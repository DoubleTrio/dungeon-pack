local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local group = {}

function group.SightSeer(add)
SightSeer = add({
  rarity = EnchantmentRarity.Common,
  tags = { "exploration" },
  name = "Sightseer",
  id = "SIGHTSEER",

  
  description = "A traveling escort will join your party as a guest until the next checkpoint. If they make it to the next checkpoint, you'll receive a reward",

  get_progress_texts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)
    return {}
  end,

  on_checkpoint = function(self)

    -- local data = EnchantmentRegistry:GetData(self)

    -- if not data["completed"] then
    --   local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    --   local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    --   UI:WaitShowDialogue(M_HELPERS.MakeColoredText(new_mob.Name, PMDColor.LimeGreen2) .. " has left your party")

    --   RemoveGuestsWithValue(self.id)
    --   data["completed"] = true
    -- end
  end,
 
  dialogue = function ()
    -- UI:WaitShowDialogue("Prep quickly! I have business ventures to attend to!")
    -- UI:SetSpeakerEmotion("Happy")
    -- UI:WaitShowDialogue("Oh, I'm also happy to do business with you during our travels!")
  end,

  apply = function(self)
    -- local data = EnchantmentRegistry:GetData(self)
    -- data["completed"] = false
    -- RemoveGuestsWithValue(self.id)
    -- local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    -- local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    -- local tactic = _DATA:GetAITactic("follower")
    -- new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
    -- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("TravelingMerchantInteract")
    -- new_mob.ActionEvents:Add(talk_evt)
    -- local tbl = LTBL(new_mob)
    -- tbl[self.id] = true
    -- tbl.ID = self.id
    -- tbl.Items = {
    --   { Item = "food_apple", Amount = 1, Price = 300 },
    --   { Item = "berry_leppa", Amount = 1, Price = 1000 },
    --   { Item = "berry_sitrus", Amount = 1, Price = 500 },
    --   { Item = "seed_reviver",  Amount = 1, Price = 1000 },
    -- }

  
    -- GAME:SetCharacterSkill(new_mob, "slash", 0)
    -- GAME:SetCharacterSkill(new_mob, "feint_attack", 1)
    -- GAME:SetCharacterSkill(new_mob, "brick_break", 2)
    -- GAME:SetCharacterSkill(new_mob, "shadow_claw", 3)
    -- new_mob.SpeedBonus = 25
    -- new_mob.MaxHPBonus = 25
    -- new_mob.AtkBonus = 25
    -- new_mob.MAtkBonus = 25
    -- new_mob.DefBonus = 25
    -- new_mob.MDefBonus = 25
        
    -- -- if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(0), 3) ~= "" then
    -- --   GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species], 3) --override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
    -- -- else
    -- --   GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species])
    -- -- end
    -- local function AddRandomShopCategories(tbl)
    --   local categories = {
    --     -- Seeds
    --     function()
    --       local seed_amount = _DATA.Save.Rand:Next(2, 5)
    --       local seeds = GetRandomUnique(SEED, seed_amount)
    --       for _, item in ipairs(seeds) do
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = 100 })
    --       end
    --     end,
    --     -- Apricorns
    --     function()
    --       local apricorn_amount = _DATA.Save.Rand:Next(2, 4)
    --       local apricorns = GetRandomUnique(APRICORNS, apricorn_amount)
    --       for _, item in ipairs(apricorns) do
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = 1000 })
    --       end
    --     end,
    --     -- Orbs
    --     function()
    --       local orb_amount = _DATA.Save.Rand:Next(1, 4)
    --       local orbs = GetRandomUnique(ORBS, orb_amount)
    --       for _, item in ipairs(orbs) do
    --         local entry = _DATA:GetItem(item)
    --         local price = entry.Price
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = price * 3 })
    --       end
    --     end,
    --     -- Wands
    --     function()
    --       local wand_amount = _DATA.Save.Rand:Next(1, 3)
    --       local wands = GetRandomUnique(WANDS, wand_amount)
    --       for _, item in ipairs(wands) do
    --         table.insert(tbl.Items, { Item = item, Amount = 9, Price = 300 })
    --       end
    --     end
    --   }


    --   local chosen_indices = GetRandomUnique({ 1, 2, 3, 4 }, 2)


    --   for _, index in ipairs(chosen_indices) do
    --     categories[index]()
    --   end
    -- end

   
    -- AddRandomShopCategories(tbl)
    




    -- _DATA.Save.ActiveTeam.Guests:Add(new_mob)
    -- GAME:FadeOut(false, 40)

    -- GAME:WaitFrames(20)
    -- RespawnGuests()

    -- GAME:FadeIn(60)



    -- SOUND:PlayFanfare("Fanfare/NewTeam")
    -- UI:WaitShowDialogue("Added [color=#00FF00]" .. new_mob.Name .. "[color] to the party as a guest!")


    -- local player = CH('PLAYER')

    -- local count = _DATA.Save.ActiveTeam.Guests.Count 
    -- local guest = CH('Guest' .. count)

    -- print(tostring(guest))

    -- local old_dir_guest = guest.Direction
    -- local old_dir_player = player.Direction
    -- GROUND:CharTurnToChar(player, guest)
    -- GROUND:CharTurnToChar(guest, player)

    -- UI:SetSpeaker(new_mob)
    -- UI:SetSpeakerEmotion("Happy")
    -- UI:WaitShowDialogue("Pleasure to make your acquaintance!")
    -- UI:SetSpeakerEmotion("Normal")
    -- UI:WaitShowDialogue("I hope we can do business together during our little journey.")
    -- print(tostring(new_mob))
    -- guest.Direction = old_dir_guest
    -- player.Direction = old_dir_player
  end
})


end

return group
