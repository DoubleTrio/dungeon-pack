require 'trios_dungeon_pack.helpers'

StackType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
TotalDamageDealtType = luanet.import_type('PMDC.Dungeon.TotalDamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')

TaintedDrainType = luanet.import_type('PMDC.Dungeon.TaintedDrain')
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
