local helpers = {}

function helpers.AddStatusHooks(active_effect, enchantment_id, status_id, map_start_priority, turn_start_priority)
  map_start_priority = map_start_priority or 2
  turn_start_priority = turn_start_priority or 2
  local args = Serpent.line({ EnchantmentID = enchantment_id, StatusID = status_id })
  active_effect.OnMapStarts:Add(map_start_priority,
    RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereApplyEnemyEnchantments", args))
  active_effect.OnTurnStarts:Add(turn_start_priority,
    RogueEssence.Dungeon.SingleCharScriptEvent("TerrasphereApplyEnemyEnchantments", args))
end

return helpers
