local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local group = {}

function group.TheBubble(add)
TheBubble = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  interest = 0.10,
  start = 0,
  pop_increase = 1.5,
  loss = 0.45,
  name = "The Bubble",
  id = "THE_BUBBLE",
  cleanup = function (self)
    M_HELPERS.RemoveItemIDFromInventory("terrasphere_bubble")
  end,
  -- group = ENCHANTMENT_TYPES.items,
  description = "Gain a {Bubble} (Gain {Interest} interest at start of floor. If the {Bubble} pops, lose {Loss} of your {Money} and it will reset. Pop chance increases by {pop_increase} each floor)",
  description_vars = {
    Bubble = { get = function(self) return M_HELPERS.GetItemName("terrasphere_bubble") end, format = "text" },
    Interest = { get = function(self) return math.ceil(self.interest * 100) end, format = "percent" },
    Loss = { get = function(self) return math.ceil(self.loss * 100) end, format = "percent", color = "Red" },
    Money = { get = function(self) return PMDSpecialCharacters.Money end, format = "text" },
    pop_increase = { field = "pop_increase", format = "percent" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0
    local money_lost = data["money_lost"] or 0
    local pop_chance = data["pop_chance"] or 0

    return { "Money Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
      "Money Lost: " ..
      M_HELPERS.MakeColoredText(tostring(money_lost) .. " " .. PMDSpecialCharacters.Money, PMDColor.Red),
      "Current Pop Chance: " .. M_HELPERS.MakeColoredText(tostring(pop_chance) .. "%", PMDColor.Cyan) }
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    data["money_lost"] = 0
    data["pop_chance"] = self.start

    local items = { {
      Item = "terrasphere_bubble",
      Amount = 1
    } }
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

end

function group.TravelingMerchant(add)
TravelingMerchant = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  name = "Traveling Merchant",
  id = "TRAVELING_MERCHANT",

  
  description = "{Name} will join your journey until the next checkpoint. You can buy items or sell your entire inventory while they're with you",
  description_vars = {
    Name = { get = function(self) return _DATA:GetMonster("kecleon").Forms[0].FormName:ToLocal() end, format = "text", color = "Cyan" },
  },
  get_progress_texts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)
    return {}
  end,

  cleanup = function(self)
    RemoveGuestsWithValue(self.id)
  end,

  on_checkpoint = function(self)

    local data = EnchantmentRegistry:GetData(self)

    -- if not data["completed"] then
    --   local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    --   local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    --   UI:WaitShowDialogue(M_HELPERS.MakeColoredText(new_mob.Name, PMDColor.LimeGreen2) .. " has left your party")

    --   RemoveGuestsWithValue(self.id)
    --   data["completed"] = true
    -- end
  end,
 
  dialogue = function ()
    UI:WaitShowDialogue("Prep quickly! I have business ventures to attend to!")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Oh, I'm also happy to do business with you during our travels!")
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["completed"] = false
    RemoveGuestsWithValue(self.id)
    local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    local tactic = _DATA:GetAITactic("follower")
    new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("TravelingMerchantInteract")
    new_mob.ActionEvents:Add(talk_evt)
    local tbl = LTBL(new_mob)
    tbl[self.id] = true
    tbl.ID = self.id
    tbl.Items = {
      { Item = "food_apple", Amount = 1, Price = 300 },
      { Item = "berry_leppa", Amount = 1, Price = 1000 },
      { Item = "berry_sitrus", Amount = 1, Price = 500 },
      { Item = "seed_reviver",  Amount = 1, Price = 1000 },
    }

  
    GAME:SetCharacterSkill(new_mob, "slash", 0)
    GAME:SetCharacterSkill(new_mob, "feint_attack", 1)
    GAME:SetCharacterSkill(new_mob, "brick_break", 2)
    GAME:SetCharacterSkill(new_mob, "shadow_claw", 3)
    new_mob.SpeedBonus = 25
    new_mob.MaxHPBonus = 25
    new_mob.AtkBonus = 25
    new_mob.MAtkBonus = 25
    new_mob.DefBonus = 25
    new_mob.MDefBonus = 25
        
    -- if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(0), 3) ~= "" then
    --   GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species], 3) --override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
    -- else
    --   GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species])
    -- end
    local function AddRandomShopCategories(tbl)
      local categories = {
        -- Seeds
        function()
          local seed_amount = _DATA.Save.Rand:Next(2, 5)
          local seeds = GetRandomUnique(SEED, seed_amount)
          for _, item in ipairs(seeds) do
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = 100 })
          end
        end,
        -- Apricorns
        function()
          local apricorn_amount = _DATA.Save.Rand:Next(2, 4)
          local apricorns = GetRandomUnique(APRICORNS, apricorn_amount)
          for _, item in ipairs(apricorns) do
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = 1000 })
          end
        end,
        -- Orbs
        function()
          local orb_amount = _DATA.Save.Rand:Next(1, 4)
          local orbs = GetRandomUnique(ORBS, orb_amount)
          for _, item in ipairs(orbs) do
            local entry = _DATA:GetItem(item)
            local price = entry.Price
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = price * 3 })
          end
        end,
        -- Wands
        function()
          local wand_amount = _DATA.Save.Rand:Next(1, 3)
          local wands = GetRandomUnique(WANDS, wand_amount)
          for _, item in ipairs(wands) do
            table.insert(tbl.Items, { Item = item, Amount = 9, Price = 300 })
          end
        end
      }


      local chosen_indices = GetRandomUnique({ 1, 2, 3, 4 }, 2)


      for _, index in ipairs(chosen_indices) do
        categories[index]()
      end
    end

   
    AddRandomShopCategories(tbl)
    




    _DATA.Save.ActiveTeam.Guests:Add(new_mob)
    GAME:FadeOut(false, 40)

    GAME:WaitFrames(20)
    RespawnGuests()

    GAME:FadeIn(60)



    SOUND:PlayFanfare("Fanfare/NewTeam")
    UI:WaitShowDialogue("Added [color=#00FF00]" .. new_mob.Name .. "[color] to the party as a guest!")


    local player = CH('PLAYER')

    local count = _DATA.Save.ActiveTeam.Guests.Count 
    local guest = CH('Guest' .. count)

    print(tostring(guest))

    local old_dir_guest = guest.Direction
    local old_dir_player = player.Direction
    GROUND:CharTurnToChar(player, guest)
    GROUND:CharTurnToChar(guest, player)

    UI:SetSpeaker(new_mob)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Pleasure to make your acquaintance!")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("I hope we can do business together during our little journey.")
    print(tostring(new_mob))
    guest.Direction = old_dir_guest
    player.Direction = old_dir_player
  end
})


end

function group.RainingGold(add)
RainingGold = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  name = "Raining Gold",
  id = "RAINING_GOLD",
  initial = 2000,
  

  description = "Gain {initial}. At the start of each floor, a shower of {Money} falls from the sky",
  description_vars = {
    initial = { field = "initial", format = "money", space = false },
    Money = { get = function(self) return PMDSpecialCharacters.Money end, format = "text" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)

  end,

  set_active_effects = function(self, active_effect, zone_context)
    beholder.group(TERRASPHERE_BEHOLDER_GROUPS, function()
      local on_start_id
      
      on_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
    
        local arguments = {
          MinAmount = 7,
          MaxAmount = 11,
          Guaranteed = {},
          Items = {
            { Item = "money",      Amount = 50, Weight = 80 },
            { Item = "money",      Amount = 100, Weight = 15 },
            { Item = "money",      Amount = 200, Weight = 5 },
            { Item = "money",      Amount = 1200, Weight = 1 },

          },
          UseUserCharLoc = true,
        }

        GAME:WaitFrames(10)
        local old = context.User
        context.User = _DUNGEON.ActiveTeam.Leader
        SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
        context.User = old
        GAME:WaitFrames(20)
      end) 
    end)
  end,

  apply = function(self)
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.initial
    SOUND:PlayFanfare("Fanfare/Item")
    UI:SetCenter(true)
    UI:WaitShowDialogue("You gained " .. tostring(self.initial) .. " " .. PMDSpecialCharacters.Money .. "!")
    UI:SetCenter(false)
  end
})


end

function group.Shopper(add)
Shopper = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  name = "Shopper",
  id = "SHOPPER",
  amount = 1000,

  description = "Gain {amount}. The likelihood of shopkeepers appearing in the dungeon is increased.",
  description_vars = {
    amount = { field = "amount", format = "money", space = true },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("ShopperRefresh",
      Serpent.line({ 
        Rate = 15, 
      })))
  end,

  apply = function(self)
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.gold_amount

    FanfareText("You gained " .. tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money .. "!")
    FanfareText(string.format(
      "Shopkeepers are more likely to appear in the dungeon!"))
  end
})

end

function group.TreasureHunt(add)
TreasureHunt = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  name = "Treasure Hunt",
  id = "TREASURE_HUNT",
  amount = 1000,

  description = "Gain {amount}. The likelihood of chests appearing in the dungeon is increased.",
  description_vars = {
    amount = { field = "amount", format = "money", space = true },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("TreasureHunt",
        Serpent.line({
          Rate = 15,
        })))
  end,

  apply = function(self)

    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.amount

    FanfareText("You gained " .. tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money .. "!")
    FanfareText(string.format(
      "Chests are more likely to appear in the dungeon!"))
  end
})


end

function group.LooseChange(add)
LooseChange = add({
  rarity = EnchantmentRarity.Common,
  tags = { "economy" },
  name = "Loose Change",
  id = "LOOSE_CHANGE",

  description = "More {Money} can be found while exploring the dungeon",
  description_vars = {
    Money = { get = function(self) return PMDSpecialCharacters.Money end, format = "text" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- MAKE IT ZONE CONTEXT DEPENDENT
    local rate = 300
    if zone_context.CurrentSegment ~= 0 then
      return
    end

    if zone_context.CurrentID >= 15 then
      rate = 600
    end
    
  
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("LooseChange",
        Serpent.line({
          Rate = rate,
        })))
  end,

  apply = function(self)
    FanfareText(string.format(
      "You will find more " .. PMDSpecialCharacters.Money .. " while exploring the dungeon!"))
  end
})

function AssignCharacterEnchantment(chara, enchantment_id)
  local tbl = LTBL(chara)

  tbl.Enchantments = tbl.Enchantments or {}
  tbl.Enchantments[enchantment_id] = true
end

function AssignEnchantmentToCharacter(enchant, show_message)
  local ret = {}
  local choose = function(chars)
    ret = chars
    _MENU:RemoveMenu()
  end
  local refuse = function()
  end
  local menu = TeamMultiSelectMenu:new(string.format("Assign %s to?",
    M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)), _DATA.Save.ActiveTeam.Players, function()
    return true
  end, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  local selected_char = ret[1]


  AssignCharacterEnchantment(selected_char, enchant.id)
  if show_message == nil then
    show_message = true
  end

  if show_message then
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("%s got the %s enchantment!", selected_char:GetDisplayName(true),
        M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)))
    UI:SetCenter(false)
  end
  return selected_char
end



end

return group
