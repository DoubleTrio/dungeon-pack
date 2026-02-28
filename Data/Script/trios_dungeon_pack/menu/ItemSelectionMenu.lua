ItemSelectionMenu = Class("ItemSelectionMenu")

-- - @param generate_menu_text fun(item:any, index:number): any

function ItemSelectionMenu:initialize(title, item_list, generate_option_choice, confirm_action, refuse_action,
                                      menu_width, label)
  self.MAX_ELEMENTS = 6

  self.title = title

  self.generateOptionChoice = generate_option_choice
  self.itemList = item_list

  self.menuWidth = menu_width or 142
  self.label = label or "TEAM_ITEM_SELECTION_MENU_LUA"
  self.currentIndex = 1

  self.refuseAction = refuse_action or function() _MENU:RemoveMenu() end
  self.confirmAction = confirm_action or function() end

  self.choice = nil -- result
  self.optionsList = self:generate_options()
  if #self.optionsList < self.MAX_ELEMENTS then self.MAX_ELEMENTS = #self.optionsList end


  local GraphicsManager = RogueEssence.Content.GraphicsManager


  self.itemSummary = RogueEssence.Menu.ItemSummary(RogueElements.Rect.FromPoints(
        RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 4), --LINE_HEIGHT = 12, VERT_SPACE = 14
        RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))


  self:createMenu()

  self.menu.SummaryMenus:Add(self.itemSummary)
  self:updateSummary()
end

function ItemSelectionMenu:createMenu()
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
  
  local origin = RogueElements.Loc(16, self.itemSummary.Bounds.Y - math.min(self.MAX_ELEMENTS, #self.itemList) * 14 - 30)

  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, refuse, refuse, false)
  self.menu.ChoiceChangedFunction = function() self:updateSummary() end
  -- self.menu.
end



--- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function ItemSelectionMenu:generate_options()
  local options = {}
  for i = 1, #self.itemList, 1 do
    local item_entry = self.itemList[i]
    print(tostring(item_entry))
    print(Serpent.dump(item_entry))

    local option = self.generateOptionChoice(item_entry, i, function(idx)
      self:choose(idx)
    end)

    table.insert(options, option)
  end
  return options
end

function ItemSelectionMenu:updateSummary()
  local index = self.menu.CurrentPage * self.MAX_ELEMENTS + self.menu.CurrentChoice + 1
  local entry = self.itemList[index]

  local inv_item = RogueEssence.Dungeon.InvItem(entry.Item, false, entry.Amount)
  self.itemSummary:SetItem(inv_item)
end



function ItemSelectionMenu:choose(index)
  self.confirmAction(self.itemList[index])
end