
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

function SINGLE_CHAR_SCRIPT.LogShimmeringEvent(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  -- SOUND:PlayFanfare("Fanfare/Note")
  -- UI:ResetSpeaker()
  -- UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_DESTINATION"):ToLocal()))
  local msg = RogueEssence.StringKey(args.StringKey):ToLocal()
  _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg))
  -- UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_DESTINATION"):ToLocal()))
end
-- local new_context = RogueEssence.Dungeon.SingleCharContext(target)
-- TASK:WaitTask(monster_event:Apply(owner, ownerChar, new_context))
-- PMDC.Dungeon.StatusStackBattleEvent(string statusID, bool affectTarget, bool silentCheck, int stack)

function SINGLE_CHAR_SCRIPT.AskWishEvent(owner, ownerChar, context, args)
  -- if context.User ~= nil then
  --   return
  -- end
  -- local msg = RogueEssence.StringKey(args.StringKey):ToLocal()
  print("WishEvent")
  print(tostring(context.User))
  -- if (co.Direction)
  print(tostring( context.User.Direction ))
  if context.User.CharDir == Direction.Up then
    _DUNGEON:LogMsg("TESTING HERE")
  end
end

function SINGLE_CHAR_SCRIPT.CrystalGlowEvent(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam.Leader.MemberTeam then
    return
  end

  -- Example usage
  local entries = {
    {item = "Option 1", weight = 2},
    {item = "Option 2", weight = 1},
    {item = "Option 3", weight = 10}
  }

  -- CHECK IF THERE'S AN ITEM IN THE WAY OR NOT
  print(tostring(owner.TileLoc))
  local inv_item = RogueEssence.Dungeon.InvItem("wish_gem")
  local map_item = RogueEssence.Dungeon.MapItem(inv_item)
  map_item.ItemLoc = owner.TileLoc

  -- print(tostring(map_item.Amount))
  local selected = PickByWeight(entries)
  -- ResetEffectTile(owner)
  

  -- print("Selected option:", selected)
  -- if context.User ~= nil then
  --   return
  -- end
  -- local msg = RogueEssence.StringKey(args.StringKey):ToLocal()
  -- print("CrystalGlowEvent")
  -- print(tostring(context.User))
  -- -- if (co.Direction)
  -- print(tostring( context.User.Direction ))
  -- if context.User.CharDir == Direction.Up then
  --   _DUNGEON:LogMsg("TESTING HERE")
  -- end
  --
end

-- public class NoticeEvent : SingleCharEvent
-- {
--     public NoticeEvent() { }
--     public override GameEvent Clone() { return new NoticeEvent(); }

--     public override IEnumerator<YieldInstruction> Apply(GameEventOwner owner, Character ownerChar, SingleCharContext context)
--     {
--         if (context.User == DungeonScene.Instance.ActiveTeam.Leader)
--         {
--             NoticeState notice = ((EffectTile)owner).TileStates.GetWithDefault<NoticeState>();
--             if (notice == null)
--                 yield break;
--             GameManager.Instance.SE("Menu/Confirm");

--             DungeonScene.Instance.PendingLeaderAction = processNotice(notice);
--             yield break;
--         }
--     }

--     private IEnumerator<YieldInstruction> processNotice(NoticeState notice)
--     {
--         if (DataManager.Instance.CurrentReplay != null)
--             yield break;

--         if (!notice.Title.Key.IsValid())
--             yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetSign(notice.Content.FormatLocal()));
--         else
--             yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.ProcessMenuCoroutine(MenuManager.Instance.CreateNotice(notice.Title.FormatLocal(), notice.Content.FormatLocal())));
--     }
-- }

-- [Serializable]
-- public class AskEvoEvent : SingleCharEvent
-- {
--     [JsonConverter(typeof(ItemConverter))]
--     [DataType(0, DataManager.DataType.Item, false)]
--     public string ExceptionItem;

--     public AskEvoEvent() { ExceptionItem = ""; }
--     public AskEvoEvent(string exceptItem) { ExceptionItem = exceptItem; }
--     public AskEvoEvent(AskEvoEvent other) { ExceptionItem = other.ExceptionItem; }
--     public override GameEvent Clone() { return new AskEvoEvent(this); }

--     public override IEnumerator<YieldInstruction> Apply(GameEventOwner owner, Character ownerChar, SingleCharContext context)
--     {
--         if (context.User.MemberTeam == DungeonScene.Instance.ActiveTeam)
--         {
--             CharAnimation standAnim = new CharAnimIdle(context.User.CharLoc, context.User.CharDir);
--             standAnim.MajorAnim = true;
--             yield return CoroutineManager.Instance.StartCoroutine(context.User.StartAnim(standAnim));

--             if (DataManager.Instance.CurrentReplay != null)
--             {
--                 int index = DataManager.Instance.CurrentReplay.ReadUI();
--                 if (index > -1)
--                 {
--                     string currentSong = GameManager.Instance.Song;
--                     GameManager.Instance.BGM("", true);

--                     yield return CoroutineManager.Instance.StartCoroutine(beginEvo(context.User, index));

--                     GameManager.Instance.BGM(currentSong, true);
--                 }
--             }
--             else
--             {
--                 string currentSong = GameManager.Instance.Song;
--                 GameManager.Instance.BGM("", true);

--                 yield return new WaitForFrames(GameManager.Instance.ModifyBattleSpeed(20));

--                 int index = -1;

--                 yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetDialogue(Text.FormatGrammar(new StringKey("DLG_EVO_INTRO").ToLocal())));
--                 yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.ProcessMenuCoroutine(createEvoQuestion(context.User, (int slot) => { index = slot; })));

--                 if (DataManager.Instance.CurrentReplay == null)
--                     DataManager.Instance.LogUIPlay(index);

--                 if (index > -1)
--                     yield return CoroutineManager.Instance.StartCoroutine(beginEvo(context.User, index));

--                 yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetDialogue(Text.FormatGrammar(new StringKey("DLG_EVO_END").ToLocal())));

--                 GameManager.Instance.BGM(currentSong, true);

--                 yield return new WaitForFrames(1);
--             }
--         }
--     }

--     private DialogueBox createEvoQuestion(Character character, VertChoiceMenu.OnChooseSlot action)
--     {
--         return MenuManager.Instance.CreateQuestion(Text.FormatGrammar(new StringKey("DLG_EVO_ASK").ToLocal()), () =>
--         {
--             //check for valid branches
--             MonsterData entry = DataManager.Instance.GetMonster(character.BaseForm.Species);
--             bool bypass = character.EquippedItem.ID == ExceptionItem;
--             bool hasReq = false;
--             List<int> validEvos = new List<int>();
--             for (int ii = 0; ii < entry.Promotions.Count; ii++)
--             {
--                 if (!DataManager.Instance.DataIndices[DataManager.DataType.Monster].Get(entry.Promotions[ii].Result).Released)
--                     continue;
--                 bool hardReq = false;
--                 if (entry.Promotions[ii].IsQualified(character, true))
--                     validEvos.Add(ii);
--                 else
--                 {
--                     foreach (PromoteDetail detail in entry.Promotions[ii].Details)
--                     {
--                         if (detail.IsHardReq() && !detail.GetReq(character, true))
--                         {
--                             hardReq = true;
--                             break;
--                         }
--                     }
--                 }
--                 if (!hardReq)
--                 {
--                     if (bypass)
--                         validEvos.Add(ii);
--                     else
--                         hasReq = true;
--                 }
--             }
--             if (validEvos.Count == 0)
--             {
--                 if (hasReq)
--                     MenuManager.Instance.AddMenu(MenuManager.Instance.CreateDialogue(Text.FormatGrammar(new StringKey("DLG_EVO_NONE_NOW").ToLocal(), character.GetDisplayName(true))), false);
--                 else
--                     MenuManager.Instance.AddMenu(MenuManager.Instance.CreateDialogue(Text.FormatGrammar(new StringKey("DLG_EVO_NONE").ToLocal(), character.GetDisplayName(true))), false);
--             }
--             else if (validEvos.Count == 1)
--                 MenuManager.Instance.AddMenu(createTryEvoQuestion(character, action, validEvos[0]), false);
--             else
--             {
--                 List<DialogueChoice> choices = new List<DialogueChoice>();
--                 foreach (int validEvo in validEvos)
--                 {
--                     choices.Add(new DialogueChoice(DataManager.Instance.GetMonster(entry.Promotions[validEvo].Result).GetColoredName(),
--                         () => { MenuManager.Instance.AddMenu(createTryEvoQuestion(character, action, validEvo), false); }));
--                 }
--                 choices.Add(new DialogueChoice(Text.FormatKey("MENU_CANCEL"), () => { }));
--                 MenuManager.Instance.AddMenu(MenuManager.Instance.CreateMultiQuestion(Text.FormatGrammar(new StringKey("DLG_EVO_CHOICE").ToLocal(), character.GetDisplayName(true)), true, choices, 0, choices.Count - 1), false);
--             }
--         }, () => { });
--     }

--     private DialogueBox createTryEvoQuestion(Character character, VertChoiceMenu.OnChooseSlot action, int branchIndex)
--     {
--         MonsterData entry = DataManager.Instance.GetMonster(character.BaseForm.Species);
--         PromoteBranch branch = entry.Promotions[branchIndex];
--         bool bypass = character.EquippedItem.ID == ExceptionItem;
--         string evoItem = "";
--         foreach (PromoteDetail detail in branch.Details)
--         {
--             evoItem = detail.GetReqItem(character);
--             if (!String.IsNullOrEmpty(evoItem))
--                 break;
--         }
--         //factor in exception item to this question
--         if (bypass)
--             evoItem = ExceptionItem;
--         string question = !String.IsNullOrEmpty(evoItem) ? Text.FormatGrammar(new StringKey("DLG_EVO_CONFIRM_ITEM").ToLocal(), character.GetDisplayName(true), DataManager.Instance.GetItem(evoItem).GetIconName(), DataManager.Instance.GetMonster(branch.Result).GetColoredName()) : Text.FormatGrammar(new StringKey("DLG_EVO_CONFIRM").ToLocal(), character.GetDisplayName(true), DataManager.Instance.GetMonster(branch.Result).GetColoredName());
--         return MenuManager.Instance.CreateQuestion(question, () => { action(branchIndex); }, () => { });
--     }

--     private IEnumerator<YieldInstruction> beginEvo(Character character, int branchIndex)
--     {
--         MonsterData oldEntry = DataManager.Instance.GetMonster(character.BaseForm.Species);
--         PromoteBranch branch = oldEntry.Promotions[branchIndex];
--         bool bypass = character.EquippedItem.ID == ExceptionItem;

--         if (DataManager.Instance.CurrentReplay == null)
--             yield return CoroutineManager.Instance.StartCoroutine(MenuManager.Instance.SetDialogue(Text.FormatGrammar(new StringKey("DLG_EVO_BEGIN").ToLocal())));
--         character.CharDir = Dir8.Down;
--         //fade
--         GameManager.Instance.BattleSE("EVT_Evolution_Start");
--         yield return CoroutineManager.Instance.StartCoroutine(GameManager.Instance.FadeOut(true));
--         string oldName = character.GetDisplayName(true);
--         //evolve
--         MonsterData entry = DataManager.Instance.GetMonster(branch.Result);
--         MonsterID newData = character.BaseForm;
--         newData.Species = branch.Result;
--         branch.BeforePromote(character, true, ref newData);
--         character.Promote(newData);
--         branch.OnPromote(character, true, bypass);
--         if (bypass)
--             yield return CoroutineManager.Instance.StartCoroutine(character.DequipItem());

--         int oldFullness = character.Fullness;
--         character.FullRestore();
--         character.Fullness = oldFullness;
--         //restore HP and status problems
--         //{
--         //    context.User.HP = context.User.MaxHP;

--         //    List<int> statuses = new List<int>();
--         //    foreach (StatusEffect oldStatus in context.User.IterateStatusEffects())
--         //        statuses.Add(oldStatus.ID);

--         //    foreach (int statusID in statuses)
--         //        yield return CoroutineManager.Instance.StartCoroutine(context.User.RemoveStatusEffect(statusID, false));
--         //}

--         yield return new WaitForFrames(30);
--         //fade
--         GameManager.Instance.BattleSE("EVT_Title_Intro");
--         yield return CoroutineManager.Instance.StartCoroutine(GameManager.Instance.FadeIn());
--         //evolution chime
--         GameManager.Instance.Fanfare("Fanfare/Promotion");
--         //proclamation

--         yield return CoroutineManager.Instance.StartCoroutine(GameManager.Instance.LogSkippableMsg(Text.FormatGrammar(new StringKey("DLG_EVO_COMPLETE").ToLocal(), oldName, entry.GetColoredName())));

--         DataManager.Instance.Save.RegisterMonster(character.BaseForm.Species);
--         DataManager.Instance.Save.RogueUnlockMonster(character.BaseForm.Species);
--         yield return CoroutineManager.Instance.StartCoroutine(character.OnMapStart());

--         yield return CoroutineManager.Instance.StartCoroutine(DungeonScene.Instance.CheckLevelSkills(character, 0));
--         if (character.Level > 1)
--             yield return CoroutineManager.Instance.StartCoroutine(DungeonScene.Instance.CheckLevelSkills(character, character.Level - 1));
--     }
-- }

-- Function to pick an item based on weights
function pickWeightedItem(itemsWithWeights)
  local totalWeight = 0

  -- Calculate the total weight
  for _, entry in ipairs(itemsWithWeights) do
      totalWeight = totalWeight + entry.weight
  end

  -- Generate a random number within the total weight range
  local randomValue = math.random() * totalWeight

  -- Iterate through items to find the selected item
  local cumulativeWeight = 0
  for _, entry in ipairs(itemsWithWeights) do
      cumulativeWeight = cumulativeWeight + entry.weight
      if randomValue <= cumulativeWeight then
          return entry.item
      end
  end
end

function PickByWeight(entries)
  local total_weight = 0
  
  for _, entry in ipairs(entries) do
    total_weight = total_weight + entry.weight
  end
  
  local rand_val = GAME.Rand:NextDouble() * total_weight
  local cummul_weight = 0
  for _, entry in ipairs(entries) do
    cummul_weight = cummul_weight + entry.weight
    if rand_val <= cummul_weight then
      return entry.item
    end
  end
end

-- local items = {"Option 1", "Option 2", "Option 3"}
-- local weights = {2, 1, 3} -- Adjust weights as needed

-- local selectedOption = pickWeightedItem(items, weights)
-- print("Selected option:", selectedOption)