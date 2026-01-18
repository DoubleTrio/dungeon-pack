
require 'origin.menu.team.TeamSelectMenu'
require 'trios_dungeon_pack.menu.ItemSelectionMenu'


ENCHANTMENT_TYPES = {
  items = "ITEMS",
  money = "MONEY",
  power = "POWER"
}

ENCHANTMENT_REGISTRY = ENCHANTMENT_REGISTRY or {}

local count = 0

function RegisterEnchantment(def)
  assert(def.id, "Enchantment must have an id")

  local enchant = setmetatable(def, {
    __index = PowerupDefaults
  })
  ENCHANTMENT_REGISTRY[def.id] = enchant
  count = count + 1
  print(tostring(count))
  return enchant
end

function GetSelectedEnchantments(selected)
  selected = selected or SV.EmberFrost.SelectedEnchantments
  local list = {}
  for _, id in ipairs(selected or {}) do
    local enchant = GetEnchantmentFromRegistry(id)
    if enchant then
      table.insert(list, enchant)
    end
  end
  return list
end

function GetEnchantmentFromRegistry(enchantment_id)
  return ENCHANTMENT_REGISTRY[enchantment_id]
end

function GetRandomEnchantments(amount, total_groups)
  local candidates = {}
  for id, enchant in pairs(ENCHANTMENT_REGISTRY) do
    local seen = SV.EmberFrost.SeenEnchantments[id]

    if not seen and (not enchant.can_apply or enchant:can_apply()) then
      table.insert(candidates, enchant)
    end
  end

  -- TODO: Change the random to C# version... maybe?
  for i = #candidates, 2, -1 do
    local j = math.random(i)
    candidates[i], candidates[j] = candidates[j], candidates[i]
  end

  local result = {}
  for i = 1, math.min(amount, #candidates) do
    local enchant = candidates[i]

    table.insert(result, enchant)
    SV.EmberFrost.SeenEnchantments[enchant.id] = true
  end

  local per_group = math.floor(#result / total_groups)
  local grouped = {}
  for i = 1, total_groups do
    grouped[i] = {}
  end

  for i, enchant in ipairs(result) do
    local group_index = ((i - 1) % total_groups) + 1
    table.insert(grouped[group_index], enchant)
  end

  return grouped
end

function ResetSeenEnchantments()
  SV.EmberFrost.SeenEnchantments = {}
  SV.EmberFrost.EnchantmentData = {}
  SV.EmberFrost.RerollCounts = { 1, 1, 1 }
end

function PrepareNextEnchantment()
  SV.RerollCounts = { 1, 1, 1 }
  SV.EmberFrost.GotEnchantmentFromCheckpoint = false
end

function GetEnchantmentData(enchant)
  local id
  if type(enchant) == "string" then
    id = enchant
  elseif type(enchant) == "table" and enchant.id then
    id = enchant.id
  else
    error("GetEnchantmentData: enchant must be a string or a table with an id")
  end

  local data = SV.EmberFrost.EnchantmentData[id]

  if not data then
    data = {}
    SV.EmberFrost.EnchantmentData[id] = data
  end

  return data
end

local function FindInGroup(count, get, enchant_id)
  for i = count, 1, -1 do
    local p = get(i - 1)
    local tbl = LTBL(p)
    if tbl.SelectedEnchantments and tbl.SelectedEnchantments[enchant_id] then
      return p
    end
  end
end

function FindCharacterWithEnchantment(enchant_id)
  return FindInGroup(GAME:GetPlayerPartyCount(), function(i)
    return GAME:GetPlayerPartyMember(i)
  end, enchant_id) or FindInGroup(GAME:GetPlayerAssemblyCount(), function(i)
    return GAME:GetPlayerAssemblyMember(i)
  end, enchant_id)
end

function HasEnchantment(enchantment_id)
  for _, id in ipairs(SV.EmberFrost.SelectedEnchantments) do
    if id == enchantment_id then
      return true
    end
  end
  return false
end

function AssignCharacterEnchantment(chara, enchantment_id)
  local tbl = LTBL(chara)

  tbl.SelectedEnchantments = tbl.SelectedEnchantments or {}
  tbl.SelectedEnchantments[enchantment_id] = true
end

function FindCharacterWithEnchantment(enchant_id)
  return FindInGroup(GAME:GetPlayerPartyCount(), function(i)
    return GAME:GetPlayerPartyMember(i)
  end, enchant_id) or FindInGroup(GAME:GetPlayerAssemblyCount(), function(i)
    return GAME:GetPlayerAssemblyMember(i)
  end, enchant_id)
end

function ResetCharacterEnchantment(chara)
  local tbl = LTBL(chara)
  tbl.SelectedEnchantments = {}
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
  set_active_effects = function(self, active_effect)
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
  end
}

-- ExpandedSatchel = RegisterEnchantment({
--   name = "Expanded Satchel",
--   id = "EXPANDED_SATCHEL",
--   group = ENCHANTMENT_TYPES.items,

--   bag_increase = 4,

--   getDescription = function(self)
--     return string.format(
--       "Increases the team's bag size by %s for the duration of the dungeon. " ..
--       "Additional bag size of %s in Emberfrost Depths.",
--       M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText("+" .. tostring(self.bag_increase), PMDColor.Cyan)
--     )
--   end,

--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     local old_amount = _ZONE.CurrentZone.BagSize
--     _ZONE.CurrentZone.BagSize = old_amount + self.bag_increase

--     UI:SetCenter(true)
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:WaitShowDialogue(
--       string.format(
--         "Your team's bag size has increased by %d! (%d -> %d)",
--         M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan),
--         M_HELPERS.MakeColoredText(tostring(old_amount), PMDColor.Cyan),
--         M_HELPERS.MakeColoredText(tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan)
--       )
--     )
--     UI:SetCenter(false)
--   end,

--   getProgressTexts = function(self)
--     return {
--       "Current Bag Size: " .. M_HELPERS.MakeColoredText(tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan)
--     }
--   end,

--   progress = function(self)
--     _ZONE.CurrentZone.BagSize =
--       _ZONE.CurrentZone.BagSize + self.bag_increase
--   end,
-- })

-- AllTerrainTreads = RegisterEnchantment({
--   name = "Treading Through",
--   id = "ALL_TERRAIN_TREADS",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_allterrain_gear")
--     return string.format(
--       "Gain %s " ..  entry:GetColoredName() ..  " (allows the holder to traverse water, lava, and pits)",
--       M_HELPERS.MakeColoredText("2", PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add to other inventory
--     local items = {
--       { Item = "emberfrost_allterrain_gear", Amount = 1 },
--       { Item = "emberfrost_allterrain_gear", Amount = 1 },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- Gain5000P = RegisterEnchantment({



--   name = "Gain 5000 " .. STRINGS:Format("\\uE024"),
--   id = "GAIN_5000_P",
--   group = ENCHANTMENT_TYPES.money,

--   getDescription = function(self)
--     return "Gain 5000 " .. STRINGS:Format("\\uE024")
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 5000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 5,000 " .. STRINGS:Format("\\uE024") .. "!")
--     UI:SetCenter(false)

--   end,

-- })


-- Gain7000P = RegisterEnchantment({



--   name = "Gain 7,000 " .. STRINGS:Format("\\uE024"),
--   id = "GAIN_7000_P",
--   group = ENCHANTMENT_TYPES.money,
--   getDescription = function(self)
--     return "Gain 7000 " .. STRINGS:Format("\\uE024")
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 7000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 7000 " .. STRINGS:Format("\\uE024") .. "!")
--     UI:SetCenter(false)

--   end,

-- }, { __index = PowerupDefaults })


-- Gain9000P = setmetatable({
--   name = "Gain 9000 " .. STRINGS:Format("\\uE024"),
--   id = "GAIN_9000_P",
--   group = ENCHANTMENT_TYPES.money,
--   getDescription = function(self)
--     return "Gain 9000 " .. STRINGS:Format("\\uE024")
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 9000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 9000 " .. STRINGS:Format("\\uE024") .. "!")
--     UI:SetCenter(false)

--   end,

-- }, { __index = PowerupDefaults })


-- CalmTheStorm = RegisterEnchantment({
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



-- MysteryEnchant = RegisterEnchantment({
--   gold_amount = 1000,
--   name = "Mystery Enchant",
--   id = "MYSTERY_ENCHANT",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self) 
--     return string.format("Gain a random enchantment and %s.", M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan))
--   end,
  
--   getProgressTexts = function(self)
--     local data = GetEnchantmentData(self)
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
--     local data = GetEnchantmentData(self)

--     data["selected_enchantment"] = enchantment.id

--     enchantment:apply()

--     table.insert(SV.EmberFrost.SelectedEnchantments, enchantment.id)

--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.gold_amount
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained " .. tostring(self.gold_amount) .. " " .. STRINGS:Format("\\uE024") .. "!")
--     UI:SetCenter(false)

--   end,


-- })

PrimalMemory = RegisterEnchantment({
  name = "Primal Memory",
  id = "PRIMAL_MEMORY",
  amount = 2,
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format(
      "Select a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("egg moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      recall_box
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,
  apply = function(self)



    local selected_char = AssignEnchantmentToCharacter(self)

    SetMovesRelearnable(selected_char, true, false)

    local items = {}
 
    for i = 1, self.amount do
      table.insert(items, { Item = "machine_recall_box", Amount = 1 })
    end
  
    M_HELPERS.GiveInventoryItemsToPlayer(items)
    
  end,
})

EliteTutoring = RegisterEnchantment({
  name = "Elite Tutoring",
  id = "ELITE_TUTORING",
  amount = 1,
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format(
      "Select a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("tutoring moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      recall_box
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,
  apply = function(self)



    local selected_char = AssignEnchantmentToCharacter(self)

    SetMovesRelearnable(selected_char, false, true)

    local items = {}
 
    for i = 1, self.amount do
      table.insert(items, { Item = "machine_recall_box", Amount = 1 })
    end
  
    M_HELPERS.GiveInventoryItemsToPlayer(items)
    
  end,
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


-- SticksAndStones = RegisterEnchantment({
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
-- MayBreakMyBones = RegisterEnchantment({
--   amount = 9,
--   percent = 50,

--   name = "...Break My Bones",
--   id = "BREAK_MY_BONES",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SticksAndStones.id)
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


-- WordsWillNever = RegisterEnchantment({

--   name = "...Words Will Never",
--   id = "WORDS_WILL_NEVER",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(MayBreakMyBones.id)
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



-- BuriedTreasures = RegisterEnchantment({
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



-- Pacifist = RegisterEnchantment({
--   gold_amount = 500,
--   name = "Pacifist",
--   id = "PACIFIST",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Select a character. When that character deals no damage for the floor, gain %s the following floor.",
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
--     )
--   end,


--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_pacifist", EnchantmentID = self.id })))
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

-- RiskyMoves = RegisterEnchantment({
--   gold_amount = 10000,
--   total_floors = 5,
--   name = "Risky Moves",
--   id = "RISKY_MOVES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Your team cannot use items for %s floors. Gain %s afterwards",
--       M_HELPERS.MakeColoredText(tostring(self.total_floors), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
--     )
--   end,
  

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--   end,
-- })


HandsTied = RegisterEnchantment({
  gold_amount = 20000,
  name = "Hands Tied",
  id = "HANDS_TIED",
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Gain %s. The team cannot use %s until the next checkpoint",
      M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)
    )
  end,

  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_embargo", EnchantmentID = self.id, ApplyToAll = true })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    SOUND:PlayFanfare("Fanfare/Note")
		UI:WaitShowDialogue(string.format("Note: Your team cannot use %s until the next checkpoint.", M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
  end,
})



-- When an enemy is hit. Only 1 enemy can be marked at a time.
Marksman = RegisterEnchantment({
  increased_damage_percent = 25,
  name = "Marksman",
  id = "MARKSMAN",
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Select a team member. When that member hits an enemy, that enemy is %s. %s enemies take %s more damage from all sources. Only one enemy can be %s at a time.",
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue),
      M_HELPERS.MakeColoredText("Marked", PMDColor.Blue),
      M_HELPERS.MakeColoredText(tostring(self.increased_damage_percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring("1") .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue)
    )
  end,


  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_marksman", EnchantmentID = self.id })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})

-- FeelTheBurn = RegisterEnchantment({
--   name = "Feel the Burn",
--   chance = 15,
--   id = "FEEL_THE_BURN",
--   group = ENCHANTMENT_TYPES.items,
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

--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_fire_speed_boost", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })


GlassCannon = RegisterEnchantment({
  name = "Glass Cannon",
  id = "GLASS_CANNON",
  attack_boost = 50,
  defense_drop = 50,
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. That member will deal %s more damage but take %s more damage",
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_glass_cannon", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})


Sponge = RegisterEnchantment({
  name = "Sponge",
  id = "SPONGE",
  attack_boost = 50,
  defense_drop = 50,
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. That member will take %s less damage but deal %s less damage",
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_sponge", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})



-- MonoMoves = RegisterEnchantment({
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

--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })

Ravenous = RegisterEnchantment({
  name = "Ravenous",
  id = "RAVENOUS",
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. That member deals %s the more hungrier. At very low hunger, that member has a chance to be %s",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow),
      "confused"
      --  M_HELPERS.MakeColoredText("confused", PMDColor.Red)
      -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_ravenous", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})

-- wwww
-- OneTrick
-- MonoMoves = RegisterEnchantment({
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

  -- set_active_effects = function(self, active_effect)
  --   active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
  -- end,

  -- apply = function(self)
  --   AssignEnchantmentToCharacter(self)
  -- end,
-- })
-- HungerStrike = RegisterEnchantment({
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

--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_hunger_strike", EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })



PandorasItems = RegisterEnchantment({
  amount = 1,
  name = "Pandora's Items",
  id = "PANDORAS_ITEMS",
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Gain %s random %s and %s. At the start of each floor, any non-held %s or %s are randomized",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("equipment", PMDColor.Pink),
      M_HELPERS.MakeColoredText("orb", PMDColor.Pink),
      M_HELPERS.MakeColoredText("equipments", PMDColor.Pink),
      M_HELPERS.MakeColoredText("orbs", PMDColor.Pink)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = GetEnchantmentData(self)
    local equipment = data["equipment"]
    local orb = data["orb"]

    local equipment_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(equipment)
    local orb_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(orb)
    local text = {
      "Equipment: " .. equipment_entry:GetIconName(),
      "Orb: " .. orb_entry:GetIconName(),
    }

    return text
  end,

  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PandorasItems"))
  end,

  apply = function(self)
    local random_orb_index = math.random(#ORBS)
    local random_orb = ORBS[random_orb_index]
    local random_equipment_index = math.random(#EQUIPMENT)
    local random_equipment = EQUIPMENT[random_equipment_index]
    local amount = self.amount
    local items = {
      { Item = random_equipment, Amount = amount },
      { Item = random_orb, Amount = amount },
    }

    local data = GetEnchantmentData(self)
    data["equipment"] = random_equipment
    data["orb"] = random_orb


    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end,
})

-- YourAWizard = RegisterEnchantment({
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

    
--     local data = GetEnchantmentData(self)
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

--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_wizard", EnchantmentID = self.id })))
--     -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)

--     local data = GetEnchantmentData(self)
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

-- PlantYourSeeds = RegisterEnchantment({
--   money = 300,
--   amount = 3,
--   minimum = 6,
--   name = "Plant Your Seeds",
--   id = "PLANT_YOUR_SEEDS",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Gain %s random %s. At the start of each floor, if you have at least non-held %s, lose all of them and gain %s for each seed",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText("seeds", PMDColor.Pink),
--       M_HELPERS.MakeColoredText(tostring(self.minimum), PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.money) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
    
--     local data = GetEnchantmentData(self)
--     local seeds = data["seeds"]
--     local money_earned = data["money_earned"]

--     local str_arr = {
--       "Recieved: ",
--     }
--     for _, seed in ipairs(seeds) do
--         local seed_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(seed)
--         local seed_name = seed_entry:GetIconName()
--         table.insert(str_arr, seed_name)
--     end

    

--     -- TODO: Account for the player is holding the seeds...
--     local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
--     local seed_index_arr = {}
--     for i = inv_count, 0, -1 do
--         local item = _DATA.Save.ActiveTeam:GetInv(i)
--         local item_id = item.ID
--         if Contains(SEED, item_id) then
--             table.insert(seed_index_arr, i)
--         end        
--     end

--     table.insert(str_arr, "\n")
--     table.insert(str_arr, "Seed Count: " .. M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan))
--     table.insert(str_arr, "Money Earned: " .. M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan))
    
    
--     return str_arr
--   end,

--   set_active_effects = function(self, active_effect)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
--   end,

--   apply = function(self)

--     local data = GetEnchantmentData(self)
--     data["seeds"] = {}
--     data["money_earned"] = 0

--     local items = {}

--     for i = 1, self.amount do
--         local random_seed_index = math.random(#SEED)
--         local seed = SEED[random_seed_index]

--         table.insert(data["seeds"], seed)

  
--         table.insert(items, { Item = seed, Amount = 1 })
--     end

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,
-- })



ExitStrategy = RegisterEnchantment({
  pure_seed_amount = 2,
  warp_wands_amount = 9,
  salac_amount = 3,
  name = "Exit Strategy",
  id = "EXIT_STRATEGY",
  group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local warp_scarf = M_HELPERS.GetItemName("held_warp_scarf")
    local pure_seed = M_HELPERS.GetItemName("seed_pure")
    local warp_wand_name = M_HELPERS.GetItemName("wand_warp")


    return string.format(
      "Select a team member. They will see the direction of the stairs at the start of each floor. Gain a %s, %s %s, %s %s, and %s %s.",
      warp_scarf,
      M_HELPERS.MakeColoredText(tostring(self.pure_seed_amount), PMDColor.Cyan),
      pure_seed,
      M_HELPERS.MakeColoredText(tostring(self.warp_wands_amount), PMDColor.Cyan),
      warp_wand_name,
      M_HELPERS.MakeColoredText(tostring(self.salac_amount), PMDColor.Cyan),
      M_HELPERS.GetItemName("berry_salac")
    )
  end,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,
  offer_time = "beginning",
  rarity = 1,
  -- getProgressTexts = function(self)
    
  --   local data = GetEnchantmentData(self)
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
  --   table.insert(str_arr, "Money Earned: " .. M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan))
    
    
  --   return str_arr
  -- end,

  -- set_active_effects = function(self, active_effect)
    -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
  -- end,


  set_active_effects = function(self, active_effect)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_stairs_sensor", EnchantmentID = self.id })))
  end,


  apply = function(self)

    local items = {
      { Item= "held_warp_scarf", Amount = 1 },
      { Item ="wand_warp", Amount = self.warp_wands_amount },
    }
    
    for i = 1, self.pure_seed_amount do
        table.insert(items, { Item="seed_pure", Amount = 1 })
    end

    for i = 1, self.salac_amount do
        table.insert(items, { Item="berry_salac", Amount = 1 })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
    AssignEnchantmentToCharacter(self)
  end,
})
-- TheBubble = RegisterEnchantment({
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
--       STRINGS:Format("\\uE024"),
--       M_HELPERS.MakeColoredText(tostring(self.pop_increase) .. "%", PMDColor.Cyan))
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local data = GetEnchantmentData(self)
--     local money_earned = data["money_earned"] or 0
--     local money_lost = data["money_lost"] or 0
--     local pop_chance = data["pop_chance"] or 0

--     return { "Money Earned: " ..
--     M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan),
--       "Money Lost: " ..
--       M_HELPERS.MakeColoredText(tostring(money_lost) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Red),
--       "Current Pop Chance: " .. M_HELPERS.MakeColoredText(tostring(pop_chance) .. "%", PMDColor.Cyan) }
--   end,

--   set_active_effects = function(self, active_effect)
--     -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
--   end,

--   apply = function(self)
--     local data = GetEnchantmentData(self)
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

-- StackOfPlates = RegisterEnchantment({
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

--     local data = GetEnchantmentData(self)
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
--     local data = GetEnchantmentData(self)
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
-- Fashionable = RegisterEnchantment({
--   "for each unique specs or googles"

-- })
-- 
-- Minimalist - The less items in intentory, the more damage
-- SupplyDrop - Gain essential items aftrer every checkpoint (Apples, Reviver Seeds, Orbs, Sticks, Seeds, Oran, Sitrus Berry, Apricorn)
-- Dazzling - Choose a character. For each equipment, lower the accuracy of the target
-- RunAndGun - Projectiles deal more damage if your team has a speed boost, depends on it
-- Fitness - Each food item grants more hunger points, boosts to yourself
-- For 10 denmies fainted with an ammo,
-- Precision - Choose a team member. That team member. Moves that have less than 80% accuracy cannot miss. Moves with accuracy will miss more often
-- BluePrint - Select a team member. Gain tms. Select a tm, gain two randoms ones. Gain a recall box.
-- TaskMaster - Complete various task to gain money. Defeat 10 enemies with mon. Reach hunger 20. Use 3 seeds. Use an orb. Complete a floor with items.
-- All for one - Choose a team member. That members gains for power for each team member within 1 tile.
-- One for all - Choose a team member. That members transfer ALL status to all adjacent allies upon recieiving a status.
-- Team Building - Gain 3 big apricorns and 2 amber tears and a friend bow
-- Gummi Overload - Gain 5 random gummies. Each gummy grants +1 max hunger.
-- Death Defying - Gain a death amulet.
-- I C - Gain an X-ray specs. Your team can see invisible traps.
-- Harmony Scarf - Gain a harmony scarf.
-- Huddle - Defense
-- Moral Support / Support from Beyond - Gain a damage boost for each tea m member alive in the assembly
-- Berry Nutritious - At the start of each floor, if you have at least 5 berries, each party member gains 2 random stat boosts,
-- Tempo - Select a team member. That member gains a random permanetent stat boost for every 10
-- Solo Mission - When your team has only 1 member, that member does more damage
-- Avenger - Dead teammates = more damage
-- Ravenous - More damage when low on hunger
-- Hoarder - More money when you have more items in your inventory
-- Fitness Routine - Speed boost when your team has more than 75% hunger (ewwww, better)
-- Full Belly Happy Heart
-- Nitroglycerin - Speed boost when low on hunger
-- Choose a character. Super-effective moves deal less damage
-- Bargainer: Half off from shop. I don’t know why, but I feel like giving everything to you half off now
-- Affluent: Calculate the cost of inventory. Do damage based on total. Easier to recruit monsters.
-- Ranged: Select a team member. That member gets +1 tange.
-- Underdogs: Your team does more damage when lower leveled than the enemy
-- Immunity: Choose a team member. That member is immune to negative status effects.
-- Treausre Tracker: Gain a trackr. Will reveal buried within 20 tiles
-- Eviolite: If held by a Pokémon that is not fully evolved, its Defense and Special Defense are raised by 50%.
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
--  That member only has one move, but that move deals more damage.
-- StandGround - Standing in spot leaves a post which gains an attack boost
-- Leader 
-- Trick Shot - Arc projectiles do more damage
-- Vitamins Gummmies - 
-- Minimalist - The less items in intentory, the more damage 
-- Gain a random vitamin fo 
-- Life-Steal+
-- 3-1 Special - Gain 
--  Ranged+: Select a team member. That member gets +1 tange.

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

function AssignEnchantmentToCharacter(enchant)
    local ret = {}
    local choose = function(chars)
        ret = chars
        _MENU:RemoveMenu()
    end
    local refuse = function() end
    local menu = TeamMultiSelectMenu:new(string.format("Assign %s to?", M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)), _DATA.Save.ActiveTeam.Players, function() return true end, choose, refuse)
    UI:SetCustomMenu(menu.menu)
    UI:WaitForChoice()
 

    local selected_char = ret[1]
    AssignCharacterEnchantment(selected_char, enchant.id)
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(
      string.format(
        "%s got the %s enchantment!",
        selected_char:GetDisplayName(true),
        M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)
      )
    )
    UI:SetCenter(false)
    return selected_char
end



ORBS = {
  "orb_all_dodge", 
  "orb_all_protect", 
  "orb_cleanse", 
  "orb_devolve", 
  "orb_fill_in", 
  "orb_endure", 
  "orb_foe_hold", 
  "orb_foe_seal", 
  "orb_freeze", 
  "orb_halving", 
  "orb_invert", 
  "orb_invisify", 
  "orb_itemizer", 
  "orb_luminous", 
  "orb_pierce", 
  "orb_scanner", 
  "orb_mobile", 
  "orb_mug", 
  "orb_nullify", 
  "orb_mirror", 
  "orb_spurn", 
  "orb_slow", 
  "orb_slumber", 
  "orb_petrify", 
  "orb_totter", 
  "orb_invisify", 
  "orb_one_room", 
  "orb_totter", 
  "orb_rebound",
  "orb_revival",  
  "orb_rollcall", 
  "orb_stayaway", 
  "orb_trap_see", 
  "orb_trapbust", 
  "orb_trawl", 
  "orb_weather", 
}


EQUIPMENT = {
  "emberfrost_allterrain_gear",
  "emberfrost_weather_ward",
  "held_assault_vest",
  "held_binding_band",
  "held_big_root",
  "held_black_belt",
  "held_black_glasses",
  "held_black_sludge",
  "held_charcoal",
  "held_choice_band",
  "held_choice_scarf",
  "held_choice_specs",
  "held_cover_band",
  "held_defense_scarf",
  "held_dragon_scale",
  "held_expert_belt",
  "held_friend_bow",
  "held_goggle_specs",
  "held_grip_claw",
  "held_hard_stone",
  "held_heal_ribbon",
  "held_iron_ball",
  "held_life_orb",
  "held_magnet",
  "held_metal_coat",
  "held_metronome",
  "held_miracle_seed",
  "held_mobile_scarf",
  "held_mystic_water",
  "held_pass_scarf",
  "held_pierce_band",
  "held_pink_bow",
  "held_poison_barb",
  "held_power_band",
  "held_reunion_cape",
  "held_ring_target",
  "held_scope_lens",
  "held_sharp_beak",
  "held_shed_shell",
  "held_shell_bell",
  "held_silk_scarf",
  "held_silver_powder",
  "held_soft_sand",
  "held_special_band",
  "held_spell_tag",
  "held_sticky_barb",
  "held_toxic_orb",
  "held_flame_orb",
  "held_twist_band",
  "held_twisted_spoon",
  "held_warp_scarf",
  "held_weather_rock",
  "held_wide_lens",
  "held_x_ray_specs",
  "held_zinc_band",
  "held_blank_plate",
  "held_draco_plate",
  "held_dread_plate",
  "held_earth_plate",
  "held_fist_plate",
  "held_flame_plate",
  "held_icicle_plate",
  "held_insect_plate",
  "held_iron_plate",
  "held_meadow_plate",
  "held_mind_plate",
  "held_pixie_plate",
  "held_sky_plate",
  "held_splash_plate",
  "held_spooky_plate",
  "held_stone_plate",
  "held_toxic_plate",
  "held_zap_plate",
}

SEED = {
  "seed_ban",
  "seed_blast",
  "seed_blinker",
  "seed_decoy",
  "seed_doom",
  "seed_golden",
  "seed_hunger",
  "seed_ice",
  "seed_joy",
  "seed_last_chance",
  "seed_plain",
  "seed_pure",
  "seed_reviver",
  "seed_sleep",
  -- "seed_spreader",
  -- "seed_training",
  -- "seed_vanish",
  "seed_vile",
  "seed_warp",
}


WANDS = {
  "wand_fear",
  -- "wand_infatuation",
  "wand_lob",
  "wand_lure",
  "wand_path",
  "wand_pounce",
  "wand_purge",
  "wand_slow",
  -- "wand_stayaway",
  -- "wand_surround",
  "wand_switcher",
  "wand_topsy_turvy",
  -- "wand_totter",
  "wand_transfer",
  "wand_vanish",
  "wand_warp",
  "wand_whirlwind"
}

PLATES = {
  "held_blank_plate",
  "held_draco_plate",
  "held_dread_plate",
  "held_earth_plate",
  "held_fist_plate",
  "held_flame_plate",
  "held_icicle_plate",
  "held_insect_plate",
  "held_iron_plate",
  "held_meadow_plate",
  "held_mind_plate",
  "held_pixie_plate",
  "held_sky_plate",
  "held_splash_plate",
  "held_spooky_plate",
  "held_stone_plate",
  "held_toxic_plate",
  "held_zap_plate",
}

TMS = {
  "tm_acrobatics",
  "tm_aerial_ace",
  "tm_attract",
  "tm_avalanche",
  "tm_blizzard",
  "tm_brick_break",
  "tm_brine",
  "tm_bulk_up",
  "tm_bulldoze",
  "tm_bullet_seed",
  "tm_calm_mind",
  "tm_captivate",
  "tm_charge_beam",
  "tm_cut",
  "tm_dark_pulse",
  "tm_dazzling_gleam",
  "tm_defog",
  "tm_dig",
  "tm_dive",
  "tm_double_team",
  "tm_dragon_claw",
  "tm_dragon_pulse",
  "tm_dragon_tail",
  "tm_drain_punch",
  "tm_dream_eater",
  "tm_earthquake",
  "tm_echoed_voice",
  "tm_embargo",
  "tm_endure",
  "tm_energy_ball",
  "tm_explosion",
  "tm_facade",
  "tm_false_swipe",
  "tm_fire_blast",
  "tm_flame_charge",
  "tm_flamethrower",
  "tm_flash",
  "tm_flash_cannon",
  "tm_fling",
  "tm_fly",
  "tm_focus_blast",
  "tm_focus_punch",
  "tm_frost_breath",
  "tm_frustration",
  "tm_giga_drain",
  "tm_giga_impact",
  "tm_grass_knot",
  "tm_gyro_ball",
  "tm_hail",
  "tm_hidden_power",
  "tm_hone_claws",
  "tm_hyper_beam",
  "tm_ice_beam",
  "tm_incinerate",
  "tm_infestation",
  "tm_iron_tail",
  "tm_light_screen",
  "tm_low_sweep",
  "tm_natural_gift",
  "tm_nature_power",
  "tm_overheat",
  "tm_payback",
  "tm_pluck",
  "tm_poison_jab",
  "tm_power_up_punch",
  "tm_protect",
  "tm_psych_up",
  "tm_psychic",
  "tm_psyshock",
  "tm_quash",
  "tm_rain_dance",
  "tm_recycle",
  "tm_reflect",
  "tm_rest",
  "tm_retaliate",
  "tm_return",
  "tm_roar",
  "tm_rock_climb",
  "tm_rock_polish",
  "tm_rock_slide",
  "tm_rock_smash",
  "tm_rock_tomb",
  "tm_roost",
  "tm_round",
  "tm_safeguard",
  "tm_sandstorm",
  "tm_scald",
  "tm_secret_power",
  "tm_shadow_ball",
  "tm_shadow_claw",
  "tm_shock_wave",
  "tm_silver_wind",
  "tm_sky_drop",
  "tm_sludge_bomb",
  "tm_sludge_wave",
  "tm_smack_down",
  "tm_snarl",
  "tm_snatch",
  "tm_steel_wing",
  "tm_stone_edge",
  "tm_strength",
  "tm_struggle_bug",
  "tm_substitute",
  "tm_sunny_day",
  "tm_surf",
  "tm_swagger",
  "tm_swords_dance",
  "tm_taunt",
  "tm_telekinesis",
  "tm_thief",
  "tm_thunder",
  "tm_thunder_wave",
  "tm_thunderbolt",
  "tm_torment",
  "tm_u_turn",
  "tm_venoshock",
  "tm_volt_switch",
  "tm_water_pulse",
  "tm_waterfall",
  "tm_whirlpool",
  "tm_wild_charge",
  "tm_will_o_wisp",
  "tm_work_up",
  "tm_x_scissor",
}



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
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do res[table.copy(k, s)] = table.copy(v, s) end
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
        local index = math.random(#pool)
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
    local refuse = function() end
    local menu = ItemSelectionMenu:new(prompt, items, choose, refuse)
    UI:SetCustomMenu(menu.menu)
    UI:WaitForChoice()
    return ret
end