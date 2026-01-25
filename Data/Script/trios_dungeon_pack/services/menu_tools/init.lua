require 'origin.common'
require 'origin.services.baseservice'
require 'trios_dungeon_pack.menu.EnchantmentViewMenu'

--Declare class MenuTools
local MenuTools = Class('MenuTools', BaseService)


local function GetTextAndColorBasedOnStatus(enchantment, seen_text)
  local text_color = PMDColor.Gray
  local text = "???"

  local seen_status = SV.EmberFrost.Enchantments.Collection[enchantment.id] or EnchantmentStatus.NotSeen

  if seen_status == EnchantmentStatus.Seen then
    text = seen_text
  elseif seen_status == EnchantmentStatus.Selected then
    text_color = PMDColor.White
    text = seen_text
  elseif seen_status == EnchantmentStatus.SelectedAndWon then
    text_color = PMDColor.Yellow
    text = seen_text
  end

  return {
    text = text,
    color = text_color
  }
end

local function collection_generate_menu_text(enchantment)
  local status_info = GetTextAndColorBasedOnStatus(enchantment, enchantment.name)
  local text = status_info.text
  local text_color = status_info.color
  local color = Color.White

  local text_name = RogueEssence.Menu.MenuText(M_HELPERS.MakeColoredText(text, text_color), RogueElements.Loc(2, 1), color)

  return text_name
end
     

local function collection_update_description_summary(enchantment, menu, origin, menuWidth)
  local seen_status = SV.EmberFrost.Enchantments.Collection[enchantment.id] or EnchantmentStatus.NotSeen 
  local status_info = GetTextAndColorBasedOnStatus(enchantment, enchantment.name)

  local text_color = status_info.color

  local GraphicsManager = RogueEssence.Content.GraphicsManager

  menu.Elements:Clear()

  menu.Bounds = RogueElements.Rect.FromPoints(
    RogueElements.Loc(origin.X + menuWidth + 2, origin.Y),
    RogueElements.Loc(
      GraphicsManager.ScreenWidth - 16,
      origin.Y + 106
    )
  )

  local y_offset = 10

  local name = RogueEssence.Menu.DialogueText(
    M_HELPERS.MakeColoredText(status_info.text, text_color),
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(menu.Bounds.Width, y_offset + 6)
    ),
    12
  )

  y_offset = y_offset + 12

  local divider = RogueEssence.Menu.MenuDivider(
    RogueElements.Loc(10, y_offset),
    menu.Bounds.Width - 20
  )

  y_offset = y_offset + 4




  local description = M_HELPERS.MakeColoredText("???", text_color)

  if seen_status ~= EnchantmentStatus.NotSeen then
    description = enchantment:getDescription()
  end

  local desc = RogueEssence.Menu.DialogueText(
    description,
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(menu.Bounds.Width - 20, 60)
    ),
    12
  )

  y_offset = y_offset + 72

  menu.Elements:Add(name)
  menu.Elements:Add(divider)
  menu.Elements:Add(desc)
end

local function selection_generate_menu_text(enchantment)
  local color = Color.White
  local text_name = RogueEssence.Menu.MenuText(M_HELPERS.MakeColoredText(enchantment.name, PMDColor.White), RogueElements.Loc(2, 1), color)

  return text_name
end

local function selection_update_description_summary(enchantment, menu, origin, menuWidth)
  local GraphicsManager = RogueEssence.Content.GraphicsManager
  local additional_texts = enchantment:getProgressTexts()

  menu.Elements:Clear()

  menu.Bounds = RogueElements.Rect.FromPoints(
    RogueElements.Loc(origin.X + menuWidth + 2, origin.Y),
    RogueElements.Loc(
      GraphicsManager.ScreenWidth - 16,
      origin.Y + 106 + (additional_texts and #additional_texts or 0) * 12 + 12
    )
  )

  local y_offset = 10

  local name = RogueEssence.Menu.DialogueText(
    M_HELPERS.MakeColoredText(enchantment.name, PMDColor.White),
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(menu.Bounds.Width, y_offset + 6)
    ),
    12
  )

  y_offset = y_offset + 12

  local divider = RogueEssence.Menu.MenuDivider(
    RogueElements.Loc(10, y_offset),
    menu.Bounds.Width - 20
  )

  y_offset = y_offset + 4

  local desc = RogueEssence.Menu.DialogueText(
    enchantment:getDescription(),
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(menu.Bounds.Width - 20, 60)
    ),
    12
  )

  y_offset = y_offset + 72

  menu.Elements:Add(name)
  menu.Elements:Add(divider)
  menu.Elements:Add(desc)

  if additional_texts then
    for _, text in ipairs(additional_texts) do
      y_offset = y_offset + 12
      local additional = RogueEssence.Menu.DialogueText(
        text,
        RogueElements.Rect(
          RogueElements.Loc(12, y_offset),
          RogueElements.Loc(menu.Bounds.Width - 20, y_offset + 6)
        ),
        12
      )
      menu.Elements:Add(additional)
    end
  end
end


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


    local enchant_count = #SV.EmberFrost.Enchantments.Selected
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
      MenuTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end, has_enchants, enchant_color))

      local collection = {}
      local collections = SV.EmberFrost.Enchantments.Collection
      local data = EnchantmentRegistry._registry
      -- local tbl = {}

      -- for _, enchant_id in ipairs(SV.EmberFrost.Enchantments.Selected) do
      --   local enchantment = M_ENCHANTMENTS:GetEnchantmentByID(enchant_id)
      --   if enchantment ~= nil then
      --     table.insert(tbl, enchantment)
      --   end
      -- end
      for k, _ in pairs(data) do
        table.insert(collection, k)
        -- local tbl = {
        --   id = k,
        --   seen_status = collections[k] or EnchantmentStatus.NotSeen
        -- }
        -- table.insert(collection, tbl)
        -- if enchantment ~= nil then
        --   table.insert(tbl, enchantment)
        -- end
      end
      -- local 

      MenuTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Collection", function () _MENU:AddMenu(EnchantmentViewMenu:new("All Enchants", collection, collection_generate_menu_text, collection_update_description_summary).menu, false) end, true, Color.White))
    end
  end
 
  MenuTools.MainMenu:SetupTitleAndSummary()

  
  MenuTools.MainMenu:InitMenu()
  TASK:WaitTask(_MENU:ProcessMenuCoroutine(MenuTools.MainMenu))
end



function MenuTools:CustomDungeonOthersMenu()
    local menu = RogueEssence.Menu.OthersMenu()
    menu:SetupChoices();

    local enchant_count = #SV.EmberFrost.Enchantments.Selected
    local has_enchants = enchant_count > 0

    local enchant_color = Color.Red
    if enchant_count > 0 then
      enchant_color = Color.White
    end 
    
	if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
		menu.Choices:Insert(1, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end, has_enchants, enchant_color))
    menu.Choices:Insert(2, RogueEssence.Menu.MenuTextChoice("Collection", function () _MENU:AddMenu(EnchantmentViewMenu:new("All Enchants", collection, collection_generate_menu_text, collection_update_description_summary).menu, false) end, true, Color.White))
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

