local runtime = require 'trios_dungeon_pack.emberfrost.achievements.runtime'
local zone_name = runtime.zone_name
local AddToNotifyQueue = runtime.AddToNotifyQueue
local ContainsEnchantment = runtime.ContainsEnchantment
local AllEnchantsEqualOrGreater = runtime.AllEnchantsEqualOrGreater

local group = {}

function group.enchantment_challenges(add)
add({
  id = "CHAOS",
  name = "Chaos",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    local enchantment = EnchantmentRegistry:Get(PandorasItems.id)
    return "Clear " .. zone_name .. " with the " .. enchantment.name .. " enchantment"
  end,
  apply = function(self)

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
  end,
})


add({
  id = "SIDE_QUESTER",
  name = "Side Quester",
  amount = 23 * 600,
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Have at least " .. M_HELPERS.MakeColoredText(self.amount .. " ", PMDSpecialCharacters.Money, PMDColor.Cyan) .. " from " .. QuestMaster.name .. " enchantment"
  end,
  apply = function(self)
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
  end,
})

add({
  id = "FULL_SPECTRUM",
  name = "Full Spectrum",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Receive the massive reward from " .. TypeMaster.name .. " enchantment"
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnTypeMasterComplete", function()

      AddToNotifyQueue(self.id)
      beholder.stopObserving(id)
    end)
  end,
})

add({
  id = "MARKET_CRASH",
  name = "Market Crash",
  amount = 25000,
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Lose at least" .. M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Red) .. " from " .. TypeMaster.name .. " all at once"
  end,
  apply = function(self)
    local id
    id = beholder.observe("TheBubbleLost", function(lost, total, pop_chance)
      if lost >= self.amount then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

add({
  id = "STONKS",
  name = "Stonks",
  amount = 5000,
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Gain at least " ..
    M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) ..
    " from " .. TypeMaster.name .. " all at once"
  end,
  apply = function(self)
    local id
    id = beholder.observe("TheBubbleGained", function(gained, total, pop_chance)
      if gained >= self.amount then
        AddToNotifyQueue(self.id)
        beholder.stopObserving(id)
      end
    end)
  end,
})

add({
  id = "NOT_TODAY",
  name = "Not Today!",
  defaultVis = AchievementStatus.Hidden,
  get_description = function(self)
    return "Have a member survive the Wheel of Fortune" 
  end,
  apply = function(self)
    local id
    id = beholder.observe("OnNotToday", function()
      AddToNotifyQueue(self.id)
      beholder.stopObserving(id)
    end)
  end,
})

end

return group
