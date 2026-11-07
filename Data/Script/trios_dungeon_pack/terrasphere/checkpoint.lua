
require 'trios_dungeon_pack.menu.EnchantmentSelectionMenu'
local checkpoint_offers = require 'trios_dungeon_pack.terrasphere.checkpoint_offers'
local enemy_enchantment_offers = require 'trios_dungeon_pack.terrasphere.enemy_enchantments.offers'

require 'trios_dungeon_pack.terrasphere.enchantments.enchants'
require 'trios_dungeon_pack.terrasphere.enchantments.type_enchantments'
require 'trios_dungeon_pack.terrasphere.enchantments.character_enchantments'

require 'trios_dungeon_pack.beholder'

require 'trios_dungeon_pack.menu.ItemShopMenu'
require 'origin.menu.InventorySelectMenu'

function PlayRandomBGM(tracks)
  tracks = tracks or {
    -- "The Wind is Blowing at Cavi Cape.ogg",
    -- "Obsidian Fieldlands 2.ogg",
    "Vast Poni Canyon.ogg",
    -- "Rock Slide Canyon.ogg",
    -- "Resolution Gorge.ogg",
    -- "Wishmaker Depths.ogg",
    "Ruins of Life.ogg"
  }

  local music = tracks[math.random(#tracks)]
  SOUND:PlayBGM(music, true)
end




-- function base_camp_2.Init(map)
--   DEBUG.EnableDbgCoro() --Enable debugging this coroutine
--   PrintInfo("=>> Init_base_camp_2")

--   GROUND:RefreshPlayer()

--   if GAME:GetCurrentGround():GetObj("Storage") == nil then
--     local storage = RogueEssence.Ground.GroundObject(
--       RogueEssence.Content.ObjAnimData("Storage", 1, -1, -1, 255, RogueElements.Dir8.None), -- byte 255
--       RogueElements.Dir8.Down,
--       RogueElements.Rect(RogueElements.Loc(296, 536), RogueElements.Loc(24)),
--       RogueElements.Loc(4, 8),
--       RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.Action,
--       false,
--       "Storage"
--     )
--     storage:ReloadEvents()
--     GAME:GetCurrentGround():AddObject(storage)
--   end
-- end

-- function base_camp_2.Storage_Action(obj, activator)
--   DEBUG.EnableDbgCoro() --Enable debugging this coroutine

--   COMMON:ShowTeamStorageMenu()
-- end

local checkpoint = {}

-- Disable after testing to restore random enemy offers and one selection per checkpoint.
local ENEMY_ENCHANTMENT_TESTING = true

function checkpoint.EnsureGroundObject(name, x, y, width, height, options)
  options = options or {}
  local map = GAME:GetCurrentGround()
  local obj = map:GetObj(name)
  if obj == nil then
    obj = RogueEssence.Ground.GroundObject(
      RogueEssence.Content.ObjAnimData(options.animation or "", 1, -1, -1, 255, RogueElements.Dir8.None),
      RogueElements.Dir8.Down,
      RogueElements.Rect(RogueElements.Loc(x, y), RogueElements.Loc(width, height)),
      RogueElements.Loc(0, 0),
      options.trigger or RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.None,
      options.passable == true,
      name
    )
    map:AddObject(obj)
  end
  obj:ReloadEvents()
  return obj
end

function checkpoint.SpawnCheckpointWalls()
  checkpoint.EnsureGroundObject("BlackWall", 192, 110, 24, 24,
    {animation = "Block_Blank_Black", passable = true})
  checkpoint.EnsureGroundObject("BlackWall_1", 240, 110, 24, 24,
    {animation = "Block_Blank_Black", passable = true})
  checkpoint.EnsureGroundObject("BlackVaultWall", 216, 110, 24, 24,
    {animation = "Block_Vault_Black", passable = true})
  checkpoint.EnsureGroundObject("EnemyInvisWall", 192, 123, 72, 10,
    {passable = false, trigger = RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.Action})

  if ENEMY_ENCHANTMENT_TESTING then
    local map = GAME:GetCurrentGround()
    for _, name in ipairs({"BlackWall", "BlackWall_1", "BlackVaultWall", "EnemyInvisWall"}) do
      map:GetObj(name).EntEnabled = true
    end
    local blocker = map:GetObj("EnemyInvisWall")
    blocker.Passable = false
    blocker:SetTriggerType(RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.Action)
    local state = SV.Terrasphere.EnemyEnchantments
    state.Seen = {}
    state.RerollCounts = {1, 1, 1}
    state.Offers = {}
    state.OfferCheckpoint = -1
    state.SelectedCheckpoints[tostring(SV.Terrasphere.CheckpointProgression)] = nil
  end
end

function checkpoint.SelectEnemyEnchantment()
  M_HELPERS.UpgradeVariables()
  local state = SV.Terrasphere.EnemyEnchantments
  local key = tostring(SV.Terrasphere.CheckpointProgression)
  if state.SelectedCheckpoints[key] then return true end
  local rows
  if ENEMY_ENCHANTMENT_TESTING then
    rows = {
      {EnemyEnchantmentRegistry:Get("HUNGER_STRIKE_ENEMY"), EnemyEnchantmentRegistry:Get("HAZER_ENEMY"), EnemyEnchantmentRegistry:Get("ENEMY_TEST_3")},
      {EnemyEnchantmentRegistry:Get("ENEMY_TEST_4"), EnemyEnchantmentRegistry:Get("ENEMY_TEST_5"), EnemyEnchantmentRegistry:Get("ENEMY_TEST_6")},
    }
  else
    rows = enemy_enchantment_offers.GetForCheckpoint()
  end
  if not rows then
    UI:WaitShowDialogue("There are not enough eligible enemy enchantments available right now.")
    return false
  end
  local selected
  local choose = function(enchantment)
    selected = enchantment
    _MENU:RemoveMenu()
  end
  local refuse = function() _MENU:RemoveMenu() end
  local old = RogueEssence.Menu.MenuBase.BorderStyle
  RogueEssence.Menu.MenuBase.BorderStyle = 17
  local menu = EnchantmentSelectionMenu:new("Select enemy enchantment...", rows,
    function(id)
      EnemyEnchantmentRegistry:MarkSeen(id)
      state.Collection[id] = math.max(state.Collection[id] or EnchantmentStatus.NotSeen, EnchantmentStatus.Seen)
    end, nil, nil,
    state.RerollCounts, choose, refuse, nil, PMDColor.BrightBlue)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
  RogueEssence.Menu.MenuBase.BorderStyle = old
  if not selected then return false end
  selected:apply()
  table.insert(state.Selected, selected.id)
  state.Collection[selected.id] = math.max(state.Collection[selected.id] or EnchantmentStatus.NotSeen, EnchantmentStatus.Selected)
  state.SelectedCheckpoints[key] = selected.id
  return true
end

function checkpoint.InvisibleWallInteraction(obj, activator)
  local triggers = RogueEssence.Ground.GroundEntity.EEntityTriggerTypes
  if not obj.EntEnabled or obj:GetTriggerType() ~= triggers.Action then return end
  
  local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")

  crystal_moment_status:LoadFromData()
  crystal_moment_status.Emitter.Layer = DrawLayer.Top

  _GROUND:AddMapStatus(crystal_moment_status)

  GAME:WaitFrames(50)
  if not checkpoint.SelectEnemyEnchantment() 
  then
    
    _GROUND:RemoveMapStatus("crystal_moment")
    GAME:WaitFrames(20)

    
    return

  end

  _GROUND:RemoveMapStatus("crystal_moment")
  GAME:WaitFrames(20)

  SOUND:PlayBattleSE("DUN_Open_Chamber")
  obj:SetTriggerType(triggers.None)

  local map = GAME:GetCurrentGround()
  for _, name in ipairs({"BlackWall", "BlackVaultWall", "BlackWall_1"}) do
    local wall = map:GetObj(name)
    if wall and wall.EntEnabled then
      local animation = name == "BlackVaultWall" and "Block_Vault_Black_Open" or "Block_Blank_Black_Open"
      local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData(animation, 3))
      local bounds = wall.Collider
      wall.EntEnabled = false
      GROUND:PlayVFX(emitter, bounds.X + bounds.Width / 2, bounds.Y + bounds.Height / 2,
        RogueElements.Dir8.Down)
    end
  end
  GAME:WaitFrames(30)
  obj.Passable = true
  obj.EntEnabled = false
end

-- Currently does the Shopkeeper and the chest
-- Might be good to have the spawners and exits here also...
function checkpoint.SpawnGroundEntities()
  if GAME:GetCurrentGround():GetObj("Enchantment_Chest") == nil then
    local chest = RogueEssence.Ground.GroundObject(
      RogueEssence.Content.ObjAnimData("Green_Chest_Opening", 1, -1, 0, 255, RogueElements.Dir8.None), -- byte 255
      RogueElements.Dir8.Down,
      RogueElements.Rect(RogueElements.Loc(212, 240), RogueElements.Loc(32, 24)),
      RogueElements.Loc(20, 20),
      RogueEssence.Ground.GroundEntity.EEntityTriggerTypes.Action,
      false,
      "Enchantment_Chest"
    )
    chest:ReloadEvents()
    GAME:GetCurrentGround():AddObject(chest)
  end

  if GAME:GetCurrentGround():GetMapChar("Shopkeeper") == nil then
    -- local char = GROUND:CreateCharacterFromCharData("test", context.User, 31, 37)
    local monster_data = RogueEssence.Dungeon.MonsterID("pachirisu", 0, "normal",  RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(268, 176), Dir8.DownLeft,
    "Shopkeeper")
    ground_char:ReloadEvents()

    -- print(tostring(_ZONE.CurrentGround))
    GAME:GetCurrentGround():AddMapChar(ground_char)
  end


end

function checkpoint.ShowTitle(guest, player)

  local title = "Rest Point " .. SV.Terrasphere.CheckpointProgression
  local is_first_checkpoint = SV.Terrasphere.CheckpointProgression == 0

  local is_final_checkpoint = SV.Terrasphere.CheckpointProgression == 5
  if is_final_checkpoint then
    title = title .. " - Final Stretch"
  end

  if not is_first_checkpoint then
    UI:WaitShowTitle(title, 20)
  end

  GAME:WaitFrames(60)
  if not is_first_checkpoint then
    UI:WaitHideTitle(20)
  end
end

function RespawnGuests()
  local count = _DATA.Save.ActiveTeam.Guests.Count
  for i = 1, count, 1
  do
    GROUND:RemoveCharacter("Guest" .. tostring(i))
  end

  local total = 1
  for member in luanet.each(_DATA.Save.ActiveTeam.Guests) do
    GROUND:SpawnerSetSpawn("GUEST_" .. tostring(total), member)
    local chara = GROUND:SpawnerDoSpawn("GUEST_" .. tostring(total))
    -- GROUND:GiveCharIdleChatter(chara)
    total = total + 1
  end
end

function checkpoint.GetGroundDialogueForGuest(guest, player)
  local oldDir = guest.Direction
  GROUND:CharTurnToChar(guest, player)


  UI:SetSpeaker(guest)
  local tbl = LTBL(guest)
  local id = tbl.ID

  local enchant = EnchantmentRegistry:Get(id)

  enchant:dialogue()

  guest.Direction = oldDir
end




--roll a random index from 1 to length of category
--add the item in that index category to the shop
--2 essentials, always
-- local type_count = 2
-- for ii = 1, type_count, 1 do
--   local base_data = COMMON.ESSENTIALS[math.random(1, #COMMON.ESSENTIALS)]
--   table.insert(SV.base_shop, base_data)
-- end

-- --1-2 ammo, always
-- type_count = math.random(1, 2)
-- for ii = 1, type_count, 1 do
--   local base_data = COMMON.AMMO[math.random(1, #COMMON.AMMO)]
--   table.insert(SV.base_shop, base_data)
-- end

-- --2-3 utilities, always
-- type_count = math.random(3, 4)
-- for ii = 1, type_count, 1 do
--   local base_data = COMMON.UTILITIES[math.random(1, #COMMON.UTILITIES)]
--   table.insert(SV.base_shop, base_data)
-- end

-- --1-2 orbs, always
-- type_count = math.random(1, 2)
-- for ii = 1, type_count, 1 do
--   local base_data = COMMON.ORBS[math.random(1, #COMMON.ORBS)]
--   table.insert(SV.base_shop, base_data)
-- end

-- --2 special item, always
-- type_count = 2
-- for ii = 1, type_count, 1 do
--   local base_data = COMMON.SPECIAL[math.random(1, #COMMON.SPECIAL)]
--   table.insert(SV.base_shop, base_data)
-- end


function checkpoint.GenerateShop()
  local shop = {}
  local i = 1

  local function addItem(entry)
    entry.Index = i
    shop[i] = entry
    i = i + 1
  end

  -- 10 from the beginning
  -- 

  -- 1-5
  -- +5 from exploring



  -- 10 each floor
  -- Gain +10 shards from the 

  addItem({ Item = "food_apple", Amount = 1, Price = 2 })
  addItem({ Item = "berry_oran", Amount = 1, Price = 2 })
  addItem({ Item = "berry_oran", Amount = 1, Price = 2 })
  addItem({ Item = "orb_cleanse", Amount = 1, Price = 3 })
  addItem({ Item = "ammo_cacnea_spike", Amount = 9, Price = 3 })
  addItem({ Item = "gummi_wonder", Amount = 1, Price = 6 })
  addItem({ Item = "loot_pearl", Amount = 3, Price = 10 })
  addItem({ Item = "loot_nugget", Amount = 1, Price = 20 })
  
  if not SV.Terrasphere.GotMelodyBox then
    addItem({ Item = "terrasphere_melody_box", Amount = 1, Price = 99 })
  end

  return shop
end

function checkpoint.OnCheckpointArrive(checkpoint_progression)

  
  print(tostring(checkpoint_progression) .. "aaaaa")
  COMMON.RespawnAllies()
  RespawnGuests()
  checkpoint.SpawnGroundEntities()
  SV.Terrasphere.Shopkeeper = checkpoint.GenerateShop()
  SV.Terrasphere.CheckpointProgression = checkpoint_progression
  print(tostring(SV.Terrasphere.CheckpointProgression) .. "arrrrir")
  local active_enchants = EnchantmentRegistry:GetSelected()

  if not SV.Terrasphere.CheckpointEnchantsCalled then
    for _, enchant in pairs(active_enchants) do
      enchant:on_checkpoint()
    end
    SV.Terrasphere.CheckpointEnchantsCalled = true

    if not (SV.Terrasphere.ReceivedCannotSaveOnGroundModeReminder or GAME:InRogueMode()) then
      SV.Terrasphere.ReceivedCannotSaveOnGroundModeReminder = true
      UI:ResetSpeaker()
      UI:SetCenter(true)
      SOUND:PlayFanfare("Fanfare/Note")
      UI:WaitShowDialogue(string.format("Note: To prevent some bugs, you can only save during dungeon mode."))
      UI:WaitShowDialogue(string.format("Also, please do not also close the game while in ground mode too as your progress will be lost too!"))
      UI:SetCenter(false)
    end
  end
end

function checkpoint.OnCheckpointExit()
  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:on_checkpoint_exit()
  end
  SV.Terrasphere.GotEnchantmentFromCheckpoint = false
  SV.Terrasphere.CheckpointEnchantsCalled = false
end

function checkpoint.AskContinue()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Would you like to continue?", true)
  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  return yesnoResult
end

function checkpoint.ProceedToNextSection(segment, floor_num)
  segment = segment or 0
  local progression = SV.Terrasphere.CheckpointProgression
  floor_num = floor_num or (progression * 5)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local player = CH('PLAYER')
  local yesnoResult = checkpoint.AskContinue()
  GROUND:CharSetAnim(player, 'None', true)
  if yesnoResult then
    GAME:FadeOut(false, 60)
    GROUND:CharEndAnim(player)
    checkpoint.OnCheckpointExit()
    GAME:ContinueDungeon('the_terrasphere', 1, floor_num, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true,
    true)
  end

  local checkpoint = SV.Terrasphere.CheckpointProgression
  checkpoint = math.max(checkpoint, 5)
  SV.Terrasphere.ShopkeeperDialogueProgression[checkpoint] = true

  GROUND:CharEndAnim(player)
  
end

function checkpoint.AskReturn()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local player = CH('PLAYER')
  GROUND:CharSetAnim(player, 'None', true)
  local zone_data = _DATA:GetZone("guildmaster_island")
  local zone_name = zone_data:GetColoredName()
  UI:ChoiceMenuYesNo("Would you like to return to " .. zone_name .. "?", true)

  UI:WaitForChoice()
  local yesnoResult = UI:ChoiceResult()
  UI:SetCenter(false)
  if yesnoResult then
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GROUND:CharEndAnim(player)
    GAME:WaitFrames(60)
    ResetTerrasphereRun()
    GAME:EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Escaped, "guildmaster_island", -1, 0, 0, true, true)
    GAME:EnterZone("guildmaster_island", -1, 1, 0)
  end
  GROUND:CharEndAnim(player)
end

function checkpoint.ChestInteraction(obj, activator)
  if (activator.Direction ~= Dir8.Up) then
    return
  end
  
  UI:ResetSpeaker()
  print(Serpent.dump(SV.Terrasphere.Enchantments.Collection))
  -- if SV.Terrasphere.GotEnchantmentFromCheckpoint then
  --   UI:SetCenter(true)
  --   UI:WaitShowDialogue("You already selected an enchantment.")
  --   UI:SetCenter(false)
  --   return
  -- end


  GROUND:CharSetAnim(activator, "None", true)



  GROUND:ObjectSetDefaultAnim(obj, 'Green_Chest_Opening', 0, 0, 0, Direction.Right)
  GROUND:ObjectSetAnim(obj, 6, 0, 7, Direction.Right, 1)
  GROUND:ObjectSetDefaultAnim(obj, 'Green_Chest_Opening', 0, 7, 7, Direction.Right)


  -- local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Open", 10))
  -- emitter.LocHeight = 12
  -- GROUND:PlayVFX(emitter, obj.MapLoc.X + 18, obj.MapLoc.Y + 12)

  -- local emitter2 = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Light", 4))


  --   local startPos = obj.MapLoc * RogueEssence.Content.GraphicsManager.TileSize +
  --     RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2,
  --       RogueEssence.Content.GraphicsManager.TileSize / 2) + RogueElements.Loc(-100, 72)

  -- local endPos = obj.MapLoc * RogueEssence.Content.GraphicsManager.TileSize +
  --     RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2,
  --       RogueEssence.Content.GraphicsManager.TileSize / 2) + RogueElements.Loc(-80, 52)

  local emitter2 = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Light", 4))
  GROUND:PlayVFX(emitter2, obj.MapLoc.X - 80, obj.MapLoc.Y + 90, Dir8.Left, -100, 100)

  local emitter3 = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Light", 4))
  GROUND:PlayVFX(emitter3, obj.MapLoc.X + 120, obj.MapLoc.Y + 90, Dir8.Right, 100, 100)

  GAME:WaitFrames(50)

  local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")

  crystal_moment_status:LoadFromData()
  crystal_moment_status.Emitter.Layer = DrawLayer.Top

  _GROUND:AddMapStatus(crystal_moment_status)

  GAME:WaitFrames(60)

  ResetSeenEnchantments()
  local picked = checkpoint_offers.Get("Player")
  if #picked < 3 then
    _GROUND:RemoveMapStatus("crystal_moment")
    UI:WaitShowDialogue("There are not enough eligible enchantments available right now.")
    return
  end
  local enchantments = {}
  for i, enchantment in ipairs(picked) do
    local row = math.floor((i - 1) / 3) + 1
    enchantments[row] = enchantments[row] or {}
    table.insert(enchantments[row], enchantment)
  end
  -- Fixed initial offers for testing.
  enchantments[1][1] = EnchantmentRegistry._registry[ExitStrategy.id]
  enchantments[1][2] = EnchantmentRegistry._registry[HealingWaters.id]
  enchantments[1][3] = EnchantmentRegistry._registry[ShockValue.id]
  -- enchantments[1][2] = EnchantmentRegistry._registry[DoubleUp.id]
  -- enchantments[1][3] = EnchantmentRegistry._registry[ComboChain.id]
  -- enchantments[2][1] = EnchantmentRegistry._registry[CriticalSuccess.id]
  -- enchantments[1][2] = EnchantmentRegistry._registry[StackOfPlates.id]
  local ret = nil
  local choose = function(enchantment)
    SOUND:PlayBattleSE("_UNK_EVT_075")
    ret = enchantment
    print("Chosen enchantment: " .. enchantment.name)
    _MENU:RemoveMenu()
  end

  local refuse = function() _MENU:RemoveMenu() end



  local old = RogueEssence.Menu.MenuBase.BorderStyle

  RogueEssence.Menu.MenuBase.BorderStyle = 12

  print(tostring(Serpent.dump(SV.Terrasphere.Enchantments.RerollCounts)))

  local on_enchantment_seen = function(enchantment_id)
    SetEnchantmentStatusIfNeeded(enchantment_id, EnchantmentStatus.Seen)
    EnchantmentRegistry:MarkSeen(enchantment_id)
    beholder.trigger("OnEnchantmentSeen", enchantment_id)
  end

  local menu = EnchantmentSelectionMenu:new("Choose an enchantment!", enchantments, on_enchantment_seen, nil, nil,
    SV.Terrasphere.Enchantments.RerollCounts, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  RogueEssence.Menu.MenuBase.BorderStyle = old


  if (ret ~= nil) then
    GROUND:ObjectSetDefaultAnim(obj, 'Chest_Open', 0, 0, 0, Direction.Right)

    _GROUND:RemoveMapStatus("crystal_moment")
    GAME:WaitFrames(70)
    local enchantment_id = ret.id
    table.insert(SV.Terrasphere.Enchantments.Selected, enchantment_id)
    SetEnchantmentStatusIfNeeded(enchantment_id, EnchantmentStatus.Selected)
    SV.Terrasphere.GotEnchantmentFromCheckpoint = true
    beholder.trigger("OnEnchantmentSelected", enchantment_id)
    ret:apply()

    if not SV.Terrasphere.Enchantments.GotFirstReminder then
      SV.Terrasphere.Enchantments.GotFirstReminder = true
      SOUND:PlayFanfare("Fanfare/Note")
      UI:WaitShowDialogue("Note: You can check your active enchantments while in-dungeon: Others -> Run Info -> Active Enchants.")
    end
  else
    GROUND:ObjectSetDefaultAnim(obj, 'Green_Chest_Closing', 0, 0, 0, Direction.Right)
    GROUND:ObjectSetAnim(obj, 6, 0, 7, Direction.Right, 1)
    GROUND:ObjectSetDefaultAnim(obj, 'Green_Chest_Closing', 0, 7, 7, Direction.Right)
    _GROUND:RemoveMapStatus("crystal_moment")
    GAME:WaitFrames(40)
  end

  GROUND:CharEndAnim(activator)
end




function CreateShopMenu(prompt, items)
  local ret = {}
  local choose = function(item)
    ret = item
    _MENU:RemoveMenu()
  end
  local refuse = function()
    _MENU:RemoveMenu()
  end

  local generate_option_choice = function(item_entry, i, confirm_action)
    local price_text = tostring(item_entry.Price) .. PMDSpecialCharacters.YellowShard
    local item_name = M_HELPERS.GetItemName(item_entry.Item, item_entry.Amount)
    local text = price_text .. " - " .. item_name

    local color = Color.White
    local text_name = RogueEssence.Menu.MenuText(text, RogueElements.Loc(2, 1), color)

    local option = RogueEssence.Menu.MenuElementChoice(
      function() confirm_action(i) end,
      false,
      text_name
    )
    return option
  end

  local menu = ItemSelectionMenu:new(prompt, items, generate_option_choice, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()
  return ret
end


-- function ItemShopMenu:generate_options()
--   local options = {}
--   for i = 1, #self.itemsList, 1 do
--     local item_entry = self.itemsList[i]
--     local enabled = self.filter(item)
--     -- local item, equip_id = nil, nil
--     -- if slot.IsEquipped then
--     --   equip_id = slot.Slot
--     --   item = _DATA.Save.ActiveTeam.Players[equip_id].EquippedItem
--     -- else
--     --   item = _DATA.Save.ActiveTeam:GetInv(slot.Slot)
--     -- end
--     local color = Color.White
--     if not enabled then color = Color.Red end

--     -- local name = item:GetDisplayName()
--     -- if equip_id then name = tostring(equip_id + 1) .. ": " .. name end

--     --     List<MenuChoice> flatChoices = new List<MenuChoice>();
--     -- for (int ii = 0; ii < goods.Count; ii++)
--     -- {
--     --     int index = ii;

--     --     bool canAfford = goods[index].Item2 <= DataManager.Instance.Save.ActiveTeam.Money;
--     --     MenuText itemText = new MenuText(goods[index].Item1.GetDisplayName(), new Loc(2, 1), canAfford ? Color.White : Color.Red);
--     --     MenuText itemPrice = new MenuText(goods[index].Item2.ToString(), new Loc(ItemMenu.ITEM_MENU_WIDTH - 8 * 4, 1), DirV.Up, DirH.Right, Color.Lime);
--     --     flatChoices.Add(new MenuElementChoice(() => { choose(index); }, true, itemText, itemPrice));
--     -- }



--     -- MenuText itemPrice = new MenuText(goods[index].Item2.ToString(), new Loc(ItemMenu.ITEM_MENU_WIDTH - 8 * 4, 1), DirV.Up, DirH.Right, Color.Lime);
--     local text_name = RogueEssence.Menu.MenuText(item_entry.Name, RogueElements.Loc(2, 1), color)
--     local option = RogueEssence.Menu.MenuElementChoice(function() self:choose(i) end, enabled, text_name)
--     table.insert(options, option)
--   end
--   return options
-- end



function checkpoint.ShopkeeperIntroDialogue()
  local checkpoint = SV.Terrasphere.CheckpointProgression

  local player = CH("PLAYER")
  local shopkeeper = CH("Shopkeeper")
  checkpoint = math.max(checkpoint, 5)
  if not SV.Terrasphere.ShopkeeperDialogueProgression[checkpoint] and not GAME:InRogueMode() then
    if checkpoint == 1 then
      UI:WaitShowDialogue("Ay! A bunch of ")
    elseif checkpoint == 2 then
      UI:WaitShowDialogue("hi2")
    elseif checkpoint == 3 then
      UI:WaitShowDialogue("hi3")
    elseif checkpoint == 4 then
      UI:WaitShowDialogue("hi4")
    else
      UI:WaitShowDialogue("hey, you are probably using dev mode")
      GROUND:CharSetEmote(shopkeeper, "shock", 1)
      SOUND:PlayBattleSE("EVT_Emote_Shock_Bad")
      GROUND:CharSetEmote(player, "exclaim", 1)
      UI:WaitShowDialogue("donenenen")
    end
    -- SV.Terrasphere.ShopkeeperDialogueProgression[checkpoint] = true
  end
end

function checkpoint.ShopkeeperDialogue(shopkeeper, player)
  local oldDir = shopkeeper.Direction
  GROUND:CharTurnToChar(shopkeeper, player)
  GROUND:CharSetAnim(player, "None", true)
  GROUND:CharSetAnim(shopkeeper, "None", true)

  UI:SetSpeaker(shopkeeper)
  -- UI:SetSpeakerReverse(true)
  -- local portrait_loc = RogueEssence.Menu.SpeakerPortrait.DefaultLoc
  -- portrait_loc.X = RogueEssence.Content.GraphicsManager.ScreenWidth - 56
  -- UI:SetSpeakerLoc(portrait_loc.X, portrait_loc.Y)

  checkpoint.ShopkeeperIntroDialogue()

  local state = 0
  local repeated = false
  local cart = {}

  while state > -1 do
    if state == 0 then
      UI:SetSpeakerEmotion("Normal")
      local msg = repeated and "Hehe.. anything else?" or
      "Hehe... what business do ya got with me today?"
      local choices = { "Buy", "Sell", "Info", "Section Info", "Leave" }
      UI:BeginChoiceMenu(msg, choices, 1, 5)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      repeated = true

      if result == 1 then
        local shop_array = {}
        for _, item in pairs(SV.Terrasphere.Shopkeeper) do
          table.insert(shop_array, item)
        end
        if #shop_array > 0 then
          UI:SetSpeakerEmotion("Happy")
          UI:WaitShowDialogue("Lookie here... See anything the catches your twinkling eye?")
          state = 1
        else
          UI:SetSpeakerEmotion("Happy")
          UI:WaitShowDialogue("Well, well... You made me very happy today...")
          UI:WaitShowDialogue("Come back again if ya got the shards...")
        end
      elseif result == 2 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        if bag_count > 0 then
          UI:WaitShowDialogue("Wanna sell something do ya? I ain't a rich merchant like Kecleon... but I'll payout just a little.")
          state = 3
        else
          UI:SetSpeakerEmotion("Worried")
          UI:WaitShowDialogue("You've got nothing on ya...")
          UI:SetSpeakerEmotion("Normal")
        end
      elseif result == 3 then
        UI:WaitShowDialogue("Yellow Shards are my life... ya know.")
        UI:WaitShowDialogue("They're yellow and shiny... just like me.")
        UI:WaitShowDialogue("I'll take them off your hands in exchange for some... desirable items.")
        UI:WaitShowDialogue("I also ain't rich like them Kecleon... but I'll still complensate ya just a little.")
      elseif result == 4 then
      
        UI:WaitShowDialogue("Water section!")

      else
        local shards = ItemShopMenu:count_item("yellow_shard")
        if shards == 0 then
          UI:WaitShowDialogue("Good luck... keep your twinkling eye for those shards will ya.")
        elseif shards < 3 then
          UI:WaitShowDialogue("Good luck... keep those shards safe will ya?")
        else
        end
    
        -- end
        state = -1
      end
    elseif state == 1 then
      local shop_array = {}
      for _, item in pairs(SV.Terrasphere.Shopkeeper) do
        table.insert(shop_array, item)
      end

      local result = ItemShopMenu.run("Pachirisu's Shop", shop_array, function(x) return true end, "Trade", 8)

      if result.Items then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        local bag_cap = GAME:GetPlayerBagLimit()
        if bag_count == bag_cap then
          UI:SetSpeakerEmotion("Sad")
          UI:WaitShowDialogue("Hmm. Your bag seems full.")
          UI:SetSpeakerEmotion("Happy")
          UI:WaitShowDialogue("You can give some items to me!")
          UI:SetSpeakerEmotion("Normal")
        else
          cart = result.Items
          local total = result.Price

          local msg

          if #cart == 1 then
            local item_name = RogueEssence.Dungeon.InvItem(cart[1].Item, false, cart[1].Amount):GetDisplayName()
            msg = "That'll be " .. total .. PMDSpecialCharacters.YellowShard .. " for " .. item_name .. ". Deal?"
          else
            msg = "That'll be " .. total .. PMDSpecialCharacters.YellowShard .. " for all of that. Deal?"
          end

          UI:ChoiceMenuYesNo(msg, false)
          UI:WaitForChoice()
          local confirm = UI:ChoiceResult()

          if confirm then
            local bought_count = #cart
            M_HELPERS.RemoveItem("yellow_shard", total)
            for ii = 1, #cart do
              local entry = cart[ii]
              GAME:GivePlayerItem(entry.Item, entry.Amount, false)
              SV.Terrasphere.Shopkeeper[entry.Index] = nil
            end
            cart = {}
            SOUND:PlayBattleSE("DUN_Money")
            if bought_count == 1 then
              UI:WaitShowDialogue("Here ya go... enjoy your item.")
            else
              UI:WaitShowDialogue("Here ya go... these shards do be looking mighty beautiful.")
            end
          else
            UI:WaitShowDialogue("Unfortunate... Do come back soon...")
          end
        end
      end
      state = 0
    elseif state == 3 then
      UI:SellMenu()
      UI:WaitForChoice()
      local result = UI:ChoiceResult()

      if #result > 0 then
        cart = result
        state = 4
      else
        state = 0
      end
    elseif state == 4 then
      local total = 0
      for ii = 1, #cart do
        local item
        if cart[ii].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[ii].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[ii].Slot)
        end
        total = total + math.floor(item:GetSellValue() * 0.5)
      end

      local msg
      if #cart == 1 then
        local item
        if cart[1].IsEquipped then
          item = GAME:GetPlayerEquippedItem(cart[1].Slot)
        else
          item = GAME:GetPlayerBagItem(cart[1].Slot)
        end
        msg = "I'll give you " .. STRINGS:FormatKey("MONEY_AMOUNT", total) .. " for that " .. item:GetDisplayName() .. ". Sound good?"
      else
        msg = "I'll give you " .. STRINGS:FormatKey("MONEY_AMOUNT", total) .. " for all of it. Sound good?"
      end

      UI:ChoiceMenuYesNo(msg, false)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()

      if result then
        local sold_count = #cart
        for ii = #cart, 1, -1 do
          if cart[ii].IsEquipped then
            GAME:TakePlayerEquippedItem(cart[ii].Slot, true)
          else
            GAME:TakePlayerBagItem(cart[ii].Slot, true)
          end
        end
        SOUND:PlayBattleSE("DUN_Money")
        GAME:AddToPlayerMoney(total)
        cart = {}
        if sold_count == 1 then
          UI:WaitShowDialogue("Pleasure. I'll take care of this.")
        else
          UI:WaitShowDialogue("Pleasure. I'll take care of all of these.")
        end
        state = 0
      else
        state = 3
      end
    end
  end

  shopkeeper.Direction = oldDir
  GROUND:CharEndAnim(player)
  GROUND:CharEndAnim(shopkeeper)
  UI:ResetSpeaker()
end


  -- UI:WaitForChoice()
  -- CalculateChoiceLength
    -- protected int CalculateChoiceLength(IEnumerable<IChoosable> choices, int minWidth)
    
  -- local ret = {}
  -- local choose = function(list) ret = list end
  -- local refuse = function() _MENU:RemoveMenu() end
  -- local shop = checkpoint.GenerateShop()
  -- local menu = ItemShopMenu:new("gi", function (x) return true
    
  -- end, choose, refuse, "ggiig", 176, true, 8)
  -- UI:SetCustomMenu(menu.menu)
  -- UI:WaitForChoice()
  -- return ret

  -- 1st Checkpoint:
  -- If in roguelocke mode, then the introduction isn't necessary, only for story mod
  -- Oy there! Making ways towards the Terrasphere ain't you? Come over here ... and don't mind that chest there...

  -- Ay, I bunch of first-timers I see.
  -- Ay, a first-timer I see.


  -- Pachirisu

  -- Psh. You probably heard a similar spiel from Nocturne. Very few have made it towards the end of Terrasphere and yada-yada-yada...

  -- I'm here to make your life easier

  -- Oy there! Making ways towards the Terrasphere ain't ye? Come o'er here ... an don't mind dat chest there.
  -- Ay, I bunch o' first-timers I see.
  -- Ay, a first-timer I see.

  -- Psh. Ye prolly heard a similar spiel from Nocturne. Mighty few have made it towards the end of Terrasphere and yada-yada-yada...

  -- Let me keep it simple, I be here to make yer life easier as I have a bunch of goods for your little adventure but at a penny

  -- Let me keep it simple, I be here to make yer life easier as I have a bunch of loot fer your wee adventure... but at a penny of course!

  -- The Terrasphere be more barren of resources that you need to make it there
  -- The penny will Price ye 2 penny

  -- Then see that chest o'er there, that thing be mighty special, aye indeed. Open the chest and it shall grant untold powers

  -- ... only for the Terrasphere area
  -- Anyways, lads, speak wit' me if ye loot ye needs for  your wee adventure!


  -- I haven't seen an explorer team such as yours in quite a while!

  -- The more you purchase from me the more expensive it will be later
  -- It's supply & demand baby!
  -- Except fer gold 'n pearls, folks these days don't understand thar value 'n 'ave no use at the Terrasphere
  -- What do they call it these days, oh yeah, supply and demand har-har! Popular items will be more expensive, while less popular items will have the same price
  -- Wha' do they call it these days, oh aye, supply 'n demand har har har!




  -- When press "Sell": Whatever you're selling, I've already got. I'm sure those Kecleons have be taking businesses with with you


  -- How can I be of er' service today?

  -- Best of luck ye scallywags!

  -- That will be 1500 gold, how that sound for ye
  -- Dat shall be 1500 gold, how dat sound fer ye

  -- Har-Har pleasure doing businesses with ye.

  -- 2nd Checkpoint:
  -- How did I get here?

  -- Actually, we're all related...
-- end
return checkpoint
