
EnchantmentViewMenu = Class("EnchantmentViewMenu")


function EnchantmentViewMenu:initialize(title, enchantment_list, generate_menu_text, update_description_summary, refuse_action, menu_width, label)
  self.MAX_ELEMENTS = 10

  self.title = title

  -- print(Serpent.line(enchantment_list) .. ".... enchantment list in view menu")
  self.enchantmentList = EnchantmentRegistry:GetSelected(enchantment_list)
  print(Serpent.dump(self.enchantmentList) .. ".... enchantment list after getting selected")

  self.menuWidth = menu_width or 122
  self.label = label or "TEAM_ENCHANTMENT_VIEW_MENU_LUA"
  self.currentIndex = 1
  self.generateMenuText = generate_menu_text
  self.updateDescriptionSummary = update_description_summary

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
    self:updateSummary(self.enchantmentList[1], self.summary)
end

function EnchantmentViewMenu:createMenu()
  local option_array = luanet.make_array(RogueEssence.Menu.MenuElementChoice, self.optionsList)
  self.menu = RogueEssence.Menu.ScriptableMultiPageMenu(self.origin, self.menuWidth, self.title, option_array, 0, self.MAX_ELEMENTS, function() _MENU:RemoveMenu() end, function() _MENU:RemoveMenu() end, false)
  self.menu.ChoiceChangedFunction = function()
    local index = self.menu.CurrentPage * self.MAX_ELEMENTS + self.menu.CurrentChoice + 1
    print("Choice changed to index: " .. tostring(index))
    local enchantment = self.enchantmentList[index]
    self:updateSummary(enchantment, self.summary)
  end
  -- self.menu.
end



--- Processes the menu's properties and generates the ``RogueEssence.Menu.MenuElementChoice`` list that will be displayed.
--- @return table a list of ``RogueEssence.Menu.MenuElementChoice`` objects.
function EnchantmentViewMenu:generate_options()
  local options = {}
  for i=1, #self.enchantmentList, 1 do
      local enchantment = self.enchantmentList[i]
      local menu_text = self.generateMenuText(enchantment)
      local option = RogueEssence.Menu.MenuElementChoice(function() end, true, menu_text)
      table.insert(options, option)
  end
  return options
end


function EnchantmentViewMenu:updateSummary(enchantment, menu)
  self.updateDescriptionSummary(enchantment, menu, self.origin, self.menuWidth)
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