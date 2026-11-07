local EnchantmentRarity = require 'trios_dungeon_pack.terrasphere.enchantments.rarities'
local descriptions = require 'trios_dungeon_pack.terrasphere.descriptions'
local group = {}

function group.HandsTied(add)
HandsTied = add({
  rarity = EnchantmentRarity.Common,
  tags = { "combat" },
  gold_amount = 10000,
  name = "Hands Tied",
  id = "HANDS_TIED",
  description = "Gain {gold_amount}. The team cannot use {Items} until the next checkpoint",
  description_vars = {
    gold_amount = { field = "gold_amount", format = "money", space = true },
    Items = { value = "items", format = "text", color = "SkyBlue" },
  },

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(2,
      RogueEssence.Dungeon.SingleCharScriptEvent("AddEnchantmentStatus", Serpent.line({
        StatusID = "terrasphere_embargo",
        EnchantmentID = self.id,
        ApplyToAll = true
      })))
  end,
  offer_time = "beginning",
  apply = function(self)
    UI:SetCenter(true)
    SOUND:PlayFanfare("Fanfare/Note")
    UI:WaitShowDialogue(string.format("Note: Your team cannot use %s until the next checkpoint.",
      M_HELPERS.MakeColoredText("items", PMDColor.SkyBlue)))
    UI:SetCenter(false)
  end
})

end

function group.Tempo(add)
Tempo = add({
  rarity = EnchantmentRarity.Common,
  tags = { "combat" },
  name = "Tempo",
  id = "TEMPO",
  count = 1,
  description = "For every {Count} {Count:plural:enemy:enemies} defeated, your team gains a random stat boost",
  description_vars = {
    Count = { field = "count", format = "number" },
  },
  keywords = { "ACTIVE_PARTY" },

  get_progress_texts = function(self)
    return {
      string.format("Enemies Defeated: %s/%s",
        descriptions.Number(EnchantmentRegistry:GetData(self)["defeated_enemies"] or 0),
        descriptions.Number(self.count))
    }
  end,


  set_active_effects = function(self, active_effect, zone_context)
    local data = EnchantmentRegistry:GetData(self)
    data["defeated_enemies"] = data["defeated_enemies"] or 0

    beholder.group(TERRASPHERE_BEHOLDER_GROUPS, function()
      local on_turn_ends_id = beholder.observe("OnTurnEnds", function(owner, ownerChar, context, args)
        local data = EnchantmentRegistry:GetData(self)
        if data["defeated_enemies"] >= self.count then
          data["defeated_enemies"] = data["defeated_enemies"] % self.count

          local stat = GetRandomFromArray(STATS)
          local stat_text = RogueEssence.Text.ToLocal(stat)

          _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(
            "All members in the active party gained [a/an] {0} stat boost!",
            stat_text)
          )

          for member in luanet.each(_DUNGEON.ActiveTeam.Players) do
            BoostStat(stat, 1, member)
          end
        end
      end)

      local on_death_id = beholder.observe("OnDeath", function(owner, ownerChar, context, args)
        local team = context.User.MemberTeam
        if (team ~= nil and team.MapFaction == RogueEssence.Dungeon.Faction.Foe) then
          local data = EnchantmentRegistry:GetData(self)


          data["defeated_enemies"] = data["defeated_enemies"] + 1
        end
      end)

    end)




  end,
  offer_time = "beginning",
  apply = function(self)

  end
})

end

function group.Rationalize(add)
Rationalize = add({
  rarity = EnchantmentRarity.Common,
  tags = { "combat" },
  name = "Rationalize",
  id = "RATIONALIZE",

  description = "Gain a {Apricorn}. {Normal} types in your team will have their {Normal} moves be super effective against {Fairy}, {Ghost}, and {Dragon} types",
  description_vars = {
    Apricorn = { get = function(self) return M_HELPERS.GetItemName("apricorn_white") end, format = "text" },
    Normal = { get = function(self) return _DATA:GetElement("normal"):GetIconName() end, format = "text" },
    Fairy = { get = function(self) return _DATA:GetElement("fairy"):GetIconName() end, format = "text" },
    Ghost = { get = function(self) return _DATA:GetElement("ghost"):GetIconName() end, format = "text" },
    Dragon = { get = function(self) return _DATA:GetElement("dragon"):GetIconName() end, format = "text" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    local normal_type = _DATA:GetElement("normal")
    local icon = normal_type:GetIconName()

    local count = #GetCharacterOfMatchingType("normal", false)

    return { "Total " .. icon .. " Members: " .. count }
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(5, RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches", Serpent.line({
      Types = { "normal" },
      StatusID = "terrasphere_rationalize",
    })))
  end,

  apply = function(self)
    local items = {
      {
        Item = "apricorn_white",
        Amount = 1
      }
    }

    M_HELPERS.GiveInventoryItemsToPlayer(items)

  end
})

end

function group.DraconianDefience(add)
DraconianDefience = add({
  rarity = EnchantmentRarity.Common,
  tags = { "combat" },
  name = "Draconian Defience",
  id = "DRACONIAN_DEFICIENCE",
  description = "Gain a {Apricorn}. {Dragon} types in your team deal more damage the lower HP they are",
  description_vars = {
    Apricorn = { get = function(self) return M_HELPERS.GetItemName("apricorn_red") end, format = "text" },
    Dragon = { get = function(self) return _DATA:GetElement("dragon"):GetIconName() end, format = "text" },
  },
  offer_time = "beginning",
  get_progress_texts = function(self)
    return {}
  end,

  set_active_effects = function(self, active_effect, zone_context)
    active_effect.OnMapStarts:Add(5,

      RogueEssence.Dungeon.SingleCharScriptEvent("ApplyStatusIfTypeMatches", Serpent.line({
        Types = { "dragon" },
        StatusID = "terrasphere_draconian_defience",
      })))
  end,
  --   local chance = self.chance
  --   beholder.observe("OnHits", function(owner, ownerChar, context, args)
  --     local user = context.User
  --     local target = context.Target



  --     if context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Physical and
  --         context.Data.Category ~= RogueEssence.Data.BattleData.SkillCategory.Magical then
  --       return
  --     end


  --     if user.MemberTeam ~= _DUNGEON.ActiveTeam then
  --       return
  --     end

  --     if user.Element1 ~= "bug" and user.Element2 ~= "bug" then
  --       return
  --     end

  --     local roll = _DATA.Save.Rand:Next(100)
  --     if roll >= chance then
  --       return
  --     end


  --     if target == nil then
  --       return
  --     end

  --     local status = RogueEssence.Dungeon.StatusEffect("infestation")

  --     status:LoadFromData()
  --     TASK:WaitTask(target:AddStatusEffect(nil, status, true))
  --   end)
  -- end,
  apply = function(self)
  end
})


-- Blaze Tile - Will burn the user, but will double their speed. (max 2 stack) 
-- Fire Tile - Take fire damage but raise attack
-- Ice Title - Freeze chracter, but grant, users on these tiles will be granted +2 range on thei rmoves
-- Haze tile
-- Evolved - Mons that evolved gain +5 stat boosts
-- Targets with two tiles of the will have their attack reduced by 20% (Dark) - Malevolence - Apply a random debuff for any enemies within two tiles
-- fired Up -- 

-- Electric -- Overflow/Overcharge damage will be carried over to the next target - from base elctric damage (1 transfer) - Overcharge
-- Water Purification - Heal Passively hea teammates
-- Combat Flow - Every third attack of fighting mons will do increased damage and critical hit
-- Flock - Flying types will reduce damage of nearby floating allies. Allies nearby can traverse
-- Ground
-- Rock -- Geopebbles and gravlerrocks. 
-- Steel  -- Steel- “conduction- when hit by fire moves all defenses raise by 1 stage & reduce damage by 25%.
-- Iron Will : steel-type moves will utilize the user's defense stat to determine power
-- Ignition: the Pokemon's speed is boosted when inflicted with a burn
-- Fairy -
-- Cruel Kindness – Fairy-type moves heal allies for a portion of the damage dealt.
-- Fairy -
--  Conductor- The Pokémon's Attack and Special Attack stats get boosted if hit by an Electric-Type move.

-- polished metal
-- gives a plus 1 evasiveness boost for steel types.

--  Poison: Intoxication/Noxious Cloud/Toxic Boost/Contamination - Prevent\\ 

-- Toxic Touch: When the user attacks, the target is inflicted with a stacking “contamination” debuff that spreads to nearby enemies after a turn.

-- Chain Infection: Any status effect the user receives (burn, poison, etc.) also spreads to a random enemy at the end of the turn.

-- Virulent / Noxious Aura: At the start of each turn, all enemies have a small chance to be poisoned, paralyzed, or weakened. All poison-type hav

-- -- Normal: Extraordinaire/Power Boost/Amplifier/Complexity

-- Electric: Battery Charger/Electrify/Juicer/High Capacity/

-- Fighting: Prideful/Fighting Spirit/Combo - Raise the attack str for each 

-- Fairy: Uplifting Spirit/Wish Granter/Spirit’s Gift/Trickery

-- Dark: Corruption/Nightmare Fuel/Darkest Hour//Negative Aura
-- 
-- Flying: Strong Wings/Rising Phoenix/Shedded Feathers/Flocking/Air Ride (can guide other types across terrains), Turbulence, Flock - Each flying type reduces damage of nearby allies

-- Quick Charge: Moves that take 2 turns to use now only require 1, but require 1 extra PP.
-- Ghost: Possession/Haunted/Spirit Riser/After Dusk/Conjure - 



-- Rock: Hardheaded/Compression

-- Dungeon Unboxing --- open all boxes inside your inventory
-- Ground: Tectonic strength/Earth Rising/Aftershock, Quicksands -  

end

return group
