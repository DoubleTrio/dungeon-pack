require 'trios_dungeon_pack.beholder'


EMBERFROST_ACHIEVEMENT_GROUPS = {}

local zone_data = _DATA:GetZone("emberfrost_depths")
local zone_name = zone_data:GetColoredName()

AchievementDefaults = {
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
  for i, enchantment in ipairs(EnchantmentRegistry._registry) do
    local id = enchantment.id
    if (SV.EmberFrost.Enchantments.Collection[id] or 0 < value) then
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
    local description = achievement:getDescription()
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("Achievement Unlocked: %s\n(%s)", M_HELPERS.MakeColoredText(name, PMDColor.Cyan), description))
    UI:SetCenter(false)
  end
end

-- AllEnchantsEqualOrGreater


AchievementRegistry:Register({
  id = "FIRST_TRY",
  name = "First Try!",
  defaultVis = AchievementStatus.Visible,
  getDescription = function(self)
    -- local enchantment = EnchantmentRegistry:Get()
    return "Clear " .. zone_name .. " for the first time"
  end,
  apply = function(self)
      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local id
        id = beholder.observe("OnEmberfrostClear", function()
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end)
      end)
  end,
})


local function CreateScoreAchievement(id, name, amount, useTotalScore)
  return {
    amount = amount,
    id = id,
    name = name,
    defaultVis = AchievementStatus.Visible,
    getDescription = function(self)
      return "Clear " .. zone_name .. " with a score of " ..
          M_HELPERS.MakeColoredText(self.amount, PMDColor.Cyan)
    end,
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

AchievementRegistry:Register(CreateScoreAchievement("50K_ROCKY", "50k Rocky", 50000))
AchievementRegistry:Register(CreateScoreAchievement("SIX FIGURES", "Six Figures", 100000))
AchievementRegistry:Register(CreateScoreAchievement("HIGH_ROLLER", "High Roller", 500000))
AchievementRegistry:Register(CreateScoreAchievement("IMPOSSIBLE", "Impossible?", 1000000))

AchievementRegistry:Register({
  id = "SOLO_MISSION",
  name = "Solo Mission",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Clear " .. zone_name .. " with only the character you entered with"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnEmberfrostClear", function()
        local assembly_count = CountAssemblyWithKey("EmberfrostRun")
        SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
        if assembly_count == 0 and _DATA.Save.ActiveTeam.Players.Count == 1 then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "ENCHANTMENT_ENCYCLOPEDIA",
  name = "Enchantment Encyclopedia",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "See all the enchants"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnEnchantmentSeen", function()
        SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
        if AllEnchantsEqualOrGreater(EnchantmentStatus.Seen) then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "Arcanist",
  name = "ARCANIST",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Win with all the enchants"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnEmberfrostClear", function()
        SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
        if AllEnchantsEqualOrGreater(EnchantmentStatus.SelectedAndWon) then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "PURIST",
  name = "Purist",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Clear " .. zone_name .. " with no enchants"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnEmberfrostClear", function()
        SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
        if #SV.EmberFrost.Enchantments.Selected <= 0 then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "CHAOS",
  name = "Chaos",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    local enchantment = EnchantmentRegistry:Get(PandorasItems.id)
    return "Clear " .. zone_name .. " with the " .. enchantment.name .. " enchantment"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()

      local enchantment_selected_id

      enchantment_selected_id = beholder.observe("OnEnchantmentSelected", function(enchantment_id)
        if enchantment_id == PandorasItems.id then
          SetAchievementStatusIfNeeded(self.id, AchievementStatus.Visible)
          beholder.stopObserving(enchantment_selected_id)
        end
      end)
      
      local id
      id = beholder.observe("OnEmberfrostClear", function()
        if ContainsEnchantment(PandorasItems.id) then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
          beholder.stopObserving(enchantment_selected_id)
        end
      end)
    end)
  end,
})


AchievementRegistry:Register({
  id = "SIDE_QUESTER",
  name = "Side Quester",
  amount = 23 * 600,
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Have at least " .. M_HELPERS.MakeColoredText(self.amount .. " ", PMDSpecialCharacters.Money, PMDColor.Cyan) .. " from " .. QuestMaster.name .. " enchantment"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnQuestComplete", function()
        -- if ContainsEnchantment(QuestMaster.id) then
        local data = EnchantmentRegistry:GetData(QuestMaster.id)
        local money_earned = data["money_earned"]
        if money_earned >= self.amount then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "FULL_SPECTRUM",
  name = "Full Spectrum",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Receive the massive reward from " .. TypeMaster.name .. " enchantment"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnTypeMasterComplete", function()

        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "MARKET_CRASH",
  name = "Market Crash",
  amount = 25000,
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Lose at least" .. M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Red) .. " from " .. TypeMaster.name .. " all at once"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("TheBubbleLost", function(lost, total, pop_chance)
        if lost >= self.amount then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "STONKS",
  name = "Stonks",
  amount = 5000,
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Gain at least " ..
    M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) ..
    " from " .. TypeMaster.name .. " all at once"
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("TheBubbleGained", function(gained, total, pop_chance)
        if gained >= self.amount then
          AddToNotifyQueue(self.id)
          beholder.stopObserving(id)
        end
      end)
    end)
  end,
})

AchievementRegistry:Register({
  id = "NOT_TODAY",
  name = "Not Today!",
  defaultVis = AchievementStatus.Hidden,
  getDescription = function(self)
    return "Have a member survive the Wheel of Fortune" 
  end,
  apply = function(self)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnNotToday", function()
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end)
    end)
  end,
})

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
  for _, achievement in pairs(AchievementRegistry._registry) do
    local id = achievement.id
    if SV.EmberFrost.Achievements.Statuses[id] ~= AchievementStatus.Achieved then
      achievement:apply()
    end
  end
end

function StopAchievementListeners()
  beholder.stopObserving(EMBERFROST_ACHIEVEMENT_GROUPS)
end
