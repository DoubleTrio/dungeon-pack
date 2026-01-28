require 'origin.menu.team.TeamSelectMenu'
require 'trios_dungeon_pack.menu.ItemSelectionMenu'
require 'trios_dungeon_pack.beholder'

OrbStateType = luanet.import_type('PMDC.Dungeon.OrbState')
BerryStateType = luanet.import_type('PMDC.Dungeon.BerryState')
EdibleStateType = luanet.import_type('PMDC.Dungeon.EdibleState')
GummiStateType = luanet.import_type('PMDC.Dungeon.GummiState')
DrinkStateType = luanet.import_type('PMDC.Dungeon.DrinkState')
WandStateType = luanet.import_type('PMDC.Dungeon.WandState')

AmmoStateType = luanet.import_type('PMDC.Dungeon.AmmoState')
UtilityStateType = luanet.import_type('PMDC.Dungeon.UtilityState')
HeldStateType = luanet.import_type('PMDC.Dungeon.HeldState')
EquipStateType = luanet.import_type('PMDC.Dungeon.EquipState')
EvoStateType = luanet.import_type('PMDC.Dungeon.EvoState')
SeedStateType = luanet.import_type('PMDC.Dungeon.SeedState')

MachineStateType = luanet.import_type('PMDC.Dungeon.MachineState')
RecruitStateType = luanet.import_type('PMDC.Dungeon.RecruitState')
CurerStateType = luanet.import_type('PMDC.Dungeon.CurerState')
FoodStateType = luanet.import_type('PMDC.Dungeon.FoodState')
HerbStateType = luanet.import_type('PMDC.Dungeon.HerbState')
UnrecruitableType = luanet.import_type('PMDC.LevelGen.MobSpawnUnrecruitable')

RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')

local function get_item_from_context(context)
  local index = context.UsageSlot
  local item
  if index >= -1 then
    item = _DATA.Save.ActiveTeam:GetInv(index).ID
  elseif index == -1 then
    item = context.User.EquippedItem.ID
  elseif index == -2 then
    local map_slot = _ZONE.CurrentMap:GetItem(context.User.CharLoc)
    item = _ZONE.CurrentMap.Items[map_slot].Value
  end

  return item
end

local function item_id_contains_state(item_id, state_type)
  local item_data = _DATA:GetItem(item_id)
  local contains = item_data.ItemStates:Contains(luanet.ctype(state_type))
  return contains
end


function GetFloorSpawns(config)
  local possible = {}
  local seen_species = {}
  local map = _ZONE.CurrentMap
  local spawns = map.TeamSpawns

  local required_features = config and config.has_features or nil
  local excluded_features = config and config.not_has_features or nil

  -- get the spawn list
  for i = 0, spawns.Count - 1, 1 do
    local spawnList = spawns:GetSpawn(i):GetPossibleSpawns()
    for j = 0, spawnList.Count - 1, 1 do
      local spawn = spawnList:GetSpawn(j)
      local features = spawn.SpawnFeatures

      -- Check if spawn has all required features
      local has_all_features = true
      if required_features then
        for _, required_feature in ipairs(required_features) do
          local has_feature = false
          for f = 0, features.Count - 1, 1 do
            if LUA_ENGINE:TypeOf(features[f]) == luanet.ctype(required_feature) then
              has_feature = true
              break
            end
          end
          if not has_feature then
            has_all_features = false
            break
          end
        end
      end

      -- Check if spawn has any excluded features
      local has_excluded_feature = false
      if excluded_features then
        for _, excluded_feature in ipairs(excluded_features) do
          for f = 0, features.Count - 1, 1 do
            if LUA_ENGINE:TypeOf(features[f]) == luanet.ctype(excluded_feature) then
              has_excluded_feature = true
              break
            end
          end
          if has_excluded_feature then
            break
          end
        end
      end

      if spawn:CanSpawn() and has_all_features and not has_excluded_feature then
        local species = spawn.BaseForm.Species
        if not seen_species[species] then
          seen_species[species] = true
          table.insert(possible, species)
        end
      end
    end
  end

  return possible
end

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

QuestDefaults = {

  can_apply = function()
    return true
  end,

  complete_quest = function(self)
    local data = QuestRegistry:GetData(self)

    local enchantment_data = EnchantmentRegistry:GetData(QuestMaster)

    if not data["completed"] then
      data["completed"] = true
      _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.reward
      enchantment_data["money_earned"] = enchantment_data["money_earned"] + self.reward
      if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
        SOUND:PlayFanfare("Fanfare/Note")
        UI:WaitShowDialogue(string.format("Completed Quest! %s (%s)", self:getDescription(),
          M_HELPERS.MakeColoredText(tostring(self.reward), PMDColor.Cyan) .. " " .. PMDSpecialCharacters.Money))
      end
    end
  end,
  -- Called at the beginning of each floor
  cleanup = function(self)

  end,

  set_active_effects = function(self, active_effect, zone_context)
    print(self.name .. " set quest map effect.")
    -- print(self.name .. " activated.")
  end,

  getDescription = function(self)
    return ""
  end,

  getProgressTexts = function(self)
    return {}
  end
}

PowerupDefaults = {
  -- Checks whether this powerup can be given to the player
  can_apply = function()
    return true
  end,

  -- Called upon immediately selecting the powerup
  apply = function(self)
    print(self.name .. " activated.")
  end,

  -- At the start of each floor, call this
  set_active_effects = function(self, active_effect, zone_context)
    print(self.name .. " set map effect.")
    -- print(self.name .. " activated.")
  end,

  -- Revert anything applied by the powerup at the end of the run
  revert = function(self)
    print(self.name .. " reverted.")
  end,

  -- Used for when progressing to Emberfrost Depths
  progress = function(self)
    print(self.name .. " progressed.")
  end,

  -- Used for getting more info about the progress through a submenu (ex. character selected, the amount of money made, the stat boosts)
  getProgressTexts = function(self)
    -- return nil
    return {}
  end,

  -- When the end of the dungeon is reached, provide the player rewards
  reward = function(self)
    print(self.name .. " progressed.")
  end,

  -- Called upon when going back into a save file and setting variables in Lua that cannot be saved
  restore = function(self)
    print(self.name .. " restore.")
  end,

  getDescription = function(self)
    return ""
  end,

  -- On checkpoint reached
  on_checkpoint = function(self)
    print(self.name .. " checkpoint.")
  end
}

function CreateRegistry(config)
  local Registry = {}

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

    local entry = self.defaults and setmetatable(def, {
      __index = self.defaults
    }) or def

    self._registry[def.id] = entry

    self._count = self._count + 1
    if self.debug then
      print("[Registry] Registered:", def.id)
    end

    return entry
  end

  function Registry:Get(id)
    return self._registry[id]
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

  function Registry:GetRandom(amount, total_groups)
    local seen_table = resolve_path(SV, self.seen_table_path) or {}
    print(Serpent.dump(seen_table) .. ".... uh seen")

    local candidates = {}
    for id, entry in pairs(self._registry) do
      local seen = seen_table[id]
      local can_apply = entry[self.can_apply_key]
      if not seen and (not can_apply or can_apply(entry)) then
        table.insert(candidates, entry)
      end
    end

    -- Fisher-Yates shuffle (fixed for 1-indexed Lua arrays)
    for i = #candidates, 2, -1 do
      local j = _DATA.Save.Rand:Next(i) + 1       -- Add 1 to convert 0-indexed to 1-indexed
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

EnchantmentRegistry = CreateRegistry({
  registry_table = {},
  seen_table_path = "EmberFrost.Enchantments.Seen",
  data_table_path = "EmberFrost.Enchantments.Data",
  selected_table_path = "EmberFrost.Enchantments.Selected",
  defaults = PowerupDefaults,
  selection_field = "Enchantments",
  debug = true
})

QuestRegistry = CreateRegistry({
  registry_table = {},
  data_table_path = "EmberFrost.Quests.Data",
  selected_table_path = "EmberFrost.Quests.Active",
  defaults = QuestDefaults,
  selection_field = "Quests",
  debug = true
})

-- "AfterActions": [
-- {
-- "Key": {
-- "str": [
-- 0
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.KnockOutNeededEvent, PMDC",
-- "BaseEvents": [
-- {
-- "$type": "PMDC.Dungeon.OnMoveUseEvent, PMDC",
-- "BaseEvents": [
-- {
-- "$type": "PMDC.Dungeon.OnHitAnyEvent, PMDC",
-- "BaseEvents": [
-- {
-- "$type": "PMDC.Dungeon.StatusStackBattleEvent, PMDC",
-- "Stack": 1,
-- "StatusID": "mod_attack",
-- "AffectTarget": false,
-- "SelfInflicted": true,
-- "SilentCheck": true,
-- "Anonymous": false,
-- "TriggerMsg": {
-- "Key": "MSG_MOXIE"
-- },
-- "Anims": []
-- }
-- ],
-- "RequireDamage": true,
-- "Chance": 50
-- }
-- ]
-- }
-- ]
-- }
-- }
-- ],
-- TaskMaster - Complete tasks to gain money. The task will be rerolled upon arrival new floor. Gain cashout rewards?
-- Have all your team be less than 50% HP
-- Have all your team be below 50 hunger
-- Have 1 member be above 100 hunger
-- Have all your team be above 50 hunger
-- All moves reach less than 5 pp on 1 mon
-- Be inflicted with a bad status condition
-- Throw projectiles and hit enemies 5 times
-- Pick up X gold
-- Defeat 1 enemies with projectiles
-- Defeat 1 enemies with wands


-- -- Extracts and sorts the list of all mons that are spawned at the start of the current floor
-- -- Non-respawning mons will have an asterisk at the start of their name
-- -- returns a table containing the following properties:
-- -- {table{string} keys, table{string -> boolean} entries}
-- function RECRUIT_LIST.compileInitialFloorList()
--     local list = {
--         keys = {},
--         entries = {}
--     }
--     -- abort immediately if we're not inside a dungeon
--     if RogueEssence.GameManager.Instance.CurrentScene ~= RogueEssence.Dungeon.DungeonScene.Instance then
--         return list
--     end

--     -- get the currently spawned mons
--     local teams = map.MapTeams
--     for i = 0, teams.Count-1, 1 do
--         local team = teams[i].Players
--         for j = 0, team.Count-1, 1 do
--             local member = team[j].BaseForm
--             local hide = false

--             -- do not show in recruit list if cannot recruit
--             if team[j].Unrecruitable then hide = true end

--             -- add the member and its display mode to the list
--             if not hide then
--                 local MID = RogueEssence.Dungeon.MonsterID(member.Species, member.Form, "", Gender.Unknown)
--                 if list.entries[MID.Species] == nil then
--                     list.entries[MID.Species] = {}
--                 end
--                 if list.entries[MID.Species][MID.Form] == nil then
--                     table.insert(list.keys, MID)
--                     list.entries[MID.Species][MID.Form] = true
--                 end
--             end
--         end
--     end

--     -- sort spawn list
--     table.sort(list.keys, function (a, b)
--         if a.Species == b.Species then
--             return a.Form < b.Form
--         else
--             return _DATA:GetMonster(a.Species).IndexNum < _DATA:GetMonster(b.Species).IndexNum
--         end
--     end)

--     return list
-- end

--           -- only include if conditions are met
--             function RECRUIT_LIST.colorName(form, mode, asterisk)
--     local name = _DATA:GetMonster(form.Species).Forms[form.Form].FormName:ToLocal()
--     if asterisk then name = "\u{E111}"..name end -- asterisk is for mons that are not in the spawn list but spawned at floor start
--     if mode == RECRUIT_LIST.undiscovered then name = '???' end
--     local color = RECRUIT_LIST.colorList[mode]
--     return '[color='..color..']'..name..'[color]'
-- end

local function CreateBountyQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = function(self)
      local data = QuestRegistry:GetData(self)
      local species = data["bounty_target"]
      local name = _DATA:GetMonster(species).Forms[0].FormName:ToLocal()
      local amount_text = M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " "

      return string.format("Defeat %s%s", amount_text, M_HELPERS.MakeColoredText(name, PMDColor.LimeGreen2))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["defeated_enemies"] = 0
      local on_death_id
      local on_map_start_id

      on_map_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
        local possible_spawns = GetFloorSpawns()
        local rand_spawn = possible_spawns[_DATA.Save.Rand:Next(#possible_spawns) + 1]
        local data = QuestRegistry:GetData(self)
        data["bounty_target"] = rand_spawn
      end)

      on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
        local team = context.User.MemberTeam
        if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and context.User.MemberTeam ~=
              _DUNGEON.ActiveTeam) then
          if context.User.BaseForm.Species ~= data["bounty_target"] then
            return
          end
          data["defeated_enemies"] = data["defeated_enemies"] + 1
          if data["defeated_enemies"] >= self.amount then
            data["defeated_enemies"] = self.amount
            beholder.stopObserving(on_death_id)
            beholder.stopObserving(on_map_start_id)
            self:complete_quest()
          end
        end
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local defeated_enemies = data["defeated_enemies"] or 0
      return { "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateBountyQuest({
  id = "BOUNTY",
  amount = 1,
  reward = 200
}))

QuestRegistry:Register(CreateBountyQuest({
  id = "BOUNTY_3",
  amount = 3,
  reward = 800
}))

            -- int typeMatchup = PreTypeEvent.GetDualEffectiveness(context.User, context.Target, context.Data);

QuestRegistry:Register({
  id = "DEFEAT_ENEMIES",
  amount = 15,
  reward = 300,
  getDescription = function(self)
    return string.format("Defeat %s enemies", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["defeated_enemies"] = 0

    local id
    id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
      local team = context.User.MemberTeam
      if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and context.User.MemberTeam ~=
            _DUNGEON.ActiveTeam) then
        data["defeated_enemies"] = data["defeated_enemies"] + 1
        print("Defeated enemies: " .. tostring(data["defeated_enemies"]) .. " / " .. tostring(self.amount))
        if data["defeated_enemies"] >= self.amount then
          beholder.stopObserving(id)
          data["defeated_enemies"] = self.amount
          self:complete_quest()
        end
      end

      -- TotalKnockoutsTypes = luanet.import_type('PMDC.Dungeon.TotalKnockouts')
      -- local knockouts = context:GetContextStateInt(luanet.ctype(TotalKnockoutsTypes), 0)
      -- print(tostring(knockouts) .. " is the dmg taken")
      -- print("yepppp")
      -- print(tostring(context.User))
      -- print(tostring(context.Target))
      -- print(tostring(ownerChar))
      -- print(tostring(owner))
      -- print(tostring(args))
      -- print(tostring(context.InCombat))
      -- print(tostring(context.ContextStates.Count))
      -- print(tostring(idd) .. " is the observer id")
    end)

    print("Registered OnDeath observer for " .. self.id)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local defeated_enemies = data["defeated_enemies"]
    return { "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
  end
})

local function CreateEffectivenessQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,
    
    getDescription = config.getDescription or function(self)
      local action = config.is_dealing and "Deal" or "Take"
      local effectiveness = config.super_effective and "super effective" or "not super effective"
      local plural = self.amount == 1 and "time" or "times"
      return string.format(
        "%s a %s hit %s %s",
        action,
        effectiveness,
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
        plural
      )
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local redirection = luanet.ctype(RedirectionType)
      local data = QuestRegistry:GetData(self)
      data["hits"] = 0

      local on_turn_end_id
      local on_hit_id
      on_hit_id = beholder.observe("OnHits", function(owner, ownerChar, context, args)
        -- Check if we're tracking the user (dealing) or target (taking)
        local check_team = config.is_dealing and context.User.MemberTeam or context.Target.MemberTeam
        if check_team == nil or check_team ~= _DUNGEON.ActiveTeam then
          return
        end

        if context.ContextStates:Contains(redirection) then
          return
        end
        
        if context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or
           context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
          return
        end

        if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and 
           context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
          return
        end

        local matchup = PMDC.Dungeon.PreTypeEvent.GetDualEffectiveness(context.User, context.Target, context.Data)
        matchup = matchup - PMDC.Dungeon.PreTypeEvent.NRM_2
        
        -- Invert matchup for "not super effective" quests
        if not config.super_effective then
          matchup = matchup * -1
        end

        if matchup > 0 then
          data["hits"] = data["hits"] + 1
        end
      end)

      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        print("Hits recorded: " .. tostring(data["hits"]) .. " / " .. tostring(self.amount))
        if data["hits"] >= self.amount then
          beholder.stopObserving(on_hit_id)
          beholder.stopObserving(on_turn_end_id)
          data["hits"] = self.amount
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local hits = data["hits"] or 0
      return {
        "",
        "Progress: " .. math.min(hits, self.amount) .. "/" .. tostring(self.amount) 
      }
    end
  }
end

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "TAKE_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = false,
  super_effective = true
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "TAKE_NOT_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = false,
  super_effective = false
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "DEAL_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = true,
  super_effective = true
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "DEAL_NOT_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = true,
  super_effective = false
}))






	
	-- if ownerChar.HP <= ownerChar.MaxHP / 4 then
		
	-- 	--Do not redirect attacks that were already redirected
	-- 	if (context.ContextStates:Contains(redirection)) then
	-- 		return
	-- 	end 
		
	-- 	if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) then
	-- 		return
	-- 	end
		
	-- 	--needs to be an attacking move
	-- 	if (context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical) then
	-- 		return
	-- 	end 
		
	-- 	if (_ZONE.CurrentMap:GetCharAtLoc(context.ExplosionTile) ~= ownerChar) then
	-- 		return
	-- 	end 
		
	-- 	--make sure incoming "attack" is from a foe 
	-- 	if _DUNGEON:GetMatchup(ownerChar, context.User) ~= RogueEssence.Dungeon.Alignment.Foe then 
	-- 		return
	-- 	end





QuestRegistry:Register({
  id = "FAINT",
  amount = 1,
  reward = 1000,
  getDescription = function(self)
    return string.format("Have any member faint %s time", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["fainted"] = 0

    local id
    id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
      local team = context.User.MemberTeam
      if (team ~= nil and context.User.MemberTeam == _DUNGEON.ActiveTeam) then
        data["fainted"] = data["fainted"] + 1
        print("Fainted: " .. tostring(data["fainted"]) .. " / " .. tostring(self.amount))
        if data["fainted"] >= self.amount then
          beholder.stopObserving(id)
          data["fainted"] = self.amount
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local fainted = data["fainted"]
    return { "", "Progress: " .. math.min(fainted, self.amount) .. "/" .. tostring(self.amount) }
  end
})



QuestRegistry:Register({
  id = "SUPER_FULL",
  amount = 1,
  threshold = 100,
  reward = 500,

  get_max_fullness = function(self)

    local max_fullness = 0
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      if member.Fullness > max_fullness then
        max_fullness = member.Fullness
      end
    end
    
    print("Max fullness is " .. tostring(max_fullness))
    return max_fullness
  end,
  getDescription = function(self)
    return string.format("Have %s member be above %s hunger", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan))
  end,
  

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["best_fullness"] = 0

    local id
    id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
      print("Checking fullness for quest " .. self.id)

      local max_fullness = self:get_max_fullness()
      data["best_fullness"] = math.max(data["best_fullness"], max_fullness)
      if max_fullness > self.threshold then
        beholder.stopObserving(id)
  
        GAME:WaitFrames(30)
        self:complete_quest()
      end
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)  
    local best_fullness = data["best_fullness"]
    return { "", "Max Fullness: " .. best_fullness }
  end
})

local function CreateEmptyStomachQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    threshold = config.threshold,
    reward = config.reward,
    
    can_apply = function()
      return _DATA.Save.ActiveTeam.Players.Count == config.amount
    end,
    
    get_min_fullness = function(self)
      local min_fullness = math.huge
      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        if member.Fullness < min_fullness then
          min_fullness = member.Fullness
        end
      end
      print("Min fullness is " .. tostring(min_fullness))
      return min_fullness
    end,
    
    getDescription = function(self)
      local member_text = self.amount == 1 and "member" or "members"
      return string.format(
        "Have all %s %s be below %s hunger", 
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
        member_text,
        M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan)
      )
    end,
    
    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      
      local on_map_start_id
      local on_turn_end_id
      
      on_map_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
        data["min_fullness"] = math.huge
      end)
      
      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        print("Checking fullness for quest " .. self.id)
        local min_fullness = self:get_min_fullness()
        data["min_fullness"] = math.min(data["min_fullness"], min_fullness)
        
        if min_fullness < self.threshold then
          beholder.stopObserving(on_map_start_id)
          beholder.stopObserving(on_turn_end_id)
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end,
    
    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)  
      local min_fullness = data["min_fullness"]
      if min_fullness == math.huge then
        min_fullness = 100
      end
      local status = min_fullness < self.threshold and "Completed" or "Not Completed"
      return {
        "",
        status
      }
    end
  }
end

-- Have all your team be less than 50% .HP
-- .MaxHP
-- Usage:
QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_1",
  amount = 1,
  threshold = 5,
  reward = 300
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_2",
  amount = 2,
  threshold = 20,
  reward = 500
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_3",
  amount = 3,
  threshold = 35,
  reward = 500
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_4",
  amount = 4,
  threshold = 50,
  reward = 500
}))


local function CreateLowHealthQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    health_percent = config.health_percent,
    reward = config.reward,
    
    can_apply = function()
      return _DATA.Save.ActiveTeam.Players.Count == config.amount
    end,
    
    check_all_low_health = function(self)
      local threshold = self.health_percent / 100
      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        local health_ratio = member.HP / member.MaxHP
        if health_ratio > threshold then
          return false
        end
      end
      return true
    end,
    
    getDescription = function(self)
      local member_text = self.amount == 1 and "member" or "members"
      return string.format(
        "Have all %s %s be at or below %s%% HP", 
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
        member_text,
        M_HELPERS.MakeColoredText(tostring(self.health_percent), PMDColor.Cyan)
      )
    end,
    
    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      
      local on_map_start_id
      local on_turn_end_id
      
    
      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        print("Checking HP for quest " .. self.id)
        
        if self:check_all_low_health() then
          beholder.stopObserving(on_map_start_id)
          beholder.stopObserving(on_turn_end_id)
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end,
    
    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)  
      local status = data["completed"] and "Completed" or "Not Completed"
      return { 
        "", 
        status
      }
    end
  }
end

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_1",
  amount = 1,
  health_percent = 5,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_2",
  amount = 2,
  health_percent = 20,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_3",
  amount = 3,
  health_percent = 35,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_4",
  amount = 4,
  health_percent = 50,
  reward = 500
}))

-- QuestRegistry:Register({
--   id = "STAY_ON_FLOOR",
--   amount = 1000,
--   reward = 500,
--   getDescription = function(self)
--     return string.format(
--       "Stay on floor for %s turns",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan)
--     )
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["turns"] = 0

--     local id
--     id = beholder.observe("OnMapTurnEnds",
--       function(owner, ownerChar, context, args)

--         data["turns"] = data["turns"] + 1
--         print("Turns on floor: " .. tostring(data["turns"]) .. " / " .. tostring(self.amount))
--         if data["turns"] >= self.amount then
--           beholder.stopObserving(id)
--           data["turns"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end
--     )
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local turns = data["turns"]
--     return {
--       "",
--       "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount)
--     }
--   end
-- })

-- QuestRegistry:Register({
--   id = "STAY_ON_FLOOR",
--   amount = 1000,
--   reward = 500,
--   getDescription = function(self)
--     return string.format("Stay on floor for %s turns",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["turns"] = 0

--     local id
--     id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
--       data["turns"] = data["turns"] + 1
--       if data["turns"] >= self.amount then
--         beholder.stopObserving(id)
--         data["turns"] = self.amount
--         GAME:WaitFrames(30)
--         self:complete_quest()
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local turns = data["turns"]
--     return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- })

local function CreateAvoidActionQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      return string.format(config.description_template,
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      local no_action_used = true
      data["turns"] = 0

      local on_map_turn_end_id
      local on_before_actions_id

      on_map_turn_end_id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
        if no_action_used then
          data["turns"] = data["turns"] + 1
        else
          data["turns"] = 0
        end

        if data["turns"] >= self.amount then
          beholder.stopObserving(on_map_turn_end_id)
          beholder.stopObserving(on_before_actions_id)
          data["turns"] = self.amount
          GAME:WaitFrames(30)
          self:complete_quest()
        end

        no_action_used = true
      end)

      on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
        -- Use custom check function if provided, otherwise check forbidden actions
        if config.check_forbidden then
          if config.check_forbidden(context) then
            no_action_used = false
          end
        else
          for _, forbidden_type in ipairs(config.forbidden_actions) do
            if context.ActionType == forbidden_type then
              no_action_used = false
              break
            end
          end
        end
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local turns = data["turns"]
      return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateAvoidActionQuest({
  id = "DO_NOT_USE_ITEMS",
  amount = 300,
  reward = 500,
  description_template = "Do not use or throw items for %s turns",
  forbidden_actions = { RogueEssence.Dungeon.BattleActionType.Item, RogueEssence.Dungeon.BattleActionType.Throw }
}))

QuestRegistry:Register(CreateAvoidActionQuest({
  id = "DO_NOT_USE_SKILLS",
  amount = 200,
  reward = 500,
  description_template = "Do not use any skills for %s turns",
  check_forbidden = function(context)
    return context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill and context.UsageSlot ~=
        RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  end
}))

QuestRegistry:Register({
  id = "RECRUIT",
  amount = 1,
  reward = 500,

  capped_floor = 20,

  can_apply = function(self)
    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      if SV.EmberFrost.LastFloor <= self.capped_floor then
        return false
      end


      local possible_recruits = GetFloorSpawns({
        not_has_features = { UnrecruitableType }
      })
      return #possible_recruits > 0
    end
    return true
  end,
  getDescription = function(self)
    return string.format("Recruit a new team member")
  end,

  get_total_team_members = function(self)
    return _DUNGEON.ActiveTeam.Players.Count + _DUNGEON.ActiveTeam.Assembly.Count
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)

    local on_start_id
    local on_turn_end_id

    on_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
      data["starting_team_members"] = self:get_total_team_members()
    end)

    on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
      local new_count = self:get_total_team_members()
      if new_count - data["starting_team_members"] >= self.amount then
        beholder.stopObserving(on_start_id)
        beholder.stopObserving(on_turn_end_id)
        self:complete_quest()
      end
    end)
  end,

  getProgressTexts = function(self)
    local total_team_members = self:get_total_team_members()
    local data = QuestRegistry:GetData(self)
    return { "", "Progress: " .. math.min(total_team_members - data["starting_team_members"], self.amount) .. "/" ..
    tostring(self.amount) }
  end
})

QuestRegistry:Register({
  id = "LEVEL_UP",
  amount = 1,
  reward = 300,
  getDescription = function(self)
    return string.format("Level up %s time", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  get_total_level_from_start = function(self)
    local total_level = 0
    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      local tbl = LTBL(member)
      total_level = total_level + (member.Level - tbl["StartLevel"])
    end
    for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      total_level = total_level + (member.Level - tbl["StartLevel"])
    end
    return total_level
  end,

  cleanup = function(self)
    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      local tbl = LTBL(member)
      tbl["StartLevel"] = nil
    end
    for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      tbl["StartLevel"] = nil
    end
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local on_start_id
    local on_turn_end_id

    on_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
      print("LEVEL UP CHECK START")
      for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
        local tbl = LTBL(member)
        tbl["StartLevel"] = member.Level
      end
      for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
        local tbl = LTBL(member)
        tbl["StartLevel"] = member.Level
      end
    end)

    on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
      local leveled_up = self:get_total_level_from_start()
      if leveled_up >= self.amount then
        beholder.stopObserving(on_start_id)
        beholder.stopObserving(on_turn_end_id)
        self:complete_quest()
      end
    end)

    -- id = beholder.observe("OnDeath",
    --   function(owner, ownerChar, context, args)
    --     local team = context.User.MemberTeam
    --     if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and context.User.MemberTeam ~= _DUNGEON.ActiveTeam) then
    --       data["defeated_enemies"] = data["defeated_enemies"] + 1
    --       print("Defeated enemies: " .. tostring(data["defeated_enemies"]) .. " / " .. tostring(self.amount))
    --       if data["defeated_enemies"] >= self.amount then
    --         beholder.stopObserving(id)
    --         data["defeated_enemies"] = self.amount
    --         UI:SetCenter(true)

    --         self:complete_quest()
    --         -- SOUND:PlayBattleSE("DUN_Money")

    --         UI:SetCenter(false)
    --       end
    --     end

    -- TotalKnockoutsTypes = luanet.import_type('PMDC.Dungeon.TotalKnockouts')
    -- local knockouts = context:GetContextStateInt(luanet.ctype(TotalKnockoutsTypes), 0)
    -- print(tostring(knockouts) .. " is the dmg taken")
    -- print("yepppp")
    -- print(tostring(context.User))
    -- print(tostring(context.Target))
    -- print(tostring(ownerChar))
    -- print(tostring(owner))
    -- print(tostring(args))
    -- print(tostring(context.InCombat))
    -- print(tostring(context.ContextStates.Count))
    -- print(tostring(idd) .. " is the observer id")
    -- end
    -- )

    -- print("Registered OnDeath observer for " .. self.id)
  end,

  getProgressTexts = function(self)
    local leveled_up = self:get_total_level_from_start()
    return { "Progress: " .. math.min(leveled_up, self.amount) .. "/" .. tostring(self.amount) }
  end
})

-- local contains = item_data.ItemStates:contains(luanet.ctype(OrbStateType))

-- if
-- print(tostring(item_data) .. " is the item data"  )
-- item = _DATA:GetItem(item.ID)

-- print(tostring(item) .. " is the item used")
-- int mapSlot = ZoneManager.Instance.CurrentMap.GetItem(context.User.CharLoc);

--                                   Label = label;
-- MapItem mapItem = ZoneManager.Instance.CurrentMap.Items[mapItemSlot];
-- string itemName = mapItem.GetDungeonName();

-- List<MenuTextChoice> choices = new List<MenuTextChoice>();

-- bool invFull = (DungeonScene.Instance.ActiveTeam.GetInvCount() >= DungeonScene.Instance.ActiveTeam.GetMaxInvSlots(ZoneManager.Instance.CurrentZone));
-- bool hasItem = !String.IsNullOrEmpty(DungeonScene.Instance.FocusedCharacter.EquippedItem.ID);
-- bool inReplay = DataManager.Instance.CurrentReplay != null;

-- if (mapItem.IsMoney)
--     choices.Add(new MenuTextChoice(Text.FormatKey("MENU_GROUND_GET"), PickupAction));
-- else
-- {
--     ItemData entry = DataManager.Instance.GetItem(mapItem.Value);
--     //disable pick up for full inv
--     //disable swap for empty inv
--     bool canGet = (DungeonScene.Instance.ActiveTeam.GetInvCount() < DungeonScene.Instance.ActiveTeam.GetMaxInvSlots(ZoneManager.Instance.CurrentZone));
--     if (!canGet && entry.MaxStack > 1)
--     {
--         //find an inventory slot that isn't full stack
--         foreach (InvItem item in DungeonScene.Instance.ActiveTeam.EnumerateInv())
--         {
--             if (item.ID == mapItem.Value && item.Cursed == mapItem.Cursed && item.Amount < entry.MaxStack)
--             {
--                 canGet = true;
--                 break;
--             }
--         }
--     }

local function CreateItemUseQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      local action_verb = config.action_verb or "Use"
      local item_type = self.amount == 1 and config.item_type_singular or config.item_type_plural
      return string.format(
        action_verb .. " " .. M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " " ..
        item_type, M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["count"] = 0

      local on_before_actions_id
      local on_turn_end_id

      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        if data["count"] >= self.amount then
          beholder.stopObserving(on_before_actions_id)
          beholder.stopObserving(on_turn_end_id)
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)

      on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
        if context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
          local item = get_item_from_context(context)
          local contains = item_id_contains_state(item, config.state_type)
          if contains then
            data["count"] = data["count"] + 1
          end
        end
      end)
    end,

    getProgressTexts = config.getProgressTexts or function(self)
      local data = QuestRegistry:GetData(self)
      local count = data["count"] or 0
      return { "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_ORB",
--   amount = 1,
--   reward = 100,
--   action_verb = "Use",
--   item_type_singular = "orb",
--   item_type_plural = "orbs",
--   state_type = OrbStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_WAND",
--   amount = 5,
--   reward = 200,
--   action_verb = "Use",
--   item_type_singular = "wand",
--   item_type_plural = "wands",
--   state_type = WandStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_ORB_2",
--   amount = 2,
--   reward = 250,
--   action_verb = "Use",
--   item_type_singular = "orb",
--   item_type_plural = "orbs",
--   state_type = OrbStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_SEED",
--   amount = 2,
--   reward = 100,
--   action_verb = "Eat",
--   item_type_singular = "seed",
--   item_type_plural = "seeds",
--   state_type = SeedStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_GUMMI",
--   amount = 1,
--   reward = 200,
--   action_verb = "Eat",
--   item_type_singular = "gummi",
--   item_type_plural = "gummis",
--   state_type = GummiStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_ITEMS",
--   amount = 4,
--   reward = 250,
--   action_verb = "Eat",
--   item_type_singular = "item",
--   item_type_plural = "edible items",
--   state_type = EdibleStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_FOOD_ITEMS",
--   amount = 2,
--   reward = 250,
--   action_verb = "Eat",
--   item_type_singular = "food item",
--   item_type_plural = "food items",
--   state_type = FoodStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_MACHINE_ITEMS",
--   amount = 1,
--   reward = 300,
--   action_verb = "Use",
--   item_type_singular = "machine item",
--   item_type_plural = "machine items",
--   state_type = MachineStateType,
--   getDescription = function(self)
--     local recall_box = M_HELPERS.GetItemName("machine_recall_box")
--     local assembly_box = M_HELPERS.GetItemName("machine_assembly_box")
--     local ability_capsule = M_HELPERS.GetItemName("machine_ability_capsule")

--     return string.format("Use %s machine or capsule items",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box, assembly_box, ability_capsule)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local count = data["count"] or 0
--     return { "", "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- }))

QuestMaster = EnchantmentRegistry:Register({
  name = "Quest Master",
  id = "QUEST_MASTER",
  task_amount = 2,
  getDescription = function(self)
    return string.format("At the start of each floor, receive %s quests to gain " .. PMDSpecialCharacters.Money,
      M_HELPERS.MakeColoredText(tostring(self.task_amount), PMDColor.Cyan))
  end,
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local currents_quests = SV.EmberFrost.Quests.Active
    local selected = QuestRegistry:GetSelected(currents_quests)
    local progress_texts = {}

    local money_earned = data["money_earned"] or 0

    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      table.insert(progress_texts,
        string.format("Quests (Earned %s %s): ",
          M_HELPERS.MakeColoredText(tostring(money_earned), PMDColor.Cyan), PMDSpecialCharacters.Money))
      for _, quest in ipairs(selected) do
        local description = quest:getDescription()
        local texts = quest:getProgressTexts()
        local data = QuestRegistry:GetData(quest)
        local completed = data["completed"] or false
        local icon = completed and PMDSpecialCharacters.Check or PMDSpecialCharacters.Cross
        if texts then
          table.insert(progress_texts, "")
          table.insert(progress_texts, description ..
            string.format(" (%s %s)", M_HELPERS.MakeColoredText(tostring(quest.reward), PMDColor.Cyan),
              PMDSpecialCharacters.Money))

          for i, text in ipairs(texts) do
            local prefix = (i == #texts) and (icon .. " ") or ""
            table.insert(progress_texts, prefix .. text)
          end
        end
      end
    else
      table.insert(progress_texts, "Total Earned: " ..
        M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
    end
    return progress_texts
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local quests = QuestRegistry:GetRandom(self.task_amount, 1)[1]

    SV.EmberFrost.Quests.Active = M_HELPERS.map(quests, function(q)
      return q.id
    end)
    SV.EmberFrost.Quests.Data = {}
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0

    print(Serpent.block(SV.EmberFrost.Quests.Active) .. ".... selected quests")

    for _, quest in ipairs(quests) do
      quest:set_active_effects(active_effect)
      print(quest.id .. " set active effects.")
    end
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("LogQuests"))
  end,

  apply = function(self)
    -- UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue("You will now receive quests at the start of each floor. Complete them to earn " ..
      PMDSpecialCharacters.Money .. "!")
    UI:WaitShowDialogue("You can check your quests in the Others -> Enchants menu while in dungeon.")
    -- UI:SetCenter(false)
  end
})

-- ENCHANTMENT_REGISTRY = ENCHANTMENT_REGISTRY or {}

-- local count = 0

-- function RegisterEnchantment(def)
--   assert(def.id, "Enchantment must have an id")

--   local enchant = setmetatable(def, {
--     __index = PowerupDefaults
--   })
--   ENCHANTMENT_REGISTRY[def.id] = enchant
--   count = count + 1
--   print(tostring(count))
--   return enchant
-- end

-- function GetEnchantmentFromRegistry(enchantment_id)
--   return ENCHANTMENT_REGISTRY[enchantment_id]
-- end

-- function GetRandomEnchantments(amount, total_groups)
--   local candidates = {}
--   for id, enchant in pairs(ENCHANTMENT_REGISTRY) do
--     local seen = SV.EmberFrost.SeenEnchantments[id]

--     if not seen and (not enchant.can_apply or enchant:can_apply()) then
--       table.insert(candidates, enchant)
--     end
--   end

--   -- TODO: Change the random to C# version... maybe?
--   for i = #candidates, 2, -1 do
--     local j = math.random(i)
--     candidates[i], candidates[j] = candidates[j], candidates[i]
--   end

--   local result = {}
--   for i = 1, math.min(amount, #candidates) do
--     local enchant = candidates[i]

--     table.insert(result, enchant)
--     SV.EmberFrost.SeenEnchantments[enchant.id] = true
--   end

--   local per_group = math.floor(#result / total_groups)
--   local grouped = {}
--   for i = 1, total_groups do
--     grouped[i] = {}
--   end

--   for i, enchant in ipairs(result) do
--     local group_index = ((i - 1) % total_groups) + 1
--     table.insert(grouped[group_index], enchant)
--   end

--   return grouped
-- end

-- function EnchantmentRegistry:GetData(enchant)
--   -- Enchantment data, note it should
--   local id
--   if type(enchant) == "string" then
--     id = enchant
--   elseif type(enchant) == "table" and enchant.id then
--     id = enchant.id
--   else
--     error("EnchantmentRegistry:GetData: enchant must be a string or a table with an id")
--   end

--   local data = SV.EmberFrost.EnchantmentData[id]

--   if not data then
--     data = {}
--     SV.EmberFrost.EnchantmentData[id] = data
--   end

--   return data
-- end

-- local function FindInGroup(count, get, enchant_id)
--   for i = count, 1, -1 do
--     local p = get(i - 1)
--     local tbl = LTBL(p)
--     if tbl.SelectedEnchantments and tbl.SelectedEnchantments[enchant_id] then
--       return p
--     end
--   end
-- end

-- local function FindInGroups(groups, entry_id, field)
--   field = field or "Selected"

--   for _, group in ipairs(groups) do
--     for i = group.count(), 1, -1 do
--       local obj = group.get(i - 1)
--       local tbl = LTBL(obj)

--       local selected = tbl[field]
--       if selected and selected[entry_id] then
--         return obj
--       end
--     end
--   end
-- end

-- function FindCharacterWithEnchantment(enchant_id)
--   return FindInGroup(GAME:GetPlayerPartyCount(), function(i)
--     return GAME:GetPlayerPartyMember(i)
--   end, enchant_id) or FindInGroup(GAME:GetPlayerAssemblyCount(), function(i)
--     return GAME:GetPlayerAssemblyMember(i)
--   end, enchant_id)
-- end

-- function HasEnchantment(table, enchantment_id)
--   table = table or SV.EmberFrost.SelectedEnchantments
--   for _, id in ipairs(table) do
--     if id == enchantment_id then
--       return true
--     end
--   end
--   return false
-- end

function ResetSeenEnchantments()
  SV.EmberFrost.Enchantments.Seen = {}
  -- SV.EmberFrost.Enchantments.Data = {}
  -- SV.EmberFrost.Enchantments.Selected = {}
  SV.EmberFrost.Enchantments.RerollCounts = { 1, 1, 1 }
end

function PrepareNextEnchantment()
  -- SV.EmberFrost.Enchantments.RerollCounts = { 1, 1, 1 }
  SV.EmberFrost.GotEnchantmentFromCheckpoint = false
end

function FindCharacterWithEnchantment(enchant_id)
  -- Party
  -- for i = GAME:GetPlayerPartyCount(), 1, -1 do
  --   local obj = GAME:GetPlayerPartyMember(i - 1)
  --   local tbl = LTBL(obj)

  --   if tbl.Enchantments
  --       and tbl.Enchantments[enchant_id] then
  --     return obj
  --   end
  -- end

  -- _DUNGEON.ActiveTeam.Assembly
  -- Assembly

  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
    for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
  else
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
  end
  -- for i = GAME:GetPlayerAssemblyCount(), 1, -1 do
  --   local obj = GAME:GetPlayerAssemblyMember(i - 1)
  --   local tbl = LTBL(obj)

  --   if tbl.Enchantments
  --       and tbl.Enchantments[enchant_id] then
  --     return obj
  --   end
  -- end
end

function ResetCharacterEnchantment(chara)
  local tbl = LTBL(chara)
  tbl.Enchantments = {}
end

function ResetAllCharacterEnchantments()
  for i = 0, GAME:GetPlayerPartyCount() - 1 do
    local chara = GAME:GetPlayerPartyMember(i)
    ResetCharacterEnchantment(chara)
  end

  for i = 0, GAME:GetPlayerAssemblyCount() - 1 do
    local chara = GAME:GetPlayerAssemblyMember(i)
    ResetCharacterEnchantment(chara)
  end
end

ExpandedSatchel = EnchantmentRegistry:Register({
  name = "Expanded Satchel",
  id = "EXPANDED_SATCHEL",
  bag_increase = 8,
  getDescription = function(self)
    return string.format("Increase the bag size by %s for the duration of the dungeon",
      M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local old_amount = _ZONE.CurrentZone.BagSize
    _ZONE.CurrentZone.BagSize = old_amount + self.bag_increase

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("Your team's bag size has increased by %s! (%s -> %s)",
      M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(old_amount), PMDColor.Cyan), M_HELPERS.MakeColoredText(
        tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan)))
    UI:SetCenter(false)
  end,

  getProgressTexts = function(self)
    return { "Current Bag Size: " .. M_HELPERS.MakeColoredText(tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan) }
  end,

  progress = function(self)
    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + self.bag_increase
  end
})

TreadingThrough = EnchantmentRegistry:Register({
  name = "Treading Through",
  id = "TREADING_THROUGH",
  getDescription = function(self)
    local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_allterrain_gear")
    return string.format("Gain %s " .. entry:GetColoredName() ..
      " (allows the holder to traverse water, lava, and pits)",
      M_HELPERS.MakeColoredText("2", PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    -- TODO: Add to other inventory
    local items = { {
      Item = "emberfrost_allterrain_gear",
      Amount = 1
    }, {
      Item = "emberfrost_allterrain_gear",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end

})

ThreadsOfLife = EnchantmentRegistry:Register({
  name = "Threads of Life",
  id = "THREADS_OF_LIFE",
  getDescription = function(self)
    local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("evo_harmony_scarf")
    return string.format("Gain a " .. entry:GetColoredName())
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local items = { {
      Item = "evo_harmony_scarf",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})
-- Gain6500P = EnchantmentRegistry:Register({

--   name = "Gain 6500 " .. PMDSpecialCharacters.Money,
--   id = "GAIN_6500_P",
--   group = ENCHANTMENT_TYPES.money,

--   getDescription = function(self)
--     return "Gain 6500 " .. PMDSpecialCharacters.Money
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 5000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 5,000 " .. PMDSpecialCharacters.Money .. "!")
--     UI:SetCenter(false)

--   end,

-- })

-- Gain7000P = EnchantmentRegistry:Register({

--   name = "Gain 7,000 " .. PMDSpecialCharacters.Money,
--   id = "GAIN_7000_P",
--   group = ENCHANTMENT_TYPES.money,
--   getDescription = function(self)
--     return "Gain 7000 " .. PMDSpecialCharacters.Money
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 7000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 7000 " .. PMDSpecialCharacters.Money .. "!")
--     UI:SetCenter(false)

--   end,

-- }, { __index = PowerupDefaults })

-- Gain9000P = setmetatable({
--   name = "Gain 9000 " .. PMDSpecialCharacters.Money,
--   id = "GAIN_9000_P",
--   group = ENCHANTMENT_TYPES.money,
--   getDescription = function(self)
--     return "Gain 9000 " .. PMDSpecialCharacters.Money
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 9000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 9000 " .. PMDSpecialCharacters.Money .. "!")
--     UI:SetCenter(false)

--   end,

-- }, { __index = PowerupDefaults })

-- CalmTheStorm = EnchantmentRegistry:Register({
--   name = "Calm the Storm",
--   id = "CALM_THE_STORM",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     local ward_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_weather_ward")
--     return string.format("Gain a %s (allows the holder to eliminate the weather when it is battling)", ward_entry:GetIconName())
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     local items = {
--       {Item = "emberfrost_weather_ward", Amount = 1 },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- MysteryEnchant = EnchantmentRegistry:Register({
--   gold_amount = 1000,
--   name = "Mystery Enchant",
--   id = "MYSTERY_ENCHANT",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format("Gain a random enchantment and %s.", M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
--   end,

--   getProgressTexts = function(self)
--     local data = EnchantmentRegistry:GetData(self)
--     local enchant_id = data["selected_enchantment"]
--     local enchant = ENCHANTMENT_REGISTRY[enchant_id]
--     if enchant then
--       return {
--         "Recieved: " .. M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow),
--       }
--     end

--     return {}
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     local enchantment = GetRandomEnchantments(1, 1)[1][1]

--     print(tostring(self.id) .. " applying enchantment: " .. tostring(enchantment.id))
--     local data = EnchantmentRegistry:GetData(self)

--     data["selected_enchantment"] = enchantment.id

--     enchantment:apply()

--     table.insert(SV.EmberFrost.SelectedEnchantments, enchantment.id)

--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.gold_amount
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained " .. tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money .. "!")
--     UI:SetCenter(false)

--   end,

-- })

PrimalMemory = EnchantmentRegistry:Register({
  name = "Primal Memory",
  id = "PRIMAL_MEMORY",
  amount = 2,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Select a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("egg moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)
    SetMovesRelearnable(selected_char, true, false)
    local items = {}
    for i = 1, self.amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

EliteTutoring = EnchantmentRegistry:Register({
  name = "Elite Tutoring",
  id = "ELITE_TUTORING",
  amount = 1,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Select a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("tutoring moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)

    SetMovesRelearnable(selected_char, false, true)

    local items = {}

    for i = 1, self.amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

function GetTM(tm)
  local entry = _DATA:GetItem(tm)

  local ItemIDState = luanet.import_type('RogueEssence.Dungeon.ItemIDState')
  local id_state = entry.ItemStates:Get(luanet.ctype(ItemIDState))
  local id = id_state.ID

  return id
end

--
-- function SetEggMovesRelearnable(member)

-- end

function SetMovesRelearnable(member, include_egg_moves, include_tutor_moves)
  local playerMonId = member.BaseForm

  while playerMonId ~= nil do
    local mon = _DATA:GetMonster(playerMonId.Species)
    local form = mon.Forms[playerMonId.Form]

    if include_egg_moves then
      for move_idx = 0, form.SharedSkills.Count - 1, 1 do
        local move = form.SharedSkills[move_idx].Skill
        -- local already_learned = member:HasBaseSkill(move)
        member.Relearnables[move] = true
      end
    end

    if include_tutor_moves then
      for move_idx = 0, form.SecretSkills.Count - 1, 1 do
        local move = form.SecretSkills[move_idx].Skill
        -- local already_learned = member:HasBaseSkill(move)
        member.Relearnables[move] = true
      end
    end
    if mon.PromoteFrom ~= "" then
      playerMonId = RogueEssence.Dungeon.MonsterID(mon.PromoteFrom, form.PromoteForm, "normal", Gender.Genderless)
    else
      playerMonId = nil
    end
  end
end

-- /// <summary>
-- /// Moves learned by TM
-- /// </summary>
-- public List<LearnableSkill> TeachSkills;

-- /// <summary>
-- /// Egg moves
-- /// </summary>
-- public List<LearnableSkill> SharedSkills;

-- /// <summary>
-- /// Tutor moves
-- /// </summary>
-- public List<LearnableSkill> SecretSkills;

-- Frostbite = setmetatable({
--   name = "Frostbite",
--   type = "Boost",
--   description = "",
--   offer_time = 1,
--   rarity = 1,

--   apply = function(self)
--     print("Frostbite active: attacks deal damage over time.")
--   end
-- }, { __index = PowerupDefaults })

-- SticksAndStones = EnchantmentRegistry:Register({
--   amount = 5,

--   name = "Sticks & Stones",
--   id = "STICKS_AND_STONES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)

--     local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
--     local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
--     local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
--     local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
--     -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

--     -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
--     -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
--     -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

--     return string.format(
--       "Gain %s of each: %s, %s, %s, %s",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       goldenthorn:GetIconName(),
--       sticks:GetIconName(),

--       gravelerock:GetIconName(),
--       geopebble:GetIconName()
--     )
--     -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)

--     local amount = self.amount
--     local items = {
--       {Item = "ammo_stick", Amount = amount },
--       {Item = "ammo_golden_thorn", Amount = amount },
--       {Item = "ammo_gravelerock", Amount = amount },
--       {Item = "ammo_geo_pebble", Amount = amount },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

--
-- MayBreakMyBones = EnchantmentRegistry:Register({
--   amount = 9,
--   percent = 50,

--   name = "...Break My Bones",
--   id = "BREAK_MY_BONES",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.EmberFrost.SelectedEnchantments, SticksAndStones.id)
--   end,

--   getDescription = function(self)
--     local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
--     local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
--     local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
--     local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
--     -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

--     -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
--     -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
--     -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

--     return string.format(
--       "Your team's projectiles do %s more damage. Gain %s of each: %s, %s, %s, %s",
--       M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       goldenthorn:GetIconName(),
--       sticks:GetIconName(),

--       gravelerock:GetIconName(),
--       geopebble:GetIconName()
--     )
--     -- return "Projectiles deal 50% more damage."
--     -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     local amount = self.amount

--     local items = {
--       "ammo_stick", Amount = amount },
--       "ammo_golden_thorn", Amount = amount },
--       "ammo_gravelerock", Amount = amount },
--       "ammo_geo_pebble", Amount = amount },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- WordsWillNever = EnchantmentRegistry:Register({

--   name = "...Words Will Never",
--   id = "WORDS_WILL_NEVER",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.EmberFrost.SelectedEnchantments, MayBreakMyBones.id)
--   end,

--   getDescription = function(self)
--     local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
--     local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
--     local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
--     local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
--     -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

--     -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
--     -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
--     -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

--     return string.format(
--       "Your team is immune to the negative status effects: Spite, Disabled, Taunt, Swagger, Torment, Grudge, and Quash",
--       M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       goldenthorn:GetIconName(),
--       sticks:GetIconName(),

--       gravelerock:GetIconName(),
--       geopebble:GetIconName()
--     )
--     -- return "Projectiles deal 50% more damage."
--     -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
--   end,

--   offer_time = "beginning",
--   rarity = 2,
--   apply = function(self)
--     local amount = self.amount

--     local items = {
--       "ammo_stick", Amount = amount },
--       "ammo_golden_thorn", Amount = amount },
--       "ammo_gravelerock", Amount = amount },
--       "ammo_geo_pebble", Amount = amount },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- BuriedTreasures = EnchantmentRegistry:Register({
--   turn_interval = 200,
--   name = "Buried Treasures",
--   id = "BURIED_TREASURES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "At the start of each floor and every %s turns, show a compass towards to a buried treasure if any are present.",
--       M_HELPERS.MakeColoredText(tostring(self.turn_interval), PMDColor.Cyan)
--     )
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--   end,
-- })

-- Pacifist = EnchantmentRegistry:Register({
--   gold_amount = 500,
--   name = "Pacifist",
--   id = "PACIFIST",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Select a character. When that character deals no damage for the floor, gain %s the following floor.",
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. PMDSpecialCharacters.Money, PMDColor.Cyan)
--     )
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_pacifist", EnchantmentID = self.id })))
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

-- RiskyMoves = EnchantmentRegistry:Register({
--   gold_amount = 10000,
--   total_floors = 5,
--   name = "Risky Moves",
--   id = "RISKY_MOVES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Your team cannot use items for %s floors. Gain %s afterwards",
--       M_HELPERS.MakeColoredText(tostring(self.total_floors), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. PMDSpecialCharacters.Money, PMDColor.Cyan)
--     )
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--   end,
-- })

HandsTied = EnchantmentRegistry:Register({
  gold_amount = 20000,
  name = "Hands Tied",
  id = "HANDS_TIED",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Gain %s. The team cannot use %s until the next checkpoint", M_HELPERS.MakeColoredText(
        tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_embargo",
        EnchantmentID = self.id,
        ApplyToAll = true
      })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue(string.format("Note: Your team cannot use %s until the next checkpoint.",
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
    UI:SetCenter(false)
  end
})

-- When an enemy is hit. Only 1 enemy can be marked at a time.
Marksman = EnchantmentRegistry:Register({
  increased_damage_percent = 25,
  name = "Marksman",
  id = "MARKSMAN",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Select a team member. When that member hits an enemy, that enemy is %s. %s enemies take %s more damage from all sources. Only one enemy can be %s at a time.",
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue), M_HELPERS.MakeColoredText("Marked", PMDColor.Blue),
      M_HELPERS.MakeColoredText(tostring(self.increased_damage_percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring("1") .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_marksman",
        EnchantmentID = self.id
      })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

-- FeelTheBurn = EnchantmentRegistry:Register({
--   name = "Feel the Burn",
--   chance = 15,
--   id = "FEEL_THE_BURN",
--   -- group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     local element = _DATA:GetElement("fire")
--     return string.format(
--       "Choose a team member. When that member is hit by a %s move, they will take %s additional damage and gain a speed boost",
--       element:GetIconName(),
--       M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local char = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil
--     if char_name then
--       return {
--         "Assigned to: " .. char_name,
--       }
--     end
--     return {}
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_fire_speed_boost", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

GlassCannon = EnchantmentRegistry:Register({
  name = "Glass Cannon",
  id = "GLASS_CANNON",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member will deal %s more damage but take %s more damage",
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_glass_cannon",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Sponge = EnchantmentRegistry:Register({
  name = "Sponge",
  id = "SPONGE",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member will take %s less damage but deal %s less damage",
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_sponge",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

-- MonoMoves = EnchantmentRegistry:Register({
--   name = "Mono Moves",
--   id = "MONO_MOVES",
--   attack_boost = 35,
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Choose a team member. If all their moves are the %s, that member deals %s more damage.",
--       M_HELPERS.MakeColoredText("same type", PMDColor.Yellow),
--       M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan)
--       -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local char = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil
--     if char_name then
--       return {
--         "Assigned to: " .. char_name,
--       }
--     end
--     return {}
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

Ravenous = EnchantmentRegistry:Register({
  name = "Ravenous",
  id = "RAVENOUS",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. That member deals %s the more hungrier. At very low hunger, that member has a chance to be %s",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow),
      "confused"                                                                  --  M_HELPERS.MakeColoredText("confused", PMDColor.Red)
    -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_ravenous",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Avenger = EnchantmentRegistry:Register({
  name = "Avenger",
  id = "AVENGER",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member deals %s the more members that are fainted",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_avenger",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

-- OneTrick
-- MonoMoves = EnchantmentRegistry:Register({
-- name = "Mono Moves",
-- id = "MONO_MOVES",
-- attack_boost = 35,
-- group = ENCHANTMENT_TYPES.items,
-- getDescription = function(self)
--   return string.format(
--     "Choose a team member. If all their moves are the %s, that member deals %s more damage.",
--     M_HELPERS.MakeColoredText("same type", PMDColor.Yellow),
--     M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan)
--     -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
--   )
-- end,
-- offer_time = "beginning",
-- rarity = 1,
-- getProgressTexts = function(self)
--   local char = FindCharacterWithEnchantment(self.id)
--   local char_name = char and char:GetDisplayName(true) or nil
--   if char_name then
--     return {
--       "Assigned to: " .. char_name,
--     }
--   end
--   return {}
-- end,

-- set_active_effects = function(self, active_effect, zone_context)
--   active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
-- end,

-- apply = function(self)
--   AssignEnchantmentToCharacter(self)
-- end,
-- })
-- HungerStrike = EnchantmentRegistry:Register({
--   name = "Hunger Strike",
--   amount = 5,
--   id = "HUNGER_STRIKE",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Choose a team member. That member will lose hunger more quickly. When they inflict damage, the target will lose %s hunger points",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local char = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil
--     if char_name then
--       return {
--         "Assigned to: " .. char_name,
--       }
--     end
--     return {}
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_hunger_strike", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

PandorasItems = EnchantmentRegistry:Register({
  amount = 1,
  name = "Pandora's Items",
  id = "PANDORAS_ITEMS",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Gain %s random %s and %s. At the start of each floor, any non-held %s or %s are randomized",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("equipment", PMDColor.Pink), M_HELPERS.MakeColoredText("orb", PMDColor.Pink),
      M_HELPERS.MakeColoredText("equipments", PMDColor.Pink), M_HELPERS.MakeColoredText("orbs", PMDColor.Pink))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local equipment = data["equipment"]
    local orb = data["orb"]

    print(tostring(equipment))
    print(tostring(orb))
    print(Serpent.dump(SV.EmberFrost.Enchantments.Data) .. " hmmmm")
    print(Serpent.dump(EnchantmentRegistry._data) .. " hmmmm2")
    print("Are they the same table reference?")
    print(tostring(EnchantmentRegistry._data == SV.EmberFrost.Enchantments.Data))

    print(Serpent.dump(SV.EmberFrost.Enchantments.Seen) .. " hmmmm")
    print(Serpent.dump(EnchantmentRegistry._seen) .. " hmmmm2")

    local equipment_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(equipment)
    local orb_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(orb)
    local text = { "Equipment: " .. equipment_entry:GetIconName(), "Orb: " .. orb_entry:GetIconName() }

    return text
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PandorasItems"))
  end,

  apply = function(self)
    print("Are they the same table reference hm,,,,dkd?")
    print(tostring(EnchantmentRegistry._data == SV.EmberFrost.Enchantments.Data))

    local random_orb_index = _DATA.Save.Rand:Next(#ORBS)
    local random_orb = ORBS[random_orb_index]
    local random_equipment_index = _DATA.Save.Rand:Next(#EQUIPMENT)
    local random_equipment = EQUIPMENT[random_equipment_index]
    local amount = self.amount
    local items = { {
      Item = random_equipment,
      Amount = amount
    }, {
      Item = random_orb,
      Amount = amount
    } }

    local data = EnchantmentRegistry:GetData(self)
    data["equipment"] = random_equipment
    data["orb"] = random_orb

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

SupplyDrop = EnchantmentRegistry:Register({
  amount = 1,
  name = "Supply Drop",
  id = "SUPPLY_DROP",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("After each checkpoint, gain a random supply drop containing %s",
      M_HELPERS.MakeColoredText("essential items", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,

  on_checkpoint = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["can_receive_supply_drop"] = true
  end,
  set_active_effects = function(self, active_effect, zone_context)
    local essentials_table = {
      Min = 2,
      Max = 2,
      Guaranteed = { { {
        Item = "food_apple",
        Amount = 1,
        Weight = 10
      } }, { {
        Item = "berry_sitrus",
        Amount = 1,
        Weight = 10
      }, {
        Item = "berry_oran",
        Amount = 1,
        Weight = 10
      } }, { {
        Item = "berry_leppa",
        Amount = 1,
        Weight = 10
      }, {
        Item = "seed_reviver",
        Amount = 1,
        Weight = 10
      } }, { {
        Item = "seed_reviver",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_ban",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_pure",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_joy",
        Amount = 1,
        Weight = 2
      } }, { {
        Item = "ammo_geo_pebble",
        Amount = 3,
        Weight = 3
      }, {
        Item = "ammo_gravelerock",
        Amount = 3,
        Weight = 3
      }, {
        Item = "ammo_stick",
        Amount = 3,
        Weight = 3
      } } },
      Items = { {
        Item = "food_apple",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_leppa",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_sitrus",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_oran",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_leppa",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_apicot",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_jaboca",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_liechi",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_starf",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_petaya",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_salac",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_ganlon",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_enigma",
        Amount = 1,
        Weight = 2
      }, {
        Item = "berry_micle",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_ban",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_joy",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_decoy",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_pure",
        Amount = 1,
        Weight = 3
      }, {
        Item = "seed_blast",
        Amount = 1,
        Weight = 3
      }, {
        Item = "seed_ice",
        Amount = 1,
        Weight = 3
      }, {
        Item = "seed_reviver",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_warp",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_doom",
        Amount = 1,
        Weight = 2
      }, {
        Item = "seed_ice",
        Amount = 1,
        Weight = 2
      }, {
        Item = "herb_white",
        Amount = 1,
        Weight = 2
      }, {
        Item = "herb_mental",
        Amount = 1,
        Weight = 2
      }, {
        Item = "herb_power",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_all_dodge",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_all_protect",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_cleanse",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_devolve",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_fill_in",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_endure",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_foe_hold",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_foe_seal",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_freeze",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_halving",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_invert",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_invisify",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_itemizer",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_luminous",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_pierce",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_scanner",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_mobile",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_mug",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_nullify",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_mirror",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_spurn",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_slow",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_slumber",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_petrify",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_totter",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_invisify",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_one_room",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_totter",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_rebound",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_rollcall",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_stayaway",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_trap_see",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_trapbust",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_trawl",
        Amount = 1,
        Weight = 2
      }, {
        Item = "orb_weather",
        Amount = 1,
        Weight = 2
      }, {
        Item = "machine_recall_box",
        Amount = 1,
        Weight = 2
      }, {
        Item = "machine_assembly_box",
        Amount = 1,
        Weight = 2
      }, {
        Item = "machine_ability_capsule",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_elixir",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_full_heal",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_max_elixir",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_max_potion",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_potion",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_accuracy",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_attack",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_defense",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_sp_atk",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_sp_atk",
        Amount = 1,
        Weight = 2
      }, {
        Item = "medicine_x_speed",
        Amount = 1,
        Weight = 2
      }, {
        Item = "ammo_cacnea_spike",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_corsola_twig",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_geo_pebble",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_golden_thorn",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_gravelerock",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_iron_thorn",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_rare_fossil",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_silver_spike",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_stick",
        Amount = 3,
        Weight = 2
      }, {
        Item = "ammo_iron_thorn",
        Amount = 3,
        Weight = 2
      }, {
        Item = "apricorn_big",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_black",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_blue",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_brown",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_green",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_plain",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_purple",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_red",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_white",
        Amount = 1,
        Weight = 2
      }, {
        Item = "apricorn_yellow",
        Amount = 1,
        Weight = 2
      } }
    }

    -- local item_table = DUNGEON_WISH_TABLE[choice]
    -- local arguments = {}
    -- arguments.MinAmount = item_table.Min
    -- arguments.MaxAmount = item_table.Max
    -- arguments.Guaranteed = item_table.Guaranteed
    -- arguments.Items = item_table.Items
    -- arguments.UseUserCharLoc = true
    -- SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
    -- GAME:WaitFrames(60)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("SupplyDrop", Serpent.line({
      DropTable = essentials_table,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["can_receive_supply_drop"] = true

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("You will receive a %s after each checkpoint!",
      M_HELPERS.MakeColoredText("supply drop", PMDColor.Yellow)))
    UI:SetCenter(false)
    UI:ResetSpeaker()

    -- TODO: Set flag to indi
    -- local random_orb_index = math.random(#ORBS)
    -- local random_orb = ORBS[random_orb_index]
    -- local random_equipment_index = math.random(#EQUIPMENT)
    -- local random_equipment = EQUIPMENT[random_equipment_index]
    -- local amount = self.amount
    -- local items = {
    --   { Item = random_equipment, Amount = amount },
    --   { Item = random_orb, Amount = amount },
    -- }

    -- local data = EnchantmentRegistry:GetData(self)
    -- data["equipment"] = random_equipment
    -- data["orb"] = random_orb

    -- M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

-- YourAWizard = EnchantmentRegistry:Register({
--   stack = 3,
--   amount = 3,
--   percent = 3,
--   name = "You're a Wizard!",
--   id = "YOURE_A_WIZARD",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Gain %s stacks of %s random %s. Then select a party member. That member will gain %s special attack boost for each unique %s in your inventory.",
--       M_HELPERS.MakeColoredText(tostring(self.stack), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText("wands", PMDColor.Pink),
--       M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText("wand", PMDColor.Pink)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)

--     local data = EnchantmentRegistry:GetData(self)
--     local wands = data["wands"]

--     local str_arr = {
--       "Recieved: ",
--     }
--     for _, wand in ipairs(wands) do
--         local item = RogueEssence.Dungeon.InvItem(wand, false, self.amount)

--         local wand_name = item:GetDisplayName()
--         table.insert(str_arr, wand_name)
--     end

--     local unique_wands = {}
--     local total_unique = 0

--     local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
--     for i = inv_count, 0, -1 do
--         local item = _DATA.Save.ActiveTeam:GetInv(i)
--         local item_id = item.ID
--         print("Checking item in inventory: " .. tostring(item_id))
--         if Contains(WANDS, item_id) then
--             print("Found wand in inventory: " .. tostring(item_id)  )
--             if unique_wands[item_id] == nil then
--                 unique_wands[item_id] = true
--                 total_unique = total_unique + 1
--             end
--         end
--     end

--     local player_count = _DATA.Save.ActiveTeam.Players.Count
--     for player_idx = 0, player_count-1, 1 do
--       local inv_item = GAME:GetPlayerEquippedItem(player_idx)
--       local item_id = inv_item.ID
--       if Contains(WANDS, item_id) then
--           if unique_wands[item_id] == nil then
--               unique_wands[item_id] = true
--               total_unique = total_unique + 1
--           end
--       end
--     end

--     print("Total Unique Wands: " .. tostring(total_unique))
--     local boost_amount = self.percent * total_unique

--     local char = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil

--     table.insert(str_arr, "\n")
--     table.insert(str_arr, "Assigned to: " .. char_name)
--     table.insert(str_arr, "Special Attack Boost: " .. M_HELPERS.MakeColoredText(tostring(boost_amount) .. "%", PMDColor.Cyan))

--     return str_arr
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_wizard", EnchantmentID = self.id })))
--     -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)

--     local data = EnchantmentRegistry:GetData(self)
--     data["wands"] = {}
--     data["boost"] = 0

--     local items = {}

--     for i = 1, self.amount do
--         local random_wand_index = math.random(#WANDS)
--         local wand = WANDS[random_wand_index]

--         table.insert(data["wands"], wand)

--         table.insert(items, { Item = wand, Amount = self.stack })
--     end

--     M_HELPERS.GiveInventoryItemsToPlayer(items)

--   end,
-- })

PlantYourSeeds = EnchantmentRegistry:Register({
  money = 300,
  amount = 3,
  minimum = 6,
  name = "Plant Your Seeds",
  id = "PLANT_YOUR_SEEDS",
  getDescription = function(self)
    return string.format(
      "Gain %s random %s. At the start of each floor, if you have at least non-held %s, lose all of them and gain %s for each seed",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("seeds", PMDColor.Pink),
      M_HELPERS.MakeColoredText(tostring(self.minimum), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.money) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local seeds = data["seeds"]
    local money_earned = data["money_earned"] or 0

    local str_arr = { "Recieved: " }
    for _, seed in ipairs(seeds) do
      local seed_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(seed)
      local seed_name = seed_entry:GetIconName()
      table.insert(str_arr, seed_name)
    end

    -- TODO: Account for the player is holding the seeds...
    local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
    local seed_index_arr = {}
    for i = inv_count, 0, -1 do
      local item = _DATA.Save.ActiveTeam:GetInv(i)
      local item_id = item.ID
      if Contains(SEED, item_id) then
        table.insert(seed_index_arr, i)
      end
    end

    table.insert(str_arr, "\n")
    table.insert(str_arr, "Seed Count: " .. M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan))
    table.insert(str_arr, "Total Earned: " ..
      M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))

    return str_arr
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({
      MoneyPerSeed = self.money,
      MinimumSeeds = self.minimum,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["seeds"] = {}
    data["money_earned"] = 0

    local items = {}

    for i = 1, self.amount do
      local random_seed_index = _DATA.Save.Rand:Next(#SEED)
      local seed = SEED[random_seed_index]

      table.insert(data["seeds"], seed)

      table.insert(items, {
        Item = seed,
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

ExitStrategy = EnchantmentRegistry:Register({
  pure_seed_amount = 2,
  warp_wands_amount = 9,
  salac_amount = 3,
  name = "Exit Strategy",
  id = "EXIT_STRATEGY",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local warp_scarf = M_HELPERS.GetItemName("held_warp_scarf")
    local pure_seed = M_HELPERS.GetItemName("seed_pure")
    local warp_wand_name = M_HELPERS.GetItemName("wand_warp")

    return string.format(
      "Select a team member. They will see the direction of the stairs at the start of each floor. Gain a %s, %s %s, %s %s, and %s %s.",
      warp_scarf, M_HELPERS.MakeColoredText(tostring(self.pure_seed_amount), PMDColor.Cyan), pure_seed,
      M_HELPERS.MakeColoredText(tostring(self.warp_wands_amount), PMDColor.Cyan), warp_wand_name,
      M_HELPERS.MakeColoredText(tostring(self.salac_amount), PMDColor.Cyan), M_HELPERS.GetItemName("berry_salac"))
  end,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  offer_time = "beginning",
  rarity = 1,
  -- getProgressTexts = function(self)

  --   local data = EnchantmentRegistry:GetData(self)
  --   local seeds = data["seeds"]
  --   local money_earned = data["money_earned"]

  --   local str_arr = {
  --     "Recieved: ",
  --   }
  --   for _, seed in ipairs(seeds) do
  --       local seed_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(seed)
  --       local seed_name = seed_entry:GetIconName()
  --       table.insert(str_arr, seed_name)
  --   end

  --   -- TODO: Account for the player is holding the seeds...
  --   local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
  --   local seed_index_arr = {}
  --   for i = inv_count, 0, -1 do
  --       local item = _DATA.Save.ActiveTeam:GetInv(i)
  --       local item_id = item.ID
  --       if Contains(SEED, item_id) then
  --           table.insert(seed_index_arr, i)
  --       end
  --   end

  --   table.insert(str_arr, "\n")
  --   table.insert(str_arr, "Seed Count: " .. M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan))
  --   table.insert(str_arr, "Money Earned: " .. M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))

  --   return str_arr
  -- end,

  -- set_active_effects = function(self, active_effect, zone_context)
  -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
  -- end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_stairs_sensor",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    local items = { {
      Item = "held_warp_scarf",
      Amount = 1
    }, {
      Item = "wand_warp",
      Amount = self.warp_wands_amount
    } }

    for i = 1, self.pure_seed_amount do
      table.insert(items, {
        Item = "seed_pure",
        Amount = 1
      })
    end

    for i = 1, self.salac_amount do
      table.insert(items, {
        Item = "berry_salac",
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
    AssignEnchantmentToCharacter(self)
  end
})
-- TheBubble = EnchantmentRegistry:Register({
--   interest = 0.10,
--   start = 0,
--   pop_increase = 1.5,
--   loss = 0.50,
--   name = "The Bubble",
--   id = "THE_BUBBLE",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     local bubble = M_HELPERS.GetItemName("emberfrost_bubble")
--     return string.format(
--       "Gain a %s (Gain %s interest at start of floor. If the %s pops, lose %s of your %s and it will reset. Pop chance increases by %s each floor)",
--       bubble,
--       M_HELPERS.MakeColoredText(tostring(math.ceil(self.interest * 100)).. "%", PMDColor.Cyan),
--       bubble,
--       M_HELPERS.MakeColoredText(tostring(math.ceil(self.loss * 100)) .. "%", PMDColor.Cyan),
--       PMDSpecialCharacters.Money,
--       M_HELPERS.MakeColoredText(tostring(self.pop_increase) .. "%", PMDColor.Cyan))
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local data = EnchantmentRegistry:GetData(self)
--     local money_earned = data["money_earned"] or 0
--     local money_lost = data["money_lost"] or 0
--     local pop_chance = data["pop_chance"] or 0

--     return { "Money Earned: " ..
--     M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
--       "Money Lost: " ..
--       M_HELPERS.MakeColoredText(tostring(money_lost) .. " " .. PMDSpecialCharacters.Money, PMDColor.Red),
--       "Current Pop Chance: " .. M_HELPERS.MakeColoredText(tostring(pop_chance) .. "%", PMDColor.Cyan) }
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     local data = EnchantmentRegistry:GetData(self)
--     data["money_earned"] = 0
--     data["money_lost"] = 0
--     data["pop_chance"] = self.start

--     local items = { {
--       Item = "emberfrost_bubble",
--       Amount = 1
--     } }
--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end
-- })

-- StackOfPlates = EnchantmentRegistry:Register({
--   amount = 2,
--   choice = 5,
--   name = "Stack of Plates",
--   id = "STACK_OF_PLATES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Gain %s random type %s. Then select a %s from a choice of %s ",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring("plates"), PMDColor.Pink),
--       M_HELPERS.MakeColoredText(tostring("plate"), PMDColor.Pink),
--       M_HELPERS.MakeColoredText(tostring(self.choice), PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)

--     local data = EnchantmentRegistry:GetData(self)
--     local plates = data["plates"]

--     local str_arr = {
--       "Recieved: ",
--     }
--     for _, plate in ipairs(plates) do
--         local plate_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(plate)
--         local plate_name = plate_entry:GetIconName()
--         table.insert(str_arr, plate_name)
--     end

--     return str_arr
--   end,

--   apply = function(self)
--     local data = EnchantmentRegistry:GetData(self)
--     data["plates"] = {}

--     local random_items = {}

--     for i = 1, self.amount do
--         local random_plate_index = math.random(#PLATES)
--         local plate = PLATES[random_plate_index]
--         table.insert(data["plates"], plate)
--         table.insert(random_items, { Item = plate, Amount = 1 })
--     end
--     M_HELPERS.GiveInventoryItemsToPlayer(random_items)

--     GAME:WaitFrames(20)

--     local pool_items = {}

--     local plates = GetRandomUnique(PLATES, 5)
--     for _, plate in ipairs(plates) do
--         table.insert(pool_items, { Item = plate, Amount = 1 })
--     end

--     local result = SelectItemFromList(
--       string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
--       pool_items
--     )

--     table.insert(data["plates"], result.Item)
--     GAME:WaitFrames(20)
--     M_HELPERS.GiveInventoryItemsToPlayer({ result })
--   end
-- })

-- For each equipment in your inventory, gain a 3% attack boost.
-- Fashionable = EnchantmentRegistry:Register({
--   "for each unique specs or googles"

-- })
--
-- Minimalist - The less items in intentory, the more damage
-- Dazzled- Choose a team member. For each equipment, lower the accuracy of the target
-- RunAndGun - Projectiles deal more damage if your team has a speed boost, depends on it
-- Fitness - Each food item grants more hunger points, boosts to yourself
-- For 10 enemies fainted with an ammo,
-- Precision - Choose a team member. That team member. Moves that have less than 80% accuracy cannot miss. Moves with accuracy will miss more often
-- BluePrint - Select a team member. Gain tms. Select a tm, gain two randoms ones. Gain a recall box.

-- Minimalist - Your team gains a famage boost. When you pick up an item, that boost disappears.
-- Minimalist - Gain money based on how few items you have in your inventory at the end of each floor.
--
-- All your party members gain the stat boost of the highest party member
-- Lots of Equipment: Select 3 equipment from a pool of 5 random ones.
-- Allies Type Squad - If you recruit all types, gain a huge reward (includes assembly).
-- Monotype - If all your team members are the same type, gain a damage boost (Requires 2+ members).
-- ???
-- Win Out -
-- Gain 3 Invisibioty orbs
-- Raining Gold - Gain 200 each floor
-- Gain 2 random allies from the previous floors. Gain an assembly box. They have gummi boosts with random equioment attatched
-- RPG Gold - Your team has %50 chance to gain 50 p from an enemies.
-- Every third attack is a critical hit.
-- Your team gains a ciritcal chance boost
-- Your team does slighty more damage for super-effective moves.
-- Your team takes slightly more damage for not very effective moves.
-- All for one - Choose a team member. That members gains for power for each team member within 1 tile.
-- One for all - Choose a team member. That members transfer ALL status to all adjacent allies upon recieiving a status.
-- Team Building - Select a between apricrons and 2 amber tears and a friend bow
-- Gummi Overload - Gain 5 random gummies. Each gummy grants +1 max hunger.
-- Gain a random gummi at the start of each floor.
-- Death Defying/ Second Wind - Gain a death amulet. If that member would faint, 50% chance to survive with 1 HP instead. When at 1 HP, gain a speed boost.
-- Quick Reflexes - Choose a team member. That member has a chance to dodge physical attacks.
-- Elusive - Each team gains a evasive boost at the start of each floor
-- Restart Mission - Lose all items in your inventory.
-- Each of your team member loses 2 levels. When the next checkpoint is reached, gain 5 levels for each team member.
-- Killing Blow - Choose a team member. Explode area around enemy when defeated
-- Execute - Choose a team member. That member will deal defeat any enemies below 20% HP.
-- I C - Gain an X-ray specs. Your team can see invisible traps.
-- Harmony Scarf - Gain a harmony scarf.
-- Huddle - Defense
-- Safety Net / Emergency Fund - Gain 1,000 P when a team member faints. Gain a reviver seed
-- Emergency Fund
-- Moral Support / Support from Beyond - Gain a damage boost for each tea m member alive in the assembly
-- Berry Nutritious - At the start of each floor, if you have at least 5 berries, each party member gains 2 random stat boosts,
-- Tempo - Select a team member. That member gains a permanent stat boost for every 10
-- After each member defeats 20 enemies, your team gains a damage boost.
-- Solo Mission - When your team has only 1 member, that member does more damage
-- Hoarder - More money when you have more items in your inventory
-- Fitness Routine - Speed boost when your team has more than 75% hunger (ewwww, better)
-- Full Belly Happy Heart
-- Resilience - Take less damage from super-effective moves
-- Nitroglycerin - Speed boost when low on hunger
-- Choose a character. Super-effective moves deal less damage
-- Bargainer: Half off from shop. I don’t know why, but I feel like giving everything to you half off now
-- Affluent: Calculate the cost of inventory. Do damage based on total. Easier to recruit monsters.
-- Ranged: Select a team member. That member gets +1 tange.
-- Underdogs: Your team does more damage when lower leveled than the enemy
-- Immunity: Choose a team member. That member is immune to negative status effects.
-- Treausre Tracker: Gain a trackr. Will reveal buried within 20 tiles
-- Level Up: Choose a team member. That member gains 5 levels.
-- Reroll: For the next enchantment selections. Gain an extra reroll.
-- Flexible: Gain 20,000 P, you will not know what your enchantment will be until you select it.
-- Your next enchantment selection gains an extra reroll.
-- Toll (Scorched): Select a team member. Lose 50 G of your money when the character damage or 50 gold (whichever is higher) Do higher damage based on the toll
-- Pay-to-Win - Pay 3,000 P, you can select another two enchantments afterwards
-- 2 for 1 Special - Gain two random enchantments
-- Tiny, but Mighty - Choose a team member. That member is smaller, but deals more damage.
-- Heavy Hitter - Choose a team member. If that member is weight, but takes more damage
-- Self-Improvment - Gain 1 nectors, 1 ability capsule, 1 recall box, 1 joy seed, 1 citrus 1 protein
-- LotsOfStats
-- Life Orb - Gain a life-orb
-- Life-Steal - Select a character
-- When you pick up gold - Gain a random state boost.
-- Drain Terrain - Fill gaps - Moves can fill gaps
-- Mission Impossible
-- Limit to only 1 boost except for speed.
-- 25% Spawn a slow tile
-- OneTrick - Choose a team member. That member is locked into
-- StandGround - Standing in spot leaves a post which gains an attack boost
-- Leader
-- Trick Shot - Arc projectiles do more damage
-- Vitamins Gummmies -
-- Minimalist - The less items in intentory, the more damage
-- Power of 3s - For every 3 of the same item in inventory, gain a boost
-- Mileage - For every 100 tiles moved, gain a small boost
-- Gain a random vitamin fo
-- Life-Steal+
-- Revival Blessing - Gain a reviver orb.
-- Insurance - Whenever a team member faints, gain 1000 P
-- 3-1 Special - Gain
-- Ranged+: Select a team member. That member gets +1 tange.

-- Tank
-- -- Marksmen: Choose a team member. That member’s projectiles deal more damage. Mark the target. That target will take additonal damage
-- {
-- "Key": {
-- "str": [
-- 0
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.SpeedPowerEvent, PMDC",
-- "Reverse": false
-- }
-- }
-- ],
-- "OnHits": [
-- {
-- "Key": {
-- "str": [
-- -1
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.DamageFormulaEvent, PMDC"
-- }
-- }

function AssignCharacterEnchantment(chara, enchantment_id)
  local tbl = LTBL(chara)

  tbl.Enchantments = tbl.Enchantments or {}
  tbl.Enchantments[enchantment_id] = true
end

function AssignEnchantmentToCharacter(enchant)
  local ret = {}
  local choose = function(chars)
    ret = chars
    _MENU:RemoveMenu()
  end
  local refuse = function()
  end
  local menu = TeamMultiSelectMenu:new(string.format("Assign %s to?",
    M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)), _DATA.Save.ActiveTeam.Players, function()
    return true
  end, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  local selected_char = ret[1]
  AssignCharacterEnchantment(selected_char, enchant.id)
  UI:SetCenter(true)
  SOUND:PlayFanfare("Fanfare/Item")
  UI:WaitShowDialogue(string.format("%s got the %s enchantment!", selected_char:GetDisplayName(true),
    M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)))
  UI:SetCenter(false)
  return selected_char
end

ORBS = { "orb_all_dodge", "orb_all_protect", "orb_cleanse", "orb_devolve", "orb_fill_in", "orb_endure", "orb_foe_hold",
  "orb_foe_seal", "orb_freeze", "orb_halving", "orb_invert", "orb_invisify", "orb_itemizer", "orb_luminous",
  "orb_pierce", "orb_scanner", "orb_mobile", "orb_mug", "orb_nullify", "orb_mirror", "orb_spurn", "orb_slow",
  "orb_slumber", "orb_petrify", "orb_totter", "orb_invisify", "orb_one_room", "orb_totter", "orb_rebound",
  "orb_revival", "orb_rollcall", "orb_stayaway", "orb_trap_see", "orb_trapbust", "orb_trawl", "orb_weather" }

EQUIPMENT = { "emberfrost_allterrain_gear", "emberfrost_weather_ward", "held_assault_vest", "held_binding_band",
  "held_big_root", "held_black_belt", "held_black_glasses", "held_black_sludge", "held_charcoal",
  "held_choice_band", "held_choice_scarf", "held_choice_specs", "held_cover_band", "held_defense_scarf",
  "held_dragon_scale", "held_expert_belt", "held_friend_bow", "held_goggle_specs", "held_grip_claw",
  "held_hard_stone", "held_heal_ribbon", "held_iron_ball", "held_life_orb", "held_magnet", "held_metal_coat",
  "held_metronome", "held_miracle_seed", "held_mobile_scarf", "held_mystic_water", "held_pass_scarf",
  "held_pierce_band", "held_pink_bow", "held_poison_barb", "held_power_band", "held_reunion_cape",
  "held_ring_target", "held_scope_lens", "held_sharp_beak", "held_shed_shell", "held_shell_bell",
  "held_silk_scarf", "held_silver_powder", "held_soft_sand", "held_special_band", "held_spell_tag",
  "held_sticky_barb", "held_toxic_orb", "held_flame_orb", "held_twist_band", "held_twisted_spoon",
  "held_warp_scarf", "held_weather_rock", "held_wide_lens", "held_x_ray_specs", "held_zinc_band",
  "held_blank_plate", "held_draco_plate", "held_dread_plate", "held_earth_plate", "held_fist_plate",
  "held_flame_plate", "held_icicle_plate", "held_insect_plate", "held_iron_plate", "held_meadow_plate",
  "held_mind_plate", "held_pixie_plate", "held_sky_plate", "held_splash_plate", "held_spooky_plate",
  "held_stone_plate", "held_toxic_plate", "held_zap_plate" }

SEED = { "seed_ban", "seed_blast", "seed_blinker", "seed_decoy", "seed_doom", "seed_golden", "seed_hunger", "seed_ice",
  "seed_joy", "seed_last_chance", "seed_plain", "seed_pure", "seed_reviver", "seed_sleep",       -- "seed_spreader",
  -- "seed_training",
  -- "seed_vanish",
  "seed_vile", "seed_warp" }

WANDS = { "wand_fear",                                                          -- "wand_infatuation",
  "wand_lob", "wand_lure", "wand_path", "wand_pounce", "wand_purge", "wand_slow", -- "wand_stayaway",
  -- "wand_surround",
  "wand_switcher", "wand_topsy_turvy",                                          -- "wand_totter",
  "wand_transfer", "wand_vanish", "wand_warp", "wand_whirlwind" }

PLATES = { "held_blank_plate", "held_draco_plate", "held_dread_plate", "held_earth_plate", "held_fist_plate",
  "held_flame_plate", "held_icicle_plate", "held_insect_plate", "held_iron_plate", "held_meadow_plate",
  "held_mind_plate", "held_pixie_plate", "held_sky_plate", "held_splash_plate", "held_spooky_plate",
  "held_stone_plate", "held_toxic_plate", "held_zap_plate" }

TMS = { "tm_acrobatics", "tm_aerial_ace", "tm_attract", "tm_avalanche", "tm_blizzard", "tm_brick_break", "tm_brine",
  "tm_bulk_up", "tm_bulldoze", "tm_bullet_seed", "tm_calm_mind", "tm_captivate", "tm_charge_beam", "tm_cut",
  "tm_dark_pulse", "tm_dazzling_gleam", "tm_defog", "tm_dig", "tm_dive", "tm_double_team", "tm_dragon_claw",
  "tm_dragon_pulse", "tm_dragon_tail", "tm_drain_punch", "tm_dream_eater", "tm_earthquake", "tm_echoed_voice",
  "tm_embargo", "tm_endure", "tm_energy_ball", "tm_explosion", "tm_facade", "tm_false_swipe", "tm_fire_blast",
  "tm_flame_charge", "tm_flamethrower", "tm_flash", "tm_flash_cannon", "tm_fling", "tm_fly", "tm_focus_blast",
  "tm_focus_punch", "tm_frost_breath", "tm_frustration", "tm_giga_drain", "tm_giga_impact", "tm_grass_knot",
  "tm_gyro_ball", "tm_hail", "tm_hidden_power", "tm_hone_claws", "tm_hyper_beam", "tm_ice_beam", "tm_incinerate",
  "tm_infestation", "tm_iron_tail", "tm_light_screen", "tm_low_sweep", "tm_natural_gift", "tm_nature_power",
  "tm_overheat", "tm_payback", "tm_pluck", "tm_poison_jab", "tm_power_up_punch", "tm_protect", "tm_psych_up",
  "tm_psychic", "tm_psyshock", "tm_quash", "tm_rain_dance", "tm_recycle", "tm_reflect", "tm_rest", "tm_retaliate",
  "tm_return", "tm_roar", "tm_rock_climb", "tm_rock_polish", "tm_rock_slide", "tm_rock_smash", "tm_rock_tomb",
  "tm_roost", "tm_round", "tm_safeguard", "tm_sandstorm", "tm_scald", "tm_secret_power", "tm_shadow_ball",
  "tm_shadow_claw", "tm_shock_wave", "tm_silver_wind", "tm_sky_drop", "tm_sludge_bomb", "tm_sludge_wave",
  "tm_smack_down", "tm_snarl", "tm_snatch", "tm_steel_wing", "tm_stone_edge", "tm_strength", "tm_struggle_bug",
  "tm_substitute", "tm_sunny_day", "tm_surf", "tm_swagger", "tm_swords_dance", "tm_taunt", "tm_telekinesis",
  "tm_thief", "tm_thunder", "tm_thunder_wave", "tm_thunderbolt", "tm_torment", "tm_u_turn", "tm_venoshock",
  "tm_volt_switch", "tm_water_pulse", "tm_waterfall", "tm_whirlpool", "tm_wild_charge", "tm_will_o_wisp",
  "tm_work_up", "tm_x_scissor" }

-- function COMMON.GetTutorableMoves(member, tutor_moves)

-- 	local valid_moves = {}
-- 	local playerMonId = member.BaseForm

-- 	while playerMonId ~= nil do
-- 		local mon = _DATA:GetMonster(playerMonId.Species)
-- 		local form = mon.Forms[playerMonId.Form]

-- 		--for each shared skill
-- 		for move_idx = 0, form.SharedSkills.Count - 1, 1 do
-- 			local move = form.SharedSkills[move_idx].Skill
-- 			local already_learned = member:HasBaseSkill(move)
-- 			if not already_learned and tutor_moves[move] ~= nil then
-- 				--check if the move tutor list contains it as nonspecial
-- 				if not tutor_moves[move].Special then
-- 					valid_moves[move] = tutor_moves[move]
-- 				end
-- 			end
-- 		end
-- 		--for each secret skill
-- 		for move_idx = 0, form.SecretSkills.Count - 1, 1 do
-- 			local move = form.SecretSkills[move_idx].Skill
-- 			local already_learned = member:HasBaseSkill(move)
-- 			if not already_learned and tutor_moves[move] ~= nil then
-- 				--check if the move tutor list contains it as special
-- 				if tutor_moves[move].Special then
-- 					valid_moves[move] = tutor_moves[move]
-- 				end
-- 			end
-- 		end

-- 		if mon.PromoteFrom ~= "" then
-- 		  playerMonId = RogueEssence.Dungeon.MonsterID(mon.PromoteFrom, form.PromoteForm, "normal", Gender.Genderless)
-- 		else
-- 		  playerMonId = nil
-- 		end
-- 	end

--   return valid_moves
-- end

print(GetTM("tm_acrobatics"))

function table.copy(obj, seen)
  if type(obj) ~= 'table' then
    return obj
  end
  if seen and seen[obj] then
    return seen[obj]
  end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
    res[table.copy(k, s)] = table.copy(v, s)
  end
  return res
end

function GetRandomUnique(items, amount)
  local pool = {}
  for i = 1, #items do
    pool[i] = items[i]
  end

  local result = {}
  local count = math.min(amount, #pool)

  for i = 1, count do
    local index = _DATA.Save.Rand:Next(#pool)
    table.insert(result, pool[index])
    table.remove(pool, index)
  end

  return result
end

function SelectItemFromList(prompt, items)
  local ret = {}
  local choose = function(item)
    ret = item
    _MENU:RemoveMenu()
  end
  local refuse = function()
  end
  local menu = ItemSelectionMenu:new(prompt, items, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
  return ret
end
