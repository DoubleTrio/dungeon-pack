require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local rocky_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---rocky_checkpoint.Init(map)
-- Engine callback function

function rocky_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive()
end

---rocky_checkpoint.Enter(map)
-- Engine callback function
function rocky_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---rocky_checkpoint.Exit(map)
-- Engine callback function
function rocky_checkpoint.Exit(map)

end

---rocky_checkpoint.Update(map)
-- Engine callback function
function rocky_checkpoint.Update(map)

end

---rocky_checkpoint.GameSave(map)
-- Engine callback function
function rocky_checkpoint.GameSave(map)

end

---rocky_checkpoint.GameLoad(map)
-- Engine callback function
function rocky_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function rocky_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function rocky_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function rocky_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function rocky_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function rocky_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function rocky_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function rocky_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function rocky_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue()
end

return rocky_checkpoint
