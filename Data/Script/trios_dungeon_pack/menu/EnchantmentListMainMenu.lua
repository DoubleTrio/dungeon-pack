require 'trios_dungeon_pack.menu.EnchantmentViewMenu'
-- -----------------------------------------------
-- Enchantment List Main Menu
-- -----------------------------------------------



local function GetTextAndColorBasedOnStatus(enchantment, seen_text)
  local text_color = PMDColor.Gray
  local text = "???"

  local seen_status = SV.EmberFrost.Enchantments.Collection[enchantment.id] or EnchantmentStatus.NotSeen

  if seen_status == EnchantmentStatus.Seen then
    text = seen_text
  elseif seen_status == EnchantmentStatus.Selected or seen_status == EnchantmentStatus.SelectedAndWon then
    text_color = PMDColor.White
    text = seen_text
  end

  return {
    text = text,
    color = text_color
  }
end

local function collection_generate_menu_text(enchantment)
  local seen_status = SV.EmberFrost.Enchantments.Collection[enchantment.id] or EnchantmentStatus.NotSeen


  local status_info = GetTextAndColorBasedOnStatus(enchantment, enchantment.name)

  local text_color = status_info.color
  local text = status_info.text
  local color = Color.White

  if seen_status == EnchantmentStatus.SelectedAndWon then
    text = PMDSpecialCharacters.Star .. " " .. text
  end

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


  local text = status_info.text

  if seen_status == EnchantmentStatus.SelectedAndWon then
    text = PMDSpecialCharacters.Star .. " " .. text
  end

  local name = RogueEssence.Menu.DialogueText(
    M_HELPERS.MakeColoredText(text, text_color),
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



EnchantmentListMainMenu = Class('EnchantmentListMainMenu')
EnchantmentListMainMenu.static = {}
EnchantmentListMainMenu.static.width = 70
EnchantmentListMainMenu.static.options =  {"Active", "Collection"}

function EnchantmentListMainMenu:initialize(x, y)
    assert(self, "EnchantmentListMainMenu:initialize(): self is nil!")
    self.static = EnchantmentListMainMenu.static

    self.optionsList = self:generate_options()
    self.menu = RogueEssence.Menu.ScriptableSingleStripMenu(x - 1, y, self.static.width, self.optionsList, 0, function() _GAME:SE("Menu/Cancel"); _MENU:RemoveMenu() end)
end

function EnchantmentListMainMenu:generate_options()
  
    local list = {}



    local enchant_count = #SV.EmberFrost.Enchantments.Selected
    local has_enchants = enchant_count > 0


    table.insert(list, { "Active", has_enchants, function() _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end } )




    local collection = {}

    local data = EnchantmentRegistry._registry
    for k, _ in pairs(data) do
      table.insert(collection, k)
    end

    table.sort(collection)

    table.insert(list, { "Collection", true, function() _MENU:AddMenu(EnchantmentViewMenu:new("All Enchants", collection, collection_generate_menu_text, collection_update_description_summary).menu, false) end } )

            -- MenuTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end, has_enchants, enchant_color))
        
    -- local text = self.static.options
    -- for i = 1, 2, 1 do
    --     list[i] = {text[i], true, function() self:choose(i) end}
    -- end
    return list
end

function EnchantmentListMainMenu:choose(index)

    -- if index == 1 then
    --     if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    --         local map = RECRUIT_LIST.getCurrentMap()
    --         local zone = map.zone
    --         local segment = map.segment
    --         _MENU:AddMenu(RecruitmentListMenu:new("Recruitment List", zone, segment).menu, false)
    --     else
    --         _MENU:AddMenu(RecruitListDungeonMenu:new().menu, false)
    --     end
    -- elseif index == 4 then
    --     _MENU:AddMenu(RecruitListSettingsMenu:new(self.menu).menu, true)
    -- else
    --     _MENU:AddMenu(MultiPageTextMenu:new(index-1).menu, false)
    -- end
end




-- require 'origin.common'
-- require 'origin.services.baseservice'
-- require 'trios_dungeon_pack.menu.EnchantmentViewMenu'

-- --Declare class MenuTools
-- local MenuTools = Class('MenuTools', BaseService)




-- --[[---------------------------------------------------------------
--     MenuTools:initialize()
--       MenuTools class constructor
-- ---------------------------------------------------------------]]
-- function MenuTools:initialize()
--   BaseService.initialize(self)

-- end

-- --[[---------------------------------------------------------------
--     MenuTools:__gc()
--       MenuTools class gc method
--       Essentially called when the garbage collector collects the service.
-- 	  TODO: Currently causes issues.  debug later.
--   ---------------------------------------------------------------]]
-- --function MenuTools:__gc()
-- --  PrintInfo('****************MenuTools:__gc()')
-- --end



-- --[[---------------------------------------------------------------
--     MenuTools:OnMenuButtonPressed()
--       When the main menu button is pressed or the main menu should be enabled this is called!
--       This is called as a coroutine.
-- ---------------------------------------------------------------]]
-- function MenuTools:OnMenuButtonPressed()
--   if MenuTools.MainMenu == nil then
--     MenuTools.MainMenu = RogueEssence.Menu.MainMenu()
--   end
  
--   MenuTools.MainMenu:SetupChoices()
  
--   if _ZONE.CurrentZoneID == "emberfrost_depths" then


--     local enchant_count = #SV.EmberFrost.Enchantments.Selected
--     local has_enchants = enchant_count > 0

--     local enchant_color = Color.Red
--     if enchant_count > 0 then
--       enchant_color = Color.White
--     end 
    
--     if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
--       MenuTools.MainMenu.Choices:RemoveAt(5)
--       MenuTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Others", function () _MENU:AddMenu(MenuTools:CustomDungeonOthersMenu(), false) end))
--     else

--       MenuTools.MainMenu.Choices:Insert(4, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end, has_enchants, enchant_color))

--       local collection = {}

--       local data = EnchantmentRegistry._registry
--       for k, _ in pairs(data) do
--         table.insert(collection, k)
--       end

--       table.sort(collection)

--       MenuTools.MainMenu.Choices:Insert(5, RogueEssence.Menu.MenuTextChoice("Collection", function () _MENU:AddMenu(EnchantmentViewMenu:new("All Enchants", collection, collection_generate_menu_text, collection_update_description_summary).menu, false) end, true, Color.White))
--     end
--   end
 
--   MenuTools.MainMenu:SetupTitleAndSummary()

  
--   MenuTools.MainMenu:InitMenu()
--   TASK:WaitTask(_MENU:ProcessMenuCoroutine(MenuTools.MainMenu))
-- end



-- function MenuTools:CustomDungeonOthersMenu()
--     local menu = RogueEssence.Menu.OthersMenu()
--     menu:SetupChoices();

--     local enchant_count = #SV.EmberFrost.Enchantments.Selected
--     local has_enchants = enchant_count > 0

--     local enchant_color = Color.Red
--     if enchant_count > 0 then
--       enchant_color = Color.White
--     end 
    
-- 	if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
-- 		menu.Choices:Insert(1, RogueEssence.Menu.MenuTextChoice("Enchants", function () _MENU:AddMenu(EnchantmentViewMenu:new("Enchantments", SV.EmberFrost.Enchantments.Selected, selection_generate_menu_text, selection_update_description_summary).menu, false) end, has_enchants, enchant_color))

--     local collection = {}

--     local data = EnchantmentRegistry._registry
--     for k, _ in pairs(data) do
--       table.insert(collection, k)
--     end

--     table.sort(collection)
--     menu.Choices:Insert(2, RogueEssence.Menu.MenuTextChoice("Collection", function () _MENU:AddMenu(EnchantmentViewMenu:new("All Enchants", collection, collection_generate_menu_text, collection_update_description_summary).menu, false) end, true, Color.White))
-- 	end
-- 	menu:InitMenu();
--     return menu
-- end


-- ---Summary
-- -- Subscribe to all channels this service wants callbacks from
-- function MenuTools:Subscribe(med)
--   med:Subscribe("MenuTools", EngineServiceEvents.MenuButtonPressed, function() self.OnMenuButtonPressed() end )
-- end

-- ---Summary
-- -- un-subscribe to all channels this service subscribed to
-- function MenuTools:UnSubscribe(med)
-- end


-- --Add our service
-- SCRIPT:AddService("MenuTools", MenuTools:new())

-- return MenuTools

