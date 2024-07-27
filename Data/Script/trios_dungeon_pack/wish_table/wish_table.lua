require 'trios_dungeon_pack.wish_table.wish_table_tier0'
require 'trios_dungeon_pack.wish_table.wish_table_tier1'
require 'trios_dungeon_pack.wish_table.wish_table_tier2'
require 'trios_dungeon_pack.wish_table.wish_table_tier3'
require 'trios_dungeon_pack.wish_table.wish_table_tier4'
require 'trios_dungeon_pack.wish_table.wish_table_tier5'
require 'trios_dungeon_pack.wish_table.wish_table_dungeon'

FINAL_WISH_TABLE = {
  FINAL_WISH_TABLE_TIER_0,
  FINAL_WISH_TABLE_TIER_1,
  FINAL_WISH_TABLE_TIER_2,
  FINAL_WISH_TABLE_TIER_3,
  FINAL_WISH_TABLE_TIER_4,
  FINAL_WISH_TABLE_TIER_5,
}

local all_wish_tables = {
  DUNGEON_WISH_TABLE,
  FINAL_WISH_TABLE_TIER_0,
  FINAL_WISH_TABLE_TIER_1,
  FINAL_WISH_TABLE_TIER_2,
  FINAL_WISH_TABLE_TIER_3,
  FINAL_WISH_TABLE_TIER_4,
  FINAL_WISH_TABLE_TIER_5,
  -- FINAL_WISH_TABLE_TIER_1,
  -- FINAL_WISH_TABLE_TIER_1,
  -- FINAL_WISH_TABLE_TIER_1
}
--[[
TIER 0:
Ordinary Wish Table

Money: 9500.0
Food: 538.78947368421
Utility: 2091.4813218391
Equipment: 3044.8717948718
Power:  3470.1660516605
Recruitment: 2860.0

Should be around 30% increase
TIER 1:
Money: 
Food:
Utility:
Equipment:
Power:
Recruitment:

Should be around 40% increase
TIER 2:
Money:
Food:
Utility:
Equipment:
Power:
Recruitment:

Should be around 50% increase
TIER 3:
Money:
Food:
Utility:
Equipment:
Power:
Recruitment:

Should be around 60% increase
TIER 4:
Money:
Food:
Utility:
Equipment:
Power:
Recruitment:

TIER 5:
Money:
Food:
Utility:
Equipment:
Power:
Recruitment:
--]]

function ExpectedValue(tb)
  local mid = (tb.Min + tb.Max) * 0.5
  local expected_value = 0

  if tb.AlwaysSpawn ~= nil then
    for _, item_name in ipairs(tb.AlwaysSpawn) do
      local item_entry = _DATA:GetItem(item_name)
      local price = item_entry.Price
      expected_value = expected_value + price
    end
  end

  for _, guaurantee_entries in ipairs(tb.Guaranteed) do
    -- FIRST SUM THE WEIGHTS...
    local total_weight = 0
    for _, entry in ipairs(guaurantee_entries) do
      -- print(tostring(entry))
      total_weight = total_weight + entry.Weight
    end
    -- print(tostring("Weight: ") .. weight)
    
    -- local total_price = 0
    local lc_expected = 0
    for _, entry in ipairs(guaurantee_entries) do
      if entry.Item == "money" then
        local price = entry.Amount
        lc_expected = lc_expected + (price * (entry.Weight / total_weight))
        -- expected = 
        -- total_price = total_price + price
      else
        local item = _DATA:GetItem(entry.Item)
        local price = (item.Price * entry.Amount)
        lc_expected = lc_expected + (price * (entry.Weight / total_weight))
        -- total_price = total_price + price
      end
    end
    -- print(tostring(lc_expected))
    expected_value = expected_value + lc_expected
  end


  local total_weight = 0

  for _, entry in ipairs(tb.Items) do
    total_weight = total_weight + entry.Weight
  end

  local lc_expected = 0
  for _, entry in ipairs(tb.Items) do

    if entry.Item == "money" then
      local price = entry.Amount
      lc_expected = lc_expected + (price * (entry.Weight / total_weight))
    else
      local item = _DATA:GetItem(entry.Item)
      local price = (item.Price * entry.Amount)
      lc_expected = lc_expected + (price * (entry.Weight / total_weight))
    end
  end

  print("CATEGORY: " .. tb.Category)
  print("GURANTEED EXPECTED: " .. expected_value)
  print("RANDOM ROLL EXPECTED: " .. lc_expected * mid)
  expected_value = expected_value + (lc_expected * mid)
  print("TOTAL EXPECTED: " .. expected_value)
  print("")
  return expected_value
end

-- local arr_name = { "wish_table_dungeon", "wish_table_tier0", "wish_table_tier1", "wish_table_tier2", "wish_table_tier3", "wish_table_tier4", "wish_table_tier5"}
-- for i, wish_table in ipairs(all_wish_tables) do
--   print("============================")
--   print(arr_name[i])
--   print("============================")
--   print()
--   for _, wish_entry in ipairs(wish_table) do
--     if wish_entry.Category == "Money" then
--       ExpectedValue(wish_entry)
--     end
--   end
-- end
-- -- all_wish_tables
-- for _, wish_entry in ipairs(DUNGEON_WISH_TABLE) do
--   ExpectedValue(wish_entry)
-- end