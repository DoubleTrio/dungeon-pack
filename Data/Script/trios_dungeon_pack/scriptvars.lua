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
    -- List of active quests for the task master enchantment
    Active = {},
    Data = {},
  },

  -- The last floor we were at in Emberfrost
  LastFloor = 0,

  -- The checkpoint progression we were at in Emberfrost
  -- 1 corresponds to the one after completing 5F
  -- 2 corresponds to the one after completing 10F
  -- 3 corresponds to the one after completing 15F
  -- etc
  CheckpointProgression = 0,

  -- Whether the dungeon was cleared
  Completed = false,

  -- Recieve a reminder about the enchantment collection and where to view it
  ReceivedEnchantmentReminder = true,

  -- Whether we got an enchantment from the checkpoint
  GotEnchantmentFromCheckpoint = false,
}

SV.SavedCharacters = {}
SV.SavedInventories = {}

SV.TemporaryFlags = {
  OldDirection = nil
}