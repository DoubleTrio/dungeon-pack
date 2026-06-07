SafeguardPlus = EnchantmentRegistry:Register({
  name = "Safeguard+",
  id = "SAFEGUARD_PLUS",
  get_description = function(self)
    local status = _DATA:GetStatus("safeguard")
    return string.format("Choose a team member. That member gains a permanent %s for the rest of the dungeon",
      status:GetColoredName())
  end,
  offer_time = "beginning",
  rarity = 1,
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

Ravenous = EnchantmentRegistry:Register({
  name = "Ravenous",
  id = "RAVENOUS",
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    return string.format(
      "Choose a team member. That member deals %s the more hungrier. At very low hunger, that member has a chance to be %s",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow),
      "confused" --  M_HELPERS.MakeColoredText("confused", PMDColor.Red)
    -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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


Avenger = EnchantmentRegistry:Register({
  name = "Avenger",
  id = "AVENGER",
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    return string.format("Choose a team member. That member deals %s the more members that are fainted in the party",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
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

CriticalSuccess = EnchantmentRegistry:Register({
  name = "Critical Success!",
  id = "CRITICAL_SUCCESS",
  percent = 50,
  get_description = function(self)
    return string.format(
      "Choose a team member. Their attacks will have an additional %s chance to land a critical hit",
      M_HELPERS.FormatPercent(self.percent, PMDColor.Cyan)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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

-- LockedIn = EnchantmentRegistry:Register({
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


DoubleUp = EnchantmentRegistry:Register({
  name = "Double Up!",
  id = "DOUBLE_UP",
  damage_reduction = 60,
  get_description = function(self)
    return string.format(
      "Choose a team member. Their moves will strike twice as much but deal %s less damage per hit.",
      M_HELPERS.FormatPercent(self.damage_reduction, PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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

PrimalMemory = EnchantmentRegistry:Register({
  name = "Primal Memory",
  id = "PRIMAL_MEMORY",
  amount = 2,
  get_description = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Choose a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("egg moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
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


Blueprint = EnchantmentRegistry:Register({
  name = "Blueprint",
  id = "BLUEPRINT",
  tm_amount = 2,
  recall_amount = 1,
  total_choices = 5,
  get_description = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format(
      "Choose a team member. Gain %s random TMs that member learns and then select another one (TMs will be randomized if not possible). Gain a %s",
      M_HELPERS.MakeColoredText(self.tm_amount, PMDColor.Cyan),
      recall_box
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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

EliteTutoring = EnchantmentRegistry:Register({
  name = "Elite Tutoring",
  id = "ELITE_TUTORING",
  amount = 1,
  get_description = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Choose a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("tutoring moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
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
Marksman = EnchantmentRegistry:Register({
  increased_damage_percent = 25,
  name = "Marksman",
  id = "MARKSMAN",
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    return string.format(
      "Choose a team member. When that member hits an enemy, that enemy is %s. %s enemies take %s more damage from all sources. Only one enemy can be %s at a time.",
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

FeelTheBurn = EnchantmentRegistry:Register({
  name = "Feel the Burn",
  chance = 15,
  id = "FEEL_THE_BURN",
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    local element = _DATA:GetElement("fire")
    return string.format(
      "Choose a team member. When that member is hit by a %s move, they will take %s additional damage and gain a speed boost",
      element:GetIconName(),
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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

GlassCannon = EnchantmentRegistry:Register({
  name = "Glass Cannon",
  id = "GLASS_CANNON",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    return string.format("Choose a team member. That member will deal %s more damage but take %s more damage",
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
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

Sponge = EnchantmentRegistry:Register({
  name = "Sponge",
  id = "SPONGE",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    return string.format("Choose a team member. That member will take %s less damage but deal %s less damage",
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
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

-- Vampiric = EnchantmentRegistry:Register({
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

MonoMoves = EnchantmentRegistry:Register({
  name = "Mono Moves",
  id = "MONO_MOVES",
  attack_boost = 35,
  get_description = function(self)
    return string.format(
      "Choose a team member. If all their moves are the %s, that member deals %s more damage.",
      M_HELPERS.MakeColoredText("same type", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan)
    -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
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

ExitStrategy = EnchantmentRegistry:Register({
  pure_seed_amount = 2,
  warp_wands_amount = 9,
  salac_amount = 3,
  name = "Exit Strategy",
  id = "EXIT_STRATEGY",
  -- group = ENCHANTMENT_TYPES.items,
  get_description = function(self)
    local warp_scarf = M_HELPERS.GetItemName("held_warp_scarf")
    local pure_seed = M_HELPERS.GetItemName("seed_pure")
    local warp_wand_name = M_HELPERS.GetItemName("wand_warp")

    return string.format(
      "Choose a team member. They will see the direction of the stairs at the start of each floor. Gain a %s, %s %s, %s %s, and %s %s.",
      warp_scarf, M_HELPERS.MakeColoredText(tostring(self.pure_seed_amount), PMDColor.Cyan), pure_seed,
      M_HELPERS.MakeColoredText(tostring(self.warp_wands_amount), PMDColor.Cyan), warp_wand_name,
      M_HELPERS.MakeColoredText(tostring(self.salac_amount), PMDColor.Cyan), M_HELPERS.GetItemName("berry_salac"))
  end,
  get_progress_texts = function(self)
    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  offer_time = "beginning",
  rarity = 1,
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
