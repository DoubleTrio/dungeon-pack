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
  if MenuTools.MainMenu == nil then
    MenuTools.MainMenu = RogueEssence.Menu.MainMenu()
  end
  
  MenuTools.MainMenu:SetupChoices()
  
  if _ZONE.CurrentZoneID == "emberfrost_depths" then


    local enchant_count = #SV.EmberFrost.SelectedEnchantments
    local has_enchants = enchant_count > 0

    local enchant_color = Color.Red
    if enchant_count > 0 then
      enchant_color = Color.White
    end 
    
    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      MenuTools.MainMenu.Choices:RemoveAt(5)
      MenuTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Others", function () _MENU:AddMenu(MenuTools:CustomDungeonOthersMenu(), false) end))
    else

      -- local refuse = function() print("* Refuse action called") _MENU:RemoveMenu() end

      MenuTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.SelectedEnchantments).menu, false) end, has_enchants, enchant_color))
    end
  end
 
  MenuTools.MainMenu:SetupTitleAndSummary()

  
  MenuTools.MainMenu:InitMenu()
  TASK:WaitTask(_MENU:ProcessMenuCoroutine(MenuTools.MainMenu))
end



function MenuTools:CustomDungeonOthersMenu()
    local menu = RogueEssence.Menu.OthersMenu()
    menu:SetupChoices();

    local enchant_count = #SV.EmberFrost.SelectedEnchantments
    local has_enchants = enchant_count > 0

    local enchant_color = Color.Red
    if enchant_count > 0 then
      enchant_color = Color.White
    end 
    
	if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
		menu.Choices:Insert(1, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.SelectedEnchantments).menu, false) end, has_enchants, enchant_color))
	end
	menu:InitMenu();
    return menu
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