-- Run from Data/Script/trios_dungeon_pack: lua tests/emberfrost_rarity_test.lua
local root = arg[1] or '.'
local env = dofile(root .. '/tests/emberfrost_test_environment.lua')(root .. '/emberfrost')
local rarity = env.require('trios_dungeon_pack.emberfrost.enchantments.rarities')
local config = env.require('trios_dungeon_pack.emberfrost.config')
local offers = env.require('trios_dungeon_pack.emberfrost.enchantments.offers')
assert(rarity.Common == 'common' and rarity.Epic == 'epic' and rarity.Legendary == 'legendary')
env.RogueEssence = {GameManager = {Instance = {CurrentScene = 'dungeon'}},
  Dungeon = {DungeonScene = {Instance = 'dungeon'}}}
local original = env.EnchantmentRegistry
for _, id in ipairs(original:GetIDOrdered()) do
  local entry = original:Get(id)
  assert(entry.rarity == rarity.Common, id .. ' must start common')
  assert(type(entry.tags) == 'table' and #entry.tags == 1 and type(entry.tags[1]) == 'string', id .. ' needs one initial tag')
end
for _, registry in ipairs({env.QuestRegistry, env.TarotRegistry, env.WheelOfFortuneRegistry, env.AchievementRegistry}) do
  for _, entry in pairs(registry._registry) do
    assert(entry.rarity == nil and entry.tags == nil, 'Enchantment metadata leaked to other registries')
  end
end
local function probabilities(c,e,l)
  config.enchantment_rarity_probabilities = {[rarity.Common]=c,[rarity.Epic]=e,[rarity.Legendary]=l}
end
assert(config.enchantment_rarity_probabilities[rarity.Common] == 100)
local roll = 0
local bounds = {}
env._DATA.Save = {Rand = {Next = function(_, max)
  bounds[#bounds + 1] = max
  if max == 1000000 then return roll end
  return max - 1 -- leave each rarity pool in registration order
end}}
env.SV.EmberFrost.Enchantments.Seen = {}
assert(#original:GetRandom(100, nil, rarity.Common) == 66)
assert(#original:GetRandom(100, nil, rarity.Epic) == 0)
local initial = offers.GetRandom(6,2)
assert(#initial == 2 and #initial[1] == 3 and #initial[2] == 3)
local seen = {}
for _, row in ipairs(initial) do for _, entry in ipairs(row) do
  assert(entry.rarity == rarity.Common and not seen[entry.id]); seen[entry.id] = true
end end

local test = env.CreateRegistry({registry_table = {}, seen_table_path = 'EmberFrost.Enchantments.Seen'})
local definitions = {
  {id='C1', rarity=rarity.Common, tags={'items', 'economy'}},
  {id='C2', rarity=rarity.Common}, -- tags optional
  {id='E1', rarity=rarity.Epic},
  {id='L1', rarity=rarity.Legendary},
  {id='BLOCKED', rarity=rarity.Legendary, can_apply=function()return false end},
}
for _, def in ipairs(definitions) do test:Register(def) end
env.EnchantmentRegistry = test
assert(#test:GetRandom(10) == 4, 'Omitting rarity must preserve unfiltered selection')
local filtered = test:GetRandom(10, 2, rarity.Common)
assert(filtered[1][1].id == 'C1' and filtered[2][1].id == 'C2')
assert(#test:GetRandom(10, nil, rarity.Legendary) == 1)
assert(#test:Get('C1').tags == 2 and test:Get('C2').tags == nil)
probabilities(80,15,5)
for _, case in ipairs({{0,'C1'},{799999,'C1'},{800000,'E1'},{949999,'E1'},{950000,'L1'},{999999,'L1'}}) do
  roll = case[1]
  assert(offers.GetRandom(1)[1].id == case[2], 'Incorrect probability boundary')
end
-- Ground mode uses Lua RNG for both the pool shuffle and rarity roll.
env.RogueEssence.GameManager.Instance.CurrentScene = 'ground'
local saved_next = env._DATA.Save.Rand.Next
env._DATA.Save.Rand.Next = function() error('Ground mode used dungeon RNG') end
local ground_shuffle, ground_roll = false, false
env.math = setmetatable({random = function(max)
  if max then ground_shuffle = true; return max end
  ground_roll = true; return 0.8
end}, {__index = math})
assert(offers.GetRandom(2)[1].id == 'E1')
assert(ground_shuffle and ground_roll)
env.math = math
env._DATA.Save.Rand.Next = saved_next
env.RogueEssence.GameManager.Instance.CurrentScene = 'dungeon'
-- Empty/excluded tiers are removed from the roll; no fallback into a zero-probability tier.
test:MarkSeen('L1'); roll = 999999
assert(offers.GetRandom(1)[1].id == 'E1')
probabilities(0,0,100)
assert(#offers.GetRandom(3) == 0)
probabilities(100,0,0)
assert(#offers.GetRandom(10) == 2, 'Zero-probability tiers must remain excluded')
probabilities(80,15,5)
env.SV.EmberFrost.Enchantments.Seen = {}
local picked = offers.GetRandom(10)
assert(#picked == 4, 'All eligible entries should be available as tiers empty')
seen = {}
for _, entry in ipairs(picked) do assert(not seen[entry.id]);seen[entry.id]=true end
for _, weights in ipairs({{90,0,0},{101,-1,0},{100,0,'bad'}}) do
  probabilities(table.unpack(weights))
  assert(not pcall(function()offers.GetRandom(1)end), 'Invalid probabilities must fail clearly')
end
probabilities(100,0,0)
-- No rarity requirement introduced for non-enchantment registries.
env._DATA.Save.ActiveTeam = {Players = {Count = 1}}
env.SV.EmberFrost.LastFloor = 0
assert(#env.QuestRegistry:GetRandom(1) == 1)
assert(#env.TarotRegistry:GetRandom(1) == 1)
assert(#env.WheelOfFortuneRegistry:GetRandom(1) == 1)

-- A limited pool may leave a reroll row short: do not index a missing entry or spend a reroll.
env.Class = function() return {} end
env._GAME = {SE = function() end}
env.SOUND = {PlayBattleSE = function() end}
assert(loadfile(root .. '/menu/EnchantmentSelectionMenu.lua','t',env))()
local menu = {selectionIndex=3,rerollCountTotals={1,1,1},enchantmentList={{definitions[1],definitions[2],definitions[3]}, {definitions[4]}}}
env.EnchantmentSelectionMenu.handleReroll(menu,3)
assert(menu.rerollCountTotals[3] == 1)
print('PASS: all 66 common/single-tag defaults; multi/optional tags; exact registry rarity filtering; weighted boundaries; empty/zero tiers; no duplicates; non-enchantment isolation; partial reroll safety')
