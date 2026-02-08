require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local cove_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---cove_checkpoint.Init(map)
-- Engine callback function

function cove_checkpoint.Init(map)
  PlayRandomBGM()
  checkpoint.OnCheckpointArrive()
  GROUND:AddMapStatus("rain")
end

---cove_checkpoint.Enter(map)
-- Engine callback function
function cove_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---cove_checkpoint.Exit(map)
-- Engine callback function
function cove_checkpoint.Exit(map)

end

---cove_checkpoint.Update(map)
-- Engine callback function
function cove_checkpoint.Update(map)

end

---cove_checkpoint.GameSave(map)
-- Engine callback function
function cove_checkpoint.GameSave(map)

end

---cove_checkpoint.GameLoad(map)
-- Engine callback function
function cove_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function cove_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function cove_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function cove_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function cove_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function cove_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function cove_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function cove_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function cove_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue()
end

return cove_checkpoint
