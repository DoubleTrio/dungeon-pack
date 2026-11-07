require 'trios_dungeon_pack.terrasphere.registry'
local descriptions = require 'trios_dungeon_pack.terrasphere.descriptions'
require 'trios_dungeon_pack.beholder'


TERRASPHERE_ACHIEVEMENT_GROUPS = {}

local zone_data = _DATA:GetZone("the_terrasphere")
local zone_name = zone_data:GetColoredName()

AchievementDefaults = {
  get_description = function(self)
    return descriptions.Format(self)
  end,
  apply = function(self)
    print(self.name .. " activated.")
  end,
}

AchievementRegistry = CreateRegistry({
  registry_table = {},
  defaults = AchievementDefaults,
})

local function AddToNotifyQueue(id)
  table.insert(SV.Terrasphere.Achievements.ToDisplay, id)
  SV.Terrasphere.Achievements.Statuses[id] = AchievementStatus.Achieved
end

local function ContainsEnchantment(id)
  return Contains(SV.Terrasphere.Enchantments.Selected, id)
end


local function AllEnchantsEqualOrGreater(value)
  for id in pairs(EnchantmentRegistry._registry) do
    if (SV.Terrasphere.Enchantments.Collection[id] or 0) < value then
      return false
    end
  end
  return true
end

function NotifyAchievements()

  UI:ResetSpeaker()
  for _, achievement_id in ipairs(SV.Terrasphere.Achievements.ToDisplay) do
    print(achievement_id)
    local achievement = AchievementRegistry:Get(achievement_id)
    local name = achievement.name
    local description = achievement:get_description()
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("Achievement Unlocked: %s\n(%s)", M_HELPERS.MakeColoredText(name, PMDColor.Cyan), description))
    UI:SetCenter(false)
  end
end

-- AllEnchantsEqualOrGreater


-- 4 puppers
function SetAchievementStatusIfNeeded(achievement_id, status)
  local achievement_value = SV.Terrasphere.Achievements.Statuses[achievement_id] or AchievementStatus.Hidden
  SV.Terrasphere.Achievements.Statuses[achievement_id] = math.max(achievement_value, status)
end

function InitializeAchievementCollection()
  for k, v in pairs(AchievementRegistry._registry) do
    SetAchievementStatusIfNeeded(k, math.max(AchievementStatus.Hidden, v.defaultVis))
  end
end

function InitializeAchievementListeners()
  StopAchievementListeners()
  local ok, err
  beholder.group(TERRASPHERE_ACHIEVEMENT_GROUPS, function()
    -- Catch inside the group so beholder always clears its current-group state.
    ok, err = pcall(function()
      for _, achievement in pairs(AchievementRegistry._registry) do
        if SV.Terrasphere.Achievements.Statuses[achievement.id] ~= AchievementStatus.Achieved then
          achievement:apply()
        end
      end
    end)
  end)
  if not ok then
    StopAchievementListeners()
    error(err, 0)
  end
end

function StopAchievementListeners()
  beholder.stopObserving(TERRASPHERE_ACHIEVEMENT_GROUPS)
end

return {
  zone_name = zone_name,
  AddToNotifyQueue = AddToNotifyQueue,
  ContainsEnchantment = ContainsEnchantment,
  AllEnchantsEqualOrGreater = AllEnchantsEqualOrGreater,
}
