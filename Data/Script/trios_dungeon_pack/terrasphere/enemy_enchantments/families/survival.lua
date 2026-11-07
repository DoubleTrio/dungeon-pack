local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local group = {}

function group.HungerStrike(add)
  add({
    rarity = EnchantmentRarity.Common,
    id = "HUNGER_STRIKE_ENEMY",
    name = "Hunger Strike",
    description = "When enemies inflict damage with a move, the target loses 3 hunger points.",
    set_active_effects = function(self, active_effect, zone_context)
      local args = Serpent.line({ EnchantmentID = self.id, StatusID = "terrasphere_hunger_strike_enemy" })
      active_effect.OnMapStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereApplyEnemyEnchantments", args))
      active_effect.OnTurnStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereApplyEnemyEnchantments", args))
    end,
  })
end

return group
