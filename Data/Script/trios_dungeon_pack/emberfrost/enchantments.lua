
ENCHANTMENT_TYPES = {
  items = "ITEMS",
  money = "MONEY",
  power = "POWER"
}

-- NOTE: These can only be called during GROUND MODE

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
  map_effects = function(self, active_effect)
    print(self.name .. " activated.")
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

  -- When the end of the dungeon is reached, provide the player rewards
  reward = function(self)
    print(self.name .. " progressed.")
  end
}

-- Chillmark = setmetatable({
--   name = "Chillmark",
--   type = "Frost",
--   description = "",
--   offer_time = 1,
--   rarity = 1,

--   apply = function(self)
--     print("Chillmark active: enemies move slower.")
--   end
-- }, { __index = PowerupDefaults })


-- Frostbite = setmetatable({
--   name = "Frostbite",
--   type = "Boost",
--   description = "",
--   offer_time = 1,
--   rarity = 1,

--   apply = function(self)
--     print("Frostbite active: attacks deal damage over time.")
--   end
-- }, { __index = PowerupDefaults })

EmberfrostSatchel = setmetatable({
  name = "Emberfrost Satchel",
  group = ENCHANTMENT_TYPES.items,
  description = "Increases the team's bag size by 4 for the duration of the dungeon. Additional bag size of +5 in Emberfrost Depths.",
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + 4
  end,

  progress = function(self)
    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + 4
  end,
}, { __index = PowerupDefaults })

AllTerrainTreads = setmetatable({
  name = "Treading Through",
  group = ENCHANTMENT_TYPES.items,
  description = "Both parties gain an All-Terrain Gear (allows the holder to traverse water, lava, and pits)",
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    -- TODO: Add a custom menu to select which inventory item
    -- Check out InventorySelectMenu.lua for reference.
  end,

}, { __index = PowerupDefaults })

Gain5000P = setmetatable({
  name = "Gain 5000 P",
  group = ENCHANTMENT_TYPES.money,
  description = "Gain 5000 P",
  offer_time = "beginning",
  rarity = 1,

  apply = function(self)
    -- TODO: Add a custom menu to select which inventory item
    -- Check out InventorySelectMenu.lua for reference.
    _DATA.Save.ActiveTeam.Money = _DATA.Save.ActiveTeam.Money + 5000
    UI:WaitShowDialogue("You gained 5000 P!")
  end,

}, { __index = PowerupDefaults })