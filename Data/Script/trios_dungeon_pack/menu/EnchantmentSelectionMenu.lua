--[[
    EnchantmentSelectionMenu

    Use for ground mode only then.
]]

EnchantmentSelectionMenu = Class("EnchantmentSelectionMenu")

function EnchantmentSelectionMenu:initialize(title, enchantment_list, on_reroll, can_reroll, current_rerolls, confirm_action, refuse_action, enchantment_width)
   local len = type(enchantment_list) == 'table' and #enchantment_list or 0
  if len < 1 then
    error("parameter 'enchantment_list' cannot be an empty collection")
  end
  
  self:initializeConstants()
  self:initializeState(title, enchantment_list, on_reroll, can_reroll, current_rerolls, confirm_action, refuse_action)
  self:createMenu()
end

function EnchantmentSelectionMenu:initializeConstants()
  self.LINE_HEIGHT = 12
  self.VERT_SPACE = 14
  self.ENCHANTMENT_WIDTH = 108
  self.ENCHANTMENT_HEIGHT = 162
  self.EDGE_PADDING = 1
end

function EnchantmentSelectionMenu:initializeState(title, enchantment_list, on_reroll, can_reroll, current_rerolls, confirm_action, refuse_action)
  self.title = title
  self.enchantmentList = enchantment_list
  self.onReroll = on_reroll
  self.canReroll = can_reroll
  self.confirmAction = confirm_action
  self.refuseAction = refuse_action
  self.selectionIndex = 1
  self.count = #enchantment_list[1]
  self.rerollCountTotals = current_rerolls
  self.maxRerollCount = #self.enchantmentList
  self.groundToggle = {}
  self.enchantments = {}
  
  self.currentEnchantments = {}
  for i = 1, 3 do
    self.currentEnchantments[i] = self.enchantmentList[self.rerollCountTotals[i]][i]
  end
end

function EnchantmentSelectionMenu:createMenu()
  local GraphicsManager = RogueEssence.Content.GraphicsManager
  local titleRect = self:createTitleRect(GraphicsManager)
  
  self.menu = RogueEssence.Menu.ScriptableMenu(
    titleRect.X, titleRect.Y, titleRect.Width, titleRect.Height,
    function(input) self:Update(input) end
  )
  
  self:addTitleText(titleRect)
  self:createEnchantmentMenus(GraphicsManager, titleRect)
  self:createGroundToggle(GraphicsManager, titleRect)
  self:createRerollText(GraphicsManager, titleRect)
  
  self.enchantments[1].showCursor()
end

function EnchantmentSelectionMenu:createTitleRect(GraphicsManager)
  return RogueElements.Rect.FromPoints(
    RogueElements.Loc(80, 4),
    RogueElements.Loc(
      GraphicsManager.ScreenWidth - 80,
      4 + GraphicsManager.MenuBG.TileHeight * 2 + 14
    )
  )
end

function EnchantmentSelectionMenu:addTitleText(titleRect)
  local titleText = RogueEssence.Menu.DialogueText(
    self.title,
    RogueElements.Rect(
      RogueElements.Loc(0, 0),
      RogueElements.Loc(titleRect.Width, titleRect.Height)
    ),
    12
  )
  titleText.CenterH = true
  titleText.CenterV = true
  self.menu.Elements:Add(titleText)
end

function EnchantmentSelectionMenu:createEnchantmentMenus(GraphicsManager, titleRect)
  local start_x = self.EDGE_PADDING
  local end_x = GraphicsManager.ScreenWidth - self.EDGE_PADDING
  local total_width = end_x - start_x
  local spacing = (total_width - self.ENCHANTMENT_WIDTH * 3) / 2
  local row_y = titleRect.Y + titleRect.Height + 2
  
  for i = 1, 3 do
    local x = start_x + (i - 1) * (self.ENCHANTMENT_WIDTH + spacing)
    self.enchantments[i] = self:createEnchantmentMenu(i, x, row_y)
  end
end

function EnchantmentSelectionMenu:createEnchantmentMenu(index, x, y)
  local enchantment = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(x, y),
      RogueElements.Loc(x + self.ENCHANTMENT_WIDTH, y + self.ENCHANTMENT_HEIGHT)
    )
  )
  
  local y_offset = 12
  local name = self:createNameText(index, y_offset)
  enchantment.Elements:Add(name)
  
  y_offset = y_offset + 18
  enchantment.Elements:Add(
    RogueEssence.Menu.MenuDivider(
      RogueElements.Loc(10, y_offset),
      self.ENCHANTMENT_WIDTH - 20
    )
  )
  
  local desc = self:createDescriptionText(index, y_offset + 6)
  enchantment.Elements:Add(desc)
  
  local cursor = RogueEssence.Menu.MenuCursor(self.menu, RogueElements.Dir4.Up)
  cursor.Loc = RogueElements.Loc(self.ENCHANTMENT_WIDTH / 2 - 6, y_offset + 112)
  
  self.menu.SummaryMenus:Add(enchantment)
  
  return {
    menu = enchantment,
    showCursor = function() enchantment.Elements:Add(cursor) end,
    hideCursor = function() enchantment.Elements:Remove(cursor) end,
    updateNewEnchantment = function(newEnchantment)
      name:SetAndFormatText(M_HELPERS.MakeColoredText(newEnchantment.name, PMDColor.Yellow))
      desc:SetAndFormatText(newEnchantment:getDescription())
    end
  }
end

function EnchantmentSelectionMenu:createNameText(index, y_offset)
  local name = RogueEssence.Menu.DialogueText(
    M_HELPERS.MakeColoredText(self.currentEnchantments[index].name, PMDColor.Yellow),
    RogueElements.Rect(
      RogueElements.Loc(0, y_offset),
      RogueElements.Loc(self.ENCHANTMENT_WIDTH, y_offset + 12)
    ),
    12
  )
  name.CenterH = true
  return name
end

function EnchantmentSelectionMenu:createDescriptionText(index, y_offset)
  local desc = RogueEssence.Menu.DialogueText(
    self.currentEnchantments[index]:getDescription(),
    RogueElements.Rect(
      RogueElements.Loc(10, y_offset),
      RogueElements.Loc(self.ENCHANTMENT_WIDTH - 16, 102)
    ),
    12
  )
  desc.CenterH = true
  return desc
end

function EnchantmentSelectionMenu:createGroundToggle(GraphicsManager, titleRect)
  local row_y = titleRect.Y + titleRect.Height + self.ENCHANTMENT_HEIGHT + 10
  
  local groundToggle = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(142, row_y),
      RogueElements.Loc(
        GraphicsManager.ScreenWidth - 142,
        row_y + GraphicsManager.MenuBG.TileHeight * 2 + 14
      )
    )
  )
  
  local toggleText = RogueEssence.Menu.DialogueText(
    STRINGS:Format("\\uE0AF"),
    RogueElements.Rect(
      RogueElements.Loc(0, 0),
      RogueElements.Loc(groundToggle.Bounds.Width, groundToggle.Bounds.Height)
    ),
    12
  )
  toggleText.CenterH = true
  toggleText.CenterV = true
  groundToggle.Elements:Add(toggleText)
  
  local cursor = RogueEssence.Menu.MenuCursor(self.menu, RogueElements.Dir4.Up)
  cursor.Loc = RogueElements.Loc(groundToggle.Bounds.Width / 2 - 6, 18)
  
  self.groundToggle = {
    menu = groundToggle,
    showCursor = function() groundToggle.Elements:Add(cursor) end,
    hideCursor = function() groundToggle.Elements:Remove(cursor) end
  }
  
  self.menu.SummaryMenus:Add(groundToggle)
end

function EnchantmentSelectionMenu:createRerollText(GraphicsManager, titleRect)
  local row_y = titleRect.Y + titleRect.Height + self.ENCHANTMENT_HEIGHT + 10
  
  local rerollTextMenu = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(248, row_y),
      RogueElements.Loc(348, row_y + GraphicsManager.MenuBG.TileHeight * 2 + 14)
    )
  )
  
  local rerollText = RogueEssence.Menu.DialogueText(
    STRINGS:LocalKeyString(7) .. " to reroll",
    RogueElements.Rect(
      RogueElements.Loc(12, 0),
      RogueElements.Loc(rerollTextMenu.Bounds.Width, rerollTextMenu.Bounds.Height)
    ),
    12
  )
  rerollText.CenterV = true
  rerollTextMenu.Elements:Add(rerollText)
  
  self.menu.SummaryMenus:Add(rerollTextMenu)
end

function EnchantmentSelectionMenu:Update(input)
  if input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
    _MENU:RemoveMenu()
    return
  end

  if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) or
     input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    self:handleConfirm()
    return
  end

  local moved = self:handleNavigation(input)
  if moved then
    _GAME:SE("Menu/Skip")
  end
end

function EnchantmentSelectionMenu:handleConfirm()
  if self.selectionIndex ~= -1 then
    self.confirmAction(self.currentEnchantments[self.selectionIndex])
  else
    self.refuseAction()
  end
end

function EnchantmentSelectionMenu:handleNavigation(input)
  if self.selectionIndex ~= -1 then
    return self:handleEnchantmentNavigation(input)
  else
    return self:handleGroundToggleNavigation(input)
  end
end

function EnchantmentSelectionMenu:handleEnchantmentNavigation(input)
  local oldIndex = self.selectionIndex
  
  if RogueEssence.Menu.InteractableMenu.IsInputting(
      input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Right, Dir8.UpRight, Dir8.DownRight })) then
    self:moveSelection(oldIndex, (self.selectionIndex % self.count) + 1)
    return true
    
  elseif RogueEssence.Menu.InteractableMenu.IsInputting(
      input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Left, Dir8.UpLeft, Dir8.DownLeft })) then
    self:moveSelection(oldIndex, ((self.selectionIndex - 2 + self.count) % self.count) + 1)
    return true
    
  elseif RogueEssence.Menu.InteractableMenu.IsInputting(
      input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down })) then
    self:moveToGroundToggle(oldIndex)
    return true
    
  elseif input:JustPressed(RogueEssence.FrameInput.InputType.TeamMode) then
    return self:handleReroll(oldIndex)
  end
  
  return false
end

function EnchantmentSelectionMenu:handleGroundToggleNavigation(input)
  local directionMap = {
    [Dir8.Up] = 2,
    [Dir8.UpRight] = 3,
    [Dir8.UpLeft] = 1
  }
  
  for direction, targetIndex in pairs(directionMap) do
    if RogueEssence.Menu.InteractableMenu.IsInputting(
        input, LUA_ENGINE:MakeLuaArray(Dir8, { direction })) then
      self:moveFromGroundToggle(targetIndex)
      return true
    end
  end
  
  return false
end

function EnchantmentSelectionMenu:moveSelection(oldIndex, newIndex)
  self.enchantments[oldIndex].hideCursor()
  self.selectionIndex = newIndex
  self.enchantments[newIndex].showCursor()
end

function EnchantmentSelectionMenu:moveToGroundToggle(oldIndex)
  self.enchantments[oldIndex].hideCursor()
  self.selectionIndex = -1
  self.groundToggle.showCursor()
end

function EnchantmentSelectionMenu:moveFromGroundToggle(targetIndex)
  self.groundToggle.hideCursor()
  self.selectionIndex = targetIndex
  self.enchantments[targetIndex].showCursor()
end

function EnchantmentSelectionMenu:handleReroll(oldIndex)
  if self.rerollCountTotals[self.selectionIndex] < self.maxRerollCount then
    SOUND:PlayBattleSE("_UNK_EVT_118")
    self.rerollCountTotals[self.selectionIndex] = self.rerollCountTotals[self.selectionIndex] + 1
    local newEnchantment = self.enchantmentList[self.rerollCountTotals[self.selectionIndex]][self.selectionIndex]
    self.enchantments[oldIndex].updateNewEnchantment(newEnchantment)
    self.currentEnchantments[self.selectionIndex] = newEnchantment
    return false
  else
    _GAME:SE("Menu/Cancel")
    return false
  end
end

-- function EnchantmentSelectionMenu:createMenu()





-- equivalent to defining a class
-- local ExampleMenu = Class('ExampleMenu')

-- function ExampleMenu:initialize()
--   assert(self, "ExampleMenu:initialize(): Error, self is nil!")
--   self.menu = RogueEssence.Menu.ScriptableMenu(24, 24, 196, 128, function(input) self:Update(input) end)

--   self.cursor = RogueEssence.Menu.MenuCursor(self.menu)
--   self.menu.Elements:Add(self.cursor)
--   self.menu.Elements:Add(RogueEssence.Menu.MenuText("Test String", RogueElements.Loc(16, 8 + 12 * 0)))
--   self.menu.Elements:Add(RogueEssence.Menu.MenuText("Apple", RogueElements.Loc(88, 8 + 12 * 0)))
--   self.menu.Elements:Add(RogueEssence.Menu.MenuText("Test String 2", RogueElements.Loc(16, 8 + 12 * 1)))
--   self.menu.Elements:Add(RogueEssence.Menu.MenuText("Orange", RogueElements.Loc(88, 8 + 12 * 1)))

--   local portrait = RogueEssence.Menu.MenuPortrait(RogueElements.Loc(16, 32), RogueEssence.Dungeon.MonsterID("jigglypuff", 0, "normal", Gender.Male), RogueEssence.Content.EmoteStyle(1, true))
--   self.menu.Elements:Add(portrait)
--   local dirtex = RogueEssence.Menu.MenuDirTex(RogueElements.Loc(64, 32), RogueEssence.Menu.MenuDirTex.TexType.Item, RogueEssence.Content.AnimData("Money_Gray", 1))
--   self.menu.Elements:Add(dirtex)
--   local dirtex2 = RogueEssence.Menu.MenuDirTex(RogueElements.Loc(64, 48), RogueEssence.Menu.MenuDirTex.TexType.Icon, RogueEssence.Content.AnimData("Shield_Green", 3))
--   self.menu.Elements:Add(dirtex2)
--   self.total_items = 4
--   self.current_item = 0
--   self.cursor.Loc = RogueElements.Loc(8 + 12 * (self.current_item % 2), 8 + 80 * (self.current_item // 2))
-- end

-- function ExampleMenu:Update(input)
--   assert(self, "BaseState:Begin(): Error, self is nil!")
--   -- default does nothing
--   if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
--     _GAME:SE("Menu/Confirm")
-- 	if self.current_item > 2 then
-- 	  local choices = { RogueEssence.Menu.MenuTextChoice(STRINGS:FormatKey("DLG_CHOICE_YES"), LUA_ENGINE:MakeLuaAction(function() _GAME:SE("Fanfare/RankUp")  end) ),
--         { STRINGS:FormatKey("MENU_INFO"), false, function() end  },
--         { STRINGS:FormatKey("DLG_CHOICE_NO"), true, function() _MENU:RemoveMenu() end }}
-- 	  submenu = RogueEssence.Menu.ScriptableSingleStripMenu(220, 24, 24, choices, 1, function() _MENU:RemoveMenu() end)
-- 	  _MENU:AddMenu(submenu, true)
-- 	end
--   elseif input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) then
--     _GAME:SE("Menu/Cancel")
--     _MENU:RemoveMenu()
--   else
--     moved = false
--     if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
--       moved = true
--       self.current_item = (self.current_item + 1) % self.total_items
--     elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
--       moved = true
--       self.current_item = (self.current_item + self.total_items - 1) % self.total_items
--     end
--     if moved then
--       _GAME:SE("Menu/Select")
--       self.cursor:ResetTimeOffset()
--       self.cursor.Loc = RogueElements.Loc(8 + 80 * (self.current_item % 2), 8 + 12 * (self.current_item // 2))
--     end
--   end
-- end

-- function test_grounds.Hungrybox_Action(chara, activator)
--   DEBUG.EnableDbgCoro() --Enable debugging this coroutine
--   PrintInfo('Hungrybox_Action')
--   local player = CH('PLAYER')
--   local hbox = chara
--   local olddir = hbox.CharDir
--   --GROUND:Hide("PLAYER")
--   GROUND:CharTurnToCharAnimated(hbox, player, 4)
--   GROUND:CharSetDrawEffect(hbox, DrawEffect.Trembling)
--   GAME:WaitFrames(120)
--   GROUND:CharEndDrawEffect(hbox, DrawEffect.Trembling)
--   GROUND:CharAnimateTurnTo(hbox, olddir, 4)
--   --chara.CollisionDisabled = true
--   --GROUND:Unhide("PLAYER")

--   COMMON.BossTransition()

--   local coro1 = TASK:BranchCoroutine(GAME:_FadeOutFront(true, 180))

--   UI:SetSpeaker(hbox)
--   UI:TextDialogue("AAAAAAAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAAAAAAAAAAA", 180)
--   UI:WaitDialog()

--   TASK:JoinCoroutines({coro1})

--   GAME:WaitFrames(120)

--   coro1 = TASK:BranchCoroutine(GAME:_FadeInFront(180))

--   local menu = ExampleMenu:new()
--   UI:SetCustomMenu(menu.menu)
--   UI:WaitForChoice()

--   TASK:JoinCoroutines({coro1})


--   GAME:FadeIn(60)
-- end

-- function test_grounds.Custom_Menu_Update(input)
--   if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
--     _MENU:RemoveMenu()
--   end
-- end










--

--[[
    TeamSelectMenu
    lua port by MistressNebula

    Opens a menu, potentially with multiple pages, that allows the player to select a Pokémon.
    It contains a run method for quick instantiation, as well as a way to open
    a version of itself containing the current party members.
    This equivalent is NOT SAFE FOR REPLAYS. Do NOT use in dungeons until further notice.
]]


--- Menu for selecting a character from a specific list of ``RogueEssence.Dungeon.Character`` objects.
-- TeamSelectMenu = Class("TeamSelectMenu")

-- --- Creates a new ``TeamSelectMenu`` instance using the provided list and callbacks.
-- --- This function throws an error if the parameter ``char_list`` contains less than 1 entries.
-- --- @param title string the title this window will have.
-- --- @param char_list table an array, list or lua array table containing ``RogueEssence.Dungeon.Character`` objects.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @param confirm_action function the function called when a slot is chosen. It will have a ``RogueEssence.Dungeon.Character`` passed to it as a parameter.
-- --- @param refuse_action function the function called when the player presses the cancel or menu button.
-- --- @param use_submenu boolean whether or not to call the ``TeamSelectSubMenu`` before returning. Defaults to true.
-- --- @param menu_width number the width of this window. Default is 160.
-- --- @param label string the label that will be applied to this menu. Defaults to "TEAM_MENU_LUA"
-- function TeamSelectMenu:initialize(title, char_list, filter, confirm_action, refuse_action, use_submenu, menu_width, label)
--     -- param validity check
--     local len = 0
--     if type(char_list) == 'table' then len = #char_list
--     else len = char_list.Count end
--     if len <1 then
--         --abort if list is empty
--         error("parameter 'char_list' cannot be an empty collection")
--     end

--     -- constants
--     self.MAX_ELEMENTS = 5

--     -- parsing data
--     self.title = title
--     self.confirmAction = confirm_action
--     self.refuseAction = refuse_action
--     self.use_submenu = use_submenu
--     self.menuWidth = menu_width or 160
--     self.filter = filter or function(_) return true end
--     self.charList = self:load_chars(char_list)
--     self.optionsList = self:generate_options()
--     self.label = label or "TEAM_MENU_LUA"
--     if #self.optionsList<self.MAX_ELEMENTS then self.MAX_ELEMENTS = #self.optionsList end
--     if self.use_submenu == nil then self.use_submenu = true end

--     self.choice = nil -- result

--     self:createMenu()

--     -- creating the summary window
--     local GraphicsManager = RogueEssence.Content.GraphicsManager

--     self.summary = RogueEssence.Menu.TeamMiniSummary(RogueElements.Rect.FromPoints(RogueElements.Loc(16,
--             GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 5), --LINE_HEIGHT = 12, VERT_SPACE = 14
--             RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))
--     self.menu.SummaryMenus:Add(self.summary)
--     self:updateSummary()
-- end

-- --- Performs the final adjustments and creates the actual menu object.
-- function TeamSelectMenu:createMenu()
--     local origin = RogueElements.Loc(16,16)
--     local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
--     self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(self.label, origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, self.refuseAction, self.refuseAction, false)
--     self.menu.ChoiceChangedFunction = function() self:updateSummary() end
-- end

-- --- Loads the characters that will be part of the menu.
-- --- @param char_list table an array, list or lua array table containing ``RogueEssence.Dungeon.Character`` objects.
-- --- @return table a standardized version of the character list
-- function TeamSelectMenu:load_chars(char_list)
--     local list = {}

--     if type(char_list) == 'table' then
--         for _, char in pairs(char_list) do table.insert(list, char) end
--     else
--         for char in luanet.each(LUA_ENGINE:MakeList(char_list)) do table.insert(list, char) end
--     end
--     return list
-- end

-- --- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
-- --- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
-- function TeamSelectMenu:generate_options()
--     local options = {}
--     for i=1, #self.charList, 1 do
--         local char = self.charList[i]
--         local enabled = self.filter(char)
--         local color = Color.White
--         if not enabled then color = Color.Red end

--         local name = char:GetDisplayName(true)
--         local level = char.Level
--         local text_name = RogueEssence.Menu.MenuText(name, RogueElements.Loc(2, 1), color)
--         local text_lv_label = RogueEssence.Menu.MenuText(STRINGS:FormatKey("MENU_TEAM_LEVEL_SHORT"), RogueElements.Loc(self.menuWidth - 8 * 7 + 6, 1), RogueElements.DirV.Up, RogueElements.DirH.Right, color)
--         local text_level = RogueEssence.Menu.MenuText(tostring(level), RogueElements.Loc(self.menuWidth - 8 * 4, 1), RogueElements.DirV.Up, RogueElements.DirH.Right, color)
--         local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(i) end, enabled, text_name, text_lv_label, text_level)
--         table.insert(options, option)
--     end
--     return options
-- end

-- --- Calls the menu's confirmation callback and stores the chosen character in the choice variable of this object.
-- --- If the menu is set to use the sub_menu, the aforementioned process will be performed only if the sub_menu
-- --- returns true.
-- --- @param index number the chosen character.
-- function TeamSelectMenu:choose(index)
--     local callback = function(ret)
--         if ret==true then
--             self.choice = self.charList[index]
--             self.confirmAction(self.choice)
--         end
--         _MENU:RemoveMenu()
--     end

--     if self.use_submenu then
--         self:callSubMenu(callback)
--     else
--         self.choice = self.charList[index]
--         self.confirmAction(self.choice)
--     end
-- end

-- --- Summons a ``TeamSelectSubMenu`` with the provided callback.
-- --- @param callback function the function that will be called by the menu upon running confirm or cancel operations. It will have a boolean passed as a parameter.
-- function TeamSelectMenu:callSubMenu(callback)
--     _MENU:AddMenu(TeamSelectSubMenu:new(self, function() callback(true) end, function() callback(false) end).menu, true)
-- end

-- --- Updates the summary window.
-- function TeamSelectMenu:updateSummary()
--     self.summary:SetMember(self.charList[self.menu.CurrentChoiceTotal+1])
-- end


-- -------------------------------------------------------------------------------------------
-- --- Menu for selecting one or more characters from a specific list of ``RogueEssence.Dungeon.Character`` objects.
-- TeamMultiSelectMenu = Class("TeamMultiSelectMenu", TeamSelectMenu)
-- -------------------------------------------------------------------------------------------

-- --- Creates a new ``TeamMultiSelectMenu`` instance using the provided list and callbacks.
-- --- This function throws an error if the parameter ``char_list`` contains less than 1 entries.
-- --- @param title string the title this window will have.
-- --- @param char_list table an array, list or lua array table containing ``RogueEssence.Dungeon.Character`` objects.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @param confirm_action function the function called when a slot is chosen. It will have a ``RogueEssence.Dungeon.Character`` passed to it as a parameter.
-- --- @param refuse_action function the function called when the player presses the cancel or menu button.
-- --- @param menu_width number the width of this window. Default is 160.
-- --- @param label string the label that will be applied to this menu. Defaults to "TEAM_MENU_LUA"
-- function TeamMultiSelectMenu:initialize(title, char_list, filter, confirm_action, refuse_action, menu_width, label)
--     self.multiConfirmAction = function(list)
--         self.choice = self:multiConfirm(list)
--         self.confirmAction(self.choice)
--     end
--     TeamSelectMenu.initialize(self, title, char_list, filter, confirm_action, refuse_action, menu_width, label)
-- end

-- --- Performs the final adjustments and creates the actual menu object.
-- function TeamMultiSelectMenu:createMenu()
--     local valid = self:count_valid()
--     local origin = RogueElements.Loc(16,16)
--     local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
--     self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(self.label, origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, self.refuseAction, self.refuseAction, false, valid, self.multiConfirmAction)
--     self.menu.ChoiceChangedFunction = function() self:updateSummary() end
-- end

-- --- Counts the number of valid options generated.
-- --- @return number the number of valid options.
-- function TeamMultiSelectMenu:count_valid()
--     local count = 0
--     for _, option in pairs(self.optionsList) do
--         if option.Enabled then count = count+1 end
--     end
--     return count
-- end

-- --- Calls the menu's confirmation callback and stores the table array of chosen charactes in the choice
-- --- variable of this object.
-- --- If the menu is set to use the sub_menu, the aforementioned process will be performed only if the sub_menu
-- --- returns true.
-- --- @param index number the chosen character, wrapped inside of a single element table array.
-- function TeamMultiSelectMenu:choose(index)
--     local callback = function(ret)
--         if ret==true then
--             self.multiConfirmAction({index-1})
--         end
--         _MENU:RemoveMenu()
--     end

--     if self.use_submenu then
--         self:callSubMenu(callback)
--     else
--         self.multiConfirmAction({index-1})
--     end
-- end

-- --- Extract the list of selected slots.
-- --- @param list table a table array containing the menu indexes of the chosen items.
-- --- @return table a table array containing ``RogueEssence.Dungeon.InvSlot`` objects.
-- function TeamMultiSelectMenu:multiConfirm(list)
--     local result = {}
--     for _, index in pairs(list) do
--         local char = self.charList[index+1]
--         table.insert(result, char)
--     end
--     return result
-- end


-- -------------------------------------------------------------------------------------------
-- --- Menu for choosing what to do with the chosen character.
-- TeamSelectSubMenu = Class("TeamSelectSubMenu")
-- -------------------------------------------------------------------------------------------

-- --- Creates a new ``TeamSelectSubMenu`` instance using the provided data and callbacks.
-- --- @param parent table a ``TeamSelectMenu``
-- --- @param confirm_action function the function called when the first option is pressed.
-- --- @param refuse_action function the function called when the third option or the cancel or menu buttons are pressed.
-- --- @param label string the label that will be applied to this menu. Defaults to "TEAM_CHOSEN_MENU_LUA"
-- function TeamSelectSubMenu:initialize(parent, confirm_action, refuse_action, label)
--     self.parent = parent
--     label = label or "TEAM_CHOSEN_MENU_LUA"
--     local x, y, w = parent.menu.Bounds.Right, parent.menu.Bounds.Top, 64
--     local summary_action = function()
--         self:openSummary()
--     end

--     local choices = {
--         {STRINGS:FormatKey("MENU_CHOOSE"),       true, confirm_action},
--         {STRINGS:FormatKey("MENU_TEAM_SUMMARY"), true, summary_action},
--         {STRINGS:FormatKey("MENU_EXIT"),         true, refuse_action}
--     }
--     self.menu = RogueEssence.Menu.ScriptableSingleStripMenu(label, x, y, w, choices, 0, refuse_action)
-- end

-- --- Opens the ``RogueEssence.Menu.MemberFeaturesMenu`` of the character selected in the parent menu.
-- function TeamSelectSubMenu:openSummary()
--     _MENU:AddMenu(RogueEssence.Menu.MemberFeaturesMenu(_DATA.Save.ActiveTeam, self.parent.menu.CurrentChoiceTotal, false, false, false), false)
-- end




-- -------------------------------------------------------------------------------------------
-- --- Creates a basic ``TeamSelectMenu`` instance using the provided list and callbacks, then runs it and returns its output.
-- --- @param title string the title this window will have
-- --- @param char_list table an array, list or lua array table containing ``RogueEssence.Dungeon.Character`` objects.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @param use_submenu boolean whether or not to call the ``TeamSelectSubMenu`` before returning. Defaults to true.
-- --- @return userdata the selected character if one was chosen in the menu; ``nil`` otherwise.
-- function TeamSelectMenu.run(title, char_list, filter, use_submenu)
--     local ret
--     local choose = function(char)
--         ret = char
--         _MENU:RemoveMenu()
--     end
--     local refuse = function() _MENU:RemoveMenu() end
--     local menu = TeamSelectMenu:new(title, char_list, filter, choose, refuse, use_submenu)
--     UI:SetCustomMenu(menu.menu)
--     UI:WaitForChoice()
--     return ret
-- end

-- --- Creates a ``TeamSelectMenu`` instance that allows a choice between the current party members.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @param use_submenu boolean whether or not to call the ``TeamSelectSubMenu`` before returning. Defaults to true.
-- --- @return userdata the selected character if one was chosen in the menu; ``nil`` otherwise.
-- function TeamSelectMenu.runPartyMenu(filter, use_submenu)
--     local char_list = _DATA.Save.ActiveTeam.Players

--     return TeamSelectMenu.run(STRINGS:FormatKey("MENU_TEAM_TITLE"), char_list, filter, use_submenu)
-- end

-- -------------------------------------------------------------------------------------------
-- --- Creates a basic ``TeamMultiSelectMenu`` instance using the provided list and callbacks, then runs it and returns its output.
-- --- @param title string the title this window will have
-- --- @param char_list table an array, list or lua array table containing ``RogueEssence.Dungeon.Character`` objects.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @return table the list of selected characters if at least one was chosen in the menu; ``nil`` otherwise.
-- function TeamMultiSelectMenu.runMultiMenu(title, char_list, filter)
--     local ret = {}
--     local choose = function(chars)
--         ret = chars
--         _MENU:RemoveMenu()
--     end
--     local refuse = function() _MENU:RemoveMenu() end
--     local menu = TeamMultiSelectMenu:new(title, char_list, filter, choose, refuse)
--     UI:SetCustomMenu(menu.menu)
--     UI:WaitForChoice()
--     return ret
-- end

-- --- Creates a ``TeamMultiSelectMenu`` instance that allows a choice between the current party members.
-- --- @param filter function a function that takes a ``RogueEssence.Dungeon.Character`` object and returns a boolean. Any character that does not pass this check will have its option disabled in the menu. Defaults to ``return true``.
-- --- @return table the list of selected characters if at least one was chosen in the menu; ``nil`` otherwise.
-- function TeamMultiSelectMenu.runMultiPartyMenu(filter)
--     local char_list = _DATA.Save.ActiveTeam.Players

--     return TeamMultiSelectMenu.runMultiMenu(STRINGS:FormatKey("MENU_TEAM_TITLE"), char_list, filter)
-- end
