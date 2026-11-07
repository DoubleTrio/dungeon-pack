local offers = require 'trios_dungeon_pack.terrasphere.enchantments.offers'
require 'trios_dungeon_pack.terrasphere.enemy_enchantments.enchants'
local checkpoint_offers = {}

-- Generate both sets together: every corresponding initial/reroll slot shares a rarity.
function checkpoint_offers.Get(side)
  local state = SV.Terrasphere.CheckpointEnchantmentOffers
  if state.Checkpoint ~= SV.Terrasphere.CheckpointProgression then
    SV.Terrasphere.Enchantments.Seen = {}
    SV.Terrasphere.EnemyEnchantments.Seen = {}
    local player, enemy = offers.GetRandom(6, nil, EnchantmentRegistry, EnemyEnchantmentRegistry)
    state.Player, state.Enemy = {}, {}
    for i, entry in ipairs(player) do state.Player[i] = entry.id end
    for i, entry in ipairs(enemy) do state.Enemy[i] = entry.id end
    state.Checkpoint = SV.Terrasphere.CheckpointProgression
  end
  local registry = side == "Player" and EnchantmentRegistry or EnemyEnchantmentRegistry
  local picked = {}
  for _, id in ipairs(state[side]) do picked[#picked + 1] = registry:Get(id) end
  return picked
end

return checkpoint_offers
