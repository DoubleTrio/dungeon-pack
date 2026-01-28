require 'trios_dungeon_pack.helpers'

StackType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
TotalDamageDealtType = luanet.import_type('PMDC.Dungeon.TotalDamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')

TaintedDrainType = luanet.import_type('PMDC.Dungeon.TaintedDrain')
beholder = require 'trios_dungeon_pack.beholder'

-- pachirisu, dragonair, quilava, oshawott, zangoose, zigzagoon, ribombee
-- 
-- B3F Oshawott: Wow! Wishmaker Cave is so beautiful! Sometimes, I feel something stirring within me as I look at the crystals. 
-- B6F Zigzagoon: I could have sworn I saw something shiny on the ground earlier. I wish I could remember where I last saw it...
-- B10F Zangoose: Heh. These crystals can't hide from old Zangoose. Hidden from the plain eye, but I always check. 
-- B11F Ribombee: Ughh, those Tentacools are nasty, very nasty. I feel absolutely drained from them!
-- B12F Quilava: Huh, I noticed some Pokémon here actively seek crystals to become more powerful. I think it's best to use their power immediately the moment you find them.
-- B17F Dragonair: Rumors has it, something rests within the depths of this cave. ...Waiting to be awaken by worthy explorers who held on to some of their hopes and wishes until the end. 
-- B19F Staryu: [emote=happy]Like a star.[pause=10].[pause=10].[pause=10]  Until the end.[pause=10].[pause=10].[pause=10]
-- B19F Staryu: {0} more.[pause=10] Like a star.
-- One last wish for Wishmaker powered by how many Wish Gems you have. Jirachi for 5. 0 use the original Wish Gem


local function CountInvItemID(item_id)
  local bag_count = GAME:GetPlayerBagCount()
  local count = 0
  
	for i = 0, bag_count - 1, 1 do
		local item = GAME:GetPlayerBagItem(i)
		local amount = item.Amount
		if item.Amount == 0 then
			amount = 1
		end

		if item.ID == item_id then count = count + amount end
	end

  return count
end

function BATTLE_SCRIPT.WishmakerTipDialogue(owner, ownerChar, context, args)
  -- if _DATA.CurrentReplay == nil then
  UI:SetSpeaker(context.Target)

  context.Target.CharDir = context.User.CharDir:Reverse()
  
  local old_dir = context.Target.CharDir

  local wish_desires = {
    {
      Category = "Money",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Poké,[pause=10] Pearls,[pause=10] Nuggets."
    },
    {
      Category = "Food",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Apples,[pause=10] Bananas,[pause=10] Berries."
    },
    {
      Category = "Utility",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Seeds,[pause=10] Orbs,[pause=10] Berries,[pause=10] Stat Boosters,[pause=10] Throwables,[pause=10] Machinaries."
    },
    {
      Category = "Power",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Joy Seeds,[pause=10] Gummis,[pause=10] Vitamins,[pause=10] TMs."
    },
    {
      Category = "Equipment",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Any equipment that can be held."
    },
    {
      Category = "Evolution",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Any evolution for any Pokémon in here."
    },
    {
      Category = "Recruitment",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Apricorns,[pause=10] Amber Tears,[pause=10] Assembly Boxes."
    },
  }

  local crystal_types = {
    {
      Crystal = "Attack Crystal",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Boosts attack by a stage for 5 attacks.[pause=0] Can be stacked to 3."
    },
    {
      Crystal = "Defense Crystal",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Boosts defense by a stage for 5 attacks.[pause=0] Can be stacked to 3."
    },
    {
      Crystal = "Drain Crystal",
      Info = "[pause=10].[pause=10].[pause=10].[pause=10]Steals Pokémon health for 5 attacks.[pause=0] Can be stacked to 3."
    },
  }

  local tips = { 
    {
      TipName = "Crystal Wishes",
      Tip = "[pause=10].[pause=10].[pause=10].[pause=10]Which wish?[pause=10]",
    },
    {
      TipName = "Crystal Boosts",
      Tip = "[pause=10].[pause=10].[pause=10].[pause=10]Which crystal?[pause=10]",
    },
    {
      TipName = "Wishmaker Depths",
      Tip = "Wishmaker slumbers there.[pause=0] You need lots of gems.[br]Place them like a star \u{E10C}.[pause=0] Wish with your heart's desire.",
    },
    {
      TipName = "Wish Gems",
      Tip = "Hidden everywhere.[pause=0] Less common here.[pause=0] More common near the depths.[pause=0] Keep eye on shiny ground.",
    },
    -- "Wish Crystal", "Wishmaker", "Tips", "Don't know"
   }
   
  --  local tips = { "Want big score?[pause=30]"}


  -- table.insert(wish_choices, "Don't know")


  -- local wish_choices = M_HELPERS.map(DUNGEON_WISH_TABLE, function(item) return item.Category end)
  -- table.insert(wish_choices, "Don't know")


  local tip_choices = M_HELPERS.map(tips, function(item) return item.TipName end)
  table.insert(tip_choices, "Don't know")
  
  local end_choice = #tip_choices
  UI:BeginChoiceMenu("[pause=10].[pause=10].[pause=10].[pause=10]I have knowledge.[pause=30] I give knowledge.[pause=30]\nWhat do you want to know?[pause=20]", tip_choices, 1, end_choice)
  UI:WaitForChoice()
  local tip_choice = UI:ChoiceResult()
  if tip_choice ~= end_choice then
    -- TODO REWRITE THIS
    local tip = tips[tip_choice].Tip

    if tip_choice == 1 then
      local wish_choices = M_HELPERS.map(wish_desires, function(item) return item.Category end)
      table.insert(wish_choices, "All good")
      local end_wish_choice = #wish_choices
      




      local wish_choice = -1
      while wish_choice ~= end_wish_choice do

        local shown_tip = "...[pause=10]Which wish?"
        if wish_choice == -1 then
          shown_tip = tip
        end
        UI:BeginChoiceMenu(shown_tip, wish_choices, 1, end_wish_choice)
        UI:WaitForChoice()
        wish_choice = UI:ChoiceResult()
        if wish_choice ~= end_wish_choice then
          local wish_info = wish_desires[wish_choice].Info
          UI:WaitShowDialogue(wish_info)
        end
      end

      UI:WaitShowDialogue(".[pause=10].[pause=10].[pause=10][emote=happy]Best wishes.")
    elseif tip_choice == 2 then
      local crystal_choices =  M_HELPERS.map(crystal_types, function(item) return item.Crystal end)
      table.insert(crystal_choices, "All good")
      local end_crystal_choice = #crystal_choices
      




      local crystal_choice = -1
      while crystal_choice ~= end_crystal_choice do

        local shown_tip = "...Which crystal?"
        if crystal_choice == -1 then
          shown_tip = tip
        end
        UI:BeginChoiceMenu(shown_tip, crystal_choices, 1, end_crystal_choice)
        UI:WaitForChoice()
        crystal_choice = UI:ChoiceResult()
        if crystal_choice ~= end_crystal_choice then
          local crystal_info = crystal_types[crystal_choice].Info
          UI:WaitShowDialogue(crystal_info)
        end
      end
      UI:WaitShowDialogue(".[pause=10].[pause=10].[pause=10][emote=happy]Best wishes.")
    else
      UI:WaitShowDialogue(tip)
    end
  else
    UI:WaitShowDialogue(".[pause=10].[pause=10].[pause=10][emote=happy]Then,[pause=10] best wishes.")
  end

  -- local target = context.Target
  -- UI:WaitShowDialogue()
  -- if wish_gem_count > 5 then
  --   UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("WISHMAKER_NPC_TALK7.2"):ToLocal()))
  -- elseif wish_gem_count == 5 then
  --   UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("WISHMAKER_NPC_TALK7.1"):ToLocal(), wish_gem_count))
  -- else
  --   UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("WISHMAKER_NPC_TALK7.0"):ToLocal(), 5 - wish_gem_count))
  -- end

  context.Target.CharDir = old_dir

  context.CancelState.Cancel = true
    
  -- end
end

function BATTLE_SCRIPT.WishmakerGemCountDialogue(owner, ownerChar, context, args)
  -- if _DATA.CurrentReplay == nil then
  UI:SetSpeaker(context.Target)

  local wish_gem_count = CountInvItemID("wish_gem")

  context.Target.CharDir = context.User.CharDir:Reverse()
  
  local old_dir = context.Target.CharDir
  -- local target = context.Target
  -- UI:WaitShowDialogue()
  if wish_gem_count >= 5 then
    UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("WISHMAKER_NPC_TALK7.1"):ToLocal(), wish_gem_count))
  else
    UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("WISHMAKER_NPC_TALK7.0"):ToLocal(), 5 - wish_gem_count))
  end

  context.Target.CharDir = old_dir

  context.CancelState.Cancel = true
    
  -- end
end

-- if (DataManager.Instance.CurrentReplay == null)
-- {
--     if (HideSpeaker)
--         yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetDialogue(Message.ToLocal()));
--     else
--     {
--         Dir8 oldDir = context.Target.CharDir;
--         context.Target.CharDir = context.User.CharDir.Reverse();
--         Character target = context.Target;
--         yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetDialogue(target.Appearance, target.GetDisplayName(true), Emote, true, Message.ToLocal()));
--         context.Target.CharDir = oldDir;
--     }
--     context.CancelState.Cancel = true;
-- }
function BATTLE_SCRIPT.CrystalDefenseCountdownRemove(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.Target:GetStatusEffect(status)
  local dmg = context:GetContextStateInt(luanet.ctype(DamageDealtType), 0)
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) and dmg > 0 then
      s.Counter = s.Counter - 1
    end
    if s.Counter <= 0 then
      TASK:WaitTask(context.Target:RemoveStatusEffect(status, true))
    end
  end
end


function BATTLE_SCRIPT.TargetStatusRequired(owner, ownerChar, context, args)
  local status = args.StatusID
  local target = context.Target
  local message_key = args.MessageKey
  local stack = target:GetStatusEffect(status)
  if stack == nil then
    if message_key ~= nil then
      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey(message_key):ToLocal(), context.Target:GetDisplayName(false)))
    end

    context.CancelState.Cancel = true
  end
end

function BATTLE_SCRIPT.MonoMoves(owner, ownerChar, context, args)


  -- local skill_data = _DATA:GetSkill(move_idx)
	-- for _, element_id in ipairs(args.Elements) do
	--   --check to see if the skill is of the correct element
	--   if skill_data.Data.Element == element_id then
	--     has_element = true
	-- 	break
	--   end
	-- end

  local chara = context.User

  local main_element = nil
  local all_same = true

  for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
    local skill = chara.BaseSkills[ii].SkillNum
    if skill ~= nil and skill ~= "" then
      local skill_data = _DATA:GetSkill(skill)
      local element = skill_data.Data.Element

      if main_element == nil then
        main_element = element
      else
        if element ~= main_element then
          all_same = false
        end
      end
    end
  end
  if (
    context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill and
    context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT and
    (context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical or context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Magical)
  ) then
    if all_same then

      -- LogMsg(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MONO_MOVES_ACTIVATED"):ToLocal(), chara:GetDisplayName(false)))

      
      -- public ItemAnimData(string animIndex, int frameTime, int startFrame, int endFrame)
              -- public AnimData(string animIndex, int frameTime, int startFrame, int endFrame)
      local anim_data = RogueEssence.Content.AnimData("Stat_Blue_Line", 5, -1, -1, 255, Dir8.Up)

      -- AnimData(string animIndex, int frameTime, int startFrame, int endFrame, byte alpha, Dir8 dir)
              -- public ParticleAnim(AnimData anim, int cycles, int totalTime)
      local particle_anim = RogueEssence.Content.ParticleAnim(anim_data, 1, 0)
      local emitter = RogueEssence.Content.SqueezedAreaEmitter(particle_anim)
      emitter.Bursts = 2
      emitter.ParticlesPerBurst = 3
      emitter.BurstTime = 6
      emitter.HeightSpeed = 16
      emitter.Range = 24


      -- print(tostring(emitter) .. " emitter")

      	-- SOUND:PlayBattleSE("DUN_Tri_Attack_2")
              	-- SOUND:PlayBattleSE("_UNK_EVT_085")
                GAME:WaitFrames(10)
                -- SOUND:PlayBattleSE("_UNK_EVT_043")
      DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)



      -- _DUNGEON:LogMsg(string.format("%s's Mono Moves Activated!", context.User:GetDisplayName(false)))
      -- _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_LIQUID_OOZE"):ToLocal(), context.User:GetDisplayName(false)))
      
      print(tostring(anim_data))
      local attack_boost = PMDC.Dungeon.MultiplyDamageEvent(100 + 35, 100)
      TASK:WaitTask(attack_boost:Apply(owner, ownerChar, context))
      -- local emitter = RogueEssence.Content.SqueezedAreaEmitter()
      -- emitterx


	-- GAME:WaitFrames(30)
            --       Bursts = other.Bursts;
            -- ParticlesPerBurst = other.ParticlesPerBurst;
            -- BurstTime = other.BurstTime;
            -- Range = other.Range;
            -- HeightSpeed = other.HeightSpeed;
            -- SpeedDiff = other.SpeedDiff;
            -- StartHeight = other.StartHeight;
            -- HeightDiff = other.HeightDiff;
            -- Layer = other.Layer;
      -- print(tostring(particle_anim))
      -- print(tostring(anim_data))
    end
  end


              -- if (effect)
                -- yield return CoroutineManager.Instance.StartCoroutine(DungeonScene.Instance.ProcessBattleFX(this, this, DataManager.Instance.LoseChargeFX));

end



function BATTLE_SCRIPT.Ravenous(owner, ownerChar, context, args)
  -- print("Ravenous called")
  local chara = context.User

  local add_boost = 0

  if chara.Fullness <= 0 then
    add_boost = 100
  elseif chara.Fullness <= 3 then
    add_boost = 50
  elseif chara.Fullness <= 10 then
    add_boost = 25
  elseif chara.Fullness <= 20 then
    add_boost = 10
  end
  if add_boost > 0 and (context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical or context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Magical) then
    local attack_boost = PMDC.Dungeon.MultiplyDamageEvent(100 + add_boost, 100)
    local anim_data = RogueEssence.Content.AnimData("Stat_Green_Line", 5, -1, -1, 255, Dir8.Up)
    local particle_anim = RogueEssence.Content.ParticleAnim(anim_data, 1, 0)
    local emitter = RogueEssence.Content.SqueezedAreaEmitter(particle_anim)
    emitter.Bursts = 2
    emitter.ParticlesPerBurst = 3
    emitter.BurstTime = 6
    emitter.HeightSpeed = 16
    emitter.Range = 24
    GAME:WaitFrames(10)
    DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
    TASK:WaitTask(attack_boost:Apply(owner, ownerChar, context))
  end
end



function BATTLE_SCRIPT.Avenger(owner, ownerChar, context, args)
  local chara = context.User

  local count = 0

  for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
		if member.Dead then
      count = count + 1
    end
	end

  local add_boost = 0

  if count >= 3 then
    add_boost = 35
  elseif count >= 2 then
    add_boost = 20
  elseif count >= 1 then
    add_boost = 10
  end

  print("Avenger dead count: " .. tostring(count) .. " add_boost: " .. tostring(add_boost)  )
  if add_boost > 0 and (context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical or context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Magical) then
    local attack_boost = PMDC.Dungeon.MultiplyDamageEvent(100 + add_boost, 100)
    local anim_data = RogueEssence.Content.AnimData("Stat_White_Line", 5, -1, -1, 255, Dir8.Up)
    local particle_anim = RogueEssence.Content.ParticleAnim(anim_data, 1, 0)
    local emitter = RogueEssence.Content.SqueezedAreaEmitter(particle_anim)
    emitter.Bursts = 2
    emitter.ParticlesPerBurst = 3
    emitter.BurstTime = 6
    emitter.HeightSpeed = 16
    emitter.Range = 24
    GAME:WaitFrames(10)
    DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
    TASK:WaitTask(attack_boost:Apply(owner, ownerChar, context))
  end
end

function BATTLE_SCRIPT.RavenousAfterHit(owner, ownerChar, context, args)

  local confusion_chance = 0
  local chara = context.User
  if chara.Fullness <= 0 then
    confusion_chance = 33
    -- add_boost = 100
  elseif chara.Fullness <= 3 then
    confusion_chance = 20
    -- add_boost = 50
  elseif chara.Fullness <= 10 then
    confusion_chance = 15
  end

  local contains = chara.StatusEffects:ContainsKey("confuse")

  if confusion_chance > 0 and (context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical or context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Magical) and not contains then
    -- local roll = RogueEssence.Dungeon.BattleContext.Rand:Next(100)
    local roll = _DATA.Save.Rand:Next(100)
  _DUNGEON:LogMsg(string.format("%s ravenousness took over!", chara:GetDisplayName(false)))
    -- print("Ravenous confusion roll: " .. tostring(roll) .. " vs " .. tostring(confusion_chance))
    if roll < confusion_chance then
      SOUND:PlayBattleSE("DUN_Leech_Seed_2")
      local status = RogueEssence.Dungeon.StatusEffect("confuse")
      status:LoadFromData()
      TASK:WaitTask(context.User:AddStatusEffect(nil, status, true))
    end 
  end
end

-- function BATTLE_SCRIPT.EvioliteEvent(owner, ownerChar, context, args)
--   --NOTE: A 50% decrease in damage was a bit powerful... 
--   --This has been nerfed to 20%
--   local DEFAULT_NUM = 20
--   local DEFUALT_DENOM = 25

--   local phy_num = DEFAULT_NUM
--   local phy_denom = DEFUALT_DENOM

--   local spec_num = DEFAULT_NUM
--   local spec_denom = DEFUALT_DENOM

--   if type(args.PhyNum) == "number" then p_num = args.PhyNum end
--   if type(args.PhyDenom) == "number" then p_denom = args.PhyDenom end
--   if type(args.SpecNum) == "number" then spec_num = args.SpecNum end
--   if type(args.SpecDenom) == "number" then spec_denom = args.SpecDenom end
--   local apply_effect = GAME:CanPromote(context.Target)
--   if args.Reverse then apply_effect = (not apply_effect) end

--   if apply_effect then
--     local effects = {
--       PMDC.Dungeon.MultiplyCategoryEvent(RogueEssence.Data.BattleData.SkillCategory.Physical, phy_num, phy_denom),
--       PMDC.Dungeon.MultiplyCategoryEvent(RogueEssence.Data.BattleData.SkillCategory.Magical, spec_num, spec_denom)
--     }

--     for _, effect in pairs(effects) do
--       TASK:WaitTask(effect:Apply(owner, ownerChar, context))
--     end
--   end
-- end


function BATTLE_SCRIPT.WizardPowerBoost(owner, ownerChar, context, args)
  local boost_percent = args.BoostPercent

  local unique_wands = {}
  local total_unique = 0
  
  local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
  for i = inv_count, 0, -1 do
      local item = _DATA.Save.ActiveTeam:GetInv(i)
      local item_id = item.ID
      if Contains(WANDS, item_id) then
          if unique_wands[item_id] == nil then
              unique_wands[item_id] = true
              total_unique = total_unique + 1
          end
      end        
  end
  
  local player_count = _DUNGEON.ActiveTeam.Players.Count
  for player_idx = 0, player_count-1, 1 do
    local inv_item = GAME:GetPlayerEquippedItem(player_idx)
    local item_id = inv_item.ID
    if Contains(WANDS, item_id) then
        if unique_wands[item_id] == nil then
            unique_wands[item_id] = true
            total_unique = total_unique + 1
        end
    end        
  end

  local boost_amount = boost_percent * total_unique

  -- do add anims as last parameter
  local special_attack_boost = PMDC.Dungeon.MultiplyCategoryEvent(RogueEssence.Data.BattleData.SkillCategory.Magical, 100 + boost_amount, 100)
  TASK:WaitTask(special_attack_boost:Apply(owner, ownerChar, context))
end


-- function COMMON.ClearPlayerPrices()
--   local item_count = GAME:GetPlayerBagCount()
--   for item_idx = 0, item_count-1, 1 do
--     local inv_item = GAME:GetPlayerBagItem(item_idx)
-- 	inv_item.Price = 0
--   end
--   local player_count = _DUNGEON.ActiveTeam.Players.Count
--   for player_idx = 0, player_count-1, 1 do
--     local inv_item = GAME:GetPlayerEquippedItem(player_idx)
-- 	inv_item.Price = 0
--   end
  
--   COMMON.ClearMapTeamPrices(_ZONE.CurrentMap.AllyTeams)
--   COMMON.ClearMapTeamPrices(_ZONE.CurrentMap.MapTeams)
-- end


-- {
-- "Key": {
-- "str": [
-- 0
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.MultiplyCategoryEvent, PMDC",
-- "Category": 1,
-- "Numerator": 11,
-- "Denominator": 10,
-- "Anims": []
-- }
-- }

function BATTLE_SCRIPT.CrystalAttackCountdownRemove(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.User:GetStatusEffect(status)
  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) and dmg > 0 then
      s.Counter = s.Counter - 1
    end
    if s.Counter <= 0 then
      TASK:WaitTask(context.User:RemoveStatusEffect(status, true))
    end
  end
end

function BATTLE_SCRIPT.CustomHpDrainEvent(owner, ownerChar, context, args)
  local numer = args.Numerator
  local denom = args.Denominator
  local dmg_done = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)
  if dmg_done > 0 then
    local tainted_drain = context.GlobalContextStates:GetWithDefault(luanet.ctype(TaintedDrainType))
    if tainted_drain ~= nil then
      SOUND:PlayBattleSE("DUN_Toxic")
      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_LIQUID_OOZE"):ToLocal(), context.User:GetDisplayName(false)))
      TASK:WaitTask(context.User:InflictDamage(math.max(1, (dmg_done * numer * 2) / denom )))
    else
      TASK:WaitTask(context.User:RestoreHP(math.max(1, dmg_done * numer) / denom ))
    end
  end
end

function BATTLE_SCRIPT.CrystalHealCountdownRemove(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.User:GetStatusEffect(status)
  local crystal_stack = stack.StatusStates:Get(luanet.ctype(StackType))
  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)

  local drain_num = 1
  local drain_denom = 2
  if crystal_stack.Stack == 2 then
    drain_num = 3
    drain_denom = 4
  elseif crystal_stack.Stack == 3 then
    -- drain_num = 1
    drain_denom = 1
    
  end

  BATTLE_SCRIPT.CustomHpDrainEvent(owner, ownerChar, context, { Numerator = drain_num, Denominator = drain_denom })
  -- local hp_drain_event = PMDC.Dungeon.HPDrainEvent(drain_denom)
  -- TASK:WaitTask(hp_drain_event:Apply(owner, ownerChar, context))

  local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
  if (context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item) and dmg > 0 then
    s.Counter = s.Counter - 1
  end
  if s.Counter <= 0 then
    TASK:WaitTask(context.User:RemoveStatusEffect(status, true))
  end
end

-- function BATTLE_SCRIPT.FickleSpecsEvent(owner, ownerChar, context, args)
--   local boost_rate = 2
--   local reverse = false
--   if type(args.BoostRate) == "number" then boost_rate = args.BoostRate end
--   if type(args.Reverse) == "boolean" then reverse = args.Reverse end

--   local move_status_id = "last_used_move"
--   local move_repeat_status_id = "times_move_used"
--   local move_status = context.User:GetStatusEffect(move_status_id)
--   local repeat_status = context.User:GetStatusEffect(move_repeat_status_id)
--   if move_status == nil or repeat_status == nil then
--     return
--   end
--   local contains_move_id = move_status.StatusStates:Get(luanet.ctype(IDStateType)).ID == context.Data.ID
--   if reverse then
--     contains_move_id = not contains_move_id
--   end

--   if contains_move_id then
--     return
--   end
--   if not repeat_status.StatusStates:Contains(luanet.ctype(RecentStateType)) then
--     return
--   end

--   local effects = {
--     PMDC.Dungeon.BoostCriticalEvent(boost_rate)
--   }

--   for _, effect in pairs(effects) do
--     TASK:WaitTask(effect:Apply(owner, ownerChar, context))
--   end
-- end

function BATTLE_SCRIPT.EmberfrostOnAfterActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  beholder.trigger("OnAfterActions", owner, ownerChar, context, args)
end

function BATTLE_SCRIPT.EmberfrostOnActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  
  beholder.trigger("OnActions", owner, ownerChar, context, args)
end


function BATTLE_SCRIPT.EmberfrostOnBeforeActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  
  beholder.trigger("OnBeforeActions", owner, ownerChar, context, args)
end

function BATTLE_SCRIPT.EmberfrostBeforeHits(owner, ownerChar, context, args)
  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end
  
  beholder.trigger("BeforeHits", owner, ownerChar, context, args)
end


function BATTLE_SCRIPT.EmberfrostOnHits(owner, ownerChar, context, args)
  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end
  
  -- print("EmberfrostOnHits triggered")
  beholder.trigger("OnHits", owner, ownerChar, context, args)
end


function BATTLE_SCRIPT.EmberfrostBeforeExplosions(owner, ownerChar, context, args)
  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end
  
  beholder.trigger("BeforeExplosions", owner, ownerChar, context, args)
end

function BATTLE_SCRIPT.EmberfrostBeforeTryActions(owner, ownerChar, context, args)
  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end
  
  beholder.trigger("BeforeTryActions", owner, ownerChar, context, args)
end


function BATTLE_SCRIPT.EmberfrostOnHitTiles(owner, ownerChar, context, args)
  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end
  
  beholder.trigger("OnHitTiles", owner, ownerChar, context, args)
end


-- function BATTLE_SCRIPT.EmberfrostBeforeBeingHits(owner, ownerChar, context, args)
--   -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
--   --   return
--   -- end
  
--   beholder.trigger("OnBeforeBeingHits", owner, ownerChar, context, args)
-- end

-- function BATTLE_SCRIPT.EmberfrostBeforeHittings(owner, ownerChar, context, args)
--   -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
--   --   return
--   -- end
  
--   beholder.trigger("OnBeforeHittings", owner, ownerChar, context, args)
-- end