local TypeEHelpers = {}
function TypeEHelpers.MakeApply(item_id)
  return function(self)
    M_HELPERS.GiveInventoryItemsToPlayer({ { Item = item_id, Amount = 1 } })
  end
end

function TypeEHelpers.MakeSetActiveEffects(status_id, _)
  return function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = status_id, EnchantmentID = self.id, ApplyToAll = true })))
  end
end

-- function TypeEHelpers.MakeSetActiveEffects(status_id, types)
--   return function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2,
--       RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches",
--         Serpent.line({ Types = types, StatusID = status_id })))
--   end
-- end
-- RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches", Serpent.line({
--   Types = { "dragon" },
--   StatusID = "emberfrost_draconian_defience",
-- })))

function TypeEHelpers.MakeProgressTexts(element_id)
  return function(self)
    local element = _DATA:GetElement(element_id)
    local icon = element:GetIconName()
    local count = #GetCharacterOfMatchingType(element_id, false)
    return { "Total " .. icon .. " Members: " .. count }
  end
end

-- STEEL
ReinforcedPlating = EnchantmentRegistry:Register({
  name = "Reinforced Plating",
  id = "REINFORCED_PLATING",
  turn_amount = 20,
  shield_percent = 75,
  offer_time = "beginning",
  rarity = 1,
  getDescription = function(self)
    local steel_type = _DATA:GetElement("steel")
    local yellow_apricron = M_HELPERS.GetItemName("apricorn_yellow")
    return string.format("Gain a %s. Each %s in the %s gains a %s attack reduction shield every %s turns not attacked",
      yellow_apricron, steel_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.shield_percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(self.turn_amount, PMDColor.Cyan))
  end,
  getProgressTexts = TypeEHelpers.MakeProgressTexts("steel"),
  set_active_effects = TypeEHelpers.MakeSetActiveEffects("emberfrost_reinforced_plating", { "steel" }),
  apply = TypeEHelpers.MakeApply("apricorn_yellow"),
})

-- DARK
NegativeAura = EnchantmentRegistry:Register({
  name = "Negative Aura",
  id = "NEGATIVE_AURA",
  chance = 50,
  tile_range = 2,
  offer_time = "beginning",
  rarity = 1,
  getDescription = function(self)
    local dark_type = _DATA:GetElement("dark")
    local apricorn_black = M_HELPERS.GetItemName("apricorn_black")
    return string.format(
      "Gain a %s. Each %s type has a %s chance to inflict enemies within %s tiles with a random stat debuff at the end of the turn",
      apricorn_black, dark_type:GetIconName(),
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(self.tile_range, PMDColor.Cyan))
  end,
  getProgressTexts = TypeEHelpers.MakeProgressTexts("dark"),
  set_active_effects = TypeEHelpers.MakeSetActiveEffects("emberfrost_negative_aura", {"dark"}),
  apply = TypeEHelpers.MakeApply("apricorn_black"),
})

-- GROUND
FindYourGround = EnchantmentRegistry:Register({
  name = "Find Your Ground",
  id = "FIND_YOUR_GROUND",
  percent = 40,
  turns = 4,
  offer_time = "beginning",
  rarity = 1,
  getDescription = function(self)
    local ground_type = _DATA:GetElement("ground")
    local brown_apricorn = M_HELPERS.GetItemName("apricorn_brown")
    return string.format(
      "Gain a %s. Each %s type gains a %s attack boost and a %s damage reduction boost if they do not move for %s turns",
      brown_apricorn, ground_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.turns), PMDColor.Cyan))
  end,
  cleanup = function(self)
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      local tbl = LTBL(member)
      tbl["X"] = nil
      tbl["Y"] = nil
    end
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      tbl["X"] = nil
      tbl["Y"] = nil
    end
  end,
  getProgressTexts = TypeEHelpers.MakeProgressTexts("ground"),
  set_active_effects = TypeEHelpers.MakeSetActiveEffects("emberfrost_grounded", { "ground" }),
  apply = TypeEHelpers.MakeApply("apricorn_brown"),
})

return TypeEHelpers
