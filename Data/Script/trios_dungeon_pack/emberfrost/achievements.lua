local registry = require 'trios_dungeon_pack.emberfrost.registry'
require 'trios_dungeon_pack.emberfrost.achievements.runtime'

local clears = require 'trios_dungeon_pack.emberfrost.achievements.clears'
local score = require 'trios_dungeon_pack.emberfrost.achievements.score'
local collection = require 'trios_dungeon_pack.emberfrost.achievements.collection'
local roguelocke = require 'trios_dungeon_pack.emberfrost.achievements.roguelocke'
local enchantment_challenges = require 'trios_dungeon_pack.emberfrost.achievements.enchantment_challenges'

-- Preserve menu order, including clear achievements surrounding score/collection groups.
registry.add(AchievementRegistry, clears.first_clear)
registry.add(AchievementRegistry, score.score)
registry.add(AchievementRegistry, clears.solo)
registry.add(AchievementRegistry, collection.collection)
registry.add(AchievementRegistry, clears.purist)
registry.add(AchievementRegistry, roguelocke.roguelocke)
registry.add(AchievementRegistry, enchantment_challenges.enchantment_challenges)
