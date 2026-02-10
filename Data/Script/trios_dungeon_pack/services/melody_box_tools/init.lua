require 'origin.common'
require 'origin.services.baseservice'
require 'trios_dungeon_pack.menu.EnchantmentViewMenu'

local MelodyBoxTools = Class('MelodyBoxTools', BaseService)

--[[---------------------------------------------------------------
    MelodyBoxTools:initialize()
      MelodyBoxTools class constructor
---------------------------------------------------------------]]
function MelodyBoxTools:initialize()
  BaseService.initialize(self)
end

--[[---------------------------------------------------------------
    MelodyBoxTools:__gc()
      MelodyBoxTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function MelodyBoxTools:__gc()
--  PrintInfo('****************MelodyBoxTools:__gc()')
--end



--[[---------------------------------------------------------------
    MelodyBoxTools:OnMenuButtonPressed()
      When the main menu button is pressed or the main menu should be enabled this is called!
      This is called as a coroutine.
---------------------------------------------------------------]]
function MelodyBoxTools:OnMenuButtonPressed()
end

--[[---------------------------------------------------------------
    MelodyBoxTools:OnMenuButtonPressed()
      When the main menu button is pressed or the main menu should be enabled this is called!
      This is called as a coroutine.
---------------------------------------------------------------]]
function MelodyBoxTools:DungeonSegmentEnd()
  SV.EmberFrost.DungeonMusicSelection = ""
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
  print("DungeonSegmentEnd!!!!")
end

function MelodyBoxTools:OnMenuButtonPressed()
  print("KSKSSKSK")
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function MelodyBoxTools:Subscribe(med)
  med:Subscribe("MelodyBoxTools", EngineServiceEvents.DungeonSegmentEnd, function() self.DungeonSegmentEnd("A") end)
  med:Subscribe("MelodyBoxTools", EngineServiceEvents.MenuButtonPressed, function() self.OnMenuButtonPressed("a") end)
end

---Summary
-- un-subscribe to all channels this service subscribed to
function MelodyBoxTools:UnSubscribe(med)
end

--Add our service
SCRIPT:AddService("MelodyBoxTools", MelodyBoxTools:new())

return MelodyBoxTools
