local registry = require 'trios_dungeon_pack.emberfrost.registry'
require 'trios_dungeon_pack.emberfrost.enchantments.runtime'

local items = require 'trios_dungeon_pack.emberfrost.enchantments.families.items'
local survival = require 'trios_dungeon_pack.emberfrost.enchantments.families.survival'
local choices = require 'trios_dungeon_pack.emberfrost.enchantments.families.choices'
local party = require 'trios_dungeon_pack.emberfrost.enchantments.families.party'
local combat = require 'trios_dungeon_pack.emberfrost.enchantments.families.combat'
local economy = require 'trios_dungeon_pack.emberfrost.enchantments.families.economy'
local exploration = require 'trios_dungeon_pack.emberfrost.enchantments.families.exploration'
local type_master = require 'trios_dungeon_pack.emberfrost.enchantments.families.type_master'
local tarot = require 'trios_dungeon_pack.emberfrost.enchantments.families.tarot'
local quests = require 'trios_dungeon_pack.emberfrost.enchantments.families.quests'

registry.add(EnchantmentRegistry, choices.MysteryEnchant)
registry.add(EnchantmentRegistry, choices.TwoForOne)

registry.add(EnchantmentRegistry, combat.DraconianDefience)
registry.add(EnchantmentRegistry, combat.HandsTied)
registry.add(EnchantmentRegistry, combat.Rationalize)
registry.add(EnchantmentRegistry, combat.Tempo)

registry.add(EnchantmentRegistry, economy.LooseChange)
registry.add(EnchantmentRegistry, economy.RainingGold)
registry.add(EnchantmentRegistry, economy.Shopper)
registry.add(EnchantmentRegistry, economy.TheBubble)
registry.add(EnchantmentRegistry, economy.TravelingMerchant)
registry.add(EnchantmentRegistry, economy.TreasureHunt)

registry.add(EnchantmentRegistry, exploration.SightSeer)

registry.add(EnchantmentRegistry, items.BerryNutritious)
registry.add(EnchantmentRegistry, items.ExpandedSatchel)
registry.add(EnchantmentRegistry, items.JeweledBug)
registry.add(EnchantmentRegistry, items.PandorasItems)
registry.add(EnchantmentRegistry, items.PlantYourSeeds)
registry.add(EnchantmentRegistry, items.Randorb)
registry.add(EnchantmentRegistry, items.StackOfPlates)
registry.add(EnchantmentRegistry, items.SticksAndStones)
registry.add(EnchantmentRegistry, items.SupplyDrop)
registry.add(EnchantmentRegistry, items.YourAWizard)

registry.add(EnchantmentRegistry, party.ATrueLeader)
registry.add(EnchantmentRegistry, party.MoralSupport)
registry.add(EnchantmentRegistry, party.Protagonist)
registry.add(EnchantmentRegistry, party.Puppeteer)
registry.add(EnchantmentRegistry, party.TeamBuilding)

registry.add(EnchantmentRegistry, quests.QuestMaster)

registry.add(EnchantmentRegistry, survival.CalmTheStorm)
registry.add(EnchantmentRegistry, survival.HungerStrike)
registry.add(EnchantmentRegistry, survival.Minimalist)
registry.add(EnchantmentRegistry, survival.PressureCooker)
registry.add(EnchantmentRegistry, survival.ThreadsOfLife)
registry.add(EnchantmentRegistry, survival.TrapTripper)
registry.add(EnchantmentRegistry, survival.TreadingThrough)

registry.add(EnchantmentRegistry, tarot.TarotCards)

registry.add(EnchantmentRegistry, type_master.TypeMaster)
