require 'origin.menu.team.TeamSelectMenu'
require 'trios_dungeon_pack.menu.ItemSelectionMenu'
require 'trios_dungeon_pack.beholder'
-- require 'trios_dungeon_pack.emberfrost.quests'

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
RecruitStateType = luanet.import_type('PMDC.Dungeon.RecruitState')
CurerStateType = luanet.import_type('PMDC.Dungeon.CurerState')
FoodStateType = luanet.import_type('PMDC.Dungeon.FoodState')
HerbStateType = luanet.import_type('PMDC.Dungeon.HerbState')
UnrecruitableType = luanet.import_type('PMDC.LevelGen.MobSpawnUnrecruitable')

RedirectionType = luanet.import_type('PMDC.Dungeon.Redirected')


ORBS = { "orb_all_dodge", "orb_all_protect", "orb_cleanse", "orb_devolve", "orb_fill_in", "orb_endure", "orb_foe_hold",
  "orb_foe_seal", "orb_freeze", "orb_halving", "orb_invert", "orb_invisify", "orb_itemizer", "orb_luminous",
  "orb_pierce", "orb_scanner", "orb_mobile", "orb_mug", "orb_nullify", "orb_mirror", "orb_spurn", "orb_slow",
  "orb_slumber", "orb_petrify", "orb_totter", "orb_invisify", "orb_one_room", "orb_one_shot", "orb_totter", "orb_rebound",
  "orb_revival", "orb_rollcall", "orb_stayaway", "orb_trap_see", "orb_trapbust", "orb_trawl", "orb_weather" }

EQUIPMENT = { "emberfrost_allterrain_gear", "emberfrost_weather_ward", "held_assault_vest", "held_binding_band",
  "held_big_root", "held_black_belt", "held_black_glasses", "held_black_sludge", "held_charcoal",
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

HARVEST_TABLE = {
  "berry_apicot", "berry_babiri", "berry_charti", "berry_chilan", "berry_chople", "berry_coba", "berry_colbur",
  "berry_enigma", "berry_ganlon", "berry_haban", "berry_jaboca", "berry_kasib", "berry_kebia", "berry_leppa",
  "berry_liechi", "berry_lum", "berry_micle", "berry_occa", "berry_oran", "berry_passho", "berry_payapa", "berry_petaya",
  "berry_rindo", "berry_roseli", "berry_rowap", "berry_salac", "berry_shuca", "berry_sitrus", "berry_starf",
  "berry_tanga", "berry_wacan", "berry_yache", "food_apple", "food_apple_big", "food_apple_huge", "food_apple_perfect",
  "food_banana", "food_banana_big",
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

EMBERFROST_BEHOLDER_GROUPS = {}


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
  local menu = ItemSelectionMenu:new(prompt, items, choose, refuse)
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

-- Unfortunately, I'm not sure why passing a reference to the SV table doesn't work. This is a workaround for now
local function resolve_path(root, path)
  if type(root) ~= "table" then
    print("[resolve_path error] root is not a table:", tostring(root))
    return {}
  end

  if type(path) ~= "string" then
    print("[resolve_path error] path is not a string:", tostring(path))
    return {}
  end

  local current = root
  local walked = {}

  for key in string.gmatch(path, "[^%.]+") do
    table.insert(walked, key)

    if type(current) ~= "table" then
      print(string.format("[resolve_path error] '%s' is not a table (got %s)", table.concat(walked, "."),
        type(current)))
      return nil
    end

    if current[key] == nil then
      print(string.format("[resolve_path error] missing key '%s' at '%s'", key, table.concat(walked, ".")))
      return nil
    end

    current = current[key]
  end

  return current
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

  -- Used for when progressing to Emberfrost Depths
  progress = function(self)
    print(self.name .. " progressed.")
  end,

  -- Used for getting more info about the progress through a submenu (ex. character selected, the amount of money made, the stat boosts)
  getProgressTexts = function(self)
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

  getDescription = function(self)
    return ""
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

function CreateRegistry(config)
  local Registry = {}
  local order = {}

  Registry._registry = config.registry_table
  Registry.data_table_path = config.data_table_path
  Registry.selected_table_path = config.selected_table_path
  Registry.seen_table_path = config.seen_table_path

  -- Registry._seen = config.seen_table
  -- Registry._default_selected = config.selected_table
  Registry.defaults = config.defaults
  Registry.can_apply_key = config.can_apply_key or "can_apply"
  Registry.debug = config.debug
  Registry._count = 0

  function Registry:Register(def)
    assert(def.id, "Registry entry must have an id")

    local entry = self.defaults and setmetatable(def, {
      __index = self.defaults
    }) or def

    self._registry[def.id] = entry
    table.insert(order, def.id)

    self._count = self._count + 1
    if self.debug then
      print("[Registry] Registered:", def.id)
    end

    return entry
  end

  function Registry:Get(id)
    return self._registry[id]
  end


  function Registry:GetIDOrdered()
    return order
  end

  function Registry:Select(id)
    local select_table = resolve_path(SV, self.selected_table_path) or {}
    return select_table.insert(id)
  end

  function Registry:RemoveSelection(index)
    local select_table = resolve_path(SV, self.selected_table_path) or {}
    select_table.remove(index)
  end

  function Registry:GetSelected(selected)
    local list = {}
    local select_table = selected or resolve_path(SV, self.selected_table_path)

    for _, id in ipairs(select_table) do
      local entry = self._registry[id]
      if entry then
        table.insert(list, entry)
      end
    end
    return list
  end

  function Registry:GetData(entry)
    local table = resolve_path(SV, self.data_table_path) or {}
    -- I'm not sure why this doesn't work...
    -- local table = self._data_tab
    -- self._data_tab = SV.EmberFrost.Enchantments.Data
    local id

    if type(entry) == "string" then
      id = entry
    elseif type(entry) == "table" and entry.id then
      id = entry.id
    else
      error("Registry:GetData: entry must be string or table with id")
    end

    table[id] = table[id] or {}

    return table[id]
  end

  function Registry:GetRandom(amount, total_groups)
    local seen_table = resolve_path(SV, self.seen_table_path) or {}
    print(Serpent.dump(seen_table) .. ".... uh seen")

    local candidates = {}
    for id, entry in pairs(self._registry) do
      local seen = seen_table[id]
      local can_apply = entry[self.can_apply_key]
      if not seen and (not can_apply or can_apply(entry)) then
        table.insert(candidates, entry)
      end
    end

    for i = #candidates, 2, -1 do
      local j = _DATA.Save.Rand:Next(i) + 1
      candidates[i], candidates[j] = candidates[j], candidates[i]
    end

    local picked = {}
    for i = 1, math.min(amount, #candidates) do
      local entry = candidates[i]
      table.insert(picked, entry)
    end

    if not total_groups then
      return picked
    end

    local grouped = {}
    for i = 1, total_groups do
      grouped[i] = {}
    end

    for i, entry in ipairs(picked) do
      table.insert(grouped[((i - 1) % total_groups) + 1], entry)
    end

    return grouped
  end

  return Registry
end


EnchantmentRegistry = CreateRegistry({
  registry_table = {},
  seen_table_path = "EmberFrost.Enchantments.Seen",
  data_table_path = "EmberFrost.Enchantments.Data",
  selected_table_path = "EmberFrost.Enchantments.Selected",
  defaults = PowerupDefaults,
  selection_field = "Enchantments",
  debug = true
})

function ResetSeenEnchantments()
  SV.EmberFrost.Enchantments.Seen = {}
  -- SV.EmberFrost.Enchantments.Data = {}
  -- SV.EmberFrost.Enchantments.Selected = {}
  SV.EmberFrost.Enchantments.RerollCounts = { 1, 1, 1 }
end

function PrepareNextEnchantment()
  -- SV.EmberFrost.Enchantments.RerollCounts = { 1, 1, 1 }
  SV.EmberFrost.GotEnchantmentFromCheckpoint = false
end

function FindCharacterWithEnchantment(enchant_id)
  if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
    for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
  else
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.Enchantments and tbl.Enchantments[enchant_id] then
        return member
      end
    end
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

ExpandedSatchel = EnchantmentRegistry:Register({
  name = "Expanded Satchel",
  id = "EXPANDED_SATCHEL",
  bag_increase = 8,
  getDescription = function(self)
    return string.format("Increase the bag size by %s for the duration of the dungeon",
      M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local old_amount = _ZONE.CurrentZone.BagSize
    _ZONE.CurrentZone.BagSize = old_amount + self.bag_increase

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("Your team's bag size has increased by %s! (%s -> %s)",
      M_HELPERS.MakeColoredText(tostring(self.bag_increase), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(old_amount), PMDColor.Cyan), M_HELPERS.MakeColoredText(
        tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan)))
    UI:SetCenter(false)
  end,

  getProgressTexts = function(self)
    return { "Current Bag Size: " .. M_HELPERS.MakeColoredText(tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan) }
  end,

  progress = function(self)
    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + self.bag_increase
  end
})


JeweledBug = EnchantmentRegistry:Register({
  name = "Jeweled Bug",
  id = "JEWELLED_BUG",
  amount = 50000,
  getDescription = function(self)
    local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_jeweled_bug")
    return string.format("Gain a " .. entry:GetColoredName() ..
      " (eats a random item at the start of each floor and gives " .. M_HELPERS.MakeColoredText(tostring(self.amount) .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local items = { {
      Item = "emberfrost_jeweled_bug",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

TreadingThrough = EnchantmentRegistry:Register({
  name = "Treading Through",
  id = "TREADING_THROUGH",
  getDescription = function(self)
    local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_allterrain_gear")
    return string.format("Gain %s " .. entry:GetColoredName() ..
      " (allows the holder to traverse water, lava, and pits)",
      M_HELPERS.MakeColoredText("2", PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local items = { {
      Item = "emberfrost_allterrain_gear",
      Amount = 1
    }, {
      Item = "emberfrost_allterrain_gear",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end

})

ThreadsOfLife = EnchantmentRegistry:Register({
  name = "Threads of Life",
  id = "THREADS_OF_LIFE",
  getDescription = function(self)
    local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("evo_harmony_scarf")
    return string.format("Gain a " .. entry:GetColoredName())
  end,
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    local items = { {
      Item = "evo_harmony_scarf",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})
-- Gain6500P = EnchantmentRegistry:Register({

--   name = "Gain 6500 " .. PMDSpecialCharacters.Money,
--   id = "GAIN_6500_P",
--   group = ENCHANTMENT_TYPES.money,

--   getDescription = function(self)
--     return "Gain 6500 " .. PMDSpecialCharacters.Money
--   end,
--   offer_time = "beginning",
--   rarity = 1,

--   apply = function(self)
--     -- TODO: Add a custom menu to select which inventory item
--     -- Check out InventorySelectMenu.lua for reference.
--     _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 5000
--     SOUND:PlayFanfare("Fanfare/Item")
--     UI:SetCenter(true)
--     UI:WaitShowDialogue("You gained 5,000 " .. PMDSpecialCharacters.Money .. "!")
--     UI:SetCenter(false)

--   end

-- })


CalmTheStorm = EnchantmentRegistry:Register({
  name = "Calm the Storm",
  id = "CALM_THE_STORM",
  getDescription = function(self)
    local ward_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("emberfrost_weather_ward")
    return string.format("Gain a %s (allows the holder to eliminate the weather when it is battling)", ward_entry:GetIconName())
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    local items = {
      {Item = "emberfrost_weather_ward", Amount = 1 },
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end

})



TwoForOne = EnchantmentRegistry:Register({
  name = "2 for 1",
  id = "TWO_FOR_ONE",
  amount = 2,
  getDescription = function(self)
    return string.format("Gain %s random enchantments",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan)
    )
  end,

  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local enchant_ids = data["selected_enchantments"]
    local texts = {}
    for _, enchant_id in ipairs(enchant_ids) do
      local enchant = EnchantmentRegistry._registry[enchant_id]
      if enchant then
        table.insert(texts, "Recieved: " .. M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow))
      end
    end

    return texts
  end,

  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["selected_enchantments"] = {}
    local enchantments = EnchantmentRegistry:GetRandom(2, 1)[1]


    for _, enchantment in ipairs(enchantments) do
      local data = EnchantmentRegistry:GetData(self)
      table.insert(data["selected_enchantments"], enchantment.id)

      enchantment:apply()

      table.insert(SV.EmberFrost.SelectedEnchantments, enchantment.id)
    end
  end,
})

MysteryEnchant = EnchantmentRegistry:Register({
  gold_amount = 4000,
  name = "Mystery Enchant",
  id = "MYSTERY_ENCHANT",
  getDescription = function(self)
    return string.format("Gain a random enchantment and %s.", M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,

  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local enchant_id = data["selected_enchantment"]
    local enchant = EnchantmentRegistry._registry[enchant_id]
    if enchant then
      return {
        "Recieved: " .. M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow),
      }
    end

    return {}
  end,

  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    local enchantment = EnchantmentRegistry:GetRandom(1, 1)[1][1]

    print(tostring(self.id) .. " applying enchantment: " .. tostring(enchantment.id))
    local data = EnchantmentRegistry:GetData(self)

    data["selected_enchantment"] = enchantment.id

    enchantment:apply()

    table.insert(SV.EmberFrost.SelectedEnchantments, enchantment.id)

    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.gold_amount
    SOUND:PlayFanfare("Fanfare/Item")
    UI:SetCenter(true)
    UI:WaitShowDialogue("You gained " .. tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money .. "!")
    UI:SetCenter(false)

  end,

})

PrimalMemory = EnchantmentRegistry:Register({
  name = "Primal Memory",
  id = "PRIMAL_MEMORY",
  amount = 2,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Choose a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("egg moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)
    SetMovesRelearnable(selected_char, true, false, false)
    local items = {}
    for i = 1, self.amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})


Blueprint = EnchantmentRegistry:Register({
  name = "Blueprint",
  id = "BLUEPRINT",
  tm_amount = 2,
  recall_amount = 1,
  total_choices = 5,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Choose a team member. Gain %s random TMs that member learns and then select another one (TMs will be randomized if not possible). Gain a %s",
      M_HELPERS.MakeColoredText(self.tm_amount, PMDColor.Cyan),
      recall_box
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self, false)
    local possible_skills = GetMemberSkills(selected_char, false, false, true)
    local seen = {}
    local tm_items = {}

    -- First, add TMs from possible_skills
    for i = 1, math.min(self.tm_amount, #possible_skills) do
      local rand_skill = GetRandomUnique(possible_skills, 1, seen)[1]
      seen[rand_skill] = true
      table.insert(tm_items, {
        Item = "tm_" .. rand_skill,
        Amount = 1
      })
    end

    -- If we need more TMs, get from TMs pool
    local remaining = self.tm_amount - #tm_items
    if remaining > 0 then
      local additional_tms = GetRandomUnique(TMS, remaining, seen)
      for _, tm in ipairs(additional_tms) do
        seen[tm] = true
        table.insert(tm_items, {
          Item = tm,
          Amount = 1
        })
      end
    end

    M_HELPERS.GiveInventoryItemsToPlayer(tm_items)

    -- Select 5 TMs for the choice menu (prioritize possible_skills, then add from TMs pool)
    local choice_pool = {}
    local choice_seen = {}

    -- Add up to 5 from possible_skills first
    for i = 1, math.min(self.total_choices, #possible_skills) do
      local rand_skill = GetRandomUnique(possible_skills, 1, choice_seen)[1]
      choice_seen[rand_skill] = true
      table.insert(choice_pool, {
        Item = "tm_" .. rand_skill,
        Amount = 1
      })
    end

    -- Fill remaining slots from TMs pool
    local remaining_choices = 5 - #choice_pool
    if remaining_choices > 0 then
      local additional_choices = GetRandomUnique(TMS, remaining_choices, choice_seen)
      for _, tm in ipairs(additional_choices) do
        table.insert(choice_pool, {
          Item = tm,
          Amount = 1
        })
      end
    end

    local result = SelectItemFromList(
      string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
      choice_pool
    )

    GAME:WaitFrames(20)
    M_HELPERS.GiveInventoryItemsToPlayer({ result })

    local items = {}

    for i = 1, self.recall_amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

APRICORNS = { "apricorn_black", "apricorn_blue", "apricorn_brown", 'apricorn_green', 'apricorn_purple', 'apricorn_plain', 'apricorn_red', 'apricorn_white', 'apricorn_yellow' }

TeamBuilding = EnchantmentRegistry:Register({
  amount = 2,
  choice = 5,
  name = "Team Building",
  id = "TEAM_BUILDING",
  apricorn_amount = 2,
  total_choices = 5,
  amber_tear_amount = 3,

  getDescription = function(self)
    local assembly_box = M_HELPERS.GetItemName("machine_assembly_box")

    local amber_tear = M_HELPERS.GetItemName("medicine_amber_tear", self.amber_tear_amount)

    return string.format(
      "Gain %s random apricorns and then select an apricorn from a choice of %s. Gain an %s and %s",
      M_HELPERS.MakeColoredText(self.apricorn_amount, PMDColor.Cyan),
      M_HELPERS.MakeColoredText(self.total_choices, PMDColor.Cyan),
      assembly_box,
      amber_tear
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local apricorns = data["apricorns"]

    local str_arr = {
      "Recieved: ",
    }
    for _, apricorn in ipairs(apricorns) do
      local apricorn_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(apricorn)
      local apricorn_name = apricorn_entry:GetIconName()
      table.insert(str_arr, apricorn_name)
    end

    return str_arr
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["apricorns"] = {}

    local random_items = {}

    for i = 1, self.amount do
      local random_apricorn_index = math.random(APRICORNS)
      local apricorn = APRICORNS[random_apricorn_index]
      table.insert(data["apricorns"], apricorn)
      table.insert(random_items, { Item = apricorn, Amount = 1 })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(random_items)

    GAME:WaitFrames(20)

    local pool_items = {}

    local apricorns = GetRandomUnique(self.apricorns, 5)
    for _, apricorn in ipairs(apricorns) do
      table.insert(pool_items, { Item = apricorn, Amount = 1 })
    end

    local result = SelectItemFromList(
      string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
      pool_items
    )

    table.insert(data["apricorns"], result.Item)
    GAME:WaitFrames(20)
    M_HELPERS.GiveInventoryItemsToPlayer({ result })


    local items2 = {
      { Item = "machine_assembly_box", Amount = 1 },
      { Item = "medicine_amber_tear", Amount = self.amber_tear_amount },
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items2)

  end
})

EliteTutoring = EnchantmentRegistry:Register({
  name = "Elite Tutoring",
  id = "ELITE_TUTORING",
  amount = 1,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    return string.format("Choose a team member. That member can now remember any %s. Gain %s %s",
      M_HELPERS.MakeColoredText("tutoring moves", PMDColor.Yellow),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box)
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  apply = function(self)
    local selected_char = AssignEnchantmentToCharacter(self)

    SetMovesRelearnable(selected_char, false, true, false)

    local items = {}

    for i = 1, self.amount do
      table.insert(items, {
        Item = "machine_recall_box",
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

function GetTM(tm)
  local entry = _DATA:GetItem(tm)

  local ItemIDState = luanet.import_type('RogueEssence.Dungeon.ItemIDState')
  local id_state = entry.ItemStates:Get(luanet.ctype(ItemIDState))
  local id = id_state.ID

  return id
end

--
-- function SetEggMovesRelearnable(member)

-- end
function GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  local skills = {}


  if include_egg_moves then
    for skill in luanet.each(member.SharedSkills) do
      table.insert(skills, skill.Skill)
    end
  end

  if include_tutor_moves then
    for skill in luanet.each(member.SecretSkills) do
      table.insert(skills, skill.Skill)
    end
  end


  if include_teach_skills then
    for skill in luanet.each(member.TeachSkills) do
      table.insert(skills, skill.Skill)
    end
  end

  return skills
end

function GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  
  local base_form = member.BaseForm
  local mon = _DATA:GetMonster(base_form.Species)
  local form = mon.Forms[base_form.Form]

  local skills = {}
  local seen = {} -- Track unique skills

  if include_egg_moves then
    for skill in luanet.each(form.SharedSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end

  if include_tutor_moves then
    for skill in luanet.each(form.SecretSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end


  if include_teach_skills then
    for skill in luanet.each(form.TeachSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end


  return skills
end
-- local already_learned = member:HasBaseSkill(move)
-- if mon.PromoteFrom ~= "" then
--   playerMonId = RogueEssence.Dungeon.MonsterID(mon.PromoteFrom, form.PromoteForm, "normal", Gender.Genderless)
-- else
--   playerMonId = nil
-- end
-- end

function SetMovesRelearnable(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  local skills = GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  for _, skill in ipairs(skills) do
    member.Relearnables[skill] = true
  end
end


SticksAndStones = EnchantmentRegistry:Register({
  amount = 5,

  apricorns = { "apricorn_black", "apricorn_blue", "apricorn_brown", "apricorn_green", "apricorn_purple", "apricorn_red", "apricorn_white", "apricorn_yellow", "apricorn_plain" },
  name = "Sticks & Stones",
  id = "STICKS_AND_STONES",
  getDescription = function(self)

    local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
    local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
    local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
    local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
    -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

    -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
    -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
    -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

    return string.format(
      "Gain %s of each: %s, %s, %s, %s",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      goldenthorn:GetIconName(),
      sticks:GetIconName(),

      gravelerock:GetIconName(),
      geopebble:GetIconName()
    )
    -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
  end,

  offer_time = "beginning",
  rarity = 1,
  apply = function(self)

    local amount = self.amount
    local items = {
      {Item = "ammo_stick", Amount = amount },
      {Item = "ammo_golden_thorn", Amount = amount },
      {Item = "ammo_gravelerock", Amount = amount },
      {Item = "ammo_geo_pebble", Amount = amount },
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end,

})

--
-- MayBreakMyBones = EnchantmentRegistry:Register({
--   amount = 9,
--   percent = 50,

--   name = "...Break My Bones",
--   id = "BREAK_MY_BONES",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.EmberFrost.SelectedEnchantments, SticksAndStones.id)
--   end,

--   getDescription = function(self)
--     local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
--     local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
--     local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
--     local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
--     -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

--     -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
--     -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
--     -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

--     return string.format(
--       "Your team's projectiles do %s more damage. Gain %s of each: %s, %s, %s, %s",
--       M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       goldenthorn:GetIconName(),
--       sticks:GetIconName(),

--       gravelerock:GetIconName(),
--       geopebble:GetIconName()
--     )
--     -- return "Projectiles deal 50% more damage."
--     -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     local amount = self.amount

--     local items = {
--       "ammo_stick", Amount = amount },
--       "ammo_golden_thorn", Amount = amount },
--       "ammo_gravelerock", Amount = amount },
--       "ammo_geo_pebble", Amount = amount },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- WordsWillNever = EnchantmentRegistry:Register({

--   name = "...Words Will Never",
--   id = "WORDS_WILL_NEVER",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.EmberFrost.SelectedEnchantments, MayBreakMyBones.id)
--   end,

--   getDescription = function(self)
--     local sticks = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick")
--     local goldenthorn = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn")
--     local gravelerock = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock")
--     local geopebble = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble")
--     -- local sticks = RogueEssence.Dungeon.InvItem("ammo_stick", false, 1)

--     -- local goldenthorn = RogueEssence.Dungeon.InvItem("ammo_golden_thorn", false, 1)
--     -- local gravelerock = RogueEssence.Dungeon.InvItem("ammo_gravelerock", false, 1)
--     -- local geopebble = RogueEssence.Dungeon.InvItem("ammo_geo_pebble", false, 1)

--     return string.format(
--       "Your team is immune to the negative status effects: Spite, Disabled, Taunt, Swagger, Torment, Grudge, and Quash",
--       M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
--       M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
--       goldenthorn:GetIconName(),
--       sticks:GetIconName(),

--       gravelerock:GetIconName(),
--       geopebble:GetIconName()
--     )
--     -- return "Projectiles deal 50% more damage."
--     -- return "Select a team member. That member can remember any moves they can learn through a Recall Box"
--   end,

--   offer_time = "beginning",
--   rarity = 2,
--   apply = function(self)
--     local amount = self.amount

--     local items = {
--       "ammo_stick", Amount = amount },
--       "ammo_golden_thorn", Amount = amount },
--       "ammo_gravelerock", Amount = amount },
--       "ammo_geo_pebble", Amount = amount },
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end,

-- })

-- BuriedTreasures = EnchantmentRegistry:Register({
--   turn_interval = 200,
--   name = "Buried Treasures",
--   id = "BURIED_TREASURES",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "At the start of each floor and every %s turns, show a compass towards to a buried treasure if any are present.",
--       M_HELPERS.MakeColoredText(tostring(self.turn_interval), PMDColor.Cyan)
--     )
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--   end,
-- })

-- Pacifist = EnchantmentRegistry:Register({
--   gold_amount = 500,
--   name = "Pacifist",
--   id = "PACIFIST",
--   group = ENCHANTMENT_TYPES.items,
--   getDescription = function(self)
--     return string.format(
--       "Select a character. When that character deals no damage for the floor, gain %s the following floor.",
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. PMDSpecialCharacters.Money, PMDColor.Cyan)
--     )
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_pacifist", EnchantmentID = self.id })))
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })


HandsTied = EnchantmentRegistry:Register({
  gold_amount = 10000,
  name = "Hands Tied",
  id = "HANDS_TIED",
  getDescription = function(self)
    return string.format("Gain %s. The team cannot use %s until the next checkpoint", M_HELPERS.MakeColoredText(
        tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_embargo",
        EnchantmentID = self.id,
        ApplyToAll = true
      })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue(string.format("Note: Your team cannot use %s until the next checkpoint.",
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
    UI:SetCenter(false)
  end
})

ATrueLeader = EnchantmentRegistry:Register({
  gold_amount = 10000,
  name = "A True Leader",
  id = "A_TRUE_LEADER",
  getDescription = function(self)
    return string.format("You cannot swap leaders until the next checkpoint. Gain %s when you do reach the next checkpoint.", M_HELPERS.MakeColoredText(
        tostring(self.gold_amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue))
  end,

  on_checkpoint = function ()
    local data = EnchantmentRegistry:GetData(ATrueLeader)
    data["completed"] = true
    _DATA.Save.NoSwitching = false

  end,
  on_checkpoint_exit = function()
    local data = EnchantmentRegistry:GetData(self)
    if not data["completed"] then
      _DATA.Save.NoSwitching = true
    end
  end,
  offer_range = {3, 4},
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["completed"] = false

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue(string.format("Note: Your team cannot swap leaders until the next checkpoint.",
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
    UI:SetCenter(false)
  end
})


Tempo = EnchantmentRegistry:Register({
  name = "Tempo",
  id = "TEMPO",
  count = 15,
  getDescription = function(self)
    return string.format("For every %s enemies defeated, your team gains a random stat boost", M_HELPERS.MakeColoredText(tostring(self.count), PMDColor.Cyan))
  end,

  getProgressTexts = function(self)
    return {
      string.format("Enemies Defeated: %s/%s", tostring(EnchantmentRegistry:GetData(self)["defeated_enemies"]), tostring(self.count))
    }
  end,


  set_active_effects = function(self, active_effect, zone_context)
    local data = EnchantmentRegistry:GetData(self)
    data["defeated_enemies"] = data["defeated_enemies"] or 0

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        local data = EnchantmentRegistry:GetData(self)
        if data["defeated_enemies"] >= self.count then
          data["defeated_enemies"] = data["defeated_enemies"] % self.count

          local stat = GetRandomFromArray(STATS)
          local stat_text = RogueEssence.Text.ToLocal(stat)

          _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
            "All members in the active party gained [a/an] {0} stat boost!",
            stat_text)
          )

          for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
            BoostStat(stat, 1, member)
          end
        end
      end)

      local on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
        local team = context.User.MemberTeam
        if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe) then
          local data = EnchantmentRegistry:GetData(self)


          data["defeated_enemies"] = data["defeated_enemies"] + 1
        end
      end)

    end)




  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)

  end
})

-- When an enemy is hit. Only 1 enemy can be marked at a time.
Marksman = EnchantmentRegistry:Register({
  increased_damage_percent = 25,
  name = "Marksman",
  id = "MARKSMAN",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. When that member hits an enemy, that enemy is %s. %s enemies take %s more damage from all sources. Only one enemy can be %s at a time.",
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue), M_HELPERS.MakeColoredText("Marked", PMDColor.Blue),
      M_HELPERS.MakeColoredText(tostring(self.increased_damage_percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring("1") .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText("marked", PMDColor.Blue))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_marksman",
        EnchantmentID = self.id
      })))
  end,
  offer_time = "beginning",
  rarity = 1,
  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

FeelTheBurn = EnchantmentRegistry:Register({
  name = "Feel the Burn",
  chance = 15,
  id = "FEEL_THE_BURN",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local element = _DATA:GetElement("fire")
    return string.format(
      "Choose a team member. When that member is hit by a %s move, they will take %s additional damage and gain a speed boost",
      element:GetIconName(),
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_fire_speed_boost", EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end,
})

GlassCannon = EnchantmentRegistry:Register({
  name = "Glass Cannon",
  id = "GLASS_CANNON",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member will deal %s more damage but take %s more damage",
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_glass_cannon",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Sponge = EnchantmentRegistry:Register({
  name = "Sponge",
  id = "SPONGE",
  attack_boost = 50,
  defense_drop = 50,
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member will take %s less damage but deal %s less damage",
      M_HELPERS.MakeColoredText(tostring(self.defense_drop) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Red))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_sponge",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Ravenous = EnchantmentRegistry:Register({
  name = "Ravenous",
  id = "RAVENOUS",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Choose a team member. That member deals %s the more hungrier. At very low hunger, that member has a chance to be %s",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow),
      "confused"                                                                  --  M_HELPERS.MakeColoredText("confused", PMDColor.Red)
    -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_ravenous",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

Avenger = EnchantmentRegistry:Register({
  name = "Avenger",
  id = "AVENGER",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("Choose a team member. That member deals %s the more members that are fainted in the party",
      M_HELPERS.MakeColoredText("more damage", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_avenger",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)
  end
})

MonoMoves = EnchantmentRegistry:Register({
name = "Mono Moves",
id = "MONO_MOVES",
attack_boost = 35,
getDescription = function(self)
  return string.format(
    "Choose a team member. If all their moves are the %s, that member deals %s more damage.",
    M_HELPERS.MakeColoredText("same type", PMDColor.Yellow),
    M_HELPERS.MakeColoredText(tostring(self.attack_boost) .. "%", PMDColor.Cyan)
    -- M_HELPERS.MakeColoredText(tostring(self.attack_drop) .. "%", PMDColor.Red)
  )
end,
offer_time = "beginning",
rarity = 1,
getProgressTexts = function(self)
  local char = FindCharacterWithEnchantment(self.id)
  local char_name = char and char:GetDisplayName(true) or nil
  if char_name then
    return {
      "Assigned to: " .. char_name,
    }
  end
  return {}
end,

set_active_effects = function(self, active_effect, zone_context)
  active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_mono_moves", EnchantmentID = self.id })))
end,

apply = function(self)
  AssignEnchantmentToCharacter(self)
end,
})

HungerStrike = EnchantmentRegistry:Register({
  name = "Hunger Strike",
  amount = 5,
  id = "HUNGER_STRIKE",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Your party will lose hunger more quickly when walking. When they inflict damage with a move, the target will lose %s hunger points",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return {
        "Assigned to: " .. char_name,
      }
    end
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
    RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus",
        Serpent.line({ StatusID = "emberfrost_hunger_strike", EnchantmentID = self.id, ApplyToAll = true })))
  end,

  apply = function(self)
    -- UI:SetCenter(true)
    -- SOUND:PlayFanfare("Fanfare/Note")
    -- UI:WaitShowDialogue(string.format("Note: Your team will lose %s hunger points when walking.",
    --   M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.SkyBlue)))
    -- UI:SetCenter(false)
  end,
})

PandorasItems = EnchantmentRegistry:Register({
  amount = 1,
  gold_amount = 1000,
  name = "Pandora's Items",
  id = "PANDORAS_ITEMS",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Gain %s random %s, %s, and %s. At the start of each floor, any non-held items are randomized (except food, loots, and treasures)",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("equipment", PMDColor.Pink), M_HELPERS.MakeColoredText("orb", PMDColor.Pink),
      M_HELPERS.MakeColoredText("apricorn", PMDColor.Pink))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    return {}
    -- local data = EnchantmentRegistry:GetData(self)
    -- local equipment = data["equipment"]
    -- local orb = data["orb"]

    -- print(tostring(equipment))
    -- print(tostring(orb))
    -- print(Serpent.dump(SV.EmberFrost.Enchantments.Data) .. " hmmmm")
    -- print(Serpent.dump(EnchantmentRegistry._data) .. " hmmmm2")
    -- print("Are they the same table reference?")
    -- print(tostring(EnchantmentRegistry._data == SV.EmberFrost.Enchantments.Data))

    -- print(Serpent.dump(SV.EmberFrost.Enchantments.Seen) .. " hmmmm")
    -- print(Serpent.dump(EnchantmentRegistry._seen) .. " hmmmm2")

    -- local equipment_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(equipment)
    -- local orb_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(orb)
    -- local text = { "Equipment: " .. equipment_entry:GetIconName(), "Orb: " .. orb_entry:GetIconName() }

  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PandorasItemsModified"))
  end,

  apply = function(self)
    local random_orb = GetRandomFromArray(ORBS)
    local random_equipment = GetRandomFromArray(EQUIPMENT)
    local random_apricorn = GetRandomFromArray(APRICORNS)

    local amount = self.amount
    local items = { {
      Item = random_equipment,
      Amount = amount
    }, {
      Item = random_orb,
      Amount = amount
    }, {
      Item = random_apricorn,
      Amount = amount
    } }

    -- local data = EnchantmentRegistry:GetData(self)
    -- data["equipment"] = random_equipment
    -- data["orb"] = random_orb
    -- data["apricorn"] = random_apricorn

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

SupplyDrop = EnchantmentRegistry:Register({
  amount = 1,
  name = "Supply Drop",
  id = "SUPPLY_DROP",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format("After each checkpoint, gain a random supply drop containing %s",
      M_HELPERS.MakeColoredText("essential items", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,

  on_checkpoint = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["can_receive_supply_drop"] = true
  end,
  set_active_effects = function(self, active_effect, zone_context)
    -- local item_table = DUNGEON_WISH_TABLE[choice]
    -- local arguments = {}
    -- arguments.MinAmount = item_table.Min
    -- arguments.MaxAmount = item_table.Max
    -- arguments.Guaranteed = item_table.Guaranteed
    -- arguments.Items = item_table.Items
    -- arguments.UseUserCharLoc = true
    -- SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
    -- GAME:WaitFrames(60)
    local essentials_table = {
      Min = 2,
      Max = 2,
      Guaranteed = {
        {
          { Item = "food_apple",   Amount = 1, Weight = 10 },
          { Item = "berry_sitrus", Amount = 1, Weight = 10 },
          { Item = "berry_oran",   Amount = 1, Weight = 10 }
        }, 
        {
          { Item = "berry_leppa",  Amount = 1, Weight = 10 },
          { Item = "seed_reviver", Amount = 1, Weight = 10 }
        }, 
        {
          { Item = "seed_reviver", Amount = 1, Weight = 2 },
          { Item = "seed_ban",     Amount = 1, Weight = 2 },
          { Item = "seed_pure",    Amount = 1, Weight = 2 },
          { Item = "seed_joy",     Amount = 1, Weight = 2 }
        }, 
        {
          { Item = "ammo_geo_pebble",  Amount = 3, Weight = 3 },
          { Item = "ammo_gravelerock", Amount = 3, Weight = 3 },
          { Item = "ammo_stick",       Amount = 3, Weight = 3 }
        }
      },
      Items = {
        { Item = "food_apple",              Amount = 1, Weight = 2 },
        { Item = "berry_leppa",             Amount = 1, Weight = 2 },
        { Item = "berry_sitrus",            Amount = 1, Weight = 2 },
        { Item = "berry_oran",              Amount = 1, Weight = 2 },
        { Item = "berry_leppa",             Amount = 1, Weight = 2 },
        { Item = "berry_apicot",            Amount = 1, Weight = 2 },
        { Item = "berry_jaboca",            Amount = 1, Weight = 2 },
        { Item = "berry_liechi",            Amount = 1, Weight = 2 },
        { Item = "berry_starf",             Amount = 1, Weight = 2 },
        { Item = "berry_petaya",            Amount = 1, Weight = 2 },
        { Item = "berry_salac",             Amount = 1, Weight = 2 },
        { Item = "berry_ganlon",            Amount = 1, Weight = 2 },
        { Item = "berry_enigma",            Amount = 1, Weight = 2 },
        { Item = "berry_micle",             Amount = 1, Weight = 2 },
        { Item = "seed_ban",                Amount = 1, Weight = 2 },
        { Item = "seed_joy",                Amount = 1, Weight = 2 },
        { Item = "seed_decoy",              Amount = 1, Weight = 2 },
        { Item = "seed_pure",               Amount = 1, Weight = 3 },
        { Item = "seed_blast",              Amount = 1, Weight = 3 },
        { Item = "seed_ice",                Amount = 1, Weight = 3 },
        { Item = "seed_reviver",            Amount = 1, Weight = 2 },
        { Item = "seed_warp",               Amount = 1, Weight = 2 },
        { Item = "seed_doom",               Amount = 1, Weight = 2 },
        { Item = "seed_ice",                Amount = 1, Weight = 2 },
        { Item = "herb_white",              Amount = 1, Weight = 2 },
        { Item = "herb_mental",             Amount = 1, Weight = 2 },
        { Item = "herb_power",              Amount = 1, Weight = 2 },
        { Item = "orb_all_dodge",           Amount = 1, Weight = 2 },
        { Item = "orb_all_protect",         Amount = 1, Weight = 2 },
        { Item = "orb_cleanse",             Amount = 1, Weight = 2 },
        { Item = "orb_devolve",             Amount = 1, Weight = 2 },
        { Item = "orb_fill_in",             Amount = 1, Weight = 2 },
        { Item = "orb_endure",              Amount = 1, Weight = 2 },
        { Item = "orb_foe_hold",            Amount = 1, Weight = 2 },
        { Item = "orb_foe_seal",            Amount = 1, Weight = 2 },
        { Item = "orb_freeze",              Amount = 1, Weight = 2 },
        { Item = "orb_halving",             Amount = 1, Weight = 2 },
        { Item = "orb_invert",              Amount = 1, Weight = 2 },
        { Item = "orb_invisify",            Amount = 1, Weight = 2 },
        { Item = "orb_itemizer",            Amount = 1, Weight = 2 },
        { Item = "orb_luminous",            Amount = 1, Weight = 2 },
        { Item = "orb_pierce",              Amount = 1, Weight = 2 },
        { Item = "orb_scanner",             Amount = 1, Weight = 2 },
        { Item = "orb_mobile",              Amount = 1, Weight = 2 },
        { Item = "orb_mug",                 Amount = 1, Weight = 2 },
        { Item = "orb_nullify",             Amount = 1, Weight = 2 },
        { Item = "orb_mirror",              Amount = 1, Weight = 2 },
        { Item = "orb_spurn",               Amount = 1, Weight = 2 },
        { Item = "orb_slow",                Amount = 1, Weight = 2 },
        { Item = "orb_slumber",             Amount = 1, Weight = 2 },
        { Item = "orb_petrify",             Amount = 1, Weight = 2 },
        { Item = "orb_totter",              Amount = 1, Weight = 2 },
        { Item = "orb_invisify",            Amount = 1, Weight = 2 },
        { Item = "orb_one_room",            Amount = 1, Weight = 2 },
        { Item = "orb_totter",              Amount = 1, Weight = 2 },
        { Item = "orb_rebound",             Amount = 1, Weight = 2 },
        { Item = "orb_rollcall",            Amount = 1, Weight = 2 },
        { Item = "orb_stayaway",            Amount = 1, Weight = 2 },
        { Item = "orb_trap_see",            Amount = 1, Weight = 2 },
        { Item = "orb_trapbust",            Amount = 1, Weight = 2 },
        { Item = "orb_trawl",               Amount = 1, Weight = 2 },
        { Item = "orb_weather",             Amount = 1, Weight = 2 },
        { Item = "machine_recall_box",      Amount = 1, Weight = 2 },
        { Item = "machine_assembly_box",    Amount = 1, Weight = 2 },
        { Item = "machine_ability_capsule", Amount = 1, Weight = 2 },
        { Item = "medicine_elixir",         Amount = 1, Weight = 2 },
        { Item = "medicine_full_heal",      Amount = 1, Weight = 2 },
        { Item = "medicine_max_elixir",     Amount = 1, Weight = 2 },
        { Item = "medicine_max_potion",     Amount = 1, Weight = 2 },
        { Item = "medicine_potion",         Amount = 1, Weight = 2 },
        { Item = "medicine_x_accuracy",     Amount = 1, Weight = 2 },
        { Item = "medicine_x_attack",       Amount = 1, Weight = 2 },
        { Item = "medicine_x_defense",      Amount = 1, Weight = 2 },
        { Item = "medicine_x_sp_atk",       Amount = 1, Weight = 2 },
        { Item = "medicine_x_sp_atk",       Amount = 1, Weight = 2 },
        { Item = "medicine_x_speed",        Amount = 1, Weight = 2 },
        { Item = "ammo_cacnea_spike",       Amount = 3, Weight = 2 },
        { Item = "ammo_corsola_twig",       Amount = 3, Weight = 2 },
        { Item = "ammo_geo_pebble",         Amount = 3, Weight = 2 },
        { Item = "ammo_golden_thorn",       Amount = 3, Weight = 2 },
        { Item = "ammo_gravelerock",        Amount = 3, Weight = 2 },
        { Item = "ammo_iron_thorn",         Amount = 3, Weight = 2 },
        { Item = "ammo_rare_fossil",        Amount = 3, Weight = 2 },
        { Item = "ammo_silver_spike",       Amount = 3, Weight = 2 },
        { Item = "ammo_stick",              Amount = 3, Weight = 2 },
        { Item = "ammo_iron_thorn",         Amount = 3, Weight = 2 },
        { Item = "apricorn_big",            Amount = 1, Weight = 2 },
        { Item = "apricorn_black",          Amount = 1, Weight = 2 },
        { Item = "apricorn_blue",           Amount = 1, Weight = 2 },
        { Item = "apricorn_brown",          Amount = 1, Weight = 2 },
        { Item = "apricorn_green",          Amount = 1, Weight = 2 },
        { Item = "apricorn_plain",          Amount = 1, Weight = 2 },
        { Item = "apricorn_purple",         Amount = 1, Weight = 2 },
        { Item = "apricorn_red",            Amount = 1, Weight = 2 },
        { Item = "apricorn_white",          Amount = 1, Weight = 2 },
        { Item = "apricorn_yellow",         Amount = 1, Weight = 2 }
      }
    }

    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("SupplyDrop", Serpent.line({
      DropTable = essentials_table,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["can_receive_supply_drop"] = true

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("You will receive a %s after each checkpoint!",
      M_HELPERS.MakeColoredText("supply drop", PMDColor.Yellow)))
    UI:SetCenter(false)
    UI:ResetSpeaker()

    -- TODO: Set flag to indi
    -- local random_orb_index = math.random(#ORBS)
    -- local random_orb = ORBS[random_orb_index]
    -- local random_equipment_index = math.random(#EQUIPMENT)
    -- local random_equipment = EQUIPMENT[random_equipment_index]
    -- local amount = self.amount
    -- local items = {
    --   { Item = random_equipment, Amount = amount },
    --   { Item = random_orb, Amount = amount },
    -- }

    -- local data = EnchantmentRegistry:GetData(self)
    -- data["equipment"] = random_equipment
    -- data["orb"] = random_orb

    -- M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

YourAWizard = EnchantmentRegistry:Register({
  stack = 3,
  amount = 3,
  percent = 3,
  name = "You're a Wizard!",
  id = "YOURE_A_WIZARD",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    return string.format(
      "Gain %s stacks of %s random %s. Then select a party member. That member will gain %s special attack boost for each unique %s in your inventory.",
      M_HELPERS.MakeColoredText(tostring(self.stack), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("wands", PMDColor.Pink),
      M_HELPERS.MakeColoredText(tostring(self.percent) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText("wand", PMDColor.Pink)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)

    local data = EnchantmentRegistry:GetData(self)
    local wands = data["wands"]

    local str_arr = {
      "Recieved: ",
    }
    for _, wand in ipairs(wands) do
        local item = RogueEssence.Dungeon.InvItem(wand, false, self.amount)

        local wand_name = item:GetDisplayName()
        table.insert(str_arr, wand_name)
    end

    local unique_wands = {}
    local total_unique = 0

    local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
    for i = inv_count, 0, -1 do
        local item = _DATA.Save.ActiveTeam:GetInv(i)
        local item_id = item.ID
        print("Checking item in inventory: " .. tostring(item_id))
        if Contains(WANDS, item_id) then
            print("Found wand in inventory: " .. tostring(item_id)  )
            if unique_wands[item_id] == nil then
                unique_wands[item_id] = true
                total_unique = total_unique + 1
            end
        end
    end

    local player_count = _DATA.Save.ActiveTeam.Players.Count
    for player_idx = 0, player_count-1, 1 do
      local inv_item = GAME:GetPlayerEquippedItem(player_idx)
      local item_id = inv_item.ID
      if Contains(WANDS, item_id) then
          if unique_wands[item_id] == nil then
              unique_wands[item_id] = true
              total_unique = total_unique + 1
          end
      end
    end

    print("Total Unique Wands: " .. tostring(total_unique))
    local boost_amount = self.percent * total_unique

    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil

    table.insert(str_arr, "\n")
    table.insert(str_arr, "Assigned to: " .. char_name)
    table.insert(str_arr, "Special Attack Boost: " .. M_HELPERS.MakeColoredText(tostring(boost_amount) .. "%", PMDColor.Cyan))

    return str_arr
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "emberfrost_wizard", EnchantmentID = self.id })))
    -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
  end,

  apply = function(self)
    AssignEnchantmentToCharacter(self)

    local data = EnchantmentRegistry:GetData(self)
    data["wands"] = {}
    data["boost"] = 0

    local items = {}

    for i = 1, self.amount do
        local random_wand_index = math.random(#WANDS)
        local wand = WANDS[random_wand_index]

        table.insert(data["wands"], wand)

        table.insert(items, { Item = wand, Amount = self.stack })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)

  end,
})

PlantYourSeeds = EnchantmentRegistry:Register({
  money = 300,
  amount = 3,
  minimum = 5,
  name = "Plant Your Seeds",
  id = "PLANT_YOUR_SEEDS",
  getDescription = function(self)
    return string.format(
      "Gain %s random %s. At the start of each floor, if you have at least non-held %s, lose all of them and gain %s for each seed",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText("seeds", PMDColor.Pink),
      M_HELPERS.MakeColoredText(tostring(self.minimum), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.money) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local seeds = data["seeds"]
    local money_earned = data["money_earned"] or 0

    local str_arr = { "Recieved: " }
    for _, seed in ipairs(seeds) do
      local seed_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(seed)
      local seed_name = seed_entry:GetIconName()
      table.insert(str_arr, seed_name)
    end

    -- TODO: Account for the player is holding the seeds...
    local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
    local seed_index_arr = {}
    for i = inv_count, 0, -1 do
      local item = _DATA.Save.ActiveTeam:GetInv(i)
      local item_id = item.ID
      if Contains(SEED, item_id) then
        table.insert(seed_index_arr, i)
      end
    end

    table.insert(str_arr, "\n")
    table.insert(str_arr, "Seed Count: " .. M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan))
    table.insert(str_arr, "Total Earned: " ..
      M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))

    return str_arr
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({
      MoneyPerSeed = self.money,
      MinimumSeeds = self.minimum,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["seeds"] = {}
    data["money_earned"] = 0

    local items = {}

    for i = 1, self.amount do

      
      local seed = GetRandomFromArray(SEED)

      table.insert(data["seeds"], seed)

      table.insert(items, {
        Item = seed,
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

ExitStrategy = EnchantmentRegistry:Register({
  pure_seed_amount = 2,
  warp_wands_amount = 9,
  salac_amount = 3,
  name = "Exit Strategy",
  id = "EXIT_STRATEGY",
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local warp_scarf = M_HELPERS.GetItemName("held_warp_scarf")
    local pure_seed = M_HELPERS.GetItemName("seed_pure")
    local warp_wand_name = M_HELPERS.GetItemName("wand_warp")

    return string.format(
      "Choose a team member. They will see the direction of the stairs at the start of each floor. Gain a %s, %s %s, %s %s, and %s %s.",
      warp_scarf, M_HELPERS.MakeColoredText(tostring(self.pure_seed_amount), PMDColor.Cyan), pure_seed,
      M_HELPERS.MakeColoredText(tostring(self.warp_wands_amount), PMDColor.Cyan), warp_wand_name,
      M_HELPERS.MakeColoredText(tostring(self.salac_amount), PMDColor.Cyan), M_HELPERS.GetItemName("berry_salac"))
  end,
  getProgressTexts = function(self)
    local char = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil
    if char_name then
      return { "Assigned to: " .. char_name }
    end
    return {}
  end,
  offer_time = "beginning",
  rarity = 1,
  -- getProgressTexts = function(self)

  --   local data = EnchantmentRegistry:GetData(self)
  --   local seeds = data["seeds"]
  --   local money_earned = data["money_earned"]

  --   local str_arr = {
  --     "Recieved: ",
  --   }
  --   for _, seed in ipairs(seeds) do
  --       local seed_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(seed)
  --       local seed_name = seed_entry:GetIconName()
  --       table.insert(str_arr, seed_name)
  --   end

  --   -- TODO: Account for the player is holding the seeds...
  --   local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
  --   local seed_index_arr = {}
  --   for i = inv_count, 0, -1 do
  --       local item = _DATA.Save.ActiveTeam:GetInv(i)
  --       local item_id = item.ID
  --       if Contains(SEED, item_id) then
  --           table.insert(seed_index_arr, i)
  --       end
  --   end

  --   table.insert(str_arr, "\n")
  --   table.insert(str_arr, "Seed Count: " .. M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan))
  --   table.insert(str_arr, "Money Earned: " .. M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))

  --   return str_arr
  -- end,

  -- set_active_effects = function(self, active_effect, zone_context)
  -- active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("PlantYourSeeds", Serpent.line({ MoneyPerSeed = self.money, MinimumSeeds = self.minimum, EnchantmentID = self.id })))
  -- end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "emberfrost_stairs_sensor",
        EnchantmentID = self.id
      })))
  end,

  apply = function(self)
    local items = { {
      Item = "held_warp_scarf",
      Amount = 1
    }, {
      Item = "wand_warp",
      Amount = self.warp_wands_amount
    } }

    for i = 1, self.pure_seed_amount do
      table.insert(items, {
        Item = "seed_pure",
        Amount = 1
      })
    end

    for i = 1, self.salac_amount do
      table.insert(items, {
        Item = "berry_salac",
        Amount = 1
      })
    end

    M_HELPERS.GiveInventoryItemsToPlayer(items)
    AssignEnchantmentToCharacter(self)
  end
})
TheBubble = EnchantmentRegistry:Register({
  interest = 0.10,
  start = 0,
  pop_increase = 1.5,
  loss = 0.45,
  name = "The Bubble",
  id = "THE_BUBBLE",
  cleanup = function (self)
    M_HELPERS.RemoveItemIDFromInventory("emberfrost_bubble")
  end,
  -- group = ENCHANTMENT_TYPES.items,
  getDescription = function(self)
    local bubble = M_HELPERS.GetItemName("emberfrost_bubble")
    return string.format(
      "Gain a %s (Gain %s interest at start of floor. If the %s pops, lose %s of your %s and it will reset. Pop chance increases by %s each floor)",
      bubble,
      M_HELPERS.MakeColoredText(tostring(math.ceil(self.interest * 100)).. "%", PMDColor.Cyan),
      bubble,
      M_HELPERS.MakeColoredText(tostring(math.ceil(self.loss * 100)) .. "%", PMDColor.Red),
      PMDSpecialCharacters.Money,
      M_HELPERS.MakeColoredText(tostring(self.pop_increase) .. "%", PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0
    local money_lost = data["money_lost"] or 0
    local pop_chance = data["pop_chance"] or 0

    return { "Money Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan),
      "Money Lost: " ..
      M_HELPERS.MakeColoredText(tostring(money_lost) .. " " .. PMDSpecialCharacters.Money, PMDColor.Red),
      "Current Pop Chance: " .. M_HELPERS.MakeColoredText(tostring(pop_chance) .. "%", PMDColor.Cyan) }
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    data["money_lost"] = 0
    data["pop_chance"] = self.start

    local items = { {
      Item = "emberfrost_bubble",
      Amount = 1
    } }
    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

StackOfPlates = EnchantmentRegistry:Register({
  amount = 2,
  choice = 5,
  name = "Stack of Plates",
  id = "STACK_OF_PLATES",
  getDescription = function(self)
    return string.format(
      "Gain %s random type %s. Then select a %s from a choice of %s ",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring("plates"), PMDColor.Pink),
      M_HELPERS.MakeColoredText(tostring("plate"), PMDColor.Pink),
      M_HELPERS.MakeColoredText(tostring(self.choice), PMDColor.Cyan)
    )
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)

    local data = EnchantmentRegistry:GetData(self)
    local plates = data["plates"]

    local str_arr = {
      "Recieved: ",
    }
    for _, plate in ipairs(plates) do
        local plate_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(plate)
        local plate_name = plate_entry:GetIconName()
        table.insert(str_arr, plate_name)
    end

    return str_arr
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["plates"] = {}

    local random_items = {}

    for i = 1, self.amount do
        local random_plate_index = math.random(#PLATES)
        local plate = PLATES[random_plate_index]
        table.insert(data["plates"], plate)
        table.insert(random_items, { Item = plate, Amount = 1 })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(random_items)

    GAME:WaitFrames(20)

    local pool_items = {}

    local plates = GetRandomUnique(PLATES, 5)
    for _, plate in ipairs(plates) do
        table.insert(pool_items, { Item = plate, Amount = 1 })
    end

    local result = SelectItemFromList(
      string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
      pool_items
    )

    table.insert(data["plates"], result.Item)
    GAME:WaitFrames(20)
    M_HELPERS.GiveInventoryItemsToPlayer({ result })
  end
})


Protagonist = EnchantmentRegistry:Register({
  name = "Protagonist",
  id = "PROTAGONIST",
  boost = 20,
  getDescription = function(self)
    return string.format(
      "The %s takes reduced damage from enemies and deals increased damage",
      M_HELPERS.MakeColoredText("active leader", PMDColor.Yellow)

    )
  end,
  offer_time = "beginning",
  rarity = 1,
  set_active_effects = function(self, active_effect, zone_context)
    print("Setting active effects for Protagonist enchantment")
    active_effect.BeforeHits:Add(2,
      RogueEssence.Dungeon.BattleScriptEvent("Protagonist", Serpent.line({
        BoostAmount = self.boost
      })))
  end,

  getProgressTexts = function(self)

    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      return {
        "Active Leader: " .. _DUNGEON.ActiveTeam.Leader:GetDisplayName(true) or nil
      }
    else
      return {}
    end

  end,

  apply = function(self)
    FanfareText(string.format("The %s will now take reduced damage from enemies and deals increased damage!",
      M_HELPERS.MakeColoredText("active leader", PMDColor.Yellow)))
  end
})


function CountAssemblyWithKey(key)
  local count = 0
  for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
    local tbl = LTBL(member)
    if tbl ~= nil and tbl[key] == true then
      count = count + 1
    end
  end
  return count
end

MoralSupport = EnchantmentRegistry:Register({
  name = "Moral Support",
  id = "MORAL_SUPPORT",
  boost = 3,
  key = "EmberfrostRun",

  get_total_boost = function(self)

    local count = CountAssemblyWithKey(self.key)
    return count * self.boost
  end,
  getDescription = function(self)
    return string.format(
      "Your team gains a %s boost for each team member in the assembly recruited during this run",
      M_HELPERS.MakeColoredText(tostring(self.boost) .. "%", PMDColor.Cyan)

    )
  end,
  offer_time = "beginning",
  rarity = 1,
  set_active_effects = function(self, active_effect, zone_context)
    print("Setting active effects for Moral Support enchantment")
    active_effect.BeforeHits:Add(2,
      RogueEssence.Dungeon.BattleScriptEvent("MoralSupport", Serpent.line({
        EnchantmentID = self.id,
      })))
  end,

  getProgressTexts = function(self)
    local total_boost = self:get_total_boost()
    return {
      "Total Boost: " .. M_HELPERS.MakeColoredText(tostring(total_boost) .. "%", PMDColor.Cyan)
    }
  end,

  apply = function(self)
    FanfareText(string.format("Your team will now gain a %s attack boost for each team member recruited this run!",
      M_HELPERS.MakeColoredText(tostring(self.boost) .. "%", PMDColor.Cyan)))
  end
})

-- For each equipment in your inventory, gain a 3% attack boost.
-- Fashionable = EnchantmentRegistry:Register({
--   "for each unique specs or googles"

-- })
--
-- Vampiric - Select a character, that character heals for 30% of damage dealt.
-- An exclusive item for the Salamence family. When kept in the bag, it allows Dragon-type moves to hit Fairy-type Pokémon.
-- Dazzled - Choose a team member. For each equipment, lower the accuracy of the target
-- RunAndGun - Projectiles deal more damage if your team has a speed boost, depends on it
-- Spawn NPCs, which will give you rewards
-- Fitness - Each food item grants more hunger points, boosts to yourself
-- For 10 enemies fainted with an ammo,
-- Precision - Choose a team member. That team member. Moves that have less than 80% accuracy cannot miss. Moves with accuracy will miss more often
-- From now to the next checkpoint, spawn buried treasueres
-- Start of each floor, gain 1 PP in each move slot
-- Spawn more apricrons
-- Spawn more seeds
-- Checkpoint shop costs will be reduced by 20%
-- Randomly explode the enemies
-- All your party members gain the stat boost of the highest party member
-- Lots of Equipment: Select 3 equipment from a pool of 5 random ones.
-- Have a 50% chance to an item
-- More buried treasures spawn
-- Type Mastery  - If you recruit all types, gain a huge reward (includes assembly).
-- Trap Tripper Specialist - For every unique trap triggered on that floor, gain money
-- Shops, vaults, and  are more likely to show up
-- Monotype - If all your team members share a common type, gain a damage boost (Requires 3+ members).
-- Elemental Affinity - Choose a type. Your team does more damage with that type, but takes more damage from that type.
-- Weathered - Your team gains a boost depending on the current weather condition. Rain 
-- All In - Lost all your inventory items and (only offered past floor 15)
-- Gain 3 Invisibioty orbs
-- Regular attacks can destroy walls at the cost of 1 hunger
-- The Orb - Each orb usage increases your team's damage
-- Gain 2 random allies from the previous floors. Gain an assembly box. They have gummi boosts with random equioment attatched
-- RPG Gold - Your team has 25% chance to gain 50 p from an enemies. -- Enemies have a 50% chance to drop gold based on their level
-- Combo Chain: When you use 3 skills in a row. Second The final attack will be critical and deal double damage
-- Your team gains a critical chance boost
-- Your team does slighty more damage for super-effective moves.
-- Allowance - Gain 200 each mon that is not fully evolved at the start of each floor
-- Your team takes slightly more damage for not very effective moves.
-- All for one - Choose a team member. That members gains for power for each team member within 1 tile.
-- One for all - Choose a team member. That members transfer ALL status to all adjacent allies upon recieiving a status.
-- Team Building - Gain 2 random apricorns. Select a between apricrons and 2 amber tears and a friend bow. Gain a Assembly Box
-- Negligible Risk?: - Gain 20,000 P. Your team has a tiny chance to be inflicted with a random negative status at the end of the their turn
-- Gain a random gummi at the start of each floor.
-- Death Defying/ Second Wind - Gain a death amulet. If that member would faint, 50% chance to survive with 1 HP instead. When at 1 HP, gain a speed boost.
-- Quick Reflexes - Choose a team member. That member has a chance to dodge physical attacks.
-- Elusive - Each team gains a evasive boost at the start of each floor
-- Restart Mission - Lose all items in your inventory.
-- Each of your team member loses 2 levels. When the next checkpoint is reached, gain 5 levels for each team member.
-- Killing Blow - Choose a team member. Explode area around enemy when defeated
-- Execute - Choose a team member. That member will defeat any enemies below 20% HP.
-- I C - Gain an X-ray specs. Your team can see invisible traps.
-- Huddle - Defense
-- Alchemy - At the start of each floor, any evo stones or plates has a small chance to convert to a gold nugget
-- Safety Net / Emergency Fund - Gain 1,000 P when a team member faints. Gain a reviver seed
-- Evo: Gain +10 boosts for each evolution
-- Solo Mission - When your team has only 1 member, that member does more damage
-- Hoarder - More money when you have more items in your inventory
-- Fitness Routine - Speed boost when your team has more than 75% hunger (ewwww, better)
-- Full Belly Happy Heart
-- Resilience - Take less damage from super-effective moves
-- Nitroglycerin - Speed boost when low on hunger
-- Choose a character. Super-effective moves deal less damage
-- Bargainer: Half off from shop. I don’t know why, but I feel like giving everything to you half off now
-- Affluent: Calculate the cost of inventory. Do damage based on total. Easier to recruit monsters.
-- Material Investment - Earn interest 5% based on the cost of your inventory at the start of each floor.
-- Ranged: Select a team member. That member gets +1 tange.
-- Underdogs: Your team does more damage when lower leveled than the enemy
-- Immunity: Choose a team member. That member is immune to negative status effects.
-- Treausre Tracker: Gain a trackr. Will reveal buried within 20 tiles
-- Level Up: Choose a team member. That member gains 5 levels.
-- Reroll: For the next enchantment selections. Gain an extra reroll.
-- Flexible: Gain 20,000 P, you will not know what your enchantment will be until you select it.
-- Your next enchantment selection gains an extra reroll.
-- Toll (Scorched): Select a team member. Lose 50 G of your money when the character damage or 50 gold (whichever is higher) Do higher damage based on the toll
-- Pay-to-Win - Pay 3,000 P, you can select another two enchantments afterwards
-- 2 for 1 Special - Gain two random enchantments
-- Tiny, but Mighty - Choose a team member. That member is smaller, but deals more damage.
-- Heavy Hitter - Choose a team member. If that member is weight, but takes more damage
-- Self-Improvment - Gain 1 nectors, 1 ability capsule, 1 recall box, 1 joy seed, 1 citrus 1 protein
-- LotsOfStats
-- Life Orb - Gain a life-orb

-- When you pick up gold - Gain a random state boost.
-- Drain Terrain - Fill gaps - Moves can fill gaps
-- Mission Impossible
-- Limit to only 1 boost except for speed.
-- OneTrick - Choose a team member. That member is permenatly locked into 1 skill for the rest of the dungeon. Deal double damage
-- StandGround - Standing in spot leaves a post which gains an attack boost
-- Trick Shot - Arc projectiles do more damage
-- Vitamins Gummmies -
-- Power of 3s - For every 3 of the same item in inventory, gain a boost
-- Mileage - For every 300 tiles walked, gain a small boost to speed
-- Gain a random vitamin fo
-- Life-Steal+
-- Revival Blessing - Gain a reviver orb.
-- Insurance - Whenever a team member faints, gain 1000 P
-- 3-1 Special - Gain
-- Ranged+: Select a team member. That member gets +1 tange.
-- Marksmen: Choose a team member. That member’s projectiles deal more damage. Mark the target. That target will take additonal damage
-- {
-- "Key": {
-- "str": [
-- 0
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.SpeedPowerEvent, PMDC",
-- "Reverse": false
-- }
-- }
-- ],
-- "OnHits": [
-- {
-- "Key": {
-- "str": [
-- -1
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.DamageFormulaEvent, PMDC"
-- }
-- }
-- Bounty Hunter - After collecting 15 bounties, gain a reward Has to be 2.
-- Level Boost - After each checkpoint, each party memmber gains 3 levels

-- deep boulder quarry


local type_master_drops = {
  Min = 2,
  Max = 3,
  Guaranteed = {
    {
      { Item = "loot_nugget",   Amount = 1, Weight = 10 },
    },

    {
      { Item = "held_x_ray_specs", Amount = 1, Weight = 10 },
    },
    {
      { Item = "machine_recall_box", Amount = 1, Weight = 10 },
    },
    {
      { Item = "machine_assembly_box", Amount = 1, Weight = 10 },
    },
    {
      { Item = "machine_ability_capsule", Amount = 1, Weight = 10 },
    },
    {
      { Item = "loot_star_piece", Amount = 1, Weight = 10 },
    },
    {
      { Item = "loot_pearl", Amount = 3, Weight = 10 },
    },
    {
      { Item = "loot_pearl", Amount = 3, Weight = 10 },
    },
    {
      { Item = "loot_pearl", Amount = 3, Weight = 10 },
    },
    {
      { Item = "held_x_ray_specs", Amount = 1, Weight = 10 },
    },
    {
      { Item = "food_banana",     Amount = 1, Weight = 2 },
      { Item = "food_banana_big", Amount = 1, Weight = 2 }
    }
  },
  Items = {
    { Item = "medicine_max_elixir",     Amount = 1, Weight = 2 },
    { Item = "medicine_max_potion",     Amount = 1, Weight = 2 },
    { Item = "medicine_amber_tear",     Amount = 1, Weight = 2 },
    { Item = "medicine_amber_tear", Amount = 1, Weight = 2 },
    { Item = "evo_dawn_stone",      Amount = 1, Weight = 3 },
    { Item = "evo_dusk_stone",      Amount = 1, Weight = 3 },
    { Item = "evo_fire_stone",      Amount = 1, Weight = 3 },
    { Item = "evo_harmony_scarf",   Amount = 1, Weight = 1 },
    { Item = "evo_ice_stone",       Amount = 1, Weight = 3 },
    { Item = "evo_leaf_stone",      Amount = 1, Weight = 3 },
    { Item = "evo_link_cable",      Amount = 1, Weight = 3 },
    { Item = "evo_lunar_ribbon",    Amount = 1, Weight = 3 },
    { Item = "evo_moon_stone",      Amount = 1, Weight = 3 },
    { Item = "evo_shiny_stone",     Amount = 1, Weight = 3 },
    { Item = "evo_thunder_stone",   Amount = 1, Weight = 3 },
    { Item = "evo_water_stone",     Amount = 1, Weight = 3 },
    { Item = "held_blank_plate",    Amount = 1, Weight = 1 },
    { Item = "held_draco_plate",    Amount = 1, Weight = 1 },
    { Item = "held_dread_plate",    Amount = 1, Weight = 1 },
    { Item = "held_earth_plate",    Amount = 1, Weight = 1 },
    { Item = "held_fist_plate",     Amount = 1, Weight = 1 },
    { Item = "held_flame_plate",    Amount = 1, Weight = 1 },
    { Item = "held_icicle_plate",   Amount = 1, Weight = 1 },
    { Item = "held_insect_plate",   Amount = 1, Weight = 1 },
    { Item = "held_iron_plate",     Amount = 1, Weight = 1 },
    { Item = "held_meadow_plate",   Amount = 1, Weight = 1 },
    { Item = "held_mind_plate",     Amount = 1, Weight = 1 },
    { Item = "held_pixie_plate",    Amount = 1, Weight = 1 },
    { Item = "held_sky_plate",      Amount = 1, Weight = 1 },
    { Item = "held_splash_plate",   Amount = 1, Weight = 1 },
    { Item = "held_spooky_plate",   Amount = 1, Weight = 1 },
    { Item = "held_stone_plate",    Amount = 1, Weight = 1 },
    { Item = "held_toxic_plate",    Amount = 1, Weight = 1 },
    { Item = "held_zap_plate",      Amount = 1, Weight = 1 },
    { Item = "gummi_wonder",        Amount = 1, Weight = 1 },
    { Item = "orb_revival",         Amount = 1, Weight = 2 },
    { Item = "food_apple_huge",     Amount = 1, Weight = 5 },
    { Item = "food_apple_perfect",  Amount = 1, Weight = 2 },
    { Item = "food_banana",         Amount = 1, Weight = 4 },
    { Item = "food_banana_big",     Amount = 1, Weight = 2 }
  }
  --   { Item = "food_apple",              Amount = 1, Weight = 2 },
  --   { Item = "berry_leppa",             Amount = 1, Weight = 2 },
  --   { Item = "berry_sitrus",            Amount = 1, Weight = 2 },
  --   { Item = "berry_oran",              Amount = 1, Weight = 2 },
  --   { Item = "berry_leppa",             Amount = 1, Weight = 2 },
  --   { Item = "berry_apicot",            Amount = 1, Weight = 2 },
  --   { Item = "berry_jaboca",            Amount = 1, Weight = 2 },
  --   { Item = "berry_liechi",            Amount = 1, Weight = 2 },
  --   { Item = "berry_starf",             Amount = 1, Weight = 2 },
  --   { Item = "berry_petaya",            Amount = 1, Weight = 2 },
  --   { Item = "berry_salac",             Amount = 1, Weight = 2 },
  --   { Item = "berry_ganlon",            Amount = 1, Weight = 2 },
  --   { Item = "berry_enigma",            Amount = 1, Weight = 2 },
  --   { Item = "berry_micle",             Amount = 1, Weight = 2 },
  --   { Item = "seed_ban",                Amount = 1, Weight = 2 },
  --   { Item = "seed_joy",                Amount = 1, Weight = 2 },
  --   { Item = "seed_decoy",              Amount = 1, Weight = 2 },
  --   { Item = "seed_pure",               Amount = 1, Weight = 3 },
  --   { Item = "seed_blast",              Amount = 1, Weight = 3 },
  --   { Item = "seed_ice",                Amount = 1, Weight = 3 },
  --   { Item = "seed_reviver",            Amount = 1, Weight = 2 },
  --   { Item = "seed_warp",               Amount = 1, Weight = 2 },
  --   { Item = "seed_doom",               Amount = 1, Weight = 2 },
  --   { Item = "seed_ice",                Amount = 1, Weight = 2 },
  --   { Item = "herb_white",              Amount = 1, Weight = 2 },
  --   { Item = "herb_mental",             Amount = 1, Weight = 2 },
  --   { Item = "herb_power",              Amount = 1, Weight = 2 },
  --   { Item = "orb_all_dodge",           Amount = 1, Weight = 2 },
  --   { Item = "orb_all_protect",         Amount = 1, Weight = 2 },
  --   { Item = "orb_cleanse",             Amount = 1, Weight = 2 },
  --   { Item = "orb_devolve",             Amount = 1, Weight = 2 },
  --   { Item = "orb_fill_in",             Amount = 1, Weight = 2 },
  --   { Item = "orb_endure",              Amount = 1, Weight = 2 },
  --   { Item = "orb_foe_hold",            Amount = 1, Weight = 2 },
  --   { Item = "orb_foe_seal",            Amount = 1, Weight = 2 },
  --   { Item = "orb_freeze",              Amount = 1, Weight = 2 },
  --   { Item = "orb_halving",             Amount = 1, Weight = 2 },
  --   { Item = "orb_invert",              Amount = 1, Weight = 2 },
  --   { Item = "orb_invisify",            Amount = 1, Weight = 2 },
  --   { Item = "orb_itemizer",            Amount = 1, Weight = 2 },
  --   { Item = "orb_luminous",            Amount = 1, Weight = 2 },
  --   { Item = "orb_pierce",              Amount = 1, Weight = 2 },
  --   { Item = "orb_scanner",             Amount = 1, Weight = 2 },
  --   { Item = "orb_mobile",              Amount = 1, Weight = 2 },
  --   { Item = "orb_mug",                 Amount = 1, Weight = 2 },
  --   { Item = "orb_nullify",             Amount = 1, Weight = 2 },
  --   { Item = "orb_mirror",              Amount = 1, Weight = 2 },
  --   { Item = "orb_spurn",               Amount = 1, Weight = 2 },
  --   { Item = "orb_slow",                Amount = 1, Weight = 2 },
  --   { Item = "orb_slumber",             Amount = 1, Weight = 2 },
  --   { Item = "orb_petrify",             Amount = 1, Weight = 2 },
  --   { Item = "orb_totter",              Amount = 1, Weight = 2 },
  --   { Item = "orb_invisify",            Amount = 1, Weight = 2 },
  --   { Item = "orb_one_room",            Amount = 1, Weight = 2 },
  --   { Item = "orb_totter",              Amount = 1, Weight = 2 },
  --   { Item = "orb_rebound",             Amount = 1, Weight = 2 },
  --   { Item = "orb_rollcall",            Amount = 1, Weight = 2 },
  --   { Item = "orb_stayaway",            Amount = 1, Weight = 2 },
  --   { Item = "orb_trap_see",            Amount = 1, Weight = 2 },
  --   { Item = "orb_trapbust",            Amount = 1, Weight = 2 },
  --   { Item = "orb_trawl",               Amount = 1, Weight = 2 },
  --   { Item = "orb_weather",             Amount = 1, Weight = 2 },
  --   { Item = "machine_recall_box",      Amount = 1, Weight = 2 },
  --   { Item = "machine_assembly_box",    Amount = 1, Weight = 2 },
  --   { Item = "machine_ability_capsule", Amount = 1, Weight = 2 },
  --   { Item = "medicine_elixir",         Amount = 1, Weight = 2 },
  --   { Item = "medicine_full_heal",      Amount = 1, Weight = 2 },
  --   { Item = "medicine_max_elixir",     Amount = 1, Weight = 2 },
  --   { Item = "medicine_max_potion",     Amount = 1, Weight = 2 },
  --   { Item = "medicine_potion",         Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_accuracy",     Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_attack",       Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_defense",      Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_sp_atk",       Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_sp_atk",       Amount = 1, Weight = 2 },
  --   { Item = "medicine_x_speed",        Amount = 1, Weight = 2 },
  --   { Item = "ammo_cacnea_spike",       Amount = 3, Weight = 2 },
  --   { Item = "ammo_corsola_twig",       Amount = 3, Weight = 2 },
  --   { Item = "ammo_geo_pebble",         Amount = 3, Weight = 2 },
  --   { Item = "ammo_golden_thorn",       Amount = 3, Weight = 2 },
  --   { Item = "ammo_gravelerock",        Amount = 3, Weight = 2 },
  --   { Item = "ammo_iron_thorn",         Amount = 3, Weight = 2 },
  --   { Item = "ammo_rare_fossil",        Amount = 3, Weight = 2 },
  --   { Item = "ammo_silver_spike",       Amount = 3, Weight = 2 },
  --   { Item = "ammo_stick",              Amount = 3, Weight = 2 },
  --   { Item = "ammo_iron_thorn",         Amount = 3, Weight = 2 },
  --   { Item = "apricorn_big",            Amount = 1, Weight = 2 },
  --   { Item = "apricorn_black",          Amount = 1, Weight = 2 },
  --   { Item = "apricorn_blue",           Amount = 1, Weight = 2 },
  --   { Item = "apricorn_brown",          Amount = 1, Weight = 2 },
  --   { Item = "apricorn_green",          Amount = 1, Weight = 2 },
  --   { Item = "apricorn_plain",          Amount = 1, Weight = 2 },
  --   { Item = "apricorn_purple",         Amount = 1, Weight = 2 },
  --   { Item = "apricorn_red",            Amount = 1, Weight = 2 },
  --   { Item = "apricorn_white",          Amount = 1, Weight = 2 },
  --   { Item = "apricorn_yellow",         Amount = 1, Weight = 2 }
  -- }
}



TypeMaster = EnchantmentRegistry:Register({


  valid_types = { "normal", "fire", "water", "electric", "grass", "ice", "fighting", "poison",
    "ground", "flying", "psychic", "bug", "rock", "ghost", "dragon", "dark", "steel", "fairy" },

  get_type_progress = function(self)
    local type_set = {}
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.EmberfrostRun == true then
        local element1 = member.Element1
        local element2 = member.Element2
        if element1 ~= "" then
          type_set[element1] = true
        end
        if element2 ~= "" then
          type_set[element2] = true
        end
      end
    end

    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do

      local element1 = member.Element1
      local element2 = member.Element2
      if element1 ~= "" then
        type_set[element1] = true
      end
      if element2 ~= "" then
        type_set[element2] = true
      end
  
    end

    local type_count = 0
    local missing = {}
    for _, valid_type in ipairs(self.valid_types) do
      if type_set[valid_type] then
        type_count = type_count + 1
      else
        table.insert(missing, valid_type)
      end
    end

    return { count = type_count, missing = missing }
  end,

  completed = function(self)
    local progress = self:get_type_progress()
    return progress.count >= #self.valid_types
  end,
  name = "Type Mastery",
  id = "TYPE_MASTERY",
  getDescription = function(self)
    -- local type_count = self:get_type_progress().count
    local total_types = #self.valid_types

    return string.format("If your team has recruited all %s types, gain a massive reward",
      M_HELPERS.MakeColoredText(tostring(total_types), PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)

    local progress = self:get_type_progress()
    local type_count = progress.count
    local total_types = #self.valid_types
    local missing = progress.missing

    local icon
    
    if self:completed() then
      icon = PMDSpecialCharacters.Check
    else
      icon = PMDSpecialCharacters.Cross
    end

    local str_arr = {
      icon .. " Types Collected: " .. M_HELPERS.MakeColoredText(tostring(type_count) .. "/" .. tostring(total_types), PMDColor.Cyan),
    }

    if #missing > 0 then
      table.insert(str_arr, "Missing Types: ")
      local line = ""
      for i, missing_type in ipairs(missing) do
        local element = _DATA:GetElement(missing_type):GetIconName()
        line = line .. element

        if i < #missing then
          line = line .. ", "
        end

        if i % 3 == 0 or i == #missing then
          table.insert(str_arr, line)
          line = ""
        end
      end
    end

    return str_arr
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = EnchantmentRegistry:GetData(self)
    if data["rewarded"] then
      return
    end
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_turn_ends_id
      on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        if self:completed() then
          beholder.stopObserving(on_turn_ends_id)
          beholder.trigger("OnTypeMasterCompleted")
          GAME:WaitFrames(30)
          data["rewarded"] = true
          local arguments = {}
          arguments.MinAmount = type_master_drops.Min
          arguments.MaxAmount = type_master_drops.Max
          arguments.Guaranteed = type_master_drops.Guaranteed
          arguments.Items = type_master_drops.Items
          arguments.UseUserCharLoc = true
          FanfareText("Type Mastery Completed!")
          GAME:WaitFrames(10)
          local old = context.User
          context.User = _DUNGEON.ActiveTeam.Leader
          SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
          GAME:WaitFrames(20)
          context.User = old
        end
      end)
    end)
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["rewarded"] = false

  end
})

Minimalist = EnchantmentRegistry:Register({
  amount = 50,
  name = "Minimalist",
  id = "MINIMALIST",
  getDescription = function(self)
    return string.format("At the start of each floor, gain %s for each available item slot in your inventory",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0

    return { "Total Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- Should occur before the quests are logged
    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("Minimalist", Serpent.line({
      AmountPerSlot = self.amount,
      EnchantmentID = self.id
    })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    FanfareText(string.format(
      "You will gain %s for each available item slot in your inventory at the start of each floor!",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})

TrapTripper = EnchantmentRegistry:Register({
  amount = 50,
  name = "Trap Tripper",
  id = "TRAP_TRIPPER",
  getDescription = function(self)
    return string.format("For each different trap triggered on a floor, gain %s",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local money_earned = data["money_earned"] or 0

    return { "Total Earned: " ..
    M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan) }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- Should occur before the quests are logged
    -- active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("TrapTripper", Serpent.line({
    --   AmountPerSlot = self.amount,
    --   EnchantmentID = self.id
    -- })))
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0
    FanfareText(string.format(
      "You will gain %s for each available item slot in your inventory at the start of each floor!",
      M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})



GetCharacterOfMatchingType = function(type, include_assembly)

  -- local count = 0
  local tbl = {}
  for member in luanet.each(_DATA.Save.ActiveTeam.Players) do

    local element1 = member.Element1
    local element2 = member.Element2

    if element1 == type or element2 == type then
      table.insert(tbl, member)
    end
  end


  if include_assembly then
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      if tbl.EmberfrostRun then

        local element1 = member.Element1
        local element2 = member.Element2

        if element1 == type or element2 == type then
          table.insert(tbl, member)
        end
      end
    end
  end

  return tbl
end



-- Rationalize: This Pokémon's Normal-Type moves are Super Effective to Fairy, Ghosts, and Dragon-Types in exchange for Moves from those Types becoming Super Effective to this Pokémon.
-- https://gamefaqs.gamespot.com/boards/359435-pokemon-violet/80421481

-- Deep Dweller - raises SpD when hit by a water type move 

--  Dark Tranquility - powers down moves of opponents if they move after the pokemon with this ability

-- Daunt - lowers the opponent's speed everytime it enters the field by 1 stage (like intimidate)

-- Deceiver - if any other pokemon on the field boosts its stats, the pokemon with this ability will steal them. Does not affect stats that are lowered or where already boosted before this pokemon entered the field

-- Deep Dweller - raises SpD when hit by a water type move

-- Diver - grants STAB for water type moves

-- Draconian - makes normal type moves dragon type moves and gives them a boost in power

-- Dynamo - regenerates a bit of health when the pokemon uses an electric type move

-- Eco-Maintaining - draining and healing moves have their effect boosted

-- Emperor - moves get a small chance to lower the opponent's defense

-- Explosive Point - when hit by a move that makes contact, it will damage the attacker as well

-- Explosive Swim - when hit by a water or fire type move, it will raise your speed, instead of taking damage

-- Fairy Spore - when this pokemon is on the field, there is a 30% chance that it will infect other pokemon, meaning that they can't use the same move twice in a row

-- Flame Eater - grants immunity to fire type moves. when hit by one, if will raise defense by 1

-- Fortification - raises defense to the max upon taking a critical hit

-- Fruit Picker - steals the opponent's berry upon contact

-- Gardener - grants STAB for grass type pokemon

-- Impersonate - raises 2 stats, based on the opponent's highest stats upon entering the field

-- Ink Body - when hit, it may lower the opponent's accuracy

-- Loud Voice - sound based moves get a boost in power

-- Martialate - normal type moves become fighting type and get a boost in power

-- Misty Body - raises evasion during rain

-- Oneirokinesis - opposing pokemon take damage while asleep after each turn

-- Overmind - doubles the SpA stat

-- Parasitic - draining moves heal more health

-- Petrify - normal type moves become rock type and get a boost in power

-- Plant Body - when hit by a grass type move, it heals 25% HP instead of taking damage

-- Play Dead - grants immunity to normal type moves


-- Power Fume - after every turn there is a chance that the opposing pokemon will be poisoned

-- Protective Shell - doubles the defense stat

-- Protector - raises def and sp.def as long as the pokemon holds an item

-- Psychedelic - raises the power of Psychic type moves

-- Quarantine - grants all pokemon immunity to being poisoned

-- Resentment - raises the attack stat each time a move misses

-- Resilience - raises the SpD stat each time damage is taken

-- Sand Sprinkler - rock and ground type moves get a chance to put the opponent to sleep

-- Scaredy Cat - raises evasion upon entering the field

-- Seismic Thrust - grants priority to ground type moves when at full HP

-- Siren Singer - sound based moves have a chance to trap the opponent

-- Sleepwalker - when asleep, a random move will be selected

-- Sleet - STAB for ice type moves



-- Steel Toe - give a boost in power to kicking moves

-- sticky Nectar - bug type moves will lower the opponents speed stat




-- Spirit Train - boost the power of ghost type moves if they are used consecutively

-- Swirling Souls - raises the attack stat by 1 for every fainted member in your party

-- I like this
-- Resentment - raises the attack stat each time a move misses
-- Portal Creation - all damaging moves get +1 priority if the pokemon with this ability is inflicted with a major status condition


-- Cold-Blooded: Pokémon that use contact moves against this Pokémon have a 30% chance of being frozen. (Ice-type Poison Point)

-- Repulsive: Lower's the opposing team's Sp. Atk by 1 upon entry. Reduces wild Pokémon encounter rate. (special Intimidate)

-- Emergency Guard: When HP is below 1/4 of max, takes 50% less damage from attacks. (Multiscale but for low HP instead of max HP)




-- Portal Creation - all damaging moves get +1 priority if the pokemon with this ability is inflicted with a major status condition



-- Negative Aura - Apply a random debug

TarotCards = EnchantmentRegistry:Register({
  name = "Tarot Cards",
  id = "TAROT_CARDS",
  getDescription = function(self)
    local psychic_type = _DATA:GetElement("psychic")
    local purple_apricorn = M_HELPERS.GetItemName("apricorn_purple")
    return string.format(
      "Gain a %s. For each %s in the %s, draw a card and apply a random effect at the start of each floor",
      purple_apricorn, psychic_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local psychic_type = _DATA:GetElement("psychic")
    local icon = psychic_type:GetIconName()

    local count = #GetCharacterOfMatchingType("psychic", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,


  set_active_effects = function(self, active_effect, zone_context)


    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("TarotCards", Serpent.line({
      EnchantmentID = self.id,
      Type = "psychic",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_purple",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})




TarotRegistry = CreateRegistry({
  registry_table = {},
  defaults = TarotDefaults,
})

TarotRegistry:Register({
  id = "THE_HERMIT",
  name = "The Hermit",
  -- amount = 500,
  apply = function(self, owner, ownerChar, context, args)
    -- local money = _DATA.Save.
    local randval = _DATA.Save.Rand:Next(200, 1001)
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + randval
    _DUNGEON:LogMsg(string.format("%s: You gained %s!", M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
    M_HELPERS.MakeColoredText(tostring(randval) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
  end
})

local function CreateStatusTarot(id, name, statusId, stackCount)
  return {
    id = id,
    name = name,
    apply = function(self, owner, ownerChar, context, args)
      local entry = _DATA:GetStatus(statusId)
      local statusName = entry.Name:ToLocal()

      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
        "{0}: Your team gain [a/an] {1} boost!",
        M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
        statusName
      ))

      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(statusId, false, false, stackCount)
        local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.None)
        mock_context.User = member
        TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
      end
    end
  }
end

TarotRegistry:Register(CreateStatusTarot("THE_TOWER", "The Tower", "mod_defense", 1))
TarotRegistry:Register(CreateStatusTarot("THE_HIGH_PRIESTESS", "The High Priestess", "mod_special_defense", 1))


TarotRegistry:Register(CreateStatusTarot("THE_EMPRESS", "The Empress", "mod_special_attack", 1))
TarotRegistry:Register(CreateStatusTarot("THE_EMPEROR", "The Emperor", "mod_attack", 1))


TarotRegistry:Register(CreateStatusTarot("THE_CHARIOT", "The Chariot", "mod_speed", 1))

TarotRegistry:Register(CreateStatusTarot("THE_HIEROPHANT", "The Hierophant", "mod_accuracy", 1))
TarotRegistry:Register(CreateStatusTarot("THE_DEVIL", "The Devil", "mod_evasion", 1))


TarotRegistry:Register({
  id = "THE_WORLD",
  name = "The World",
  amount = 500,
  apply = function(self, owner, ownerChar, context, args, member)

    local name = member:GetDisplayName(true)
    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
      "{0}: {1} has revealed the layout of the floor!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      name
    ))

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
    mock_context.User = member
    local level_event = PMDC.Dungeon.MapOutRadiusEvent(25)
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
  end
})


  -- local string_key = args.StringKey
  -- local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(status, false, false, 1)
  -- local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
  -- mock_context.User = context.User
  -- local stack = context.User:GetStatusEffect(status)
  -- if stack ~= nil then
  --   local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
  --   if s.Stack < max_stack then
  --     ResetEffectTile(owner)
  --     TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
  --   else
  --     local msg = RogueEssence.StringKey(string_key):ToLocal()
  --     _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
  --   end
    
  -- else
  --   ResetEffectTile(owner)
  --   TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
--   end
-- end


TarotRegistry:Register({
  id = "WHEEL_OF_FORTUNE",
  name = "Wheel of Fortune",
  add_as_status = true,
  apply = function(self, owner, ownerChar, context, args, member)
    local wheel_choice = WheelOfFortuneRegistry:GetRandom(1, 1)[1][1]

    local choices = {
      { "Accept", true },
      { "Decline",  true },
    }

    local question = wheel_choice:getQuestion(member)
    UI:BeginChoiceMenu(string.format("%s: %s", M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan), question), choices, 1, 2)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()

    if result == 1 then
      local roll = _DATA.Save.Rand:Next(100)
      if roll < wheel_choice.chance then
        wheel_choice:yes_choice(owner, ownerChar, context, args, member)
      else
        
        _DUNGEON:LogMsg(M_HELPERS.MakeColoredText("Nope!", PMDColor.Magenta))
        wheel_choice:roll_fail(owner, ownerChar, context, args, member)
      end
    else
      wheel_choice:no_choice(owner, ownerChar, context, args, member)
    end

    GAME:WaitFrames(30)
  end
})

WheelOfFortuneRegistry = CreateRegistry({
  registry_table = {},
  defaults = WheelOfFortuneDefaults,
})

WheelOfFortuneDefaults = {
  -- On Map Starts
  getQuestion = function(self, member)
    return "add question"
  end,

  roll_fail = function(owner, ownerChar, context, args, member)
  end,

  yes_choice = function(owner, ownerChar, context, args, member)
  end,

  no_choice = function(owner, ownerChar, context, args, member)
  end
}

WheelOfFortuneRegistry:Register({
  id = "FAINT_MEMBER",
  amount = 5000,
  chance = 100,

  getQuestion = function(self)
    return string.format("Take a %s to gain %s or a random team member faints. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(self.amount .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,

  roll_fail = function(owner, ownerChar, context, args)
    local candidates = {}

    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      if not member.Dead then
        table.insert(candidates, member)
      end
    end


    local mem = GetRandomFromArray(candidates)

    SOUND:PlayBattleSE('DUN_Hit_Neutral')
    TASK:WaitTask(mem:InflictDamage(9999))

    if not mem.Dead then
      beholder.trigger("OnNotToday")
    end

  end,

  yes_choice = function(self, owner, ownerChar, context, args)
    -- SOUND:
    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("Gained %s!", M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    
    -- M_HELPERS.MakeColoredText("Gained %s", ))
    -- _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.amount
  
  end,

  no_choice = function(self, owner, ownerChar, context, args)
  end
})

WheelOfFortuneRegistry:Register({
  id = "REMOVE_INVENTORY",
  chance = 25,


  getQuestion = function(self, member)
    local value = GetInventoryCost()

    return string.format("Take a %s to gain %s or remove all items in your inventory. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      M_HELPERS.MakeColoredText(value .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
  end,

  roll_fail = function(self, owner, ownerChar, context, args)
    M_HELPERS.RemoveAllInventory()
  end,

  yes_choice = function(self, owner, ownerChar, context, args)
    local value = GetInventoryCost()

    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("Gained %s!", M_HELPERS.MakeColoredText(tostring(value) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + value



        -- M_HELPERS.MakeColoredText("Gained %s", ))
  
    -- SOUND:
    -- SOUND:PlayBattleSE('DUN_Money')
    -- _DUNGEON:LogMsg(string.format("Gained %s!",
    --   M_HELPERS.MakeColoredText(tostring(self.amount) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))

    -- M_HELPERS.MakeColoredText("Gained %s", ))
    -- _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.amount
  end,

  no_choice = function(self, owner, ownerChar, context, args)
  end
})




WheelOfFortuneRegistry:Register({
  id = "REMOVE_LEVELS",
  chance = 35,
  gain = 5,
  lose = 3,

  getQuestion = function(self, member)
    local name = member:GetDisplayName(true)

    return string.format("Take a %s for %s to gain %s levels or lose %s levels. Risk it?",
      M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
      name,
      M_HELPERS.MakeColoredText(tostring(self.gain), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.lose), PMDColor.Cyan)
  )
  end,

  roll_fail = function(self, owner, ownerChar, context, args, member)

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
    mock_context.User = member
    local level_event = PMDC.Dungeon.LevelChangeEvent(-self.lose, false)
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
    -- print("AKAAKAAKKA")
    TASK:WaitTask(_DUNGEON:CheckEXP())
  end,
  yes_choice = function(self, owner, ownerChar, context, args, member)
    print(tostring(member))

    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.None)
    mock_context.User = member

    local level_event = PMDC.Dungeon.LevelChangeEvent(-self.gain, false)
    print(tostring(level_event))
    TASK:WaitTask(level_event:Apply(nil, nil, mock_context))
    -- print("MMDDMDMDM")
    TASK:WaitTask(_DUNGEON:CheckEXP())
   
  end,

  no_choice = function(self, owner, ownerChar, context, args, member)

  end
})


local function CreateItemTarot(id, name, itemIds, count)

  count = count or 1
  return {
    id = id,
    name = name,
    apply = function(self, owner, ownerChar, context, args, member)

      local picked_item = GetRandomFromArray(itemIds)

      local arguments = {
        MinAmount = 0,
        MaxAmount = 0,
        Guaranteed = {
          {
            { Item = picked_item, Amount = count, Weight = 10 }
          }
        },
        Items = {},
        MaxRangeWidth = 2,
        MaxRangeHeight = 2,
        UseUserCharLoc = true
      }

      local itemName = M_HELPERS.GetItemName(picked_item, count)
      _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
        "{0}: You received a {1}!",
        M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
        itemName
      ))

      GAME:WaitFrames(10)
      context.User = member
      SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
    end
  }
end

TarotRegistry:Register(CreateItemTarot("THE_SUN", "The Sun", { "evo_sun_stone" }))
TarotRegistry:Register(CreateItemTarot("THE_MOON", "The Moon", { "evo_moon_stone" }))
TarotRegistry:Register(CreateItemTarot("THE_STAR", "The Star", {"loot_star_piece"}))
TarotRegistry:Register(CreateItemTarot("DEATH", "The Hanged Man", { "orb_one_shot" }))
TarotRegistry:Register(CreateItemTarot("THE_FOOL", "The Fool", { "orb_invisify" }))
TarotRegistry:Register(CreateItemTarot("JUSTICE", "Justice", { "orb_rebound" }))
TarotRegistry:Register(CreateItemTarot("THE_HANGED_MAN", "Death", { "seed_reviver" }))
TarotRegistry:Register(CreateItemTarot("STRENGTH", "Strength", { "tm_strength" }))
TarotRegistry:Register(CreateItemTarot("THE_LOVERS", "The Lover", ConcatTables(APRICORNS, { "loot_heart_scale" })))


TarotRegistry:Register(CreateItemTarot("THE_MAGICIAN", "The Magician", WANDS, 9))


TarotRegistry:Register({
  id = "TEMPERANCE",
  name = "Temperance",
  apply = function(self, owner, ownerChar, context, args)
    local inv = GetInventoryCost()
    local value = math.min(math.floor(inv / 5), 2000)

    SOUND:PlayBattleSE('DUN_Money')
    _DUNGEON:LogMsg(string.format("%s: Gained %s!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(value) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan)))
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + value
  end
})

TarotRegistry:Register({
  id = "JUDGEMENT",
  name = "Judgement",
  apply = function(self, owner, ownerChar, context, args)
    local sound = "DUN_Gummi"
    SOUND:PlayBattleSE(sound)

    local stat = GetRandomStat()
    local stat_text = RogueEssence.Text.ToLocal(stat)

    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar("{0}: All members in the active party gained [a/an] {1} stat boost!",
      M_HELPERS.MakeColoredText(self.name, PMDColor.Cyan),
      stat_text)
    )


    for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
      BoostStat(stat, 1, member)
    end
    
  end
})

TarotDefaults = {
  apply = function(owner, ownerChar, context, args)    
  end
}


Puppeteer = EnchantmentRegistry:Register({
  name = "Puppeteer",
  id = "PUPPETEER",
  getDescription = function(self)
    local ghost_type = _DATA:GetElement("ghost")
    local black_apricorn = M_HELPERS.GetItemName("apricorn_black")
    return string.format(
      "Gain a %s. Each %s in the %s summons a doll that mirrors a weaker version of itself and targets enemies",
      black_apricorn, ghost_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local ghost_type = _DATA:GetElement("ghost")
    local icon = ghost_type:GetIconName()

    local count = #GetCharacterOfMatchingType("ghost", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,

  cleanup = function(self)
    RemoveGuestsWithValue(self.id)
  end,

  set_active_effects = function(self, active_effect, zone_context)

    active_effect.OnMapStarts:Add(-20, RogueEssence.Dungeon.SingleCharScriptEvent("RemoveGuestWithIDBackground", Serpent.line({
      ID = self.id,
    })))

    active_effect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("Puppeteer", Serpent.line({
      EnchantmentID = self.id,
      Type = "ghost",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_black",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})


-- HideAndSeek = EnchantmentRegistry:Register({
--   name = "Hide and Seek",
--   id = "HIDE_AND_SEEK",
--   getDescription = function(self)
--     local ghost_type = _DATA:GetElement("ghost")
--     local purple_apricorn = M_HELPERS.GetItemName("apricorn_purple")
--     return string.format(
--       "Gain a %s. Each %s in the %s summons a doll that mirrors a weaker version of itself and targets enemies",
--       purple_apricorn, ghost_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow))
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   getProgressTexts = function(self)
--     local ghost_type = _DATA:GetElement("ghost")
--     local icon = ghost_type:GetIconName()

--     local count = #GetCharacterOfMatchingType("ghost", false)

--     return { "Total " .. icon .. " Members: " .. count }
--   end,

--   cleanup = function(self)
--     for i = _DATA.Save.ActiveTeam.Guests.Count - 1, 0, -1 do
--       local guest = GAME:GetPlayerGuestMember(i)
--       local tbl = LTBL(guest)
--       if tbl[self.id] then
--         GAME:RemovePlayerGuest(i)
--       end
--     end
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(-20,
--       RogueEssence.Dungeon.SingleCharScriptEvent("RemoveGuestWithIDBackground", Serpent.line({
--         ID = self.id,
--       })))

--     active_effect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("Puppeteer", Serpent.line({
--       EnchantmentID = self.id,
--       Type = "ghost",
--     })))
--   end,

--   apply = function(self)
--     local items = {
--       {
--         Item = "apricorn_purple",
--         Amount = 1
--       }
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end
-- })


-- Bounty Hunter - Defeat a specific mon, gain 100 P. When you reach 15 bounties recieve a massive reward

-- HideAndSeek - From now, you will be tasked with finding a lost item.

-- From now until the end of the dungeon, until Spawn a random NPC on which will give reward. Spawn a random or two gold nuggets...

-- local mon_id = RogueEssence.Dungeon.MonsterID(mission.Client, 0, "normal",
--   GeneralFunctions.NumToGender(mission.ClientGender))
-- -- set the escort level 20% less than the expected level
-- local level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 0.80)
-- local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, level, "", -1)
-- local tactic = _DATA:GetAITactic("stick_together")
-- new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
-- _DATA.Save.ActiveTeam.Guests:Add(new_mob)
-- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("EscortInteract")
-- new_mob.ActionEvents:Add(talk_evt)

-- local tbl = LTBL(new_mob)
-- tbl.Escort = name
-- UI:ResetSpeaker()

-- SightSeeing


-- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PuppetInteract")
-- clone.ActionEvents:Add(talk_evt)



function RemoveGuestsWithValue(id)
  for i = _DATA.Save.ActiveTeam.Guests.Count - 1, 0, -1 do
    local guest = GAME:GetPlayerGuestMember(i)
    local tbl = LTBL(guest)
    if tbl[id] then
      GAME:RemovePlayerGuest(i)
    end
  end
end

TravelingMerchant = EnchantmentRegistry:Register({
  name = "Traveling Merchant",
  id = "TRAVELING_MERCHANT",

  
  getDescription = function(self)
    -- local name = 
      local species = 'kecleon'
      local name = _DATA:GetMonster(species).Forms[0].FormName:ToLocal()
    return string.format("%s will join your journey until the next checkpoint. You can buys items or sell your entire inventory while they're with you",
      M_HELPERS.MakeColoredText(name, PMDColor.Cyan))
  end,
  getProgressTexts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)
    return {}
  end,

  cleanup = function(self)
    RemoveGuestsWithValue(self.id)
  end,

  on_checkpoint = function(self)

    local data = EnchantmentRegistry:GetData(self)

    -- if not data["completed"] then
    --   local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    --   local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    --   UI:WaitShowDialogue(M_HELPERS.MakeColoredText(new_mob.Name, PMDColor.LimeGreen2) .. " has left your party")

    --   RemoveGuestsWithValue(self.id)
    --   data["completed"] = true
    -- end
  end,
 
  dialogue = function ()
    UI:WaitShowDialogue("Prep quickly! I have business ventures to attend to!")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Oh, I'm also happy to do business with you during our travels!")
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["completed"] = false
    RemoveGuestsWithValue(self.id)
    local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    local tactic = _DATA:GetAITactic("follower")
    new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("TravelingMerchantInteract")
    new_mob.ActionEvents:Add(talk_evt)
    local tbl = LTBL(new_mob)
    tbl[self.id] = true
    tbl.ID = self.id
    tbl.Items = {
      { Item = "food_apple", Amount = 1, Price = 300 },
      { Item = "berry_leppa", Amount = 1, Price = 1000 },
      { Item = "berry_sitrus", Amount = 1, Price = 500 },
      { Item = "seed_reviver",  Amount = 1, Price = 1000 },
    }

  
    GAME:SetCharacterSkill(new_mob, "slash", 0)
    GAME:SetCharacterSkill(new_mob, "feint_attack", 1)
    GAME:SetCharacterSkill(new_mob, "brick_break", 2)
    GAME:SetCharacterSkill(new_mob, "shadow_claw", 3)
    new_mob.SpeedBonus = 25
    new_mob.MaxHPBonus = 25
    new_mob.AtkBonus = 25
    new_mob.MAtkBonus = 25
    new_mob.DefBonus = 25
    new_mob.MDefBonus = 25
        
    -- if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(0), 3) ~= "" then
    --   GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species], 3) --override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
    -- else
    --   GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species])
    -- end
    local function AddRandomShopCategories(tbl)
      local categories = {
        -- Seeds
        function()
          local seed_amount = _DATA.Save.Rand:Next(2, 5)
          local seeds = GetRandomUnique(SEED, seed_amount)
          for _, item in ipairs(seeds) do
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = 100 })
          end
        end,
        -- Apricorns
        function()
          local apricorn_amount = _DATA.Save.Rand:Next(2, 4)
          local apricorns = GetRandomUnique(APRICORNS, apricorn_amount)
          for _, item in ipairs(apricorns) do
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = 1000 })
          end
        end,
        -- Orbs
        function()
          local orb_amount = _DATA.Save.Rand:Next(1, 4)
          local orbs = GetRandomUnique(ORBS, orb_amount)
          for _, item in ipairs(orbs) do
            local entry = _DATA:GetItem(item)
            local price = entry.Price
            table.insert(tbl.Items, { Item = item, Amount = 1, Price = price * 3 })
          end
        end,
        -- Wands
        function()
          local wand_amount = _DATA.Save.Rand:Next(1, 3)
          local wands = GetRandomUnique(WANDS, wand_amount)
          for _, item in ipairs(wands) do
            table.insert(tbl.Items, { Item = item, Amount = 9, Price = 300 })
          end
        end
      }


      local chosen_indices = GetRandomUnique({ 1, 2, 3, 4 }, 2)


      for _, index in ipairs(chosen_indices) do
        categories[index]()
      end
    end

   
    AddRandomShopCategories(tbl)
    




    _DATA.Save.ActiveTeam.Guests:Add(new_mob)
    GAME:FadeOut(false, 40)

    GAME:WaitFrames(20)
    RespawnGuests()

    GAME:FadeIn(60)



    SOUND:PlayFanfare("Fanfare/NewTeam")
    UI:WaitShowDialogue("Added [color=#00FF00]" .. new_mob.Name .. "[color] to the party as a guest!")


    local player = CH('PLAYER')

    local count = _DATA.Save.ActiveTeam.Guests.Count 
    local guest = CH('Guest' .. count)

    print(tostring(guest))

    local old_dir_guest = guest.Direction
    local old_dir_player = player.Direction
    GROUND:CharTurnToChar(player, guest)
    GROUND:CharTurnToChar(guest, player)

    UI:SetSpeaker(new_mob)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("Pleasure to make your acquaintance!")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("I hope we can do business together during our little journey.")
    print(tostring(new_mob))
    guest.Direction = old_dir_guest
    player.Direction = old_dir_player
  end
})


SightSeer = EnchantmentRegistry:Register({
  name = "Sightseer",
  id = "SIGHTSEER",

  
  getDescription = function(self)

      return string.format("A traveling escort will join your party as a guest until the next checkpoint. If they make it to the next checkpoint, you'll receive a reward")
  end,
  getProgressTexts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)
    return {}
  end,

  on_checkpoint = function(self)

    -- local data = EnchantmentRegistry:GetData(self)

    -- if not data["completed"] then
    --   local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    --   local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    --   UI:WaitShowDialogue(M_HELPERS.MakeColoredText(new_mob.Name, PMDColor.LimeGreen2) .. " has left your party")

    --   RemoveGuestsWithValue(self.id)
    --   data["completed"] = true
    -- end
  end,
 
  dialogue = function ()
    -- UI:WaitShowDialogue("Prep quickly! I have business ventures to attend to!")
    -- UI:SetSpeakerEmotion("Happy")
    -- UI:WaitShowDialogue("Oh, I'm also happy to do business with you during our travels!")
  end,

  apply = function(self)
    -- local data = EnchantmentRegistry:GetData(self)
    -- data["completed"] = false
    -- RemoveGuestsWithValue(self.id)
    -- local mon_id = RogueEssence.Dungeon.MonsterID("kecleon", 0, "normal", Gender.Unknown)
    -- local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", -1)

    -- local tactic = _DATA:GetAITactic("follower")
    -- new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
    -- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("TravelingMerchantInteract")
    -- new_mob.ActionEvents:Add(talk_evt)
    -- local tbl = LTBL(new_mob)
    -- tbl[self.id] = true
    -- tbl.ID = self.id
    -- tbl.Items = {
    --   { Item = "food_apple", Amount = 1, Price = 300 },
    --   { Item = "berry_leppa", Amount = 1, Price = 1000 },
    --   { Item = "berry_sitrus", Amount = 1, Price = 500 },
    --   { Item = "seed_reviver",  Amount = 1, Price = 1000 },
    -- }

  
    -- GAME:SetCharacterSkill(new_mob, "slash", 0)
    -- GAME:SetCharacterSkill(new_mob, "feint_attack", 1)
    -- GAME:SetCharacterSkill(new_mob, "brick_break", 2)
    -- GAME:SetCharacterSkill(new_mob, "shadow_claw", 3)
    -- new_mob.SpeedBonus = 25
    -- new_mob.MaxHPBonus = 25
    -- new_mob.AtkBonus = 25
    -- new_mob.MAtkBonus = 25
    -- new_mob.DefBonus = 25
    -- new_mob.MDefBonus = 25
        
    -- -- if GAME:GetCharacterSkill(GAME:GetPlayerPartyMember(0), 3) ~= "" then
    -- --   GAME:SetCharacterSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species], 3) --override move in slot 4 if 4 moves are known. They can always go see slowpoke to get it back
    -- -- else
    -- --   GAME:LearnSkill(GAME:GetPlayerPartyMember(0), egg_move_list[mon_id.Species])
    -- -- end
    -- local function AddRandomShopCategories(tbl)
    --   local categories = {
    --     -- Seeds
    --     function()
    --       local seed_amount = _DATA.Save.Rand:Next(2, 5)
    --       local seeds = GetRandomUnique(SEED, seed_amount)
    --       for _, item in ipairs(seeds) do
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = 100 })
    --       end
    --     end,
    --     -- Apricorns
    --     function()
    --       local apricorn_amount = _DATA.Save.Rand:Next(2, 4)
    --       local apricorns = GetRandomUnique(APRICORNS, apricorn_amount)
    --       for _, item in ipairs(apricorns) do
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = 1000 })
    --       end
    --     end,
    --     -- Orbs
    --     function()
    --       local orb_amount = _DATA.Save.Rand:Next(1, 4)
    --       local orbs = GetRandomUnique(ORBS, orb_amount)
    --       for _, item in ipairs(orbs) do
    --         local entry = _DATA:GetItem(item)
    --         local price = entry.Price
    --         table.insert(tbl.Items, { Item = item, Amount = 1, Price = price * 3 })
    --       end
    --     end,
    --     -- Wands
    --     function()
    --       local wand_amount = _DATA.Save.Rand:Next(1, 3)
    --       local wands = GetRandomUnique(WANDS, wand_amount)
    --       for _, item in ipairs(wands) do
    --         table.insert(tbl.Items, { Item = item, Amount = 9, Price = 300 })
    --       end
    --     end
    --   }


    --   local chosen_indices = GetRandomUnique({ 1, 2, 3, 4 }, 2)


    --   for _, index in ipairs(chosen_indices) do
    --     categories[index]()
    --   end
    -- end

   
    -- AddRandomShopCategories(tbl)
    




    -- _DATA.Save.ActiveTeam.Guests:Add(new_mob)
    -- GAME:FadeOut(false, 40)

    -- GAME:WaitFrames(20)
    -- RespawnGuests()

    -- GAME:FadeIn(60)



    -- SOUND:PlayFanfare("Fanfare/NewTeam")
    -- UI:WaitShowDialogue("Added [color=#00FF00]" .. new_mob.Name .. "[color] to the party as a guest!")


    -- local player = CH('PLAYER')

    -- local count = _DATA.Save.ActiveTeam.Guests.Count 
    -- local guest = CH('Guest' .. count)

    -- print(tostring(guest))

    -- local old_dir_guest = guest.Direction
    -- local old_dir_player = player.Direction
    -- GROUND:CharTurnToChar(player, guest)
    -- GROUND:CharTurnToChar(guest, player)

    -- UI:SetSpeaker(new_mob)
    -- UI:SetSpeakerEmotion("Happy")
    -- UI:WaitShowDialogue("Pleasure to make your acquaintance!")
    -- UI:SetSpeakerEmotion("Normal")
    -- UI:WaitShowDialogue("I hope we can do business together during our little journey.")
    -- print(tostring(new_mob))
    -- guest.Direction = old_dir_guest
    -- player.Direction = old_dir_player
  end
})


Randorb = EnchantmentRegistry:Register({
  name = "Randorb",
  id = "RANDORB",

  getDescription = function(self)
    return string.format("Gain a random orb. At the start of each floor, gain a random orb")
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_start_id

      on_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
        local random_orb = GetRandomFromArray(ORBS)
        print(tostring(random_orb))
        local arguments = {
          MinAmount = 1,
          MaxAmount = 1,
          Guaranteed = {},
          Items = {
            { Item = random_orb, Amount = 1, Weight = 80 },


          },
          UseUserCharLoc = true,
        }

        GAME:WaitFrames(10)
        local old = context.User
        context.User = _DUNGEON.ActiveTeam.Leader
        SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
        context.User = old
        GAME:WaitFrames(20)
      end)
    end)

    return {}
  end,

  apply = function(self)
    local random_orb = GetRandomFromArray(ORBS)
    local items = {
      {
        Item = random_orb,
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

RainingGold = EnchantmentRegistry:Register({
  name = "Raining Gold",
  id = "RAINING_GOLD",
  initial = 2000,
  

  getDescription = function(self)
    return string.format("Gain %s. At the start of each floor, a shower of %s falls from the sky",
    M_HELPERS.MakeColoredText(tostring(self.initial) .. PMDSpecialCharacters.Money, PMDColor.Cyan),
    PMDSpecialCharacters.Money)
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)

  end,

  set_active_effects = function(self, active_effect, zone_context)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_start_id
      
      on_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
    
        local arguments = {
          MinAmount = 7,
          MaxAmount = 11,
          Guaranteed = {},
          Items = {
            { Item = "money",      Amount = 50, Weight = 80 },
            { Item = "money",      Amount = 100, Weight = 15 },
            { Item = "money",      Amount = 200, Weight = 5 },
            { Item = "money",      Amount = 1200, Weight = 1 },

          },
          UseUserCharLoc = true,
        }

        GAME:WaitFrames(10)
        local old = context.User
        context.User = _DUNGEON.ActiveTeam.Leader
        SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
        context.User = old
        GAME:WaitFrames(20)
      end) 
    end)
  end,

  apply = function(self)
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.initial
    SOUND:PlayFanfare("Fanfare/Item")
    UI:SetCenter(true)
    UI:WaitShowDialogue("You gained " .. tostring(self.initial) .. " " .. PMDSpecialCharacters.Money .. "!")
    UI:SetCenter(false)
  end
})


BerryNutritious = EnchantmentRegistry:Register({
  name = "Berry Nutritous",
  id = "BERRY_NUTRITOUS",
  chance = 50,

  getDescription = function(self)
    return string.format("Gain a random berry. Whenever a team member eats a berry, there is a %s chance they get a random stat boost", M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)

    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.BeforeActions:Add(5,
      RogueEssence.Dungeon.BattleScriptEvent("StoreItemInEnchant", Serpent.line({
      EnchantmentID = self.id
    })))

    active_effect.AfterActions:Add(5,
      RogueEssence.Dungeon.BattleScriptEvent("BerryNutritiousAfterActions", Serpent.line({
        Chance = self.chance,
        EnchantmentID = self.id
      })))    
  end,

  apply = function(self)

    local rand_berry = GetRandomFromArray(BERRIES)
    local items = {
      {
        Item = rand_berry,
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

Harvester = EnchantmentRegistry:Register({
  name = "Harvester",
  id = "HARVESTER",

  getDescription = function(self)
    local grass_type = _DATA:GetElement("grass")
    local green_apricron = M_HELPERS.GetItemName("apricorn_green")
    return string.format("Gain a %s. For each %s in the %s, gain a random berry or food at the start of each floor",
      green_apricron, grass_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local grass_type = _DATA:GetElement("grass")
    local icon = grass_type:GetIconName()

    local count = #GetCharacterOfMatchingType("grass", false)

    return { "Total " .. icon ..  " Members: " .. count}

  end,

  set_active_effects = function(self, active_effect, zone_context)
    print("Setting Harvester active effects...")
    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("GiveRandomForEachType", Serpent.line({
      Type = "grass",
      ItemTable = HARVEST_TABLE,
      AnimName = "Circle_Green_Out"
    })))
  end,

  apply = function(self)

    local items = { 
      {
      Item = "apricorn_green",
      Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)


    -- FanfareText(string.format(
    --   "You will gain a random berry or food for each %s in your active party at the start of each floor!",
    --   _DATA:GetElement("grass"):GetIconName()),)
  end
})

-- Negative Aura - For each  At the end of each turn, enemies within 2 tiles of

-- Rationalize: This Pokémon's Normal-Type moves are Super Effective to Fairy, Ghosts, and Dragon-Types in exchange for Moves from those Types becoming Super Effective to this Pokémon.
-- https://gamefaqs.gamespot.com/boards/359435-pokemon-violet/80421481
Rationalize = EnchantmentRegistry:Register({
  name = "Rationalize",
  id = "RATIONALIZE",

  getDescription = function(self)
    local normal_type = _DATA:GetElement("normal")

    local fairy = _DATA:GetElement("fairy")
    local ghost = _DATA:GetElement("ghost")
    local dragon = _DATA:GetElement("dragon")
    local white_apricron = M_HELPERS.GetItemName("apricorn_white")
    return string.format("Gain a %s. %s types in your team will have their %s moves be super effective against %s, %s, and %s types",
      white_apricron, normal_type:GetIconName(), normal_type:GetIconName(), fairy:GetIconName(), ghost:GetIconName(), dragon:GetIconName())
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    local grass_type = _DATA:GetElement("normal")
    local icon = grass_type:GetIconName()

    local count = #GetCharacterOfMatchingType("normal", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches", Serpent.line({
      Types = { "normal" },
      StatusID = "emberfrost_rationalize",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_white",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)

  end
})

DraconianDefience = EnchantmentRegistry:Register({
  name = "Draconian Defience",
  id = "DRACONIAN_DEFICIENCE",
  getDescription = function(self)
    local dragon = _DATA:GetElement("dragon")
    local red_apricorn = M_HELPERS.GetItemName("apricorn_red")
    return string.format(
      "Gain a %s. %s types in your team deal more damage the lower HP they are",
      red_apricorn, dragon:GetIconName(), M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan))
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(5,

      RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches", Serpent.line({
        Types = { "dragon" },
        StatusID = "emberfrost_draconian_defience",
      })))
  end,
  --   local chance = self.chance
  --   beholder.observe("OnHits", function(owner, ownerChar, context, args)
  --     local user = context.User
  --     local target = context.Target



  --     if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and
  --         context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
  --       return
  --     end


  --     if user.MemberTeam ~= _DUNGEON.ActiveTeam then
  --       return
  --     end

  --     if user.Element1 ~= "bug" and user.Element2 ~= "bug" then
  --       return
  --     end

  --     local roll = _DATA.Save.Rand:Next(100)
  --     if roll >= chance then
  --       return
  --     end


  --     if target == nil then
  --       return
  --     end

  --     local status = RogueEssence.Dungeon.StatusEffect("infestation")

  --     status:LoadFromData()
  --     TASK:WaitTask(target:AddStatusEffect(nil, status, true))
  --   end)
  -- end,
  apply = function(self)
  end
})

local function CreateTypeStatusEnchantment(config)
  return EnchantmentRegistry:Register({
    name = config.name,
    id = config.id,
    chance = config.chance,
    getDescription = function(self)
      local element_type = _DATA:GetElement(config.element)
      local apricorn = M_HELPERS.GetItemName(config.apricorn)
      return string.format(
        "Gain a %s. %s types in your team will have a %s chance to have their %s moves inflict the target with the %s status",
        apricorn,
        element_type:GetIconName(),
        M_HELPERS.MakeColoredText(tostring(self.chance) .. "%", PMDColor.Cyan),
        element_type:GetIconName(),
        config.status_name
      )
    end,
    offer_time = "beginning",
    rarity = 1,
    getProgressTexts = function(self)
      local grass_type = _DATA:GetElement(config.element)
      local icon = grass_type:GetIconName()

      local count = #GetCharacterOfMatchingType(config.element, false)

      return { "Total " .. icon .. " Members: " .. count }
    end,
    set_active_effects = function(self, active_effect, zone_context)
      local chance = self.chance
      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        beholder.observe("OnHits", function(owner, ownerChar, context, args)
          local user = context.User
          local target = context.Target

          if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and
              context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
            return
          end

          if user.MemberTeam ~= _DUNGEON.ActiveTeam then
            return
          end

          if user.Element1 ~= config.element and user.Element2 ~= config.element then
            return
          end

          local roll = _DATA.Save.Rand:Next(100)
          if roll >= chance then
            return
          end

          if target == nil then
            return
          end

          local status = RogueEssence.Dungeon.StatusEffect(config.status_id)
          status:LoadFromData()
          TASK:WaitTask(target:AddStatusEffect(nil, status, true))
        end)
      end)
    end,
    apply = function(self)
      local items = {
        {
          Item = config.apricorn,
          Amount = 1
        }
      }

      M_HELPERS.GiveInventoryItemsToPlayer(items)
      
    end
  })
end

SwatTeam = CreateTypeStatusEnchantment({
  name = "Swat Team",
  id = "SWAT_TEAM",
  chance = 30,
  element = "bug",
  apricorn = "apricorn_green",
  status_name = "infestation",
  status_id = "infestation"
})

Subzero = CreateTypeStatusEnchantment({
  name = "Subzero",
  id = "SUBZERO",
  chance = 25,
  element = "ice",
  apricorn = "apricorn_blue",
  status_name = "Frostbite",
  status_id = "emberfrost_frostbite"
})


-- Blaze Tile - Will burn the user, but will double their speed. (max 2 stack) 
-- Fire Tile - Take fire damage but raise attack
-- Ice Title - Freeze chracter, but grant, users on these tiles will be granted +2 range on thei rmoves

-- Evolved - Mons that evolved gain +5 stat boosts
-- Targets with two tiles of the will have their attack reduced by 20% (Dark) - Malevolence - Apply a random debuff for any enemies within two tiles
-- fired Up -- 
-- Noxious
-- Electric -- Overflow/Overcharge damage will be carried over to the next target - from base elctric damage (1 transfer) - Overcharge
-- Water Purification - Heal Passively hea teammates
-- Combat Flow - Every third attack of fighting mons will do increased damage and critical hit
-- Flock - Flying types will reduce damage of nearby floating allies. Allies nearby can traverse
-- Ground
-- Rock -- Geopebbles and gravlerrocks. 
-- Steel  -- Steel- “conduction- when hit by fire moves all defenses raise by 1 stage & reduce damage by 25%.
-- Iron Will : steel-type moves will utilize the user's defense stat to determine power
-- Ignition: the Pokemon's speed is boosted when inflicted with a burn
-- Fairy -
-- Cruel Kindness – Fairy-type moves heal allies for a portion of the damage dealt.
-- Fairy -
-- Steel: Reinforced Plating - Impact, take 10% damage from one physical move, once. Every 50 turns - gain a shield that reduces damage by 80%
--  Conductor- The Pokémon's Attack and Special Attack stats get boosted if hit by an Electric-Type move.

-- polished metal
-- gives a plus 1 evasiveness boost for steel types.

--  Poison: Intoxication/Noxious Cloud/Toxic Boost/Contamination - Prevent\\ 

-- Toxic Touch: When the user attacks, the target is inflicted with a stacking “contamination” debuff that spreads to nearby enemies after a turn.

-- Chain Infection: Any status effect the user receives (burn, poison, etc.) also spreads to a random enemy at the end of the turn.

-- Virulent / Noxious Aura: At the start of each turn, all enemies have a small chance to be poisoned, paralyzed, or weakened. All poison-type hav

-- -- Normal: Extraordinaire/Power Boost/Amplifier/Complexity

-- Electric: Battery Charger/Electrify/Juicer/High Capacity/

-- Fighting: Prideful/Fighting Spirit/Combo - Raise the attack str for each 

-- Fairy: Uplifting Spirit/Wish Granter/Spirit’s Gift/Trickery

-- Dark: Corruption/Nightmare Fuel/Darkest Hour//Negative Aura
-- 
-- Flying: Strong Wings/Rising Phoenix/Shedded Feathers/Flocking/Air Ride (can guide other types across terrains), Turbulence, Flock - Each flying type reduces damage of nearby allies

-- Quick Charge: Moves that take 2 turns to use now only require 1, but require 1 extra PP.
-- Ghost: Possession/Haunted/Spirit Riser/After Dusk/Conjure - 



-- Rock: Hardheaded/Compression

-- Dungeon Unboxing --- open all boxes inside your inventory
-- Ground: Tectonic strength/Earth Rising/Aftershock, Quicksands -  

Shopper = EnchantmentRegistry:Register({
  name = "Shopper",
  id = "SHOPPER",

  getDescription = function(self)
    return "Increase the likelihood of shopkeepers appearing in the dungeon"
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("ShopperRefresh",
      Serpent.line({ 
        Rate = 15, 
      })))
  end,

  apply = function(self)
    FanfareText(string.format(
      "Shopkeepers are more likely to appear in the dungeon!"))
  end
})

TreasureHunt = EnchantmentRegistry:Register({
  name = "Treasure Hunt",
  id = "TREASURE_HUNT",

  getDescription = function(self)
    return "Increase the likelihood of chests appearing in the dungeon"
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("TreasureHunt",
        Serpent.line({
          Rate = 15,
        })))
  end,

  apply = function(self)
    FanfareText(string.format(
      "Chests are more likely to appear in the dungeon!"))
  end
})


LooseChange = EnchantmentRegistry:Register({
  name = "Loose Change",
  id = "LOOSE_CHANGE",

  getDescription = function(self)
    local money = PMDSpecialCharacters.Money  
    return "More " .. money .. " can be found while exploring the dungeon"
  end,
  offer_time = "beginning",
  rarity = 1,
  getProgressTexts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- MAKE IT ZONE CONTEXT DEPENDENT
    local rate = 300
    if zone_context.CurrentSegment ~= 0 then
      return
    end

    if zone_context.CurrentID >= 15 then
      rate = 600
    end
    
  
    active_effect.OnRefresh:Add(5,
      RogueEssence.Dungeon.RefreshScriptEvent("LooseChange",
        Serpent.line({
          Rate = rate,
        })))
  end,

  apply = function(self)
    FanfareText(string.format(
      "You will find more " .. PMDSpecialCharacters.Money .. " while exploring the dungeon!"))
  end
})

function AssignCharacterEnchantment(chara, enchantment_id)
  local tbl = LTBL(chara)

  tbl.Enchantments = tbl.Enchantments or {}
  tbl.Enchantments[enchantment_id] = true
end

function AssignEnchantmentToCharacter(enchant, show_message)
  local ret = {}
  local choose = function(chars)
    ret = chars
    _MENU:RemoveMenu()
  end
  local refuse = function()
  end
  local menu = TeamMultiSelectMenu:new(string.format("Assign %s to?",
    M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)), _DATA.Save.ActiveTeam.Players, function()
    return true
  end, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  local selected_char = ret[1]


  AssignCharacterEnchantment(selected_char, enchant.id)
  if show_message == nil then
    show_message = true
  end

  if show_message then
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Item")
    UI:WaitShowDialogue(string.format("%s got the %s enchantment!", selected_char:GetDisplayName(true),
        M_HELPERS.MakeColoredText(enchant.name, PMDColor.Yellow)))
    UI:SetCenter(false)
  end
  return selected_char
end



QuestDefaults = {

  can_apply = function()
    return true
  end,

  complete_quest = function(self)
    local data = QuestRegistry:GetData(self)

    local enchantment_data = EnchantmentRegistry:GetData(QuestMaster)

    if not data["completed"] then
      data["completed"] = true
      _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + self.reward
      enchantment_data["money_earned"] = enchantment_data["money_earned"] + self.reward
      if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
        SOUND:PlayFanfare("Fanfare/Note")
        UI:WaitShowDialogue(string.format("Completed Quest! %s (%s)", self:getDescription(),
          M_HELPERS.MakeColoredText(tostring(self.reward), PMDColor.Cyan) .. " " .. PMDSpecialCharacters.Money))
      end
    end
  end,
  -- Called when exiting the dungeon
  cleanup = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)
    print(self.name .. " set quest map effect.")
    -- print(self.name .. " activated.")
  end,

  getDescription = function(self)
    return ""
  end,

  getProgressTexts = function(self)
    return {}
  end
}


QuestMaster = EnchantmentRegistry:Register({
  name = "Quest Master",
  id = "QUEST_MASTER",
  task_amount = 2,
  getDescription = function(self)
    return string.format("At the start of each floor, receive %s quests to gain " .. PMDSpecialCharacters.Money,
      M_HELPERS.MakeColoredText(tostring(self.task_amount), PMDColor.Cyan))
  end,
  rarity = 1,
  getProgressTexts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local currents_quests = SV.EmberFrost.Quests.Active
    local selected = QuestRegistry:GetSelected(currents_quests)
    local progress_texts = {}

    local money_earned = data["money_earned"] or 0

    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      table.insert(progress_texts,
        string.format("Quests (Earned %s %s): ",
          M_HELPERS.MakeColoredText(tostring(money_earned), PMDColor.Cyan), PMDSpecialCharacters.Money))
      for _, quest in ipairs(selected) do
        local description = quest:getDescription()
        local texts = quest:getProgressTexts()
        local data = QuestRegistry:GetData(quest)
        local completed = data["completed"] or false
        local icon = completed and PMDSpecialCharacters.Check or PMDSpecialCharacters.Cross
        if texts then
          table.insert(progress_texts, "")
          table.insert(progress_texts, description ..
            string.format(" (%s %s)", M_HELPERS.MakeColoredText(tostring(quest.reward), PMDColor.Cyan),
              PMDSpecialCharacters.Money))

          for i, text in ipairs(texts) do
            local prefix = (i == #texts) and (icon .. " ") or ""
            table.insert(progress_texts, prefix .. text)
          end
        end
      end
    else
      table.insert(progress_texts, "Total Earned: " ..
        M_HELPERS.MakeColoredText(tostring(money_earned) .. " " .. PMDSpecialCharacters.Money, PMDColor.Cyan))
    end
    return progress_texts
  end,

  set_active_effects = function(self, active_effect, zone_context)
    -- print("QuestMaster OnMapStarts Triggered")
    local quests = QuestRegistry:GetRandom(self.task_amount, 1)[1]

    SV.EmberFrost.Quests.Active = M_HELPERS.map(quests, function(q)
      return q.id
    end)
    SV.EmberFrost.Quests.Data = {}
    local data = EnchantmentRegistry:GetData(self)
    data["money_earned"] = 0

    print(Serpent.block(SV.EmberFrost.Quests.Active) .. ".... selected quests")

    for _, quest in ipairs(quests) do
      quest:set_active_effects(active_effect)
      print(quest.id .. " set active effects.")
    end
    active_effect.OnMapStarts:Add(6, RogueEssence.Dungeon.SingleCharScriptEvent("LogQuests"))
  end,

  apply = function(self)
    -- UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue("You will now receive quests at the start of each floor. Complete them to earn " ..
      PMDSpecialCharacters.Money .. "!")
    UI:WaitShowDialogue("You can check your quests in the Others -> Enchants menu while in dungeon.")
    -- UI:SetCenter(false)
  end,

  cleanup = function(self)
    for k, v in pairs(QuestRegistry._registry) do
      v:cleanup()
    end
  end
})

QuestRegistry = CreateRegistry({
  registry_table = {},
  data_table_path = "EmberFrost.Quests.Data",
  selected_table_path = "EmberFrost.Quests.Active",
  defaults = QuestDefaults,
  selection_field = "Quests",
  debug = true
})

local function CreateBountyQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = function(self)
      local data = QuestRegistry:GetData(self)
      local species = data["bounty_target"]
      local name = _DATA:GetMonster(species).Forms[0].FormName:ToLocal()
      local amount_text = M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " "

      return string.format("Defeat %s%s", amount_text, M_HELPERS.MakeColoredText(name, PMDColor.LimeGreen2))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["defeated_enemies"] = 0

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_death_id
        local on_map_start_id

        on_map_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
          local possible_spawns = GetFloorSpawns()
          local rand_spawn = GetRandomFromArray(possible_spawns)
          local data = QuestRegistry:GetData(self)
          data["bounty_target"] = rand_spawn
        end)

        on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
          local team = context.User.MemberTeam
          if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe) then
            if context.User.BaseForm.Species ~= data["bounty_target"] then
              return
            end
            data["defeated_enemies"] = data["defeated_enemies"] + 1
            if data["defeated_enemies"] >= self.amount then
              data["defeated_enemies"] = self.amount
              beholder.stopObserving(on_death_id)
              beholder.stopObserving(on_map_start_id)
              self:complete_quest()
            end
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local defeated_enemies = data["defeated_enemies"] or 0
      return { "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateBountyQuest({
  id = "BOUNTY",
  amount = 1,
  reward = 200
}))

QuestRegistry:Register(CreateBountyQuest({
  id = "BOUNTY_3",
  amount = 3,
  reward = 800
}))

QuestRegistry:Register({
  id = "LOW_PP",
  amount = 1,
  pp = 5,
  reward = 1000,

  getDescription = function(self)
    local member_text = self.amount == 1 and "member" or "members"
    return string.format("Let %s %s with all moves at %s PP or less",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), member_text,
      M_HELPERS.MakeColoredText(tostring(self.pp), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_turn_ends_id
      on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        local members_with_low_pp = 0

        for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
          local all_moves_low = true

          for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
            local skill = member.BaseSkills[ii]
            if not skill.SkillNum ~= "" and skill.SkillNum ~= nil then
              local charges = skill.Charges
              if charges > self.pp then
                all_moves_low = false
                break
              end
            end
          end

          if all_moves_low then
            members_with_low_pp = members_with_low_pp + 1
          end
        end

        if members_with_low_pp >= self.amount then
          beholder.stopObserving(on_turn_ends_id)
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local status = data["completed"] and "Completed" or "Not Completed"
    return { "", status }
  end
})

QuestRegistry:Register({
  id = "DEFEAT_ENEMY_WITH_PROJECTILE",
  amount = 1,
  reward = 300,
  getDescription = function(self)
    return string.format("Defeat an enemy with a projectile")
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["defeated_enemies"] = 0

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local after_actions_id

      local on_turn_ends_id
      after_actions_id = beholder.observe("AfterActions", function(owner, ownerChar, context, args)
        local team = context.User.MemberTeam
        -- if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe and team ~= _DUNGEON.ActiveTeam) then
        if context.ActionType == RogueEssence.Dungeon.BattleActionType.Throw and team == _DUNGEON.ActiveTeam then
          TotalKnockoutsTypes = luanet.import_type('PMDC.Dungeon.TotalKnockouts')
          local knockouts = context:GetContextStateInt(luanet.ctype(TotalKnockoutsTypes), true, 0)

          if knockouts > 0 then
            print("Defeated enemy with projectile!")
            data["defeated_enemies"] = data["defeated_enemies"] + knockouts
          end
        end
      end)

      on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        if data["defeated_enemies"] >= self.amount then
          beholder.stopObserving(after_actions_id)
          beholder.stopObserving(on_turn_ends_id)
          data["defeated_enemies"] = self.amount
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
  end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local defeated_enemies = data["defeated_enemies"]
    return { "", "Progress: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) }
  end
})

local function CreateProjectileQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      local plural = self.amount == 1 and "enemy" or "enemies"
      return string.format("Hit %s %s with projectiles",
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), plural)
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["hits"] = 0

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_hits_id
        local on_turn_ends_id
        on_hits_id = beholder.observe("OnHits", function(owner, ownerChar, context, args)
          local target_team = context.Target.MemberTeam
          local user_team = context.User.MemberTeam
          if user_team == nil or user_team ~= _DUNGEON.ActiveTeam then
            return
          end

          if target_team == nil or target_team == _DUNGEON.ActiveTeam then
            return
          end

          if target_team.MapFaction ~= RogueEssence.Dungeon.Faction.Foe then
            return
          end

          if context.ActionType == RogueEssence.Dungeon.BattleActionType.Throw then
            data["hits"] = data["hits"] + 1
          end
        end)

        on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          if data["hits"] >= self.amount then
            beholder.stopObserving(on_hits_id)
            beholder.stopObserving(on_turn_ends_id)
            data["hits"] = self.amount
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local hits = data["hits"] or 0
      return { "", "Progress: " .. math.min(hits, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateProjectileQuest({
  id = "HIT_ENEMY_WITH_PROJECTILE",
  amount = 3,
  reward = 250
}))

QuestRegistry:Register(CreateProjectileQuest({
  id = "HIT_ENEMY_WITH_PROJECTILE_5",
  amount = 5,
  reward = 600
}))

QuestRegistry:Register(CreateProjectileQuest({
  id = "HIT_ENEMY_WITH_PROJECTILE_10",
  amount = 10,
  reward = 1250
}))

local function CreateTimedDefeatQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    turns = config.turns,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      local enemy_text = self.amount == 1 and "enemy" or "enemies"
      local turn_text = self.turns == 1 and "turn" or "turns"
      return string.format("Defeat %s %s in %s %s",
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), enemy_text,
        M_HELPERS.MakeColoredText(tostring(self.turns), PMDColor.Cyan), turn_text)
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["defeated_enemies"] = 0
      data["turns_elapsed"] = 0
      data["timer_started"] = false


      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()

        local on_death_id
        local on_map_turn_ends_id
        local on_turn_ends_id

        on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
          local team = context.User.MemberTeam
          if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe) then
            data["defeated_enemies"] = data["defeated_enemies"] + 1

            if not data["timer_started"] then
              data["timer_started"] = true
              data["turns_elapsed"] = 0
            end

            print("Defeated enemies: " .. tostring(data["defeated_enemies"]) .. " / " .. tostring(self.amount))
          end
        end)

        on_map_turn_ends_id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
          if data["timer_started"] then
            data["turns_elapsed"] = data["turns_elapsed"] + 1
            print("Turns elapsed: " .. tostring(data["turns_elapsed"]) .. " / " .. tostring(self.turns))

            if data["turns_elapsed"] >= self.turns then
              data["defeated_enemies"] = 0
              data["turns_elapsed"] = 0
              data["timer_started"] = false
            end
          end
        end)

        on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          if data["defeated_enemies"] >= self.amount then
            beholder.stopObserving(on_death_id)
            beholder.stopObserving(on_map_turn_ends_id)
            beholder.stopObserving(on_turn_ends_id)
            data["defeated_enemies"] = self.amount
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local defeated_enemies = data["defeated_enemies"] or 0
      local turns_elapsed = data["turns_elapsed"] or 0
      return { "",
        "Enemies: " .. math.min(defeated_enemies, self.amount) .. "/" .. tostring(self.amount) ..
        " | Turns: " .. math.min(turns_elapsed, self.turns) .. "/" .. tostring(self.turns) }
    end
  }
end

QuestRegistry:Register(CreateTimedDefeatQuest({
  id = "DEFEAT_ENEMIES_TIMED_1",
  amount = 3,
  turns = 10,
  reward = 500
}))

QuestRegistry:Register(CreateTimedDefeatQuest({
  id = "DEFEAT_ENEMIES_TIMED_2",
  amount = 5,
  turns = 20,
  reward = 1000
}))

QuestRegistry:Register(CreateTimedDefeatQuest({
  id = "DEFEAT_ENEMIES_TIMED_3",
  amount = 7,
  turns = 35,
  reward = 1500
}))

local function CreateEffectivenessQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      local action = config.is_dealing and "Deal" or "Take"
      local effectiveness = config.super_effective and "super effective" or "not super effective"
      local plural = self.amount == 1 and "time" or "times"
      return string.format("%s a %s hit %s %s", action, effectiveness,
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), plural)
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local redirection = luanet.ctype(RedirectionType)
      local data = QuestRegistry:GetData(self)
      data["hits"] = 0

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_turn_end_id
        local on_hit_id
        on_hit_id = beholder.observe("OnHits", function(owner, ownerChar, context, args)
          -- Check if we're tracking the user (dealing) or target (taking)
          local check_team = config.is_dealing and context.User.MemberTeam or context.Target.MemberTeam
          if check_team == nil or check_team ~= _DUNGEON.ActiveTeam then
            return
          end

          if context.ContextStates:Contains(redirection) then
            return
          end

          if context.ActionType == RogueEssence.Dungeon.BattleActionType.Trap or context.ActionType ==
              RogueEssence.Dungeon.BattleActionType.Item then
            return
          end

          if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and
              context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
            return
          end

          local matchup = PMDC.Dungeon.PreTypeEvent.GetDualEffectiveness(context.User, context.Target,
            context.Data)
          matchup = matchup - PMDC.Dungeon.PreTypeEvent.NRM_2

          -- Invert matchup for "not super effective" quests
          if not config.super_effective then
            matchup = matchup * -1
          end

          if matchup > 0 then
            data["hits"] = data["hits"] + 1
          end
        end)

        on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          print("Hits recorded: " .. tostring(data["hits"]) .. " / " .. tostring(self.amount))
          if data["hits"] >= self.amount then
            beholder.stopObserving(on_hit_id)
            beholder.stopObserving(on_turn_end_id)
            data["hits"] = self.amount
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local hits = data["hits"] or 0
      return { "", "Progress: " .. math.min(hits, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "TAKE_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = false,
  super_effective = true
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "TAKE_NOT_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = false,
  super_effective = false
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "DEAL_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = true,
  super_effective = true
}))

QuestRegistry:Register(CreateEffectivenessQuest({
  id = "DEAL_NOT_SUPER_EFFECTIVE",
  amount = 1,
  reward = 200,
  is_dealing = true,
  super_effective = false
}))

QuestRegistry:Register({
  id = "FAINT",
  amount = 1,
  reward = 1000,
  getDescription = function(self)
    return string.format("Have any member faint %s time",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["fainted"] = 0

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
        local team = context.User.MemberTeam
        if (team ~= nil and context.User.MemberTeam == _DUNGEON.ActiveTeam) then
          data["fainted"] = data["fainted"] + 1
          print("Fainted: " .. tostring(data["fainted"]) .. " / " .. tostring(self.amount))
          if data["fainted"] >= self.amount then
            beholder.stopObserving(id)
            data["fainted"] = self.amount
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local fainted = data["fainted"]
    return { "", "Progress: " .. math.min(fainted, self.amount) .. "/" .. tostring(self.amount) }
  end
})

QuestRegistry:Register({
  id = "SUPER_FULL",
  amount = 1,
  threshold = 100,
  reward = 500,

  get_max_fullness = function(self)
    local max_fullness = 0
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      if member.Fullness > max_fullness then
        max_fullness = member.Fullness
      end
    end

    print("Max fullness is " .. tostring(max_fullness))
    return max_fullness
  end,
  getDescription = function(self)
    return string.format("Have %s member be above %s hunger",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan),
      M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["best_fullness"] = 0

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        print("Checking fullness for quest " .. self.id)

        local max_fullness = self:get_max_fullness()
        data["best_fullness"] = math.max(data["best_fullness"], max_fullness)
        if max_fullness > self.threshold then
          beholder.stopObserving(id)

          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local best_fullness = data["best_fullness"]
    return { "", "Max Fullness: " .. best_fullness }
  end
})

local function CreateEmptyStomachQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    threshold = config.threshold,
    reward = config.reward,

    can_apply = function()
      return _DATA.Save.ActiveTeam.Players.Count == config.amount
    end,

    get_min_fullness = function(self)
      local min_fullness = math.huge
      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        if member.Fullness < min_fullness then
          min_fullness = member.Fullness
        end
      end
      print("Min fullness is " .. tostring(min_fullness))
      return min_fullness
    end,

    getDescription = function(self)
      local member_text = self.amount == 1 and "member" or "members"
      return string.format("Have all %s %s be below %s hunger",
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), member_text,
        M_HELPERS.MakeColoredText(tostring(self.threshold), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_map_start_id
        local on_turn_end_id

        on_map_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
          data["min_fullness"] = math.huge
        end)

        on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          print("Checking fullness for quest " .. self.id)
          local min_fullness = self:get_min_fullness()
          data["min_fullness"] = math.min(data["min_fullness"], min_fullness)

          if min_fullness < self.threshold then
            beholder.stopObserving(on_map_start_id)
            beholder.stopObserving(on_turn_end_id)
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local min_fullness = data["min_fullness"]
      if min_fullness == math.huge then
        min_fullness = 100
      end
      local status = min_fullness < self.threshold and "Completed" or "Not Completed"
      return { "", status }
    end
  }
end

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_1",
  amount = 1,
  threshold = 5,
  reward = 300
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_2",
  amount = 2,
  threshold = 20,
  reward = 500
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_3",
  amount = 3,
  threshold = 35,
  reward = 500
}))

QuestRegistry:Register(CreateEmptyStomachQuest({
  id = "EMPTY_STOMACH_4",
  amount = 4,
  threshold = 50,
  reward = 500
}))

local function CreateLowHealthQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    health_percent = config.health_percent,
    reward = config.reward,

    can_apply = function()
      return _DATA.Save.ActiveTeam.Players.Count == config.amount
    end,

    check_all_low_health = function(self)
      local threshold = self.health_percent / 100
      for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        local health_ratio = member.HP / member.MaxHP
        if health_ratio > threshold then
          return false
        end
      end
      return true
    end,

    getDescription = function(self)
      local member_text = self.amount == 1 and "member" or "members"
      return string.format("Have all %s %s be at or below %s%% HP",
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), member_text,
        M_HELPERS.MakeColoredText(tostring(self.health_percent), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_map_start_id
        local on_turn_end_id

        on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          print("Checking HP for quest " .. self.id)

          if self:check_all_low_health() then
            beholder.stopObserving(on_map_start_id)
            beholder.stopObserving(on_turn_end_id)
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local status = data["completed"] and "Completed" or "Not Completed"
      return { "", status }
    end
  }
end

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_1",
  amount = 1,
  health_percent = 5,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_2",
  amount = 2,
  health_percent = 20,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_3",
  amount = 3,
  health_percent = 35,
  reward = 500
}))

QuestRegistry:Register(CreateLowHealthQuest({
  id = "LOW_HEALTH_4",
  amount = 4,
  health_percent = 50,
  reward = 500
}))

QuestRegistry:Register({
  id = "STAY_ON_FLOOR",
  amount = 1000,
  reward = 500,
  getDescription = function(self)
    return string.format("Stay on floor for %s turns",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)
    data["turns"] = 0
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local id
      id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
        data["turns"] = data["turns"] + 1
        if data["turns"] >= self.amount then
          beholder.stopObserving(id)
          data["turns"] = self.amount
          GAME:WaitFrames(30)
          self:complete_quest()
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local turns = data["turns"]
    return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
  end
})

local function CreateAvoidActionQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      return string.format(config.description_template,
        M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      local no_action_used = true
      data["turns"] = 0

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_map_turn_end_id
        local on_before_actions_id

        on_map_turn_end_id = beholder.observe("OnMapTurnEnds", function(owner, ownerChar, context, args)
          if no_action_used then
            data["turns"] = data["turns"] + 1
          else
            data["turns"] = 0
          end

          if data["turns"] >= self.amount then
            beholder.stopObserving(on_map_turn_end_id)
            beholder.stopObserving(on_before_actions_id)
            data["turns"] = self.amount
            GAME:WaitFrames(30)
            self:complete_quest()
          end

          no_action_used = true
        end)

        on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
          -- Use custom check function if provided, otherwise check forbidden actions
          if config.check_forbidden then
            if config.check_forbidden(context) then
              no_action_used = false
            end
          else
            for _, forbidden_type in ipairs(config.forbidden_actions) do
              if context.ActionType == forbidden_type then
                no_action_used = false
                break
              end
            end
          end
        end)
      end)
    end,

    getProgressTexts = function(self)
      local data = QuestRegistry:GetData(self)
      local turns = data["turns"]
      return { "", "Progress: " .. math.min(turns, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateAvoidActionQuest({
  id = "DO_NOT_USE_ITEMS",
  amount = 300,
  reward = 500,
  description_template = "Do not use or throw items for %s turns",
  forbidden_actions = { RogueEssence.Dungeon.BattleActionType.Item, RogueEssence.Dungeon.BattleActionType.Throw }
}))

QuestRegistry:Register(CreateAvoidActionQuest({
  id = "DO_NOT_USE_SKILLS",
  amount = 200,
  reward = 500,
  description_template = "Do not use any skills for %s turns",
  check_forbidden = function(context)
    return context.ActionType == RogueEssence.Dungeon.BattleActionType.Skill and context.UsageSlot ~=
        RogueEssence.Dungeon.BattleContext.DEFAULT_ATTACK_SLOT
  end
}))

QuestRegistry:Register({
  id = "RECRUIT",
  amount = 1,
  reward = 500,

  capped_floor = 20,

  can_apply = function(self)
    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      if SV.EmberFrost.LastFloor <= self.capped_floor then
        return false
      end

      local possible_recruits = GetFloorSpawns({
        not_has_features = { UnrecruitableType }
      })
      return #possible_recruits > 0
    end
    return true
  end,
  getDescription = function(self)
    return string.format("Recruit a new team member")
  end,

  get_total_team_members = function(self)
    return _DUNGEON.ActiveTeam.Players.Count + _DUNGEON.ActiveTeam.Assembly.Count
  end,

  set_active_effects = function(self, active_effect, zone_context)
    local data = QuestRegistry:GetData(self)

    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_start_id
      local on_turn_end_id

      on_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
        data["starting_team_members"] = self:get_total_team_members()
      end)

      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        local new_count = self:get_total_team_members()
        if new_count - data["starting_team_members"] >= self.amount then
          beholder.stopObserving(on_start_id)
          beholder.stopObserving(on_turn_end_id)
          self:complete_quest()
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local total_team_members = self:get_total_team_members()
    local data = QuestRegistry:GetData(self)
    return { "", "Progress: " .. math.min(total_team_members - data["starting_team_members"], self.amount) .. "/" ..
    tostring(self.amount) }
  end
})

QuestRegistry:Register({
  id = "LEVEL_UP",
  amount = 1,
  reward = 300,
  getDescription = function(self)
    return string.format("Level up %s time", M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
  end,

  get_total_level_from_start = function(self)
    local total_level = 0
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      local tbl = LTBL(member)
      total_level = total_level + (member.Level - tbl["StartLevel"])
    end
    for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      total_level = total_level + (member.Level - tbl["StartLevel"])
    end
    return total_level
  end,

  cleanup = function(self)
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
      local tbl = LTBL(member)
      tbl["StartLevel"] = nil
    end
    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
      local tbl = LTBL(member)
      tbl["StartLevel"] = nil
    end
  end,

  set_active_effects = function(self, active_effect, zone_context)
    beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
      local on_start_id
      local on_turn_end_id

      on_start_id = beholder.observe("OnMapStarts", function(owner, ownerChar, context, args)
        for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
          local tbl = LTBL(member)
          tbl["StartLevel"] = member.Level
        end
        for member in luanet.each(_DUNGEON.ActiveTeam.Assembly) do
          local tbl = LTBL(member)
          tbl["StartLevel"] = member.Level
        end
      end)

      on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        local leveled_up = self:get_total_level_from_start()
        if leveled_up >= self.amount then
          beholder.stopObserving(on_start_id)
          beholder.stopObserving(on_turn_end_id)
          self:complete_quest()
        end
      end)
    end)
  end,

  getProgressTexts = function(self)
    local leveled_up = self:get_total_level_from_start()
    return { "Progress: " .. math.min(leveled_up, self.amount) .. "/" .. tostring(self.amount) }
  end
})

local function CreateItemUseQuest(config)
  return {
    id = config.id,
    amount = config.amount,
    reward = config.reward,

    getDescription = config.getDescription or function(self)
      local action_verb = config.action_verb or "Use"
      local item_type = self.amount == 1 and config.item_type_singular or config.item_type_plural
      return string.format(
        action_verb .. " " .. M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan) .. " " ..
        item_type, M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan))
    end,

    set_active_effects = function(self, active_effect, zone_context)
      local data = QuestRegistry:GetData(self)
      data["count"] = 0

      beholder.group(EMBERFROST_BEHOLDER_GROUPS, function()
        local on_before_actions_id
        local on_turn_end_id

        on_turn_end_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
          if data["count"] >= self.amount then
            beholder.stopObserving(on_before_actions_id)
            beholder.stopObserving(on_turn_end_id)
            GAME:WaitFrames(30)
            self:complete_quest()
          end
        end)

        on_before_actions_id = beholder.observe("OnBeforeActions", function(owner, ownerChar, context, args)
          if context.ActionType == RogueEssence.Dungeon.BattleActionType.Item then
            local item = GetItemFromContext(context)
            local contains = ItemIdContainsState(item, config.state_type)
            if contains then
              data["count"] = data["count"] + 1
            end
          end
        end)
      end)
    end,

    getProgressTexts = config.getProgressTexts or function(self)
      local data = QuestRegistry:GetData(self)
      local count = data["count"] or 0
      return { "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
    end
  }
end

QuestRegistry:Register(CreateItemUseQuest({
  id = "USE_ORB",
  amount = 1,
  reward = 100,
  action_verb = "Use",
  item_type_singular = "orb",
  item_type_plural = "orbs",
  state_type = OrbStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "USE_WAND",
  amount = 5,
  reward = 200,
  action_verb = "Use",
  item_type_singular = "wand",
  item_type_plural = "wands",
  state_type = WandStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "USE_ORB_2",
  amount = 2,
  reward = 250,
  action_verb = "Use",
  item_type_singular = "orb",
  item_type_plural = "orbs",
  state_type = OrbStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "EAT_SEED",
  amount = 2,
  reward = 100,
  action_verb = "Eat",
  item_type_singular = "seed",
  item_type_plural = "seeds",
  state_type = SeedStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "EAT_GUMMI",
  amount = 1,
  reward = 200,
  action_verb = "Eat",
  item_type_singular = "gummi",
  item_type_plural = "gummis",
  state_type = GummiStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "EAT_ITEMS",
  amount = 4,
  reward = 250,
  action_verb = "Eat",
  item_type_singular = "item",
  item_type_plural = "edible items",
  state_type = EdibleStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "EAT_FOOD_ITEMS",
  amount = 2,
  reward = 250,
  action_verb = "Eat",
  item_type_singular = "food item",
  item_type_plural = "food items",
  state_type = FoodStateType
}))

QuestRegistry:Register(CreateItemUseQuest({
  id = "USE_MACHINE_ITEMS",
  amount = 1,
  reward = 300,
  action_verb = "Use",
  item_type_singular = "machine item",
  item_type_plural = "machine items",
  state_type = MachineStateType,
  getDescription = function(self)
    local recall_box = M_HELPERS.GetItemName("machine_recall_box")
    local assembly_box = M_HELPERS.GetItemName("machine_assembly_box")
    local ability_capsule = M_HELPERS.GetItemName("machine_ability_capsule")

    return string.format("Use %s machine or capsule items",
      M_HELPERS.MakeColoredText(tostring(self.amount), PMDColor.Cyan), recall_box, assembly_box, ability_capsule)
  end,

  getProgressTexts = function(self)
    local data = QuestRegistry:GetData(self)
    local count = data["count"] or 0
    return { "", "Progress: " .. math.min(count, self.amount) .. "/" .. tostring(self.amount) }
  end
}))


