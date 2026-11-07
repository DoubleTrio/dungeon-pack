local EnchantmentRarity = require 'trios_dungeon_pack.emberfrost.enchantments.rarities'
local group = {}

function group.TeamBuilding(add)
APRICORNS = { "apricorn_black", "apricorn_blue", "apricorn_brown", 'apricorn_green', 'apricorn_purple', 'apricorn_plain', 'apricorn_red', 'apricorn_white', 'apricorn_yellow' }

TeamBuilding = add({
  rarity = EnchantmentRarity.Common,
  tags = { "party" },
  amount = 2,
  choice = 5,
  name = "Team Building",
  id = "TEAM_BUILDING",
  apricorn_amount = 2,
  total_choices = 5,
  amber_tear_amount = 3,

  description = "Gain {apricorn_amount} random {apricorn_amount:plural:apricorn:apricorns} and then select an apricorn from a choice of {total_choices}. Gain an {AssemblyBox} and {AmberTear}",
  description_vars = {
    AssemblyBox = { get = function(self) return M_HELPERS.GetItemName("machine_assembly_box") end, format = "text" },
    AmberTear = { get = function(self) return M_HELPERS.GetItemName("medicine_amber_tear", self.amber_tear_amount) end, format = "text" },
    apricorn_amount = { field = "apricorn_amount", format = "number" },
    total_choices = { field = "total_choices", format = "number" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local data = EnchantmentRegistry:GetData(self)
    local apricorns = data["apricorns"]

    local str_arr = {
      "Recieved: ",
    }
    for _, apricorn in ipairs(apricorns) do
      local apricorn_entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(apricorn)
      local apricorn_name = apricorn_entry:GetIconName()
      table.insert(str_arr, apricorn_name)
    end

    return str_arr
  end,

  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["apricorns"] = {}

    local random_items = {}

    for i = 1, self.amount do
      local random_apricorn_index = math.random(APRICORNS)
      local apricorn = APRICORNS[random_apricorn_index]
      table.insert(data["apricorns"], apricorn)
      table.insert(random_items, { Item = apricorn, Amount = 1 })
    end
    M_HELPERS.GiveInventoryItemsToPlayer(random_items)

    GAME:WaitFrames(20)

    local pool_items = {}

    local apricorns = GetRandomUnique(self.apricorns, 5)
    for _, apricorn in ipairs(apricorns) do
      table.insert(pool_items, { Item = apricorn, Amount = 1 })
    end

    local result = SelectItemFromList(
      string.format("Choose %s", M_HELPERS.MakeColoredText("1", PMDColor.Cyan)),
      pool_items
    )

    table.insert(data["apricorns"], result.Item)
    GAME:WaitFrames(20)
    M_HELPERS.GiveInventoryItemsToPlayer({ result })


    local items2 = {
      { Item = "machine_assembly_box", Amount = 1 },
      { Item = "medicine_amber_tear", Amount = self.amber_tear_amount },
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items2)

  end
})

function GetTM(tm)
  local entry = _DATA:GetItem(tm)


  local id_state = entry.ItemStates:Get(luanet.ctype(ItemIDStateType))
  local id = id_state.ID

  return id
end

--
-- function SetEggMovesRelearnable(member)

-- end
function GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  local skills = {}


  if include_egg_moves then
    for skill in luanet.each(member.SharedSkills) do
      table.insert(skills, skill.Skill)
    end
  end

  if include_tutor_moves then
    for skill in luanet.each(member.SecretSkills) do
      table.insert(skills, skill.Skill)
    end
  end


  if include_teach_skills then
    for skill in luanet.each(member.TeachSkills) do
      table.insert(skills, skill.Skill)
    end
  end

  return skills
end

function GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  
  local base_form = member.BaseForm
  local mon = _DATA:GetMonster(base_form.Species)
  local form = mon.Forms[base_form.Form]

  local skills = {}
  local seen = {} -- Track unique skills

  if include_egg_moves then
    for skill in luanet.each(form.SharedSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end

  if include_tutor_moves then
    for skill in luanet.each(form.SecretSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end


  if include_teach_skills then
    for skill in luanet.each(form.TeachSkills) do
      if not seen[skill.Skill] then
        table.insert(skills, skill.Skill)
        seen[skill.Skill] = true
      end
    end
  end


  return skills
end
-- local already_learned = member:HasBaseSkill(move)
-- if mon.PromoteFrom ~= "" then
--   playerMonId = RogueEssence.Dungeon.MonsterID(mon.PromoteFrom, form.PromoteForm, "normal", Gender.Genderless)
-- else
--   playerMonId = nil
-- end
-- end

function SetMovesRelearnable(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  local skills = GetMemberSkills(member, include_egg_moves, include_tutor_moves, include_teach_skills)
  for _, skill in ipairs(skills) do
    member.Relearnables[skill] = true
  end
end


end

function group.ATrueLeader(add)
ATrueLeader = add({
  rarity = EnchantmentRarity.Common,
  tags = { "party" },
  gold_amount = 10000,
  name = "A True Leader",
  id = "A_TRUE_LEADER",
  description = "You cannot swap leaders until the next checkpoint. Gain {gold_amount} when you do reach the next checkpoint.",
  description_vars = {
    gold_amount = { field = "gold_amount", format = "money", space = true },
  },

  on_checkpoint = function ()
    local data = EnchantmentRegistry:GetData(ATrueLeader)
    data["completed"] = true
    _DATA.Save.NoSwitching = false

  end,
  on_checkpoint_exit = function()
    local data = EnchantmentRegistry:GetData(self)
    if not data["completed"] then
      _DATA.Save.NoSwitching = true
    end
  end,
  offer_range = {3, 4},
  offer_time = "beginning",
  apply = function(self)
    local data = EnchantmentRegistry:GetData(self)
    data["completed"] = false

    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue(string.format("Note: Your team cannot swap leaders until the next checkpoint.",
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
    UI:SetCenter(false)
  end
})


end

function group.Protagonist(add)
Protagonist = add({
  rarity = EnchantmentRarity.Common,
  tags = { "party" },
  name = "Protagonist",
  id = "PROTAGONIST",
  boost = 20,
  description = "The {Leader} takes reduced damage from enemies and deals increased damage",
  description_vars = {
    Leader = { value = "active leader", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",
  set_active_effects = function(self, active_effect, zone_context)
    print("Setting active effects for Protagonist enchantment")
    active_effect.BeforeHits:Add(2,
      RogueEssence.Dungeon.BattleScriptEvent("Protagonist", Serpent.line({
        BoostAmount = self.boost
      })))
  end,

  get_progress_texts = function(self)

    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      return {
        "Active Leader: " .. _DUNGEON.ActiveTeam.Leader:GetDisplayName(true) or nil
      }
    else
      return {}
    end

  end,

  apply = function(self)
    FanfareText(string.format("The %s will now take reduced damage from enemies and deals increased damage!",
      M_HELPERS.MakeColoredText("active leader", PMDColor.Yellow)))
  end
})


function CountAssemblyWithKey(key)
  local count = 0
  for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
    local tbl = LTBL(member)
    if tbl ~= nil and tbl[key] == true then
      count = count + 1
    end
  end
  return count
end

end

function group.MoralSupport(add)
MoralSupport = add({
  rarity = EnchantmentRarity.Common,
  tags = { "party" },
  name = "Moral Support",
  id = "MORAL_SUPPORT",
  boost = 3,
  key = "EmberfrostRun",

  get_total_boost = function(self)

    local count = CountAssemblyWithKey(self.key)
    return count * self.boost
  end,
  description = "Your team gains a {boost} boost for each team member in the assembly recruited during this run (includes starting party)",
  description_vars = {
    boost = { field = "boost", format = "percent" },
  },
  offer_time = "beginning",
  set_active_effects = function(self, active_effect, zone_context)
    active_effect.BeforeHits:Add(2,
      RogueEssence.Dungeon.BattleScriptEvent("MoralSupport", Serpent.line({
        EnchantmentID = self.id,
      })))
  end,

  get_progress_texts = function(self)
    local total_boost = self:get_total_boost()
    return {
      "Total Boost: " .. M_HELPERS.MakeColoredText(tostring(total_boost) .. "%", PMDColor.Cyan)
    }
  end,

  apply = function(self)
    FanfareText(string.format("Your team will now gain a %s attack boost for each team member recruited this run!",
      M_HELPERS.MakeColoredText(tostring(self.boost) .. "%", PMDColor.Cyan)))
  end
})

-- For each equipment in your inventory, gain a 3% attack boost.
-- Fashionable = add({
--   "for each unique specs or googles"

-- })
--
-- Can't touch this
-- Vampiric - Select a character, that character heals for 30% of damage dealt.
-- An exclusive item for the Salamence family. When kept in the bag, it allows Dragon-type moves to hit Fairy-type Pokémon.
-- Dazzled - Choose a team member. For each equipment, lower the accuracy of the target
-- RunAndGun - Projectiles deal more damage if your team has a speed boost, depends on it
-- Spawn NPCs, which will give you rewards
-- Fitness - Each food item grants more hunger points, boosts to yourself
-- For 10 enemies fainted with an ammo,
-- Precision - Choose a team member. That team member. Moves that have less than 80% accuracy cannot miss. Moves with accuracy will miss more often
-- From now to the next checkpoint, spawn buried treasueres
-- Start of each floor, gain 1 PP in each move slot
-- Spawn more apricrons
-- Spawn more seeds
-- Checkpoint shop costs will be reduced by 20%
-- Randomly explode the enemies
-- All your party members gain the stat boost of the highest party member
-- Lots of Equipment: Select 3 equipment from a pool of 5 random ones.
-- Have a 50% chance to an item
-- More buried treasures spawn
-- Type Mastery  - If you recruit all types, gain a huge reward (includes assembly).
-- Trap Tripper Specialist - For every unique trap triggered on that floor, gain money
-- Shops, vaults, and  are more likely to show up
-- Monotype - If all your team members share a common type, gain a damage boost (Requires 3+ members).
-- Elemental Affinity - Choose a type. Your team does more damage with that type, but takes more damage from that type.
-- Weathered - Your team gains a boost depending on the current weather condition. Rain 
-- All In - Lost all your inventory items and (only offered past floor 15)
-- Gain 3 Invisibioty orbs
-- Regular attacks can destroy walls at the cost of 1 hunger
-- The Orb - Each orb usage increases your team's damage
-- Gain 2 random allies from the previous floors. Gain an assembly box. They have gummi boosts with random equioment attatched
-- RPG Gold - Your team has 25% chance to gain 50 p from an enemies. -- Enemies have a 50% chance to drop gold based on their level
-- Combo Chain: When you use 3 skills in a row. Second The final attack will be critical and deal double damage
-- Your team gains a critical chance boost
-- Your team does slighty more damage for super-effective moves.
-- Allowance - Gain 200 each mon that is not fully evolved at the start of each floor
-- Your team takes slightly more damage for not very effective moves.
-- All for one - Choose a team member. That members gains for power for each team member within 1 tile.
-- One for all - Choose a team member. That members transfer ALL status to all adjacent allies upon recieiving a status.
-- Team Building - Gain 2 random apricorns. Select a between apricrons and 2 amber tears and a friend bow. Gain a Assembly Box
-- Negligible Risk?: - Gain 20,000 P. Your team has a tiny chance to be inflicted with a random negative status at the end of the their turn
-- Gain a random gummi at the start of each floor.
-- Death Defying/ Second Wind - Gain a death amulet. If that member would faint, 50% chance to survive with 1 HP instead. When at 1 HP, gain a speed boost.
-- Quick Reflexes - Choose a team member. That member has a chance to dodge physical attacks.
-- Elusive - Each team gains a evasive boost at the start of each floor
-- Restart Mission - Lose all items in your inventory.
-- Each of your team member loses 2 levels. When the next checkpoint is reached, gain 5 levels for each team member.
-- Killing Blow - Choose a team member. Explode area around enemy when defeated
-- Execute - Choose a team member. That member will defeat any enemies below 20% HP.
-- I C - Gain an X-ray specs. Your team can see invisible traps.
-- Huddle - Defense
-- Alchemy - At the start of each floor, any evo stones or plates has a small chance to convert to a gold nugget
-- Safety Net / Emergency Fund - Gain 1,000 P when a team member faints. Gain a reviver seed
-- Evo: Gain +10 boosts for each evolution
-- Solo Mission - When your team has only 1 member, that member does more damage
-- Hoarder - More money when you have more items in your inventory
-- Fitness Routine - Speed boost when your team has more than 75% hunger (ewwww, better)
-- Full Belly Happy Heart
-- Resilience - Take less damage from super-effective moves
-- Nitroglycerin - Speed boost when low on hunger
-- Choose a character. Super-effective moves deal less damage
-- Bargainer: Half off from shop. I don’t know why, but I feel like giving everything to you half off now
-- Affluent: Calculate the cost of inventory. Do damage based on total. Easier to recruit monsters.
-- Material Investment - Earn interest 5% based on the cost of your inventory at the start of each floor.
-- Ranged: Select a team member. That member gets +1 tange.
-- Underdogs: Your team does more damage when lower leveled than the enemy
-- Treausre Tracker: Gain a trackr. Will reveal buried within 20 tiles
-- Level Up: Choose a team member. That member gains 5 levels.
-- Reroll: For the next enchantment selections. Gain an extra reroll.
-- Flexible: Gain 20,000 P, you will not know what your enchantment will be until you select it.
-- Your next enchantment selection gains an extra reroll.
-- Toll (Scorched): Select a team member. Lose 50 G of your money when the character damage or 50 gold (whichever is higher) Do higher damage based on the toll
-- Pay-to-Win - Pay 3,000 P, you can select another two enchantments afterwards
-- 2 for 1 Special - Gain two random enchantments
-- Tiny, but Mighty - Choose a team member. That member is smaller, but deals more damage.
-- Heavy Hitter - Choose a team member. If that member is weight, but takes more damage
-- Self-Improvment - Gain 1 nectors, 1 ability capsule, 1 recall box, 1 joy seed, 1 citrus 1 protein
-- LotsOfStats
-- Life Orb - Gain a life-orb

-- When you pick up gold - Gain a random state boost.
-- Drain Terrain - Fill gaps - Moves can fill gaps
-- Mission Impossible
-- Limit to only 1 boost except for speed.
-- OneTrick - Choose a team member. That member is permenatly locked into 1 skill for the rest of the dungeon. Deal double damage
-- StandGround - Standing in spot leaves a post which gains an attack boost
-- Trick Shot - Arc projectiles do more damage
-- Vitamins Gummmies -
-- Power of 3s - For every 3 of the same item in inventory, gain a boost
-- Mileage - For every 300 tiles walked, gain a small boost to speed
-- Gain a random vitamin fo
-- Life-Steal+
-- Revival Blessing - Gain a reviver orb.
-- Insurance - Whenever a team member faints, gain 1000 P
-- 3-1 Special - Gain
-- Ranged+: Select a team member. That member gets +1 tange.
-- Marksmen: Choose a team member. That member’s projectiles deal more damage. Mark the target. That target will take additonal damage
-- {
-- "Key": {
-- "str": [
-- 0
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.SpeedPowerEvent, PMDC",
-- "Reverse": false
-- }
-- }
-- ],
-- "OnHits": [
-- {
-- "Key": {
-- "str": [
-- -1
-- ]
-- },
-- "Value": {
-- "$type": "PMDC.Dungeon.DamageFormulaEvent, PMDC"
-- }
-- }
-- Bounty Hunter - After collecting 15 bounties, gain a reward Has to be 2.
-- Level Boost - After each checkpoint, each party memmber gains 3 levels

-- deep boulder quarry


end

function group.Puppeteer(add)
Puppeteer = add({
  rarity = EnchantmentRarity.Common,
  tags = { "party" },
  name = "Puppeteer",
  id = "PUPPETEER",
  description = "Gain a {Apricorn}. Each {Ghost} in the {Party} summons a doll that mirrors a weaker version of itself and targets enemies",
  description_vars = {
    Apricorn = { get = function(self) return M_HELPERS.GetItemName("apricorn_black") end, format = "text" },
    Ghost = { get = function(self) return _DATA:GetElement("ghost"):GetIconName() end, format = "text" },
    Party = { value = "active party", format = "text", color = "Yellow" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local ghost_type = _DATA:GetElement("ghost")
    local icon = ghost_type:GetIconName()

    local count = #GetCharacterOfMatchingType("ghost", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,

  cleanup = function(self)
    RemoveGuestsWithValue(self.id)
  end,

  set_active_effects = function(self, active_effect, zone_context)

    active_effect.OnMapStarts:Add(-20, RogueEssence.Dungeon.SingleCharScriptEvent("RemoveGuestWithIDBackground", Serpent.line({
      ID = self.id,
    })))

    active_effect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("Puppeteer", Serpent.line({
      EnchantmentID = self.id,
      Type = "ghost",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_black",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)
  end
})


-- HideAndSeek = add({
--   name = "Hide and Seek",
--   id = "HIDE_AND_SEEK",
--   get_description = function(self)
--     local ghost_type = _DATA:GetElement("ghost")
--     local purple_apricorn = M_HELPERS.GetItemName("apricorn_purple")
--     return string.format(
--       "Gain a %s. Each %s in the %s summons a doll that mirrors a weaker version of itself and targets enemies",
--       purple_apricorn, ghost_type:GetIconName(), M_HELPERS.MakeColoredText("active party", PMDColor.Yellow))
--   end,
--   offer_time = "beginning",
--   rarity = 1,
--   get_progress_texts = function(self)
--     local ghost_type = _DATA:GetElement("ghost")
--     local icon = ghost_type:GetIconName()

--     local count = #GetCharacterOfMatchingType("ghost", false)

--     return { "Total " .. icon .. " Members: " .. count }
--   end,

--   cleanup = function(self)
--     for i = _DATA.Save.ActiveTeam.Guests.Count - 1, 0, -1 do
--       local guest = GAME:GetPlayerGuestMember(i)
--       local tbl = LTBL(guest)
--       if tbl[self.id] then
--         GAME:RemovePlayerGuest(i)
--       end
--     end
--   end,

--   set_active_effects = function(self, active_effect, zone_context)
--     active_effect.OnMapStarts:Add(-20,
--       RogueEssence.Dungeon.SingleCharScriptEvent("RemoveGuestWithIDBackground", Serpent.line({
--         ID = self.id,
--       })))

--     active_effect.OnMapStarts:Add(-6, RogueEssence.Dungeon.SingleCharScriptEvent("Puppeteer", Serpent.line({
--       EnchantmentID = self.id,
--       Type = "ghost",
--     })))
--   end,

--   apply = function(self)
--     local items = {
--       {
--         Item = "apricorn_purple",
--         Amount = 1
--       }
--     }

--     M_HELPERS.GiveInventoryItemsToPlayer(items)
--   end
-- })


-- Bounty Hunter - Defeat a specific mon, gain 100 P. When you reach 15 bounties recieve a massive reward

-- HideAndSeek - From now, you will be tasked with finding a lost item.

-- From now until the end of the dungeon, until Spawn a random NPC on which will give reward. Spawn a random or two gold nuggets...

-- local mon_id = RogueEssence.Dungeon.MonsterID(mission.Client, 0, "normal",
--   GeneralFunctions.NumToGender(mission.ClientGender))
-- -- set the escort level 20% less than the expected level
-- local level = math.floor(MISSION_GEN.EXPECTED_LEVEL[mission.Zone] * 0.80)
-- local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, level, "", -1)
-- local tactic = _DATA:GetAITactic("stick_together")
-- new_mob.Tactic = RogueEssence.Data.AITactic(tactic);
-- _DATA.Save.ActiveTeam.Guests:Add(new_mob)
-- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("EscortInteract")
-- new_mob.ActionEvents:Add(talk_evt)

-- local tbl = LTBL(new_mob)
-- tbl.Escort = name
-- UI:ResetSpeaker()

-- SightSeeing


-- local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PuppetInteract")
-- clone.ActionEvents:Add(talk_evt)



function RemoveGuestsWithValue(id)
  for i = _DATA.Save.ActiveTeam.Guests.Count - 1, 0, -1 do
    local guest = GAME:GetPlayerGuestMember(i)
    local tbl = LTBL(guest)
    if tbl[id] then
      GAME:RemovePlayerGuest(i)
    end
  end
end

end

return group
