
EnchantmentViewMenu = Class("EnchantmentViewMenu")


function EnchantmentViewMenu:initialize(title, enchantment_list, refuse_action, menu_width, label)

    -- constants
  self.MAX_ELEMENTS = 10

  self.title = title

  self.enchantmentList = GetSelectedEnchantments(enchantment_list)

  print("Enchantment List Length: " .. tostring(#self.enchantmentList))
  self.menuWidth = menu_width or 122
  self.label = label or "TEAM_ENCHANTMENT_VIEW_MENU_LUA"
  self.currentIndex = 1

  self.choice = nil -- result
  self.optionsList = self:generate_options()
  if #self.optionsList < self.MAX_ELEMENTS then self.MAX_ELEMENTS = #self.optionsList end

  self.origin = RogueElements.Loc(16,16)
  self:createMenu()

  -- self.refuseAction = refuse_action or function() _MENU:RemoveMenu() end
  
  local GraphicsManager = RogueEssence.Content.GraphicsManager

    self.summary = RogueEssence.Menu.SummaryMenu(
    RogueElements.Rect.FromPoints(
      RogueElements.Loc(self.origin.X + self.menuWidth + 2, self.origin.Y),
      RogueElements.Loc(GraphicsManager.ScreenWidth - 16, self.origin.Y + 94)
    )
  )

    self.menu.SummaryMenus:Add(self.summary)
    self:updateSummary()
end

function EnchantmentViewMenu:createMenu()
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(self.origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, function() _MENU:RemoveMenu() end, function() _MENU:RemoveMenu() end, false)
  self.menu.ChoiceChangedFunction = function() self:updateSummary() print(tostring(self.menu.CurrentChoice)) end
  -- self.menu.
end



--- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function EnchantmentViewMenu:generate_options()
  local options = {}
  for i=1, #self.enchantmentList, 1 do
      local enchantment = self.enchantmentList[i]
      local color = Color.White
      local text_name = RogueEssence.Menu.MenuText(M_HELPERS.MakeColoredText(enchantment.name, PMDColor.Yellow), RogueElements.Loc(2, 1), color)
      local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(i) end, true, text_name)
      table.insert(options, option)
  end
  return options
end


function EnchantmentViewMenu:updateSummary()

  local GraphicsManager = RogueEssence.Content.GraphicsManager

 
  local index = self.menu.CurrentPage * self.MAX_ELEMENTS + self.menu.CurrentChoice + 1
  local enchantment = self.enchantmentList[index]
  local additonal_texts = enchantment:getProgressTexts()
  self.summary.Elements:Clear()
  self.summary.Bounds = RogueElements.Rect.FromPoints(
    RogueElements.Loc(self.origin.X + self.menuWidth + 2, self.origin.Y),
    RogueElements.Loc(GraphicsManager.ScreenWidth - 16, self.origin.Y + 106 + #additonal_texts * 12 + 12)
  )

  -- print("Updating summary for index: " .. tostring(self.menu.CurrentChoice))

  local y_offset = 10

  local name = RogueEssence.Menu.DialogueText(
    M_HELPERS.MakeColoredText(enchantment.name, PMDColor.Yellow),
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(self.summary.Bounds.Width, y_offset + 6)
    ),
    12
  )

  y_offset = y_offset + 6 + 6

  local divider = RogueEssence.Menu.MenuDivider(
    RogueElements.Loc(10, y_offset),
    self.summary.Bounds.Width - 20
  )

  y_offset = y_offset + 4
  

  local desc = RogueEssence.Menu.DialogueText(
    enchantment:getDescription(),
    RogueElements.Rect(
      RogueElements.Loc(12, y_offset),
      RogueElements.Loc(self.summary.Bounds.Width - 20, 60)
    ),
    12
  )

  y_offset = y_offset + 72

  self.summary.Elements:Add(name)
  self.summary.Elements:Add(divider)
  self.summary.Elements:Add(desc)




  if additonal_texts ~= nil then
    for _, text in ipairs(additonal_texts) do
      y_offset = y_offset + 12
      local additional = RogueEssence.Menu.DialogueText(
        text,
        RogueElements.Rect(
          RogueElements.Loc(12, y_offset),
          RogueElements.Loc(self.summary.Bounds.Width - 20, y_offset + 6)
        ),
        12
      )
      self.summary.Elements:Add(additional)
    end
  end


  -- return name


  -- self.summary.
    -- self.summary:SetMember(self.charList[self.menu.CurrentChoiceTotal+1])
end



function EnchantmentViewMenu:choose(index)
    -- local callback = function(ret)
    --     if ret==true then
    --         self.choice = self.charList[index]
    --         self.confirmAction(self.choice)
    --     end
    --     _MENU:RemoveMenu()
    -- end

    -- self.choice = self.enchantmentList[index]
    -- _MENU:RemoveMenu()
        -- self.confirmAction(self.choice)
  
end