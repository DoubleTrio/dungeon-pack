require 'trios_dungeon_pack.beholder'

-- Clear Emberfrost with the Jeweled Bug enchantment
-- Clear Emberfrost with X amount from Task Master
-- Clear Emberfrost with 10000 score
-- Clear Emberfrost with 100000 score
-- Clear Emberfrost with 50000 score
-- Clear Emberfrost with 1000000 score
-- Clear Emberfrost with no enchants
-- Clear Emberfrost with only the mon you entered with
-- Clear Emberfrost with a score of 500000
-- See all the enchants
-- Select all enchants
-- Cash out reward from Type Master
-- ??? - maybe secret achievement?

-- NotifyAchievementsFunction
-- Check 


EMBERFROST_ACHIEVEMENT_GROUPS = {}

AchievementDefaults = {
  apply = function(self)
    print(self.name .. " activated.")
  end,
}

AchievementRegistry = CreateRegistry({
  registry_table = {},
  defaults = AchievementDefaults,
})


AchievementRegistry:Register({
  id = "QUEST_MASTER",
  name = "Quest Master",
  getDescription = function(self)
    return "Clear Emberfrost with the Jeweled Bug enchantment"
  end,
  apply = function(self)

  end,
})
AchievementRegistry:Register({
  id = "BIG_BUG",
  name = "Big Bug!",
  getDescription = function(self)
    return "Clear Emberfrost with the Jeweled Bug enchantment"
  end,
  apply = function(self)
    
  end,
})

AchievementRegistry:Register({
  amount = 600 * 30,
  id = "QUEST_MASTER",
  name = "Quest Master",
  getDescription = function(self)
    local money = self.amount
    return "Clear Emberfrost with " .. money .. " money"
  end,
  apply = function(self)

  end,
})


AchievementRegistry:Register({
  id = "CLEAR",
  name = "Clear Emberfrost",
  apply = function(self)

  end,
})
