require 'trios_dungeon_pack.emberfrost.registry'
local descriptions = require 'trios_dungeon_pack.emberfrost.descriptions'
require 'trios_dungeon_pack.beholder'


EMBERFROST_ACHIEVEMENT_GROUPS = {}

local zone_data = _DATA:GetZone("emberfrost_depths")
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
  table.insert(SV.EmberFrost.Achievements.ToDisplay, id)
  SV.EmberFrost.Achievements.Statuses[id] = AchievementStatus.Achieved
end

local function ContainsEnchantment(id)
  return Contains(SV.EmberFrost.Enchantments.Selected, id)
end


local function AllEnchantsEqualOrGreater(value)
  for id in pairs(EnchantmentRegistry._registry) do
    if (SV.EmberFrost.Enchantments.Collection[id] or 0) < value then
      return false
    end
  end
  return true
end

function NotifyAchievements()

  UI:ResetSpeaker()
  for _, achievement_id in ipairs(SV.EmberFrost.Achievements.ToDisplay) do
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
  local achievement_value = SV.EmberFrost.Achievements.Statuses[achievement_id] or AchievementStatus.Hidden
  SV.EmberFrost.Achievements.Statuses[achievement_id] = math.max(achievement_value, status)
end

function InitializeAchievementCollection()
  for k, v in pairs(AchievementRegistry._registry) do
    SetAchievementStatusIfNeeded(k, math.max(AchievementStatus.Hidden, v.defaultVis))
  end
end

function InitializeAchievementListeners()
  StopAchievementListeners()
  local ok, err
  beholder.group(EMBERFROST_ACHIEVEMENT_GROUPS, function()
    -- Catch inside the group so beholder always clears its current-group state.
    ok, err = pcall(function()
      for _, achievement in pairs(AchievementRegistry._registry) do
        if SV.EmberFrost.Achievements.Statuses[achievement.id] ~= AchievementStatus.Achieved then
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
  beholder.stopObserving(EMBERFROST_ACHIEVEMENT_GROUPS)
end

return {
  zone_name = zone_name,
  AddToNotifyQueue = AddToNotifyQueue,
  ContainsEnchantment = ContainsEnchantment,
  AllEnchantsEqualOrGreater = AllEnchantsEqualOrGreater,
}
