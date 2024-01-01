
BATTLE_SCRIPT = {}

StackStateType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')
ListType = luanet.import_type('System.Collections.Generic.List`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')

SpawnListType =  luanet.import_type('RogueElements.SpawnList`1')

SINGLE_CHAR_SCRIPT = {}


local WISH_TABLE = {
  {
    Min = 7,
    Max = 14,
    Items = {
      { Item = "money", Amount = 50, Weight = 23 },
      { Item = "money", Amount = 200, Weight = 15 },
      { Item = "money", Amount = 300, Weight = 15 },
      { Item = "money", Amount = 400, Weight = 15 },
      { Item = "loot_pearl", Amount = 1, Weight = 10 },
      { Item = "loot_pearl", Amount = 2, Weight = 10 },
      { Item = "loot_pearl", Amount = 3, Weight = 10 },
      { Item = "loot_nugget", Amount = 1, Weight = 2 }
    },
  },
  {
    Min = 9,
    Max = 12,
    Items = {
      { Item = "food_grimy", Amount = 1, Weight = 2 },
      { Item = "berry_leppa", Amount = 1, Weight = 12 },
      { Item = "berry_sitrus", Amount = 1, Weight = 8 },
      { Item = "berry_oran", Amount = 1, Weight = 8 },
      { Item = "berry_apicot", Amount = 1, Weight = 3 },
      { Item = "berry_jaboca", Amount = 1, Weight = 3 },
      { Item = "berry_liechi", Amount = 1, Weight = 3 },
      { Item = "berry_starf", Amount = 1, Weight = 3 },
      { Item = "berry_petaya", Amount = 1, Weight = 3 },
      { Item = "berry_salac", Amount = 1, Weight = 3 },
      { Item = "berry_micle", Amount = 1, Weight = 3 },
      { Item = "berry_ganlon", Amount = 1, Weight = 3 },
      { Item = "berry_emigma", Amount = 1, Weight = 3 },
      { Item = "berry_lum", Amount = 1, Weight = 10 },
      { Item = "food_apple", Amount = 1, Weight = 18 },
      { Item = "food_apple_big", Amount = 1, Weight = 6 },
      { Item = "food_apple_huge", Amount = 1, Weight = 3 },
      { Item = "food_apple_golden", Amount = 1, Weight = 1 },
      { Item = "food_banana", Amount = 1, Weight = 3 },
      { Item = "food_banana_big", Amount = 1, Weight = 1 }
    },
  },
  {
    Min = 10,
    Max = 15,
    Items = {
      { Item = "seed_ban", Amount = 1, Weight = 7 },
      { Item = "seed_joy", Amount = 1, Weight = 7 },
      { Item = "seed_decoy", Amount = 1, Weight = 2 },
      { Item = "seed_pure", Amount = 1, Weight = 2 },
      { Item = "seed_blast", Amount = 1, Weight = 2 },
      { Item = "seed_ice", Amount = 1, Weight = 2 },
      { Item = "seed_reviver", Amount = 1, Weight = 12 },
      { Item = "seed_warp", Amount = 1, Weight = 2 },
      { Item = "seed_doom", Amount = 1, Weight = 2 },
      { Item = "seed_ice", Amount = 1, Weight = 2 },
      { Item = "herb_white", Amount = 1, Weight = 2 },
      { Item = "herb_mental", Amount = 1, Weight = 2 },
      { Item = "herb_power", Amount = 1, Weight = 2 },
      { Item = "held_flame_orb", Amount = 1, Weight = 2 },
      { Item = "held_toxic_orb", Amount = 1, Weight = 2 },
      { Item = "orb_all_dodge", Amount = 1, Weight = 2 },
      { Item = "orb_all_protect", Amount = 1, Weight = 2 },
      { Item = "orb_cleanse", Amount = 1, Weight = 2 },
      { Item = "orb_devolve", Amount = 1, Weight = 2 },
      { Item = "orb_fill_in", Amount = 1, Weight = 2 },
      { Item = "orb_endure", Amount = 1, Weight = 2 },
      { Item = "orb_foe_hold", Amount = 1, Weight = 2 },
      { Item = "orb_foe_seal", Amount = 1, Weight = 2 },
      { Item = "orb_freeze", Amount = 1, Weight = 2 },
      { Item = "orb_halving", Amount = 1, Weight = 2 },
      { Item = "orb_itemizer", Amount = 1, Weight = 2 },
      { Item = "orb_luminous", Amount = 1, Weight = 2 },
      { Item = "orb_mobile", Amount = 1, Weight = 2 },
      { Item = "orb_mirror", Amount = 1, Weight = 2 },
      { Item = "orb_spurn", Amount = 1, Weight = 2 },
      { Item = "orb_slumber", Amount = 1, Weight = 2 },
      { Item = "orb_petrify", Amount = 1, Weight = 2 },
      { Item = "orb_totter", Amount = 1, Weight = 2 },
      { Item = "orb_invisify", Amount = 1, Weight = 2 },
      { Item = "orb_totter", Amount = 1, Weight = 2 },
      { Item = "orb_stayaway", Amount = 1, Weight = 2 },
      { Item = "machine_recall_box", Amount = 1, Weight = 2 },
      { Item = "machine_ability_capsule", Amount = 1, Weight = 2 },
      { Item = "medicine_elixir", Amount = 1, Weight = 2 },
      { Item = "medicine_full_heal", Amount = 1, Weight = 2 },
      { Item = "medicine_max_elixir", Amount = 1, Weight = 2 },
      { Item = "medicine_max_potion", Amount = 1, Weight = 2 },
      { Item = "medicine_potion", Amount = 1, Weight = 2 },
      { Item = "medicine_x_accuracy", Amount = 1, Weight = 2 },
      { Item = "medicine_x_attack", Amount = 1, Weight = 2 },
      { Item = "medicine_x_defense", Amount = 1, Weight = 2 },
      { Item = "medicine_x_sp_atk", Amount = 1, Weight = 2 },
      { Item = "medicine_x_sp_atk", Amount = 1, Weight = 2 },
      { Item = "medicine_x_speed", Amount = 1, Weight = 2 },
      { Item = "ammo_cacnea_spike", Amount = 3, Weight = 3 },
      { Item = "ammo_corsola_twig", Amount = 3, Weight = 3 },
      { Item = "ammo_geo_pebble", Amount = 3, Weight = 3 },
      { Item = "ammo_golden_thorn", Amount = 3, Weight = 3 },
      { Item = "ammo_gravelerock", Amount = 3, Weight = 3 },
      { Item = "ammo_iron_thorn", Amount = 3, Weight = 3 },
      { Item = "ammo_rare_fossil", Amount = 3, Weight = 3 },
      { Item = "ammo_silver_spike", Amount = 3, Weight = 3 },
      { Item = "ammo_stick", Amount = 3, Weight = 3 },
      { Item = "ammo_iron_thorn", Amount = 3, Weight = 3 },
    }
  },
  {
    Min = 7,
    Max = 10,
    Items = {
      { Item = "machine_recall_box", Amount = 1, Weight = 10 },
      { Item = "seed_joy", Amount = 1, Weight = 15 },
      { Item = "seed_golden", Amount = 1, Weight = 2 },
      { Item = "gummi_black", Amount = 1, Weight = 3 },
      { Item = "gummi_blue", Amount = 1, Weight = 3 },
      { Item = "gummi_brown", Amount = 1, Weight = 3 },
      { Item = "gummi_clear", Amount = 1, Weight = 3 },
      { Item = "gummi_gold", Amount = 1, Weight = 3 },
      { Item = "seed_joy", Amount = 1, Weight = 3 },
      { Item = "gummi_grass", Amount = 1, Weight = 3 },
      { Item = "gummi_green", Amount = 1, Weight = 3 },
      { Item = "gummi_magenta", Amount = 1, Weight = 3 },
      { Item = "gummi_orange", Amount = 1, Weight = 3 },
      { Item = "gummi_pink", Amount = 1, Weight = 3 },
      { Item = "gummi_purple", Amount = 1, Weight = 3 },
      { Item = "gummi_red", Amount = 1, Weight = 3 },
      { Item = "gummi_royal", Amount = 1, Weight = 3 },
      { Item = "gummi_silver", Amount = 1, Weight = 3 },
      { Item = "gummi_sky", Amount = 1, Weight = 3 },
      { Item = "gummi_white", Amount = 1, Weight = 3 },
      { Item = "gummi_yellow", Amount = 1, Weight = 3 },
      { Item = "gummi_wonder", Amount = 1, Weight = 3 },
      { Item = "boost_calcium", Amount = 1, Weight = 4 },
      { Item = "boost_carbos", Amount = 1, Weight = 4 },
      { Item = "boost_hp_up", Amount = 1, Weight = 4 },
      { Item = "boost_iron", Amount = 1, Weight = 4 },
      { Item = "boost_nectar", Amount = 1, Weight = 4 },
      { Item = "boost_zinc", Amount = 1, Weight = 4 },
      { Item = "tm_acrobatics", Amount = 1, Weight = 1 },
      { Item = "tm_aerial_ace", Amount = 1, Weight = 1 },
      { Item = "tm_attract", Amount = 1, Weight = 1 },
      { Item = "tm_avalanche", Amount = 1, Weight = 1 },
      { Item = "tm_blizzard", Amount = 1, Weight = 1 },
      { Item = "tm_brick_break", Amount = 1, Weight = 1 },
      { Item = "tm_brine", Amount = 1, Weight = 1 },
      { Item = "tm_bulk_up", Amount = 1, Weight = 1 },
      { Item = "tm_bulldoze", Amount = 1, Weight = 1 },
      { Item = "tm_bullet_seed", Amount = 1, Weight = 1 },
      { Item = "tm_calm_mind", Amount = 1, Weight = 1 },
      { Item = "tm_captivate", Amount = 1, Weight = 1 },
      { Item = "tm_charge_beam", Amount = 1, Weight = 1 },
      { Item = "tm_cut", Amount = 1, Weight = 1 },
      { Item = "tm_dark_pulse", Amount = 1, Weight = 1 },
      { Item = "tm_dazzling_gleam", Amount = 1, Weight = 1 },
      { Item = "tm_defog", Amount = 1, Weight = 1 },
      { Item = "tm_dig", Amount = 1, Weight = 1 },
      { Item = "tm_dive", Amount = 1, Weight = 1 },
      { Item = "tm_double_team", Amount = 1, Weight = 1 },
      { Item = "tm_dragon_claw", Amount = 1, Weight = 1 },
      { Item = "tm_dragon_pulse", Amount = 1, Weight = 1 },
      { Item = "tm_dragon_tail", Amount = 1, Weight = 1 },
      { Item = "tm_drain_punch", Amount = 1, Weight = 1 },
      { Item = "tm_dream_eater", Amount = 1, Weight = 1 },
      { Item = "tm_earthquake", Amount = 1, Weight = 1 },
      { Item = "tm_echoed_voice", Amount = 1, Weight = 1 },
      { Item = "tm_embargo", Amount = 1, Weight = 1 },
      { Item = "tm_endure", Amount = 1, Weight = 1 },
      { Item = "tm_energy_ball", Amount = 1, Weight = 1 },
      { Item = "tm_explosion", Amount = 1, Weight = 1 },
      { Item = "tm_facade", Amount = 1, Weight = 1 },
      { Item = "tm_false_swipe", Amount = 1, Weight = 1 },
      { Item = "tm_fire_blast", Amount = 1, Weight = 1 },
      { Item = "tm_flame_charge", Amount = 1, Weight = 1 },
      { Item = "tm_flamethrower", Amount = 1, Weight = 1 },
      { Item = "tm_flash", Amount = 1, Weight = 1 },
      { Item = "tm_flash_cannon", Amount = 1, Weight = 1 },
      { Item = "tm_fling", Amount = 1, Weight = 1 },
      { Item = "tm_fly", Amount = 1, Weight = 1 },
      { Item = "tm_focus_blast", Amount = 1, Weight = 1 },
      { Item = "tm_focus_punch", Amount = 1, Weight = 1 },
      { Item = "tm_frost_breath", Amount = 1, Weight = 1 },
      { Item = "tm_frustration", Amount = 1, Weight = 1 },
      { Item = "tm_giga_drain", Amount = 1, Weight = 1 },
      { Item = "tm_giga_impact", Amount = 1, Weight = 1 },
      { Item = "tm_grass_knot", Amount = 1, Weight = 1 },
      { Item = "tm_gyro_ball", Amount = 1, Weight = 1 },
      { Item = "tm_hail", Amount = 1, Weight = 1 },
      { Item = "tm_hidden_power", Amount = 1, Weight = 1 },
      { Item = "tm_hone_claws", Amount = 1, Weight = 1 },
      { Item = "tm_hyper_beam", Amount = 1, Weight = 1 },
      { Item = "tm_ice_beam", Amount = 1, Weight = 1 },
      { Item = "tm_incinerate", Amount = 1, Weight = 1 },
      { Item = "tm_infestation", Amount = 1, Weight = 1 },
      { Item = "tm_iron_tail", Amount = 1, Weight = 1 },
      { Item = "tm_light_screen", Amount = 1, Weight = 1 },
      { Item = "tm_low_sweep", Amount = 1, Weight = 1 },
      { Item = "tm_natural_gift", Amount = 1, Weight = 1 },
      { Item = "tm_nature_power", Amount = 1, Weight = 1 },
      { Item = "tm_overheat", Amount = 1, Weight = 1 },
      { Item = "tm_payback", Amount = 1, Weight = 1 },
      { Item = "tm_pluck", Amount = 1, Weight = 1 },
      { Item = "tm_poison_jab", Amount = 1, Weight = 1 },
      { Item = "tm_power_up_punch", Amount = 1, Weight = 1 },
      { Item = "tm_protect", Amount = 1, Weight = 1 },
      { Item = "tm_psych_up", Amount = 1, Weight = 1 },
      { Item = "tm_psychic", Amount = 1, Weight = 1 },
      { Item = "tm_psyshock", Amount = 1, Weight = 1 },
      { Item = "tm_quash", Amount = 1, Weight = 1 },
      { Item = "tm_rain_dance", Amount = 1, Weight = 1 },
      { Item = "tm_recycle", Amount = 1, Weight = 1 },
      { Item = "tm_reflect", Amount = 1, Weight = 1 },
      { Item = "tm_rest", Amount = 1, Weight = 1 },
      { Item = "tm_retaliate", Amount = 1, Weight = 1 },
      { Item = "tm_return", Amount = 1, Weight = 1 },
      { Item = "tm_roar", Amount = 1, Weight = 1 },
      { Item = "tm_rock_climb", Amount = 1, Weight = 1 },
      { Item = "tm_rock_polish", Amount = 1, Weight = 1 },
      { Item = "tm_rock_slide", Amount = 1, Weight = 1 },
      { Item = "tm_rock_smash", Amount = 1, Weight = 1 },
      { Item = "tm_rock_tomb", Amount = 1, Weight = 1 },
      { Item = "tm_roost", Amount = 1, Weight = 1 },
      { Item = "tm_round", Amount = 1, Weight = 1 },
      { Item = "tm_safeguard", Amount = 1, Weight = 1 },
      { Item = "tm_sandstorm", Amount = 1, Weight = 1 },
      { Item = "tm_scald", Amount = 1, Weight = 1 },
      { Item = "tm_secret_power", Amount = 1, Weight = 1 },
      { Item = "tm_shadow_ball", Amount = 1, Weight = 1 },
      { Item = "tm_shadow_claw", Amount = 1, Weight = 1 },
      { Item = "tm_shock_wave", Amount = 1, Weight = 1 },
      { Item = "tm_silver_wind", Amount = 1, Weight = 1 },
      { Item = "tm_sky_drop", Amount = 1, Weight = 1 },
      { Item = "tm_sludge_bomb", Amount = 1, Weight = 1 },
      { Item = "tm_sludge_wave", Amount = 1, Weight = 1 },
      { Item = "tm_smack_down", Amount = 1, Weight = 1 },
      { Item = "tm_snarl", Amount = 1, Weight = 1 },
      { Item = "tm_snatch", Amount = 1, Weight = 1 },
      { Item = "tm_steel_wing", Amount = 1, Weight = 1 },
      { Item = "tm_stone_edge", Amount = 1, Weight = 1 },
      { Item = "tm_strength", Amount = 1, Weight = 1 },
      { Item = "tm_struggle_bug", Amount = 1, Weight = 1 },
      { Item = "tm_substitute", Amount = 1, Weight = 1 },
      { Item = "tm_sunny_day", Amount = 1, Weight = 1 },
      { Item = "tm_surf", Amount = 1, Weight = 1 },
      { Item = "tm_swagger", Amount = 1, Weight = 1 },
      { Item = "tm_swords_dance", Amount = 1, Weight = 1 },
      { Item = "tm_taunt", Amount = 1, Weight = 1 },
      { Item = "tm_telekinesis", Amount = 1, Weight = 1 },
      { Item = "tm_thief", Amount = 1, Weight = 1 },
      { Item = "tm_thunder", Amount = 1, Weight = 1 },
      { Item = "tm_thunder_wave", Amount = 1, Weight = 1 },
      { Item = "tm_thunderbolt", Amount = 1, Weight = 1 },
      { Item = "tm_torment", Amount = 1, Weight = 1 },
      { Item = "tm_u_turn", Amount = 1, Weight = 1 },
      { Item = "tm_venoshock", Amount = 1, Weight = 1 },
      { Item = "tm_volt_switch", Amount = 1, Weight = 1 },
      { Item = "tm_water_pulse", Amount = 1, Weight = 1 },
      { Item = "tm_waterfall", Amount = 1, Weight = 1 },
      { Item = "tm_whirlpool", Amount = 1, Weight = 1 },
      { Item = "tm_wild_charge", Amount = 1, Weight = 1 },
      { Item = "tm_will_o_wisp", Amount = 1, Weight = 1 },
      { Item = "tm_work_up", Amount = 1, Weight = 1 },
      { Item = "tm_x_scissor", Amount = 1, Weight = 1 },
    },
  },
}

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

function SINGLE_CHAR_SCRIPT.CrystalGlowEvent(owner, ownerChar, context, args)
  if context.User.MemberTeam ~= _DUNGEON.ActiveTeam.Leader.MemberTeam then
    return
  end
  
  if context.User.CharLoc ~= owner.TileLoc then
    return
  end

  local item_idx = _ZONE.CurrentMap:GetItem(owner.TileLoc)
  if item_idx ~= -1 then
    return
  end

  local base_loc = owner.TileLoc
  local entries = {
    {item = "wish_gem", weight = 450},
    {item = "loot_nugget", weight = 20},
    {item = "loot_pearl", weight = 75},
    {item = "evo_fire_stone", weight = 5},
    {item = "evo_water_stone", weight = 5},
    {item = "evo_thunder_stone", weight = 5},
    {item = "evo_leaf_stone", weight = 5},
    {item = "evo_ice_stone", weight = 5}, -- 25
    {item = "evo_moon_stone", weight = 5}, -- 35
    {item = "evo_dusk_stone", weight = 5}, -- 40
    {item = "evo_dawn_stone", weight = 5}, -- 45
    {item = "evo_shiny_stone", weight = 5}, -- 55
    {item = "", weight = 405},
    -- {item = "nugget", weight = 5},
  }
  GAME:WaitFrames(10)
  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Dig", 3))
  DUNGEON:PlayVFX(emitter, base_loc.X * 24 + 12, base_loc.Y * 24)
  SOUND:PlayBattleSE("DUN_Dig")
  GAME:WaitFrames(10)
  
  local item = PickByWeights(entries)
  
  -- 3, 12, 13
  -- 5, 14, 15
  -- print(DUNGEON:DungeonCurrentFloor() == 1)
  if DUNGEON:DungeonCurrentFloor() == 1 then
    item = "wish_gem"
  end

  if item ~= "" then
    local inv_item =  RogueEssence.Dungeon.InvItem(item, false, 1)
    local map_item = RogueEssence.Dungeon.MapItem(inv_item)
    map_item.TileLoc = owner.TileLoc
    local start_loc = base_loc * RogueEssence.Content.GraphicsManager.TileSize - RogueElements.Loc(-RogueEssence.Content.GraphicsManager.TileSize / 2, -20)
    local end_loc = base_loc * RogueEssence.Content.GraphicsManager.TileSize - RogueElements.Loc(-RogueEssence.Content.GraphicsManager.TileSize / 2, -10)
    local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(item).Sprite, RogueEssence.Content.GraphicsManager.TileSize / 2, 10);
    _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Normal)
    
    GAME:WaitFrames(10)
    local msg = RogueEssence.StringKey("MSG_GLOW_FOUND_ITEM"):ToLocal()
    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true), inv_item:GetDisplayName()))
    GAME:WaitFrames(10)
    _ZONE.CurrentMap.Items:Add(map_item);
  else
    local msg = RogueEssence.StringKey("MSG_GLOW_FOUND_NO_ITEM"):ToLocal()
    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
  end
  ResetEffectTile(owner)
end

function SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, args)

  -- if pause == nil then pause = true end
  -- if sound == nil then sound = false end
  print("HEREEEEEEE SPAWNNNN")
  local min_amount = 5
  local max_amount = 9
  local max_range_width = 2
  local max_range_height = 2
  local effect_tile = owner
  local x_offset = 0
  local y_offset = 1
  local base_loc = effect_tile.TileLoc + RogueElements.Loc(x_offset, y_offset)
  local Items = args.Items
  if type(args.MinAmount) == "number" then min_amount = args.MinAmount end
  if type(args.MaxAmount) == "number" then max_amount = args.MaxAmount end
  if type(args.MaxRangeWidth) == "number" then max_range_width = args.MaxRangeWidth end
  if type(args.MaxRangeHeight) == "number" then max_range_height = args.MaxRangeHeight end
  if type(args.xOffset) == "number" then x_offset = args.xOffset end
  if type(args.yOffset) == "number" then y_offset = args.yOffset end

  function checkOp(test_loc)
    local test_tile = _ZONE.CurrentMap:GetTile(test_loc)
    print(tostring(test_tile.Data:GetData().BlockType == RogueEssence.Data.TerrainData.Mobility.Passable) .. "HERE " .. tostring(test_loc))
    if test_tile ~= nil and not _ZONE.CurrentMap:TileBlocked(test_loc) and test_tile.Data:GetData().BlockType == RogueEssence.Data.TerrainData.Mobility.Passable and (test_tile.Effect.ID == nil or test_tile.Effect.ID == "") then
      local item_count = _ZONE.CurrentMap.Items.Count
      for item_idx = 0, item_count - 1, 1 do
        local map_item = _ZONE.CurrentMap.Items[item_idx]
        if map_item.TileLoc == test_loc then
          return false
        end
      end
      return true
    end
    return false
	end


  local loc_x = base_loc.X
  local loc_y = base_loc.Y

  local x_with_borders = max_range_width + 1
  local y_with_borders = max_range_height + 1
  local bounds = RogueElements.Rect(loc_x - x_with_borders, loc_y - y_with_borders, (2 * y_with_borders) + 1, (2 * x_with_borders) + 1)
  local free_tiles = RogueElements.Grid.FindTilesInBox(bounds.Start + RogueElements.Loc(1), bounds.Size - RogueElements.Loc(2), checkOp)
  local spawn_items = LUA_ENGINE:MakeGenericType(ListType, { MapItemType }, { })

  local amount = _DATA.Save.Rand:Next(min_amount, max_amount)

  for ii = 0, amount - 1, 1 do
    if free_tiles.Count == 0 then
      break
    end

    local spawn_index = Items:PickIndex(_ZONE.CurrentMap.Rand)
    local item = RogueEssence.Dungeon.MapItem(Items:GetSpawn(spawn_index))
    local rand_index = _DATA.Save.Rand:Next(free_tiles.Count);
    local item_target_loc = free_tiles[rand_index]
    item.TileLoc = _ZONE.CurrentMap:WrapLoc(item_target_loc)
    spawn_items:Add(item)
    free_tiles:RemoveAt(rand_index)
    local offset = RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2)
    local sprite
    if item.IsMoney then
      sprite = RogueEssence.Content.GraphicsManager.MoneySprite
    else
      sprite = _DATA:GetItem(item.Value).Sprite
    end
    local item_anim = RogueEssence.Content.ItemAnim(item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset - RogueElements.Loc(0, 200), item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset, sprite, RogueEssence.Content.GraphicsManager.TileSize * 2, 60);
    _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Bottom)
    GAME:WaitFrames(5)
    _ZONE.CurrentMap.Items:Add(spawn_items[ii]);
  end
end


function SINGLE_CHAR_SCRIPT.AskWishEvent(owner, ownerChar, context, args)
    local chara = context.User
    UI:ResetSpeaker()
    -- local stand_anim =  RogueEssence.Dungeon.CharAnimNone(context.User.CharLoc, context.User.CharDir)
    -- stand_anim.MajorAnim = true
    -- TASK:WaitTask(context.User:StartAnim(stand_anim))
    DUNGEON:CharSetAction(chara, RogueEssence.Dungeon.CharAnimPose(chara.CharLoc, chara.CharDir, 0, -1))
    -- UI:WaitShowDialogue("HI")
    local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")
    crystal_moment_status:LoadFromData()
    TASK:WaitTask(_DUNGEON:AddMapStatus(crystal_moment_status))
    -- TASK:WaitTask(_DUNGEON:AddMapStatus("rain"))

    _ZONE.CurrentMap.HideMinimap = true
    local curr_song = RogueEssence.GameManager.Instance.Song;
    SOUND:StopBGM()
    UI:WaitShowDialogue("...[pause=0]Time momentarily pauses.[pause=0] The world around you holds their breath, as the crystal shines brightly.")
    -- local msg = STRINGS:FormatKey("DLG_TRY_AGAIN_ASK");
    UI:ChoiceMenuYesNo("Would you like to make a wish?", false)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    if result then
      local slot = GAME:FindPlayerItem("wish_gem", true, true) 

      if slot:IsValid() and SV.Wishmaker.TotalWishesPerFloor > 0 then        
        local end_choice = 5
        local wish_choices = {"Money", "Food", "Items", "Power", "Don't know"}    
        UI:BeginChoiceMenu("What do you desire?", wish_choices, 1, end_choice)
        UI:WaitForChoice()
        choice = UI:ChoiceResult()
        if choice ~= 5 then
          SV.Wishmaker.TotalWishesPerFloor = SV.Wishmaker.TotalWishesPerFloor - 1
          GAME:WaitFrames(50)
          SOUND:PlayBattleSE("_UNK_EVT_044");
          GAME:WaitFrames(10)
          GAME:FadeOut(true, 40)
          -- SOUND:PlayBattleSE("_UNK_EVT_091");
          -- SOUND:PlayBattleSE("_UNK_EVT_096");
          SOUND:PlayBattleSE("EVT_EP_Regi_Permission");
          -- SOUND:PlayBattleSE("EVT_Dimenstional_Scream");
          -- SOUND:PlayBattleSE("EVT_Fade_White");
          -- SOUND:PlayBattleSE("EVT_Evolution_Start");
          TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.User, context.User, _DATA.SendHomeFX))
          -- SOUND:PlayBattleSE("_UNK_EVT_074");
          -- SOUND:PlayBattleSE("_UNK_EVT_084");
                -- SOUND:PlayBattleSE("_UNK_EVT_087");
          local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Last_Resort_Front", 4), 1)

          -- local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(item).Sprite, RogueEssence.Content.GraphicsManager.TileSize / 2, 10);
          emitter:SetupEmit(owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize + RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2), owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize + RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2), Direction.Left);
          _DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw);
          GAME:FadeIn(60)
          GAME:WaitFrames(80)
          local arguments = {}
          local Items = LUA_ENGINE:MakeGenericType(SpawnListType, { MapItemType }, { })
          local item_table = WISH_TABLE[choice]
          arguments.MinAmount = item_table.Min
          arguments.MaxAmount = item_table.Max
          local items = item_table.Items
          for _, value in ipairs(items) do
            local item_name = value.Item
            if item_name == "money" then
              Items:Add(RogueEssence.Dungeon.MapItem.CreateMoney(value.Amount), value.Weight)
            else
              Items:Add(RogueEssence.Dungeon.MapItem(item_name, value.Amount), value.Weight)
            end
          end
          arguments.Items = Items
          SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
          GAME:WaitFrames(20)
        end
      else
        UI:WaitShowDialogue("...[pause=0]" .. context.User:GetDisplayName(true) .. " cannot make a wish right now.")
      end
    end
    UI:WaitShowDialogue("The crystal became dimmer.")
    
    TASK:WaitTask(_DUNGEON:RemoveMapStatus("crystal_moment", false))
    SOUND:PlayBGM(curr_song, true, 0)
    GAME:WaitFrames(20)

    _ZONE.CurrentMap.HideMinimap = false
    GAME:WaitFrames(20)
    local stand_anim =  RogueEssence.Dungeon.CharAnimNone(context.User.CharLoc, context.User.CharDir)
    stand_anim.MajorAnim = true
    TASK:WaitTask(context.User:StartAnim(stand_anim))
end

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

function PickByWeights(entries)
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