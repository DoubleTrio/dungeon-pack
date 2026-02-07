function SetEnchantmentStatusIfNeeded(enchantment_id, status)
  local seen_value = SV.EmberFrost.Enchantments.Collection[enchantment_id] or EnchantmentStatus.NotSeen
  SV.EmberFrost.Enchantments.Collection[enchantment_id] = math.max(seen_value, status)
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

function checkpoint.ProceedToNextSection(floor_num)
  floor_num = floor_num or (SV.EmberFrost.CheckpointProgression * 5) - 1
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
    CleanUpEmberFrostDepths()
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
  if SV.EmberFrost.GotEnchantmentFromCheckpoint then
    UI:SetCenter(true)
    UI:WaitShowDialogue("You already selected an enchantment.")
    UI:SetCenter(false)
    return
  end


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

  -- ResetSeenEnchantments()
  local enchantments = EnchantmentRegistry:GetRandom(6, 2)


  enchantments[1][1] = EnchantmentRegistry._registry['RAINING_GOLD']
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
  end

  print("Creating enchantment selection menu..." .. Serpent.dump(enchantments))

  local menu = EnchantmentSelectionMenu:new("Choose an enchantment!", enchantments, on_enchantment_seen, nil, nil,
    SV.EmberFrost.Enchantments.RerollCounts, choose, refuse)
  UI:SetCustomMenu(menu.menu)
  UI:WaitForChoice()

  RogueEssence.Menu.MenuBase.BorderStyle = old
  -- \uE110
  _GROUND:RemoveMapStatus("crystal_moment")
  GAME:WaitFrames(40)

  if (ret ~= nil) then
    GAME:WaitFrames(30)
    local enchantment_id = ret.id
    table.insert(SV.EmberFrost.Enchantments.Selected, enchantment_id)
    SetEnchantmentStatusIfNeeded(enchantment_id, EnchantmentStatus.Selected)
    SV.EmberFrost.GotEnchantmentFromCheckpoint = true
    ret:apply()
  end


  GROUND:CharEndAnim(activator)
  
end

return checkpoint