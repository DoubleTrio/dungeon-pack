local runtime = require 'trios_dungeon_pack.terrasphere.achievements.runtime'
local zone_name = runtime.zone_name
local AddToNotifyQueue = runtime.AddToNotifyQueue
local ContainsEnchantment = runtime.ContainsEnchantment
local AllEnchantsEqualOrGreater = runtime.AllEnchantsEqualOrGreater

local group = {}

function group.first_clear(add)
add({
  id = "FIRST_TRY",
  name = "First Try!",
  defaultVis = AchievementStatus.Visible,
  get_description = function(self)
    -- local enchantment = EnchantmentRegistry:Get()
    return "Clear " .. zone_name .. " for the first time"
  end,
  apply = function(self)
      local id
      id = beholder.observe("OnTerrasphereClear", function()
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end)
  end,
})


end

function group.solo(add)
add({
  id = "SOLO_MISSION",
  name = "Solo Mission",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Clear " .. zone_name .. " with only the character you entered with"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTerrasphereClear", function()
      local assembly_count = CountAssemblyWithKey("TerrasphereRun")
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if assembly_count == 0 and _DATA.Save.ActiveTeam.Players.Count == 1 then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

end

function group.purist(add)
add({
  id = "PURIST",
  name = "Purist",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Clear " .. zone_name .. " with no enchants"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTerrasphereClear", function()
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if #SV.Terrasphere.Enchantments.Selected <= 0 then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

end

return group
