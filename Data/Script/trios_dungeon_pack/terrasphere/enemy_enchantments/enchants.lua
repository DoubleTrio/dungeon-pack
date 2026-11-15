local registry = require 'trios_dungeon_pack.terrasphere.registry'
require 'trios_dungeon_pack.terrasphere.enemy_enchantments.runtime'
local combat = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.families.combat'
local survival = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.families.survival'
local testing = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.families.testing'

registry.add(EnemyEnchantmentRegistry, combat.HAX)
registry.add(EnemyEnchantmentRegistry, combat.Vampirism)
registry.add(EnemyEnchantmentRegistry, combat.Shortsighted)
registry.add(EnemyEnchantmentRegistry, combat.Longsighted)
registry.add(EnemyEnchantmentRegistry, combat.StatsPadding)
registry.add(EnemyEnchantmentRegistry, combat.Tactical)
registry.add(EnemyEnchantmentRegistry, combat.Hazer)
registry.add(EnemyEnchantmentRegistry, survival.HungerStrike)
registry.add(EnemyEnchantmentRegistry, testing.Test2)
registry.add(EnemyEnchantmentRegistry, testing.Test3)
registry.add(EnemyEnchantmentRegistry, testing.Test4)
registry.add(EnemyEnchantmentRegistry, testing.Test5)
registry.add(EnemyEnchantmentRegistry, testing.Test6)
