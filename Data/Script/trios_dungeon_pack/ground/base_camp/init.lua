require 'origin.common'

local base_tbl = require('origin.ground.base_camp')

local base_camp = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function base_camp.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_base_camp")
  
  base_tbl.Init(map)
  SOUND:PlayBGM("Top Menu - The Lost Continent.ogg", false)
end

function base_camp.Ferry_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local ferry = CH('Lapras')
  UI:SetSpeaker(ferry)
  if not SV.base_camp.FerryIntroduced then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_001']))
	SV.base_camp.FerryIntroduced = true
  end

  GAME:UnlockDungeon('wishmaker_cave')
  GAME:UnlockDungeon('adventurers_peak')
  local dungeon_entrances = { 'lava_floe_island', 'castaway_cave', 'wishmaker_cave', 'adventurers_peak', 'eon_island', 'lost_seas', 'inscribed_cave', 'prism_isles' }
  local ground_entrances = {}
  
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_002']))
  
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances, true,
  ferry,
  STRINGS:Format(STRINGS.MapStrings['Ferry_Line_003']))
end

return base_camp