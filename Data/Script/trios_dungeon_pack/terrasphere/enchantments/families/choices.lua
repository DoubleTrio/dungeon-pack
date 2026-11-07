local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local enchantment_offers = require 'trios_dungeon_pack.terrasphere.enchantments.offers'
local group = {}

function group.TwoForOne(add)
TwoForOne = add({
  rarity = EnchantmentRarity.Common,
  tags = { "choices" },
  name = "2 for 1",
  id = "TWO_FOR_ONE",
  amount = 2,
  description = "Gain {amount} random {amount:plural:enchantment:enchantments}",
  description_vars = {
    amount = { field = "amount", format = "number" },
  },

  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local enchant_ids = data["selected_enchantments"]
    local texts = {}
    for _, enchant_id in ipairs(enchant_ids) do
      local enchant = EnchantmentRegistry._registry[enchant_id]
      if enchant then
        table.insert(texts, "Recieved: " .. M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow))
      end
    end

    return texts
  end,

  offer_time = "beginning",
  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["selected_enchantments"] = {}
    local enchantments = enchantment_offers.GetRandom(self.amount)


    for _, enchantment in ipairs(enchantments) do
      local data = EnchantmentRegistry:GetData(self)
      table.insert(data["selected_enchantments"], enchantment.id)

      enchantment:apply()

      table.insert(SV.Terrasphere.Enchantments.Selected, enchantment.id)
    end
  end,
})

end

function group.MysteryEnchant(add)
MysteryEnchant = add({
  rarity = EnchantmentRarity.Common,
  tags = { "choices" },
  gold_amount = 4000,
  name = "Mystery Enchant",
  id = "MYSTERY_ENCHANT",
  description = "Gain a random enchantment and {gold_amount}.",
  description_vars = {
    gold_amount = { field = "gold_amount", format = "money", space = true },
  },

  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local enchant_id = data["selected_enchantment"]
    local enchant = EnchantmentRegistry._registry[enchant_id]
    if enchant then
      return {
        "Recieved: " .. M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow),
      }
    end

    return {}
  end,

  offer_time = "beginning",
  apply = function(self)
    local enchantment = enchantment_offers.GetRandom(1)[1]
    if enchantment == nil then
      UI:WaitShowDialogue("No eligible enchantments are available right now.")
      return
    end

    print(tostring(self.id) .. " applying enchantment: " .. tostring(enchantment.id))
    local data = EnchantmentRegistry:GetData(self)

    data["selected_enchantment"] = enchantment.id

    enchantment:apply()

    table.insert(SV.Terrasphere.SelectedEnchantments, enchantment.id)

    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.gold_amount
    SOUND:PlayFanfare("Fanfare/Item")
    UI:SetCenter(true)
    UI:WaitShowDialogue("You gained " .. tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money .. "!")
    UI:SetCenter(false)

  end,

})

end

return group
