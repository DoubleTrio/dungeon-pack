local runtime = require 'trios_dungeon_pack.emberfrost.achievements.runtime'
local zone_name = runtime.zone_name
local AddToNotifyQueue = runtime.AddToNotifyQueue
local ContainsEnchantment = runtime.ContainsEnchantment
local AllEnchantsEqualOrGreater = runtime.AllEnchantsEqualOrGreater

local group = {}

function group.collection(add)
add({
  id = "ENCYCLOPEDIA",
  name = "Encyclopedia",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "See all the enchants"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnEnchantmentSeen", function()
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if AllEnchantsEqualOrGreater(EnchantmentStatus.Seen) then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

add({
  id = "ARCANIST",
  name = "Arcanist",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Win with all the enchants"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnEmberfrostClear", function()
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if AllEnchantsEqualOrGreater(EnchantmentStatus.SelectedAndWon) then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

end

return group
