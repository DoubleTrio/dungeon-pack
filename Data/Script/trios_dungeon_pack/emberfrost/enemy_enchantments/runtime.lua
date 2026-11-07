require 'trios_dungeon_pack.emberfrost.registry'
local descriptions = require 'trios_dungeon_pack.emberfrost.descriptions'

local defaults = {
  can_apply = function(self) return true end,
  get_description = function(self) return descriptions.Format(self) end,
  get_progress_texts = function(self) return {} end,
  apply = function(self) end,
  set_active_effects = function(self, activeEffect, zoneContext) end,
  cleanup = function(self) end,
}

EnemyEnchantmentRegistry = CreateRegistry({
  registry_table = {},
  seen_table_path = "EmberFrost.EnemyEnchantments.Seen",
  selected_table_path = "EmberFrost.EnemyEnchantments.Selected",
  data_table_path = "EmberFrost.EnemyEnchantments.Data",
  defaults = defaults,
})
