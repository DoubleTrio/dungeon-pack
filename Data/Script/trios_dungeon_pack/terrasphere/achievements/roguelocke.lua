local runtime = require 'trios_dungeon_pack.terrasphere.achievements.runtime'
local zone_name = runtime.zone_name
local AddToNotifyQueue = runtime.AddToNotifyQueue
local ContainsEnchantment = runtime.ContainsEnchantment
local AllEnchantsEqualOrGreater = runtime.AllEnchantsEqualOrGreater

local group = {}

function group.roguelocke(add)
CHALLENGER = add({
  id = "CHALLENGER",
  name = "Challenger",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Clear " .. zone_name .. " in Roguelocke (Must transfer a character)"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTerrasphereClear", function()
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if GAME:InRogueMode() then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
      end
    end)
  end,
})

add({
  id = "SPEEDRUN",
  name = "Speedrun!",
  timeLimitMinute = 120,
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Clear " .. zone_name .. "in Roguelocke in " .. self.timeLimitMinute .." minutes"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTerrasphereClear", function()
      SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      if GAME:InRogueMode() then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

add({
  id = "EFFIECIENCY",
  name = "Efficiency!",
  total_turns = 120,
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Clear " .. zone_name .. "in Roguelocke within " .. self.total_turns .. " turns"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTerrasphereClear", function()
      -- SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
      -- if GAME:InRogueMode() then
      --   AddToNotifyQueue(self.id)
      --   beholder.stopObserving(id)
      -- end
    end)
  end,
})
-- TotalTurns
--  public string GetDungeonTimeDisplay()
--     {
--         TimeSpan totalSessionTime = SessionTime;
--         //add the time elapsed since current session start, if we have a session start
--         if (SessionStartTime.Ticks > 0)
--             totalSessionTime += (DateTime.Now - SessionStartTime);

--         string display = "99:59:59";
--         int totalHours = totalSessionTime.Hours;
--         if (totalHours < 100)
--             display = String.Format("{0:D2}", totalHours) + totalSessionTime.ToString(@"\:mm\:ss");

--         return display;
--     }

end

return group
