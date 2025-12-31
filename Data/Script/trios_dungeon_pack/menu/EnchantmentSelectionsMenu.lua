--[[
    EnchantmentSelectionMenu

    Use for ground mode only then.
]]


EnchantmentSelectionMenu = Class("EnchantmentSelectionMenu")

--- Creates a new ``TeamSelectMenu`` instance using the provided list and callbacks.
--- This function throws an error if the parameter ``char_list`` contains less than 1 entries.
--- @param title string the title this window will have.
--- @param enchantment_list table an array, list or lua array table containing enchantment objects. Must have three elements.
--- @param confirm_action function the function called when a slot is chosen. It will have a enchantment object passed to it as a parameter.
--- @param refuse_action function the function called when the player presses the cancel or menu button.
--- @param enchantment_width number The width of each enchantmnet menu. Default is 100
function EnchantmentSelectionMenu:initialize(title, enchantment_list, confirm_action, refuse_action, enchantment_width)
  local len = 0
  if type(enchantment_list) == 'table' then len = #enchantment_list end
  if len < 1 then
    --abort if list is empty
    error("parameter 'enchantment_list' cannot be an empty collection")
  end


  local VERT_SPACE = 14
  -- local height = self.total_items_per_page * 16 + RogueEssence.Content.GraphicsManager.MenuBG.TileHeight * 2


  self.title = title
  self.enchantmentList = enchantment_list
  self.confirmAction = confirm_action
  self.refuseAction = refuse_action
  self.enchantmentWidth = enchantment_width or 120
  self.choice = nil


  local GraphicsManager = RogueEssence.Content.GraphicsManager

  -- local titleLoc =

  
  local titleLocRect = RogueElements.Rect.FromPoints(
    RogueElements.Loc(
      80,
      8
    ),
    RogueElements.Loc(
      GraphicsManager.ScreenWidth - 80,
      8 + GraphicsManager.MenuBG.TileHeight * 2 + 14 * 1
    )
  )



  -- self.summary = RogueEssence.Menu.TeamMiniSummary(RogueElements.Rect.FromPoints(RogueElements.Loc(16,
  --       GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 5), --LINE_HEIGHT = 12, VERT_SPACE = 14
  --       RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))


  self.menu = RogueEssence.Menu.ScriptableMenu(titleLocRect.X, titleLocRect.Y, titleLocRect.Width, titleLocRect.Height,
    function(input) self:Update(input) end)


 local titleText = RogueEssence.Menu.DialogueText(
  title,
  RogueElements.Rect(
    RogueElements.Loc(0, 0),
    RogueElements.Loc(
      titleLocRect.Width,
      titleLocRect.Height
    )
  ),
  14
)

titleText.CenterH = true
titleText.CenterV = true

self.menu.Elements:Add(titleText)



self.menu.Elements:Add(titleText)

local enchantment_width = 108
local enchantment_height = 150
local enchantment_count = 3

local edge_padding = 1
local start_x = edge_padding
local end_x = GraphicsManager.ScreenWidth - edge_padding
local total_width = end_x - start_x


local spacing = (total_width - enchantment_width * enchantment_count) / (enchantment_count - 1)
local start_y = 40

self.enchantments = {}



for i = 1, enchantment_count do
  local x = start_x + (i - 1) * (enchantment_width + spacing)

  local enchantment = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(x, start_y),
      RogueElements.Loc(x + enchantment_width, start_y + enchantment_height)
    )
  )

  --------------------------------
  -- Title (centered)
  --------------------------------
  local title = RogueEssence.Menu.DialogueText(
    self.enchantmentList[i].name,
    RogueElements.Rect(
      RogueElements.Loc(0, 12),
      RogueElements.Loc(enchantment_width, 24)
    ),
    12
  )
  title.CenterH = true
  enchantment.Elements:Add(title)


  local dividerY = 28
  enchantment.Elements:Add(
    RogueEssence.Menu.MenuDivider(
      RogueElements.Loc(6, dividerY),
      enchantment_width - 12
    )
  )

  local desc = RogueEssence.Menu.DialogueText(
    self.enchantmentList[i].description,
    RogueElements.Rect(
      RogueElements.Loc(12, dividerY + 8),
      RogueElements.Loc(enchantment_width - 24, enchantment_height - 16)
    ),
    12
  )
  desc.CenterH = true
  enchantment.Elements:Add(desc)

  self.menu.SummaryMenus:Add(enchantment)
  self.enchantments[i] = enchantment
end

-- RogueEssence.Menu.MenuBase.BorderStyle = old


  -- self.summary =


  -- self.menu.SummaryMenus:Add(self.summary)
end

--- Performs the final adjustments and creates the actual menu object.
function EnchantmentSelectionMenu:createMenu()
  -- local origin = RogueElements.Loc(16,16)
  -- local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
  -- self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(self.label, origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, self.refuseAction, self.refuseAction, false)
  -- self.menu.ChoiceChangedFunction = function() self:updateSummary() end
end

function EnchantmentSelectionMenu:Update(input)
  assert(self, "BaseState:Begin(): Error, self is nil!")
  -- default does nothing
  -- if input:JustPressed(RogueEssence.FrameInput.InputType.Confirm) then
  --   if (self.pages[self.current_page + 1][self.current_item + 1].can_ferment) then
  --   self.item_list_index = self.current_page * self.total_items_per_page + self.current_item
  --   _GAME:SE("Menu/Confirm")
  --   _MENU:RemoveMenu()
  -- else
  --   --play a sfx if you try to make something you can't
  --   _GAME:SE("Menu/Cancel")
  --   end
  -- end

  if input:JustPressed(RogueEssence.FrameInput.InputType.Cancel) or input:JustPressed(RogueEssence.FrameInput.InputType.Menu) then
    _GAME:SE("Menu/Cancel")
    _MENU:RemoveMenu()
  end

  -- local moved = false
  -- if #self.pages[self.current_page + 1] > 1 then
  --   if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Down, Dir8.DownLeft, Dir8.DownRight })) then
  --     moved = true
  --     self.current_item = ((self.current_item + 1) % #self.pages[self.current_page + 1])
  --     self.onChange(self)
  --   elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Up, Dir8.UpLeft, Dir8.UpRight })) then
  --     moved = true
  --     self.current_item = (self.current_item + #self.pages[self.current_page + 1] - 1) % #self.pages[self.current_page + 1]
  --     self.onChange(self)
  --   end
  -- end

  -- if #self.pages > 1 then
  --   if RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Left })) then
  --     self.setPage(self, (self.current_page + #self.pages - 1) % #self.pages)
  --     moved = true
  --   elseif RogueEssence.Menu.InteractableMenu.IsInputting(input, LUA_ENGINE:MakeLuaArray(Dir8, { Dir8.Right })) then
  --     self.setPage(self, (self.current_page + 1) % #self.pages)
  --     moved = true
  --   end
  -- end

  -- if moved then
  --   _GAME:SE("Menu/Select")
  --   self.cursor:ResetTimeOffset()
  --   self.cursor.Loc = RogueElements.Loc(10, 24 + 14 * self.current_item)
  -- end
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
