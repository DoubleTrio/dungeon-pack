require 'origin.common'

local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local frost_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---frost_checkpoint.Init(map)
-- Engine callback function

function frost_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive()
  GROUND:AddMapStatus("snow")
end

---frost_checkpoint.Enter(map)
-- Engine callback function
function frost_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---frost_checkpoint.Exit(map)
-- Engine callback function
function frost_checkpoint.Exit(map)

end

---frost_checkpoint.Update(map)
-- Engine callback function
function frost_checkpoint.Update(map)

end

---frost_checkpoint.GameSave(map)
-- Engine callback function
function frost_checkpoint.GameSave(map)

end

---frost_checkpoint.GameLoad(map)
-- Engine callback function
function frost_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function frost_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()   --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function frost_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()   --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function frost_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function frost_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function frost_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function frost_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function frost_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function frost_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue()
end

return frost_checkpoint

