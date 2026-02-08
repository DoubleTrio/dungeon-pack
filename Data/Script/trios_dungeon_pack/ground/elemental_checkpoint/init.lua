require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local elemental_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---elemental_checkpoint.Init(map)
-- Engine callback function

function elemental_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive()
  -- random weather!
  -- GROUND:AddMapStatus("rain")
end

---elemental_checkpoint.Enter(map)
-- Engine callback function
function elemental_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---elemental_checkpoint.Exit(map)
-- Engine callback function
function elemental_checkpoint.Exit(map)

end

---elemental_checkpoint.Update(map)
-- Engine callback function
function elemental_checkpoint.Update(map)

end

---elemental_checkpoint.GameSave(map)
-- Engine callback function
function elemental_checkpoint.GameSave(map)

end

---elemental_checkpoint.GameLoad(map)
-- Engine callback function
function elemental_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function elemental_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function elemental_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function elemental_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function elemental_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function elemental_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function elemental_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function elemental_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function elemental_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue()
end

return elemental_checkpoint
