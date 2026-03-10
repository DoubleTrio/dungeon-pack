ItemSelectionMenu = Class("ItemSelectionMenu")

function ItemSelectionMenu:initialize(title, item_list, generate_option_choice, confirm_action, refuse_action,
                                      menu_width, label)
  self.MAX_ELEMENTS = 6

  self.title = title

  self.generateOptionChoice = generate_option_choice
  self.itemList = item_list

  self.menuWidth = menu_width or 92
  self.label = label or "ITEM_SELECTION_MENU_LUA"
  self.currentIndex = 1

  self.refuseAction = refuse_action or function() _MENU:RemoveMenu() end
  self.confirmAction = confirm_action or function() end

  self.choice = nil

  self.optionsList = self:generate_options()
  if #self.optionsList < self.MAX_ELEMENTS then self.MAX_ELEMENTS = #self.optionsList end

  local GraphicsManager = RogueEssence.Content.GraphicsManager
  self.itemSummary = RogueEssence.Menu.ItemSummary(RogueElements.Rect.FromPoints(
    RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 4),
    RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))

  local first_entry = self.itemList[1]
  local first_inv_item = RogueEssence.Dungeon.InvItem(first_entry.Item, false, first_entry.Amount)
  self.itemSummary:SetItem(first_inv_item)

  self:createMenu()
  self.menu.SummaryMenus:Add(self.itemSummary)
  self:updateSummary()
  self.menu.ChoiceChangedFunction = function() self:updateSummary() end
end

function ItemSelectionMenu:createMenu()
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)

  local GraphicsManager = RogueEssence.Content.GraphicsManager
  local summaryTop = GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 7
  local origin = RogueElements.Loc(16, summaryTop - math.min(self.MAX_ELEMENTS, #self.itemList) * 14 - 30)

  local choiceLen = M_HELPERS.CalculateChoiceLength(self.optionsList, self.minWidth)
  print(tostring(choiceLen))

  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(origin, choiceLen, self.title, option_array, 0, self
  .MAX_ELEMENTS, refuse, refuse, false)
end

function ItemSelectionMenu:generate_options()
  local options = {}
  for i = 1, #self.itemList, 1 do
    local item_entry = self.itemList[i]

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

  if entry == nil then return end

  self.menu.SummaryMenus:Clear()

  local item_data = _DATA:GetItem(entry.Item)
  local has_id_state = item_data.ItemStates:Contains(luanet.ctype(ItemIDStateType))
  local id_state = nil
  if has_id_state then
    id_state = item_data.ItemStates:Get(luanet.ctype(ItemIDStateType))
  end

  if id_state ~= nil then
    local GraphicsManager = RogueEssence.Content.GraphicsManager
    self.skillSummary = RogueEssence.Menu.SkillSummary(RogueElements.Rect.FromPoints(
      RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 7),
      RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))
    self.skillSummary:SetSkill(id_state.ID)
    self.menu.SummaryMenus:Add(self.skillSummary)
  else
    local inv_item = RogueEssence.Dungeon.InvItem(entry.Item, false, entry.Amount)
    self.itemSummary:SetItem(inv_item)
    self.menu.SummaryMenus:Add(self.itemSummary)
  end
end

function ItemSelectionMenu:choose(index)
  self.confirmAction(self.itemList[index])
end
