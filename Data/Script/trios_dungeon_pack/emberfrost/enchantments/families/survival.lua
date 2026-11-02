local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
local group = {}

function group.TreadingThrough(add)
TreadingThrough = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  name = "Treading Through",
  id = "TREADING_THROUGH",
  description = "Gain {Quantity} {Item} (allows the holder to traverse water, lava, and pits)",
  description_vars = {
    Quantity = { value = 2, format = "number" },
    Item = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_allterrain_gear"):GetColoredName() end, format = "text" },
  },
  offer_time = "beginning",

  apply = function(self)
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

end

function group.ThreadsOfLife(add)
ThreadsOfLife = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  name = "Threads of Life",
  id = "THREADS_OF_LIFE",
  description = "Gain a {Item}",
  description_vars = {
    Item = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("evo_harmony_scarf"):GetColoredName() end, format = "text" },
  },
  offer_time = "beginning",

  apply = function(self)
    local items = { {
      Item = "evo_harmony_scarf",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})
-- Gain6500P = add({

--   name = "Gain 6500 " .. PMDSpecialCharacters.Money,
--   id = "GAIN_6500_P",
--   group = ENCHANTMENT_TYPES.money,

--   get_description = function(self)
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

--   end

-- })


end

function group.CalmTheStorm(add)
CalmTheStorm = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  name = "Calm the Storm",
  id = "CALM_THE_STORM",
  description = "Gain a {Item} (allows the holder to eliminate the weather when it is battling)",
  description_vars = {
    Item = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_weather_ward"):GetIconName() end, format = "text" },
  },
  offer_time = "beginning",
  apply = function(self)
    local items = {
      {Item = "emberfrost_weather_ward", Amount = 1 },
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end

})


end

function group.PressureCooker(add)
PressureCooker = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  name = "Pressure Cooker",
  id = "PRESSURE_COOKER",
  amount = 75,
  description = "Your party's moves will deal {amount}% more damage, but cost an additional PP",
  description_vars = {
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = "emberfrost_pressure_cooker", EnchantmentID = self.id, ApplyToAll = true })))
  end
})


end

function group.HungerStrike(add)
HungerStrike = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  name = "Hunger Strike",
  amount = 5,
  id = "HUNGER_STRIKE",
  description = "Your party will lose hunger more quickly when walking. When they inflict damage with a move, the target will lose {amount} hunger {amount:plural:point:points}",
  description_vars = {
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  -- get_progress_texts = function(self)
  --   local char, in_assembly = FindCharacterWithEnchantment(self.id)
  --   local char_name = char and char:GetDisplayName(true) or nil
  --   if char_name then
  --     return {
  --       "Assigned to: " .. char_name,
  --     }
  --   end
  --   return {}
  -- end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
    RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = "emberfrost_hunger_strike", EnchantmentID = self.id, ApplyToAll = true })))
  end,

  apply = function(self)
    -- UI:SetCenter(true)
    -- SOUND:PlayFanfare("Fanfare/Note")
    -- UI:WaitShowDialogue(string.format("Note: Your team will lose %s hunger points when walking.",
    --   M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.SkyBlue)))
    -- UI:SetCenter(false)
  end,
})

end

function group.Minimalist(add)
Minimalist = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  amount = 50,
  name = "Minimalist",
  id = "MINIMALIST",
  description = "At the start of each floor, gain {amount} for each available item slot in your inventory",
  description_vars = {
    amount = { field = "amount", format = "money", space = true },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0

    return { "Total Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- Should occur before the quests are logged
    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("Minimalist", Serpent.line({
      AmountPerSlot = self.amount,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    FanfareText(string.format(
      "You will gain %s for each available item slot in your inventory at the start of each floor!",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})

end

function group.TrapTripper(add)
TrapTripper = add({
  rarity = EnchantmentRarity.Common,
  tags = { "survival" },
  amount = 50,
  name = "Trap Tripper",
  id = "TRAP_TRIPPER",
  description = "For each different trap triggered on a floor, gain {amount}",
  description_vars = {
    amount = { field = "amount", format = "money", space = true },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0

    return { "Total Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- Should occur before the quests are logged
    -- active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("TrapTripper", Serpent.line({
    --   AmountPerSlot = self.amount,
    --   EnchantmentID = self.id
    -- })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    FanfareText(string.format(
      "You will gain %s for each available item slot in your inventory at the start of each floor!",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})



GetCharacterOfMatchingType = function(type, include_assembly)

  -- local count = 0
  local tbl = {}
  for member in luanet.each(_DATA.Save.ActiveTeam.Players) do

    local element1 = member.Element1
    local element2 = member.Element2

    if element1 == type or element2 == type then
      table.insert(tbl, member)
    end
  end


  if include_assembly then
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.EmberfrostRun then

        local element1 = member.Element1
        local element2 = member.Element2

        if element1 == type or element2 == type then
          table.insert(tbl, member)
        end
      end
    end
  end

  return tbl
end



-- Rationalize: This Pokémon's Normal-Type moves are Super Effective to Fairy, Ghosts, and Dragon-Types in exchange for Moves from those Types becoming Super Effective to this Pokémon.
-- https://gamefaqs.gamespot.com/boards/359435-pokemon-violet/80421481

-- Deep Dweller - raises SpD when hit by a water type move 

--  Dark Tranquility - powers down moves of opponents if they move after the pokemon with this ability

-- Daunt - lowers the opponent's speed everytime it enters the field by 1 stage (like intimidate)

-- Deceiver - if any other pokemon on the field boosts its stats, the pokemon with this ability will steal them. Does not affect stats that are lowered or where already boosted before this pokemon entered the field

-- Deep Dweller - raises SpD when hit by a water type move

-- Diver - grants STAB for water type moves

-- Draconian - makes normal type moves dragon type moves and gives them a boost in power

-- Dynamo - regenerates a bit of health when the pokemon uses an electric type move

-- Eco-Maintaining - draining and healing moves have their effect boosted

-- Emperor - moves get a small chance to lower the opponent's defense

-- Explosive Point - when hit by a move that makes contact, it will damage the attacker as well

-- Explosive Swim - when hit by a water or fire type move, it will raise your speed, instead of taking damage

-- Fairy Spore - when this pokemon is on the field, there is a 30% chance that it will infect other pokemon, meaning that they can't use the same move twice in a row

-- Flame Eater - grants immunity to fire type moves. when hit by one, if will raise defense by 1

-- Fortification - raises defense to the max upon taking a critical hit

-- Fruit Picker - steals the opponent's berry upon contact

-- Gardener - grants STAB for grass type pokemon

-- Impersonate - raises 2 stats, based on the opponent's highest stats upon entering the field

-- Ink Body - when hit, it may lower the opponent's accuracy

-- Loud Voice - sound based moves get a boost in power

-- Martialate - normal type moves become fighting type and get a boost in power

-- Misty Body - raises evasion during rain

-- Oneirokinesis - opposing pokemon take damage while asleep after each turn

-- Overmind - doubles the SpA stat

-- Parasitic - draining moves heal more health

-- Petrify - normal type moves become rock type and get a boost in power

-- Plant Body - when hit by a grass type move, it heals 25% HP instead of taking damage

-- Play Dead - grants immunity to normal type moves

-- Moves use up an additional PP, but deal double damahge
-- All enemies iwll have the eablity

-- Power Fume - after every turn there is a chance that the opposing pokemon will be poisoned

-- Protective Shell - doubles the defense stat

-- Protector - raises def and sp.def as long as the pokemon holds an item

-- Psychedelic - raises the power of Psychic type moves

-- Quarantine - grants all pokemon immunity to being poisoned

-- Resentment - raises the attack stat each time a move misses

-- Resilience - raises the SpD stat each time damage is taken

-- Sand Sprinkler - rock and ground type moves get a chance to put the opponent to sleep

-- Scaredy Cat - raises evasion upon entering the field

-- Seismic Thrust - grants priority to ground type moves when at full HP

-- Siren Singer - sound based moves have a chance to trap the opponent

-- Sleepwalker - when asleep, a random move will be selected

-- Sleet - STAB for ice type moves



-- Steel Toe - give a boost in power to kicking moves

-- sticky Nectar - bug type moves will lower the opponents speed stat




-- Spirit Train - boost the power of ghost type moves if they are used consecutively

-- Swirling Souls - raises the attack stat by 1 for every fainted member in your party

-- I like this
-- Resentment - raises the attack stat each time a move misses
-- Portal Creation - all damaging moves get +1 priority if the pokemon with this ability is inflicted with a major status condition


-- Cold-Blooded: Pokémon that use contact moves against this Pokémon have a 30% chance of being frozen. (Ice-type Poison Point)

-- Repulsive: Lower's the opposing team's Sp. Atk by 1 upon entry. Reduces wild Pokémon encounter rate. (special Intimidate)

-- Emergency Guard: When HP is below 1/4 of max, takes 50% less damage from attacks. (Multiscale but for low HP instead of max HP)




-- Portal Creation - all damaging moves get +1 priority if the pokemon with this ability is inflicted with a major status condition

end

return group
