BATTLE_SCRIPT = {}

StackType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')

function BATTLE_SCRIPT.AccuracyTalk(owner, ownerChar, context, args)
  -- context.CancelState.Cancel = true
  
  -- local oldDir = context.Target.CharDir
  -- DUNGEON:CharTurnToChar(context.Target, context.User)
  
  -- UI:SetSpeaker(context.Target)
  
  -- local sanded = false
  -- local acc_mod = context.Target:GetStatusEffect("mod_accuracy")
  -- if acc_mod ~= nil then
  --   local stack = acc_mod.StatusStates:Get(luanet.ctype(StackType))
	-- if stack.Stack < 0 then
	--   sanded = true
	-- end
  -- end
  
  -- if sanded then
  --   UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("TALK_ADVICE_STAT_DROP"):ToLocal()))
  -- else
  --   UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("TALK_ADVICE_STAT_DROP_CLEAR"):ToLocal()))
  -- end
  
  -- context.Target.CharDir = oldDir
end


-- ADD STACK CHECK CRYDTAL DEFENSE IN BEFORE STATUS ADDS
function BATTLE_SCRIPT.SwarmTrap(owner, ownerChar, context, args)
  print("HEREE")
end


-- function BATTLE_SCRIPT.RemoveStatusStackCheck(owner, ownerChar, context, args)
  -- print(args.MaxStack .. args.Status)
  -- print("HEREEEE")
  -- local effect_tile = owner
  -- print(tostring(effect_tile))
  -- local base_loc = effect_tile.TileLoc
  -- print(tostring(owner.TileLoc))
  -- print(tostring(owner.User))
  -- print(tostring(ownerChar) .. "OWNER")
  -- print(tostring(context))
  -- print(tostring(context.User) .. "OWNER")
  -- local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
  -- if tile.Effect == owner then
  --   tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
  -- end

  
-- end

function BATTLE_SCRIPT.CrystalDefenseCountdownRemove(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.Target:GetStatusEffect(status)
  local dmg = context:GetContextStateInt(luanet.ctype(DamageDealtType), 0)
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    if context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item and dmg > 0 then
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
  local dmg = context:GetContextStateInt(luanet.ctype(DamageDealtType), 0)
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    if context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item and dmg > 0 then
      s.Counter = s.Counter - 1
    end
    if s.Counter <= 0 then
      TASK:WaitTask(context.User:RemoveStatusEffect(status, true))
    end
  end
end

function BATTLE_SCRIPT.CrystalHealCountdownRemove(owner, ownerChar, context, args)
  local status = owner.ID
  local stack = context.User:GetStatusEffect(status)
  local dmg = context:GetContextStateInt(luanet.ctype(DamageDealtType), 0)

  local hp_drain_event = PMDC.Dungeon.HPDrainEvent(2)
  -- local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
  -- mock_context.User = context.User
  TASK:WaitTask(hp_drain_event:Apply(owner, ownerChar, context))


  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(CountDownStateType))
    if context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill or context.ActionType == RogueEssence.Dungeon.BattleActionType.Item and dmg > 0 then
      s.Counter = s.Counter - 1
    end
    if s.Counter <= 0 then
      TASK:WaitTask(context.User:RemoveStatusEffect(status, true))
    end
  end
end


  -- local acc_mod = context.Target:GetStatusEffect("mod_accuracy")
  -- if acc_mod ~= nil then
  --   local stack = acc_mod.StatusStates:Get(luanet.ctype(StackType))
	-- if stack.Stack < 0 then
	--   sanded = true
	-- end

-- function BATTLE_SCRIPT.RemoveStatusStackCheck(owner, ownerChar, context, args)
--   local status = args.Status
--   local max_stack = args.MaxStack
--   local stack = context.Target:GetStatusEffect(status)
--   if stack ~= nil then
--     local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
--     print(tostring(s.Stack), "STACK HEREEE")
--     print(tostring(max_stack), "MAX_STACK HEREEE")
--     -- STACK IS THE MAX STAT BOOST
--     if s.Stack < max_stack then
--       -- local effect_tile = owner
--       -- local base_loc = effect_tile.TileLoc
--       -- local base_loc = context.Target.CharLoc
--       -- local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
--       -- tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
--     else
--       context.Cancel.CancelState = true
--     end
--   else
--     -- local base_loc = context.Target.CharLoc
--     -- local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
--     -- tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
--   end
-- end