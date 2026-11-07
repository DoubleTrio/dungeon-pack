local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local group = {}

function group.ExpandedSatchel(add)
ExpandedSatchel = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  name = "Expanded Satchel",
  id = "EXPANDED_SATCHEL",
  bag_increase = 8,
  description = "Increase the bag size by {BagIncrease} for the duration of the dungeon",
  description_vars = {
    BagIncrease = { field = "bag_increase", format = "number" },
  },
  keywords = { "BAG_SIZE" },
  offer_time = "beginning",

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

  get_progress_texts = function(self)
    return { "Current Bag Size: " .. M_HELPERS.MakeColoredText(tostring(_ZONE.CurrentZone.BagSize), PMDColor.Cyan) }
  end,

  progress = function(self)
    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + self.bag_increase
  end
})


end

function group.JeweledBug(add)
JeweledBug = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  name = "Jeweled Bug",
  id = "JEWELLED_BUG",
  amount = 50000,
  description = "Gain a {Item} (eats a random item at the start of each floor and gives {amount}",
  description_vars = {
    Item = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("terrasphere_jeweled_bug"):GetColoredName() end, format = "text" },
    amount = { field = "amount", format = "money", space = false },
  },
  offer_time = "beginning",

  apply = function(self)
    local items = { {
      Item = "terrasphere_jeweled_bug",
      Amount = 1
    } }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})

end

function group.SticksAndStones(add)
SticksAndStones = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  amount = 5,

  apricorns = { "apricorn_black", "apricorn_blue", "apricorn_brown", "apricorn_green", "apricorn_purple", "apricorn_red", "apricorn_white", "apricorn_yellow", "apricorn_plain" },
  name = "Sticks & Stones",
  id = "STICKS_AND_STONES",
  description = "Gain {amount} of each: {GoldenThorn}, {Sticks}, {Gravelerock}, {GeoPebble}",
  description_vars = {
    GoldenThorn = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_golden_thorn"):GetIconName() end, format = "text" },
    Sticks = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_stick"):GetIconName() end, format = "text" },
    Gravelerock = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_gravelerock"):GetIconName() end, format = "text" },
    GeoPebble = { get = function(self) return _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get("ammo_geo_pebble"):GetIconName() end, format = "text" },
    amount = { field = "amount", format = "number" },
  },

  offer_time = "beginning",
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
-- MayBreakMyBones = add({
--   amount = 9,
--   percent = 50,

--   name = "...Break My Bones",
--   id = "BREAK_MY_BONES",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.Terrasphere.SelectedEnchantments, SticksAndStones.id)
--   end,

--   get_description = function(self)
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

-- Enemies spawn with a sharply decreased random stat debuff
-- Randomly disable moves from an enemy
-- Eenmy spawns with 1 sealed move
-- Taunt - Attacks have a chance of inflicting torment 
-- Enemy cannot raise their stats
-- Split into tier 1 and tier 2

-- WordsWillNever = add({

--   name = "...Words Will Never",
--   id = "WORDS_WILL_NEVER",
--   group = ENCHANTMENT_TYPES.items,
--   can_apply = function(self)
--     return HasEnchantment(SV.Terrasphere.SelectedEnchantments, MayBreakMyBones.id)
--   end,

--   get_description = function(self)
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

-- BuriedTreasures = add({
--   turn_interval = 200,
--   name = "Buried Treasures",
--   id = "BURIED_TREASURES",
--   group = ENCHANTMENT_TYPES.items,
--   get_description = function(self)
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

-- Pacifist = add({
--   gold_amount = 500,
--   name = "Pacifist",
--   id = "PACIFIST",
--   group = ENCHANTMENT_TYPES.items,
--   get_description = function(self)
--     return string.format(
--       "Select a character. When that character deals no damage for the floor, gain %s the following floor.",
--       M_HELPERS.MakeColoredText(tostring(self.gold_amount) .. PMDSpecialCharacters.Money, PMDColor.Cyan)
--     )
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "terrasphere_pacifist", EnchantmentID = self.id })))
--   end,

--   offer_time = "beginning",
--   rarity = 1,
--   apply = function(self)
--     AssignEnchantmentToCharacter(self)
--   end,
-- })


end

function group.PandorasItems(add)
PandorasItems = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  amount = 1,
  gold_amount = 1000,
  name = "Pandora's Items",
  id = "PANDORAS_ITEMS",
  description = "Gain {amount} random {Equipment}, {Orb}, and {Apricorn}. At the start of each floor, any non-held items are randomized (except food, loots, shards, and treasures)",
  description_vars = {
    Equipment = { value = "equipment", format = "text", color = "Pink" },
    Orb = { value = "orb", format = "text", color = "Pink" },
    Apricorn = { value = "apricorn", format = "text", color = "Pink" },
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    return {}
    -- local data = EnchantmentRegistry:GetData(self)
    -- local equipment = data["equipment"]
    -- local orb = data["orb"]

    -- print(tostring(equipment))
    -- print(tostring(orb))
    -- print(Serpent.dump(SV.Terrasphere.Enchantments.Data) .. " hmmmm")
    -- print(Serpent.dump(EnchantmentRegistry._data) .. " hmmmm2")
    -- print("Are they the same table reference?")
    -- print(tostring(EnchantmentRegistry._data == SV.Terrasphere.Enchantments.Data))

    -- print(Serpent.dump(SV.Terrasphere.Enchantments.Seen) .. " hmmmm")
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

end

function group.SupplyDrop(add)
SupplyDrop = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  amount = 1,
  name = "Supply Drop",
  id = "SUPPLY_DROP",
  -- group = ENCHANTMENT_TYPES.items,
  description = "After each checkpoint, gain a random supply drop containing {Items}",
  description_vars = {
    Items = { value = "essential items", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",

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

end

function group.YourAWizard(add)
YourAWizard = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  stack = 3,
  amount = 3,
  percent = 3,
  name = "You're a Wizard!",
  id = "YOURE_A_WIZARD",
  -- group = ENCHANTMENT_TYPES.items,
  description = "Gain {stack} {stack:plural:stack:stacks} of {amount} random {Wands}. Then select a party member. That member will gain {percent} special attack boost for each unique {Wand} in your inventory.",
  description_vars = {
    percent = { field = "percent", format = "percent" },
    Wands = { get = function(self) return self.amount == 1 and "wand" or "wands" end, format = "text", color = "Pink" },
    Wand = { value = "wand", format = "text", color = "Pink" },
    stack = { field = "stack", format = "number" },
    amount = { field = "amount", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)

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

    local char, in_assembly = FindCharacterWithEnchantment(self.id)
    local char_name = char and char:GetDisplayName(true) or nil

    table.insert(str_arr, "\n")
    table.insert(str_arr, "Assigned to: " .. char_name)
    table.insert(str_arr, "Special Attack Boost: " .. M_HELPERS.MakeColoredText(tostring(boost_amount) .. "%", PMDColor.Cyan))

    return str_arr
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({ StatusID = "terrasphere_wizard", EnchantmentID = self.id })))
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

end

function group.PlantYourSeeds(add)
PlantYourSeeds = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  money = 300,
  amount = 3,
  minimum = 5,
  name = "Plant Your Seeds",
  id = "PLANT_YOUR_SEEDS",
  description = "Gain {amount} random {Seeds}. At the start of each floor, if you have at least {minimum} non-held {minimum:plural:seed:seeds}, lose all of them and gain {money} for each seed",
  description_vars = {
    Seeds = { get = function(self) return self.amount == 1 and "seed" or "seeds" end, format = "text", color = "Pink" },
    money = { field = "money", format = "money", space = true },
    amount = { field = "amount", format = "number" },
    minimum = { field = "minimum", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
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

end

function group.StackOfPlates(add)
StackOfPlates = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  amount = 2,
  choice = 5,
  name = "Stack of Plates",
  id = "STACK_OF_PLATES",
  description = "Gain {amount} random type {Plates}. Then select a {Plate} from a choice of {choice} ",
  description_vars = {
    Plates = { get = function(self) return self.amount == 1 and "plate" or "plates" end, format = "text", color = "Pink" },
    Plate = { value = "plate", format = "text", color = "Pink" },
    amount = { field = "amount", format = "number" },
    choice = { field = "choice", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)

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


end

function group.Randorb(add)
Randorb = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  name = "Randorb",
  id = "RANDORB",

  description = "Gain a random orb. At the start of each floor, gain a random orb",

  offer_time = "beginning",
  get_progress_texts = function(self)
  end,

  set_active_effects = function(self, active_effect, zone_context)

    beholder.group(TERRASPHERE_BEHOLDER_GROUPS, function()
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

end

function group.BerryNutritious(add)
BerryNutritious = add({
  rarity = EnchantmentRarity.Common,
  tags = { "items" },
  name = "Berry Nutritous",
  id = "BERRY_NUTRITOUS",
  chance = 50,

  description = "Gain a random berry. Whenever a team member eats a berry, there is a {chance} chance they get a random stat boost",
  description_vars = {
    chance = { field = "chance", format = "percent" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)

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


-- Negative Aura - For each  At the end of each turn, enemies within 2 tiles of
-- Rationalize: This Pokémon's Normal-Type moves are Super Effective to Fairy, Ghosts, and Dragon-Types in exchange for Moves from those Types becoming Super Effective to this Pokémon.
-- https://gamefaqs.gamespot.com/boards/359435-pokemon-violet/80421481

end

return group
