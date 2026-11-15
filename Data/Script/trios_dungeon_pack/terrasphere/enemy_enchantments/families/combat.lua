local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local helpers = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.helpers'
local group = {}

function group.HAX(add)
  add({
    id = "HAX_ENEMY",
    name = "HAX",
    rarity = EnchantmentRarity.Common,
    description = "Enemies have an extra {crit} critical-hit chance",
    description_vars = { crit = { value = 25, format = "percent", color = "Cyan" } },
    set_active_effects = function(self, active_effect, zone_context)
      helpers.AddStatusHooks(active_effect, self.id, "terrasphere_hax")
    end,
  })
end

function group.Vampirism(add)
  add({
    id = "VAMPIRISM_ENEMY",
    name = "Vampirism",
    rarity = EnchantmentRarity.Common,
    healing_by_checkpoint = { 0, 0, 25, 25, 50, 50 },
    get_healing_percent = function(self)
      return self.healing_by_checkpoint[SV.Terrasphere.CheckpointProgression + 1] or 0
    end,
    description = "Enemies recover {healing} of the damage they deal as HP. This increases as the dungeon progresses.",
    description_vars = {
      healing = { get = function(self) return self:get_healing_percent() end, format = "percent", color = "Red" },
    },
    set_active_effects = function(self, active_effect, zone_context)
      helpers.AddStatusHooks(active_effect, self.id, "terrasphere_vampirism")
    end,
  })
end

function group.Shortsighted(add)
  add({
    id = "SHORTSIGHTED_ENEMY",
    name = "Shortsighted",
    rarity = EnchantmentRarity.Common,
    description = "Your party's moves have {range} less range",
    description_vars = { range = { value = 1, format = "number", color = "Red" } },
    set_active_effects = function(self, active_effect, zone_context)
      active_effect.OnMapStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
          EnchantmentID = self.id,
          StatusID = "terrasphere_shortsighted",
          ApplyToAll = true
        })))
    end,
  })
end

function group.Longsighted(add)
  add({
    id = "LONGSIGHTED_ENEMY",
    name = "Longsighted",
    rarity = EnchantmentRarity.Common,
    description = "The enemies' moves have {range} more range",
    description_vars = { range = { value = 1, format = "number", color = "Red" } },
    set_active_effects = function(self, active_effect, zone_context)
      helpers.AddStatusHooks(active_effect, self.id, "terrasphere_longsighted")
    end,
  })
end

function group.StatsPadding(add)
  add({
    id = "STATS_PADDING_ENEMY",
    name = "Stats Padding",
    rarity = EnchantmentRarity.Common,
    chance = 30,
    description = "Enemies have a {chance} chance to gain random stat boosts based on their level",
    description_vars = { chance = { field = "chance", format = "percent" } },
    set_active_effects = function(self, active_effect, zone_context)
      local args = Serpent.line({ EnchantmentID = self.id, Chance = self.chance })
      active_effect.OnMapStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("BoostEnemyStats", args))
      active_effect.OnTurnStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("BoostEnemyStats", args))
    end,
  })
end

function group.Tactical(add)
  add({
    id = "TACTICAL_ENEMY",
    name = "Tactical",
    rarity = EnchantmentRarity.Common,
    chance = 30,
    description = "Enemies now have a {chance} that they become smarter their positioning and move choice",
    description_vars = { chance = { field = "chance", format = "percent" } },
    set_active_effects = function(self, active_effect, zone_context)
      local args = Serpent.line({ EnchantmentID = self.id, Chance = self.chance })
      active_effect.OnMapStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("UpgradeTactics", args))
      active_effect.OnTurnStarts:Add(2,
        RogueEssence.Dungeon.SingleCharScriptEvent("UpgradeTactics", args))
    end,
  })
end

function group.Hazer(add)
  add({
    id = "HAZER_ENEMY",
    name = "Hazer",
    rarity = EnchantmentRarity.Common,
    turns_between_haze = 100,
    description = "Every {turns} turns on a floor, Haze removes all stat changes from your party. Enemies are unaffected",
    description_vars = { turns = { field = "turns_between_haze", format = "number" } },
    get_progress_texts = function(self)
      local data = EnemyEnchantmentRegistry:GetData(self)
      local remaining = math.max(0, self.turns_between_haze - (data.Turns or 0))
      return { "Turns until Haze: " .. M_HELPERS.MakeColoredText(tostring(remaining), PMDColor.Cyan) }
    end,
    set_active_effects = function(self, active_effect, zone_context)
      active_effect.OnMapStarts:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereHazer",
        Serpent.line({ EnchantmentID = self.id, Reset = true })))
      active_effect.OnMapTurnEnds:Add(2, RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereHazer",
        Serpent.line({ EnchantmentID = self.id, Turns = self.turns_between_haze })))
    end,
  })
end

function group.HungerStrike(add)
  add({
    rarity = EnchantmentRarity.Common,
    id = "HUNGER_STRIKE_ENEMY",
    name = "Hunger Strike",
    description = "When enemies inflict damage with a move, the target loses 3 hunger points",
    set_active_effects = function(self, active_effect, zone_context)
      helpers.AddStatusHooks(active_effect, self.id, "terrasphere_hunger_strike_enemy")
    end,
  })
end

return group
