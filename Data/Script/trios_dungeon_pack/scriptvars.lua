SV.Wishmaker = {
  RecruitedJirachi = false,
  RemoveBonusMoney = false,
  MadeWish = false,
  TempItemString = nil,
  BonusScore = 0
}

SV.EmberFrost = {
  ShouldSwap = false,

  -- List of selected enchantment IDs
  SelectedEnchantments = {},

  -- List of seen enchantment IDs
  SeenEnchantments = {},

  -- For custom enchantment data
  EnchantmentData = {},
  
  RerollCounts = {1, 1, 1},
  GotEnchantmentFromCheckpoint = false
}

SV.SavedCharacters = {}
SV.SavedInventories = {}

SV.TemporaryFlags = {
  OldDirection = nil
}