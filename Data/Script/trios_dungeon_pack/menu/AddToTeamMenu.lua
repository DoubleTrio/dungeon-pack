--[[
    AddToTeamMenu
    lua port

    Opens a menu that allows the player to select a Pokémon from the assembly to add to the active party.
    This is the dungeon equivalent of the assembly withdrawal menu.
]]

--- Menu for selecting a character from the assembly to add to the active team.
AddToTeamMenu = Class("AddToTeamMenu")

local SLOTS_PER_PAGE = 6

--- Creates a new ``AddToTeamMenu`` instance using the provided callbacks.
--- @param team_choice function the function called when a slot is chosen. It will have a table of ints (assembly indexes) passed to it.
--- @param refuse_action function the function called when the player presses the cancel or menu button.
--- @param label string the label that will be applied to this menu. Defaults to "ADD_TO_TEAM_MENU"
function AddToTeamMenu:initialize(team_choice, refuse_action, label)
  self.menuWidth = 160
  self.teamChoice = team_choice
  self.refuseAction = refuse_action
  self.label = label or "ADD_TO_TEAM_MENU"

  -- build eligible assembly index list
  self.eligibleAssembly = {}
  for ii = 0, _DATA.Save.ActiveTeam.Assembly.Count - 1, 1 do
    -- if not _DUNGEON.ActiveTeam.Assembly[ii].Absentee then
    table.insert(self.eligibleAssembly, ii)
    -- end
  end

  self.optionsList = self:generate_options()
  self:createMenu()
end

--- Processes the assembly and generates the ``RogueEssence.Menu.MenuElementChoice`` list.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function AddToTeamMenu:generate_options()
  local options = {}
  local GraphicsManager = RogueEssence.Content.GraphicsManager

  for i = 1, #self.eligibleAssembly, 1 do
    local index = self.eligibleAssembly[i]
    local character = _DATA.Save.ActiveTeam.Assembly[index]
    local color = character.Dead and Color.Red or Color.White

    local text_name = RogueEssence.Menu.MenuText(character:GetDisplayName(true), RogueElements.Loc(2, 1), color)
    local text_lv_label = RogueEssence.Menu.MenuText(
      STRINGS:FormatKey("MENU_TEAM_LEVEL_SHORT"),
      RogueElements.Loc(self.menuWidth - 8 * 7 + 6, 1),
      RogueElements.DirV.Up, RogueElements.DirH.Right, color)
    local text_lv = RogueEssence.Menu.MenuText(
      tostring(character.Level),
      RogueElements.Loc(
      self.menuWidth - 8 * 7 + 6 + GraphicsManager.TextFont:SubstringWidth(tostring(_DATA.Start.MaxLevel)), 1),
      RogueElements.DirV.Up, RogueElements.DirH.Right, color)

    local enabled = not character.Dead
    local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(index) end, enabled, text_name,
      text_lv_label, text_lv)
    table.insert(options, option)
  end
  return options
end

--- Performs the final adjustments and creates the actual menu object.
function AddToTeamMenu:createMenu()
  local GraphicsManager = RogueEssence.Content.GraphicsManager
  local origin = RogueElements.Loc(16, 16)
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)

  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(
    self.label, origin, self.menuWidth,
    STRINGS:FormatKey("MENU_ASSEMBLY_TITLE"),
    option_array, 0, SLOTS_PER_PAGE,
    self.refuseAction, self.refuseAction, false)

  self.menu.ChoiceChangedFunction = function() self:updateSummary() end

  -- summary window
  self.summaryMenu = RogueEssence.Menu.TeamMiniSummary(RogueElements.Rect.FromPoints(
    RogueElements.Loc(16, GraphicsManager.ScreenHeight - 8 - GraphicsManager.MenuBG.TileHeight * 2 - 14 * 5),
    RogueElements.Loc(GraphicsManager.ScreenWidth - 16, GraphicsManager.ScreenHeight - 8)))
  self.menu.SummaryMenus:Add(self.summaryMenu)

  self:createPortraitBox()
  self.menu.SummaryMenus:Add(self.portrait_box)
  
  self:updateSummary()
end

function AddToTeamMenu:createPortraitBox()
  local GraphicsManager = RogueEssence.Content.GraphicsManager
  local x = GraphicsManager.ScreenWidth - 32 - 40
  local y = 16
  local w = 38 + GraphicsManager.MenuBG.TileWidth * 2
  local h = 34 + GraphicsManager.MenuBG.TileHeight * 2
  self.portrait_box = RogueEssence.Menu.SummaryMenu(RogueElements.Rect.FromPoints(
    RogueElements.Loc(x, y),
    RogueElements.Loc(x + w, y + h)))
  local loc = RogueElements.Loc(GraphicsManager.MenuBG.TileWidth - 1, GraphicsManager.MenuBG.TileHeight - 3)
  self.portrait = RogueEssence.Menu.SpeakerPortrait(
    RogueEssence.Dungeon.MonsterID.Invalid,
    RogueEssence.Content.EmoteStyle(0),
    loc, false)
  self.portrait_box.Elements:Add(self.portrait)
end


--- Selects a character and fires the team choice callback.
--- @param index number the assembly index of the chosen character.
function AddToTeamMenu:choose(index)
  _MENU:RemoveMenu()
  self.teamChoice({ index })
end

--- Updates the summary window and portrait to reflect the currently highlighted character.
function AddToTeamMenu:updateSummary()
  local assembly_index = self.eligibleAssembly[self.menu.CurrentChoiceTotal + 1]
  if assembly_index == nil then return end
  local char = _DATA.Save.ActiveTeam.Assembly[assembly_index]
  self.summaryMenu:SetMember(char)
  self.portrait.Speaker = char.BaseForm
end
