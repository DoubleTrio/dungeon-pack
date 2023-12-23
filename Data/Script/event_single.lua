
BATTLE_SCRIPT = {}

StackStateType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')

SINGLE_CHAR_SCRIPT = {}

function ResetEffectTile(owner)
  local effect_tile = owner
  local base_loc = effect_tile.TileLoc
  local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
  if tile.Effect == owner then
    tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
  end
end

function SINGLE_CHAR_SCRIPT.CrystalStatusCheck(owner, ownerChar, context, args)
  local status = args.Status
  local max_stack = args.MaxStack
  local string_key = args.StringKey
  local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(status, false, false, 1)
  local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
  mock_context.User = context.User
  local stack = context.User:GetStatusEffect(status)
  if stack ~= nil then
    local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
    -- STACK IS THE MAX STAT BOOST
    print(tostring(s.Stack) .. "STACK")
    if s.Stack < max_stack then
      ResetEffectTile(owner)
      TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
    else
      local msg = RogueEssence.StringKey(string_key):ToLocal()
      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
    end
    
  else
    ResetEffectTile(owner)
    TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
  end
end
-- local new_context = RogueEssence.Dungeon.SingleCharContext(target)
-- TASK:WaitTask(monster_event:Apply(owner, ownerChar, new_context))
-- PMDC.Dungeon.StatusStackBattleEvent(string statusID, bool affectTarget, bool silentCheck, int stack)
