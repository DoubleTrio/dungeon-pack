--[[
    Example Service
    
    This is an example to demonstrate how to use the BaseService class to implement a game service.
    
    **NOTE:** After declaring you service, you have to include your package inside the main.lua file!
]]--
require 'origin.common'
require 'origin.services.baseservice'

--Declare class CustomUpgrade
local CustomUpgrade = Class('CustomUpgrade', BaseService)


--[[---------------------------------------------------------------
    CustomUpgrade:initialize()
      CustomUpgrade class constructor
---------------------------------------------------------------]]
function CustomUpgrade:initialize()
  BaseService.initialize(self)
  PrintInfo('CustomUpgrade:initialize()')
end

--[[---------------------------------------------------------------
    CustomUpgrade:__gc()
      CustomUpgrade class gc method
      Essentially called when the garbage collector collects the service.
	  TODO: Currently causes issues.  debug later.
  ---------------------------------------------------------------]]
--function CustomUpgrade:__gc()
--  PrintInfo('*****************CustomUpgrade:__gc()')
--end

--[[---------------------------------------------------------------
    CustomUpgrade:OnUpgrade()
      When a save file in an old version is loaded this is called!
---------------------------------------------------------------]]
function CustomUpgrade:OnUpgrade()
  assert(self, 'CustomUpgrade:OnUpgrade() : self is null!')
  if SV.Wishmaker == nil then
    SV.Wishmaker = {
      RecruitedJirachi = false,
      MadeWish = false,
      RemoveBonusMoney = false,
      TempItemString = nil,
      BonusScore = 0
    }
  end


  if SV.Wishmaker.RecruitedJirachi == nil then SV.Wishmaker.RecruitedJirachi = false end
  if SV.Wishmaker.MadeWish == nil then SV.Wishmaker.MadeWish = false end
  if SV.Wishmaker.RemoveBonusMoney == nil then SV.Wishmaker.RemoveBonusMoney = false end


  if SV.SavedCharacters == nil then
    SV.SavedCharacters = {}
  end

  if SV.SavedInventories == nil then
    SV.SavedInventories = {}
  end
  if SV.EmberFrost == nil then
    SV.EmberFrost = {
      ShouldSwap = false,
      SelectedEnchantments = {},
    }
  end
  if SV.EmberFrost.ShouldSwap == nil then SV.EmberFrost.ShouldSwap = false end
  if SV.EmberFrost.SelectedEnchantments == nil then SV.EmberFrost.SelectedEnchantments = {} end

  if SV.TemporaryFlags == nil then
    SV.TemporaryFlags = {
      OldDirection = nil
    }
  end

  SV.TemporaryFlags.OldDirection = nil
end

---Summary
-- Subscribe to all channels this service wants callbacks from
function CustomUpgrade:Subscribe(med)
  med:Subscribe("CustomUpgrade", EngineServiceEvents.UpgradeSave,  function() self.OnUpgrade(self) end )
end

--Add our service
SCRIPT:AddService("CustomUpgrade", CustomUpgrade:new())
return CustomUpgrade