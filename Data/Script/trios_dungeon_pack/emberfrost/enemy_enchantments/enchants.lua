local registry = require 'trios_dungeon_pack.emberfrost.registry'
require 'trios_dungeon_pack.emberfrost.enemy_enchantments.runtime'
local combat = require 'trios_dungeon_pack.emberfrost.enemy_enchantments.families.combat'
local survival = require 'trios_dungeon_pack.emberfrost.enemy_enchantments.families.survival'
local testing = require 'trios_dungeon_pack.emberfrost.enemy_enchantments.families.testing'

registry.add(EnemyEnchantmentRegistry, combat.Hazer)
registry.add(EnemyEnchantmentRegistry, survival.HungerStrike)
registry.add(EnemyEnchantmentRegistry, testing.Test2)
registry.add(EnemyEnchantmentRegistry, testing.Test3)
registry.add(EnemyEnchantmentRegistry, testing.Test4)
registry.add(EnemyEnchantmentRegistry, testing.Test5)
registry.add(EnemyEnchantmentRegistry, testing.Test6)
