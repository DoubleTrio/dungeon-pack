local offers = require 'trios_dungeon_pack.emberfrost.enchantments.offers'
require 'trios_dungeon_pack.emberfrost.enemy_enchantments.enchants'
local checkpoint_offers = {}

-- Generate both sets together: every corresponding initial/reroll slot shares a rarity.
function checkpoint_offers.Get(side)
  local state = SV.EmberFrost.CheckpointEnchantmentOffers
  if state.Checkpoint ~= SV.EmberFrost.CheckpointProgression then
    SV.EmberFrost.Enchantments.Seen = {}
    SV.EmberFrost.EnemyEnchantments.Seen = {}
    local player, enemy = offers.GetRandom(6, nil, EnchantmentRegistry, EnemyEnchantmentRegistry)
    state.Player, state.Enemy = {}, {}
    for i, entry in ipairs(player) do state.Player[i] = entry.id end
    for i, entry in ipairs(enemy) do state.Enemy[i] = entry.id end
    state.Checkpoint = SV.EmberFrost.CheckpointProgression
  end
  local registry = side == "Player" and EnchantmentRegistry or EnemyEnchantmentRegistry
  local picked = {}
  for _, id in ipairs(state[side]) do picked[#picked + 1] = registry:Get(id) end
  return picked
end

return checkpoint_offers
