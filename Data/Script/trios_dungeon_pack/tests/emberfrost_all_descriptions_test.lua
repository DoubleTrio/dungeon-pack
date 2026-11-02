-- Run from Data/Script/trios_dungeon_pack: lua tests/emberfrost_all_descriptions_test.lua
local root = arg[1] or "."
local loadEnvironment = dofile(root .. '/tests/emberfrost_test_environment.lua')
local expected = dofile(root .. '/tests/emberfrost_description_outputs.lua')
local env = loadEnvironment(root .. '/emberfrost')
local descriptions = env.require('trios_dungeon_pack.emberfrost.descriptions')
local checked, templates = 0, 0
for _, name in ipairs({'EnchantmentRegistry', 'QuestRegistry', 'AchievementRegistry'}) do
  local registry = env[name]
  for _, id in ipairs(registry:GetIDOrdered()) do
    local entry = registry:Get(id)
    if name == 'QuestRegistry' then registry:GetData(entry).bounty_target = 'bulbasaur' end
    local actual = entry:get_description()
    assert(actual == expected[name .. '.' .. id], name .. '.' .. id .. ' rendered description changed: ' .. actual)
    checked = checked + 1
    if name ~= 'AchievementRegistry' then
      assert(type(entry.description) == 'string' and rawget(entry, 'get_description') == nil, id .. ' must use shared templates')
      templates = templates + 1
      for key, binding in pairs(entry.description_vars or {}) do
        if binding.field then
          local original = entry[binding.field]
          assert(type(original) == 'number', id .. '.' .. key .. ' references a non-numeric gameplay field')
          -- Read current fields, not values captured at registration time.
          entry[binding.field] = original + 1
          local isolated = setmetatable({description = '{' .. key .. '}'}, {__index = entry})
          local rendered = descriptions.Format(isolated)
          assert(rendered:find(tostring(original + 1), 1, true), id .. '.' .. key .. ' did not update')
          entry[binding.field] = original
        end
      end
    end
  end
end
assert(checked == 121 and templates == 103)
for key in pairs(expected) do
  local registryName, id = key:match('^([^%.]+)%.(.+)$')
  assert(env[registryName]:Get(id), 'Orphan description fixture: ' .. key)
end
-- Computed text keeps engine markup intact, is resolved once per render, and refreshes next time.
local calls, current = 0, '<icon:fire>[color=Pink]100%[color]'
local dynamic = {description = '{Name} / {Name}', description_vars = {
  Name = {format = 'text', get = function() calls = calls + 1; return current end},
}}
assert(descriptions.Format(dynamic) == current .. ' / ' .. current and calls == 1)
current = '<icon:water>'
assert(descriptions.Format(dynamic) == current .. ' / ' .. current and calls == 2)
local function fails(def, text)
  local ok, err = pcall(descriptions.Format, def)
  assert(not ok and tostring(err):find(text, 1, true), 'Expected ' .. text)
end
fails({description = '{Name}', description_vars = {Name = {format = 'text', get = function() return nil end}}}, 'must resolve to text')
fails({description = '{Name}', description_vars = {Name = {format = 'text', value = 2}}}, 'must resolve to text')
fails({description = '{Name:plural:item:items}', description_vars = {Name = {format = 'text', value = 'text'}}}, 'numeric plural count')

-- Grammar follows the live count for both enchantment and quest factories.
for _, id in ipairs({'QUEST_MASTER', 'TWO_FOR_ONE'}) do
  local entry = env.EnchantmentRegistry:Get(id)
  local field = id == 'QUEST_MASTER' and 'task_amount' or 'amount'
  local old = entry[field]
  entry[field] = 1
  local noun = id == 'QUEST_MASTER' and 'quest' or 'enchantment'
  assert(entry:get_description():find('1[color] ' .. (id == 'TWO_FOR_ONE' and 'random ' or '') .. noun, 1, true))
  entry[field] = 2
  assert(entry:get_description():find(noun .. 's', 1, true))
  entry[field] = old
end
-- Bounty names come from current saved quest data, not a cached template string.
for _, entry in pairs(env.QuestRegistry._registry) do
  if entry.description_vars and entry.description_vars.Target then
    env.QuestRegistry:GetData(entry).bounty_target = 'eevee'
    assert(entry:get_description():find('<monster:eevee>', 1, true))
  end
end
print('PASS: 121 rendered outputs; all 66 enchantments and 37 quests templated; live numeric fields, computed text, markup, plural grammar, bounty state, missing-value errors')
