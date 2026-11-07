


local descriptions = require 'trios_dungeon_pack.terrasphere.descriptions'
require 'origin.menu.team.TeamSelectMenu'
require 'trios_dungeon_pack.menu.ItemSelectionMenu'
require 'trios_dungeon_pack.beholder'
-- require 'trios_dungeon_pack.terrasphere.quests'

OrbStateType = luanet.import_type('PMDC.Dungeon.OrbState')
BerryStateType = luanet.import_type('PMDC.Dungeon.BerryState')
EdibleStateType = luanet.import_type('PMDC.Dungeon.EdibleState')
GummiStateType = luanet.import_type('PMDC.Dungeon.GummiState')
DrinkStateType = luanet.import_type('PMDC.Dungeon.DrinkState')
WandStateType = luanet.import_type('PMDC.Dungeon.WandState')

AmmoStateType = luanet.import_type('PMDC.Dungeon.AmmoState')
UtilityStateType = luanet.import_type('PMDC.Dungeon.UtilityState')
HeldStateType = luanet.import_type('PMDC.Dungeon.HeldState')
EquipStateType = luanet.import_type('PMDC.Dungeon.EquipState')
EvoStateType = luanet.import_type('PMDC.Dungeon.EvoState')
SeedStateType = luanet.import_type('PMDC.Dungeon.SeedState')

MachineStateType = luanet.import_type('PMDC.Dungeon.MachineState')
RecruitStateType = luanet.import_type('PMDC.Duangeon.RecruitState')
CurerStateType = luanet.import_type('PMDC.Dungeon.CurerState')
FoodStateType = luanet.import_type('PMDC.Dungeon.FoodState')
HerbStateType = luanet.import_type('PMDC.Dungeon.HerbState')
UnrecruitableType = luanet.import_type('PMDC.LevelGen.MobSpawnUnrecruitable')

ItemIDStateType = luanet.import_type('RogueEssence.Dungeon.ItemIDState')
RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')

-- https://pokemondb.net/ability/guts
ORBS = { "orb_all_dodge", "orb_all_protect", "orb_cleanse", "orb_devolve", "orb_fill_in", "orb_endure", "orb_foe_hold",
  "orb_foe_seal", "orb_freeze", "orb_halving", "orb_invert", "orb_invisify", "orb_itemizer", "orb_luminous",
  "orb_pierce", "orb_scanner", "orb_mobile", "orb_mug", "orb_nullify", "orb_mirror", "orb_spurn", "orb_slow",
  "orb_slumber", "orb_petrify", "orb_totter", "orb_invisify", "orb_one_room", "orb_one_shot", "orb_totter", "orb_rebound",
  "orb_revival", "orb_rollcall", "orb_stayaway", "orb_trap_see", "orb_trapbust", "orb_trawl", "orb_weather" }

EQUIPMENT = { "terrasphere_allterrain_gear", "terrasphere_weather_ward", "held_assault_vest", "held_binding_band",
  "held_big_root", "held_black_belt", "held_black_glasses", "held_charcoal",
  "held_choice_band", "held_choice_scarf", "held_choice_specs", "held_cover_band", "held_defense_scarf",
  "held_dragon_scale", "held_expert_belt", "held_friend_bow", "held_goggle_specs", "held_grip_claw",
  "held_hard_stone", "held_heal_ribbon", "held_iron_ball", "held_life_orb", "held_magnet", "held_metal_coat",
  "held_metronome", "held_miracle_seed", "held_mobile_scarf", "held_mystic_water", "held_pass_scarf",
  "held_pierce_band", "held_pink_bow", "held_poison_barb", "held_power_band", "held_reunion_cape",
  "held_ring_target", "held_scope_lens", "held_sharp_beak", "held_shed_shell", "held_shell_bell",
  "held_silk_scarf", "held_silver_powder", "held_soft_sand", "held_special_band", "held_spell_tag",
  "held_sticky_barb", "held_toxic_orb", "held_flame_orb", "held_twist_band", "held_twisted_spoon",
  "held_warp_scarf", "held_weather_rock", "held_wide_lens", "held_x_ray_specs", "held_zinc_band",
  "held_blank_plate", "held_draco_plate", "held_dread_plate", "held_earth_plate", "held_fist_plate",
  "held_flame_plate", "held_icicle_plate", "held_insect_plate", "held_iron_plate", "held_meadow_plate",
  "held_mind_plate", "held_pixie_plate", "held_sky_plate", "held_splash_plate", "held_spooky_plate",
  "held_stone_plate", "held_toxic_plate", "held_zap_plate" }

SEED = { "seed_ban", "seed_blast", "seed_blinker", "seed_decoy", "seed_doom", "seed_golden", "seed_hunger", "seed_ice",
  "seed_joy", "seed_last_chance", "seed_plain", "seed_pure", "seed_reviver", "seed_sleep", -- "seed_spreader",
  -- "seed_training",
  -- "seed_vanish",
  "seed_vile", "seed_warp" }

WANDS = { "wand_fear",                                                            -- "wand_infatuation",
  "wand_lob", "wand_lure", "wand_path", "wand_pounce", "wand_purge", "wand_slow", -- "wand_stayaway",
  -- "wand_surround",
  "wand_switcher", "wand_topsy_turvy",                                            -- "wand_totter",
  "wand_transfer", "wand_vanish", "wand_warp", "wand_whirlwind" }

PLATES = { "held_blank_plate", "held_draco_plate", "held_dread_plate", "held_earth_plate", "held_fist_plate",
  "held_flame_plate", "held_icicle_plate", "held_insect_plate", "held_iron_plate", "held_meadow_plate",
  "held_mind_plate", "held_pixie_plate", "held_sky_plate", "held_splash_plate", "held_spooky_plate",
  "held_stone_plate", "held_toxic_plate", "held_zap_plate" }

TMS = {
  "tm_acrobatics", "tm_aerial_ace", "tm_attract", "tm_avalanche", "tm_blizzard", "tm_brick_break", "tm_brine",
  "tm_bulk_up", "tm_bulldoze", "tm_bullet_seed", "tm_calm_mind", "tm_captivate", "tm_charge_beam", "tm_cut",
  "tm_dark_pulse", "tm_dazzling_gleam", "tm_defog", "tm_dig", "tm_dive", "tm_double_team", "tm_dragon_claw",
  "tm_dragon_pulse", "tm_dragon_tail", "tm_drain_punch", "tm_dream_eater", "tm_earthquake", "tm_echoed_voice",
  "tm_embargo", "tm_endure", "tm_energy_ball", "tm_explosion", "tm_facade", "tm_false_swipe", "tm_fire_blast",
  "tm_flame_charge", "tm_flamethrower", "tm_flash", "tm_flash_cannon", "tm_fling", "tm_fly", "tm_focus_blast",
  "tm_focus_punch", "tm_frost_breath", "tm_frustration", "tm_giga_drain", "tm_giga_impact", "tm_grass_knot",
  "tm_gyro_ball", "tm_hail", "tm_hidden_power", "tm_hone_claws", "tm_hyper_beam", "tm_ice_beam", "tm_incinerate",
  "tm_infestation", "tm_iron_tail", "tm_light_screen", "tm_low_sweep", "tm_natural_gift", "tm_nature_power",
  "tm_overheat", "tm_payback", "tm_pluck", "tm_poison_jab", "tm_power_up_punch", "tm_protect", "tm_psych_up",
  "tm_psychic", "tm_psyshock", "tm_quash", "tm_rain_dance", "tm_recycle", "tm_reflect", "tm_rest", "tm_retaliate",
  "tm_return", "tm_roar", "tm_rock_climb", "tm_rock_polish", "tm_rock_slide", "tm_rock_smash", "tm_rock_tomb",
  "tm_roost", "tm_round", "tm_safeguard", "tm_sandstorm", "tm_scald", "tm_secret_power", "tm_shadow_ball",
  "tm_shadow_claw", "tm_shock_wave", "tm_silver_wind", "tm_sky_drop", "tm_sludge_bomb", "tm_sludge_wave",
  "tm_smack_down", "tm_snarl", "tm_snatch", "tm_steel_wing", "tm_stone_edge", "tm_strength", "tm_struggle_bug",
  "tm_substitute", "tm_sunny_day", "tm_surf", "tm_swagger", "tm_swords_dance", "tm_taunt", "tm_telekinesis",
  "tm_thief", "tm_thunder", "tm_thunder_wave", "tm_thunderbolt", "tm_torment", "tm_u_turn", "tm_venoshock",
  "tm_volt_switch", "tm_water_pulse", "tm_waterfall", "tm_whirlpool", "tm_wild_charge", "tm_will_o_wisp",
  "tm_work_up", "tm_x_scissor",
  "tm_toxic", "tm_confide"
}


BERRIES = {
  "berry_apicot", "berry_babiri", "berry_charti", "berry_chilan", "berry_chople", "berry_coba", "berry_colbur",
  "berry_enigma", "berry_ganlon", "berry_haban", "berry_jaboca", "berry_kasib", "berry_kebia", "berry_leppa",
  "berry_liechi", "berry_lum", "berry_micle", "berry_occa", "berry_oran", "berry_passho", "berry_payapa", "berry_petaya",
  "berry_rindo", "berry_roseli", "berry_rowap", "berry_salac", "berry_shuca", "berry_sitrus", "berry_starf",
  "berry_tanga", "berry_wacan", "berry_yache"
}

FOOD = {
  "food_apple", "food_apple_big", "food_apple_huge", "food_apple_perfect", "food_banana", "food_banana_big",
}


GUMMIS = {
  "gummi_black",
  "gummi_blue",
  "gummi_brown",
  "gummi_clear",
  "gummi_foul",
  "gummi_gold",
  "gummi_grass",
  "gummi_gray",
  "gummi_green",
  "gummi_magenta",
  "gummi_orange",
  "gummi_pink",
  "gummi_purple",
  "gummi_red",
  "gummi_royal",
  "gummi_silver",
  "gummi_sky",
  "gummi_white",
  "gummi_wonder",
  "gummi_yellow"
}

AMMOS = {
  "ammo_cacnea_spike",
  "ammo_corsola_twig",
  "ammo_geo_pebble",
  "ammo_golden_thorn",
  "ammo_gravelerock",
  "ammo_iron_thorn",
  "ammo_rare_fossil",
  "ammo_silver_spike",
  "ammo_stick"
}

APRICORNS = { "apricorn_black", "apricorn_blue", "apricorn_brown", 'apricorn_green', 'apricorn_purple', 'apricorn_plain',
  'apricorn_red', 'apricorn_white', 'apricorn_yellow', "apricorn_big", "apricorn_glittery" }

BOOSTS = {
  "boost_calcium", "boost_carbos", "boost_hp_up", "boost_iron", "boost_nectar", "boost_protein", "boost_zinc"
}

EVOS = {
  "evo_chipped_pot",
  "evo_cracked_pot",
  "evo_dawn_stone",
  "evo_deep_sea_scale",
  "evo_deep_sea_tooth",
  "evo_dubious_disc",
  "evo_dusk_stone",
  "evo_electirizer",
  "evo_fire_stone",
  "evo_harmony_scarf",
  "evo_ice_stone",
  "evo_kings_rock",
  "evo_leaf_stone",
  "evo_link_cable",
  "evo_lunar_ribbon",
  "evo_magmarizer",
  "evo_moon_stone",
  "evo_oval_stone",
  "evo_prism_scale",
  "evo_protector",
  "evo_razor_claw",
  "evo_razor_fang",
  "evo_reaper_cloth",
  "evo_shiny_stone",
  "evo_sun_ribbon",
  "evo_sun_stone",
  "evo_thunder_stone",
  "evo_up_grade",
  "evo_water_stone"
}


MACHINES = {
  "machine_ability_capsule",
  "machine_assembly_box",
  "machine_recall_box",
}

MEDICINE = {
  "medicine_dire_hit",
  "medicine_elixir",
  "medicine_full_heal",
  "medicine_full_restore",
  "medicine_guard_spec",
  "medicine_max_elixir",
  "medicine_max_potion",
  "medicine_potion",
  "medicine_x_accuracy",
  "medicine_x_attack",
  "medicine_x_defense",
  "medicine_x_sp_atk",
  "medicine_x_sp_def",
  "medicine_x_speed"
}

HERBS = {
  "herb_mental",
  "herb_power",
  "herb_white"
}

TERRASPHERE_BEHOLDER_GROUPS = {}


STATS = {
  RogueEssence.Data.Stat.Attack,
  RogueEssence.Data.Stat.Defense,
  RogueEssence.Data.Stat.MAtk,
  RogueEssence.Data.Stat.MDef,
  RogueEssence.Data.Stat.Speed,
  RogueEssence.Data.Stat.HP
}

function GetRandomFromArray(table)
  return table[_DATA.Save.Rand:Next(#table) + 1]
end

function table.copy(obj, seen)
  if type(obj) ~= 'table' then
    return obj
  end
  if seen and seen[obj] then
    return seen[obj]
  end
  local s = seen or {}
  local res = setmetatable({}, getmetatable(obj))
  s[obj] = res
  for k, v in pairs(obj) do
    res[table.copy(k, s)] = table.copy(v, s)
  end
  return res
end

function GetRandomUnique(items, amount, already_seen)
  local pool = {}
  if already_seen == nil then
    already_seen = {}
  end

  for i = 1, #items do
    if not already_seen[items[i]] then
      table.insert(pool, items[i])
    end
  end

  local result = {}
  local count = math.min(amount, #pool)

  for i = 1, count do
    local index = _DATA.Save.Rand:Next(#pool) + 1
    table.insert(result, pool[index])
    already_seen[pool[index]] = true
    table.remove(pool, index)
  end

  return result
end

function SelectItemFromList(prompt, items)
  local ret = {}
  local choose = function(item)
    ret = item
    _MENU:RemoveMenu()
  end
  local refuse = function()
  end

  local generate_option_choice = function (item_entry, i, confirm_action)

    local item_name = M_HELPERS.GetItemName(item_entry.Item, item_entry.Amount)

    local color = Color.White
    local text_name = RogueEssence.Menu.MenuText(item_name, RogueElements.Loc(2, 1), color)

    local option = RogueEssence.Menu.MenuElementChoice(
      function() confirm_action(i) end,
      true,
      text_name
    )
    return option
  end

  local menu = ItemSelectionMenu:new(prompt, items, generate_option_choice, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
  return ret
end

function GetItemFromContext(context)
  local index = context.UsageSlot
  local item
  if index >= -1 then
    item = _DATA.Save.ActiveTeam:GetInv(index).ID
  elseif index == -1 then
    item = context.User.EquippedItem.ID
  elseif index == -2 then
    local map_slot = _ZONE.CurrentMap:GetItem(context.User.CharLoc)
    item = _ZONE.CurrentMap.Items[map_slot].Value
  end

  return item
end

function GetSkillFromContext(context)
  return context.User.Skills[context.UsageSlot].Element.SkillNum
end

function ItemIdContainsState(item_id, state_type)
  local item_data = _DATA:GetItem(item_id)
  local contains = item_data.ItemStates:Contains(luanet.ctype(state_type))
  return contains
end

local function ConcatTables(a, b)
  local t = {}
  for _, v in ipairs(a) do
    t[#t + 1] = v
  end
  for _, v in ipairs(b) do
    t[#t + 1] = v
  end
  return t
end


function FanfareText(text, sound)
  local sound = sound or "Fanfare/Item"
  SOUND:PlayFanfare(sound)
  UI:SetCenter(true)
  UI:WaitShowDialogue(text)
  UI:SetCenter(false)
end

function GetFloorSpawns(config)
  local possible = {}
  local seen_species = {}
  local map = _ZONE.CurrentMap
  local spawns = map.TeamSpawns

  local required_features = config and config.has_features or nil
  local excluded_features = config and config.not_has_features or nil

  -- get the spawn list
  for i = 0, spawns.Count - 1, 1 do
    local spawnList = spawns:GetSpawn(i):GetPossibleSpawns()
    for j = 0, spawnList.Count - 1, 1 do
      local spawn = spawnList:GetSpawn(j)
      local features = spawn.SpawnFeatures

      -- Check if spawn has all required features
      local has_all_features = true
      if required_features then
        for _, required_feature in ipairs(required_features) do
          local has_feature = false
          for f = 0, features.Count - 1, 1 do
            if LUA_ENGINE:TypeOf(features[f]) == luanet.ctype(required_feature) then
              has_feature = true
              break
            end
          end
          if not has_feature then
            has_all_features = false
            break
          end
        end
      end

      -- Check if spawn has any excluded features
      local has_excluded_feature = false
      if excluded_features then
        for _, excluded_feature in ipairs(excluded_features) do
          for f = 0, features.Count - 1, 1 do
            if LUA_ENGINE:TypeOf(features[f]) == luanet.ctype(excluded_feature) then
              has_excluded_feature = true
              break
            end
          end
          if has_excluded_feature then
            break
          end
        end
      end

      if spawn:CanSpawn() and has_all_features and not has_excluded_feature then
        local species = spawn.BaseForm.Species
        if not seen_species[species] then
          seen_species[species] = true
          table.insert(possible, species)
        end
      end
    end
  end

  return possible
end

function GetInventoryCost()
  local sum = 0
  local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
  for i = 0, inv_count - 1 do
    local item = _DATA.Save.ActiveTeam:GetInv(i)
    local id = item.ID
    local entry = _DATA:GetItem(id)
    if not entry.CannotDrop then
      sum = sum + entry.Price
    end
  end


  local save = _DATA.Save
  local player_count = save.ActiveTeam.Players.Count
  for i = 0, player_count - 1, 1 do
    local player = save.ActiveTeam.Players[i]
    if player.EquippedItem.ID ~= '' and player.EquippedItem.ID ~= nil then
      local entry = _DATA:GetItem(player.EquippedItem.ID)
      if not entry.CannotDrop then
        sum = sum + entry.Price
      end
    end
  end

  return sum
end

PowerupDefaults = {
  -- Checks whether this powerup can be given to the player
  can_apply = function()
    return true
  end,

  -- Called upon immediately selecting the powerup
  apply = function(self)
    print(self.name .. " activated.")
  end,

  -- At the start of each floor, call this
  set_active_effects = function(self, active_effect, zone_context)
    print(self.name .. " set map effect.")
    -- print(self.name .. " activated.")
  end,

  -- Revert anything applied by the powerup at the end of the run
  revert = function(self)
    print(self.name .. " reverted.")
  end,

  -- Used for when progressing to Terrasphere Depths
  progress = function(self)
    print(self.name .. " progressed.")
  end,

  -- Used for getting more info about the progress through a submenu (ex. character selected, the amount of money made, the stat boosts)
  get_progress_texts = function(self)
    -- return nil
    return {}
  end,

  -- When the end of the dungeon is reached, provide the player rewards
  reward = function(self)
    print(self.name .. " progressed.")
  end,

  -- Called upon when going back into a save file and setting variables in Lua that cannot be saved
  restore = function(self)
    print(self.name .. " restore.")
  end,

  get_description = function(self)
    return descriptions.Format(self)
  end,

  -- Could maybe use beholder...
  -- On checkpoint reached
  on_checkpoint = function(self)
    print(self.name .. " checkpoint.")
  end,

  -- Could also maybe use beholder...
  -- On checkpoint exiting
  on_checkpoint_exit = function(self)
    print(self.name .. " exit checkpoint.")
  end,

  -- Called when exiting the dungeon
  cleanup = function(self)
  end,
}

EnchantmentRegistry = CreateRegistry({
  registry_table = {},
  seen_table_path = "Terrasphere.Enchantments.Seen",
  data_table_path = "Terrasphere.Enchantments.Data",
  selected_table_path = "Terrasphere.Enchantments.Selected",
  defaults = PowerupDefaults,
  selection_field = "Enchantments",
  debug = true
})

function ResetSeenEnchantments()
  SV.Terrasphere.Enchantments.Seen = {}
  -- SV.Terrasphere.Enchantments.Data = {}
  -- SV.Terrasphere.Enchantments.Selected = {}
  SV.Terrasphere.Enchantments.RerollCounts = { 1, 1, 1 }
end

function PrepareNextEnchantment()
  -- SV.Terrasphere.Enchantments.RerollCounts = { 1, 1, 1 }
  SV.Terrasphere.GotEnchantmentFromCheckpoint = false
end

function FindCharacterWithEnchantment(enchant_id)
  local function search(players, assembly)
    for member in luanet.each(players) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member, false
      end
    end
    for member in luanet.each(assembly) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member, true
      end
    end
  end

  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    return search(_DUNGEON.ActiveTeam.Players, _DUNGEON.ActiveTeam.Assembly)
  else
    return search(_DATA.Save.ActiveTeam.Players, _DATA.Save.ActiveTeam.Assembly)
  end
end

function ResetCharacterEnchantment(chara)
  local tbl = LTBL(chara)
  tbl.Enchantments = {}
end

function ResetAllCharacterEnchantments()
  for i = 0, GAME:GetPlayerPartyCount() - 1 do
    local chara = GAME:GetPlayerPartyMember(i)
    ResetCharacterEnchantment(chara)
  end

  for i = 0, GAME:GetPlayerAssemblyCount() - 1 do
    local chara = GAME:GetPlayerAssemblyMember(i)
    ResetCharacterEnchantment(chara)
  end
end


return { ConcatTables = ConcatTables }
