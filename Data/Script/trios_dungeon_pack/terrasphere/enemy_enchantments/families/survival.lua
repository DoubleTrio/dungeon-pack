local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local helpers = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.helpers'
local group = {}

function group.HungerStrike(add)
  add({
    rarity = EnchantmentRarity.Common,
    id = "HUNGER_STRIKE_ENEMY",
    name = "Hunger Strike",
    description = "When enemies inflict damage with a move, the target loses 3 hunger points",
    set_active_effects = function(self, active_effect, zone_context)
      helpers.AddStatusHooks(active_effect, self.id, "terrasphere_hunger_strike_enemy")
    end,
  })
end

return group
