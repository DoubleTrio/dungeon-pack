-- Run from Data/Script/trios_dungeon_pack: lua tests/emberfrost_achievements_test.lua
local root = arg[1] or '.'
local env = dofile(root .. '/tests/emberfrost_test_environment.lua')(root .. '/emberfrost')
-- Use the actual event bus, including its non-nestable grouping and callback removal.
env.beholder = assert(loadfile(root .. '/beholder.lua', 't', env))()
local bus = env.beholder
local runtime = env.require('trios_dungeon_pack.emberfrost.achievements.runtime')
assert(loadfile(root .. '/scriptvars.lua', 't', env))()
env._DATA.Save = { ActiveTeam = {Money = 1000000, Players = {Count = 1}, Assembly = {Count = 0}},
  GetTotalScore = function() error('Score achievements must continue to use money') end }
env.luanet = {each = function() return function() return nil end end}
env.GAME = {InRogueMode = function() return true end}
env.CountAssemblyWithKey = function() return 0 end
env.Contains = function(list, value) for _, item in ipairs(list) do if item == value then return true end end return false end
local achieved = env.AchievementStatus.Achieved
local function equal(actual, expected, message)
  assert(actual == expected, (message or 'Mismatch') .. ': expected ' .. tostring(expected) .. ', got ' .. tostring(actual))
end
local function onlyPending(id)
  env.StopAchievementListeners()
  env.SV.EmberFrost.Achievements.ToDisplay = {}
  for key in pairs(env.AchievementRegistry._registry) do env.SV.EmberFrost.Achievements.Statuses[key] = achieved end
  if id then env.SV.EmberFrost.Achievements.Statuses[id] = env.AchievementStatus.Visible end
end
local function allCollection(status)
  env.SV.EmberFrost.Enchantments.Collection = {}
  for id in pairs(env.EnchantmentRegistry._registry) do env.SV.EmberFrost.Enchantments.Collection[id] = status end
end
local firstId = env.EnchantmentRegistry:GetIDOrdered()[1]
allCollection(env.EnchantmentStatus.SelectedAndWon)
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.Seen), true)
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.SelectedAndWon), true)
env.SV.EmberFrost.Enchantments.Collection[firstId] = env.EnchantmentStatus.Seen
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.Seen), true)
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.SelectedAndWon), false)
env.SV.EmberFrost.Enchantments.Collection[firstId] = nil
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.Seen), false)
env.SV.EmberFrost.Enchantments.Collection[firstId] = 0
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.Seen), false)
-- Unregistered save entries must not affect completion.
allCollection(env.EnchantmentStatus.SelectedAndWon)
env.SV.EmberFrost.Enchantments.Collection.OLD_REMOVED_ENCHANT = 0
equal(runtime.AllEnchantsEqualOrGreater(env.EnchantmentStatus.SelectedAndWon), true)

for _, spec in ipairs({{'ENCYCLOPEDIA', 'OnEnchantmentSeen', env.EnchantmentStatus.Seen},
                       {'ARCANIST', 'OnEmberfrostClear', env.EnchantmentStatus.SelectedAndWon}}) do
  onlyPending(spec[1]); allCollection(spec[3])
  env.SV.EmberFrost.Enchantments.Collection[firstId] = spec[3] - 1
  env.InitializeAchievementListeners()
  equal(bus.trigger(spec[2]), 1)
  equal(#env.SV.EmberFrost.Achievements.ToDisplay, 0, 'Partial collection must not award')
  env.SV.EmberFrost.Enchantments.Collection[firstId] = spec[3]
  equal(bus.trigger(spec[2]), 1)
  equal(env.SV.EmberFrost.Achievements.ToDisplay[1], spec[1])
  equal(bus.trigger(spec[2]), false, 'Awarded listener must remove itself')
end

-- Test each real achievement installer, including both CHAOS listeners and ungrouped score pilots.
local events = {ENCYCLOPEDIA = {'OnEnchantmentSeen'}, SIDE_QUESTER = {'OnQuestComplete'},
  FULL_SPECTRUM = {'OnTypeMasterComplete'}, MARKET_CRASH = {'TheBubbleLost', 25000},
  STONKS = {'TheBubbleGained', 5000}, NOT_TODAY = {'OnNotToday'}}
for _, id in ipairs(env.AchievementRegistry:GetIDOrdered()) do
  onlyPending(id); allCollection(env.EnchantmentStatus.SelectedAndWon)
  env.SV.EmberFrost.Enchantments.Selected = id == 'PURIST' and {} or {env.PandorasItems.id}
  env.EnchantmentRegistry:GetData(env.QuestMaster).money_earned = 13800
  env.InitializeAchievementListeners()
  env.InitializeAchievementListeners()
  if id == 'CHAOS' then equal(bus.trigger('OnEnchantmentSelected', env.PandorasItems.id), 1) end
  local event = events[id] or {'OnEmberfrostClear'}
  equal(bus.trigger(table.unpack(event)), 1, id .. ' must have exactly one callback after repeated init')
  if id ~= 'EFFIECIENCY' then
    equal(#env.SV.EmberFrost.Achievements.ToDisplay, 1, id .. ' must award once')
    equal(env.SV.EmberFrost.Achievements.ToDisplay[1], id)
    env.InitializeAchievementListeners()
    equal(bus.trigger(table.unpack(event)), false, id .. ' earned entry must be skipped')
  else
    equal(#env.SV.EmberFrost.Achievements.ToDisplay, 0, 'Preserve disabled Efficiency award')
  end
  env.StopAchievementListeners()
  equal(bus.trigger(table.unpack(event)), false, id .. ' must stop')
end

-- Stopping achievement listeners must not touch enchantments, even on the same event.
onlyPending('FIRST_TRY')
local unrelated = 0
bus.group(env.EMBERFROST_BEHOLDER_GROUPS, function()
  bus.observe('OnEmberfrostClear', function() unrelated = unrelated + 1 end)
end)
env.InitializeAchievementListeners(); env.StopAchievementListeners(); env.StopAchievementListeners()
equal(bus.trigger('OnEmberfrostClear'), 1)
equal(unrelated, 1)
equal(#env.SV.EmberFrost.Achievements.ToDisplay, 0)
-- A floor rebuild clears the enchantment group, but must leave achievements alive.
env.InitializeAchievementListeners()
bus.stopObserving(env.EMBERFROST_BEHOLDER_GROUPS)
equal(bus.trigger('OnEmberfrostClear'), 1)
equal(unrelated, 1)
equal(env.SV.EmberFrost.Achievements.ToDisplay[1], 'FIRST_TRY')

-- Failed initialization rolls back partial listeners and releases beholder's current group.
onlyPending('FIRST_TRY')
local originalApply = env.AchievementRegistry:Get('FIRST_TRY').apply
env.AchievementRegistry:Get('FIRST_TRY').apply = function()
  bus.observe('PartialSetup', function() error('Partial callback leaked') end)
  error('Intentional setup failure')
end
local ok, err = pcall(env.InitializeAchievementListeners)
assert(not ok and tostring(err):find('Intentional setup failure', 1, true))
equal(bus.trigger('PartialSetup'), false)
bus.group(env.EMBERFROST_BEHOLDER_GROUPS, function() bus.observe('Unaffected', function() end) end)
equal(bus.trigger('Unaffected'), 1)
env.AchievementRegistry:Get('FIRST_TRY').apply = originalApply
env.InitializeAchievementListeners()
equal(bus.trigger('OnEmberfrostClear'), 1)

-- Exercise actual zone entry/exit and reset functions with engine transitions stubbed.
env.DEBUG = {EnableDbgCoro = function() end}
env.PrintInfo = function() end
env.COMMON = {ExitDungeonMissionCheck = function() return false end, EndDungeonDay = function(result)
  if result == 'clear' then
    equal(env.SV.EmberFrost.Achievements.ToDisplay[1], 'FIRST_TRY', 'Award must precede zone transition')
  end
  -- A transition may load a different save and stop the old listeners.
  env.StopAchievementListeners()
end}
env.RogueEssence = {Data = {GameProgress = {ResultType = {Cleared = 'clear'}}}}
local zone = assert(loadfile(root .. '/zone/emberfrost_depths/init.lua', 't', env))()
onlyPending('FIRST_TRY'); env.SV.EmberFrost.Enchantments.Selected = {}
zone.EnterSegment({}, false, 1, 0)
zone.EnterSegment({}, false, 2, 0)
zone.ExitSegment({ID = 'emberfrost_depths'}, 'clear', false, 2, 0)
equal(#env.SV.EmberFrost.Achievements.ToDisplay, 1, 'Award must fire before reset')
equal(env.SV.EmberFrost.Achievements.ToDisplay[1], 'FIRST_TRY')
equal(bus.trigger('OnEmberfrostClear'), false, 'Run reset must remove all remaining achievement callbacks')
onlyPending('FIRST_TRY'); zone.EnterSegment({}, false, 1, 0)
zone.ExitSegment({ID = 'emberfrost_depths'}, 'failed', false, 1, 0)
equal(#env.SV.EmberFrost.Achievements.ToDisplay, 0)
equal(bus.trigger('OnEmberfrostClear'), false)

-- Exercise the actual save-load service, including switching away from the dungeon.
env.Class = function()
  local class = {}; class.__index = class
  function class:new() return setmetatable({}, class) end
  return class
end
env.SCRIPT = {AddService = function() end}
env._ZONE = {CurrentZoneID = 'emberfrost_depths'}
local service = assert(loadfile(root .. '/services/enchant_tools/init.lua', 't', env))()
onlyPending('FIRST_TRY')
service.OnSaveLoad({}); service.OnSaveLoad({})
equal(bus.trigger('OnEmberfrostClear'), 1, 'Repeated save load must not duplicate listeners')
onlyPending('FIRST_TRY'); service.OnSaveLoad({})
env._ZONE.CurrentZoneID = 'guildmaster_island'
service.OnSaveLoad({})
equal(bus.trigger('OnEmberfrostClear'), false, 'Loading outside Ember Frost must clear stale callbacks')
print('PASS: real-beholder collection thresholds, all 18 achievement installers, repeat init/stop, earned skips, ownership, failure rollback, floor rebuild, actual zone clear/failure reset, save-load lifecycle')
