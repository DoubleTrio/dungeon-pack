
ItemViewMenu = Class("ItemViewMenu")

--- @param title string
--- @param item_list table
--- @param generate_menu_text fun(item:any, index:number): any
--- @param update_description_summary fun(item:any, summary:any, origin:any, menu_width:number): nil
--- @param opts table|nil
function ItemViewMenu:initialize(title, item_list, generate_menu_text, update_description_summary, opts)
  opts = opts or {}

  self.MAX_ELEMENTS = opts.max_elements or 10

  self.title = title
  self.itemList = item_list or {}

  self.menuWidth = opts.menu_width or 122
  self.label = opts.label or "ITEM_VIEW_MENU_LUA"
  self.origin = opts.origin or RogueElements.Loc(16, 16)

  self.generateMenuText = generate_menu_text
  self.updateDescriptionSummary = update_description_summary

  self.onChoose = opts.on_choose
  self.refuseAction = opts.refuse_action or function() _MENU:RemoveMenu() end

  self.choice = nil -- result

  self.optionsList = self:generate_options()
  if #self.optionsList < self.MAX_ELEMENTS then
    self.MAX_ELEMENTS = #self.optionsList
  end

  self:createMenu()
  self:createSummary(opts.summary_height or 94)

  -- initial summary
  if #self.itemList > 0 then
    self:updateSummary(self.itemList[1], self.summary)
  end
end

function ItemViewMenu:createMenu()
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)

  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(
    self.origin,
    self.menuWidth,
    self.title,
    option_array,
    0,
    self.MAX_ELEMENTS,
    function() self.refuseAction() end,
    function() self.refuseAction() end,
    false
  )

  -- Matches your structure: update summary based on current page+choice
  self.menu.ChoiceChangedFunction = function()
    local index = self.menu.CurrentPage * self.MAX_ELEMENTS + self.menu.CurrentChoice + 1
    if index < 1 then index = 1 end
    if index > #self.itemList then index = #self.itemList end

    local item = self.itemList[index]
    if item ~= nil then
      self:updateSummary(item, self.summary)
    end
  end
end

--- Generates RogueEssence.Menu.MenuElementChoice list
function ItemViewMenu:generate_options()
  local options = {}

  -- Empty-safe: show a disabled "[Empty]" row instead of crashing
  if #self.itemList == 0 then
    local empty_text = RogueEssence.Menu.MenuText("[Empty]", RogueElements.Loc(2, 1))
    table.insert(options, RogueEssence.Menu.MenuElementChoice(function() end, false, empty_text))
    return options
  end

  for i = 1, #self.itemList do
    local item = self.itemList[i]
    local menu_text = self.generateMenuText(item, i)

    -- Selection behavior lives here (like your original structure)
    local option = RogueEssence.Menu.MenuElementChoice(function()
      self.choice = item
      if self.onChoose ~= nil then
        self.onChoose(item, i, self)
      end
      -- default behavior: close menu when an option is chosen
      _MENU:RemoveMenu()
    end, true, menu_text)

    table.insert(options, option)
  end

  return options
end

function ItemViewMenu:createSummary(summary_height)
  local GraphicsManager = RogueEssence.Content.GraphicsManager

  self.summary = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(self.origin.X + self.menuWidth, self.origin.Y),
      RogueElements.Loc(GraphicsManager.ScreenWidth - 16, self.origin.Y + summary_height)
    )
  )

  self.menu.SummaryMenus:Add(self.summary)
end

function ItemViewMenu:updateSummary(item, menu)
  self.updateDescriptionSummary(item, menu, self.origin, self.menuWidth)
end
