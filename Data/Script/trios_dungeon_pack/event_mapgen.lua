require 'trios_dungeon_pack.helpers'
require 'trios_dungeon_pack.beholder'
PresetMultiTeamSpawnerType = luanet.import_type('RogueEssence.LevelGen.PresetMultiTeamSpawner`1')
PlaceRandomMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceRandomMobsStep`1')
MonsterHouseStepType = luanet.import_type('RogueEssence.LevelGen.MonsterHouseStep`1')
ScriptGenStepType = luanet.import_type('RogueEssence.LevelGen.ScriptGenStep`1')

MapEffectStepType = luanet.import_type('RogueEssence.LevelGen.MapEffectStep`1')
MapGenContextType = luanet.import_type('RogueEssence.LevelGen.ListMapGenContext')
EntranceType = luanet.import_type('RogueEssence.LevelGen.MapGenEntrance')

RandomRoomSpawnStepType = luanet.import_type('RogueElements.RandomRoomSpawnStep`2')
PickerSpawnType = luanet.import_type('RogueElements.PickerSpawner`2')
PresetMultiRandType = luanet.import_type('RogueElements.PresetMultiRand`1')
PresetPickerType = luanet.import_type('RogueElements.PresetPicker`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')

StatusEffectType = luanet.import_type('RogueEssence.Dungeon.StatusEffect')

DefaultMapStatusStepType = luanet.import_type('PMDC.LevelGen.DefaultMapStatusStep`1')

MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')
BadStatusStateType = luanet.import_type('PMDC.Dungeon.BadStatusState')
ListType = luanet.import_type('System.Collections.Generic.List`1')
StatType = luanet.import_type('RogueEssence.Data.Stat')


-- [ListCollapse]
-- public StateCollection<UniversalState> UniversalStates;
-- [ListCollapse]
-- public PriorityList<BattleEvent> BeforeTryActions;
-- [ListCollapse]
-- public PriorityList<BattleEvent> BeforeActions;
-- [ListCollapse]
-- public PriorityList<BattleEvent> OnActions;
-- [ListCollapse]
-- public PriorityList<BattleEvent> BeforeExplosions;
-- [ListCollapse]
-- public PriorityList<BattleEvent> BeforeHits;
-- [ListCollapse]
-- public PriorityList<BattleEvent> OnHits;
-- [ListCollapse]
-- public PriorityList<BattleEvent> OnHitTiles;
-- [ListCollapse]
-- public PriorityList<BattleEvent> AfterActions;
-- [ListCollapse]
-- public PriorityList<ElementEffectEvent> ElementEffects;

-- [ListCollapse]
-- public PriorityList<ItemGivenEvent> OnEquips;
-- [ListCollapse]
-- public PriorityList<ItemGivenEvent> OnPickups;

-- [ListCollapse]
-- public PriorityList<StatusGivenEvent> BeforeStatusAdds;
-- [ListCollapse]
-- public PriorityList<StatusGivenEvent> OnStatusAdds;
-- [ListCollapse]
-- public PriorityList<StatusGivenEvent> OnStatusRemoves;

-- [ListCollapse]
-- public PriorityList<MapStatusGivenEvent> OnMapStatusAdds;
-- [ListCollapse]
-- public PriorityList<MapStatusGivenEvent> OnMapStatusRemoves;

-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnMapStarts;

-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnTurnStarts;
-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnTurnEnds;
-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnMapTurnEnds;
-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnWalks;
-- [ListCollapse]
-- public PriorityList<SingleCharEvent> OnDeaths;

-- [ListCollapse]
-- public PriorityList<RefreshEvent> OnRefresh;
-- [ListCollapse]
-- public PriorityList<RefreshEvent> OnMapRefresh;

-- [ListCollapse]
-- public PriorityList<HPChangeEvent> ModifyHPs;
-- [ListCollapse]
-- public PriorityList<HPChangeEvent> RestoreHPs;

-- [ListCollapse]
-- public PriorityList<BattleEvent> InitActionData;

function ZONE_GEN_SCRIPT.AddEnchantmentActiveEffects(zoneContext, context, queue, seed, args)
  local activeEffect = RogueEssence.Data.ActiveEffect()

  beholder.stopObservingAll()

  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:set_active_effects(activeEffect, zoneContext)
  end

  activeEffect.OnDeaths:Add(6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnDeath"))
  activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnMapStarts"))
  activeEffect.OnMapTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnMapTurnEnds"))
  activeEffect.OnTurnEnds:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnTurnEnds"))
  activeEffect.OnPickups:Add(-6, RogueEssence.Dungeon.ItemScriptEvent("EmberfrostOnPickups"))
  activeEffect.BeforeActions:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostBeforeActions"))
  activeEffect.AfterActions:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostAfterActions"))
  activeEffect.OnActions:Add(6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostOnActions"))
  activeEffect.BeforeExplosions:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostBeforeExplosions"))
  activeEffect.BeforeTryActions:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostBeforeTryActions"))
  activeEffect.OnHits:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostOnHits"))
  -- activeEffect.BeforeBeingHits:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostBeforeBeingHits"))
  activeEffect.BeforeHits:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostBeforeHits"))
  activeEffect.BeforeStatusAdds:Add(-6, RogueEssence.Dungeon.StatusScriptEvent("EmberfrostBeforeStatusAdds"))
  activeEffect.OnHitTiles:Add(-6, RogueEssence.Dungeon.BattleScriptEvent("EmberfrostOnHitTiles"))

  activeEffect.OnStatusAdds:Add(-6, RogueEssence.Dungeon.StatusScriptEvent("EmberfrostOnStatusAdds"))
  activeEffect.OnStatusRemoves:Add(-6, RogueEssence.Dungeon.StatusScriptEvent("EmberfrostOnStatusRemoves"))
  activeEffect.OnTurnStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnTurnStarts"))
  activeEffect.OnWalks:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnWalks"))

  -- BeforeHits
  -- activeEffect.OnAfterActions:Add(-6, RogueEssence.Dungeon.ItemScriptEvent("EmberfrostOnAfterActions"))
  
  -- activeEffect.OnPickups:Add(-6, RogueEssence.Dungeon.ItemScriptEvent("MissionItemPickup", '{ Mission = '..missionNum..' }'))

  -- activeEffect.OnDeath:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("EmberfrostOnDeath"))


  -- for SV.EmberFrost.
  -- local status = args.StatusID or "emberfrost_fire_speed_boost"
  -- activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("AddStatusToLeader", Serpent.line({ StatusID = status })))
  local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
  local priority = RogueElements.Priority(-6)
  queue:Enqueue(priority, destNote)
  
end


function ZONE_GEN_SCRIPT.EmberfrostSwitchUp(zoneContext, context, queue, seed, args)

  local interval = 5
  local active_effect = RogueEssence.Data.ActiveEffect()
  local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { active_effect })
  local priority = RogueElements.Priority(-6)

  if ((zoneContext.CurrentID + 1) % interval) == 0 and zoneContext.CurrentID ~= 0  and zoneContext.CurrentID ~= 29 then
    active_effect.OnMapStarts:Add(-5, RogueEssence.Dungeon.SingleCharScriptEvent("AddSwitchSegmentStairs", Serpent.line({ NextSegment = -1, NextID = SV.EmberFrost.CheckpointProgression })))
  end
  queue:Enqueue(priority, destNote)
end


local function CreateShimmeringStatusEvent()
  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Shadow_Force_Hit_Light", 10))
  emitter.LocHeight = 30
  local status_event = PMDC.Dungeon.StatusAnimEvent(emitter, "DUN_Screen_Hit", 10)
  return status_event
end

function ZONE_GEN_SCRIPT.ShimmeringZoneStep(zoneContext, context, queue, seed, args)
  -- 75% chance of shimmering
  local low = 0
  local high = 4 
  local active_effect = RogueEssence.Data.ActiveEffect()
  local is_shimmering = _DATA.Save.Rand:Next(low, high) ~= 0
  local is_beginning = zoneContext.CurrentID < 2
  if (is_shimmering or zoneContext.CurrentID == 2 or zoneContext.CurrentID >= 20) and not is_beginning then
    local SHIMMERING_EVENTS = { 
      {
        effect = function ()
          active_effect.OnActions:Add(-1, PMDC.Dungeon.SureShotEvent())
        end,
        string_key = "MSG_SHIMMERING_EFFECT_PERFECT_ACCURACY"
      },
      {
        effect = function ()
          -- active_effect.OnActions:Add(-1, PMDC.Dungeon.AddRangeEvent(1))
        end,
        string_key = "MSG_SHIMMERING_EFFECT_RANGE"
      },
      {
        effect = function ()
          active_effect.OnActions:Add(-1, PMDC.Dungeon.BoostCriticalEvent(1))
        end,
        string_key = "MSG_SHIMMERING_EFFECT_CRITICAL"
      },
      {
        effect = function ()
          local bad_status_type = luanet.ctype(BadStatusStateType)
          local string_key =  RogueEssence.StringKey("MSG_SHIMMERING_CRYSTAL_PROTECT")
          local status_event = CreateShimmeringStatusEvent()
          active_effect.BeforeStatusAdds:Add(-1, PMDC.Dungeon.StateStatusCheck(bad_status_type, string_key, status_event))
        end,
        string_key = "MSG_SHIMMERING_EFFECT_STATUS"
      },
      {
        effect = function ()
          active_effect.OnActions:Add(-1, PMDC.Dungeon.BoostAdditionalEvent())
        end,
        string_key = "MSG_SHIMMERING_EFFECT_SERENE"
      },
      {
        effect = function ()
          local stats = LUA_ENGINE:MakeGenericType( ListType, { StatType }, { })
          -- Shadow_Force_Hit_Light Screen_Sparkle_RSE, Last_Resort_Back
          local string_key =  RogueEssence.StringKey("MSG_SHIMMERING_CRYSTAL_STAT_DROP")
          local status_event = CreateShimmeringStatusEvent()
          active_effect.BeforeStatusAdds:Add(0, PMDC.Dungeon.StatChangeCheck(stats, string_key, true, false, false, status_event))
        end,
        string_key = "MSG_SHIMMERING_EFFECT_CLEAR_BODY"
      },
     }
   
    local index = _DATA.Save.Rand:Next(#SHIMMERING_EVENTS)
    local shimmer_selection = "shimmering"
    if index + 1 > 1 then
      shimmer_selection = "shimmering" .. (index + 1)
    end

    local shimmering_status = LUA_ENGINE:MakeGenericType(DefaultMapStatusStepType, { MapGenContextType }, { "default_weather", shimmer_selection })
    local priority = RogueElements.Priority(-6)
    queue:Enqueue(priority, shimmering_status)
    local ev = SHIMMERING_EVENTS[index + 1]
    ev.effect()
    active_effect.OnMapStarts:Add(1, RogueEssence.Dungeon.SingleCharScriptEvent("LogShimmeringEvent", Serpent.line({ StringKey = ev.string_key })))
  end

  local dest_note = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { active_effect })
  local priority = RogueElements.Priority(1)
  active_effect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("RevealGems", Serpent.line({})))
  queue:Enqueue(priority, dest_note)
end

function ZONE_GEN_SCRIPT.SpawnStoryNpc(zoneContext, context, queue, seed, args)

  local SPAWNS

  if GAME:InRogueMode() then
    SPAWNS = {
      {
        Species = "staryu",
        -- SpawnFeatures = {},
        Floor = 10,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK10")),
        Statuses = {},
        Level = 50,
        Emote = 0
      },
      {
        Species = "staryu",
        -- SpawnFeatures = {},
        Floor = 20,
        Dialogue = RogueEssence.Dungeon.BattleScriptEvent("WishmakerGemCountDialogue"),
        Statuses = {},
        Level = 50,
        Emote = 0
      },
    }
  else 
    SPAWNS =  { 
      {
        Species = "oshawott",
        -- SpawnFeatures = {},
        Floor = 3,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK1")),
  
        Statuses = {},
        Level = 14,
        Emote = 0
      },
      {
        Species = "zigzagoon",
        -- SpawnFeatures = {},
        Floor = 6,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK2")),
        Statuses = {},
        Level = 16,
        Emote = 0
      },
      {
        Species = "smeargle",
        -- SpawnFeatures = {},
        Floor = 8,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK8")),
        Statuses = {},
        Level = 20,
        Emote = 0
      },
      {
        Species = "zangoose",
        -- SpawnFeatures = {},
        Floor = 10,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK3")),
        Statuses = {
          "crystal_defense",
          "crystal_attack"
        },
        Level = 25,
        Emote = 0
      },
      {
        Species = "ribombee",
        -- SpawnFeatures = {},
        Floor = 11,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK4")),
        Statuses = {
          "crystal_heal",
          "no_heal"
        },
        Level = 27,
        Emote = 2
      },
      {
        Species = "quilava",
        -- SpawnFeatures = {},
        Floor = 12,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK5")),
        Statuses = {},
        Level = 28,
        Emote = 0
      },
      {
        Species = "dragonair",
        -- SpawnFeatures = {},
        Floor = 13,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK6")),
        Statuses = {},
        Level = 30,
        Emote = 0
      },
      {
        Species = "staryu",
        -- SpawnFeatures = {},
        Floor = 16,
        Dialogue = RogueEssence.Dungeon.BattleScriptEvent("WishmakerGemCountDialogue"),
        Statuses = {},
        Level = 50,
        Emote = 0
      },
      {
        Species = "xatu",
        -- SpawnFeatures = {},
        Floor = 20,
        Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK9")),
        Statuses = {},
        Level = 55,
        Emote = 0
      },
    }
  end
  -- 
  -- local SPAWNS =
  -- local post_mob = RogueEssence.LevelGen.MobSpawn()
  -- print(tostring(zoneContext.CurrentID))
  local curr_floor = zoneContext.CurrentID
  for _, entry in ipairs(SPAWNS) do
    if curr_floor + 1 == entry.Floor then
      local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
      specificTeam.Explorer = true
      local post_mob = RogueEssence.LevelGen.MobSpawn()
      	  
      local mon = _DATA:GetMonster(entry.Species)
      local form = mon.Forms[0]
      --set the correct possible gender
      local gender = form:RollGender(_DATA.Save.Rand)
      
      post_mob.BaseForm = RogueEssence.Dungeon.MonsterID(entry.Species, 0, "normal", gender)
      post_mob.Level = RogueElements.RandRange(entry.Level)
      post_mob.Tactic = "slow_patrol_land"
      local dialogue = entry.Dialogue

      -- local dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey(entry.Dialogue))
      if entry.Species ~= "staryu" then
        dialogue.Emote = RogueEssence.Content.EmoteStyle(entry.Emote)
      end

      post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
      post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable(Serpent.line({ NPC = true })))
      for _, status in ipairs(entry.Statuses) do
        local Status = LUA_ENGINE:MakeGenericType(SpawnListType, { StatusEffectType }, { })
        Status:Add(RogueEssence.Dungeon.StatusEffect(status), 10)
        local mob_spawn_status = RogueEssence.LevelGen.MobSpawnStatus()
        mob_spawn_status.Statuses = Status
        post_mob.SpawnFeatures:Add(mob_spawn_status)
      end
      specificTeam.Spawns:Add(post_mob)
      local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
      picker.Spawns:Add(specificTeam)
      local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceRandomMobsStepType, { MapGenContextType }, { picker })
      mobPlacement.Ally = true
      mobPlacement.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
      mobPlacement.ClumpFactor = 20
      -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
      local priority = RogueElements.Priority(5, 2, 1)
      queue:Enqueue(priority, mobPlacement)
    end
  end
end

