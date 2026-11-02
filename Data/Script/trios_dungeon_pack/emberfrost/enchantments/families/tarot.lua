local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
local ConcatTables = require('trios_dungeon_pack.emberfrost.enchantments.runtime').ConcatTables

local group = {}

function group.TarotCards(add)
TarotCards = add({
  rarity = EnchantmentRarity.Common,
  tags = { "tarot" },
  name = "Tarot Cards",
  id = "TAROT_CARDS",
  description = "Gain a {Apricorn}. For each {Psychic} in the {Party}, draw a card and apply a random effect at the start of each floor",
  description_vars = {
    Apricorn = { get = function(self) return M_HELPERS.GetItemName("apricorn_purple") end, format = "text" },
    Psychic = { get = function(self) return _DATA:GetElement("psychic"):GetIconName() end, format = "text" },
    Party = { value = "active party", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local psychic_type = _DATA:GetElement("psychic")
    local icon = psychic_type:GetIconName()

    local count = #GetCharacterOfMatchingType("psychic", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,


  set_active_effects = function(self, active_effect, zone_context)


    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("TarotCards", Serpent.line({
      EnchantmentID = self.id,
      Type = "psychic",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_purple",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})




TarotRegistry = CreateRegistry({
  registry_table = {},
  defaults = TarotDefaults,
})

TarotRegistry:Register({
  id = "THE_HERMIT",
  name = "The Hermit",
  -- amount = 500,
  apply = function(self, owner, ownerChar, context, args)
    -- local money = _DATA.Save.
    local randval = _DATA.Save.Rand:Next(200, 1001)
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + randval
    _DUNGEON:LogMsg(string.format("%s: You gained %s!", M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
    M_HELPERS.MakeColoredText(tostring(randval) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})

local function CreateStatusTarot(id, name, statusId, stackCount)
  return {
    id = id,
    name = name,
    apply = function(self, owner, ownerChar, context, args)
      local entry = _DATA:GetStatus(statusId)
      local statusName = entry.Name:ToLocal()

      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
        "{0}: Your team gain [a/an] {1} boost!",
        M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
        statusName
      ))

      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(statusId, false, false, stackCount)
        local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.None)
        mock_context.User = member
        TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
      end
    end
  }
end

TarotRegistry:Register(CreateStatusTarot("THE_TOWER", "The Tower", "mod_defense", 1))
TarotRegistry:Register(CreateStatusTarot("THE_HIGH_PRIESTESS", "The High Priestess", "mod_special_defense", 1))


TarotRegistry:Register(CreateStatusTarot("THE_EMPRESS", "The Empress", "mod_special_attack", 1))
TarotRegistry:Register(CreateStatusTarot("THE_EMPEROR", "The Emperor", "mod_attack", 1))


TarotRegistry:Register(CreateStatusTarot("THE_CHARIOT", "The Chariot", "mod_speed", 1))

TarotRegistry:Register(CreateStatusTarot("THE_HIEROPHANT", "The Hierophant", "mod_accuracy", 1))
TarotRegistry:Register(CreateStatusTarot("THE_DEVIL", "The Devil", "mod_evasion", 1))


TarotRegistry:Register({
  id = "THE_WORLD",
  name = "The World",
  amount = 500,
  apply = function(self, owner, ownerChar, context, args, member)

    local name = member:GetDisplayName(true)
    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
      "{0}: {1} has revealed the layout of the floor!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      name
    ))

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
    mock_context.User = member
    local level_event = PMDC.Dungeon.MapOutRadiusEvent(25)
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
  end
})


  -- local string_key = args.StringKey
  -- local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(status, false, false, 1)
  -- local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
  -- mock_context.User = context.User
  -- local stack = context.User:GetStatusEffect(status)
  -- if stack ~= nil then
  --   local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
  --   if s.Stack < max_stack then
  --     ResetEffectTile(owner)
  --     TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
  --   else
  --     local msg = RogueEssence.StringKey(string_key):ToLocal()
  --     _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
  --   end
    
  -- else
  --   ResetEffectTile(owner)
  --   TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
--   end
-- end


TarotRegistry:Register({
  id = "WHEEL_OF_FORTUNE",
  name = "Wheel of Fortune",
  add_as_status = true,
  apply = function(self, owner, ownerChar, context, args, member)
    local wheel_choice = WheelOfFortuneRegistry:GetRandom(1, 1)[1][1]

    local choices = {
      { "Accept", true },
      { "Decline",  true },
    }

    local question = wheel_choice:getQuestion(member)
    UI:BeginChoiceMenu(string.format("%s: %s", M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan), question), choices, 1, 2)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()

    if result == 1 then
      local roll = _DATA.Save.Rand:Next(100)
      if roll < wheel_choice.chance then
        wheel_choice:yes_choice(owner, ownerChar, context, args, member)
      else
        
        _DUNGEON:LogMsg(M_HELPERS.MakeColoredText("Nope!", PMDColor.Magenta))
        wheel_choice:roll_fail(owner, ownerChar, context, args, member)
      end
    else
      wheel_choice:no_choice(owner, ownerChar, context, args, member)
    end

    GAME:WaitFrames(30)
  end
})

WheelOfFortuneRegistry = CreateRegistry({
  registry_table = {},
  defaults = WheelOfFortuneDefaults,
})

WheelOfFortuneDefaults = {
  -- On Map Starts
  getQuestion = function(self, member)
    return "add question"
  end,

  roll_fail = function(owner, ownerChar, context, args, member)
  end,

  yes_choice = function(owner, ownerChar, context, args, member)
  end,

  no_choice = function(owner, ownerChar, context, args, member)
  end
}

WheelOfFortuneRegistry:Register({
  id = "FAINT_MEMBER",
  amount = 5000,
  chance = 100,

  getQuestion = function(self)
    return string.format("Take a %s to gain %s or a random team member faints. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,

  roll_fail = function(owner, ownerChar, context, args)
    local candidates = {}

    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      if not member.Dead then
        table.insert(candidates, member)
      end
    end


    local mem = GetRandomFromArray(candidates)

    SOUND:PlayBattleSE('DUN_Hit_Neutral')
    TASK:WaitTask(mem:InflictDamage(9999))

    if not mem.Dead then
      beholder.trigger("OnNotToday")
    end

  end,

  yes_choice = function(self, owner, ownerChar, context, args)
    -- SOUND:
    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("Gained %s!", M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    
    -- M_HELPERS.MakeColoredText("Gained %s", ))
    -- _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.amount
  
  end,

  no_choice = function(self, owner, ownerChar, context, args)
  end
})

WheelOfFortuneRegistry:Register({
  id = "REMOVE_INVENTORY",
  chance = 25,


  getQuestion = function(self, member)
    local value = GetInventoryCost()

    return string.format("Take a %s to gain %s or remove all items in your inventory. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(value .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,

  roll_fail = function(self, owner, ownerChar, context, args)
    M_HELPERS.RemoveAllInventory()
  end,

  yes_choice = function(self, owner, ownerChar, context, args)
    local value = GetInventoryCost()

    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("Gained %s!", M_HELPERS.MakeColoredText(tostring(value) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + value



        -- M_HELPERS.MakeColoredText("Gained %s", ))
  
    -- SOUND:
    -- SOUND:PlayBattleSE('DUN_Money')
    -- _DUNGEON:LogMsg(string.format("Gained %s!",
    --   M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))

    -- M_HELPERS.MakeColoredText("Gained %s", ))
    -- _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.amount
  end,

  no_choice = function(self, owner, ownerChar, context, args)
  end
})




WheelOfFortuneRegistry:Register({
  id = "REMOVE_LEVELS",
  chance = 35,
  gain = 5,
  lose = 3,

  getQuestion = function(self, member)
    local name = member:GetDisplayName(true)

    return string.format("Take a %s for %s to gain %s levels or lose %s levels. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      name,
      M_HELPERS.MakeColoredText(tostring(self.gain), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.lose), PMDColor.Cyan)
  )
  end,

  roll_fail = function(self, owner, ownerChar, context, args, member)

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
    mock_context.User = member
    local level_event = PMDC.Dungeon.LevelChangeEvent(-self.lose, false)
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
    -- print("AKAAKAAKKA")
    TASK:WaitTask(_DUNGEON:CheckEXP())
  end,
  yes_choice = function(self, owner, ownerChar, context, args, member)
    print(tostring(member))

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.None)
    mock_context.User = member

    local level_event = PMDC.Dungeon.LevelChangeEvent(-self.gain, false)
    print(tostring(level_event))
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
    -- print("MMDDMDMDM")
    TASK:WaitTask(_DUNGEON:CheckEXP())
   
  end,

  no_choice = function(self, owner, ownerChar, context, args, member)

  end
})


local function CreateItemTarot(id, name, itemIds, count)

  count = count or 1
  return {
    id = id,
    name = name,
    apply = function(self, owner, ownerChar, context, args, member)

      local picked_item = GetRandomFromArray(itemIds)

      local arguments = {
        MinAmount = 0,
        MaxAmount = 0,
        Guaranteed = {
          {
            { Item = picked_item, Amount = count, Weight = 10 }
          }
        },
        Items = {},
        MaxRangeWidth = 2,
        MaxRangeHeight = 2,
        UseUserCharLoc = true
      }

      local itemName = M_HELPERS.GetItemName(picked_item, count)
      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
        "{0}: You received a {1}!",
        M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
        itemName
      ))

      GAME:WaitFrames(10)
      context.User = member
      SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
    end
  }
end

TarotRegistry:Register(CreateItemTarot("THE_SUN", "The Sun", { "evo_sun_stone" }))
TarotRegistry:Register(CreateItemTarot("THE_MOON", "The Moon", { "evo_moon_stone" }))
TarotRegistry:Register(CreateItemTarot("THE_STAR", "The Star", {"loot_star_piece"}))
TarotRegistry:Register(CreateItemTarot("DEATH", "The Hanged Man", { "orb_one_shot" }))
TarotRegistry:Register(CreateItemTarot("THE_FOOL", "The Fool", { "orb_invisify" }))
TarotRegistry:Register(CreateItemTarot("JUSTICE", "Justice", { "orb_rebound" }))
TarotRegistry:Register(CreateItemTarot("THE_HANGED_MAN", "Death", { "seed_reviver" }))
TarotRegistry:Register(CreateItemTarot("STRENGTH", "Strength", { "tm_strength" }))
TarotRegistry:Register(CreateItemTarot("THE_LOVERS", "The Lover", ConcatTables(APRICORNS, { "loot_heart_scale" })))


TarotRegistry:Register(CreateItemTarot("THE_MAGICIAN", "The Magician", WANDS, 9))


TarotRegistry:Register({
  id = "TEMPERANCE",
  name = "Temperance",
  apply = function(self, owner, ownerChar, context, args)
    local inv = GetInventoryCost()
    local value = math.min(math.floor(inv / 5), 2000)

    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("%s: Gained %s!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(value) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + value
  end
})

TarotRegistry:Register({
  id = "JUDGEMENT",
  name = "Judgement",
  apply = function(self, owner, ownerChar, context, args)
    local sound = "DUN_Gummi"
    SOUND:PlayBattleSE(sound)

    local stat = GetRandomStat()
    local stat_text = RogueEssence.Text.ToLocal(stat)

    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar("{0}: All members in the active party gained [a/an] {1} stat boost!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      stat_text)
    )


    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      BoostStat(stat, 1, member)
    end
    
  end
})

TarotDefaults = {
  apply = function(owner, ownerChar, context, args)    
  end
}


end

return group
