SV.Wishmaker = {
  RecruitedJirachi = false,
  RemoveBonusMoney = false,
  MadeWish = false,
  TempItemString = nil,
  BonusScore = 0
}


function ResetEmberfrostRun()

  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:cleanup()
  end

  SV.EmberFrost.Enchantments.Selected = {}
  SV.EmberFrost.Enchantments.Data = {}
  SV.EmberFrost.Enchantments.RerollCounts = {1, 1, 1}
  SV.EmberFrost.Quests = {
    Active = {},
    Data = {},
  }
  SV.EmberFrost.LastFloor = 0
  SV.EmberFrost.CheckpointProgression = 0
  SV.EmberFrost.ReceivedEnchantmentReminder = false
  SV.EmberFrost.GotEnchantmentFromCheckpoint = false
  SV.EmberFrost.Shopkeeper = {}

  beholder.stopObserving(EMBERFROST_BEHOLDER_GROUPS)
  StopAchievementListeners()
  for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
    local tbl = LTBL(member)
    tbl.EmberfrostRun = false
  end

  for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
    local tbl = LTBL(member)
    tbl.EmberfrostRun = false
  end
end

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

    -- Reminder for getting an enchantment after selecting one for first tane
    GotFirstReminder = false,
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
  ReceivedEnchantmentReminder = false,

  -- Whether we got an enchantment from the checkpoint
  GotEnchantmentFromCheckpoint = false,


  -- Shopkeeper item data, multiplier for items or should it me a multipication on 
  -- "item_id" = 0 (means bought 0 times)
  -- "item_id" = 1 (means bought 1 time)
  -- "item_id" = 2 (means bought 2 times)
  Shopkeeper = {},

  -- Shopkeeper dialogue progression (don't say anything if already more if it's completed)
  -- [1] = true
  -- [2] = true
  -- [3] = false
  -- [4] = false
  ShopkeeperDialogueProgression = {},


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