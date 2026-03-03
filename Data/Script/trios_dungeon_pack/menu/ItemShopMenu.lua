
--[[
    ItemShopMenu
    Opens a menu, potentially with multiple pages, that allows the player to purchase.
    It contains a run method for quick instantiation and an ItemShopChosenMenu port for confirmation.
    This equivalent is NOT SAFE FOR REPLAYS. Do NOT use in dungeons until further notice.
]]


--- Menu for selecting items from the player's inventory.
ItemShopMenu = Class("ItemShopMenu")

--- Creates a new ``ItemShopMenu`` instance using the provided list and callbacks.
--- @param title string the title this window will have.
--- @param items table The list of items formatted as { Item=string, "Amount"=int, "Cost"=int}
--- @param filter function a function that takes a ``RogueEssence.Dungeon.InvSlot`` object and returns a boolean. Any slot that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
--- @param confirm_action function the function called when the selection is confirmed. It will have a table array of ``RogueEssence.Dungeon.InvSlot`` objects passed to it as a parameter.
--- @param refuse_action function the function called when the player presses the cancel or menu button.
--- @param confirm_button string the text used for the confirm button of ``ItemShopChosenMenu``. If nil, the sub-menu will be skipped entirely.
--- @param menu_width number the width of this window. Default is 176.
--- @param max_choices boolean if set, it will never be possible to select more than the amount of items defined here. Defaults to the amount of selectable items.
--- @param label string the label that will be applied to this menu. Defaults to "INVENTORY_MENU_LUA"
function ItemShopMenu:initialize(title, items, filter, confirm_action, refuse_action, confirm_button, menu_width, max_choices, label)

  -- constants
  self.MAX_ELEMENTS = 8

  -- parsing data
  self.title = title
  self.itemsList = items
  self.confirm_button = confirm_button
  self.confirmAction = confirm_action
  self.refuseAction = refuse_action

  -- how many shards from selection
  self.selected_total = 0
  self.start_count = self:count_item("yellow_shard")


  self.menuWidth = menu_width or 176
  self.filter = filter or function(_) return true end
  self.optionsList = self:generate_options()

  self.max_choices_param = max_choices
  self.max_choices = self:count_valid()
  label = label or "ITEM_SHOP_MENU"
  self.label = label
  if self.max_choices_param and self.max_choices_param < self.max_choices then self.max_choices = self.max_choices_param end

  self.multiConfirmAction = function(list)
    self.choices = self:multiConfirm(list)
    local choose = function(answer)
      if answer then
        _MENU:RemoveMenu()
        if #self.choices == 1 then
          self.selected_total = self.choices[1].Cost
        end
        self.confirmAction(self.choices, self.selected_total)
      end
    end

    if not self.confirm_button then
      choose(true)
    else
      local menu = ItemShopChosenMenu:new(self.choices, self.menu, self.confirm_button, choose)
      _MENU:AddMenu(menu.menu, true)
    end
  end

  self.choices = {}   -- result

  -- creating the menu
  local origin = RogueElements.Loc(16, 16)
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)

  self.option_array = option_array

  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(label, origin, self.menuWidth, title, option_array, 0,
    self.MAX_ELEMENTS, refuse_action, refuse_action, false, self.max_choices, self.multiConfirmAction)
  self.menu.ChoiceChangedFunction = function() self:updateSummary() end
  self.menu.MultiSelectChangedFunction = function()
    self:updateSummary()
    local option = option_array[self.menu.CurrentChoice]
    local entry = self.itemsList[self.menu.CurrentChoice + 1]
    if option.Enabled then

      if option.Selected then
        self.selected_total = self.selected_total + entry.Cost
      else
        self.selected_total = self.selected_total - entry.Cost
      end
      self:updateShardText()
      self:updateEnabled()
    end
  end
  self.menu.UpdateFunction = function(input) self:updateFunction(input) end

  -- create the summary window
  local GraphicsManager = RogueEssence.Content.GraphicsManager

  self.summary = RogueEssence.Menu.ItemSummary(RogueElements.Rect.FromPoints(
    RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 4),         --LINE_HEIGHT = 12, VERT_SPACE = 14
    RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))
  
  self.itemCountMenu = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
    RogueElements.Loc(16 + self.menuWidth, self.menu.Bounds.Bottom - 12 * 2 - GraphicsManager.MenuBG.TileHeight * 2),
    RogueElements.Loc(RogueEssence.Content.GraphicsManager.ScreenWidth - 16, self.menu.Bounds.Bottom)
  ))


  local titleText = RogueEssence.Menu.DialogueText(
    "Shards:",
    RogueElements.Rect(
      RogueElements.Loc(GraphicsManager.MenuBG.TileWidth * 2, 0),
      RogueElements.Loc(self.itemCountMenu.Bounds.Width, 24)
    ),
    12
  )
  titleText.CenterV = true
  self.itemCountMenu.Elements:Add(titleText)




  local shardText = RogueEssence.Menu.DialogueText(
    "[Placeholder]",
    RogueElements.Rect(
      RogueElements.Loc(0, GraphicsManager.MenuBG.TileHeight + 12),
      RogueElements.Loc(self.itemCountMenu.Bounds.Width, GraphicsManager.MenuBG.TileHeight + 12 + 12)
    ),
    12
  )
    
  shardText.CenterH = true

  self.shardText = shardText
  self.itemCountMenu.Elements:Add(shardText)



  self.menu.SummaryMenus:Add(self.summary)
  self.menu.SummaryMenus:Add(self.itemCountMenu)
  self:updateSummary()
  self:updateShardText()
end

function ItemShopMenu:count_item(item_id)
  local sum = 0
  local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
  for i = 0, inv_count - 1 do
    local item = _DATA.Save.ActiveTeam:GetInv(i)
    if (item.ID == item_id) then
      sum = sum + item.Amount
    end
  end


  local player_count = _DATA.Save.ActiveTeam.Players.Count
  for i = 0, player_count - 1, 1 do
    local player = _DATA.Save.ActiveTeam.Players[i]
    if player.EquippedItem.ID == item_id then
      sum = sum + player.EquippedItem.Amount
    end
  end
  return sum
end

function ItemShopMenu:remove_item(item_id, amount)
  local remaining = amount

  local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
  for i = inv_count - 1, 0, -1 do
    if remaining <= 0 then break end
    local item = _DATA.Save.ActiveTeam:GetInv(i)
    if item.ID == item_id then
      if item.Amount <= remaining then
        remaining = remaining - item.Amount
        _DATA.Save.ActiveTeam:RemoveFromInv(i)
      else
        item.Amount = item.Amount - remaining
        remaining = 0
      end
    end
  end

  if remaining > 0 then
    local player_count = _DATA.Save.ActiveTeam.Players.Count
    for i = 0, player_count - 1, 1 do
      if remaining <= 0 then break end
      local player = _DATA.Save.ActiveTeam.Players[i]
      if player.EquippedItem.ID == item_id then
        if player.EquippedItem.Amount <= remaining then
          remaining = remaining - player.EquippedItem.Amount
          player:SilentDequipItem()
        else
          player.EquippedItem.Amount = player.EquippedItem.Amount - remaining
          remaining = 0
        end
      end
    end
  end
end

--- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function ItemShopMenu:generate_options()
  local options = {}
  print(Serpent.dump(self.itemsList))
  -- print(tostring(#self.itemsList))
  for i = 1, #self.itemsList, 1 do
    local entry = self.itemsList[i]
    local enabled = entry.Cost <= (self.start_count - self.selected_total)
    -- local enabled = false
    local color = Color.White
    if not enabled then color = Color.Red end

    -- local name = item:GetDisplayName()
    -- if equip_id then name = tostring(equip_id + 1) .. ": " .. name end

    
    local item = RogueEssence.Dungeon.InvItem(entry.Item, false, entry.Amount)
    -- TODO: GetItemName
    local text_name = RogueEssence.Menu.MenuText(item:GetDisplayName(), RogueElements.Loc(2, 1), color)


    local shard_text = RogueEssence.Menu.MenuText(entry.Cost .. " " .. PMDSpecialCharacters.YellowShard,
  
    RogueElements.Loc(176 - 8 * 4, 1), DirV.Up, DirH.Right, Color.White)
    -- new Loc(ItemMenu.ITEM_MENU_WIDTH - 8 * 4, 1), DirV.Up, DirH.Right, Color.Lim
            --         bool canAfford = goods[index].Item2 <= DataManager.Instance.Save.ActiveTeam.Money;
            --     MenuText itemText = new MenuText(goods[index].Item1.GetDisplayName(), new Loc(2, 1), canAfford ? Color.White : Color.Red);
            --     MenuText itemPrice = new MenuText(goods[index].Item2.ToString(), new Loc(ItemMenu.ITEM_MENU_WIDTH - 8 * 4, 1), DirV.Up, DirH.Right, Color.Lime);
            --     flatChoices.Add(new MenuElementChoice(() => { choose(index); }, true, itemText, itemPrice));
            -- }


    local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(i) end, enabled, text_name, shard_text)
    table.insert(options, option)
  end
  return options
end

--- Counts the number of valid options generated.
--- @return number the number of valid options.
function ItemShopMenu:count_valid()
  local count = 0
  for _, option in pairs(self.optionsList) do
    if option.Enabled then count = count + 1 end
  end
  return count
end

--- Closes the menu and calls the menu's confirmation callback.
--- The result must be retrieved by accessing the choice variable of this object, which will hold
--- the chosen index as the single element of a table array.
--- @param index number the index of the chosen character, wrapped inside of a single element table array.
function ItemShopMenu:choose(index)
  self.multiConfirmAction({ index - 1 })
end

--- Uses the current input to apply changes to the menu.
--- @param input userdata the ``RogueEssense.InputManager``.
function ItemShopMenu:updateFunction(input)
  -- if input:JustPressed(RogueEssence.FrameInput.InputType.SortItems) then
    -- _GAME:SE("Menu/Sort")
    -- self:SortCommand()
  -- end
end

--- Returns a newly created copy of this object
--- @return userdata an ``ItemShopMenu``.
function ItemShopMenu:cloneMenu()
  return ItemShopMenu:new(self.title, self.filter, self.confirmAction, self.refuseAction, self.confirm_button,
    self.menuWidth, self.includeEquips, self.max_choices_param, self.label)
end

--- Updates the summary window.
function ItemShopMenu:updateSummary()
  -- print(tostring(self.menu.CurrentChoiceTotal).. "Ge")
  -- print(tostring(self.menu.CurrentChoice))

  local entry = self.itemsList[self.menu.CurrentChoiceTotal + 1]
  local item = RogueEssence.Dungeon.InvItem(entry.Item, false, entry.Amount)

  self.summary:SetItem(item)
end

function ItemShopMenu:updateEnabled()

  local remaining = self.start_count - self.selected_total

  for i = 1, #self.itemsList do
    local entry = self.itemsList[i]
    local option = self.option_array[i - 1]

    if not option.Selected then
      local enabled = entry.Cost <= remaining

      print(tostring(entry.Cost) .. "and" .. remaining)
      option.Enabled = enabled

      print(tostring(option.Enabled))


      local color = enabled and Color.White or Color.Red
      if option.Elements ~= nil and option.Elements[0] ~= nil then
        option.Elements[0].Color = color
      end
    end
  end
end

function ItemShopMenu:updateShardText()
  
  local text = string.format("%d%s", self.start_count, PMDSpecialCharacters.YellowShard)

  if self.selected_total > 0 then
    text = text .. string.format(" (-%d)", self.selected_total)
  end

  self.shardText:SetAndFormatText(text)
end

--- Extract the list of selected slots.
--- @param list table a table array containing the menu indexes of the chosen items.
--- @return table a table array containing ``RogueEssence.Dungeon.InvSlot`` objects.
function ItemShopMenu:multiConfirm(list)
  print("mutliselecte!")
  local result = {}
  for _, index in pairs(list) do
    local entry = self.itemsList[index + 1]
    table.insert(result, entry)
  end
  return result
end


ItemShopChosenMenu = Class("ItemShopChosenMenu")

--- Creates a new ``ItemShopChosenMenu`` instance using the provided object as parent.
--- @param slots table the list of selected InvSlots
--- @param parent userdata the parent menu
--- @param confirm_text function the confirm button text
--- @param confirm_action function the function that is called when the confirm button is pressed
--- @param label string the label that will be applied to this menu. Defaults to "ITEM_CHOSEN_MENU_LUA"
function ItemShopChosenMenu:initialize(slots, parent, confirm_text, confirm_action, label)
  local x, y = parent.Bounds.Right, parent.Bounds.Top
  local width = 72
  label = label or "ITEM_CHOSEN_MENU_LUA"


  self.confirmAction = confirm_action
  local options = {
    { confirm_text,                     true, function() self:choose(true) end },
    { STRINGS:FormatKey("MENU_CANCEL"), true, function() self:choose(false) end }
  }


  self.menu = RogueEssence.Menu.ScriptableSingleStripMenu(label, x, y, width, options, 0,
    function() self:choose(false) end)
end

function ItemShopChosenMenu:choose(result)
  _MENU:RemoveMenu()
  self.confirmAction(result)
end

--- Creates a basic ``ItemShopMenu`` instance using the provided parameters, then runs it and returns its output.
--- @param title string the title this window will have
--- @param filter function a function that takes a ``RogueEssence.Dungeon.InvSlot`` object and returns a boolean. Any ``InvSlot`` that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
--- @param confirm_text string the text used by the confirm sub-menu's confirm option. If nil, the sub-menu will be skipped entirely.
--- @param max_choices number if set, it will never be possible to select more than the amount of items defined here. Defaults to the amount of selectable items.
--- @return table a table array containing the chosen ``RogueEssence.Dungeon.InvSlot`` objects.
function ItemShopMenu.run(title, items, filter, confirm_text, max_choices)
  local ret = {}
  local choose = function(list, cost)
    ret = { Items = list, Cost = cost }
  end
  
  local refuse = function() _MENU:RemoveMenu() end
  local menu = ItemShopMenu:new(title, items, filter, choose, refuse, confirm_text, 176, max_choices)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
  return ret
end
