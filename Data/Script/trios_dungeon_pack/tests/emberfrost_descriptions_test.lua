-- Run from Data/Script/trios_dungeon_pack: lua tests/emberfrost_descriptions_test.lua
-- Engine placeholders cover module initialization only; gameplay is checked explicitly below.
local root = arg[1] or "."
local proxy
proxy = setmetatable({}, { __index = function() return proxy end, __call = function() return proxy end })
local env = setmetatable({
  print = function() end,
  luanet = proxy, RogueEssence = proxy, RogueElements = proxy, PMDC = proxy,
  LUA_ENGINE = proxy,
  PMDColor = { Cyan = "cyan", Yellow = "yellow" },
  M_HELPERS = { MakeColoredText = function(text, color) return "[color=" .. color .. "]" .. text .. "[color]" end },
  _DATA = { GetZone = function() return { GetColoredName = function() return "Emberfrost" end } end },
  AchievementStatus = { Hidden = 0, Visible = 1, Achieved = 2 },
  EnchantmentStatus = { NotSeen = 0, Seen = 1, Selected = 2, SelectedAndWon = 3 },
}, { __index = _G })
local loaded = {}
env.require = function(name)
  if loaded[name] then return loaded[name] end
  local path = name:match("^trios_dungeon_pack%.(emberfrost%..+)$")
  if not path then return true end
  local result = assert(loadfile(root .. "/" .. path:gsub("%.", "/") .. ".lua", "t", env))() or true
  loaded[name] = result
  return result
end
local function equal(actual, expected)
  assert(actual == expected, "Expected " .. tostring(expected) .. ", got " .. tostring(actual))
end
local function fails(fn, message)
  local ok, err = pcall(fn)
  assert(not ok and tostring(err):find(message, 1, true), "Expected error containing: " .. message)
end
local descriptions = env.require('trios_dungeon_pack.emberfrost.descriptions')
local function number(value) return "[color=cyan]" .. value .. "[color]" end
local def = { id = "TEST", count = 1, description = "{Count} {Count:plural:enemy:enemies}",
  description_vars = { Count = { field = "count", format = "number" } } }
equal(descriptions.Format(def), number(1) .. " enemy")
for _, count in ipairs({ 0, 2, 12 }) do
  def.count = count
  equal(descriptions.Format(def), number(count) .. " enemies")
end
equal(descriptions.Number(2.5), number(2.5))
equal(descriptions.Number(-1), number(-1))
equal(descriptions.Number(3, "yellow"), "[color=yellow]3[color]")
equal(descriptions.Format({}), "")
equal(descriptions.Format({ description = "100% unchanged" }), "100% unchanged")
fails(function() descriptions.Format({ id = "MISSING", description = "{Amount}" }) end, "MISSING: Amount has no field binding")
def.count = nil
fails(function() descriptions.Format(def) end, "must reference a numeric field")
def.count = "2"
fails(function() descriptions.Format(def) end, "must reference a numeric field")
def.count = 2
def.description_vars.Count.format = "unknown"
fails(function() descriptions.Format(def) end, "unsupported format")

for _, name in ipairs({ 'enchantments.enchants', 'enchantments.type_enchantments', 'enchantments.character_enchantments', 'achievements' }) do
  env.require('trios_dungeon_pack.emberfrost.' .. name)
end
equal(env.EnchantmentRegistry._count, 66)
equal(env.AchievementRegistry._count, 18)
equal(env.TarotRegistry._count, 22)
equal(env.WheelOfFortuneRegistry._count, 3)
equal(env.QuestRegistry._count, 37)
equal(env.ExpandedSatchel:get_description(), "Increase the bag size by " .. number(8) .. " for the duration of the dungeon")
env.ExpandedSatchel.bag_increase = 11
equal(env.ExpandedSatchel:get_description(), "Increase the bag size by " .. number(11) .. " for the duration of the dungeon")
env.ExpandedSatchel.bag_increase = 8
equal(env.Tempo:get_description(), "For every " .. number(1) .. " enemy defeated, your team gains a random stat boost")
env.Tempo.count = 3
equal(env.Tempo:get_description(), "For every " .. number(3) .. " enemies defeated, your team gains a random stat boost")
env.Tempo.count = 1
local legacy = env.CreateRegistry({ registry_table = {}, defaults = env.PowerupDefaults }):Register({
  id = "LEGACY", description = "{Unbound}", get_description = function() return "Custom wins" end,
})
equal(legacy:get_description(), "Custom wins")
legacy = env.CreateRegistry({ registry_table = {}, defaults = env.AchievementDefaults }):Register({
  id = "LEGACY_ACHIEVEMENT", get_description = function() return "Old achievement" end,
})
equal(legacy:get_description(), "Old achievement")

local keyword = env.require('trios_dungeon_pack.emberfrost.keywords')
local original = env.ExpandedSatchel:get_description()
local detail = keyword.GetDescription(env.ExpandedSatchel)
assert(detail:find(original, 1, true))
assert(detail:find("Bag size[color]: Maximum number of items the bag can hold.", 1, true))
equal(keyword.GetDescription(legacy), "Old achievement")
local repeatKeyword = { keywords = { "BAG_SIZE", "BAG_SIZE" }, get_description = function() return "Test" end }
local _, count = keyword.GetDescription(repeatKeyword):gsub("Bag size", "")
equal(count, 1)
fails(function() keyword.GetDescription({ keywords = { "UNKNOWN" }, get_description = function() return "" end }) end, "Unknown enchantment keyword")

-- Descriptions read the same thresholds as the score listeners, which still use money.
local observers = {}
env.beholder = {
  observe = function(event, callback) observers[#observers + 1] = callback; return #observers end,
  stopObserving = function() end,
}
env.SV = { EmberFrost = {
  Achievements = { ToDisplay = {}, Statuses = {} },
  Enchantments = { Data = {} },
} }
env._DATA.Save = { ActiveTeam = { Money = 0 }, GetTotalScore = function() error("These achievements must use money") end }
for _, spec in ipairs({ { "50K_ROCKY", 50000 }, { "SIX FIGURES", 100000 }, { "HIGH_ROLLER", 500000 }, { "IMPOSSIBLE", 1000000 } }) do
  local achievement = env.AchievementRegistry:Get(spec[1])
  equal(achievement.amount, spec[2])
  equal(achievement:get_description(), "Clear Emberfrost with a score of " .. number(spec[2]))
  achievement:apply()
  env._DATA.Save.ActiveTeam.Money = spec[2] - 1
  local before = #env.SV.EmberFrost.Achievements.ToDisplay
  observers[#observers]()
  equal(#env.SV.EmberFrost.Achievements.ToDisplay, before)
  env._DATA.Save.ActiveTeam.Money = spec[2]
  observers[#observers]()
  equal(env.SV.EmberFrost.Achievements.ToDisplay[before + 1], spec[1])
  equal(env.SV.EmberFrost.Achievements.Statuses[spec[1]], env.AchievementStatus.Achieved)
end
equal(env.Tempo:get_progress_texts()[1], "Enemies Defeated: " .. number(0) .. "/" .. number(1))
env.EnchantmentRegistry:GetData(env.Tempo).defeated_enemies = 2
equal(env.Tempo:get_progress_texts()[1], "Enemies Defeated: " .. number(2) .. "/" .. number(1))
print("PASS: formatter errors/numbers/plurals, field binding, legacy overrides, keywords, pilot descriptions, score thresholds/semantics, progress text, registry counts")
