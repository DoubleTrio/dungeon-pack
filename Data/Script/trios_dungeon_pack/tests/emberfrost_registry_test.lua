-- Run from Data/Script/trios_dungeon_pack: lua tests/emberfrost_registry_test.lua
local root = arg[1] or '.'
local env = {assert = assert, type = type, tostring = tostring, table = table, string = string,
  ipairs = ipairs, pairs = pairs, math = math, setmetatable = setmetatable, print = function() end,
  SV = {Run = {Seen = {}}}, _DATA = {Save = {Rand = {Next = function(_, max) return max - 1 end}}}}
env.RogueEssence = {GameManager = {Instance = {CurrentScene = 'dungeon'}},
  Dungeon = {DungeonScene = {Instance = 'dungeon'}}}
assert(loadfile(root .. '/emberfrost/registry.lua', 't', env))()
local registry = env.CreateRegistry({registry_table = {}, defaults = {label = 'default'}, seen_table_path = 'Run.Seen'})
local first = registry:Register({id = 'FIRST', amount = 8})
registry:Register({id = 'SECOND'})
registry:Register({id = 'BLOCKED', can_apply = function() return false end})
local duplicate = {id = 'FIRST', amount = 99}
local ok, err = pcall(function() registry:Register(duplicate) end)
assert(not ok and tostring(err):find('Duplicate registry entry: FIRST', 1, true))
assert(registry:Get('FIRST') == first and first.amount == 8)
assert(registry._count == 3 and #registry:GetIDOrdered() == 3)
assert(registry:GetIDOrdered()[1] == 'FIRST' and registry:GetIDOrdered()[2] == 'SECOND')
assert(getmetatable(duplicate) == nil)

-- Existing saves already contain arrays, possibly with repeated IDs.
env.SV.Run.Seen = {'FIRST', 'FIRST', 'REMOVED_ENTRY'}
local picked = registry:GetRandom(10)
assert(#picked == 1 and picked[1].id == 'SECOND')
registry:MarkSeen('FIRST')
assert(#env.SV.Run.Seen == 3)
registry:MarkSeen('SECOND'); registry:MarkSeen('SECOND')
assert(#env.SV.Run.Seen == 4 and env.SV.Run.Seen[4] == 'SECOND')
assert(#registry:GetRandom(10) == 0)
local grouped = registry:GetRandom(6, 2)
assert(#grouped == 2 and #grouped[1] == 0 and #grouped[2] == 0)

-- Reset/load replaces the save table; registry must use the current one.
env.SV = {Run = {Seen = {}}}
picked = registry:GetRandom(10)
assert(#picked == 2)
registry:MarkSeen('FIRST')
assert(env.SV.Run.Seen[1] == 'FIRST')
assert(#registry:GetRandom(10) == 1)
local count = #env.SV.Run.Seen
assert(not pcall(function() registry:MarkSeen('UNKNOWN') end))
assert(#env.SV.Run.Seen == count)
env.SV.Run.Seen = nil
assert(not pcall(function() registry:MarkSeen('FIRST') end))

-- Tarot/wheel-style registries have no seen tracking and remain selectable.
local untracked = env.CreateRegistry({registry_table = {}})
untracked:Register({id = 'CARD'})
assert(untracked:GetRandom(1)[1].id == 'CARD')
assert(untracked:GetRandom(1)[1].id == 'CARD')
assert(not pcall(function() untracked:MarkSeen('CARD') end))
-- Force opposite hash traversal orders; identical random draws must give identical offers.
local stable = env.CreateRegistry({registry_table = {}, seen_table_path = 'Run.Seen'})
for _, id in ipairs({'A', 'B', 'C', 'D', 'E', 'F'}) do
  stable:Register({id = id, can_apply = function(self) return self.id ~= 'B' end})
end
env.SV.Run.Seen = {'E'}
local function draw(reverse)
  env.pairs = function(t)
    if t ~= stable._registry then return pairs(t) end
    local keys = {'A', 'B', 'C', 'D', 'E', 'F'}
    local index = reverse and #keys + 1 or 0
    return function()
      index = index + (reverse and -1 or 1)
      local id = keys[index]
      if id then return id, t[id] end
    end
  end
  local calls = {}
  env._DATA.Save.Rand.Next = function(_, max)
    calls[#calls + 1] = max
    return 0
  end
  local groups = stable:GetRandom(4, 2)
  assert(table.concat(calls, ',') == '4,3,2', 'Shuffle draw count/bounds changed')
  assert(#groups == 2 and #groups[1] == 2 and #groups[2] == 2)
  return groups[1][1].id .. groups[1][2].id .. groups[2][1].id .. groups[2][2].id
end
-- Eligible registration order A,C,D,F shuffles to C,D,F,A, grouped as C,F / D,A.
assert(draw(false) == 'CFDA')
assert(draw(true) == 'CFDA')
env.pairs = pairs
assert(table.concat(stable:GetIDOrdered(), ',') == 'A,B,C,D,E,F', 'Selection mutated registration order')
print('PASS: duplicate rejection; saved seen arrays; reset/load; eligibility; empty/untracked pools; deterministic selection and grouping independent of hash traversal')
