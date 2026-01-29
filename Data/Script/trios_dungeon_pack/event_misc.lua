require 'trios_dungeon_pack.helpers'

beholder = require 'trios_dungeon_pack.beholder'
function ITEM_SCRIPT.WishItemPickupEvent(owner, ownerChar, context, args)
  if not SV.Wishmaker.MadeWish then
    return
  end
  if context.Item.IsMoney then
    return
  end
  
	SV.Wishmaker.BonusScore = SV.Wishmaker.BonusScore + context.Item:GetSellValue()

  local amount = context.Item.Amount
  if amount == 0 then
    amount = 1
  end
 
  GAME:GivePlayerStorageItem(context.Item.Value, amount)
  while amount > 0 do
    local slot = GAME:FindPlayerItem(context.Item.Value, false, true)
    local index = slot.Slot
    GAME:TakePlayerBagItem(index, false)
    amount = amount - 1
  end
  SV.Wishmaker.TempItemString = context.Item:GetDungeonName()

  -- _DUNGEON:LogMsg("The " .. context.Item:GetDungeonName() .. " was sent to the storage!")
end




function ITEM_SCRIPT.EmberfrostOnPickups(owner, ownerChar, context, args)
  print("EmberfrostOnPickups triggered")
  beholder.trigger("OnPickups", owner, ownerChar, context, args)
end

function SPAWN_SCRIPT.EmberfrostWaterTraveler(owner, ownerChar, context, a, av)
  print("EmberfrostWaterTraveler triggered")
  print(tostring(context))
    print(tostring(owner))

        print(tostring(ownerChar))
end