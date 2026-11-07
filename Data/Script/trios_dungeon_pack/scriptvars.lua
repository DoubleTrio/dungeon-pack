SV.Wishmaker = {
  RecruitedJirachi = false,
  RemoveBonusMoney = false,
  MadeWish = false,
  TempItemString = nil,
  BonusScore = 0
}


function ResetTerrasphereRun()

  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:cleanup()
  end

  SV.Terrasphere.CheckpointEnchantmentOffers = {Checkpoint = -1, Player = {}, Enemy = {}}
  SV.Terrasphere.CheckpointEnchantsCalled = false
  SV.Terrasphere.Enchantments.Selected = {}
  SV.Terrasphere.Enchantments.Data = {}
  SV.Terrasphere.Enchantments.RerollCounts = {1, 1, 1}
  if EnemyEnchantmentRegistry then
    for _, enchant in ipairs(EnemyEnchantmentRegistry:GetSelected()) do enchant:cleanup() end
  end
  SV.Terrasphere.EnemyEnchantments = {
    Collection = SV.Terrasphere.EnemyEnchantments.Collection,
    Seen = {},
    Selected = {},
    Data = {},
    RerollCounts = {1, 1, 1},
    Offers = {},
    OfferCheckpoint = -1,
    SelectedCheckpoints = {},
  }
  SV.Terrasphere.Quests = {
    Active = {},
    Data = {},
  }
  SV.Terrasphere.LastFloor = 0
  SV.Terrasphere.CheckpointProgression = 0
  SV.Terrasphere.ReceivedEnchantmentReminder = false
  SV.Terrasphere.GotEnchantmentFromCheckpoint = false
  SV.Terrasphere.Shopkeeper = {}

  beholder.stopObserving(TERRASPHERE_BEHOLDER_GROUPS)
  StopAchievementListeners()
  for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
    local tbl = LTBL(member)
    tbl.TerrasphereRun = false
  end

  for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
    local tbl = LTBL(member)
    tbl.TerrasphereRun = false
  end
end

SV.Terrasphere = {
  CheckpointEnchantmentOffers = {Checkpoint = -1, Player = {}, Enemy = {}},
  EnemyEnchantments = {
    Collection = {},
    Seen = {},
    Selected = {},
    Data = {},
    RerollCounts = {1, 1, 1},
    Offers = {},
    OfferCheckpoint = -1,
    SelectedCheckpoints = {},
  },
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

    -- Reminder for getting an enchantment after selecting one for first tane
    GotFirstReminder = false,
  },

  Quests = {
    -- List of active quests for the task master enchantment
    Active = {},
    Data = {},
  },

  -- The last floor we were at in Terrasphere
  LastFloor = 0,

  -- The checkpoint progression we were at in Terrasphere
  -- 1 corresponds to the one after completing 5F
  -- 2 corresponds to the one after completing 10F
  -- 3 corresponds to the one after completing 15F
  -- etc
  CheckpointProgression = 0,

  -- Whether the dungeon is introduced to the player at Base Camp
  OshawottIntroduction = false,

  -- Whether the dungeon was cleared
  Completed = false,

  -- Recieve a reminder about the enchantment collection and where to view it
  ReceivedEnchantmentReminder = false,

  -- Whether we got an enchantment from the checkpoint
  GotEnchantmentFromCheckpoint = false,

  -- Whether the checkpoint method was called on each already upon arrival (only call the checkpoint function once!)
  CheckpointEnchantsCalled = false,

  -- Used to remind the player that they cannot save during ground because of bug
  ReceivedCannotSaveOnGroundModeReminder = false,


  -- Shopkeeper item data 
  -- Formatted like { Item = string, Amount = int, Cost = int }
  Shopkeeper = {},

  -- Shopkeeper dialogue progression (don't say anything if the flag is already set)
  -- [1] = true
  -- [2] = true
  -- [3] = false
  -- [4] = false
  ShopkeeperDialogueProgression = {

  },

  GotMelodyBox = false,

  -- List of achievement IDs that are completed
  Achievements = {

    -- AchievementStatus = {
    --   Hidden   = 0,
    --   Visible  = 1,
    --   Achieved = 2
    -- }
    -- List of achievement IDs with the status
    Statuses = {
      -- like Completed[<achievement_id>] = AchievementStatus.Hidden
    },
    

    -- List of achievement IDs that was completed during the run and can be displayed
    ToDisplay = {},
    
  },

  -- Reseted with every new segment
  MelodyBox = {
    DungeonMusicSelection = "",
    LastDungeonMusic = ""
  }

}

SV.SavedCharacters = {}
SV.SavedInventories = {}

SV.TemporaryFlags = {
  OldDirection = nil
}