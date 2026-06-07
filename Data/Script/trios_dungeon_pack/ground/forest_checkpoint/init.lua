require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local forest_checkpoint = {}

-- electric_surge 	Electric Surge 	Turns the ground into Electric Terrain when the Pokémon is battling.
-- psychic_surge 	Psychic Surge 	Turns the ground into Psychic Terrain when the Pokémon is battling.
-- misty_surge 	Misty Surge 	Turns the ground into Misty Terrain when the Pokémon is battling.
-- grassy_surge 	Grassy Surge 	Turns the ground into Grassy Terrain when the Pokémon is battling.

-- -------------------------
-- Map Callbacks
-------------------------------
---forest_checkpoint.Init(map)
-- Engine callback function

function forest_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive(0)
  GROUND:AddMapStatus("fog")
end

---forest_checkpoint.Enter(map)
-- Engine callback function
function forest_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---forest_checkpoint.Exit(map)
-- Engine callback function
function forest_checkpoint.Exit(map)

end

---forest_checkpoint.Update(map)
-- Engine callback function
function forest_checkpoint.Update(map)

end

---forest_checkpoint.GameSave(map)
-- Engine callback function
function forest_checkpoint.GameSave(map)

end

---forest_checkpoint.GameLoad(map)
-- Engine callback function
function forest_checkpoint.GameLoad(map)
  GAME:FadeIn(20)
end

function forest_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function forest_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function forest_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function forest_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function forest_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function forest_checkpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function forest_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function forest_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function forest_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue(obj, activator)
end

return forest_checkpoint
