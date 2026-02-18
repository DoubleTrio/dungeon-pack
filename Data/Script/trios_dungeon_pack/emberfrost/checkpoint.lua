
require 'trios_dungeon_pack.menu.EnchantmentSelectionMenu'
require 'trios_dungeon_pack.emberfrost.enchantments'
require 'trios_dungeon_pack.beholder'

require 'origin.menu.InventorySelectMenu'

function PlayRandomBGM(tracks)
  tracks = tracks or {
    "The Wind is Blowing at Cavi Cape.ogg",
    "Obsidian Fieldlands 2.ogg",
    "Vast Poni Canyon.ogg",
    "Rock Slide Canyon.ogg",
    "Resolution Gorge.ogg",
    "Wishmaker Depths.ogg",
    "Ruins of Life.ogg"
  }

  -- pick a random track with equal probability
  local music = tracks[math.random(#tracks)]
  SOUND:PlayBGM(music, true)
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

local checkpoint = {}


function checkpoint.ShowTitle(guest, player)

  local title = "Checkpoint " .. SV.EmberFrost.CheckpointProgression

  if SV.EmberFrost.CheckpointProgression == 5 then
    title = title .. " - Final Stretch"
  end
  UI:WaitShowTitle(title, 20)
  GAME:WaitFrames(60)
  UI:WaitHideTitle(20)
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

function checkpoint.OnCheckpointArrive()
  COMMON.RespawnAllies()
  RespawnGuests()
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


  local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Open", 10))
  -- emitter.LocHeight = 12
  GROUND:PlayVFX(emitter, obj.MapLoc.X + 18, obj.MapLoc.Y + 12)

  local emitter2 = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Chest_Light", 4))


  --   local startPos = obj.MapLoc * RogueEssence.Content.GraphicsManager.TileSize +
  --     RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2,
  --       RogueEssence.Content.GraphicsManager.TileSize / 2) + RogueElements.Loc(-100, 72)

  -- local endPos = obj.MapLoc * RogueEssence.Content.GraphicsManager.TileSize +
  --     RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2,
  --       RogueEssence.Content.GraphicsManager.TileSize / 2) + RogueElements.Loc(-80, 52)
  GROUND:PlayVFX(emitter2, obj.MapLoc.X - 100, obj.MapLoc.Y, Dir8.Left, -100, 100)


  GAME:WaitFrames(50)

  local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")

  crystal_moment_status:LoadFromData()
  crystal_moment_status.Emitter.Layer = DrawLayer.Top

  _GROUND:AddMapStatus(crystal_moment_status)

  GAME:WaitFrames(60)

  ResetSeenEnchantments()
  local enchantments = EnchantmentRegistry:GetRandom(6, 2)


  enchantments[1][1] = EnchantmentRegistry._registry[PandorasItems.id]
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
  _GROUND:RemoveMapStatus("crystal_moment")
  GAME:WaitFrames(40)

  if (ret ~= nil) then
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
  end

  GROUND:CharEndAnim(activator)
end

function checkpoint.ShopkeeperDialogue()
  -- checkpoint.GetGroundDialogueForGuest(chara, activator)
  UI:WaitShowDialogue("hi i'm the shopkeeper")
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
  -- The penny will cost ye 2 penny

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
end
return checkpoint