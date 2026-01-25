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

      -- "EXIT_STRATEGY" = 0 -- Not seen
      -- "EXIT_STRATEGY" = 1 -- Seen but not selected
      -- "EXIT_STRATEGY" = 2 -- Selected but not won yet
      -- "EXIT_STRATEGY" = 3 -- Won out

    -- Reroll counts for enchantments
    RerollCounts = {1, 1, 1},
  },

  Quests = {
    -- List of active quests for the task maste enchantment
    Active = {},
    Data = {},
  },

  GotEnchantmentFromCheckpoint = false
}

SV.SavedCharacters = {}
SV.SavedInventories = {}

SV.TemporaryFlags = {
  OldDirection = nil
}