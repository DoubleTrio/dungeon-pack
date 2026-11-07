require 'origin.common'
local checkpoint = require 'trios_dungeon_pack.emberfrost.checkpoint'

-- Package name
local rocky_checkpoint = {}

-------------------------
-- Map Callbacks
-------------------------------
---rocky_checkpoint.Init(map)
-- Engine callback function

function rocky_checkpoint.Init(map)
  checkpoint.OnCheckpointArrive(2)
  checkpoint.SpawnCheckpointWalls()
  GROUND:AddMapStatus("sandstorm")
end

---rocky_checkpoint.Enter(map)
-- Engine callback function
function rocky_checkpoint.Enter(map)
  checkpoint.ShowTitle()
  GAME:FadeIn(20)
end

---rocky_checkpoint.Exit(map)
-- Engine callback function
function rocky_checkpoint.Exit(map)

end

---rocky_checkpoint.Update(map)
-- Engine callback function
function rocky_checkpoint.Update(map)

end

---rocky_checkpoint.GameSave(map)
-- Engine callback function
function rocky_checkpoint.GameSave(map)

end

---rocky_checkpoint.GameLoad(map)
-- Engine callback function
function rocky_checkpoint.GameLoad(map)
  checkpoint.SpawnCheckpointWalls()
  GAME:FadeIn(20)
end

function rocky_checkpoint.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.ProceedToNextSection()
end

function rocky_checkpoint.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  checkpoint.AskReturn()
end

function rocky_checkpoint.Enchantment_Chest_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ChestInteraction(obj, activator)
end

-------------------------------
-- Entities Callbacks
-------------------------------

function rocky_checkpoint.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function rocky_checkpoint.Teammate2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function rocky_checkpoint.Teammate3_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  COMMON.GroundInteract(activator, chara)
end

function rocky_checkpoint.Guest1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function rocky_checkpoint.Guest2_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.GetGroundDialogueForGuest(chara, activator)
end

function rocky_checkpoint.Shopkeeper_Action(obj, activator)
  DEBUG.EnableDbgCoro()
  checkpoint.ShopkeeperDialogue(obj, activator)
end


function rocky_checkpoint.EnemyInvisWall_Action(obj, activator)
  checkpoint.InvisibleWallInteraction(obj, activator)
end

  --  [Serializable]
  --   public class OpenSelfEvent : SingleCharEvent
  --   {
  --       public BattleFX Anim;

  --       public bool PreOpen;

  --       public bool Fanfare;

  --       public OpenSelfEvent()
  --       {
  --           Anim = new BattleFX();
  --       }
  --       public OpenSelfEvent(BattleFX anim, bool preOpen, bool fanfare)
  --       {
  --           Anim = anim;
  --           PreOpen = preOpen;
  --           Fanfare = fanfare;
  --       }
  --       public OpenSelfEvent(OpenSelfEvent other)
  --       {
  --           Anim = other.Anim;
  --           PreOpen = other.PreOpen;
  --           Fanfare = other.Fanfare;
  --       }
  --       public override GameEvent Clone() { return new OpenSelfEvent(this); }

  --       public override IEnumerator<YieldInstruction> Apply(GameEventOwner owner, Character ownerChar, SingleCharContext context)
  --       {
  --           EffectTile effectTile = (EffectTile)owner;

  --           CharAnimation standAnim = new CharAnimIdle(context.User.CharLoc, context.User.CharDir);
  --           standAnim.MajorAnim = true;
  --           yield return CoroutineManager.Instance.StartCoroutine(context.User.StartAnim(standAnim));

  --           //remove all specified tiles; both the effect and the terrain, if there is one
  --           Loc baseLoc = effectTile.TileLoc;
  --           Tile tile = ZoneManager.Instance.CurrentMap.Tiles[baseLoc.X][baseLoc.Y];
  --           if (PreOpen)
  --           {
  --               if (tile.Effect == owner)
  --                   tile.Effect = new EffectTile(tile.Effect.TileLoc);
  --           }

  --           yield return CoroutineManager.Instance.StartCoroutine(DungeonScene.Instance.ProcessBattleFX(baseLoc, baseLoc, Dir8.Down, Anim));
  --           {
  --               if (!PreOpen)
  --                   tile.Effect = new EffectTile(tile.Effect.TileLoc);
  --               tile.Data = new TerrainTile(DataManager.Instance.GenFloor);
  --               int distance = 0;
  --               Loc startLoc = baseLoc - new Loc(distance + 2);
  --               Loc sizeLoc = new Loc((distance + 2) * 2 + 1);
  --               ZoneManager.Instance.CurrentMap.MapModified(startLoc, sizeLoc);
  --           }


  --           yield return new WaitForFrames(GameManager.Instance.ModifyBattleSpeed(60));

  --           //say, "The vault doors opened!"/with fanfare
  --           DungeonScene.Instance.LogMsg(Text.FormatGrammar(new StringKey("MSG_LOCK_OPEN").ToLocal()));
  --           if (Fanfare)
  --           {
  --               GameManager.Instance.Fanfare("Fanfare/Treasure");
  --               yield return new WaitForFrames(GameManager.Instance.ModifyBattleSpeed(90));
  --           }
  --       }

  --   }


  --   [Serializable]
  --   public class OpenOtherPassageEvent : SingleCharEvent
  --   {
  --       [JsonConverter(typeof(MapStatusConverter))]
  --       [DataType(0, DataManager.DataType.MapStatus, false)]
  --       public string TimeLimitStatus;
  --       public FiniteEmitter Emitter;
  --       public string WarningBGM;
  --       public StringKey Warning;
  --       public string WarningSE;

  --       public OpenOtherPassageEvent()
  --       {
  --           TimeLimitStatus = "";
  --           Emitter = new EmptyFiniteEmitter();
  --           WarningBGM = "";
  --           WarningSE = "";
  --       }

  --       protected OpenOtherPassageEvent(OpenOtherPassageEvent other)
  --       {
  --           TimeLimitStatus = other.TimeLimitStatus;
  --           Emitter = other.Emitter;
  --           WarningBGM = other.WarningBGM;
  --           Warning = other.Warning;
  --           WarningSE = other.WarningSE;
  --       }
  --       public override GameEvent Clone() { return new OpenOtherPassageEvent(this); }

  --       public override IEnumerator<YieldInstruction> Apply(GameEventOwner owner, Character ownerChar, SingleCharContext context)
  --       {
  --           EffectTile effectTile = (EffectTile)owner;
  --           //unlock the other doors
  --           //play the sound
  --           TileListState tilesState = effectTile.TileStates.GetWithDefault<TileListState>();
  --           if (tilesState != null)
  --           {
  --               List<Loc> locs = tilesState.Tiles;
  --               if (locs.Count > 0)
  --               {
  --                   GameManager.Instance.BattleSE("DUN_Open_Chamber");
  --                   //remove the tile, and create vfx for each one
  --                   foreach (Loc loc in locs)
  --                   {
  --                       Tile exTile = ZoneManager.Instance.CurrentMap.GetTile(loc);
  --                       exTile.Effect = new EffectTile(exTile.Effect.TileLoc);

  --                       SingleEmitter altEmitter = new SingleEmitter(new AnimData("Vault_Open", 3));
  --                       altEmitter.SetupEmit(loc * GraphicsManager.TileSize + new Loc(GraphicsManager.TileSize / 2), loc * GraphicsManager.TileSize + new Loc(GraphicsManager.TileSize / 2), Dir8.Down);
  --                       DungeonScene.Instance.CreateAnim(altEmitter, DrawLayer.NoDraw);
  --                   }
  --                   yield return new WaitForFrames(GameManager.Instance.ModifyBattleSpeed(30));

  --                   foreach (Loc loc in locs)
  --                   {
  --                       Tile exTile = ZoneManager.Instance.CurrentMap.GetTile(loc);
  --                       {
  --                           exTile.Data = new TerrainTile(DataManager.Instance.GenFloor);
  --                           int distance = 0;
  --                           Loc startLoc = exTile.Effect.TileLoc - new Loc(distance + 2);
  --                           Loc sizeLoc = new Loc((distance + 2) * 2 + 1);
  --                           ZoneManager.Instance.CurrentMap.MapModified(startLoc, sizeLoc);
  --                       }

  --                   }

  --                   //mention the other doors
  --                   DungeonScene.Instance.LogMsg(Text.FormatGrammar(new StringKey("MSG_LOCK_OPEN_FLOOR").ToLocal()));
  --               }
  --           }

  --           DangerState danger;
  --           if (!effectTile.TileStates.TryGet<DangerState>(out danger))
  --               yield break;

  --           if (danger.Danger)
  --           {

  --               bool aboveTimeLimit = true;
  --               MapStatus timeLimit;
  --               if (ZoneManager.Instance.CurrentMap.Status.TryGetValue(TimeLimitStatus, out timeLimit))
  --               {
  --                   if (timeLimit.StatusStates.GetWithDefault<MapCountDownState>().Counter <= TimeLimitEvent.WARN_1)
  --                       aboveTimeLimit = false;
  --               }

  --               if (aboveTimeLimit)
  --               {
  --                   //cut out music
  --                   //fanfare wind blowing
  --                   //play a sudden gust of wind

  --                   GameManager.Instance.BGM("", true);
  --                   yield return new WaitForFrames(GameManager.Instance.ModifyBattleSpeed(90) + 30);



  --                   DungeonScene.Instance.LogMsg(Text.FormatGrammar(Warning.ToLocal()));

  --                   FiniteEmitter endEmitter = (FiniteEmitter)Emitter.Clone();
  --                   endEmitter.SetupEmit(DungeonScene.Instance.GetFocusedMapLoc(), DungeonScene.Instance.GetFocusedMapLoc(), Dir8.None);
  --                   DungeonScene.Instance.CreateAnim(endEmitter, DrawLayer.NoDraw);

  --                   GameManager.Instance.Fanfare("Battle/" + WarningSE);
  --                   yield return new WaitForFrames(180);
  --                   GameManager.Instance.BGM(WarningBGM, true);


  --                   //start timer

  --                   MapStatus status = new MapStatus(TimeLimitStatus);
  --                   status.LoadFromData();
  --                   MapCountDownState timeState = status.StatusStates.GetWithDefault<MapCountDownState>();
  --                   timeState.Counter = TimeLimitEvent.WARN_1;
  --                   status.Hidden = false;
  --                   yield return CoroutineManager.Instance.StartCoroutine(DungeonScene.Instance.AddMapStatus(status));
  --               }
  --               else
  --                   GameManager.Instance.BGM(WarningBGM, true);
  --           }
  --       }

  --   }

return rocky_checkpoint
