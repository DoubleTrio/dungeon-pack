local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
return function(add)
SafeguardPlus = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Safeguard+",
  id = "SAFEGUARD_PLUS",
  description = "Choose a team member. That member gains a permanent {Status} for the rest of the dungeon",
  description_vars = {
    Status = { get = function(self) return _DATA:GetStatus("safeguard"):GetColoredName() end, format = "text" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_safeguard_permanent",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Ravenous = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Ravenous",
  id = "RAVENOUS",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. That member deals {Damage} the hungrier they are. At very low hunger, that member has a chance to be confused",
  description_vars = {
    Damage = { value = "more damage", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
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


Avenger = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Avenger",
  id = "AVENGER",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. That member deals {Damage} the more members that are fainted in the party",
  description_vars = {
    Damage = { value = "more damage", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
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

CriticalSuccess = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Critical Success!",
  id = "CRITICAL_SUCCESS",
  percent = 50,
  description = "Choose a team member. Their attacks will have an additional {percent} chance to land a critical hit",
  description_vars = {
    percent = { field = "percent", format = "percent" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_critical_success",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

-- LockedIn = add({
--   name = "LockedIn",
--   id = "LOCKED_IN",
--   percent = 50,
--   get_description = function(self)
--     return string.format(
--       "Every third hit from the chosen team member will hit the target.",

--       M_HELPERS.FormatPercent(self.percent, PMDColor.Cyan)
--     )
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   get_progress_texts = function(self)
--     local char, in_assembly = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil
--     if char_name then
--       return { "Assigned to: " .. char_name }
--     end
--     return {}
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2,
--       RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
--         StatusID = "emberfrost_critical_success",
--         EnchantmentID = self.id
--       })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end
-- })


DoubleUp = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Double Up!",
  id = "DOUBLE_UP",
  damage_reduction = 60,
  description = "Choose a team member. Their moves will strike twice as much but deal {damage_reduction} less damage per hit.",
  description_vars = {
    damage_reduction = { field = "damage_reduction", format = "percent", color = "Red" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_double_up",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

PrimalMemory = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Primal Memory",
  id = "PRIMAL_MEMORY",
  amount = 2,
  description = "Choose a team member. That member can now remember any {Moves}. Gain {amount} {RecallBox}",
  description_vars = {
    Moves = { value = "egg moves", format = "text", color = "Yellow" },
    RecallBox = { get = function(self) return M_HELPERS.GetItemName("machine_recall_box") end, format = "text" },
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)
    SetMovesRelearnable(selected_char, true, false, false)
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


Blueprint = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Blueprint",
  id = "BLUEPRINT",
  tm_amount = 2,
  recall_amount = 1,
  total_choices = 5,
  description = "Choose a team member. Gain {tm_amount} random {tm_amount:plural:TM:TMs} that member learns and then select another one (TMs will be randomized if not possible). Gain a {RecallBox}",
  description_vars = {
    RecallBox = { get = function(self) return M_HELPERS.GetItemName("machine_recall_box") end, format = "text" },
    tm_amount = { field = "tm_amount", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self, false)
    local possible_skills = GetMemberSkills(selected_char, false, false, true)
    local seen = {}
    local tm_items = {}

    -- First, add TMs from possible_skills
    for i = 1, math.min(self.tm_amount, #possible_skills) do
      local rand_skill = GetRandomUnique(possible_skills, 1, seen)[1]
      seen[rand_skill] = true
      table.insert(tm_items, {
        Item = "tm_" .. rand_skill,
        Amount = 1
      })
    end

    -- If we need more TMs, get from TMs pool
    local remaining = self.tm_amount - #tm_items
    if remaining > 0 then
      local additional_tms = GetRandomUnique(TMS, remaining, seen)
      for _, tm in ipairs(additional_tms) do
        seen[tm] = true
        table.insert(tm_items, {
          Item = tm,
          Amount = 1
        })
      end
    end

    M_HELPERS.GiveInventoryItemsToPlayer(tm_items)

    -- Select 5 TMs for the choice menu (prioritize possible_skills, then add from TMs pool)
    local choice_pool = {}
    local choice_seen = {}

    -- Add up to 5 from possible_skills first
    for i = 1, math.min(self.total_choices, #possible_skills) do
      local rand_skill = GetRandomUnique(possible_skills, 1, choice_seen)[1]
      choice_seen[rand_skill] = true
      table.insert(choice_pool, {
        Item = "tm_" .. rand_skill,
        Amount = 1
      })
    end

    -- Fill remaining slots from TMs pool
    local remaining_choices = 5 - #choice_pool
    if remaining_choices > 0 then
      local additional_choices = GetRandomUnique(TMS, remaining_choices, choice_seen)
      for _, tm in ipairs(additional_choices) do
        table.insert(choice_pool, {
          Item = tm,
          Amount = 1
        })
      end
    end

    local result = SelectItemFromList(
      string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
      choice_pool
    )

    GAME:WaitFrames(20)
    M_HELPERS.GiveInventoryItemsToPlayer({ result })

    local items = {}

    for i = 1, self.recall_amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

EliteTutoring = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Elite Tutoring",
  id = "ELITE_TUTORING",
  amount = 1,
  description = "Choose a team member. That member can now remember any {Moves}. Gain {amount} {RecallBox}",
  description_vars = {
    Moves = { value = "tutoring moves", format = "text", color = "Yellow" },
    RecallBox = { get = function(self) return M_HELPERS.GetItemName("machine_recall_box") end, format = "text" },
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)

    SetMovesRelearnable(selected_char, false, true, false)

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


-- When an enemy is hit. Only 1 enemy can be marked at a time.
Marksman = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  increased_damage_percent = 25,
  name = "Marksman",
  id = "MARKSMAN",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. When that member hits an enemy, that enemy is {Marked}. {CapitalMarked} enemies take {increased_damage_percent} more damage from all sources. Only one enemy can be {ExistingLimitText} at a time.",
  description_vars = {
    Marked = { value = "marked", format = "text", color = "Blue" },
    CapitalMarked = { value = "Marked", format = "text", color = "Blue" },
    increased_damage_percent = { field = "increased_damage_percent", format = "percent" },
    ExistingLimitText = { value = 1, format = "percent" },
  },

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_marksman",
        EnchantmentID = self.id
      })))
  end,
  offer_time = "beginning",
  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

FeelTheBurn = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Feel the Burn",
  chance = 15,
  id = "FEEL_THE_BURN",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. When that member is hit by a {Fire} move, they will take {chance} additional damage and gain a speed boost",
  description_vars = {
    Fire = { get = function(self) return _DATA:GetElement("fire"):GetIconName() end, format = "text" },
    chance = { field = "chance", format = "percent" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = "emberfrost_fire_speed_boost", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})

GlassCannon = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Glass Cannon",
  id = "GLASS_CANNON",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. That member will deal {attack_boost} more damage but take {defense_drop} more damage",
  description_vars = {
    attack_boost = { field = "attack_boost", format = "percent" },
    defense_drop = { field = "defense_drop", format = "percent", color = "Red" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
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

Sponge = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Sponge",
  id = "SPONGE",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. That member will take {defense_drop} less damage but deal {attack_boost} less damage",
  description_vars = {
    defense_drop = { field = "defense_drop", format = "percent" },
    attack_boost = { field = "attack_boost", format = "percent", color = "Red" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
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

-- Vampiric = add({
--   name = "Vampiric",
--   id = "VAMPIRIC",
--   attack_boost = 50,
--   -- group = ENCHANTMENT_TYPES.items,
--   get_description = function(self)
--     return string.format("Choose a team member. That member will t",
--       M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Red))
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   get_progress_texts = function(self)
--     local char, in_assembly = FindCharacterWithEnchantment(self.id)
--     local char_name = char and char:GetDisplayName(true) or nil
--     if char_name then
--       return { "Assigned to: " .. char_name }
--     end
--     return {}
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2,
--       RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
--         StatusID = "emberfrost_sponge",
--         EnchantmentID = self.id
--       })))
--   end,

--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end
-- })

MonoMoves = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  name = "Mono Moves",
  id = "MONO_MOVES",
  attack_boost = 35,
  description = "Choose a team member. If all their moves are the {SameType}, that member deals {attack_boost} more damage.",
  description_vars = {
    SameType = { value = "same type", format = "text", color = "Yellow" },
    attack_boost = { field = "attack_boost", format = "percent" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})

ExitStrategy = add({
  rarity = EnchantmentRarity.Common,
  tags = { "characters" },
  pure_seed_amount = 2,
  warp_wands_amount = 9,
  salac_amount = 3,
  name = "Exit Strategy",
  id = "EXIT_STRATEGY",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Choose a team member. They will see the direction of the stairs at the start of each floor. Gain a {Scarf}, {pure_seed_amount} {Seed}, {warp_wands_amount} {Wand}, and {salac_amount} {Berry}.",
  description_vars = {
    Scarf = { get = function(self) return M_HELPERS.GetItemName("held_warp_scarf") end, format = "text" },
    Seed = { get = function(self) return M_HELPERS.GetItemName("seed_pure") end, format = "text" },
    Wand = { get = function(self) return M_HELPERS.GetItemName("wand_warp") end, format = "text" },
    Berry = { get = function(self) return M_HELPERS.GetItemName("berry_salac") end, format = "text" },
    pure_seed_amount = { field = "pure_seed_amount", format = "number" },
    warp_wands_amount = { field = "warp_wands_amount", format = "number" },
    salac_amount = { field = "salac_amount", format = "number" },
  },
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  offer_time = "beginning",
  -- get_progress_texts = function(self)

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

end
