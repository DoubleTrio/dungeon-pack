require 'trios_dungeon_pack.emberfrost.enemy_enchantments.enchants'
local checkpoint_offers = require 'trios_dungeon_pack.emberfrost.checkpoint_offers'
local offers = {}

function offers.GetForCheckpoint()
  local state = SV.EmberFrost.EnemyEnchantments
  local checkpoint = SV.EmberFrost.CheckpointProgression
  if state.OfferCheckpoint ~= checkpoint then
    state.Seen = {}
    state.RerollCounts = {1, 1, 1}
    state.Offers = {}
    state.OfferCheckpoint = checkpoint
  end
  if #state.Offers == 0 then
    local picked = checkpoint_offers.Get("Enemy")
    if #picked < 3 then return nil end
    state.Offers = {{}, {}}
    for i = 1, 3 do
      state.Offers[1][i] = picked[i].id
      if picked[i + 3] then state.Offers[2][i] = picked[i + 3].id end
    end
  end
  local rows = {}
  for i, row in ipairs(state.Offers) do
    rows[i] = {}
    for j, id in ipairs(row) do rows[i][j] = EnemyEnchantmentRegistry:Get(id) end
  end
  return rows
end

return offers
