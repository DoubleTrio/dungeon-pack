require 'trios_dungeon_pack.helpers'

beholder = require 'trios_dungeon_pack.beholder'
function ITEM_SCRIPT.WishItemPickupEvent(owner, ownerChar, context, args)
  if not SV.Wishmaker.MadeWish then
    return
  end
  if context.Item.IsMoney then
    return
  end
  
	SV.Wishmaker.BonusScore = SV.Wishmaker.BonusScore + context.Item:GetSellValue()

  local amount = context.Item.Amount
  if amount == 0 then
    amount = 1
  end
 
  GAME:GivePlayerStorageItem(context.Item.Value, amount)
  while amount > 0 do
    local slot = GAME:FindPlayerItem(context.Item.Value, false, true)
    local index = slot.Slot
    GAME:TakePlayerBagItem(index, false)
    amount = amount - 1
  end
  SV.Wishmaker.TempItemString = context.Item:GetDungeonName()

  -- _DUNGEON:LogMsg("The " .. context.Item:GetDungeonName() .. " was sent to the storage!")
end




function ITEM_SCRIPT.EmberfrostOnPickups(owner, ownerChar, context, args)
  print("EmberfrostOnPickups triggered")
  beholder.trigger("OnPickups", owner, ownerChar, context, args)
end

function SPAWN_SCRIPT.EmberfrostWaterTraveler(owner, ownerChar, context, a, av)
  print("EmberfrostWaterTraveler triggered")
  print(tostring(context))
    print(tostring(owner))

        print(tostring(ownerChar))
end


REFRESH_SCRIPT = {}

function REFRESH_SCRIPT.ShopperRefresh(owner, ownerChar, character, args)
  local rate = args.Rate or 10

  if character == _DUNGEON.ActiveTeam.Leader then
    print("Applying SHOPPER refresh")
    local shop_gen_state = PMDC.Dungeon.ShopModGenState(rate) 
    local misc_event = PMDC.Dungeon.MiscEvent(shop_gen_state)
    misc_event:Apply(owner, ownerChar, character)
  end
end

function REFRESH_SCRIPT.TreasureHunt(owner, ownerChar, character, args)
  local rate = args.Rate or 10

  if character == _DUNGEON.ActiveTeam.Leader then
    local shop_gen_state = PMDC.Dungeon.ChestModGenState(rate)
    local misc_event = PMDC.Dungeon.MiscEvent(shop_gen_state)
    misc_event:Apply(owner, ownerChar, character)
  end
end

function REFRESH_SCRIPT.LooseChange(owner, ownerChar, character, args)
  local rate = args.Rate or 10

  if character == _DUNGEON.ActiveTeam.Leader then
    print("Applying LOOSE_CHANGE refresh")
    local shop_gen_state = PMDC.Dungeon.CoinModGenState(rate)
    local misc_event = PMDC.Dungeon.MiscEvent(shop_gen_state)
    misc_event:Apply(owner, ownerChar, character)
  end
end



    -- [Serializable]
    -- public class CoinModGenState : ModGenState
    -- {
    --     public CoinModGenState() { }
    --     public CoinModGenState(int mod) : base(mod) { }
    --     protected CoinModGenState(CoinModGenState other) : base(other) { }
    --     public override GameplayState Clone() { return new CoinModGenState(this); }
    -- }

    -- [Serializable]
    -- public class StairsModGenState : ModGenState
    -- {
    --     public StairsModGenState() { }
    --     public StairsModGenState(int mod) : base(mod) { }
    --     protected StairsModGenState(StairsModGenState other) : base(other) { }
    --     public override GameplayState Clone() { return new StairsModGenState(this); }
    -- }

    -- [Serializable]
    -- public class ChestModGenState : ModGenState
    -- public class StickyHoldState : CharState
    -- {
    --     public StickyHoldState() { }
    --     public override GameplayState Clone() { return new StickyHoldState(); }
    -- }

    -- [Serializable]
    -- public class AnchorState : CharState
    -- {
    --     public AnchorState() { }
    --     public override GameplayState Clone() { return new AnchorState(); }
    -- }
    -- [Serializable]
    -- public class HitAndRunState : CharState
    -- {
    --     [DataType(0, DataManager.DataType.Item, false)]
    --     public string OriginItem;
    --     public HitAndRunState() { OriginItem = ""; }
    --     public HitAndRunState(string origin) { OriginItem = origin; }
    --     public HitAndRunState(HitAndRunState other) { OriginItem = other.OriginItem; }
    --     public override GameplayState Clone() { return new HitAndRunState(this); }
    -- }

    -- [Serializable]
    -- public class SleepWalkerState : CharState
    -- {
    --     public SleepWalkerState() { }
    --     public override GameplayState Clone() { return new SleepWalkerState(); }
    -- }

    -- [Serializable]
    -- public class ChargeWalkerState : CharState
    -- {
    --     public ChargeWalkerState() { }
    --     public override GameplayState Clone() { return new ChargeWalkerState(); }
    -- }

    -- [Serializable]
    -- public class DrainDamageState : CharState
    -- {
    --     public int Mult;
    --     public DrainDamageState() { }
    --     public DrainDamageState(int mult) { Mult = mult; }
    --     public DrainDamageState(DrainDamageState other) { Mult = other.Mult; }
    --     public override GameplayState Clone() { return new DrainDamageState(this); }
    -- }

    -- [Serializable]
    -- public class NoRecoilState : CharState
    -- {
    --     public NoRecoilState() { }
    --     public override GameplayState Clone() { return new NoRecoilState(); }
    -- }

    -- [Serializable]
    -- public class HeatproofState : CharState
    -- {
    --     public HeatproofState() { }
    --     public override GameplayState Clone() { return new HeatproofState(); }
    -- }

    -- [Serializable]
    -- public class LavaState : CharState
    -- {
    --     public LavaState() { }
    --     public override GameplayState Clone() { return new LavaState(); }
    -- }

    -- [Serializable]
    -- public class PoisonState : CharState
    -- {
    --     public PoisonState() { }
    --     public override GameplayState Clone() { return new PoisonState(); }
    -- }

    -- [Serializable]
    -- public class MagicGuardState : CharState
    -- {
    --     public MagicGuardState() { }
    --     public override GameplayState Clone() { return new MagicGuardState(); }
    -- }

    -- [Serializable]
    -- public class SandState : CharState
    -- {
    --     public SandState() { }
    --     public override GameplayState Clone() { return new SandState(); }
    -- }

    -- [Serializable]
    -- public class HailState : CharState
    -- {
    --     public HailState() { }
    --     public override GameplayState Clone() { return new HailState(); }
    -- }

    -- [Serializable]
    -- public class SnipeState : CharState
    -- {
    --     public SnipeState() { }
    --     public override GameplayState Clone() { return new SnipeState(); }
    -- }

    -- [Serializable]
    -- public class PoisonHealState : CharState
    -- {
    --     public PoisonHealState() { }
    --     public override GameplayState Clone() { return new PoisonHealState(); }
    -- }

    -- [Serializable]
    -- public class HeavyWeightState : CharState
    -- {
    --     public HeavyWeightState() { }
    --     public override GameplayState Clone() { return new HeavyWeightState(); }
    -- }

    -- [Serializable]
    -- public class LightWeightState : CharState
    -- {
    --     public LightWeightState() { }
    --     public override GameplayState Clone() { return new LightWeightState(); }
    -- }

    -- [Serializable]
    -- public class TrapState : CharState
    -- {
    --     public TrapState() { }
    --     public override GameplayState Clone() { return new TrapState(); }
    -- }

    -- [Serializable]
    -- public class GripState : CharState
    -- {
    --     public GripState() { }
    --     public override GameplayState Clone() { return new GripState(); }
    -- }

    -- [Serializable]
    -- public class ExtendWeatherState : CharState
    -- {
    --     public ExtendWeatherState() { }
    --     public override GameplayState Clone() { return new ExtendWeatherState(); }
    -- }

    -- [Serializable]
    -- public class BindState : CharState
    -- {
    --     public BindState() { }
    --     public override GameplayState Clone() { return new BindState(); }
    -- }

    -- [Serializable]
    -- public class GemBoostState : CharState
    -- {
    --     public GemBoostState() { }
    --     public override GameplayState Clone() { return new GemBoostState(); }
    -- }




-- context.Item - The current inventory being used (InvItem)
-- context.Owner - The current ground user that used the item (GroundChar)
-- context.User = The party member that the item is going to apply its effect to (Character)
-- Reimplementation of the GummiEvent (BattleEvent) in PMDC.Dungeon but for ground usage
function GROUND_ITEM_EVENT_SCRIPT.GroundGummiEvent(context, args)
  assert(args.TargetElement ~= nil, "Gummi type needs to be initialized")
  local form_data = context.User.BaseForm
  local form = _DATA:GetMonster(form_data.Species).Forms[form_data.Form]
  local target_element = args.TargetElement
  local sound = ""
  if args.Sound == nil then
    sound = "DUN_Gummi"
  else
    sound = args.Sound
  end

  --what type boosts what stat.
  local gummi_stat = {
    water = RogueEssence.Data.Stat.HP,
    dark = RogueEssence.Data.Stat.HP,
    normal = RogueEssence.Data.Stat.HP,

    ice = RogueEssence.Data.Stat.MDef,
    grass = RogueEssence.Data.Stat.MDef,
    fairy = RogueEssence.Data.Stat.MDef,

    dragon = RogueEssence.Data.Stat.Attack,
    ground = RogueEssence.Data.Stat.Attack,
    fighting = RogueEssence.Data.Stat.Attack,

    psychic = RogueEssence.Data.Stat.MAtk,
    ghost = RogueEssence.Data.Stat.MAtk,
    fire = RogueEssence.Data.Stat.MAtk,

    poison = RogueEssence.Data.Stat.Defense,
    steel = RogueEssence.Data.Stat.Defense,
    rock = RogueEssence.Data.Stat.Defense,

    electric = RogueEssence.Data.Stat.Speed,
    flying = RogueEssence.Data.Stat.Speed,
    bug = RogueEssence.Data.Stat.Speed
  }

  local type_matchup = PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup(target_element, context.User.Element1)
  type_matchup = type_matchup + PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup(target_element, context.User.Element2)
  -- print("Type matchup: " .. tostring(type_matchup) .. " with " .. target_element)
  local heal = 5
  local boosted = false

  UI:ResetSpeaker()
  SOUND:PlayBattleSE(sound)
  if target_element == _DATA.DefaultElement or context.User.Element1 == target_element or context.User.Element2 == target_element then
    --type match
    heal = 20
    boosted = BoostStat(RogueEssence.Data.Stat.HP, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, 2, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, 2, context.User) or boosted
  elseif type_matchup > PMDC.Dungeon.PreTypeEvent.NRM_2 then
    --Super effective
    heal = 10
    --this is a messy way of doing this visually cleanly to the user, but i couldn't come up with something smarter. I guess you could put it all in a table but that's the same shit really.
    local hp_boost = 1
    local atk_boost = 1
    local def_boost = 1
    local spatk_boost = 1
    local spdef_boost = 1
    local speed_boost = 1

    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.HP then hp_boost = 2 end
    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Attack then atk_boost = 2 end
    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Defense then def_boost = 2 end
    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.MAtk then spatk_boost = 2 end
    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.MDef then spdef_boost = 2 end
    if gummi_stat[args.TargetElement] == RogueEssence.Data.Stat.Speed then speed_boost = 2 end

    --print(tostring(hp_boost) .. tostring(atk_boost) .. tostring(def_boost) .. tostring(spatk_boost) .. tostring(spdef_boost) .. tostring(speed_boost))

    boosted = BoostStat(RogueEssence.Data.Stat.HP, hp_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, atk_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, def_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, spatk_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, spdef_boost, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, speed_boost, context.User) or boosted
  elseif type_matchup == PMDC.Dungeon.PreTypeEvent.NRM_2 then
    --neutral
    heal = 10
    boosted = BoostStat(gummi_stat[args.TargetElement], 2, context.User) or boosted
  elseif type_matchup > PMDC.Dungeon.PreTypeEvent.N_E_2 then
    --Not very effective
    heal = 5
    boosted = BoostStat(gummi_stat[args.TargetElement], 1, context.User) or boosted
  else
    --No effect
    heal = 5
  end

  if not boosted then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_NOTHING_HAPPENED"):ToLocal()))
  end

  if args.PrintGummiFillBelly then
    if heal > 15 then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL"):ToLocal(),
        context.User:GetDisplayName(false)))
    elseif heal > 5 then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL_MIN"):ToLocal(),
        context.User:GetDisplayName(false)))
    end
  end

  context.User.Fullness = context.User.Fullness + heal
  if context.User.Fullness >= context.User.MaxFullness then
    context.User.Fullness = context.User.MaxFullness
    context.User.FullnessRemainder = 0
  end

  --print("HP Stat EXP = " .. tostring(context.User.MaxHPBonus))
  --print("Attack Stat EXP = " .. tostring(context.User.AtkBonus))
  --print("Defense Stat EXP = " .. tostring(context.User.DefBonus))
  --print("Sp. Atk Stat EXP = " .. tostring(context.User.MAtkBonus))
  --print("Sp. Def Stat EXP = " .. tostring(context.User.MDefBonus))
  --print("Speed Stat EXP = " .. tostring(context.User.SpeedBonus))
end

function GetMusicSelection()
  print("Melody Box Event")
  local music_selection = {}
  music_selection.music_tbl = {}
  music_selection.music_tbl["Aftermath 2.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Aftermath.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Ambush Forest 2.ogg"] = { "DUN_ambush_forest" }
  music_selection.music_tbl["Ambush Forest 3.ogg"] = { "DUN_ambush_forest" }
  music_selection.music_tbl["Ambush Forest.ogg"] = { "DUN_ambush_forest" }
  music_selection.music_tbl["Base Town.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Boss Battle 2.ogg"] = { "MAIN_01" }
  music_selection.music_tbl["Boss Battle.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Bramble Thicket.ogg"] = { "DUN_bramble_woods" }
  music_selection.music_tbl["Bramble Woods.ogg"] = { "DUN_bramble_woods" }
  music_selection.music_tbl["Canyon Camp.ogg"] = { "MAIN_03" }
  music_selection.music_tbl["Castaway Cave 2.ogg"] = { "DUN_castaway_cave" }
  music_selection.music_tbl["Castaway Cave.ogg"] = { "DUN_castaway_cave" }
  music_selection.music_tbl["Cave Camp.ogg"] = { "MAIN_04" }
  music_selection.music_tbl["Champion Road 2.ogg"] = { "DUN_champions_road", "DUN_guildmaster_trail" }
  music_selection.music_tbl["Champion Road.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Cliff Camp.ogg"] = { "MAIN_02" }
  music_selection.music_tbl["Copper Quarry.ogg"] = { "DUN_copper_quarry" }
  music_selection.music_tbl["Demonstration 2.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Demonstration 3.ogg"] = { "DUN_secret_garden" }
  music_selection.music_tbl["Demonstration.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Depleted Basin.ogg"] = { "DUN_depleted_basin" }
  music_selection.music_tbl["Enraged Caldera.ogg"] = { "DUN_sleeping_caldera" }
  music_selection.music_tbl["Faded Trail.ogg"] = { "DUN_faded_trail" }
  music_selection.music_tbl["Faultline Ridge.ogg"] = { "DUN_faultline_ridge", "DUN_guildmaster_trail" }
  music_selection.music_tbl["Fertile Valley.ogg"] = { "DUN_fertile_valley" }
  music_selection.music_tbl["Final Battle.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Flyaway Cliffs.ogg"] = { "DUN_flyaway_cliffs", "DUN_guildmaster_trail" }
  music_selection.music_tbl["Forsaken Desert.ogg"] = { "DUN_forsaken_desert" }
  music_selection.music_tbl["Glacial Path.ogg"] = { "DUN_snowbound_path", "DUN_guildmaster_trail" }
  music_selection.music_tbl["Guildmaster.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Lava Floe Island Fire.ogg"] = { "DUN_lava_floe_island" }
  music_selection.music_tbl["Lava Floe Island Water.ogg"] = { "DUN_lava_floe_island" }
  music_selection.music_tbl["Luminous Spring.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Magnetic Quarry.ogg"] = { "DUN_copper_quarry" }
  music_selection.music_tbl["Monster House.ogg"] = { "MAIN_04" }
  music_selection.music_tbl["Muddy Valley.ogg"] = { "DUN_fertile_valley", "DUN_sleeping_caldera" }
  music_selection.music_tbl["Mysterious Passage 2.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Mysterious Passage.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Outlaw.ogg"] = { "MAIN_03" }
  music_selection.music_tbl["Overgrown Wilds.ogg"] = { "DUN_overgrown_wilds", "DUN_secret_garden" }
  music_selection.music_tbl["Relic Tower.ogg"] = { "DUN_relic_tower", "DUN_moonlit_courtyard" }
  music_selection.music_tbl["Rescue.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Shop.ogg"] = { "MAIN_03" }
  music_selection.music_tbl["Sickly Hollow 2.ogg"] = { "DUN_sickly_hollow" }
  music_selection.music_tbl["Sickly Hollow.ogg"] = { "DUN_sickly_hollow", "DUN_veiled_ridge" }
  music_selection.music_tbl["Snow Camp.ogg"] = { "MAIN_05" }
  music_selection.music_tbl["Snowbound Path.ogg"] = { "DUN_snowbound_path" }
  music_selection.music_tbl["Summit.ogg"] = { "GUILDMASTER" }
  music_selection.music_tbl["Threat.ogg"] = { "MAIN_04" }
  music_selection.music_tbl["Thunderstruck Pass.ogg"] = { "DUN_thunderstruck_pass" }
  music_selection.music_tbl["Title.ogg"] = { "MAIN_00" }
  music_selection.music_tbl["Treacherous Mountain 2.ogg"] = { "DUN_treacherous_mountain" }
  music_selection.music_tbl["Treacherous Mountain 3.ogg"] = { "DUN_treacherous_mountain" }
  music_selection.music_tbl["Treacherous Mountain.ogg"] = { "DUN_treacherous_mountain" }
  music_selection.music_tbl["Trickster Woods.ogg"] = { "DUN_trickster_woods", "DUN_secret_garden" }
  music_selection.music_tbl["Tropical Path.ogg"] = { "DUN_tropical_path" }
  music_selection.music_tbl["Veiled Ridge.ogg"] = { "DUN_veiled_ridge" }
  music_selection.music_tbl["Wind.ogg"] = { "MAIN_05" }

  local unlocks = {}
  unlocks["MAIN_00"] = true
  if SV.forest_camp.ExpositionComplete then
    unlocks["MAIN_01"] = true
  end
  if SV.cliff_camp.ExpositionComplete then
    unlocks["MAIN_02"] = true
  end
  if SV.canyon_camp.ExpositionComplete then
    unlocks["MAIN_03"] = true
  end
  if SV.rest_stop.ExpositionComplete then
    unlocks["MAIN_04"] = true
  end
  if SV.final_stop.ExpositionComplete then
    unlocks["MAIN_05"] = true
  end
  if SV.guildmaster_summit.GameComplete then
    unlocks["GUILDMASTER"] = true
  end

  zones = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:GetOrderedKeys(false)
  for zone_idx = 0, zones.Count - 1, 1 do
    zone = zones[zone_idx]
    if _DATA.Save:GetDungeonUnlock(zone) == RogueEssence.Data.GameProgress.UnlockState.Completed then
      unlocks["DUN_" .. zone] = true
    end
  end


  
  local spoilers = {}
  for key, unlock_reqs in pairs(music_selection.music_tbl) do
    contains_unlock = false
    for ii = 1, #unlock_reqs, 1 do
      if unlocks[unlock_reqs[ii]] == true then
        contains_unlock = true
      end
    end
    if not contains_unlock then
      table.insert(spoilers, key)
    end
  end


  UI:ShowMusicMenu(false, spoilers)
  UI:WaitForChoice()
  local result = UI:ChoiceResult()
  return result
end

function GROUND_ITEM_EVENT_SCRIPT.MelodyBoxEvent(context, args)
  context.CancelState.Cancel = true
  local result = GetMusicSelection()
  print(result)
  if result == "" or result == nil then
    result = _ZONE.CurrentGround.Music  
  end
  SOUND:PlayBGM(result, true)

  -- if SOUND:GetCurrentSong() ~= SV.base_town.Song then
  --   SOUND:PlayBGM(SV.base_town.Song, true)
  -- end
  -- UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Music_End']))
end
function GROUND_ITEM_EVENT_SCRIPT.GroundWonderGummiEvent(context, args)
  -- { Heal = 20, Msg = true, Change = 2, BoostedStat = "none" }
  GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)
end

-- Reimplementation of the RestoreBellyEvent (BattleEvent) in PMDC.Dungeon but for ground usage
function GROUND_ITEM_EVENT_SCRIPT.GroundRestoreBellyEvent(context, args)
  local MIN_MAX_FULLNESS = 50;
  local MAX_MAX_FULLNESS = 150;

  local heal = args.Heal
  local msg = args.Msg
  local add_max_belly = args.AddMaxBelly
  local need_full_belly = args.NeedFullBelly

  if add_max_belly == nil then add_max_belly = 0 end

  local full_belly = context.User.Fullness == context.User.MaxFullness

  context.User.Fullness = context.User.Fullness + heal

  if heal < 0 then
    if msg then
      if context.User.Fullness <= 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_EMPTY"):ToLocal(),
          context.User:GetDisplayName(true)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_DROP"):ToLocal(),
          context.User:GetDisplayName(false)))
      end
    end
    --SOUND:PlayBattleSE("DUN_Hunger")
  else
    if msg then
      UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_HUNGER_FILL"):ToLocal(),
        context.User:GetDisplayName(false)))
    end
  end

  if add_max_belly ~= 0 and (full_belly or not need_full_belly) then
    if msg then
      if add_max_belly < 0 then
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_DROP"):ToLocal(),
          context.User:GetDisplayName(false)))
      else
        UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_MAX_HUNGER_BOOST"):ToLocal(),
          context.User:GetDisplayName(false)))
      end
    end

    context.User.MaxFullness = context.User.MaxFullness + add_max_belly
    if context.User.MaxFullness < MIN_MAX_FULLNESS then
      context.User.MaxFullness = MIN_MAX_FULLNESS
    end

    if context.User.MaxFullness > MAX_MAX_FULLNESS then
      context.User.MaxFullness = MAX_MAX_FULLNESS
    end
  end

  if context.User.Fullness < 0 then
    context.User.Fullness = 0
  end

  if context.User.Fullness >= context.User.MaxFullness then
    context.User.Fullness = context.User.MaxFullness
    context.User.FullnessRemainder = 0
  end
end

function GROUND_ITEM_EVENT_SCRIPT.GroundVitaminEvent(context, args)
  local lookup_table = {}

  lookup_table["hp"] = RogueEssence.Data.Stat.HP
  lookup_table["attack"] = RogueEssence.Data.Stat.Attack
  lookup_table["defense"] = RogueEssence.Data.Stat.Defense
  lookup_table["special_attack"] = RogueEssence.Data.Stat.MAtk
  lookup_table["special_defense"] = RogueEssence.Data.Stat.MDef
  lookup_table["speed"] = RogueEssence.Data.Stat.Speed
  lookup_table["none"] = RogueEssence.Data.Stat.None

  assert(lookup_table[args.BoostedStat] ~= nil, "Stat type needs to be initialized")
  assert(args.Change ~= nil, "Change amount needs to be initialized")
  local sound = ""
  if args.Sound == nil then
    sound = "DUN_Drink"
  else
    sound = args.Sound
  end

  local boosted = false
  local boosted_stat = lookup_table[args.BoostedStat]
  local change = args.Change

  UI:ResetSpeaker()
  SOUND:PlayBattleSE(sound)
  if boosted_stat ~= RogueEssence.Data.Stat.None then
    boosted = boosted or BoostStat(boosted_stat, change, context.User)
  else
    boosted = BoostStat(RogueEssence.Data.Stat.HP, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Attack, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Defense, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MAtk, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.MDef, change, context.User) or boosted
    boosted = BoostStat(RogueEssence.Data.Stat.Speed, change, context.User) or boosted
  end

  if not boosted then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_NOTHING_HAPPENED"):ToLocal()))
  end

  --print("HP Stat EXP = " .. tostring(context.User.MaxHPBonus))
  --print("Attack Stat EXP = " .. tostring(context.User.AtkBonus))
  --print("Defense Stat EXP = " .. tostring(context.User.DefBonus))
  --print("Sp. Atk Stat EXP = " .. tostring(context.User.MAtkBonus))
  --print("Sp. Def Stat EXP = " .. tostring(context.User.MDefBonus))
  --print("Speed Stat EXP = " .. tostring(context.User.SpeedBonus))
end

function BoostStat(stat, change, target)
  local prev_stat = 0
  local new_stat = 0

  local lookup_table = {}

  lookup_table[RogueEssence.Data.Stat.HP] = function()
    prev_stat = target.MaxHP
    target.MaxHPBonus = math.min(target.MaxHPBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --if the boost given is not enough to get a visual stat point, keep boosting until it is.
    --while (target.MaxHP == prev_stat and target.MaxHPBonus <  PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MaxHPBonus = target.MaxHPBonus + 1
    --end
    target.HP = target.MaxHP
    new_stat = target.MaxHP
  end

  lookup_table[RogueEssence.Data.Stat.Attack] = function()
    prev_stat = target.BaseAtk
    target.AtkBonus = math.min(target.AtkBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseAtk == prev_stat and target.AtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.AtkBonus = target.AtkBonus + 1
    --end
    new_stat = target.BaseAtk
  end

  lookup_table[RogueEssence.Data.Stat.Defense] = function()
    prev_stat = target.BaseDef
    target.DefBonus = math.min(target.DefBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseDef == prev_stat and target.DefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.DefBonus = target.DefBonus + 1
    --end
    new_stat = target.BaseDef
  end

  lookup_table[RogueEssence.Data.Stat.MAtk] = function()
    prev_stat = target.BaseMAtk
    target.MAtkBonus = math.min(target.MAtkBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseMAtk == prev_stat and target.MAtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MAtkBonus = target.MAtkBonus + 1
    --end
    new_stat = target.BaseMAtk
  end

  lookup_table[RogueEssence.Data.Stat.MDef] = function()
    prev_stat = target.BaseMDef
    target.MDefBonus = math.min(target.MDefBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseMDef == prev_stat and target.MDefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.MDefBonus = target.MDefBonus + 1
    --end
    new_stat = target.BaseMDef
  end

  lookup_table[RogueEssence.Data.Stat.Speed] = function()
    prev_stat = target.BaseSpeed
    target.SpeedBonus = math.min(target.SpeedBonus + change, PMDC.Data.MonsterFormData.MAX_STAT_BOOST)
    --while (target.BaseSpeed == prev_stat and target.SpeedBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST) do
    --  target.SpeedBonus = target.SpeedBonus + 1
    --end
    new_stat = target.BaseSpeed
  end

  lookup_table[stat]()

  if new_stat > prev_stat then
    local message = RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_STAT_BOOST"):ToLocal(),
      target:GetDisplayName(false), RogueEssence.Text.ToLocal(stat), tostring(new_stat - prev_stat))

    if RogueEssence.GameManager.Instance.CurrentScene == RogueEssence.Dungeon.DungeonScene.Instance then
      _DUNGEON:LogMsg(message)
    else
      UI:WaitShowDialogue(message)
    end

    return true
  else
    return false
  end
end

function AddStat(stat, context)
  local prev_stat = 0
  local new_stat = 0
  local lookup_table = {}
  lookup_table[RogueEssence.Data.Stat.HP] = function()
    if context.User.MaxHPBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.MaxHP
      context.User.MaxHPBonus = context.User.MaxHPBonus + 1
      context.User.HP = context.User.MaxHP
      new_stat = context.User.MaxHP
    end
  end

  lookup_table[RogueEssence.Data.Stat.Attack] = function()
    if context.User.AtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseAtk
      context.User.AtkBonus = context.User.AtkBonus + 1
      new_stat = context.User.BaseAtk
    end
  end

  lookup_table[RogueEssence.Data.Stat.Defense] = function()
    if context.User.DefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseDef
      context.User.DefBonus = context.User.DefBonus + 1
      new_stat = context.User.BaseDef
    end
  end

  lookup_table[RogueEssence.Data.Stat.MAtk] = function()
    if context.User.MAtkBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.MAtkBonus
      context.User.MAtkBonus = context.User.MAtkBonus + 1
      new_stat = context.User.MAtkBonus
    end
  end

  lookup_table[RogueEssence.Data.Stat.MDef] = function()
    if context.User.MDefBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseMDef
      context.User.MDefBonus = context.User.MDefBonus + 1
      new_stat = context.User.BaseMDef
    end
  end

  lookup_table[RogueEssence.Data.Stat.Speed] = function()
    if context.User.SpeedBonus < PMDC.Data.MonsterFormData.MAX_STAT_BOOST then
      prev_stat = context.User.BaseSpeed
      context.User.SpeedBonus = context.User.SpeedBonus + 1
      new_stat = context.User.BaseSpeed
    end
  end

  lookup_table[stat]()
  if new_stat - prev_stat > 0 then
    UI:WaitShowDialogue(RogueEssence.Text.FormatGrammar(RogueEssence.StringKey("MSG_STAT_BOOST"):ToLocal(),
      context.User:GetDisplayName(false), RogueEssence.Text.ToLocal(stat), tostring(new_stat - prev_stat)))
  end
end
