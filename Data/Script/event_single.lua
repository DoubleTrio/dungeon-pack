
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
    Min = 9,
    Max = 14,
    Items = {
      { Item = "money", Amount = 150, Weight = 15 },
      { Item = "money", Amount = 200, Weight = 15 },
      { Item = "money", Amount = 300, Weight = 15 },
      { Item = "money", Amount = 400, Weight = 15 },
      { Item = "loot_pearl", Amount = 1, Weight = 12 },
      { Item = "loot_pearl", Amount = 2, Weight = 12 },
      { Item = "loot_pearl", Amount = 3, Weight = 12 },
      { Item = "loot_nugget", Amount = 1, Weight = 4 }
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
      { Item = "berry_enigma", Amount = 1, Weight = 3 },
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
    Min = 11,
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
	{
		Min = 7,
		Max = 9,
		Items = {
			{ Item = "held_flame_orb", Amount = 1, Weight = 2 },
			{ Item = "held_toxic_orb", Amount = 1, Weight = 2 },
      { Item = "held_assault_vest", Amount = 1, Weight = 2 },
			{ Item = "held_big_root", Amount = 1, Weight = 2 },
      { Item = "held_black_belt", Amount = 1, Weight = 2 },
			{ Item = "held_black_sludge", Amount = 1, Weight = 2 },
			{ Item = "held_choice_band", Amount = 1, Weight = 2 },
			{ Item = "held_choice_scarf", Amount = 1, Weight = 2 },
			{ Item = "held_choice_specs", Amount = 1, Weight = 2 },
			{ Item = "held_defense_scarf", Amount = 1, Weight = 2 },
			{ Item = "held_expert_belt", Amount = 1, Weight = 2 },
			{ Item = "held_pass_scarf", Amount = 1, Weight = 2 },
			{ Item = "held_mobile_scarf", Amount = 1, Weight = 2 },
			{ Item = "held_metronome", Amount = 1, Weight = 2 },
			{ Item = "held_wide_lens", Amount = 1, Weight = 2 },
			{ Item = "held_x_ray_specs", Amount = 1, Weight = 4 },
			{ Item = "held_twist_band", Amount = 1, Weight = 2 },
			{ Item = "held_trap_scarf", Amount = 1, Weight = 2 },
			{ Item = "held_sticky_barb", Amount = 1, Weight = 2 },
			{ Item = "held_power_band", Amount = 1, Weight = 2 },
			{ Item = "held_pierce_band", Amount = 1, Weight = 2 },
			{ Item = "held_reunion_cape", Amount = 1, Weight = 2 },
			{ Item = "held_scope_lens", Amount = 1, Weight = 2 },
			{ Item = "held_shed_shell", Amount = 1, Weight = 2 },
			{ Item = "held_shell_bell", Amount = 1, Weight = 2 },
			{ Item = "held_life_orb", Amount = 1, Weight = 2 },
			{ Item = "held_iron_ball", Amount = 1, Weight = 2 },
			{ Item = "held_goggle_specs", Amount = 1, Weight = 2 },
			{ Item = "held_friend_bow", Amount = 1, Weight = 1 },
			{ Item = "held_heal_ribbon", Amount = 1, Weight = 2 },
			{ Item = "held_blank_plate", Amount = 1, Weight = 1},
			{ Item = "held_draco_plate", Amount = 1, Weight = 1},
			{ Item = "held_dread_plate", Amount = 1, Weight = 1},
			{ Item = "held_earth_plate", Amount = 1, Weight = 1},
			{ Item = "held_fist_plate", Amount = 1, Weight = 1},
			{ Item = "held_flame_plate", Amount = 1, Weight = 1},
			{ Item = "held_icicle_plate", Amount = 1, Weight = 1},
			{ Item = "held_insect_plate", Amount = 1, Weight = 1},
			{ Item = "held_iron_plate", Amount = 1, Weight = 1},
			{ Item = "held_meadow_plate", Amount = 1, Weight = 1},
			{ Item = "held_mind_plate", Amount = 1, Weight = 1},
			{ Item = "held_pixie_plate", Amount = 1, Weight = 1},
			{ Item = "held_sky_plate", Amount = 1, Weight = 1},
			{ Item = "held_splash_plate", Amount = 1, Weight = 1},
			{ Item = "held_spooky_plate", Amount = 1, Weight = 1},
			{ Item = "held_stone_plate", Amount = 1, Weight = 1},
			{ Item = "held_toxic_plate", Amount = 1, Weight = 1},
			{ Item = "held_zap_plate", Amount = 1, Weight = 1},
		}
	},
	{
		Min = 7,
		Max = 9,
		Items = {
			{ Item = "apricorn_big", Amount = 1, Weight = 3 },
			{ Item = "apricorn_black", Amount = 1, Weight = 2 },
			{ Item = "apricorn_blue", Amount = 1, Weight = 2 },
			{ Item = "apricorn_brown", Amount = 1, Weight = 2 },
			{ Item = "apricorn_green", Amount = 1, Weight = 2 },
			{ Item = "apricorn_plain", Amount = 1, Weight = 2 },
			{ Item = "apricorn_purple", Amount = 1, Weight = 2 },
			{ Item = "apricorn_red", Amount = 1, Weight = 2 },
			{ Item = "apricorn_white", Amount = 1, Weight = 2 },
			{ Item = "apricorn_yellow", Amount = 1, Weight = 2 },
			{ Item = "medicine_amber_tear", Amount = 1, Weight = 8 },
			{ Item = "machine_assembly_box", Amount = 1, Weight = 4 },
		},
	}
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
    -- {item = "loot_nugget", weight = 20},
    -- {item = "loot_pearl", weight = 75},
    -- {item = "evo_fire_stone", weight = 5},
    -- {item = "evo_water_stone", weight = 5},
    -- {item = "evo_thunder_stone", weight = 5},
    -- {item = "evo_leaf_stone", weight = 5},
    -- {item = "evo_ice_stone", weight = 5}, -- 25
    -- {item = "evo_moon_stone", weight = 5}, -- 35
    -- {item = "evo_dusk_stone", weight = 5}, -- 40
    -- {item = "evo_dawn_stone", weight = 5}, -- 45
    -- {item = "evo_shiny_stone", weight = 5}, -- 55
    -- {item = "", weight = 405},
    -- {item = "nugget", weight = 5},
  }
  GAME:WaitFrames(10)
  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Dig", 3))
  DUNGEON:PlayVFX(emitter, base_loc.X * 24 + 12, base_loc.Y * 24)
  SOUND:PlayBattleSE("DUN_Dig")
  GAME:WaitFrames(10)
  
  local item = PickByWeights(entries)
  
  -- if DUNGEON:DungeonCurrentFloor() == 1 then
  --   item = "wish_gem"
  -- end

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



function SINGLE_CHAR_SCRIPT.ItemWishEvent(owner, ownerChar, context, args)
	print("ITEM_WISH_EVENT")
end

-- THIS EVENT CURRENTLY BREAKS FOR REPLAYS
function SINGLE_CHAR_SCRIPT.AskWishEvent(owner, ownerChar, context, args)
	-- UI:ResetSpeaker()
	-- UI:WaitShowDialogue("HI")
	-- UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_LOCK_GUILD_OPEN"):ToLocal(), context.User:GetDisplayName(true)))
	-- TASK:WaitTask(owner:InteractWithTile(context))
	-- print(tostring(_DATA.CurrentReplay) .. "CheckingCurrentReplay")
  if _DATA.CurrentReplay == nil then
    local chara = context.User
		if chara.CharDir ~= Direction.Up then
			return
		end

    UI:ResetSpeaker()
    DUNGEON:CharSetAction(chara, RogueEssence.Dungeon.CharAnimPose(chara.CharLoc, chara.CharDir, 0, -1))
    local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")
    crystal_moment_status:LoadFromData()
    TASK:WaitTask(_DUNGEON:AddMapStatus(crystal_moment_status))

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

			-- if slot:IsValid() and SV.Wishmaker.TotalWishesPerFloor > 0 then  
      if slot:IsValid() then        
        local end_choice = 7
        local wish_choices = {"Money", "Food", "Items", "Power", "Equipment", "Allies", "Don't know"}    
        UI:BeginChoiceMenu("What do you desire?", wish_choices, 1, end_choice)
        UI:WaitForChoice()
        choice = UI:ChoiceResult()
        if choice ~= 7 then
					if slot.IsEquipped then
						GAME:TakePlayerEquippedItem(slot.Slot)
					else
						GAME:TakePlayerBagItem(slot.Slot)
					end
          -- SV.Wishmaker.TotalWishesPerFloor = SV.Wishmaker.TotalWishesPerFloor - 1
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
	else
		-- TODO - FIGURE OUT UI STUFF
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


function SINGLE_CHAR_SCRIPT.Test(owner, ownerChar, context, args)
  PrintInfo("Test")
end


function SINGLE_CHAR_SCRIPT.CastawayCaveAltMusic(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.castaway_cave.TookTreasure then
    --keep the map music as is
  else
	_ZONE.CurrentMap.Music = "B24. Castaway Cave 2.ogg"
  end
  
  SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
end


function SINGLE_CHAR_SCRIPT.CastawayCaveAltEnemies(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.castaway_cave.TookTreasure then
    return
  end
  
  _ZONE.CurrentMap.MapEffect.OnMapTurnEnds:Add(RogueElements.Priority(15), PMDC.Dungeon.RespawnFromEligibleEvent(14, 160))
  for ii = 1, 3, 1 do
	PMDC.Dungeon.RespawnFromEligibleEvent.Respawn()
  end
end



function SINGLE_CHAR_SCRIPT.SleepingCalderaAltData(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.sleeping_caldera.TookTreasure then
    --keep the map music as is
  else
	_ZONE.CurrentMap.Name = RogueEssence.LocalText(STRINGS:Format(RogueEssence.StringKey("TITLE_ENRAGED_CALDERA"):ToLocal(), _ZONE.CurrentMap.ID + 1))
	_ZONE.CurrentMap.Music = "B11. Enraged Caldera.ogg"
  end
  
  SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
end

function SINGLE_CHAR_SCRIPT.SleepingCalderaAltTiles(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.sleeping_caldera.TookTreasure then
    return
  end
  
  --set all water tiles to lava
  for xx = 0, _ZONE.CurrentMap.Width - 1, 1 do
	for yy = 0, _ZONE.CurrentMap.Height - 1, 1 do
	  local loc = RogueElements.Loc(xx, yy)
	  local tl = _ZONE.CurrentMap:GetTile(loc)
	  if tl.ID == "water" then
		tl.ID = "lava"
		--remove any mons traversing them
		local chara = _ZONE.CurrentMap:GetCharAtLoc(loc)
		if chara ~= nil then
		  if chara.MemberTeam ~= _DUNGEON.ActiveTeam then
			_DUNGEON:RemoveChar(chara)
		  end
		end
	  end
	  --also remove any stairs down
	  if tl.Effect.ID == "stairs_go_down" then
		tl.Effect = RogueEssence.Dungeon.EffectTile(loc)
	  end
	end
  end
  --set the tileset dictionary to lava
  if _ZONE.CurrentMap.ID < 6 then
    _ZONE.CurrentMap.BlankBG = RogueEssence.Dungeon.AutoTile("dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["unbreakable"] = RogueEssence.Dungeon.AutoTile("dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["wall"] = RogueEssence.Dungeon.AutoTile("dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["floor"] = RogueEssence.Dungeon.AutoTile("dark_crater_floor")
  else
    _ZONE.CurrentMap.BlankBG = RogueEssence.Dungeon.AutoTile("deep_dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["unbreakable"] = RogueEssence.Dungeon.AutoTile("deep_dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["wall"] = RogueEssence.Dungeon.AutoTile("deep_dark_crater_wall")
    _ZONE.CurrentMap.TextureMap["floor"] = RogueEssence.Dungeon.AutoTile("deep_dark_crater_floor")
  end
  --call recalculate all autotiles for the entire map
  _ZONE.CurrentMap:CalculateAutotiles(RogueElements.Loc(0, 0), RogueElements.Loc(_ZONE.CurrentMap.Width, _ZONE.CurrentMap.Height))
  _ZONE.CurrentMap:CalculateTerrainAutotiles(RogueElements.Loc(0, 0), RogueElements.Loc(_ZONE.CurrentMap.Width, _ZONE.CurrentMap.Height))
end

function SINGLE_CHAR_SCRIPT.SleepingCalderaAltEnemies(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.sleeping_caldera.TookTreasure then
    return
  end
  
  _ZONE.CurrentMap.MapEffect.OnMapTurnEnds:Add(RogueElements.Priority(15), PMDC.Dungeon.RespawnFromEligibleEvent(15, 50))
  for ii = 1, 3, 1 do
	PMDC.Dungeon.RespawnFromEligibleEvent.Respawn()
  end
end

function SINGLE_CHAR_SCRIPT.SleepingCalderaSummonHeatran(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  if not SV.sleeping_caldera.TookTreasure then
    return
  end
  
  if SV.sleeping_caldera.GotHeatran then
    return
  end
  
  -- spawn heatran- try 10 times; not guaranteed but not crucial
  local origin = _DUNGEON.ActiveTeam.Leader.CharLoc
  for ii = 1, 10, 1 do
    local testLoc = RogueElements.Loc(_DATA.Save.Rand:Next(origin.X - 7, origin.X + 7 + 1), _DATA.Save.Rand:Next(origin.Y - 4, origin.Y + 4 + 1))
	local tile_block = _ZONE.CurrentMap:TileBlocked(testLoc)
	local char_at = _ZONE.CurrentMap:GetCharAtLoc(testLoc)
	if tile_block == false and char_at == nil then
	  --spawn it here
	  DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 30))
	  GAME:WaitFrames(10)
	  
	  local new_team = RogueEssence.Dungeon.MonsterTeam()
	  local mob_data = RogueEssence.Dungeon.CharData()
	  mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("heatran", 0, "normal", Gender.Male)
	  mob_data.Level = 40;
	  mob_data.BaseSkills[0] = RogueEssence.Dungeon.SlotSkill("magma_storm")
	  mob_data.BaseSkills[1] = RogueEssence.Dungeon.SlotSkill("iron_head")
	  mob_data.BaseSkills[2] = RogueEssence.Dungeon.SlotSkill("scary_face")
	  mob_data.BaseSkills[3] = RogueEssence.Dungeon.SlotSkill("crunch")
	  mob_data.BaseIntrinsics[0] = "flash_fire"
	  local new_mob = RogueEssence.Dungeon.Character(mob_data)
	  local tactic = _DATA:GetAITactic("wander_smart")
	  new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
	  new_mob.CharLoc = testLoc
	  new_mob.CharDir = _ZONE.CurrentMap:ApproximateClosestDir8(new_mob.CharLoc, _DUNGEON.ActiveTeam.Leader.CharLoc)
	  new_team.Players:Add(new_mob)
	  player_tbl = LTBL(new_mob)
	  player_tbl.IsLegend = true
	  
	  --with fanfare
	  SOUND:PlayBattleSE("_UNK_EVT_003")
	  local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Sacred_Fire_Ranger", 3), 1)
	  arriveAnim:SetupEmitted(RogueElements.Loc(new_mob.CharLoc.X * 24 + 12, new_mob.CharLoc.Y * 24 + 12), 32, RogueElements.Dir8.Down)
	  DUNGEON:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)
	  
	  GAME:WaitFrames(3)
	  
	  _ZONE.CurrentMap.MapTeams:Add(new_team)
	  new_mob:RefreshTraits()
	  
      TASK:WaitTask(_DUNGEON:SpecialIntro(new_mob))
      TASK:WaitTask(new_mob:OnMapStart())
	  
	  _ZONE.CurrentMap:UpdateExploration(new_mob)
	  
	  break
	end
  end
  
end

function SINGLE_CHAR_SCRIPT.GuildBlock(owner, ownerChar, context, args)
  if not SV.guildmaster_summit.GameComplete then
    UI:ResetSpeaker()
    UI:SetAutoFinish(true)
    UI:WaitShowDialogue(RogueEssence.StringKey("DLG_LOCK_GUILD"):ToLocal())
  else
    UI:ResetSpeaker()
    UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_LOCK_GUILD_OPEN"):ToLocal(), context.User:GetDisplayName(true)))
    TASK:WaitTask(owner:InteractWithTile(context))
  end
end

ShopSecurityType = luanet.import_type('PMDC.Dungeon.ShopSecurityState')
MapIndexType = luanet.import_type('RogueEssence.Dungeon.MapIndexState')


function SINGLE_CHAR_SCRIPT.ThiefCheck(owner, ownerChar, context, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]
  
  local thief_idx = "thief"
  
  local price = COMMON.GetDungeonCartPrice()
  local security_price = COMMON.GetShopPriceState()
  if price < 0 then
    --lost merchandise was placed back in shop, readjust the security price and clear the current price
    security_price.Amount = security_price.Amount - price
  elseif price < security_price.Cart then
    --merchandise was returned.  doesn't matter who did it.
    security_price.Cart = price
  elseif price > security_price.Cart then
    local char_index = _ZONE.CurrentMap:GetCharIndex(context.User)
    if char_index.Faction ~= RogueEssence.Dungeon.Faction.Player then
      --non-player was responsible for taking/destroying merchandise, just readjust the security price and clear the current price
      security_price.Amount = security_price.Amount - price + security_price.Cart
	else
	  --player was responsible for taking/destroying merchandise, add to the cart
      security_price.Cart = price
    end
  end

  
  if tile.Effect.ID ~= "area_shop" then
	if security_price.Cart > 0 then
	  _GAME:BGM("", false)
      COMMON.ClearAllPrices()
	  
	  SV.adventure.Thief = true
	  local index_from = owner.StatusStates:Get(luanet.ctype(MapIndexType))
	  _DUNGEON:LogMsg(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_THIEF_%04d", index_from.Index)):ToLocal()))
		
	  -- create thief status
	  local thief_status = RogueEssence.Dungeon.MapStatus(thief_idx)
      thief_status:LoadFromData()
	  -- put spawner from security status in thief status
	  local security_to = thief_status.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  local security_from = owner.StatusStates:Get(luanet.ctype(ShopSecurityType))
	  security_to.Security = security_from.Security
      TASK:WaitTask(_DUNGEON:RemoveMapStatus(owner.ID))
      TASK:WaitTask(_DUNGEON:AddMapStatus(thief_status))
	  GAME:WaitFrames(60)
	end
  else
    local shop_idx = "shopping"
	if not _ZONE.CurrentMap.Status:ContainsKey(thief_idx) and not _ZONE.CurrentMap.Status:ContainsKey(shop_idx) then
	  
	  local shop_status = RogueEssence.Dungeon.MapStatus(shop_idx)
      shop_status:LoadFromData()
      TASK:WaitTask(_DUNGEON:AddMapStatus(shop_status))
	end
  end
end

function SINGLE_CHAR_SCRIPT.ShopCheckout(owner, ownerChar, context, args)
  local baseLoc = _DUNGEON.ActiveTeam.Leader.CharLoc
  local tile = _ZONE.CurrentMap.Tiles[baseLoc.X][baseLoc.Y]

  if tile.Effect.ID ~= "area_shop" then
	local found_shopkeep = COMMON.FindNpcWithTable(false, "Role", "Shopkeeper")
    if found_shopkeep and COMMON.CanTalk(found_shopkeep) then
	  local security_state = COMMON.GetShopPriceState()
      local price = security_state.Cart
	  local sell_price = COMMON.GetDungeonSellPrice()
  
      if price > 0 or sell_price > 0 then
	    local is_near = false
		local loc_diff = _DUNGEON.ActiveTeam.Leader.CharLoc - found_shopkeep.CharLoc
		if loc_diff:Dist8() > 1 then
		  -- check to see if the shopkeeper can see the player and warp there
		  local near_mat = false
		  local dirs = { Direction.Down, Direction.DownLeft, Direction.Left, Direction.UpLeft, Direction.Up, Direction.UpRight, Direction.Right, Direction.DownRight }
		  for idx, dir in pairs(dirs) do
            if COMMON.ShopTileCheck(baseLoc, dir) then
		      near_mat = true
		    end
		  end
		  
		  if (near_mat or found_shopkeep:CanSeeCharacter(_DUNGEON.ActiveTeam.Leader)) then
	        -- attempt to warp the shopkeeper next to the player
		    local cand_locs = _ZONE.CurrentMap:FindNearLocs(found_shopkeep, baseLoc, 1)
		    if cand_locs.Count > 0 then
		      TASK:WaitTask(_DUNGEON:PointWarp(found_shopkeep, cand_locs[0], false))
			  is_near = true
		    end
		  end
		else
		  is_near = true
		end

		-- if it can't, fall through
		if is_near then
		  DUNGEON:CharTurnToChar(found_shopkeep, _DUNGEON.ActiveTeam.Leader)
		  DUNGEON:CharTurnToChar(_DUNGEON.ActiveTeam.Leader, found_shopkeep)
          UI:SetSpeaker(found_shopkeep)
		  
		  if sell_price > 0 then
		    UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_%04d", found_shopkeep.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", sell_price)), false)
		    UI:WaitForChoice()
		    result = UI:ChoiceResult()
		  
		    if SV.adventure.Thief then
			  COMMON.ThiefReturn()
			  price = 0
		    elseif result then
			  -- iterate player inventory prices and remove total price
			  COMMON.PayDungeonSellPrice(sell_price)
			  SOUND:PlayBattleSE("DUN_Money")
			  UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_SELL_DONE_%04d", found_shopkeep.Discriminator)):ToLocal()))
		    else
			  -- nothing
		    end
		  end
		  
		  if price > 0 then
	        UI:ChoiceMenuYesNo(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_%04d", found_shopkeep.Discriminator)):ToLocal(), STRINGS:FormatKey("MONEY_AMOUNT", price)), false)
	        UI:WaitForChoice()
	        result = UI:ChoiceResult()
	        if SV.adventure.Thief then
			  COMMON.ThiefReturn()
		    elseif result then
	          if price > GAME:GetPlayerMoney() then
                UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_SHORT_%04d", found_shopkeep.Discriminator)):ToLocal()))
	          else
	            -- iterate player inventory prices and remove total price
                COMMON.PayDungeonCartPrice(price)
		        SOUND:PlayBattleSE("DUN_Money")
	            UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_PAY_DONE_%04d", found_shopkeep.Discriminator)):ToLocal()))
	          end
	        end
		  end
		end
      else
        UI:SetSpeaker(found_shopkeep)
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey(string.format("TALK_SHOP_END_%04d", found_shopkeep.Discriminator)):ToLocal()))
      end
	end
  end
end

function SINGLE_CHAR_SCRIPT.UpdateEscort(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  local party = GAME:GetPlayerGuestTable()
  for i, p in ipairs(party) do
    if p.Dead == false then
      local e_tbl = LTBL(p)
	  if e_tbl ~= nil then
	    local mission = SV.missions.Missions[e_tbl.Escort]
	    if mission ~= nil then
	      if mission.Type == COMMON.MISSION_TYPE_ESCORT_OUT then
		    if _ZONE.CurrentMapID.Segment == 0 then
		      mission.DestFloor = _ZONE.CurrentMapID.ID
		    end
	      end
	    end
	  end
	end
  end
end

function SINGLE_CHAR_SCRIPT.DestinationFloor(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  SOUND:PlayFanfare("Fanfare/Note")
  UI:ResetSpeaker()
  UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_DESTINATION"):ToLocal()))
end


function SINGLE_CHAR_SCRIPT.OutlawFloor(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  
  if not args.Silent then
    SOUND:PlayBGM("C07. Outlaw.ogg", false)
    UI:ResetSpeaker()
    UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_OUTLAW"):ToLocal()))
  end
  
  -- add a map status for outlaw clear check
  local checkClearStatus = "outlaw_clear_check" -- outlaw clear check
  local status = RogueEssence.Dungeon.MapStatus(checkClearStatus)
  status:LoadFromData()
  TASK:WaitTask(_DUNGEON:AddMapStatus(status))
end

function SINGLE_CHAR_SCRIPT.OutlawHouse(owner, ownerChar, context, args)
  if context.User ~= nil then
    return
  end
  
  local found_outlaw = COMMON.FindNpcWithTable(true, "Mission", args.Mission)
  found_outlaw.CharDir = _ZONE.CurrentMap:ApproximateClosestDir8(found_outlaw.CharLoc, _DUNGEON.ActiveTeam.Leader.CharLoc)
  UI:SetSpeaker(found_outlaw)
  UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_OUTLAW_TRAP"):ToLocal()))
	
  COMMON.TriggerAdHocMonsterHouse(owner, ownerChar, found_outlaw)
end

function SINGLE_CHAR_SCRIPT.OutlawClearCheck(owner, ownerChar, context, args)
  -- check for no outlaw in the mission list
  remaining_outlaw = false
  for name, mission in pairs(SV.missions.Missions) do
    if mission.Complete == COMMON.MISSION_INCOMPLETE and _ZONE.CurrentZoneID == mission.DestZone
	  and _ZONE.CurrentMapID.Segment == mission.DestSegment and _ZONE.CurrentMapID.ID == mission.DestFloor then
	  local found_outlaw = COMMON.FindNpcWithTable(true, "Mission", name)
	  -- check for disguised outlaws
	  if not found_outlaw then
	    found_outlaw = COMMON.FindNpcWithTable(false, "Mission", name)
	  end
      if found_outlaw then
        remaining_outlaw = true
      else
        -- if no outlaws of the mission list, mark quest as complete
        mission.Complete = COMMON.MISSION_COMPLETE
        UI:ResetSpeaker()
        
        -- retrieve the species of the target
        local target_name = _DATA:GetMonster(mission.TargetSpecies.Species).Name
        -- retrieve the species of the quest giver
        local client_name = _DATA:GetMonster(mission.ClientSpecies.Species).Name
        
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_OUTLAW_DONE"):ToLocal(), target_name:ToLocal()))
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("DLG_MISSION_REMINDER"):ToLocal(), client_name:ToLocal()))
      end
    end
  end
  if not remaining_outlaw then
    -- if no outlaws are found in the map, return music to normal and remove this status from the map
    SOUND:PlayBGM(_ZONE.CurrentMap.Music, true)
    local checkClearStatus = "outlaw_clear_check" -- outlaw clear check
	TASK:WaitTask(_DUNGEON:RemoveMapStatus(checkClearStatus))
  end
end



function SINGLE_CHAR_SCRIPT.ShowTileName(owner, ownerChar, context, args)

    
	if SV.test_grounds.Tileset == 0 then
	  UI:TextPopUp("Tiny Woods", 150)
	elseif SV.test_grounds.Tileset == 1 then
	  UI:TextPopUp("Thunderwave Cave", 150)

	elseif SV.test_grounds.Tileset == 2 then
	  UI:TextPopUp("Mt. Steel", 150)

	elseif SV.test_grounds.Tileset == 3 then
	  UI:TextPopUp("Mt. Steel 2", 150)

	elseif SV.test_grounds.Tileset == 4 then
	  UI:TextPopUp("Grass Maze", 150)

	elseif SV.test_grounds.Tileset == 5 then
	  UI:TextPopUp("Uproar Forest", 150)

	elseif SV.test_grounds.Tileset == 6 then
	  UI:TextPopUp("Electric Maze", 150)

	elseif SV.test_grounds.Tileset == 7 then
	  UI:TextPopUp("Water Maze", 150)

	elseif SV.test_grounds.Tileset == 8 then
	  UI:TextPopUp("Poison Maze", 150)

	elseif SV.test_grounds.Tileset == 9 then
	  UI:TextPopUp("Rock Maze", 150)

	elseif SV.test_grounds.Tileset == 10 then
	  UI:TextPopUp("Silent Chasm", 150)

	elseif SV.test_grounds.Tileset == 11 then
	  UI:TextPopUp("Mt. Thunder", 150)

	elseif SV.test_grounds.Tileset == 12 then
	  UI:TextPopUp("Mt. Thunder Peak", 150)

	elseif SV.test_grounds.Tileset == 13 then
	  UI:TextPopUp("Great Canyon", 150)

	elseif SV.test_grounds.Tileset == 14 then
	  UI:TextPopUp("Lapis Cave", 150)

	elseif SV.test_grounds.Tileset == 15 then
	  UI:TextPopUp("Southern Cavern 2", 150)

	elseif SV.test_grounds.Tileset == 16 then
	  UI:TextPopUp("Wish Cave 2", 150)

	elseif SV.test_grounds.Tileset == 17 then
	  UI:TextPopUp("Rock Path", 150)

	elseif SV.test_grounds.Tileset == 18 then
	  UI:TextPopUp("Northern Range", 150)

	elseif SV.test_grounds.Tileset == 19 then
	  UI:TextPopUp("Mt. Blaze", 150)

	elseif SV.test_grounds.Tileset == 20 then
	  UI:TextPopUp("Snow Path", 150)

	elseif SV.test_grounds.Tileset == 21 then
	  UI:TextPopUp("Frosty Forest", 150)

	elseif SV.test_grounds.Tileset == 22 then
	  UI:TextPopUp("Mt. Freeze", 150)

	elseif SV.test_grounds.Tileset == 23 then
	  UI:TextPopUp("Ice Maze", 150)

	elseif SV.test_grounds.Tileset == 24 then
	  UI:TextPopUp("Magma Cavern 2", 150)

	elseif SV.test_grounds.Tileset == 25 then
	  UI:TextPopUp("Magma Cavern 3", 150)

	elseif SV.test_grounds.Tileset == 26 then
	  UI:TextPopUp("Howling Forest 2", 150)

	elseif SV.test_grounds.Tileset == 27 then
	  UI:TextPopUp("Sky Tower", 150)

	elseif SV.test_grounds.Tileset == 28 then
	  UI:TextPopUp("Darknight Relic", 150)

	elseif SV.test_grounds.Tileset == 29 then
	  UI:TextPopUp("Desert Region", 150)

	elseif SV.test_grounds.Tileset == 30 then
	  UI:TextPopUp("Howling Forest", 150)

	elseif SV.test_grounds.Tileset == 31 then
	  UI:TextPopUp("Southern Cavern", 150)

	elseif SV.test_grounds.Tileset == 32 then
	  UI:TextPopUp("Wyvern Hill", 150)

	elseif SV.test_grounds.Tileset == 33 then
	  UI:TextPopUp("Solar Cave", 150)

	elseif SV.test_grounds.Tileset == 34 then
	  UI:TextPopUp("Waterfall Pond", 150)

	elseif SV.test_grounds.Tileset == 35 then
	  UI:TextPopUp("Stormy Sea", 150)

	elseif SV.test_grounds.Tileset == 36 then
	  UI:TextPopUp("Stormy Sea 2", 150)

	elseif SV.test_grounds.Tileset == 37 then
	  UI:TextPopUp("Silver Trench 3", 150)

	elseif SV.test_grounds.Tileset == 38 then
	  UI:TextPopUp("Buried Relic", 150)

	elseif SV.test_grounds.Tileset == 39 then
	  UI:TextPopUp("Buried Relic 2", 150)

	elseif SV.test_grounds.Tileset == 40 then
	  UI:TextPopUp("Buried Relic 3", 150)

	elseif SV.test_grounds.Tileset == 41 then
	  UI:TextPopUp("Lightning Field", 150)

	elseif SV.test_grounds.Tileset == 42 then
	  UI:TextPopUp("Northwind Field", 150)

	elseif SV.test_grounds.Tileset == 43 then
	  UI:TextPopUp("Mt. Faraway 2", 150)

	elseif SV.test_grounds.Tileset == 44 then
	  UI:TextPopUp("Mt. Faraway 4", 150)

	elseif SV.test_grounds.Tileset == 45 then
	  UI:TextPopUp("Northern Range 2", 150)

	elseif SV.test_grounds.Tileset == 46 then
	  UI:TextPopUp("Pitfall Valley", 150)

	elseif SV.test_grounds.Tileset == 47 then
	  UI:TextPopUp("Wish Cave", 150)

	elseif SV.test_grounds.Tileset == 48 then
	  UI:TextPopUp("Joyous Tower", 150)

	elseif SV.test_grounds.Tileset == 49 then
	  UI:TextPopUp("Purity Forest 2", 150)

	elseif SV.test_grounds.Tileset == 50 then
	  UI:TextPopUp("Purity Forest 4", 150)

	elseif SV.test_grounds.Tileset == 51 then
	  UI:TextPopUp("Purity Forest 6", 150)

	elseif SV.test_grounds.Tileset == 52 then
	  UI:TextPopUp("Purity Forest 7", 150)

	elseif SV.test_grounds.Tileset == 53 then
	  UI:TextPopUp("Purity Forest 8", 150)

	elseif SV.test_grounds.Tileset == 54 then
	  UI:TextPopUp("Purity Forest 9", 150)

	elseif SV.test_grounds.Tileset == 55 then
	  UI:TextPopUp("Murky Cave", 150)

	elseif SV.test_grounds.Tileset == 56 then
	  UI:TextPopUp("Western Cave", 150)

	elseif SV.test_grounds.Tileset == 57 then
	  UI:TextPopUp("Western Cave 2", 150)

	elseif SV.test_grounds.Tileset == 58 then
	  UI:TextPopUp("Meteor Cave", 150)

	elseif SV.test_grounds.Tileset == 59 then
	  UI:TextPopUp("Rescue Team Maze", 150)

	elseif SV.test_grounds.Tileset == 60 then
	  UI:TextPopUp("Beach Cave", 150)

	elseif SV.test_grounds.Tileset == 61 then
	  UI:TextPopUp("Drenched Bluffs", 150)

	elseif SV.test_grounds.Tileset == 62 then
	  UI:TextPopUp("Mt. Bristle", 150)

	elseif SV.test_grounds.Tileset == 63 then
	  UI:TextPopUp("Waterfall Cave", 150)

	elseif SV.test_grounds.Tileset == 64 then
	  UI:TextPopUp("Apple Woods", 150)

	elseif SV.test_grounds.Tileset == 65 then
	  UI:TextPopUp("Craggy Coast", 150)

	elseif SV.test_grounds.Tileset == 66 then
	  UI:TextPopUp("Side Path", 150)

	elseif SV.test_grounds.Tileset == 67 then
	  UI:TextPopUp("Mt. Horn", 150)

	elseif SV.test_grounds.Tileset == 68 then
	  UI:TextPopUp("Rock Path (PMD2)", 150)

	elseif SV.test_grounds.Tileset == 69 then
	  UI:TextPopUp("Foggy Forest", 150)

	elseif SV.test_grounds.Tileset == 70 then
	  UI:TextPopUp("Forest Path", 150)

	elseif SV.test_grounds.Tileset == 71 then
	  UI:TextPopUp("Steam Cave", 150)

	elseif SV.test_grounds.Tileset == 72 then
	  UI:TextPopUp("Steam Cave Unused", 150)

	elseif SV.test_grounds.Tileset == 73 then
	  UI:TextPopUp("Amp Plains", 150)

	elseif SV.test_grounds.Tileset == 74 then
	  UI:TextPopUp("Far Amp Plains", 150)

	elseif SV.test_grounds.Tileset == 75 then
	  UI:TextPopUp("Northern Desert", 150)

	elseif SV.test_grounds.Tileset == 76 then
	  UI:TextPopUp("Northern Desert 2", 150)

	elseif SV.test_grounds.Tileset == 77 then
	  UI:TextPopUp("Quicksand Cave", 150)

	elseif SV.test_grounds.Tileset == 78 then
	  UI:TextPopUp("Quicksand Pit", 150)

	elseif SV.test_grounds.Tileset == 79 then
	  UI:TextPopUp("Quicksand Pit Unused", 150)

	elseif SV.test_grounds.Tileset == 80 then
	  UI:TextPopUp("Crystal Cave", 150)

	elseif SV.test_grounds.Tileset == 81 then
	  UI:TextPopUp("Crystal Cave 2", 150)

	elseif SV.test_grounds.Tileset == 82 then
	  UI:TextPopUp("Crystal Crossing", 150)

	elseif SV.test_grounds.Tileset == 83 then
	  UI:TextPopUp("Chasm Cave", 150)

	elseif SV.test_grounds.Tileset == 84 then
	  UI:TextPopUp("Chasm Cave 2", 150)

	elseif SV.test_grounds.Tileset == 85 then
	  UI:TextPopUp("Dark Hill", 150)

	elseif SV.test_grounds.Tileset == 86 then
	  UI:TextPopUp("Dark Hill 2", 150)

	elseif SV.test_grounds.Tileset == 87 then
	  UI:TextPopUp("Sealed Ruin", 150)

	elseif SV.test_grounds.Tileset == 88 then
	  UI:TextPopUp("Deep Sealed Ruin", 150)

	elseif SV.test_grounds.Tileset == 89 then
	  UI:TextPopUp("Dusk Forest", 150)

	elseif SV.test_grounds.Tileset == 90 then
	  UI:TextPopUp("Dusk Forest 2", 150)

	elseif SV.test_grounds.Tileset == 91 then
	  UI:TextPopUp("Deep Dusk Forest", 150)

	elseif SV.test_grounds.Tileset == 92 then
	  UI:TextPopUp("Deep Dusk Forest 2", 150)

	elseif SV.test_grounds.Tileset == 93 then
	  UI:TextPopUp("Treeshroud Forest", 150)

	elseif SV.test_grounds.Tileset == 94 then
	  UI:TextPopUp("Treeshroud Forest 2", 150)

	elseif SV.test_grounds.Tileset == 95 then
	  UI:TextPopUp("Brine Cave", 150)

	elseif SV.test_grounds.Tileset == 96 then
	  UI:TextPopUp("Lower Brine Cave", 150)

	elseif SV.test_grounds.Tileset == 97 then
	  UI:TextPopUp("Brine Cave Unused", 150)

	elseif SV.test_grounds.Tileset == 98 then
	  UI:TextPopUp("Hidden Land", 150)

	elseif SV.test_grounds.Tileset == 99 then
	  UI:TextPopUp("Hidden Highland", 150)

	elseif SV.test_grounds.Tileset == 100 then
	  UI:TextPopUp("Temporal Tower", 150)

	elseif SV.test_grounds.Tileset == 101 then
	  UI:TextPopUp("Temporal Spire", 150)

	elseif SV.test_grounds.Tileset == 102 then
	  UI:TextPopUp("Temporal Tower Unused", 150)

	elseif SV.test_grounds.Tileset == 103 then
	  UI:TextPopUp("Mystifying Forest", 150)

	elseif SV.test_grounds.Tileset == 104 then
	  UI:TextPopUp("Southern Jungle", 150)

	elseif SV.test_grounds.Tileset == 105 then
	  UI:TextPopUp("Concealed Ruins", 150)

	elseif SV.test_grounds.Tileset == 106 then
	  UI:TextPopUp("Surrounded Sea", 150)

	elseif SV.test_grounds.Tileset == 107 then
	  UI:TextPopUp("Miracle Sea", 150)

	elseif SV.test_grounds.Tileset == 108 then
	  UI:TextPopUp("Mt. Travail", 150)

	elseif SV.test_grounds.Tileset == 109 then
	  UI:TextPopUp("The Nightmare", 150)

	elseif SV.test_grounds.Tileset == 110 then
	  UI:TextPopUp("Spacial Rift", 150)

	elseif SV.test_grounds.Tileset == 111 then
	  UI:TextPopUp("Spacial Rift 2", 150)

	elseif SV.test_grounds.Tileset == 112 then
	  UI:TextPopUp("Dark Crater", 150)

	elseif SV.test_grounds.Tileset == 113 then
	  UI:TextPopUp("Deep Dark Crater", 150)

	elseif SV.test_grounds.Tileset == 114 then
	  UI:TextPopUp("World Abyss 2", 150)

	elseif SV.test_grounds.Tileset == 115 then
	  UI:TextPopUp("Golden Chamber", 150)

	elseif SV.test_grounds.Tileset == 116 then
	  UI:TextPopUp("Mystery Jungle", 150)

	elseif SV.test_grounds.Tileset == 117 then
	  UI:TextPopUp("Mystery Jungle 2", 150)

	elseif SV.test_grounds.Tileset == 118 then
	  UI:TextPopUp("Zero Isle East 3", 150)

	elseif SV.test_grounds.Tileset == 119 then
	  UI:TextPopUp("Zero Isle East 4", 150)

	elseif SV.test_grounds.Tileset == 120 then
	  UI:TextPopUp("Zero Isle South", 150)

	elseif SV.test_grounds.Tileset == 121 then
	  UI:TextPopUp("Zero Isle South 2", 150)

	elseif SV.test_grounds.Tileset == 122 then
	  UI:TextPopUp("Tiny Meadow", 150)

	elseif SV.test_grounds.Tileset == 123 then
	  UI:TextPopUp("Final Maze 2", 150)

	elseif SV.test_grounds.Tileset == 124 then
	  UI:TextPopUp("Waterfall Pond Unused", 150)

	elseif SV.test_grounds.Tileset == 125 then
	  UI:TextPopUp("Lush Prairie", 150)

	elseif SV.test_grounds.Tileset == 126 then
	  UI:TextPopUp("Rock Aegis Cave", 150)

	elseif SV.test_grounds.Tileset == 127 then
	  UI:TextPopUp("Ice Aegis Cave", 150)

	elseif SV.test_grounds.Tileset == 128 then
	  UI:TextPopUp("Steel Aegis Cave", 150)

	elseif SV.test_grounds.Tileset == 129 then
	  UI:TextPopUp("Murky Forest", 150)

	elseif SV.test_grounds.Tileset == 130 then
	  UI:TextPopUp("Deep Boulder Quarry", 150)

	elseif SV.test_grounds.Tileset == 131 then
	  UI:TextPopUp("Limestone Cavern", 150)

	elseif SV.test_grounds.Tileset == 132 then
	  UI:TextPopUp("Deep Limestone Cavern", 150)

	elseif SV.test_grounds.Tileset == 133 then
	  UI:TextPopUp("Barren Valley", 150)

	elseif SV.test_grounds.Tileset == 134 then
	  UI:TextPopUp("Dark Wasteland", 150)

	elseif SV.test_grounds.Tileset == 135 then
	  UI:TextPopUp("Temporal Tower (Future of Darkness)", 150)

	elseif SV.test_grounds.Tileset == 136 then
	  UI:TextPopUp("Temporal Spire (Future of Darkness)", 150)

	elseif SV.test_grounds.Tileset == 137 then
	  UI:TextPopUp("Spacial Cliffs", 150)

	elseif SV.test_grounds.Tileset == 138 then
	  UI:TextPopUp("Dark Ice Mountain", 150)

	elseif SV.test_grounds.Tileset == 139 then
	  UI:TextPopUp("Dark Ice Mountain Peak", 150)

	elseif SV.test_grounds.Tileset == 140 then
	  UI:TextPopUp("Icicle Forest", 150)

	elseif SV.test_grounds.Tileset == 141 then
	  UI:TextPopUp("Vast Ice Mountain", 150)

	elseif SV.test_grounds.Tileset == 142 then
	  UI:TextPopUp("Vast Ice Mountain Peak", 150)

	elseif SV.test_grounds.Tileset == 143 then
	  UI:TextPopUp("Sky Peak 4th Pass", 150)

	elseif SV.test_grounds.Tileset == 144 then
	  UI:TextPopUp("Sky Peak 7th Pass", 150)

	elseif SV.test_grounds.Tileset == 145 then
	  UI:TextPopUp("Sky Peak Summit Pass", 150)

	elseif SV.test_grounds.Tileset == 146 then
	  UI:TextPopUp("Test Dungeon", 150)

	end
end

function SINGLE_CHAR_SCRIPT.SetTileData(wall, ground, water)
  
    _ZONE.CurrentMap.TextureMap["wall"] = RogueEssence.Dungeon.AutoTile(wall)
    _ZONE.CurrentMap.TextureMap["floor"] = RogueEssence.Dungeon.AutoTile(ground)
    _ZONE.CurrentMap.TextureMap["water"] = RogueEssence.Dungeon.AutoTile(water)
  
  --call recalculate all autotiles for the entire map
  _ZONE.CurrentMap:CalculateTerrainAutotiles(RogueElements.Loc(0, 0), RogueElements.Loc(_ZONE.CurrentMap.Width, _ZONE.CurrentMap.Height))
end

function SINGLE_CHAR_SCRIPT.TileTestChange(owner, ownerChar, context, args)

  SV.test_grounds.Tileset = SV.test_grounds.Tileset + 1
  
	if SV.test_grounds.Tileset == 1 then

	  SINGLE_CHAR_SCRIPT.SetTileData("thunderwave_cave_wall", "thunderwave_cave_floor", "thunderwave_cave_secondary")
	elseif SV.test_grounds.Tileset == 2 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_steel_1_wall", "mt_steel_1_floor", "mt_steel_1_secondary")
	elseif SV.test_grounds.Tileset == 3 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_steel_2_wall", "mt_steel_2_floor", "mt_steel_2_secondary")
	elseif SV.test_grounds.Tileset == 4 then

	  SINGLE_CHAR_SCRIPT.SetTileData("grass_maze_wall", "grass_maze_floor", "grass_maze_secondary")
	elseif SV.test_grounds.Tileset == 5 then

	  SINGLE_CHAR_SCRIPT.SetTileData("uproar_forest_wall", "uproar_forest_floor", "uproar_forest_secondary")
	elseif SV.test_grounds.Tileset == 6 then

	  SINGLE_CHAR_SCRIPT.SetTileData("electric_maze_wall", "electric_maze_floor", "electric_maze_secondary")
	elseif SV.test_grounds.Tileset == 7 then

	  SINGLE_CHAR_SCRIPT.SetTileData("water_maze_wall", "water_maze_floor", "water_maze_secondary")
	elseif SV.test_grounds.Tileset == 8 then

	  SINGLE_CHAR_SCRIPT.SetTileData("poison_maze_wall", "poison_maze_floor", "poison_maze_secondary")
	elseif SV.test_grounds.Tileset == 9 then

	  SINGLE_CHAR_SCRIPT.SetTileData("rock_maze_wall", "rock_maze_floor", "rock_maze_secondary")
	elseif SV.test_grounds.Tileset == 10 then

	  SINGLE_CHAR_SCRIPT.SetTileData("silent_chasm_wall", "silent_chasm_floor", "silent_chasm_secondary")
	elseif SV.test_grounds.Tileset == 11 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_thunder_wall", "mt_thunder_floor", "mt_thunder_secondary")
	elseif SV.test_grounds.Tileset == 12 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_thunder_peak_wall", "mt_thunder_peak_floor", "mt_thunder_peak_secondary")
	elseif SV.test_grounds.Tileset == 13 then
	  SOUND:PlayBGM("Great Canyon.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("great_canyon_wall", "great_canyon_floor", "great_canyon_secondary")
	elseif SV.test_grounds.Tileset == 14 then

	  SINGLE_CHAR_SCRIPT.SetTileData("lapis_cave_wall", "lapis_cave_floor", "lapis_cave_secondary")
	elseif SV.test_grounds.Tileset == 15 then

	  SINGLE_CHAR_SCRIPT.SetTileData("southern_cavern_2_wall", "southern_cavern_2_floor", "southern_cavern_2_secondary")
	elseif SV.test_grounds.Tileset == 16 then

	  SINGLE_CHAR_SCRIPT.SetTileData("wish_cave_2_wall", "wish_cave_2_floor", "wish_cave_2_secondary")
	elseif SV.test_grounds.Tileset == 17 then

	  SINGLE_CHAR_SCRIPT.SetTileData("rock_path_rb_wall", "rock_path_rb_floor", "rock_path_rb_secondary")
	elseif SV.test_grounds.Tileset == 18 then

	  SINGLE_CHAR_SCRIPT.SetTileData("northern_range_1_wall", "northern_range_1_floor", "northern_range_1_secondary")
	elseif SV.test_grounds.Tileset == 19 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_blaze_wall", "mt_blaze_floor", "mt_blaze_secondary")
	elseif SV.test_grounds.Tileset == 20 then

	  SINGLE_CHAR_SCRIPT.SetTileData("snow_path_wall", "snow_path_floor", "snow_path_secondary")
	elseif SV.test_grounds.Tileset == 21 then

	  SINGLE_CHAR_SCRIPT.SetTileData("frosty_forest_wall", "frosty_forest_floor", "frosty_forest_secondary")
	elseif SV.test_grounds.Tileset == 22 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_freeze_wall", "mt_freeze_floor", "mt_freeze_secondary")
	elseif SV.test_grounds.Tileset == 23 then

	  SINGLE_CHAR_SCRIPT.SetTileData("ice_maze_wall", "ice_maze_floor", "ice_maze_secondary")
	elseif SV.test_grounds.Tileset == 24 then

	  SINGLE_CHAR_SCRIPT.SetTileData("magma_cavern_2_wall", "magma_cavern_2_floor", "magma_cavern_2_secondary")
	elseif SV.test_grounds.Tileset == 25 then

	  SINGLE_CHAR_SCRIPT.SetTileData("magma_cavern_3_wall", "magma_cavern_3_floor", "magma_cavern_3_secondary")
	elseif SV.test_grounds.Tileset == 26 then

	  SINGLE_CHAR_SCRIPT.SetTileData("howling_forest_2_wall", "howling_forest_2_floor", "howling_forest_2_secondary")
	elseif SV.test_grounds.Tileset == 27 then
	  SOUND:PlayBGM("Sky Tower.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("sky_tower_wall", "sky_tower_floor", "sky_tower_secondary")
	elseif SV.test_grounds.Tileset == 28 then

	  SINGLE_CHAR_SCRIPT.SetTileData("darknight_relic_wall", "darknight_relic_floor", "darknight_relic_secondary")
	elseif SV.test_grounds.Tileset == 29 then

	  SINGLE_CHAR_SCRIPT.SetTileData("desert_region_wall", "desert_region_floor", "desert_region_secondary")
	elseif SV.test_grounds.Tileset == 30 then

	  SINGLE_CHAR_SCRIPT.SetTileData("howling_forest_1_wall", "howling_forest_1_floor", "howling_forest_1_secondary")
	elseif SV.test_grounds.Tileset == 31 then

	  SINGLE_CHAR_SCRIPT.SetTileData("southern_cavern_1_wall", "southern_cavern_1_floor", "southern_cavern_1_secondary")
	elseif SV.test_grounds.Tileset == 32 then

	  SINGLE_CHAR_SCRIPT.SetTileData("wyvern_hill_wall", "wyvern_hill_floor", "wyvern_hill_secondary")
	elseif SV.test_grounds.Tileset == 33 then

	  SINGLE_CHAR_SCRIPT.SetTileData("solar_cave_1_wall", "solar_cave_1_floor", "solar_cave_1_secondary")
	elseif SV.test_grounds.Tileset == 34 then

	  SINGLE_CHAR_SCRIPT.SetTileData("waterfall_pond_wall", "waterfall_pond_floor", "waterfall_pond_secondary")
	elseif SV.test_grounds.Tileset == 35 then

	  SINGLE_CHAR_SCRIPT.SetTileData("stormy_sea_1_wall", "stormy_sea_1_floor", "stormy_sea_1_secondary")
	elseif SV.test_grounds.Tileset == 36 then

	  SINGLE_CHAR_SCRIPT.SetTileData("stormy_sea_2_wall", "stormy_sea_2_floor", "stormy_sea_2_secondary")
	elseif SV.test_grounds.Tileset == 37 then

	  SINGLE_CHAR_SCRIPT.SetTileData("silver_trench_3_wall", "silver_trench_3_floor", "silver_trench_3_secondary")
	elseif SV.test_grounds.Tileset == 38 then

	  SINGLE_CHAR_SCRIPT.SetTileData("buried_relic_1_wall", "buried_relic_1_floor", "buried_relic_1_secondary")
	elseif SV.test_grounds.Tileset == 39 then

	  SINGLE_CHAR_SCRIPT.SetTileData("buried_relic_2_wall", "buried_relic_2_floor", "buried_relic_2_secondary")
	elseif SV.test_grounds.Tileset == 40 then

	  SINGLE_CHAR_SCRIPT.SetTileData("buried_relic_3_wall", "buried_relic_3_floor", "buried_relic_3_secondary")
	elseif SV.test_grounds.Tileset == 41 then

	  SINGLE_CHAR_SCRIPT.SetTileData("lightning_field_wall", "lightning_field_floor", "lightning_field_secondary")
	elseif SV.test_grounds.Tileset == 42 then

	  SINGLE_CHAR_SCRIPT.SetTileData("northwind_field_wall", "northwind_field_floor", "northwind_field_secondary")
	elseif SV.test_grounds.Tileset == 43 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_faraway_2_wall", "mt_faraway_2_floor", "mt_faraway_2_secondary")
	elseif SV.test_grounds.Tileset == 44 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_faraway_4_wall", "mt_faraway_4_floor", "mt_faraway_4_secondary")
	elseif SV.test_grounds.Tileset == 45 then

	  SINGLE_CHAR_SCRIPT.SetTileData("northern_range_2_wall", "northern_range_2_floor", "northern_range_2_secondary")
	elseif SV.test_grounds.Tileset == 46 then

	  SINGLE_CHAR_SCRIPT.SetTileData("pitfall_valley_1_wall", "pitfall_valley_1_floor", "pitfall_valley_1_secondary")
	elseif SV.test_grounds.Tileset == 47 then
	  SOUND:PlayBGM("Buried Relic.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("wish_cave_1_wall", "wish_cave_1_floor", "wish_cave_1_secondary")
	elseif SV.test_grounds.Tileset == 48 then

	  SINGLE_CHAR_SCRIPT.SetTileData("joyous_tower_wall", "joyous_tower_floor", "joyous_tower_secondary")
	elseif SV.test_grounds.Tileset == 49 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_2_wall", "purity_forest_2_floor", "purity_forest_2_secondary")
	elseif SV.test_grounds.Tileset == 50 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_4_wall", "purity_forest_4_floor", "purity_forest_4_secondary")
	elseif SV.test_grounds.Tileset == 51 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_6_wall", "purity_forest_6_floor", "purity_forest_6_secondary")
	elseif SV.test_grounds.Tileset == 52 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_7_wall", "purity_forest_7_floor", "purity_forest_7_secondary")
	elseif SV.test_grounds.Tileset == 53 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_8_wall", "purity_forest_8_floor", "purity_forest_8_secondary")
	elseif SV.test_grounds.Tileset == 54 then

	  SINGLE_CHAR_SCRIPT.SetTileData("purity_forest_9_wall", "purity_forest_9_floor", "purity_forest_9_secondary")
	elseif SV.test_grounds.Tileset == 55 then

	  SINGLE_CHAR_SCRIPT.SetTileData("murky_cave_wall", "murky_cave_floor", "murky_cave_secondary")
	elseif SV.test_grounds.Tileset == 56 then

	  SINGLE_CHAR_SCRIPT.SetTileData("western_cave_1_wall", "western_cave_1_floor", "western_cave_1_secondary")
	elseif SV.test_grounds.Tileset == 57 then

	  SINGLE_CHAR_SCRIPT.SetTileData("western_cave_2_wall", "western_cave_2_floor", "western_cave_2_secondary")
	elseif SV.test_grounds.Tileset == 58 then

	  SINGLE_CHAR_SCRIPT.SetTileData("meteor_cave_wall", "meteor_cave_floor", "meteor_cave_secondary")
	elseif SV.test_grounds.Tileset == 59 then

	  SINGLE_CHAR_SCRIPT.SetTileData("rescue_team_maze_wall", "rescue_team_maze_floor", "rescue_team_maze_secondary")
	elseif SV.test_grounds.Tileset == 60 then
	  SOUND:PlayBGM("B04. Tropical Path.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("beach_cave_wall", "beach_cave_floor", "beach_cave_secondary")
	elseif SV.test_grounds.Tileset == 61 then

	  SINGLE_CHAR_SCRIPT.SetTileData("drenched_bluff_wall", "drenched_bluff_floor", "drenched_bluff_secondary")
	elseif SV.test_grounds.Tileset == 62 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_bristle_wall", "mt_bristle_floor", "mt_bristle_secondary")
	elseif SV.test_grounds.Tileset == 63 then

	  SINGLE_CHAR_SCRIPT.SetTileData("waterfall_cave_wall", "waterfall_cave_floor", "waterfall_cave_secondary")
	elseif SV.test_grounds.Tileset == 64 then

	  SINGLE_CHAR_SCRIPT.SetTileData("apple_woods_wall", "apple_woods_floor", "apple_woods_secondary")
	elseif SV.test_grounds.Tileset == 65 then

	  SINGLE_CHAR_SCRIPT.SetTileData("craggy_coast_wall", "craggy_coast_floor", "craggy_coast_secondary")
	elseif SV.test_grounds.Tileset == 66 then

	  SINGLE_CHAR_SCRIPT.SetTileData("side_path_wall", "side_path_floor", "side_path_secondary")
	elseif SV.test_grounds.Tileset == 67 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_horn_wall", "mt_horn_floor", "mt_horn_secondary")
	elseif SV.test_grounds.Tileset == 68 then

	  SINGLE_CHAR_SCRIPT.SetTileData("rock_path_tds_wall", "rock_path_tds_floor", "rock_path_tds_secondary")
	elseif SV.test_grounds.Tileset == 69 then

	  SINGLE_CHAR_SCRIPT.SetTileData("foggy_forest_wall", "foggy_forest_floor", "foggy_forest_secondary")
	elseif SV.test_grounds.Tileset == 70 then

	  SINGLE_CHAR_SCRIPT.SetTileData("forest_path_wall", "forest_path_floor", "forest_path_secondary")
	elseif SV.test_grounds.Tileset == 71 then

	  SINGLE_CHAR_SCRIPT.SetTileData("steam_cave_wall", "steam_cave_floor", "steam_cave_secondary")
	elseif SV.test_grounds.Tileset == 72 then

	  SINGLE_CHAR_SCRIPT.SetTileData("unused_steam_cave_wall", "unused_steam_cave_floor", "unused_steam_cave_secondary")
	elseif SV.test_grounds.Tileset == 73 then
	  SOUND:PlayBGM("B10. Thunderstruck Pass.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("amp_plains_wall", "amp_plains_floor", "amp_plains_secondary")
	elseif SV.test_grounds.Tileset == 74 then

	  SINGLE_CHAR_SCRIPT.SetTileData("far_amp_plains_wall", "far_amp_plains_floor", "far_amp_plains_secondary")
	elseif SV.test_grounds.Tileset == 75 then

	  SINGLE_CHAR_SCRIPT.SetTileData("northern_desert_1_wall", "northern_desert_1_floor", "northern_desert_1_secondary")
	elseif SV.test_grounds.Tileset == 76 then

	  SINGLE_CHAR_SCRIPT.SetTileData("northern_desert_2_wall", "northern_desert_2_floor", "northern_desert_2_secondary")
	elseif SV.test_grounds.Tileset == 77 then

	  SINGLE_CHAR_SCRIPT.SetTileData("quicksand_cave_wall", "quicksand_cave_floor", "quicksand_cave_secondary")
	elseif SV.test_grounds.Tileset == 78 then

	  SINGLE_CHAR_SCRIPT.SetTileData("quicksand_pit_wall", "quicksand_pit_floor", "quicksand_pit_secondary")
	elseif SV.test_grounds.Tileset == 79 then

	  SINGLE_CHAR_SCRIPT.SetTileData("quicksand_unused_wall", "quicksand_unused_floor", "quicksand_unused_secondary")
	elseif SV.test_grounds.Tileset == 80 then

	  SINGLE_CHAR_SCRIPT.SetTileData("crystal_cave_1_wall", "crystal_cave_1_floor", "crystal_cave_1_secondary")
	elseif SV.test_grounds.Tileset == 81 then

	  SINGLE_CHAR_SCRIPT.SetTileData("crystal_cave_2_wall", "crystal_cave_2_floor", "crystal_cave_2_secondary")
	elseif SV.test_grounds.Tileset == 82 then

	  SINGLE_CHAR_SCRIPT.SetTileData("crystal_crossing_wall", "crystal_crossing_floor", "crystal_crossing_secondary")
	elseif SV.test_grounds.Tileset == 83 then
	  SOUND:PlayBGM("B29. Treacherous Mountain.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("chasm_cave_1_wall", "chasm_cave_1_floor", "chasm_cave_1_floor")
	elseif SV.test_grounds.Tileset == 84 then

	  SINGLE_CHAR_SCRIPT.SetTileData("chasm_cave_2_wall", "chasm_cave_2_floor", "chasm_cave_2_floor")
	elseif SV.test_grounds.Tileset == 85 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_hill_1_wall", "dark_hill_1_floor", "dark_hill_1_secondary")
	elseif SV.test_grounds.Tileset == 86 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_hill_2_wall", "dark_hill_2_floor", "dark_hill_2_secondary")
	elseif SV.test_grounds.Tileset == 87 then

	  SINGLE_CHAR_SCRIPT.SetTileData("sealed_ruin_wall", "sealed_ruin_floor", "sealed_ruin_secondary")
	elseif SV.test_grounds.Tileset == 88 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_sealed_ruin_wall", "deep_sealed_ruin_floor", "deep_sealed_ruin_secondary")
	elseif SV.test_grounds.Tileset == 89 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dusk_forest_1_wall", "dusk_forest_1_floor", "dusk_forest_1_secondary")
	elseif SV.test_grounds.Tileset == 90 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dusk_forest_2_wall", "dusk_forest_2_floor", "dusk_forest_2_secondary")
	elseif SV.test_grounds.Tileset == 91 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_dusk_forest_1_wall", "deep_dusk_forest_1_floor", "deep_dusk_forest_1_secondary")
	elseif SV.test_grounds.Tileset == 92 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_dusk_forest_2_wall", "deep_dusk_forest_2_floor", "deep_dusk_forest_2_secondary")
	elseif SV.test_grounds.Tileset == 93 then

	  SINGLE_CHAR_SCRIPT.SetTileData("treeshroud_forest_1_wall", "treeshroud_forest_1_floor", "treeshroud_forest_1_secondary")
	elseif SV.test_grounds.Tileset == 94 then

	  SINGLE_CHAR_SCRIPT.SetTileData("treeshroud_forest_2_wall", "treeshroud_forest_2_floor", "treeshroud_forest_2_secondary")
	elseif SV.test_grounds.Tileset == 95 then

	  SINGLE_CHAR_SCRIPT.SetTileData("brine_cave_wall", "brine_cave_floor", "brine_cave_secondary")
	elseif SV.test_grounds.Tileset == 96 then

	  SINGLE_CHAR_SCRIPT.SetTileData("lower_brine_cave_wall", "lower_brine_cave_floor", "lower_brine_cave_secondary")
	elseif SV.test_grounds.Tileset == 97 then

	  SINGLE_CHAR_SCRIPT.SetTileData("unused_brine_cave_wall", "unused_brine_cave_floor", "unused_brine_cave_secondary")
	elseif SV.test_grounds.Tileset == 98 then

	  SINGLE_CHAR_SCRIPT.SetTileData("hidden_land_wall", "hidden_land_floor", "hidden_land_secondary")
	elseif SV.test_grounds.Tileset == 99 then

	  SINGLE_CHAR_SCRIPT.SetTileData("hidden_highland_wall", "hidden_highland_floor", "hidden_highland_secondary")
	elseif SV.test_grounds.Tileset == 100 then
	  SOUND:PlayBGM("Temporal Tower.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("temporal_tower_wall", "temporal_tower_floor", "temporal_tower_secondary")
	elseif SV.test_grounds.Tileset == 101 then

	  SINGLE_CHAR_SCRIPT.SetTileData("temporal_spire_wall", "temporal_spire_floor", "temporal_spire_secondary")
	elseif SV.test_grounds.Tileset == 102 then

	  SINGLE_CHAR_SCRIPT.SetTileData("temporal_unused_wall", "temporal_unused_floor", "temporal_unused_secondary")
	elseif SV.test_grounds.Tileset == 103 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mystifying_forest_wall", "mystifying_forest_floor", "mystifying_forest_secondary")
	elseif SV.test_grounds.Tileset == 104 then

	  SINGLE_CHAR_SCRIPT.SetTileData("southern_jungle_wall", "southern_jungle_floor", "southern_jungle_secondary")
	elseif SV.test_grounds.Tileset == 105 then

	  SINGLE_CHAR_SCRIPT.SetTileData("concealed_ruins_wall", "concealed_ruins_floor", "concealed_ruins_secondary")
	elseif SV.test_grounds.Tileset == 106 then

	  SINGLE_CHAR_SCRIPT.SetTileData("surrounded_sea_wall", "surrounded_sea_floor", "surrounded_sea_secondary")
	elseif SV.test_grounds.Tileset == 107 then

	  SINGLE_CHAR_SCRIPT.SetTileData("miracle_sea_wall", "miracle_sea_floor", "miracle_sea_secondary")
	elseif SV.test_grounds.Tileset == 108 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mt_travail_wall", "mt_travail_floor", "mt_travail_secondary")
	elseif SV.test_grounds.Tileset == 109 then

	  SINGLE_CHAR_SCRIPT.SetTileData("the_nightmare_wall", "the_nightmare_floor", "the_nightmare_secondary")
	elseif SV.test_grounds.Tileset == 110 then

	  SINGLE_CHAR_SCRIPT.SetTileData("spacial_rift_1_wall", "spacial_rift_1_floor", "spacial_rift_1_secondary")
	elseif SV.test_grounds.Tileset == 111 then

	  SINGLE_CHAR_SCRIPT.SetTileData("spacial_rift_2_wall", "spacial_rift_2_floor", "spacial_rift_2_secondary")
	elseif SV.test_grounds.Tileset == 112 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_crater_wall", "dark_crater_floor", "dark_crater_secondary")
	elseif SV.test_grounds.Tileset == 113 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_dark_crater_wall", "deep_dark_crater_floor", "deep_dark_crater_secondary")
	elseif SV.test_grounds.Tileset == 114 then

	  SINGLE_CHAR_SCRIPT.SetTileData("world_abyss_2_wall", "world_abyss_2_floor", "world_abyss_2_secondary")
	elseif SV.test_grounds.Tileset == 115 then

	  SINGLE_CHAR_SCRIPT.SetTileData("golden_chamber_wall", "golden_chamber_floor", "golden_chamber_secondary")
	elseif SV.test_grounds.Tileset == 116 then
	  SOUND:PlayBGM("B22. Overgrown Wilds.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("mystery_jungle_1_wall", "mystery_jungle_1_floor", "mystery_jungle_1_secondary")
	elseif SV.test_grounds.Tileset == 117 then

	  SINGLE_CHAR_SCRIPT.SetTileData("mystery_jungle_2_wall", "mystery_jungle_2_floor", "mystery_jungle_2_secondary")
	elseif SV.test_grounds.Tileset == 118 then

	  SINGLE_CHAR_SCRIPT.SetTileData("zero_isle_east_3_wall", "zero_isle_east_3_floor", "zero_isle_east_3_secondary")
	elseif SV.test_grounds.Tileset == 119 then

	  SINGLE_CHAR_SCRIPT.SetTileData("zero_isle_east_4_wall", "zero_isle_east_4_floor", "zero_isle_east_4_secondary")
	elseif SV.test_grounds.Tileset == 120 then

	  SINGLE_CHAR_SCRIPT.SetTileData("zero_isle_south_1_wall", "zero_isle_south_1_floor", "zero_isle_south_1_secondary")
	elseif SV.test_grounds.Tileset == 121 then

	  SINGLE_CHAR_SCRIPT.SetTileData("zero_isle_south_2_wall", "zero_isle_south_2_floor", "zero_isle_south_2_secondary")
	elseif SV.test_grounds.Tileset == 122 then

	  SINGLE_CHAR_SCRIPT.SetTileData("tiny_meadow_wall", "tiny_meadow_floor", "tiny_meadow_secondary")
	elseif SV.test_grounds.Tileset == 123 then

	  SINGLE_CHAR_SCRIPT.SetTileData("final_maze_2_wall", "final_maze_2_floor", "final_maze_2_secondary")
	elseif SV.test_grounds.Tileset == 124 then

	  SINGLE_CHAR_SCRIPT.SetTileData("unused_waterfall_pond_wall", "unused_waterfall_pond_floor", "unused_waterfall_pond_secondary")
	elseif SV.test_grounds.Tileset == 125 then

	  SINGLE_CHAR_SCRIPT.SetTileData("lush_prairie_wall", "lush_prairie_floor", "lush_prairie_secondary")
	elseif SV.test_grounds.Tileset == 126 then

	  SINGLE_CHAR_SCRIPT.SetTileData("rock_aegis_cave_wall", "rock_aegis_cave_floor", "rock_aegis_cave_secondary")
	elseif SV.test_grounds.Tileset == 127 then

	  SINGLE_CHAR_SCRIPT.SetTileData("ice_aegis_cave_wall", "ice_aegis_cave_floor", "ice_aegis_cave_secondary")
	elseif SV.test_grounds.Tileset == 128 then

	  SINGLE_CHAR_SCRIPT.SetTileData("steel_aegis_cave_wall", "steel_aegis_cave_floor", "steel_aegis_cave_secondary")
	elseif SV.test_grounds.Tileset == 129 then
	  SOUND:PlayBGM("B03. Demonstration 3.ogg", true)

	  SINGLE_CHAR_SCRIPT.SetTileData("murky_forest_wall", "murky_forest_floor", "murky_forest_secondary")
	elseif SV.test_grounds.Tileset == 130 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_boulder_quarry_wall", "deep_boulder_quarry_floor", "deep_boulder_quarry_secondary")
	elseif SV.test_grounds.Tileset == 131 then

	  SINGLE_CHAR_SCRIPT.SetTileData("limestone_cavern_wall", "limestone_cavern_floor", "limestone_cavern_secondary")
	elseif SV.test_grounds.Tileset == 132 then

	  SINGLE_CHAR_SCRIPT.SetTileData("deep_limestone_cavern_wall", "deep_limestone_cavern_floor", "deep_limestone_cavern_secondary")
	elseif SV.test_grounds.Tileset == 133 then

	  SINGLE_CHAR_SCRIPT.SetTileData("barren_valley_wall", "barren_valley_floor", "barren_valley_secondary")
	elseif SV.test_grounds.Tileset == 134 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_wasteland_wall", "dark_wasteland_floor", "dark_wasteland_secondary")
	elseif SV.test_grounds.Tileset == 135 then

	  SINGLE_CHAR_SCRIPT.SetTileData("future_temporal_tower_wall", "future_temporal_tower_floor", "future_temporal_tower_secondary")
	elseif SV.test_grounds.Tileset == 136 then

	  SINGLE_CHAR_SCRIPT.SetTileData("future_temporal_spire_wall", "future_temporal_spire_floor", "future_temporal_spire_secondary")
	elseif SV.test_grounds.Tileset == 137 then

	  SINGLE_CHAR_SCRIPT.SetTileData("spacial_cliffs_wall", "spacial_cliffs_floor", "spacial_cliffs_secondary")
	elseif SV.test_grounds.Tileset == 138 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_ice_mountain_wall", "dark_ice_mountain_floor", "dark_ice_mountain_secondary")
	elseif SV.test_grounds.Tileset == 139 then

	  SINGLE_CHAR_SCRIPT.SetTileData("dark_ice_mountain_peak_wall", "dark_ice_mountain_peak_floor", "dark_ice_mountain_peak_secondary")
	elseif SV.test_grounds.Tileset == 140 then

	  SINGLE_CHAR_SCRIPT.SetTileData("icicle_forest_wall", "icicle_forest_floor", "icicle_forest_secondary")
	elseif SV.test_grounds.Tileset == 141 then

	  SINGLE_CHAR_SCRIPT.SetTileData("vast_ice_mountain_wall", "vast_ice_mountain_floor", "vast_ice_mountain_secondary")
	elseif SV.test_grounds.Tileset == 142 then

	  SINGLE_CHAR_SCRIPT.SetTileData("vast_ice_mountain_peak_wall", "vast_ice_mountain_peak_floor", "vast_ice_mountain_peak_secondary")
	elseif SV.test_grounds.Tileset == 143 then

	  SINGLE_CHAR_SCRIPT.SetTileData("sky_peak_4th_pass_wall", "sky_peak_4th_pass_floor", "sky_peak_4th_pass_secondary")
	elseif SV.test_grounds.Tileset == 144 then

	  SINGLE_CHAR_SCRIPT.SetTileData("sky_peak_7th_pass_wall", "sky_peak_7th_pass_floor", "sky_peak_7th_pass_secondary")
	elseif SV.test_grounds.Tileset == 145 then

	  SINGLE_CHAR_SCRIPT.SetTileData("sky_peak_summit_pass_wall", "sky_peak_summit_pass_floor", "sky_peak_summit_pass_secondary")
	elseif SV.test_grounds.Tileset == 146 then

	  SINGLE_CHAR_SCRIPT.SetTileData("test_dungeon_wall", "test_dungeon_floor", "test_dungeon_secondary")
	end
end