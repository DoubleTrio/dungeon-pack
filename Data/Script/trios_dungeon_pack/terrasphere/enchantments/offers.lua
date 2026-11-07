local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local config = require 'trios_dungeon_pack.terrasphere.config'
local offers = {}
local rarity_order = { EnchantmentRarity.Common, EnchantmentRarity.Epic, EnchantmentRarity.Legendary }

function offers.GetRandom(amount, total_groups, registry, paired_registry)
  registry = registry or EnchantmentRegistry
  local probabilities = config.enchantment_rarity_probabilities
  local total = 0
  for _, rarity in ipairs(rarity_order) do
    local probability = probabilities[rarity]
    assert(type(probability) == "number" and probability >= 0 and probability <= 100,
      "Invalid enchantment rarity probability: " .. rarity)
    total = total + probability
  end
  assert(math.abs(total - 100) < 0.000001, "Enchantment rarity probabilities must total 100")

  local pools = {}
  local paired_pools = {}
  for _, rarity in ipairs(rarity_order) do
    if probabilities[rarity] > 0 then
      pools[rarity] = registry:GetRandom(amount, nil, rarity)
      if paired_registry then
        paired_pools[rarity] = paired_registry:GetRandom(amount, nil, rarity)
      end
    end
  end

  local picked, paired = {}, {}
  for i = 1, amount do
    local available_weight = 0
    for _, rarity in ipairs(rarity_order) do
      if pools[rarity] and #pools[rarity] > 0
          and (not paired_registry or #paired_pools[rarity] > 0) then
        available_weight = available_weight + probabilities[rarity]
      end
    end
    if available_weight == 0 then break end
    local roll
    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      roll = _DATA.Save.Rand:Next(1000000) / 1000000 * available_weight
    else
      roll = math.random() * available_weight
    end
    local cumulative = 0
    for _, rarity in ipairs(rarity_order) do
      local pool = pools[rarity]
      if pool and #pool > 0 and (not paired_registry or #paired_pools[rarity] > 0) then
        cumulative = cumulative + probabilities[rarity]
        if roll < cumulative then
          picked[#picked + 1] = table.remove(pool, 1)
          if paired_registry then paired[#paired + 1] = table.remove(paired_pools[rarity], 1) end
          break
        end
      end
    end
  end

  if not total_groups then return picked, paired end
  local grouped = {}
  for i = 1, total_groups do grouped[i] = {} end
  for i, entry in ipairs(picked) do
    table.insert(grouped[((i - 1) % total_groups) + 1], entry)
  end
  return grouped
end

return offers
