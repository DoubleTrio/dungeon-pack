local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
local group = {}

function group.HungerStrike(add)
  add({
    rarity = EnchantmentRarity.Common,
    id = "HUNGER_STRIKE_ENEMY",
    name = "Hunger Strike",
    description = "When enemies inflict damage with a move, the target loses 3 hunger points.",
    set_active_effects = function(self, active_effect, zone_context)
      local args = Serpent.line({ EnchantmentID = self.id, StatusID = "emberfrost_hunger_strike_enemy" })
      active_effect.OnMapStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostApplyEnemyEnchantments", args))
      active_effect.OnTurnStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostApplyEnemyEnchantments", args))
    end,
  })
end

return group
