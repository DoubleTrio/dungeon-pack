ZONE_GEN_SCRIPT = {}

PresetMultiTeamSpawnerType = luanet.import_type('RogueEssence.LevelGen.PresetMultiTeamSpawner`1')
PlaceRandomMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceRandomMobsStep`1')
PlaceEntranceMobsStepType = luanet.import_type('RogueEssence.LevelGen.PlaceEntranceMobsStep`2')
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

local function CreateShimmeringStatusEvent()
  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Shadow_Force_Hit_Light", 10))
  emitter.LocHeight = 30
  local status_event = PMDC.Dungeon.StatusAnimEvent(emitter, "DUN_Screen_Hit", 10)
  return status_event
end

function ZONE_GEN_SCRIPT.ShimmeringZoneStep(zoneContext, context, queue, seed, args)
  
  SV.Wishmaker = {}
  SV.Wishmaker.TotalWishesPerFloor = 2
  -- 75% chance of shimmering
  local low = 0
  local high = 4 
  local active_effect = RogueEssence.Data.ActiveEffect()
  local is_shimmering = _DATA.Save.Rand:Next(low, high) ~= 0
  -- print(tostring( GAME:GetCurrentFloor()).. "HERE")
  -- print(tostring(zoneContext))
  -- print(tostring(DUNGEON:DungeonCurrentFloor()))
  local is_beginning = zoneContext.CurrentID < 2
  -- print(GAME:GetCurrentFloor())
  if (is_shimmering or zoneContext.CurrentID == 2) and not is_beginning then
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
  
    local dest_note = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { active_effect })
    local priority = RogueElements.Priority(1)
    queue:Enqueue(priority, dest_note)
  end
end

function ZONE_GEN_SCRIPT.SpawnStoryNpc(zoneContext, context, queue, seed, args)
  if GAME:InRogueMode() then
    return
  end
  
  local SPAWNS = { 
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
      Level = 18,
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
      Level = 23,
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
      Level = 25,
      Emote = 2
    },
    {
      Species = "quilava",
      -- SpawnFeatures = {},
      Floor = 12,
      Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK5")),
      Statuses = {},
      Level = 23,
      Emote = 0
    },
    {
      Species = "dragonair",
      -- SpawnFeatures = {},
      Floor = 17,
      Dialogue = PMDC.Dungeon.NpcDialogueBattleEvent(RogueEssence.StringKey("WISHMAKER_NPC_TALK6")),
      Statuses = {},
      Level = 35,
      Emote = 0
    },
    {
      Species = "staryu",
      -- SpawnFeatures = {},
      Floor = 19,
      Dialogue = RogueEssence.Dungeon.BattleScriptEvent("WishmakerGemCountDialogue"),
      Statuses = {},
      Level = 50,
      Emote = 0
    },
  }
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
      -- dialogue.Emote = RogueEssence.Content.EmoteStyle(entry.Emote)

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

function ZONE_GEN_SCRIPT.SpawnMissionNpcFromSV(zoneContext, context, queue, seed, args)
  -- choose a the floor to spawn it on
  local destinationFloor = false
  local outlawFloor = false
  local outlawSilent = false
  for name, mission in pairs(SV.missions.Missions) do
    if mission.Complete == COMMON.MISSION_INCOMPLETE and zoneContext.CurrentZone == mission.DestZone
	  and zoneContext.CurrentSegment == mission.DestSegment and zoneContext.CurrentID == mission.DestFloor then
      local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
      specificTeam.Explorer = true
      local post_mob = RogueEssence.LevelGen.MobSpawn()
      post_mob.BaseForm = mission.TargetSpecies
      if mission.Type == COMMON.MISSION_TYPE_OUTLAW or mission.Type == COMMON.MISSION_TYPE_OUTLAW_HOUSE or mission.Type == COMMON.MISSION_TYPE_OUTLAW_DISGUISE then -- outlaw
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_DISGUISE then
          post_mob.Tactic = "slow_patrol"
        else
          post_mob.Tactic = "boss"
        end
        post_mob.Level = RogueElements.RandRange(_ZONE.CurrentZone.Level + 5)
        post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable(Serpent.line({ Mission = name })))
        local boost = PMDC.LevelGen.MobSpawnBoost()
        boost.MaxHPBonus = _ZONE.CurrentZone.Level + 20
        boost.DefBonus = _ZONE.CurrentZone.Level // 2
        boost.SpDefBonus = _ZONE.CurrentZone.Level // 2
        boost.SpeedBonus = _ZONE.CurrentZone.Level // 2
        post_mob.SpawnFeatures:Add(boost)
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_DISGUISE then
          local spawn_status = RogueEssence.LevelGen.MobSpawnStatus()
          local status_effect = RogueEssence.Dungeon.StatusEffect("illusion")
          status_effect.StatusStates:Set(PMDC.Dungeon.MonsterIDState(mission.DisguiseSpecies))
          spawn_status.Statuses:Add(status_effect, 10)
          post_mob.SpawnFeatures:Add(spawn_status)
          
          local spawn_interact = RogueEssence.LevelGen.MobSpawnStatus()
          local status_interact = RogueEssence.Dungeon.StatusEffect("attack_response")
          status_interact.StatusStates:Set(RogueEssence.Dungeon.ScriptCallState(mission.DisguiseHit, "{}"))
          spawn_interact.Statuses:Add(status_interact, 10)
          post_mob.SpawnFeatures:Add(spawn_interact)
          
          post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(RogueEssence.Dungeon.BattleScriptEvent(mission.DisguiseTalk)))
        end
        specificTeam.Spawns:Add(post_mob)
        local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
        picker.Spawns:Add(specificTeam)
        local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceEntranceMobsStepType, { MapGenContextType, EntranceType }, { picker })
		
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_DISGUISE then
          mobPlacement.Ally = true
        end
        -- Priority 5.2.1 is for NPC spawning in PMDO, but any dev can choose to roll with their own standard of priority.
        local priority = RogueElements.Priority(5, 2, 1)
        queue:Enqueue(priority, mobPlacement)
          PrintInfo("Done")
		
        outlawFloor = true
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_DISGUISE then
            outlawSilent = true
        end
		
        if mission.Type == COMMON.MISSION_TYPE_OUTLAW_HOUSE then
          --add house trigger
              local activeEffect = RogueEssence.Data.ActiveEffect()
              activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("OutlawHouse", Serpent.line({ Mission = name})))
            local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
            local priority = RogueElements.Priority(-6, 1)
            queue:Enqueue(priority, destNote)
        end
      elseif mission.Type == COMMON.MISSION_TYPE_LOST_ITEM then
	    local has_item = false
	    
		local item_slot = GAME:FindPlayerItem(mission.TargetItem.ID, true, true)
		if not item_slot:IsValid() then
			if GAME:GetPlayerStorageItemCount(mission.TargetItem.ID) > 0 then
			  has_item = true
			end
		else
			has_item = true
		end
		
		if not has_item then
		
		local lost_item = RogueEssence.Dungeon.MapItem(mission.TargetItem)
		local preset_picker = LUA_ENGINE:MakeGenericType(PresetPickerType, { MapItemType }, { lost_item })
		local multi_preset_picker = LUA_ENGINE:MakeGenericType(PresetMultiRandType, { MapItemType }, { preset_picker })
		local picker_spawner = LUA_ENGINE:MakeGenericType(PickerSpawnType, {  MapGenContextType, MapItemType }, { multi_preset_picker })
		local random_room_spawn = LUA_ENGINE:MakeGenericType(RandomRoomSpawnStepType, { MapGenContextType, MapItemType }, { })
		random_room_spawn.Spawn = picker_spawner
		random_room_spawn.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
		local priority = RogueElements.Priority(5, 2, 1)
		queue:Enqueue(priority, random_room_spawn)
		
        if not mission.FloorUnknown then
          destinationFloor = true
        end
		
		end
	  else
        post_mob.Tactic = "slow_patrol"
        if mission.Type == COMMON.MISSION_TYPE_RESCUE then -- rescue
            post_mob.Level = RogueElements.RandRange(_ZONE.CurrentZone.Level - 5)
          local dialogue = RogueEssence.Dungeon.BattleScriptEvent("SidequestRescueReached")
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable(Serpent.line({ Mission = name })))
          elseif mission.Type == COMMON.MISSION_TYPE_ESCORT then -- escort
            post_mob.Level = RogueElements.RandRange(_ZONE.CurrentZone.Level - 5)
          local dialogue = RogueEssence.Dungeon.BattleScriptEvent("SidequestEscortReached")
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable(Serpent.line({ Mission = name })))
          elseif mission.Type == COMMON.MISSION_TYPE_ESCORT_OUT then -- escort
            post_mob.Level = RogueElements.RandRange(_ZONE.CurrentZone.Level // 2)
          local dialogue = RogueEssence.Dungeon.BattleScriptEvent("SidequestEscortOutReached", Serpent.line(mission.EscortTable))
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnMovesOff(0))
            post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnLuaTable(Serpent.line({ Escort = name })))
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
        
        if not mission.FloorUnknown then
          destinationFloor = true
        end
      end
    end
  end
  
  if destinationFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("DestinationFloor"))
    local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
    local priority = RogueElements.Priority(-6)
    queue:Enqueue(priority, destNote)
  end
  if outlawFloor then
    -- add destination floor notification
    local activeEffect = RogueEssence.Data.ActiveEffect()
    activeEffect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("SidequestOutlawFloor", Serpent.line({ Silent = outlawSilent })))
	local destNote = LUA_ENGINE:MakeGenericType( MapEffectStepType, { MapGenContextType }, { activeEffect })
	local priority = RogueElements.Priority(-6)
	queue:Enqueue(priority, destNote)
  end
end


FLOOR_GEN_SCRIPT = {}


PresetPickerType = luanet.import_type('RogueElements.PresetPicker`1')
EffectTileType = luanet.import_type('RogueEssence.Dungeon.EffectTile')
TempTileStepType = luanet.import_type('PMDC.LevelGen.TempTileStep`1')

function FLOOR_GEN_SCRIPT.Mysteriosity(map, args)
  local total_chance = 0
  if SV.magnagate.Cards > 0 then
    total_chance = args.BaseChance + (SV.magnagate.Cards - 1) * 2
  end
  if map.Rand:Next(100) < total_chance then
	local secretTile = RogueEssence.Dungeon.EffectTile("tile_mystery", true)
	secretTile.TileStates:Set(PMDC.Dungeon.DestState(RogueEssence.Dungeon.SegLoc(args.SegDiff, 0), true))
	local picker = LUA_ENGINE:MakeGenericType( PresetPickerType, { EffectTileType }, { secretTile })
	local trapStep = LUA_ENGINE:MakeGenericType( TempTileStepType, { MapGenContextType }, { picker, "mysterious_distortion" })
	trapStep.TileFilters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
	trapStep.TileFilters:Add(RogueElements.RoomFilterComponent(true, PMDC.LevelGen.BossRoom()))
	trapStep:Apply(map)
  end
  
end


function FLOOR_GEN_SCRIPT.SpawnRandomTutor(map, args)
  
  if SV.Experimental ~= true then
    return
  end
  
  local valid_moves = {}
  --iterate through all tutor moves
  for move_idx, skill in pairs(COMMON.TUTOR) do
	--Were they already encountered in this adventure?  skip
	if SV.adventure.Tutors[move_idx] ~= nil then
	  goto continue
	end
	--do they not fall in range of cost?  skip
	if skill.Cost < args.MinCost or skill.Cost >= args.MaxCost then
	  goto continue
	end
	--is the tutor species valid?  no?  skip
	if skill.TutorSpecies == "" then
	  goto continue
	end
	--can anyone on the current team learn the move? no? skip
	--iterate the team
	local can_learn = false
	for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
	  local team_id = member.BaseForm
	  local mon = _DATA:GetMonster(team_id.Species)
	  local form = mon.Forms[team_id.Form]
	  if not skill.Special then
		--iterate the shared skills
	    for learnable in luanet.each(form.SharedSkills) do
		  if learnable.Skill == move_idx then
		    can_learn = true
			break
		  end
		end
	  else
		--iterate the secret skills
	    for learnable in luanet.each(form.SecretSkills) do
		  if learnable.Skill == move_idx then
		    can_learn = true
			break
		  end
		end
	  end
	  
	  if can_learn then
	    break
	  end
	end
	if not can_learn then
	  goto continue
	end
	
	--do they not match the types provided?  skip
	local has_element = false
	local skill_data = _DATA:GetSkill(move_idx)
	for _, element_id in pairs(args.Elements) do
	  --check to see if the skill is of the correct element
	  if skill_data.Data.Element == element_id then
	    has_element = true
		break
	  end
	end
	if not has_element then
	  goto continue
	end
	
	table.insert(valid_moves, move_idx)
	
	--lua doesnt support continue keyword so we have to make do with goto
	::continue::
  end
  

  


  if #valid_moves > 0 then
	  --choose a random move out of the valid ones
	  local rand_idx = map.Rand:Next(#valid_moves) + 1
	  --set the tutor id
	  local tutor_move = valid_moves[rand_idx]
	  
	  local tutor_species = COMMON.TUTOR[tutor_move].TutorSpecies
	  local tutor_form = COMMON.TUTOR[tutor_move].TutorForm
	  
	  local mon = _DATA:GetMonster(tutor_species)
	  local form = mon.Forms[tutor_form]
	  --set the correct possible gender
	  local tutor_gender = form:RollGender(map.Rand)
	  local tutor_id = RogueEssence.Dungeon.MonsterID(tutor_species, tutor_form, "normal", tutor_gender)

  
	  local specificTeam = RogueEssence.LevelGen.SpecificTeamSpawner()
	  specificTeam.Explorer = true
	  local post_mob = RogueEssence.LevelGen.MobSpawn()
	  post_mob.BaseForm = tutor_id
	  post_mob.SpecifiedSkills:Add(tutor_move)
	  
	  post_mob.Tactic = "slow_patrol"
	  post_mob.Level = RogueElements.RandRange(_ZONE.CurrentZone.Level + 5)
	  local dialogue = RogueEssence.Dungeon.BattleScriptEvent("TutorTalk")
	  post_mob.SpawnFeatures:Add(PMDC.LevelGen.MobSpawnInteractable(dialogue))
	  
	  specificTeam.Spawns:Add(post_mob)
	  local picker = LUA_ENGINE:MakeGenericType(PresetMultiTeamSpawnerType, { MapGenContextType }, { })
	  picker.Spawns:Add(specificTeam)
	  local mobPlacement = LUA_ENGINE:MakeGenericType(PlaceRandomMobsStepType, { MapGenContextType }, { picker })
	  mobPlacement.Ally = true
	  mobPlacement.Filters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
	  mobPlacement.ClumpFactor = 20
	  mobPlacement:Apply(map)
	  
	  SV.adventure.Tutors[tutor_move] = true
  end
end

RoomGenBlockedType = luanet.import_type('RogueElements.RoomGenBlocked`1')
RoomGenEvoType = luanet.import_type('PMDC.LevelGen.RoomGenEvo`1')

function FLOOR_GEN_SCRIPT.TestGrid(map, args)
  PrintInfo("Test Grid")
  
  -- this step operates on the grid floor of the map, assuming it has one
  -- free-form floors do not have a grid
  local floorPlan = map.GridPlan
  -- these changes will only affect the map if they are done after the grid is created (after priority -5)
  -- these changes will only affect the map if they are done before the grid is drawn to the floor plan (before priority -3)
  
  
  -- set the brush for all vertical hallways on the right half to be blocked rooms 
  for xx = floorPlan.GridWidth / 2, floorPlan.GridWidth - 1, 1 do
    for yy = 0, floorPlan.GridHeight - 2, 1 do
	  local hall = floorPlan:GetHall(RogueElements.LocRay4(RogueElements.Loc(xx, yy), Dir4.Down))
	  -- only modify existing halls
	  if hall ~= nil then
	    local hallGen = LUA_ENGINE:MakeGenericType(RoomGenBlockedType, { map:GetType() }, {  })
	    -- no need to change width and height since they will be ordered by the floors
	    hallGen.BlockWidth = RogueElements.RandRange(2)
	    hallGen.BlockHeight = RogueElements.RandRange(10)
		hallGen.BlockTerrain = RogueEssence.Dungeon.Tile("water")
		floorPlan:SetHall(RogueElements.LocRay4(RogueElements.Loc(xx, yy), Dir4.Down), hallGen, hall.Components)
	  end
	end
  end
  
  -- turns all rooms on the left side into evo rooms
  for yy = 0, floorPlan.GridHeight - 1, 1 do
	local room = floorPlan:GetRoomPlan(RogueElements.Loc(0, yy))
	if room ~= nil then
	  local roomGen = LUA_ENGINE:MakeGenericType(RoomGenEvoType, { map:GetType() }, {  })
	  room.RoomGen = roomGen
	end
  end
  
end

function FLOOR_GEN_SCRIPT.TestRooms(map, args)
  PrintInfo("Test Floor")
  
  --this step just finds all hallways and rooms and prints out their areas
  --since this step does not alter the floor, it only needs to take place after the floor plan is created (after priority -3)
  
  local floorPlan = map.RoomPlan
  
  -- coordinates are offset by the start amount.  Add them to get the true amount
  local offset = floorPlan.Start
  
  for ii = 0, floorPlan.RoomCount - 1, 1 do
    local room = floorPlan:GetRoom(ii)
	PrintInfo("Room " .. ii .. ": X".. room.Draw.Start.X + offset.X .. " Y" .. room.Draw.Start.Y + offset.Y .. " W" .. room.Draw.Size.X .. " H" .. room.Draw.Size.Y  )
  end
  
  for ii = 0, floorPlan.HallCount - 1, 1 do
    local hall = floorPlan:GetHall(ii)
	PrintInfo("Hall " .. ii .. ": X".. hall.Draw.Start.X + offset.X .. " Y" .. hall.Draw.Start.Y + offset.Y .. " W" .. hall.Draw.Size.X .. " H" .. hall.Draw.Size.Y  )
  end
end
  
function FLOOR_GEN_SCRIPT.Test(map, args)
  PrintInfo("Test Tile")
  
  --A demo of various tile operations possible with scripting
  --This step should be added after everything else. (prefer 7)
  
  --Set the top-left corner to room tile. Note that unbreakable blocks are left untouched.
  for xx = 0, map.Width / 2, 1 do
    for yy = 0, map.Height / 2, 1 do
      map:TrySetTile(RogueElements.Loc(xx, yy), map.RoomTerrain)
    end  
  end
  
  --Set the center of the corner to Block tile
  for xx = map.Width / 4 - 1, map.Width / 4 + 1, 1 do
    for yy = map.Height / 4 - 1, map.Height / 4 + 1, 1 do
      map:TrySetTile(RogueElements.Loc(xx, yy), map.WallTerrain)
    end
  end
  
  --set a single coordinate to unbreakable
  map:TrySetTile(RogueElements.Loc(map.Width / 2 - 1, map.Height / 2 - 1), map.UnbreakableTerrain)
  
  --Set the bottom-right corner to water, but only if the existing tiles aren't ground.  MapGenContext has built-in members for Ground, Wall, and Impassable, but the rest must be specified.
  for xx = map.Width / 2, map.Width - 1, 1 do
    for yy = map.Height / 2, map.Height - 1, 1 do
	  local loc = RogueElements.Loc(xx, yy)
	  if not map:GetTile(loc):TileEquivalent(map.RoomTerrain) then
        map:TrySetTile(loc, RogueEssence.Dungeon.Tile("water"))
	  end
    end  
  end
  
  --Set the center of the corner to Block tile of a custom tileset.
  for xx = map.Width * 3 / 4 - 1, map.Width * 3 / 4 + 1, 1 do
    for yy = map.Height * 3 / 4 - 1, map.Height * 3 / 4 + 1, 1 do
	  local customTerrain = RogueEssence.Dungeon.Tile("wall", true) -- set StableTex to true, which prevents the map's autotexturing
	  customTerrain.Data.TileTex = RogueEssence.Dungeon.AutoTile("tiny_woods_wall")
      map:TrySetTile(RogueElements.Loc(xx, yy), customTerrain)
    end
  end
  
  --Place a trap on 2,2.  Slumber trap, revealed.
  --map:PlaceItem(RogueElements.Loc(2, 2), RogueEssence.Dungeon.EffectTile("trap_slumber", true))
  local trap_tile = map:GetTile(RogueElements.Loc(2, 2))
  trap_tile.Effect = RogueEssence.Dungeon.EffectTile("trap_slumber", true)
  
  --Place item on 3,2.  Banana, sticky
  --map:PlaceItem(RogueElements.Loc(3, 2), RogueEssence.Dungeon.MapItem(6))
  local new_item = RogueEssence.Dungeon.MapItem(6)
  new_item.Cursed = true
  new_item.TileLoc = RogueElements.Loc(3, 2)
  map.Items:Add(new_item)
  
  --Place item on 3,3.  Random amount of G between 50 and 100
  --map:PlaceItem(RogueElements.Loc(3, 3), RogueEssence.Dungeon.MapItem(true, 100))
  new_item = RogueEssence.Dungeon.MapItem.CreateMoney(map.Rand:Next(50, 101)) -- you must use the map.Rand, or else seeds wont be consistent
  new_item.TileLoc = RogueElements.Loc(3, 3)
  map.Items:Add(new_item)
  
  --Place enemies on 4,4, 4,5, together in a team, with AI of Normal Wander
  local new_team = RogueEssence.Dungeon.MonsterTeam()
  
  local mob_data = RogueEssence.Dungeon.CharData()
  mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("mewtwo", 0, "normal", Gender.Male)
  mob_data.Level = 20;
  mob_data.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill("pound")
  mob_data.BaseSkills[1] = RogueEssence.Dungeon.SlotSkill("fire_punch")
  mob_data.BaseSkills[2] = RogueEssence.Dungeon.SlotSkill("ice_punch")
  mob_data.BaseSkills[3] = RogueEssence.Dungeon.SlotSkill("thunder_punch")
  mob_data.BaseIntrinsics[0] = "drizzle"
  local new_mob = RogueEssence.Dungeon.Character(mob_data)
  local tactic = _DATA:GetAITactic("wander_normal")
  new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
  new_mob.CharLoc = RogueElements.Loc(4, 4)
  new_mob.CharDir = Dir8.Down
  new_team.Players:Add(new_mob)
  
  mob_data = RogueEssence.Dungeon.CharData()
  mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("mew", 0, "normal", Gender.Female)
  mob_data.Level = 25
  mob_data.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill("pound")
  mob_data.BaseIntrinsics[0] = "speed_boost"
  new_mob = RogueEssence.Dungeon.Character(mob_data)
  tactic = _DATA:GetAITactic("wander_normal")
  new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
  new_mob.CharLoc = RogueElements.Loc(5, 4)
  new_mob.CharDir = Dir8.Up
  new_team.Players:Add(new_mob)
  
  map.MapTeams:Add(new_team)
  
  --Place the player spawn just above the unbreakable wall (doesn't work if you already have one)
  map.GenEntrances:Add(RogueEssence.LevelGen.MapGenEntrance(RogueElements.Loc(map.Width / 2 - 1, map.Height / 2 - 2), Dir8.UpRight))
end


function FLOOR_GEN_SCRIPT.CastawayCaveRevisit(map, args)
  if not SV.manaphy_egg.Taken then
    return
  end
  
  local item = nil
  
  for ii = 0, map.Items.Count - 1, 1 do
	if map.Items[ii].Value == "egg_mystery" then
	  item = map.Items[ii]
	  break
	end
  end
  
  if item ~= nil then
    item.Value = "box_deluxe"
	item.HiddenValue = "empty"
  end
  
end