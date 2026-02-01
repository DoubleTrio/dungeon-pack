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
