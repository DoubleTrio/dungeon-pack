
require 'trios_dungeon_pack.menu.EnchantmentSelectionMenu'
require 'trios_dungeon_pack.emberfrost.enchantments'
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

  -- pick a random track with equal probability
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

  local title = "Checkpoint " .. SV.EmberFrost.CheckpointProgression
  if SV.EmberFrost.CheckpointProgression == 5 then
    title = title .. " - Final Stretch"
  end
  UI:WaitShowTitle(title, 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
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

  addItem({ Item = "food_apple", Amount = 1, Price = 2 })
  addItem({ Item = "seed_reviver", Amount = 1, Price = 4 })
  addItem({ Item = "berry_oran", Amount = 1, Price = 2 })
  addItem({ Item = "orb_cleanse", Amount = 1, Price = 3 })
  addItem({ Item = "ammo_cacnea_spike", Amount = 9, Price = 3 })
  addItem({ Item = "gummi_wonder", Amount = 1, Price = 6 })
  addItem({ Item = "loot_pearl", Amount = 3, Price = 10 })
  addItem({ Item = "loot_nugget", Amount = 1, Price = 20 })
  
  if not SV.EmberFrost.GotMelodyBox then
    addItem({ Item = "emberfrost_melody_box", Amount = 1, Price = 99 })
  end

  return shop
end

function checkpoint.OnCheckpointArrive()

  
  COMMON.RespawnAllies()
  RespawnGuests()
  checkpoint.SpawnGroundEntities()
  SV.EmberFrost.Shopkeeper = checkpoint.GenerateShop()
  SV.EmberFrost.CheckpointProgression = SV.EmberFrost.CheckpointProgression + 1
  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:on_checkpoint()
  end
end

function checkpoint.OnCheckpointExit()
  local active_enchants = EnchantmentRegistry:GetSelected()
  for _, enchant in pairs(active_enchants) do
    enchant:on_checkpoint_exit()
  end
  SV.EmberFrost.GotEnchantmentFromCheckpoint = false
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
  floor_num = floor_num or (SV.EmberFrost.CheckpointProgression * 5)
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  local player = CH('PLAYER')
  local yesnoResult = checkpoint.AskContinue()
  GROUND:CharSetAnim(player, 'None', true)
  if yesnoResult then
    GAME:FadeOut(false, 60)
    GROUND:CharEndAnim(player)
    checkpoint.OnCheckpointExit()
    GAME:ContinueDungeon('emberfrost_depths', 0, floor_num, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
  end

  local checkpoint = SV.EmberFrost.CheckpointProgression
  checkpoint = math.max(checkpoint, 5)
  SV.EmberFrost.ShopkeeperDialogueProgression[checkpoint] = true

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
    ResetEmberfrostRun()
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
  print(Serpent.dump(SV.EmberFrost.Enchantments.Collection))
  -- if SV.EmberFrost.GotEnchantmentFromCheckpoint then
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
  local enchantments = EnchantmentRegistry:GetRandom(6, 2)


  enchantments[1][1] = EnchantmentRegistry._registry[Grounded.id]
  enchantments[1][2] = EnchantmentRegistry._registry[TheBubble.id]
  enchantments[1][3] = EnchantmentRegistry._registry[Blueprint.id]
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

  print(tostring(Serpent.dump(SV.EmberFrost.Enchantments.RerollCounts)))

  local on_enchantment_seen = function(enchantment_id)
    SetEnchantmentStatusIfNeeded(enchantment_id, EnchantmentStatus.Seen)
    table.insert(SV.EmberFrost.Enchantments.Seen, enchantment_id)
    beholder.trigger("OnEnchantmentSeen", enchantment_id)
  end

  local menu = EnchantmentSelectionMenu:new("Choose an enchantment!", enchantments, on_enchantment_seen, nil, nil,
    SV.EmberFrost.Enchantments.RerollCounts, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  RogueEssence.Menu.MenuBase.BorderStyle = old


  if (ret ~= nil) then
    GROUND:ObjectSetDefaultAnim(obj, 'Chest_Open', 0, 0, 0, Direction.Right)

    _GROUND:RemoveMapStatus("crystal_moment")
    GAME:WaitFrames(40)
    GAME:WaitFrames(30)
    local enchantment_id = ret.id
    table.insert(SV.EmberFrost.Enchantments.Selected, enchantment_id)
    SetEnchantmentStatusIfNeeded(enchantment_id, EnchantmentStatus.Selected)
    SV.EmberFrost.GotEnchantmentFromCheckpoint = true
    beholder.trigger("OnEnchantmentSelected", enchantment_id)
    ret:apply()

    if not SV.EmberFrost.Enchantments.GotFirstReminder then
      SV.EmberFrost.Enchantments.GotFirstReminder = true
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
  local checkpoint = SV.EmberFrost.CheckpointProgression

  local player = CH("PLAYER")
  local shopkeeper = CH("Shopkeeper")
  checkpoint = math.max(checkpoint, 5)
  if not SV.EmberFrost.ShopkeeperDialogueProgression[checkpoint] and not GAME:InRogueMode() then
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
    -- SV.EmberFrost.ShopkeeperDialogueProgression[checkpoint] = true
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
      local msg = repeated and "What else will it be?" or
      "Welcome! I trade in Yellow Shards. Buy, sell, or just browse?"
      local choices = { "Buy", "Sell", "Info", "Section Info", "Leave" }
      UI:BeginChoiceMenu(msg, choices, 1, 5)
      UI:WaitForChoice()
      local result = UI:ChoiceResult()
      repeated = true

      if result == 1 then
        local shop_array = {}
        for _, item in pairs(SV.EmberFrost.Shopkeeper) do
          table.insert(shop_array, item)
        end
        if #shop_array > 0 then
          UI:WaitShowDialogue("Take a look at what I've got. Payment in Yellow Shards only!")
          state = 1
        else
          UI:WaitShowDialogue("...Hm. Looks like I'm all sold out. Check back later.")
        end
      elseif result == 2 then
        local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
        if bag_count > 0 then
          UI:WaitShowDialogue("Got something to offload? I'll give you a fair cut.")
          state = 3
        else
          UI:SetSpeakerEmotion("Sad")
          UI:WaitShowDialogue("You've got nothing on you. Come back when you've got something to sell.")
          UI:SetSpeakerEmotion("Normal")
        end
      elseif result == 3 then
        UI:WaitShowDialogue("INFO PLACEHOLDER 1: This shop accepts Yellow Shards as currency.")
        UI:WaitShowDialogue("INFO PLACEHOLDER 2: Items purchased here are gone for good — no restocks mid-run.")
        UI:WaitShowDialogue("INFO PLACEHOLDER 3: Selling items returns 60% of their value in Poke.")
        UI:WaitShowDialogue("INFO PLACEHOLDER 4: [Additional lore/info here]")
        
      elseif result == 4 then
      
        UI:WaitShowDialogue("Water section!")

      else
        UI:WaitShowDialogue("Safe travels. Don't spend those shards all in one place.")
        state = -1
      end
    elseif state == 1 then
      local shop_array = {}
      for _, item in pairs(SV.EmberFrost.Shopkeeper) do
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
              SV.EmberFrost.Shopkeeper[entry.Index] = nil
            end
            cart = {}
            SOUND:PlayBattleSE("DUN_Money")
            if bought_count == 1 then
              UI:WaitShowDialogue("Good pick. Take care of it.")
            else
              UI:WaitShowDialogue("Nice haul. Pleasure doing business.")
            end
          else
            UI:WaitShowDialogue("Aww unfortunate. Come back next time!")
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
  -- Oy there! Making ways towards the Emberfrost ain't you? Come over here ... and don't mind that chest there...

  -- Ay, I bunch of first-timers I see.
  -- Ay, a first-timer I see.


  -- Pachirisu

  -- Psh. You probably heard a similar spiel from Nocturne. Very few have made it towards the end of Emberfrost and yada-yada-yada...

  -- I'm here to make your life easier

  -- Oy there! Making ways towards the Emberfrost ain't ye? Come o'er here ... an don't mind dat chest there.
  -- Ay, I bunch o' first-timers I see.
  -- Ay, a first-timer I see.

  -- Psh. Ye prolly heard a similar spiel from Nocturne. Mighty few have made it towards the end of Emberfrost and yada-yada-yada...

  -- Let me keep it simple, I be here to make yer life easier as I have a bunch of goods for your little adventure but at a penny

  -- Let me keep it simple, I be here to make yer life easier as I have a bunch of loot fer your wee adventure... but at a penny of course!

  -- The Emberfrost be more barren of resources that you need to make it there
  -- The penny will Price ye 2 penny

  -- Then see that chest o'er there, that thing be mighty special, aye indeed. Open the chest and it shall grant untold powers

  -- ... only for the Emberfrost area
  -- Anyways, lads, speak wit' me if ye loot ye needs for  your wee adventure!


  -- I haven't seen an explorer team such as yours in quite a while!

  -- The more you purchase from me the more expensive it will be later
  -- It's supply & demand baby!
  -- Except fer gold 'n pearls, folks these days don't understand thar value 'n 'ave no use at the Emberfrost
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