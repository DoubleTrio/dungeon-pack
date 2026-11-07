local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local group = {}

function group.Hazer(add)
  add({
    id = "HAZER_ENEMY",
    name = "Hazer",
    rarity = EnchantmentRarity.Common,
    turns_between_haze = 100,
    description = "Every {turns} turns on a floor, Haze removes all stat changes from your party. Enemies are unaffected.",
    description_vars = { turns = { field = "turns_between_haze", format = "number" } },
    get_progress_texts = function(self)
      local data = EnemyEnchantmentRegistry:GetData(self)
      local remaining = math.max(0, self.turns_between_haze - (data.Turns or 0))
      return { "Turns until Haze: " .. M_HELPERS.MakeColoredText(tostring(remaining), PMDColor.Cyan) }
    end,
    set_active_effects = function(self, active_effect, zone_context)
      active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereHazer",
        Serpent.line({ EnchantmentID = self.id, Reset = true })))
      active_effect.OnMapTurnEnds:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereHazer",
        Serpent.line({ EnchantmentID = self.id, Turns = self.turns_between_haze })))
    end,
  })
end

return group
