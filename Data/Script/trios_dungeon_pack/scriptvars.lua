SV.Wishmaker = {
  RecruitedJirachi = false,
  RemoveBonusMoney = false,
  MadeWish = false,
  TempItemString = nil,
  BonusScore = 0
}

SV.EmberFrost = {
  Enchantments = {
    -- List of seen enchantment IDs during the run
    Seen = {},

    -- List of selected enchantment IDs during the run
    Selected = {},

    -- For saved custom enchantment data during the run
    Data = {},

    -- List of enchantments to view
    Collection = {},

    -- Reroll counts for enchantments
    RerollCounts = {1, 1, 1},
  },

  Quests = {
    -- List of active quests for the task maste enchantment
    Active = {},
    Data = {},
  },

  -- The last floor we were at in Emberfrost
  LastFloor = 0,

  GotEnchantmentFromCheckpoint = false
}

SV.SavedCharacters = {}
SV.SavedInventories = {}

SV.TemporaryFlags = {
  OldDirection = nil
}