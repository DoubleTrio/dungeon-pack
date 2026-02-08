require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local blaze_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---blaze_checkpoint.Init(map)
-- Engine callback function

function blaze_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive()
  GROUND:AddMapStatus("sunny")
end

---blaze_checkpoint.Enter(map)
-- Engine callback function
function blaze_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---blaze_checkpoint.Exit(map)
-- Engine callback function
function blaze_checkpoint.Exit(map)

end

---blaze_checkpoint.Update(map)
-- Engine callback function
function blaze_checkpoint.Update(map)

end

---blaze_checkpoint.GameSave(map)
-- Engine callback function
function blaze_checkpoint.GameSave(map)

end

---blaze_checkpoint.GameLoad(map)
-- Engine callback function
function blaze_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function blaze_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function blaze_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function blaze_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function blaze_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function blaze_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function blaze_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function blaze_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function blaze_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue()
end

return blaze_checkpoint
