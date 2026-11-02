local runtime = require 'trios_dungeon_pack.emberfrost.achievements.runtime'
local zone_name = runtime.zone_name
local AddToNotifyQueue = runtime.AddToNotifyQueue
local ContainsEnchantment = runtime.ContainsEnchantment
local AllEnchantsEqualOrGreater = runtime.AllEnchantsEqualOrGreater

local group = {}

function group.score(add)
local function CreateScoreAchievement(id, name, amount, useTotalScore)
  return {
    amount = amount,
    id = id,
    name = name,
    defaultVis = AchievementStatus.Visible,
    description = "Clear " .. zone_name .. " with a score of {Amount}",
    description_vars = {
      Amount = { field = "amount", format = "number" },
    },
    apply = function(self)
      local id
      id = beholder.observe("OnEmberfrostClear", function()
        local currentScore = useTotalScore
            and _DATA.Save:GetTotalScore()
            or _DATA.Save.ActiveTeam.Money

        if currentScore >= self.amount then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end,
  }
end

add(CreateScoreAchievement("50K_ROCKY", "50k Rocky", 50000))
add(CreateScoreAchievement("SIX FIGURES", "Six Figures", 100000))
add(CreateScoreAchievement("HIGH_ROLLER", "High Roller", 500000))
add(CreateScoreAchievement("IMPOSSIBLE", "Impossible?", 1000000))

end

return group
