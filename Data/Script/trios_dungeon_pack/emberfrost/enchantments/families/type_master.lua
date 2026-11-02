local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
local group = {}

function group.TypeMaster(add)
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



TypeMaster = add({
  rarity = EnchantmentRarity.Common,
  tags = { "type_master" },


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
  description = "When your team has recruited all {TotalTypes} types at the same time, gain a massive reward (includes starting party)",
  description_vars = {
    TotalTypes = { get = function(self) return #self.valid_types end, format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)

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

end

return group
