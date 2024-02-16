ITEM_SCRIPT = {}



-- public object GetPlayerBagItem(int slot)
-- {
--     return DataManager.Instance.Save.ActiveTeam.GetInv(slot);
-- }

-- /// <summary>
-- /// Remove an item from player inventory
-- /// </summary>
-- /// <param name="slot">The slot from which to remove the item</param>
-- /// <param name="takeAll"></param>
-- public void TakePlayerBagItem(int slot, bool takeAll = false)

function ITEM_SCRIPT.WishItemPickupEvent(owner, ownerChar, context, args)

  if not GAME:InRogueMode() then
    SV.Wishmaker.BonusScore = SV.Wishmaker.BonusScore + context.Item:GetSellValue()
  end

  if not SV.Wishmaker.MadeWish then
    return
  end
  if context.Item.IsMoney then
    return
  end

  local amount = context.Item.Amount
  if amount == 0 then
    amount = 1
  end
 
  -- public void TakePlayerBagItem(int slot, bool takeAll = false)
  --InvSlot FindPlayerItem(string id, bool held, bool inv)
  -- HANDLE THE EDGE CASE FOR STACKS...
  GAME:GivePlayerStorageItem(context.Item.Value, amount)
  while amount > 0 do
    local slot = GAME:FindPlayerItem(context.Item.Value, false, true)
    local index = slot.Slot
    GAME:TakePlayerBagItem(index, false)
    amount = amount - 1
  end
  SV.Wishmaker.TempItemString = context.Item:GetDungeonName()

  -- _DUNGEON:LogMsg("The " .. context.Item:GetDungeonName() .. " was sent to the storage!")
  
  -- if GAME:InRogueMode() then
    -- GAME:GivePlayerStorageItem(context.Item)
    -- GAME:AddToPlayerMoneyBank(10)
  -- end
end