require 'origin.common'
require 'origin.services.baseservice'
require 'trios_dungeon_pack.menu.EnchantmentViewMenu'

--Declare class MenuTools
local MenuTools = Class('MenuTools', BaseService)

--[[---------------------------------------------------------------
    MenuTools:initialize()
      MenuTools class constructor
---------------------------------------------------------------]]
function MenuTools:initialize()
  BaseService.initialize(self)

end

--[[---------------------------------------------------------------
    MenuTools:__gc()
      MenuTools class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function MenuTools:__gc()
--  PrintInfo('****************MenuTools:__gc()')
--end



--[[---------------------------------------------------------------
    MenuTools:OnMenuButtonPressed()
      When the main menu button is pressed or the main menu should be enabled this is called!
      This is called as a coroutine.
---------------------------------------------------------------]]
function MenuTools:OnMenuButtonPressed()
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function MenuTools:Subscribe(med)
  med:Subscribe("MenuTools", EngineServiceEvents.MenuButtonPressed, function() self.OnMenuButtonPressed() end )
end

---Summary
-- un-subscribe to all channels this service subscribed to
function MenuTools:UnSubscribe(med)
end


--Add our service
SCRIPT:AddService("MenuTools", MenuTools:new())

return MenuTools

