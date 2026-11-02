-- Unfortunately, I'm not sure why passing a reference to the SV table doesn't work. This is a workaround for now
local function resolve_path(root, path)
  if type(root) ~= "table" then
    print("[resolve_path error] root is not a table:", tostring(root))
    return {}
  end

  if type(path) ~= "string" then
    print("[resolve_path error] path is not a string:", tostring(path))
    return {}
  end

  local current = root
  local walked = {}

  for key in string.gmatch(path, "[^%.]+") do
    table.insert(walked, key)

    if type(current) ~= "table" then
      print(string.format("[resolve_path error] '%s' is not a table (got %s)", table.concat(walked, "."),
        type(current)))
      return nil
    end

    if current[key] == nil then
      print(string.format("[resolve_path error] missing key '%s' at '%s'", key, table.concat(walked, ".")))
      return nil
    end

    current = current[key]
  end

  return current
end

function CreateRegistry(config)
  local Registry = {}
  local order = {}

  Registry._registry = config.registry_table
  Registry.data_table_path = config.data_table_path
  Registry.selected_table_path = config.selected_table_path
  Registry.seen_table_path = config.seen_table_path

  -- Registry._seen = config.seen_table
  -- Registry._default_selected = config.selected_table
  Registry.defaults = config.defaults
  Registry.can_apply_key = config.can_apply_key or "can_apply"
  Registry.debug = config.debug
  Registry._count = 0

  function Registry:Register(def)
    assert(def.id, "Registry entry must have an id")
    assert(self._registry[def.id] == nil, "Duplicate registry entry: " .. tostring(def.id))

    local entry = self.defaults and setmetatable(def, {
      __index = self.defaults
    }) or def

    self._registry[def.id] = entry
    table.insert(order, def.id)

    self._count = self._count + 1
    if self.debug then
      print("[Registry] Registered:", def.id)
    end

    return entry
  end

  function Registry:Get(id)
    return self._registry[id]
  end


  function Registry:GetIDOrdered()
    return order
  end

  function Registry:Select(id)
    local select_table = resolve_path(SV, self.selected_table_path) or {}
    return select_table.insert(id)
  end

  function Registry:RemoveSelection(index)
    local select_table = resolve_path(SV, self.selected_table_path) or {}
    select_table.remove(index)
  end

  function Registry:GetSelected(selected)
    local list = {}
    local select_table = selected or resolve_path(SV, self.selected_table_path)

    for _, id in ipairs(select_table) do
      local entry = self._registry[id]
      if entry then
        table.insert(list, entry)
      end
    end
    return list
  end

  function Registry:GetData(entry)
    local table = resolve_path(SV, self.data_table_path) or {}
    -- I'm not sure why this doesn't work...
    -- local table = self._data_tab
    -- self._data_tab = SV.EmberFrost.Enchantments.Data
    local id

    if type(entry) == "string" then
      id = entry
    elseif type(entry) == "table" and entry.id then
      id = entry.id
    else
      error("Registry:GetData: entry must be string or table with id")
    end

    table[id] = table[id] or {}

    return table[id]
  end

  function Registry:MarkSeen(id)
    assert(self._registry[id], "Unknown registry entry: " .. tostring(id))
    assert(self.seen_table_path, "Registry has no seen table configured")
    local seen_table = resolve_path(SV, self.seen_table_path)
    assert(type(seen_table) == "table", "Registry seen table is missing: " .. self.seen_table_path)
    for _, seen_id in ipairs(seen_table) do
      if seen_id == id then return end
    end
    table.insert(seen_table, id)
  end

  function Registry:GetRandom(amount, total_groups, rarity)
    -- Keep the saved ID array; build a lookup only for this selection.
    local seen_ids = self.seen_table_path and resolve_path(SV, self.seen_table_path) or {}
    local seen_table = {}
    for _, id in ipairs(seen_ids or {}) do
      seen_table[id] = true
    end

    local candidates = {}
    for _, id in ipairs(order) do
      local entry = self._registry[id]
      local seen = seen_table[id]
      local can_apply = entry[self.can_apply_key]
      if not seen and (rarity == nil or entry.rarity == rarity) and (not can_apply or can_apply(entry)) then
        table.insert(candidates, entry)
      end
    end

    for i = #candidates, 2, -1 do
      local j
      if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
        j = _DATA.Save.Rand:Next(i) + 1
      else
        j = math.random(i)
      end
      candidates[i], candidates[j] = candidates[j], candidates[i]
    end

    local picked = {}
    for i = 1, math.min(amount, #candidates) do
      local entry = candidates[i]
      table.insert(picked, entry)
    end

    if not total_groups then
      return picked
    end

    local grouped = {}
    for i = 1, total_groups do
      grouped[i] = {}
    end

    for i, entry in ipairs(picked) do
      table.insert(grouped[((i - 1) % total_groups) + 1], entry)
    end

    return grouped
  end

  return Registry
end



local registry = {}

function registry.add(target, group)
  group(function(def)
    return target:Register(def)
  end)
end

return registry
