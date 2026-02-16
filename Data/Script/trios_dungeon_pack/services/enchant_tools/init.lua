require 'origin.common'
require 'origin.services.baseservice'
require 'trios_dungeon_pack.menu.EnchantmentListMainMenu'

-- Declare class RecruitTools
local EnchantTools = Class('EnchantTools', BaseService)

--[[---------------------------------------------------------------
    EnchantTools:initialize()
      EnchantTools class constructor
---------------------------------------------------------------]]
function EnchantTools:initialize()
    BaseService.initialize(self)
    PrintInfo('EnchantTools:initialize()')
end

--[[---------------------------------------------------------------
    EnchantTools:OnSaveLoad()
      When the Continue button is pressed this is called!
---------------------------------------------------------------]]
function EnchantTools:OnSaveLoad() end

--[[---------------------------------------------------------------
    EnchantTools:OnAddMenu(menu)
      When a menu is about to be added to the menu stack this is called!
---------------------------------------------------------------]]
function EnchantTools:OnAddMenu(menu)
    local labels = RogueEssence.Menu.MenuLabel
    if _ZONE.CurrentZoneID ~= "emberfrost_depths" then return end

    local in_dungeon = RogueEssence.GameManager.Instance.CurrentScene ==
                           RogueEssence.Dungeon.DungeonScene.Instance
    if not menu:HasLabel() then return end

    local function add_enchants_choice(target_label, y_offset)
        local choice = RogueEssence.Menu.MenuTextChoice("Run Info", function()
            _MENU:AddMenu(EnchantmentListMainMenu:new(
                              menu.Bounds.Width + menu.Bounds.X, y_offset).menu,
                          true)
        end, true, Color.White)
        local choices = menu:ExportChoices()
        local index = menu:GetChoiceIndexByLabel(target_label)
        choices:Insert(index, choice)
        menu:ImportChoices(choices)
    end

    if menu.Label == labels.MAIN_MENU and not in_dungeon then
        add_enchants_choice(labels.MAIN_OTHERS, 72)
    elseif menu.Label == labels.OTHERS_MENU and in_dungeon then
        add_enchants_choice(labels.OTH_SETTINGS, 60)
    end
end

--[[---------------------------------------------------------------
    EnchantTools:OnUpgrade()
      When version differences are found while loading a save this is called.
---------------------------------------------------------------]]
function EnchantTools:OnUpgrade() end

---Summary
-- Subscribe to all channels this service wants callbacks from
function EnchantTools:Subscribe(med)
    med:Subscribe("EnchantTools", EngineServiceEvents.LoadSavedData,
                  function() self.OnSaveLoad(self) end)
    med:Subscribe("EnchantTools", EngineServiceEvents.AddMenu,
                  function(_, args) self.OnAddMenu(self, args[0]) end)
    med:Subscribe("EnchantTools", EngineServiceEvents.UpgradeSave,
                  function(_) self.OnUpgrade(self) end)
end

---Summary
-- un-subscribe to all channels this service subscribed to
function EnchantTools:UnSubscribe(_) end

---Summary
-- The update method is run as a coroutine for each services.
function EnchantTools:Update(_)
    --  while(true)
    --    coroutine.yield()
    --  end
end

-- Add our service
SCRIPT:AddService("EnchantTools", EnchantTools:new())


return EnchantTools
