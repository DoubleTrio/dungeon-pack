require 'trios_dungeon_pack.helpers'
require 'trios_dungeon_pack.emberfrost.enchantments.enchants'

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

function BATTLE_SCRIPT.RestartCounterEvent(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.Target:GetStatusEffect(status)
  local counter = args.Counter or 10
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    s.Counter = counter
  end
end


-- Decreases the counter by 1
function BATTLE_SCRIPT.CountdownEvent(owner, ownerChar, context, args)
  local status = owner.ID
  local stack_effect = context.Target:GetStatusEffect(status)
  if stack_effect ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    s.Counter = s.Counter - 1
    -- if s.Counter <= 0 then
    --   TASK:WaitTask(context.Target:RemoveStatusEffect(status, true))
    -- end
    print(tostring(s.Counter))
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




-- function BATTLE_SCRIPT.TargetStatusRequired(owner, ownerChar, context, args)
--   local status = args.StatusID
--   local target = context.Target
--   local message_key = args.MessageKey
--   local stack = target:GetStatusEffect(status)
--   if stack == nil then
--     if message_key ~= nil then
--       _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey(message_key):ToLocal(),
--         context.Target:GetDisplayName(false)))
--     end

--     context.CancelState.Cancel = true
--   end
-- end


function BATTLE_SCRIPT.HeavyRock(owner, ownerChar, context, args)

  if context.ActionType ~= RogueEssence.Dungeon.BattleActionType.Throw then
    return
  end


  local chara = context.User

  local item = GetItemFromContext(context)

  if item == nil then
    return
  end

  local rock_items = M_HELPERS.map(HEAVY_ROCK_TABLE, function (entry) return entry.Item
    
  end)

  if not Contains(rock_items, item) then
    return
  end

  local anim_data = RogueEssence.Content.AnimData("Rock_Climb_Back", 2, -1, -1, 255, Dir8.Up)

  local emitter = RogueEssence.Content.SingleEmitter(anim_data)



  GAME:WaitFrames(10)

  DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)



  local attack_boost = PMDC.Dungeon.MultiplyDamageEvent(150, 100)
  TASK:WaitTask(attack_boost:Apply(owner, ownerChar, context))


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


function BATTLE_SCRIPT.SubtractPPEvent(owner, ownerChar, context, args)
  local amount = args.Amount or 1
  if context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill
      and context.UsageSlot > RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
      and context.UsageSlot < RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS then
    if context.User.Skills[context.UsageSlot].Element.Charges > 0 then
      if amount > 0 then
        TASK:WaitTask(
          context.User:DeductCharges(context.UsageSlot, amount, true, false, true)
        )
        if context.User.Skills[context.UsageSlot].Element.Charges == 0 then
          context.SkillUsedUp.Skill = context.User.Skills[context.UsageSlot].Element.SkillNum
        end
      end
    end
  end
end


function BATTLE_SCRIPT.DraconicDefienceBeforeActions(owner, ownerChar, context, args)
  local chara = context.User
  local health_ratio = chara.HP / chara.MaxHP

  if health_ratio <= 0.50 then
    local anim_data = RogueEssence.Content.AnimData("Taunt_Veins", 5, -1, -1, 255, Dir8.Up)
    local particle_anim = RogueEssence.Content.ParticleAnim(anim_data, 1, 0)
    local emitter = RogueEssence.Content.SqueezedAreaEmitter(particle_anim)
    emitter.Bursts = 1
    emitter.ParticlesPerBurst = 1
    emitter.BurstTime = 6
    emitter.HeightSpeed = 16
    emitter.Range = 4
    local sound = "DUN_Taunt"
    SOUND:PlayBattleSE(sound)
    GAME:WaitFrames(10)
    DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y)
  end
end

function BATTLE_SCRIPT.DraconicDefience(owner, ownerChar, context, args)
  -- print("Ravenous called")
  local chara = context.User



  local health_ratio = chara.HP / chara.MaxHP

  local add_boost = 0

  if health_ratio <= 0.01 then
    add_boost = 150
  elseif health_ratio <= 0.05 then
    add_boost = 100
  elseif health_ratio <= 0.10 then
    add_boost = 50
  elseif health_ratio <= 0.25 then
    add_boost = 25
  elseif health_ratio <= 50 then
    add_boost = 10
  end

  print("Draconic Defience health ratio: " .. tostring(health_ratio) .. " add_boost: " .. tostring(add_boost)  )
  if add_boost > 0 and (context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Physical or context.Data.Category == RogueEssence.Data.BattleData.SkillCategory.Magical) then
    local attack_boost = PMDC.Dungeon.MultiplyDamageEvent(100 + add_boost, 100)

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

function BATTLE_SCRIPT.StoreItemInEnchant(owner, ownerChar, context, args)
  if context.ActionType ~= RogueEssence.Dungeon.BattleActionType.Item then
    return
  end

  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end

  local enchant_id = args.EnchantmentID


  local item = GetItemFromContext(context)

  local data = EnchantmentRegistry:GetData(enchant_id)

  data["item"] = item
end

function BATTLE_SCRIPT.BerryNutritiousAfterActions(owner, ownerChar, context, args)


  if context.ActionType ~= RogueEssence.Dungeon.BattleActionType.Item then
    return
  end

  -- if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
  --   return
  -- end


  local enchant_id = args.EnchantmentID
  local chance = args.Chance
  local data = EnchantmentRegistry:GetData(enchant_id)

  local item = data["item"]

  if item == nil then 
    return
  end



  BerryStateType = luanet.import_type('PMDC.Dungeon.BerryState')
  local contains = ItemIdContainsState(item, BerryStateType)

  if not contains then
    return
  end

  local roll = _DATA.Save.Rand:Next(100)
  if roll >= chance then
    return
  end


  local sound = "DUN_Gummi"
  SOUND:PlayBattleSE(sound)
  local rand_index = _DATA.Save.Rand:Next(#STATS) + 1
  local stat = STATS[rand_index]

  local stat_text = RogueEssence.Text.ToLocal(stat)
  local user = context.User


  _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar("{0} gained [a/an] {1} stat boost!",
    user:GetDisplayName(true),
    stat_text
  ))
  BoostStat(stat, 1, user)
end

function BATTLE_SCRIPT.EvioliteEvent(owner, ownerChar, context, args)
  --NOTE: A 50% decrease in damage was a bit powerful... 
  --This has been nerfed to 20%
  local DEFAULT_NUM = 20
  local DEFUALT_DENOM = 25

  local phy_num = DEFAULT_NUM
  local phy_denom = DEFUALT_DENOM

  local spec_num = DEFAULT_NUM
  local spec_denom = DEFUALT_DENOM

  if type(args.PhyNum) == "number" then p_num = args.PhyNum end
  if type(args.PhyDenom) == "number" then p_denom = args.PhyDenom end
  if type(args.SpecNum) == "number" then spec_num = args.SpecNum end
  if type(args.SpecDenom) == "number" then spec_denom = args.SpecDenom end
  local apply_effect = GAME:CanPromote(context.Target)
  if args.Reverse then apply_effect = (not apply_effect) end

  if apply_effect then
    local effects = {
      PMDC.Dungeon.MultiplyCategoryEvent(RogueEssence.Data.BattleData.SkillCategory.Physical, phy_num, phy_denom),
      PMDC.Dungeon.MultiplyCategoryEvent(RogueEssence.Data.BattleData.SkillCategory.Magical, spec_num, spec_denom)
    }

    for _, effect in pairs(effects) do
      TASK:WaitTask(effect:Apply(owner, ownerChar, context))
    end
  end
end


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

function BATTLE_SCRIPT.EmberfrostAfterActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  beholder.trigger("AfterActions", owner, ownerChar, context, args)
end

function BATTLE_SCRIPT.EmberfrostOnActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  
  beholder.trigger("OnActions", owner, ownerChar, context, args)
end


function BATTLE_SCRIPT.EmberfrostBeforeActions(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
    return
  end
  
  beholder.trigger("BeforeActions", owner, ownerChar, context, args)
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

function BATTLE_SCRIPT.Protagonist(owner, ownerChar, context, args)

  local boost = args.BoostAmount
  if context.User == _DUNGEON.ActiveTeam.Leader then
    local multiply_element = PMDC.Dungeon.MultiplyDamageEvent(100 + boost, 100)
    TASK:WaitTask(multiply_element:Apply(owner, ownerChar, context))
  elseif context.Target == _DUNGEON.ActiveTeam.Leader then
    local multiply_element = PMDC.Dungeon.MultiplyDamageEvent(100 - boost, 100)
    TASK:WaitTask(multiply_element:Apply(owner, ownerChar, context))
  end
end

function BATTLE_SCRIPT.MoralSupport(owner, ownerChar, context, args)

  local enchant_id = args.EnchantmentID

  local enchant = EnchantmentRegistry:Get(enchant_id)

  local boost = enchant:get_total_boost()
  local num = 100 + boost
  local denom = 100
  if context.User.MemberTeam == _DUNGEON.ActiveTeam then
    local multiply_element = PMDC.Dungeon.MultiplyDamageEvent(num, denom)
    TASK:WaitTask(multiply_element:Apply(owner, ownerChar, context))
  end
end

-- function COMMON.DungeonInteract(chara, target, action_cancel, turn_cancel)

  -- COMMON.DungeonInteract(context.User, context.Target, context.CancelState, context.TurnCancel)
function BATTLE_SCRIPT.PuppetInteract(owner, ownerChar, context, args)

  local action_cancel = context.CancelState
  local turn_cancel = context.TurnCancel
  local chara = context.User
  local target = context.Target
  action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    UI:SetSpeaker(target)
    UI:SetSpeakerEmotion("Happy")
    local quote = "...!"

    local tbl = LTBL(target)

    local same_species = tbl["species"] == chara.BaseForm.Species
    if same_species then
      UI:SetSpeakerEmotion("Joyous")
      quote = "...I'm you!"
    end
    
    local oldDir = target.CharDir
    
    local ratio = target.HP * 100 // target.MaxHP
      if ratio <= 25 then
        UI:SetSpeakerEmotion("Pain")
        quote = "......"
        if same_species then
          quote = "...Help me?"
        end
        -- pool = personality_group.PINCH
        -- key = "TALK_PINCH_%04d"
      elseif ratio <= 50 then
        UI:SetSpeakerEmotion("Worried")
        quote = "......?"
      if same_species then
        quote = "...Why do I feel like this?"
      end
        -- pool = personality_group.HALF
        -- key = "TALK_HALF_%04d"
      else
        -- pool = personality_group.FULL
        -- key = "TALK_FULL_%04d"
      end
      DUNGEON:CharTurnToChar(target, chara)
    
      UI:WaitShowDialogue(quote)
    
      target.CharDir = oldDir
  else
  
    UI:ResetSpeaker()
  
    local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))
  
    UI:WaitShowDialogue(chosen_quote)
  
  end
  UI:ResetSpeaker()

end

local function RunShop(item_list)
    local state = 0
    
    while state == 0 do
        local inv_cost = GetInventoryCost()
        local choices = {
            { "Buy",            true },
            { "Sell All Items", inv_cost > 0 },
            { "Cancel",         true },
        }
        
        local question = "What business do you have for me today?"
        UI:BeginChoiceMenu(question, choices, 1, 3)
        UI:WaitForChoice()
        local result = UI:ChoiceResult()
        
        if result == 1 then
            -- Buy menu
            local buy_state = 0
            while buy_state == 0 do
                local item_choices = {}
                for _, item in ipairs(item_list) do
                    local item_name = M_HELPERS.GetItemName(item.Item, item.Amount)
                    local price_display = item_name .. " (" .. M_HELPERS.FormatMoney(item.Price) .. ")"
                    local money = _DATA.Save.ActiveTeam.Money
                    local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
                    local max_inv_slots = _DATA.Save.ActiveTeam:GetMaxInvSlots(_ZONE.CurrentZone)
                    local available_slots = max_inv_slots - inv_count
                    table.insert(item_choices, { price_display, available_slots > 0 and money >= item.Price })
                end
                table.insert(item_choices, { "Cancel", true })
                
                local question = "Have a look! Do you see anything that you like?"
                UI:BeginChoiceMenu(question, item_choices, 1, #item_choices)
                UI:WaitForChoice()
                local item_result = UI:ChoiceResult()
                
                if item_result > 0 and item_result <= #item_list then
                    -- Confirm purchase
                    local selected_item = item_list[item_result]
                    local item_name = M_HELPERS.GetItemName(selected_item.Item, selected_item.Amount)
                    UI:ChoiceMenuYesNo(string.format("Ah, the %s! How about for %s?", item_name, M_HELPERS.FormatMoney(selected_item.Price)))
                    UI:WaitForChoice()
                    local confirm = UI:ChoiceResult()
                    
                    if confirm then
                        _DATA:LogUIPlay(item_result + 1)
                        SOUND:PlayBattleSE("DUN_Money")
                        UI:WaitShowDialogue("Pleasure doing business with you!")
                        UI:ResetSpeaker()
                        return item_result + 1
                    else
                        _DATA:LogUIPlay(-1)
                    end
                else
                    _DATA:LogUIPlay(-1)
                    buy_state = 1
                end
            end
            
        elseif result == 2 then
            local inv_cost = GetInventoryCost()
            UI:ChoiceMenuYesNo(string.format("I shall give you %s for all your items. How does that sound?", M_HELPERS.FormatMoney(inv_cost)))
            UI:WaitForChoice()
            local sell_inv = UI:ChoiceResult()
            
            if sell_inv then
                SOUND:PlayBattleSE("DUN_Money")
                _DATA:LogUIPlay(1)
                UI:WaitShowDialogue("Thank you for your business!")
                UI:ResetSpeaker()

            else
                _DATA:LogUIPlay(-1)
            end
            
        else
            _DATA:LogUIPlay(-1)
            state = 1
        end
    end
    
    UI:ResetSpeaker()
    return -1
end

function BATTLE_SCRIPT.TravelingMerchantInteract(owner, ownerChar, context, args)
  local action_cancel = context.CancelState
  local turn_cancel = context.TurnCancel
  local chara = context.User
  local target = context.Target
  turn_cancel.Cancel = true


  -- action_cancel.Cancel = true

  if COMMON.CanTalk(target) then
    UI:SetSpeaker(target)
    UI:SetSpeakerEmotion("Normal")

    local oldDir = target.CharDir

    local ratio = target.HP * 100 // target.MaxHP
    if ratio <= 25 then

    elseif ratio <= 50 then

    else

    end
    DUNGEON:CharTurnToChar(target, chara)
    local tbl = LTBL(target)
    local item_list = tbl.Items


    local actions = {
      function()
        local inv_cost = GetInventoryCost()
        _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + inv_cost
      end,
    }

    for i, item in ipairs(item_list) do
      table.insert(actions, function()
        local item_name = item.Item
        local item_price = item.Price
        local item_amount = item.Amount

        local inv_item = RogueEssence.Dungeon.InvItem(item_name, false, item_amount)

        _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money - item_price
        GAME:GivePlayerItem(inv_item)
      end)
    end

    local ui_index = -1
    if _DATA.CurrentReplay ~= nil then
      ui_index = _DATA.CurrentReplay:ReadUI()
      if ui_index ~= -1 then
        actions[ui_index]()
      end
    else
      local purchased_index = RunShop(item_list)
      if purchased_index ~= -1 then
        actions[purchased_index]()
      end
    end



    target.CharDir = oldDir
  else
    UI:ResetSpeaker()

    local chosen_quote = RogueEssence.StringKey("TALK_CANT"):ToLocal()
    chosen_quote = string.gsub(chosen_quote, "%[myname%]", target:GetDisplayName(true))

    UI:WaitShowDialogue(chosen_quote)
    return
  end


end


function BATTLE_SCRIPT.MelodyBoxBattleEvent(owner, ownerChar, context, args)

  context.CancelState.Cancel = true
  context.TurnCancel.Cancel = true

  local result = GetMusicSelection()

  if result ~= nil and result ~= "" then
    SV.EmberFrost.MelodyBox.LastDungeonMusic = _ZONE.CurrentMap.Music
    SV.EmberFrost.MelodyBox.DungeonMusicSelection = result
  else
    result = _ZONE.CurrentMap.Music
    SV.EmberFrost.MelodyBox.DungeonMusicSelection = nil
  end
  SOUND:PlayBGM(result, true)
end

function BATTLE_SCRIPT.NoxiousAfterHittings(owner, owner_char, context, args)
  local random_statuses = {
    "confuse", "sleep", "burn", "flinch", "paralyze", "freeze",
    "taunted", "torment", "poison", "poison_toxic"
  }

  local is_skill_action = context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local category = context.Data.Category
  local is_offensive = category == RogueEssence.Data.BattleData.SkillCategory.Physical
      or category == RogueEssence.Data.BattleData.SkillCategory.Magical

  if not (is_skill_action and is_non_default and is_offensive) then return end

  local roll = _DATA.Save.Rand:Next(100)
  if roll >= 25 or context.Target.Dead then return end

  local anim_data = RogueEssence.Content.AnimData("Cross_Poison_Bubbles", 5, -1, -1, 255, Dir8.Up)
  local particle_anim = RogueEssence.Content.ParticleAnim(anim_data, 1, 0)
  local emitter = RogueEssence.Content.SqueezedAreaEmitter(particle_anim)
  emitter.Bursts = 1
  emitter.ParticlesPerBurst = 1
  emitter.BurstTime = 6
  emitter.HeightSpeed = 16
  emitter.Range = 4

  SOUND:PlayBattleSE("DUN_Cross_Poison")
  GAME:WaitFrames(10)
  DUNGEON:PlayVFX(emitter, context.Target.MapLoc.X, context.Target.MapLoc.Y)

  local rand_status = random_statuses[_DATA.Save.Rand:Next(#random_statuses) + 1]
  local status = RogueEssence.Dungeon.StatusEffect(rand_status)
  status:LoadFromData()
  TASK:WaitTask(context.Target:AddStatusEffect(nil, status, true))
end


function BATTLE_SCRIPT.TypeAttackStackBoost(owner, owner_char, context, args)
  local denom = args.Denom or 100
  local boost = args.Boost or 1
  local boost_type = args.Type

  local stack_effect = context.User:GetStatusEffect(owner.ID)
  if stack_effect == nil then return end

  local stack_state = stack_effect.StatusStates:Get(luanet.ctype(StackStateType))
  if stack_state == nil then return end

  local is_skill_action = context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local category = context.Data.Category
  local is_offensive = category == RogueEssence.Data.BattleData.SkillCategory.Physical
      or category == RogueEssence.Data.BattleData.SkillCategory.Magical

  if not (is_skill_action and is_non_default and is_offensive) then return end

  local skill_data = _DATA:GetSkill(GetSkillFromContext(context))

  print(tostring(boost_type))
  print(tostring(skill_data.Data.Element))
  if skill_data.Data.Element ~= boost_type then return end

  local multiplier = denom + (stack_state.Stack * boost)
  print(tostring(multiplier))
  -- local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(owner.ID, false, false, stack_state.Stack + 1)
  -- TASK:WaitTask(status_stack_event:Apply(owner, owner_char, context))
  -- print(tostring(stack_state.Stack))

  local multiply_event = PMDC.Dungeon.MultiplyDamageEvent(multiplier, denom)
  TASK:WaitTask(multiply_event:Apply(owner, owner_char, context))
end


function BATTLE_SCRIPT.TypeAttackStackBoostAfterActions(owner, ownerChar, context, args)
  local boost_type = args.Type
  local anim = args.Anim
  local chara = context.User
  local frame_time = args.FrameTime
  local is_skill_action = context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local category = context.Data.Category
  local is_offensive = category == RogueEssence.Data.BattleData.SkillCategory.Physical
      or category == RogueEssence.Data.BattleData.SkillCategory.Magical
  if not (is_skill_action and is_non_default and is_offensive) then return end

  local skill_data = _DATA:GetSkill(GetSkillFromContext(context))
  if skill_data.Data.Element ~= boost_type then return end

  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)
  if dmg <= 0 then return end

  local stack_effect = chara:GetStatusEffect(owner.ID)
  if stack_effect == nil then return end

  local stack_state = stack_effect.StatusStates:Get(luanet.ctype(StackStateType))
  if stack_state == nil then return end

  local anim_data = RogueEssence.Content.AnimData(anim, frame_time, -1, -1, 255, Dir8.Up)

  local emitter = RogueEssence.Content.SingleEmitter(anim_data)



  GAME:WaitFrames(10)

  DUNGEON:PlayVFX(emitter, chara.MapLoc.X, chara.MapLoc.Y - 40)

  local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(owner.ID, false, false, stack_state.Stack + 1)
  TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, context))
end


function BATTLE_SCRIPT.OnDamageAddStatusIfNotContainStatuses(owner, ownerChar, context, args)
  local status_to_add = args.Status
  local status_list_check = args.StatusList
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)
  if dmg <= 0 then return end

  if not (is_non_default) then return end

  for _, status_to_check in ipairs(status_list_check) do
    local has_status = context.User:GetStatusEffect(status_to_check) ~= nil
    if has_status then return end
  end

  local loaded_status = RogueEssence.Dungeon.StatusEffect(status_to_add)
  loaded_status:LoadFromData()

  TASK:WaitTask(context.User:AddStatusEffect(nil, loaded_status, true))
end

function BATTLE_SCRIPT.OnDamageRestartStatusCounter(owner, ownerChar, context, args)
  local current_status = owner.ID
  local counter = args.Counter

  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)

  if dmg <= 0 then return end

  
  if not (is_non_default) then return end

  local status_effect = context.User:GetStatusEffect(current_status)
  if status_effect ~= nil then
    local s = status_effect.StatusStates:Get(luanet.ctype(CountDownStateType))
    s.Counter = counter
  end
end

-- function SINGLE_CHAR_SCRIPT.RestartCounterEvent(owner, ownerChar, context, args)
--   local status = owner.ID
--   local stack = context.User:GetStatusEffect(status)
--   local counter = args.Counter or 10
--   if stack ~= nil then
--     local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
--     s.Counter = counter
--   end
-- end

function BATTLE_SCRIPT.OnDamageAddAndRemoveStatus(owner, ownerChar, context, args)
  local current_status = owner.ID
  local status_to_add = args.Status
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  local dmg = context:GetContextStateInt(luanet.ctype(TotalDamageDealtType), true, 0)

  if dmg <= 0 then return end
  if not (is_non_default) then return end

  TASK:WaitTask(context.User:RemoveStatusEffect(current_status, true))
  local loaded_status = RogueEssence.Dungeon.StatusEffect(status_to_add)
  loaded_status:LoadFromData()
  TASK:WaitTask(context.User:AddStatusEffect(nil, loaded_status, true))
end

function BATTLE_SCRIPT.DoubleUp(owner, ownerChar, context, args)
  local is_non_default = context.UsageSlot ~= RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT

  local is_skill_action = context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill

  if not (is_skill_action and is_non_default) then return end

  if not (is_non_default) then return end

  if context.StrikesMade == 0 then
    context.Strikes = context.Strikes * 2
  end
end

-- function BATTLE_SCRIPT.OnDamageRestartStatusCounter(owner, ownerChar, context, args)
--   local 
-- end


-- function SINGLE_CHAR_SCRIPT.CrystalStatusCheck(owner, ownerChar, context, args)
--   local status = args.Status
--   local max_stack = args.MaxStack
--   -- print(tostringmax_stack)
--   local string_key = args.StringKey
--   local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(status, false, false, 1)
--   local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
--   mock_context.User = context.User
--   local stack = context.User:GetStatusEffect(status)
--   if stack ~= nil then
--     local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
--     if s.Stack < max_stack then
--       ResetEffectTile(owner)
--       TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
--     else
--       local msg = RogueEssence.StringKey(string_key):ToLocal()
--       _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
--     end
--   else
--     ResetEffectTile(owner)
--     TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
--   end
-- end
