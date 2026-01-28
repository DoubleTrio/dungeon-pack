
-- require 'trios_dungeon_pack.beholder'

-- OrbStateType = luanet.import_type('PMDC.Dungeon.OrbState')
-- BerryStateType = luanet.import_type('PMDC.Dungeon.BerryState')
-- EdibleStateType = luanet.import_type('PMDC.Dungeon.EdibleState')
-- GummiStateType = luanet.import_type('PMDC.Dungeon.GummiState')
-- DrinkStateType = luanet.import_type('PMDC.Dungeon.DrinkState')
-- WandStateType = luanet.import_type('PMDC.Dungeon.WandState')

-- AmmoStateType = luanet.import_type('PMDC.Dungeon.AmmoState')
-- UtilityStateType = luanet.import_type('PMDC.Dungeon.UtilityState')
-- HeldStateType = luanet.import_type('PMDC.Dungeon.HeldState')
-- EquipStateType = luanet.import_type('PMDC.Dungeon.EquipState')
-- EvoStateType = luanet.import_type('PMDC.Dungeon.EvoState')
-- SeedStateType = luanet.import_type('PMDC.Dungeon.SeedState')

-- MachineStateType = luanet.import_type('PMDC.Dungeon.MachineState')
-- RecruitStateType = luanet.import_type('PMDC.Dungeon.RecruitState')
-- CurerStateType = luanet.import_type('PMDC.Dungeon.CurerState')
-- FoodStateType = luanet.import_type('PMDC.Dungeon.FoodState')
-- HerbStateType = luanet.import_type('PMDC.Dungeon.HerbState')
-- UnrecruitableType = luanet.import_type('PMDC.LevelGen.MobSpawnUnrecruitable')

-- RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')

-- local function get_item_from_context(context)
--   local index = context.UsageSlot
--   local item
--   if index >= -1 then
--     item = _DATA.Save.ActiveTeam:GetInv(index).ID
--   elseif index == -1 then
--     item = context.User.EquippedItem.ID
--   elseif index == -2 then
--     local map_slot = _ZONE.CurrentMap:GetItem(context.User.CharLoc)
--     item = _ZONE.CurrentMap.Items[map_slot].Value
--   end

--   return item
-- end

-- local function item_id_contains_state(item_id, state_type)
--   local item_data = _DATA:GetItem(item_id)
--   local contains = item_data.ItemStates:Contains(luanet.ctype(state_type))
--   return contains
-- end

-- QuestDefaults = {

--   can_apply = function()
--     return true
--   end,

--   complete_quest = function(self)
--     local data = QuestRegistry:GetData(self)

--     local enchantment_data = EnchantmentRegistry:GetData(QuestMaster)

--     if not data["completed"] then
--       data["completed"] = true
--       _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.reward
--       enchantment_data["money_earned"] = enchantment_data["money_earned"] + self.reward
--       if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
--         SOUND:PlayFanfare("Fanfare/Note")
--         UI:WaitShowDialogue(string.format("Completed Quest! %s (%s)", self:getDescription(),
--           M_HELPERS.MakeColoredText(tostring(self.reward), PMDColor.Cyan) .. " " .. PMDSpecialCharacters.Money))
--       end
--     end
--   end,
--   -- Called at the beginning of each floor
--   cleanup = function(self)

--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     print(self.name .. " set quest map effect.")
--     -- print(self.name .. " activated.")
--   end,

--   getDescription = function(self)
--     return ""
--   end,

--   getProgressTexts = function(self)
--     return {}
--   end
-- }

-- QuestMaster = EnchantmentRegistry:Register({
--   name = "Quest Master",
--   id = "QUEST_MASTER",
--   task_amount = 2,
--   getDescription = function(self)
--     return string.format("At the start of each floor, receive %s quests to gain " .. PMDSpecialCharacters.Money,
--       M_HELPERS.MakeColoredText(tostring(self.task_amount), PMDColor.Cyan))
--   end,
--   rarity = 1,
--   getProgressTexts = function(self)
--     local data = EnchantmentRegistry:GetData(self)
--     local currents_quests = SV.EmberFrost.Quests.Active
--     local selected = QuestRegistry:GetSelected(currents_quests)
--     local progress_texts = {}

--     local money_earned = data["money_earned"] or 0

--     if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
--       table.insert(progress_texts,
--         string.format("Quests (Earned %s %s): ",
--           M_HELPERS.MakeColoredText(tostring(money_earned), PMDColor.Cyan), PMDSpecialCharacters.Money))
--       for _, quest in ipairs(selected) do
--         local description = quest:getDescription()
--         local texts = quest:getProgressTexts()
--         local data = QuestRegistry:GetData(quest)
--         local completed = data["completed"] or false
--         local icon = completed and PMDSpecialCharacters.Check or PMDSpecialCharacters.Cross
--         if texts then
--           table.insert(progress_texts, "")
--           table.insert(progress_texts, description ..
--             string.format(" (%s %s)", M_HELPERS.MakeColoredText(tostring(quest.reward), PMDColor.Cyan),
--               PMDSpecialCharacters.Money))

--           for i, text in ipairs(texts) do
--             local prefix = (i == #texts) and (icon .. " ") or ""
--             table.insert(progress_texts, prefix .. text)
--           end
--         end
--       end
--     else
--       table.insert(progress_texts, "Total Earned: " ..
--         M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
--     end
--     return progress_texts
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local quests = QuestRegistry:GetRandom(self.task_amount, 1)[1]

--     SV.EmberFrost.Quests.Active = M_HELPERS.map(quests, function(q)
--       return q.id
--     end)
--     SV.EmberFrost.Quests.Data = {}
--     local data = EnchantmentRegistry:GetData(self)
--     data["money_earned"] = 0

--     print(Serpent.block(SV.EmberFrost.Quests.Active) .. ".... selected quests")

--     for _, quest in ipairs(quests) do
--       quest:set_active_effects(active_effect)
--       print(quest.id .. " set active effects.")
--     end
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("LogQuests"))
--   end,

--   apply = function(self)
--     -- UI:SetCenter(true)
--     SOUND:PlayFanfare("Fanfare/Note")
--     UI:WaitShowDialogue("You will now receive quests at the start of each floor. Complete them to earn " ..
--       PMDSpecialCharacters.Money .. "!")
--     UI:WaitShowDialogue("You can check your quests in the Others -> Enchants menu while in dungeon.")
--     -- UI:SetCenter(false)
--   end
-- })


-- QuestDefaults = {

--   can_apply = function()
--     return true
--   end,

--   complete_quest = function(self)
--     local data = QuestRegistry:GetData(self)

--     local enchantment_data = EnchantmentRegistry:GetData(QuestMaster)

--     if not data["completed"] then
--       data["completed"] = true
--       _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.reward
--       enchantment_data["money_earned"] = enchantment_data["money_earned"] + self.reward
--       if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
--         SOUND:PlayFanfare("Fanfare/Note")
--         UI:WaitShowDialogue(string.format("Completed Quest! %s (%s)", self:getDescription(),
--           M_HELPERS.MakeColoredText(tostring(self.reward), PMDColor.Cyan) .. " " .. PMDSpecialCharacters.Money))
--       end
--     end
--   end,
--   -- Called at the beginning of each floor
--   cleanup = function(self)

--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     print(self.name .. " set quest map effect.")
--     -- print(self.name .. " activated.")
--   end,

--   getDescription = function(self)
--     return ""
--   end,

--   getProgressTexts = function(self)
--     return {}
--   end
-- }




-- QuestRegistry = CreateRegistry({
--   registry_table = {},
--   data_table_path = "EmberFrost.Quests.Data",
--   selected_table_path = "EmberFrost.Quests.Active",
--   defaults = QuestDefaults,
--   selection_field = "Quests",
--   debug = true
-- })

-- local function CreateBountyQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     reward = config.reward,

--     getDescription = function(self)
--       local data = QuestRegistry:GetData(self)
--       local species = data["bounty_target"]
--       local name = _DATA:GetMonster(species).Forms[0].FormName:ToLocal()
--       local amount_text = M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " "

--       return string.format("Defeat %s%s", amount_text, M_HELPERS.MakeColoredText(name, PMDColor.LimeGreen2))
--     end,

--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
--       data["defeated_enemies"] = 0
--       local on_death_id
--       local on_map_start_id

--       on_map_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
--         local possible_spawns = GetFloorSpawns()
--         local rand_spawn = possible_spawns[_DATA.Save.Rand:Next(#possible_spawns) + 1]
--         local data = QuestRegistry:GetData(self)
--         data["bounty_target"] = rand_spawn
--       end)

--       on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
--         local team = context.User.MemberTeam
--         if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and context.User.MemberTeam ~=
--               _DUNGEON.ActiveTeam) then
--           if context.User.BaseForm.Species ~= data["bounty_target"] then
--             return
--           end
--           data["defeated_enemies"] = data["defeated_enemies"] + 1
--           if data["defeated_enemies"] >= self.amount then
--             data["defeated_enemies"] = self.amount
--             beholder.stopObserving(on_death_id)
--             beholder.stopObserving(on_map_start_id)
--             self:complete_quest()
--           end
--         end
--       end)
--     end,

--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)
--       local defeated_enemies = data["defeated_enemies"] or 0
--       return { "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateBountyQuest({
--   id = "BOUNTY",
--   amount = 1,
--   reward = 200
-- }))

-- QuestRegistry:Register(CreateBountyQuest({
--   id = "BOUNTY_3",
--   amount = 3,
--   reward = 800
-- }))


-- QuestRegistry:Register({
--   id = "LOW_PP",
--   amount = 1,
--   pp = 5,
--   reward = 1000,

--   getDescription = function(self)
--     local member_text = self.amount == 1 and "member" or "members"
--     return string.format(
--       "Let %s %s with all moves at %s PP or less",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       member_text,
--       M_HELPERS.MakeColoredText(tostring(self.pp), PMDColor.Cyan)
--     )
--   end,
  
--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
    
--     local on_turn_ends_id
--     on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--       local members_with_low_pp = 0
      
--       for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
--         local all_moves_low = true
        
--         for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
--           local skill = member.BaseSkills[ii]
--           if not skill.SkillNum ~= "" and skill.SkillNum ~= nil then
--             local charges = skill.Charges
--             if charges > self.pp then
--               all_moves_low = false
--               break
--             end
--           end
--         end
        
--         if all_moves_low then
--           members_with_low_pp = members_with_low_pp + 1
--         end
--       end
      
--       if members_with_low_pp >= self.amount then
--         beholder.stopObserving(on_turn_ends_id)
--         GAME:WaitFrames(30)
--         self:complete_quest()
--       end
--     end)
--   end,
  
--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local status = data["completed"] and "Completed" or "Not Completed"
--     return {
--       "",
--       status
--     }
--   end
-- })



-- QuestRegistry:Register({
--   id = "DEFEAT_ENEMY_WITH_PROJECTILE",
--   amount = 1,
--   reward = 300,
--   getDescription = function(self)
--     return string.format("Defeat an enemy with a projectile")
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["defeated_enemies"] = 0

--     local after_actions_id

--     local on_turn_ends_id
--     after_actions_id = beholder.observe("AfterActions", function(owner, ownerChar, context, args)
--       local team = context.User.MemberTeam
--       -- if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and team ~= _DUNGEON.ActiveTeam) then
--         if context.ActionType == RogueEssence.Dungeon.BattleActionType.Throw and team == _DUNGEON.ActiveTeam then
--           TotalKnockoutsTypes = luanet.import_type('PMDC.Dungeon.TotalKnockouts')
--           local knockouts = context:GetContextStateInt(luanet.ctype(TotalKnockoutsTypes), true, 0)

--           if knockouts > 0 then
--             print("Defeated enemy with projectile!")
--             data["defeated_enemies"] = data["defeated_enemies"] + knockouts
--           end

--         end
--     end)

--     on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--       if data["defeated_enemies"] >= self.amount then
--         beholder.stopObserving(after_actions_id)
--         beholder.stopObserving(on_turn_ends_id)
--         data["defeated_enemies"] = self.amount
--         GAME:WaitFrames(30)
--         self:complete_quest()
--       end
--     end)


--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local defeated_enemies = data["defeated_enemies"]
--     return { "", "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- })


-- local function CreateProjectileQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     reward = config.reward,
    
--     getDescription = config.getDescription or function(self)
--       local plural = self.amount == 1 and "enemy" or "enemies"
--       return string.format(
--         "Hit %s %s with projectiles", 
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--         plural
--       )
--     end,
    
--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
--       data["hits"] = 0
      

--       local on_hits_id
--       local on_turn_ends_id
--       on_hits_id = beholder.observe("OnHits", function(owner, ownerChar, context, args)
--         local target_team = context.Target.MemberTeam
--         local user_team = context.User.MemberTeam
        
--         if user_team == nil or user_team ~= _DUNGEON.ActiveTeam then
--           return
--         end
        
--         if target_team == nil or target_team == _DUNGEON.ActiveTeam then
--           return
--         end
  
--         if target_team.MapFaction ~= RogueEssence.Dungeon.Faction.Foe then
--           return
--         end
        
--         if context.ActionType == RogueEssence.Dungeon.BattleActionType.Throw then
--           data["hits"] = data["hits"] + 1
--         end
--       end)
      
--       local on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         if data["hits"] >= self.amount then
--           beholder.stopObserving(on_hits_id)
--           beholder.stopObserving(on_turn_ends_id)
--           data["hits"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)
--     end,
    
--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)
--       local hits = data["hits"] or 0
--       return { 
--         "", 
--         "Progress: " .. math.min(hits, self.amount) .. "/" .. tostring(self.amount) 
--       }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateProjectileQuest({
--   id = "HIT_ENEMY_WITH_PROJECTILE",
--   amount = 3,
--   reward = 250
-- }))

-- QuestRegistry:Register(CreateProjectileQuest({
--   id = "HIT_ENEMY_WITH_PROJECTILE_5",
--   amount = 5,
--   reward = 600
-- }))

-- QuestRegistry:Register(CreateProjectileQuest({
--   id = "HIT_ENEMY_WITH_PROJECTILE_10",
--   amount = 10,
--   reward = 1250
-- }))

-- local function CreateTimedDefeatQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     turns = config.turns,
--     reward = config.reward,
    
--     getDescription = config.getDescription or function(self)
--       local enemy_text = self.amount == 1 and "enemy" or "enemies"
--       local turn_text = self.turns == 1 and "turn" or "turns"
--       return string.format(
--         "Defeat %s %s in %s %s", 
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--         enemy_text,
--         M_HELPERS.MakeColoredText(tostring(self.turns), PMDColor.Cyan),
--         turn_text
--       )
--     end,
    
--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
--       data["defeated_enemies"] = 0
--       data["turns_elapsed"] = 0
--       data["timer_started"] = false
      
--       local on_death_id
--       local on_map_turn_ends_id
--       local on_turn_ends_id
      
--       on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
--         local team = context.User.MemberTeam
--         if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and context.User.MemberTeam ~= _DUNGEON.ActiveTeam) then
--           data["defeated_enemies"] = data["defeated_enemies"] + 1
          
--           if not data["timer_started"] then
--             data["timer_started"] = true
--             data["turns_elapsed"] = 0
--           end
          
--           print("Defeated enemies: " .. tostring(data["defeated_enemies"]) .. " / " .. tostring(self.amount))
--         end
--       end)
      
--       on_map_turn_ends_id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
--         if data["timer_started"] then
--           data["turns_elapsed"] = data["turns_elapsed"] + 1
--           print("Turns elapsed: " .. tostring(data["turns_elapsed"]) .. " / " .. tostring(self.turns))
          
--           if data["turns_elapsed"] >= self.turns then
--             data["defeated_enemies"] = 0
--             data["turns_elapsed"] = 0
--             data["timer_started"] = false
--           end
--         end
--       end)
      
--       on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         if data["defeated_enemies"] >= self.amount then
--           beholder.stopObserving(on_death_id)
--           beholder.stopObserving(on_map_turn_ends_id)
--           beholder.stopObserving(on_turn_ends_id)
--           data["defeated_enemies"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)
      
--       print("Registered observers for " .. self.id)
--     end,
    
--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)
--       local defeated_enemies = data["defeated_enemies"] or 0
--       local turns_elapsed = data["turns_elapsed"] or 0
--       return { 
--         "",
--         "Turns: " .. turns_elapsed .. "/" .. tostring(self.turns),
--         "Enemies: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount)
--       }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateTimedDefeatQuest({
--   id = "DEFEAT_ENEMIES_TIMED_1",
--   amount = 3,
--   turns = 10,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateTimedDefeatQuest({
--   id = "DEFEAT_ENEMIES_TIMED_2",
--   amount = 5,
--   turns = 20,
--   reward = 1000
-- }))

-- QuestRegistry:Register(CreateTimedDefeatQuest({
--   id = "DEFEAT_ENEMIES_TIMED_3",
--   amount = 7,
--   turns = 35,
--   reward = 1500
-- }))

-- local function CreateEffectivenessQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     reward = config.reward,
    
--     getDescription = config.getDescription or function(self)
--       local action = config.is_dealing and "Deal" or "Take"
--       local effectiveness = config.super_effective and "super effective" or "not super effective"
--       local plural = self.amount == 1 and "time" or "times"
--       return string.format(
--         "%s a %s hit %s %s",
--         action,
--         effectiveness,
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--         plural
--       )
--     end,

--     set_active_effects = function(self, active_effect, zone_context)
--       local redirection = luanet.ctype(RedirectionType)
--       local data = QuestRegistry:GetData(self)
--       data["hits"] = 0

--       local on_turn_end_id
--       local on_hit_id
--       on_hit_id = beholder.observe("OnHits", function(owner, ownerChar, context, args)
--         -- Check if we're tracking the user (dealing) or target (taking)
--         local check_team = config.is_dealing and context.User.MemberTeam or context.Target.MemberTeam
--         if check_team == nil or check_team ~= _DUNGEON.ActiveTeam then
--           return
--         end

--         if context.ContextStates:Contains(redirection) then
--           return
--         end
        
--         if context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or
--            context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
--           return
--         end

--         if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and 
--            context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
--           return
--         end

--         local matchup = PMDC.Dungeon.PreTypeEvent.GetDualEffectiveness(context.User, context.Target, context.Data)
--         matchup = matchup - PMDC.Dungeon.PreTypeEvent.NRM_2
        
--         -- Invert matchup for "not super effective" quests
--         if not config.super_effective then
--           matchup = matchup * -1
--         end

--         if matchup > 0 then
--           data["hits"] = data["hits"] + 1
--         end
--       end)

--       on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         print("Hits recorded: " .. tostring(data["hits"]) .. " / " .. tostring(self.amount))
--         if data["hits"] >= self.amount then
--           beholder.stopObserving(on_hit_id)
--           beholder.stopObserving(on_turn_end_id)
--           data["hits"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)
--     end,

--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)
--       local hits = data["hits"] or 0
--       return {
--         "",
--         "Progress: " .. math.min(hits, self.amount) .. "/" .. tostring(self.amount) 
--       }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateEffectivenessQuest({
--   id = "TAKE_SUPER_EFFECTIVE",
--   amount = 1,
--   reward = 200,
--   is_dealing = false,
--   super_effective = true
-- }))

-- QuestRegistry:Register(CreateEffectivenessQuest({
--   id = "TAKE_NOT_SUPER_EFFECTIVE",
--   amount = 1,
--   reward = 200,
--   is_dealing = false,
--   super_effective = false
-- }))

-- QuestRegistry:Register(CreateEffectivenessQuest({
--   id = "DEAL_SUPER_EFFECTIVE",
--   amount = 1,
--   reward = 200,
--   is_dealing = true,
--   super_effective = true
-- }))

-- QuestRegistry:Register(CreateEffectivenessQuest({
--   id = "DEAL_NOT_SUPER_EFFECTIVE",
--   amount = 1,
--   reward = 200,
--   is_dealing = true,
--   super_effective = false
-- }))

-- QuestRegistry:Register({
--   id = "FAINT",
--   amount = 1,
--   reward = 1000,
--   getDescription = function(self)
--     return string.format("Have any member faint %s time", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["fainted"] = 0

--     local id
--     id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
--       local team = context.User.MemberTeam
--       if (team ~= nil and context.User.MemberTeam == _DUNGEON.ActiveTeam) then
--         data["fainted"] = data["fainted"] + 1
--         print("Fainted: " .. tostring(data["fainted"]) .. " / " .. tostring(self.amount))
--         if data["fainted"] >= self.amount then
--           beholder.stopObserving(id)
--           data["fainted"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local fainted = data["fainted"]
--     return { "", "Progress: " .. math.min(fainted, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- })



-- QuestRegistry:Register({
--   id = "SUPER_FULL",
--   amount = 1,
--   threshold = 100,
--   reward = 500,

--   get_max_fullness = function(self)

--     local max_fullness = 0
--     for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
--       if member.Fullness > max_fullness then
--         max_fullness = member.Fullness
--       end
--     end
    
--     print("Max fullness is " .. tostring(max_fullness))
--     return max_fullness
--   end,
--   getDescription = function(self)
--     return string.format("Have %s member be above %s hunger", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan))
--   end,
  

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["best_fullness"] = 0

--     local id
--     id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--       print("Checking fullness for quest " .. self.id)

--       local max_fullness = self:get_max_fullness()
--       data["best_fullness"] = math.max(data["best_fullness"], max_fullness)
--       if max_fullness > self.threshold then
--         beholder.stopObserving(id)
  
--         GAME:WaitFrames(30)
--         self:complete_quest()
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)  
--     local best_fullness = data["best_fullness"]
--     return { "", "Max Fullness: " .. best_fullness }
--   end
-- })

-- local function CreateEmptyStomachQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     threshold = config.threshold,
--     reward = config.reward,
    
--     can_apply = function()
--       return _DATA.Save.ActiveTeam.Players.Count == config.amount
--     end,
    
--     get_min_fullness = function(self)
--       local min_fullness = math.huge
--       for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
--         if member.Fullness < min_fullness then
--           min_fullness = member.Fullness
--         end
--       end
--       print("Min fullness is " .. tostring(min_fullness))
--       return min_fullness
--     end,
    
--     getDescription = function(self)
--       local member_text = self.amount == 1 and "member" or "members"
--       return string.format(
--         "Have all %s %s be below %s hunger", 
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--         member_text,
--         M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan)
--       )
--     end,
    
--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
      
--       local on_map_start_id
--       local on_turn_end_id
      
--       on_map_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
--         data["min_fullness"] = math.huge
--       end)
      
--       on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         print("Checking fullness for quest " .. self.id)
--         local min_fullness = self:get_min_fullness()
--         data["min_fullness"] = math.min(data["min_fullness"], min_fullness)
        
--         if min_fullness < self.threshold then
--           beholder.stopObserving(on_map_start_id)
--           beholder.stopObserving(on_turn_end_id)
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)
--     end,
    
--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)  
--       local min_fullness = data["min_fullness"]
--       if min_fullness == math.huge then
--         min_fullness = 100
--       end
--       local status = min_fullness < self.threshold and "Completed" or "Not Completed"
--       return {
--         "",
--         status
--       }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateEmptyStomachQuest({
--   id = "EMPTY_STOMACH_1",
--   amount = 1,
--   threshold = 5,
--   reward = 300
-- }))

-- QuestRegistry:Register(CreateEmptyStomachQuest({
--   id = "EMPTY_STOMACH_2",
--   amount = 2,
--   threshold = 20,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateEmptyStomachQuest({
--   id = "EMPTY_STOMACH_3",
--   amount = 3,
--   threshold = 35,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateEmptyStomachQuest({
--   id = "EMPTY_STOMACH_4",
--   amount = 4,
--   threshold = 50,
--   reward = 500
-- }))


-- local function CreateLowHealthQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     health_percent = config.health_percent,
--     reward = config.reward,
    
--     can_apply = function()
--       return _DATA.Save.ActiveTeam.Players.Count == config.amount
--     end,
    
--     check_all_low_health = function(self)
--       local threshold = self.health_percent / 100
--       for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
--         local health_ratio = member.HP / member.MaxHP
--         if health_ratio > threshold then
--           return false
--         end
--       end
--       return true
--     end,
    
--     getDescription = function(self)
--       local member_text = self.amount == 1 and "member" or "members"
--       return string.format(
--         "Have all %s %s be at or below %s%% HP", 
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--         member_text,
--         M_HELPERS.MakeColoredText(tostring(self.health_percent), PMDColor.Cyan)
--       )
--     end,
    
--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
      
--       local on_map_start_id
--       local on_turn_end_id
      
    
--       on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         print("Checking HP for quest " .. self.id)
        
--         if self:check_all_low_health() then
--           beholder.stopObserving(on_map_start_id)
--           beholder.stopObserving(on_turn_end_id)
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)
--     end,
    
--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)  
--       local status = data["completed"] and "Completed" or "Not Completed"
--       return { 
--         "", 
--         status
--       }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateLowHealthQuest({
--   id = "LOW_HEALTH_1",
--   amount = 1,
--   health_percent = 5,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateLowHealthQuest({
--   id = "LOW_HEALTH_2",
--   amount = 2,
--   health_percent = 20,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateLowHealthQuest({
--   id = "LOW_HEALTH_3",
--   amount = 3,
--   health_percent = 35,
--   reward = 500
-- }))

-- QuestRegistry:Register(CreateLowHealthQuest({
--   id = "LOW_HEALTH_4",
--   amount = 4,
--   health_percent = 50,
--   reward = 500
-- }))

-- QuestRegistry:Register({
--   id = "STAY_ON_FLOOR",
--   amount = 1000,
--   reward = 500,
--   getDescription = function(self)
--     return string.format(
--       "Stay on floor for %s turns",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan)
--     )
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["turns"] = 0

--     local id
--     id = beholder.observe("OnMapTurnEnds",
--       function(owner, ownerChar, context, args)

--         data["turns"] = data["turns"] + 1
--         print("Turns on floor: " .. tostring(data["turns"]) .. " / " .. tostring(self.amount))
--         if data["turns"] >= self.amount then
--           beholder.stopObserving(id)
--           data["turns"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end
--     )
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local turns = data["turns"]
--     return {
--       "",
--       "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount)
--     }
--   end
-- })

-- QuestRegistry:Register({
--   id = "STAY_ON_FLOOR",
--   amount = 1000,
--   reward = 500,
--   getDescription = function(self)
--     return string.format("Stay on floor for %s turns",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)
--     data["turns"] = 0

--     local id
--     id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
--       data["turns"] = data["turns"] + 1
--       if data["turns"] >= self.amount then
--         beholder.stopObserving(id)
--         data["turns"] = self.amount
--         GAME:WaitFrames(30)
--         self:complete_quest()
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local turns = data["turns"]
--     return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- })

-- local function CreateAvoidActionQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     reward = config.reward,

--     getDescription = config.getDescription or function(self)
--       return string.format(config.description_template,
--         M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--     end,

--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
--       local no_action_used = true
--       data["turns"] = 0

--       local on_map_turn_end_id
--       local on_before_actions_id

--       on_map_turn_end_id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
--         if no_action_used then
--           data["turns"] = data["turns"] + 1
--         else
--           data["turns"] = 0
--         end

--         if data["turns"] >= self.amount then
--           beholder.stopObserving(on_map_turn_end_id)
--           beholder.stopObserving(on_before_actions_id)
--           data["turns"] = self.amount
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end

--         no_action_used = true
--       end)

--       on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
--         -- Use custom check function if provided, otherwise check forbidden actions
--         if config.check_forbidden then
--           if config.check_forbidden(context) then
--             no_action_used = false
--           end
--         else
--           for _, forbidden_type in ipairs(config.forbidden_actions) do
--             if context.ActionType == forbidden_type then
--               no_action_used = false
--               break
--             end
--           end
--         end
--       end)
--     end,

--     getProgressTexts = function(self)
--       local data = QuestRegistry:GetData(self)
--       local turns = data["turns"]
--       return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateAvoidActionQuest({
--   id = "DO_NOT_USE_ITEMS",
--   amount = 300,
--   reward = 500,
--   description_template = "Do not use or throw items for %s turns",
--   forbidden_actions = { RogueEssence.Dungeon.BattleActionType.Item, RogueEssence.Dungeon.BattleActionType.Throw }
-- }))

-- QuestRegistry:Register(CreateAvoidActionQuest({
--   id = "DO_NOT_USE_SKILLS",
--   amount = 200,
--   reward = 500,
--   description_template = "Do not use any skills for %s turns",
--   check_forbidden = function(context)
--     return context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill and context.UsageSlot ~=
--         RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
--   end
-- }))

-- QuestRegistry:Register({
--   id = "RECRUIT",
--   amount = 1,
--   reward = 500,

--   capped_floor = 20,

--   can_apply = function(self)
--     if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
--       if SV.EmberFrost.LastFloor <= self.capped_floor then
--         return false
--       end


--       local possible_recruits = GetFloorSpawns({
--         not_has_features = { UnrecruitableType }
--       })
--       return #possible_recruits > 0
--     end
--     return true
--   end,
--   getDescription = function(self)
--     return string.format("Recruit a new team member")
--   end,

--   get_total_team_members = function(self)
--     return _DUNGEON.ActiveTeam.Players.Count + _DUNGEON.ActiveTeam.Assembly.Count
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local data = QuestRegistry:GetData(self)

--     local on_start_id
--     local on_turn_end_id

--     on_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
--       data["starting_team_members"] = self:get_total_team_members()
--     end)

--     on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--       local new_count = self:get_total_team_members()
--       if new_count - data["starting_team_members"] >= self.amount then
--         beholder.stopObserving(on_start_id)
--         beholder.stopObserving(on_turn_end_id)
--         self:complete_quest()
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local total_team_members = self:get_total_team_members()
--     local data = QuestRegistry:GetData(self)
--     return { "", "Progress: " .. math.min(total_team_members - data["starting_team_members"], self.amount) .. "/" ..
--     tostring(self.amount) }
--   end
-- })

-- QuestRegistry:Register({
--   id = "LEVEL_UP",
--   amount = 1,
--   reward = 300,
--   getDescription = function(self)
--     return string.format("Level up %s time", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--   end,

--   get_total_level_from_start = function(self)
--     local total_level = 0
--     for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
--       local tbl = LTBL(member)
--       total_level = total_level + (member.Level - tbl["StartLevel"])
--     end
--     for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
--       local tbl = LTBL(member)
--       total_level = total_level + (member.Level - tbl["StartLevel"])
--     end
--     return total_level
--   end,

--   cleanup = function(self)
--     for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
--       local tbl = LTBL(member)
--       tbl["StartLevel"] = nil
--     end
--     for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
--       local tbl = LTBL(member)
--       tbl["StartLevel"] = nil
--     end
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     local on_start_id
--     local on_turn_end_id

--     on_start_id = beholder.observe("OnMapStart", function(owner, ownerChar, context, args)
--       print("LEVEL UP CHECK START")
--       for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
--         local tbl = LTBL(member)
--         tbl["StartLevel"] = member.Level
--       end
--       for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
--         local tbl = LTBL(member)
--         tbl["StartLevel"] = member.Level
--       end
--     end)

--     on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--       local leveled_up = self:get_total_level_from_start()
--       if leveled_up >= self.amount then
--         beholder.stopObserving(on_start_id)
--         beholder.stopObserving(on_turn_end_id)
--         self:complete_quest()
--       end
--     end)
--   end,

--   getProgressTexts = function(self)
--     local leveled_up = self:get_total_level_from_start()
--     return { "Progress: " .. math.min(leveled_up, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- })

-- local function CreateItemUseQuest(config)
--   return {
--     id = config.id,
--     amount = config.amount,
--     reward = config.reward,

--     getDescription = config.getDescription or function(self)
--       local action_verb = config.action_verb or "Use"
--       local item_type = self.amount == 1 and config.item_type_singular or config.item_type_plural
--       return string.format(
--         action_verb .. " " .. M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " " ..
--         item_type, M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
--     end,

--     set_active_effects = function(self, active_effect, zone_context)
--       local data = QuestRegistry:GetData(self)
--       data["count"] = 0

--       local on_before_actions_id
--       local on_turn_end_id

--       on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
--         if data["count"] >= self.amount then
--           beholder.stopObserving(on_before_actions_id)
--           beholder.stopObserving(on_turn_end_id)
--           GAME:WaitFrames(30)
--           self:complete_quest()
--         end
--       end)

--       on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
--         if context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
--           local item = get_item_from_context(context)
--           local contains = item_id_contains_state(item, config.state_type)
--           if contains then
--             data["count"] = data["count"] + 1
--           end
--         end
--       end)
--     end,

--     getProgressTexts = config.getProgressTexts or function(self)
--       local data = QuestRegistry:GetData(self)
--       local count = data["count"] or 0
--       return { "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
--     end
--   }
-- end

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_ORB",
--   amount = 1,
--   reward = 100,
--   action_verb = "Use",
--   item_type_singular = "orb",
--   item_type_plural = "orbs",
--   state_type = OrbStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_WAND",
--   amount = 5,
--   reward = 200,
--   action_verb = "Use",
--   item_type_singular = "wand",
--   item_type_plural = "wands",
--   state_type = WandStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_ORB_2",
--   amount = 2,
--   reward = 250,
--   action_verb = "Use",
--   item_type_singular = "orb",
--   item_type_plural = "orbs",
--   state_type = OrbStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_SEED",
--   amount = 2,
--   reward = 100,
--   action_verb = "Eat",
--   item_type_singular = "seed",
--   item_type_plural = "seeds",
--   state_type = SeedStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_GUMMI",
--   amount = 1,
--   reward = 200,
--   action_verb = "Eat",
--   item_type_singular = "gummi",
--   item_type_plural = "gummis",
--   state_type = GummiStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_ITEMS",
--   amount = 4,
--   reward = 250,
--   action_verb = "Eat",
--   item_type_singular = "item",
--   item_type_plural = "edible items",
--   state_type = EdibleStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "EAT_FOOD_ITEMS",
--   amount = 2,
--   reward = 250,
--   action_verb = "Eat",
--   item_type_singular = "food item",
--   item_type_plural = "food items",
--   state_type = FoodStateType
-- }))

-- QuestRegistry:Register(CreateItemUseQuest({
--   id = "USE_MACHINE_ITEMS",
--   amount = 1,
--   reward = 300,
--   action_verb = "Use",
--   item_type_singular = "machine item",
--   item_type_plural = "machine items",
--   state_type = MachineStateType,
--   getDescription = function(self)
--     local recall_box = M_HELPERS.GetItemName("machine_recall_box")
--     local assembly_box = M_HELPERS.GetItemName("machine_assembly_box")
--     local ability_capsule = M_HELPERS.GetItemName("machine_ability_capsule")

--     return string.format("Use %s machine or capsule items",
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box, assembly_box, ability_capsule)
--   end,

--   getProgressTexts = function(self)
--     local data = QuestRegistry:GetData(self)
--     local count = data["count"] or 0
--     return { "", "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
--   end
-- }))