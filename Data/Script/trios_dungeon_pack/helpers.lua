BattleScriptEventType = luanet.import_type("RogueEssence.Dungeon.BattleScriptEvent")


EnchantmentStatus = {
  NotSeen = 0,
  Seen = 1,
  Selected  = 2,
  SelectedAndWon = 3
}

function InitializeEnchantmentCollection()
  for k, v in pairs(EnchantmentRegistry._registry) do

    SetEnchantmentStatusIfNeeded(k, EnchantmentStatus.NotSeen)
  end
  print("Enchantment Collection initialized.")
  print(Serpent.block(SV.EmberFrost.Enchantments.Collection))

end

function ResetEmberfrost()
  SV.EmberFrost = {
    Enchantments = {
      Seen = {},
      Selected = {},
      Data = {},
      Collection = {},
      RerollCounts = {1, 1, 1},
    },

    Quests = {
      Active = {},
      Data = {},
    },
    LastFloor = 0,
    GotEnchantmentFromCheckpoint = false
  }


  InitializeEnchantmentCollection()
  
end
function SetEnchantmentStatusIfNeeded(enchantment_id, status)
  local seen_value = SV.EmberFrost.Enchantments.Collection[enchantment_id] or EnchantmentStatus.NotSeen
  SV.EmberFrost.Enchantments.Collection[enchantment_id] = math.max(seen_value, status)
end

local function GenderToNum(gender)
  local res = -1
  if gender == Gender.Genderless then
    res = 0
  elseif gender == Gender.Male then
    res = 1
  elseif gender == Gender.Female then
    res = 2
  end
  return res
end

local function NumToGender(num)
  local res = Gender.Unknown
  if num == 0 then
    res = Gender.Genderless
  elseif num == 1 then
    res = Gender.Male
  elseif num == 2 then
    res = Gender.Female
  end
  return res
end

PMDColor = {
  Gray = "#868686",
  Cyan = "#00FFFF",
  Pink = "#F8C8C8",
  Red = "#F80000",
  Yellow = "#F8F8A0",
  LightYellow = "#F8F800",
  White = "#F8F8F8",
  LightRed = "#F87878",
  LimeGreen = "#00F800",
  LightGreen = "#00E060",
  LimeGreen2 = "#40F840",
  Orange = "#F8C060",
  Blue = "#8080F8", -- Q
  SlateBlue  = "#6080E0", -- S
  Magenta = "#F8A0F8",      -- X
  SkyBlue = "#8098F8",      -- Y
  Lavender = "#8888F8",      -- Z
}

PMDSpecialCharacters = {
  Heart = STRINGS:Format("\\u2661"),
  MusicNote = STRINGS:Format("\\u266A"),

  Check = STRINGS:Format("\\uE10A"),
  Cross = STRINGS:Format("\\uE10B"),
  Star = STRINGS:Format("\\uE10C"),
  StarHalf = STRINGS:Format("\\uE10D"),

  Mail = STRINGS:Format("\\uE10E"),
  MailOpen = STRINGS:Format("\\uE10F"),

  Calculator = STRINGS:Format("\\uE110"),
  Pencil = STRINGS:Format("\\uE111"),

  Scribble = STRINGS:Format("\\uE023"),
  Money = STRINGS:Format("\\uE024"),
  SpeechBubble = STRINGS:Format("\\uE040"),
}
M_HELPERS = {


  map = function (tbl, f)
    local t = {}
    for k,v in ipairs(tbl) do
        t[k] = f(v)
    end
    return t
  end,
  
  MakeColoredText = function(text, color)
    return "[color=" .. color .. "]" .. text .. "[color]"
  end,

  GiftItemToInventory = function(item_id, amount)
    local orig_settings = UI:ExportSpeakerSettings()
    local inv_item = RogueEssence.Dungeon.InvItem(item_id, false, amount)

    GAME:GivePlayerItem(inv_item)
    SOUND:PlayFanfare("Fanfare/Item")

    UI:ResetSpeaker(false)
    UI:SetCenter(true)
    UI:WaitShowDialogue("You gained " .. inv_item:GetDisplayName() .. "!")
    UI:SetCenter(false)
    UI:ImportSpeakerSettings(orig_settings)
  end,

  GetItemName = function(item_id, with_amount)
    local item_name = ""

    if (with_amount) then
      local item = RogueEssence.Dungeon.InvItem(item_id, false, with_amount)
      item_name = item:GetDisplayName()
    else
      local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(item_id)
      if entry == nil then
        return nil
      end
      item_name = entry:GetIconName()
    end

    return item_name
  end,

  AddToAssembly = function(species, level)
    local char = M_HELPERS.CreateCharacter(species, level)
    GAME:AddPlayerAssembly(char)
  end,

  AddToParty = function(species, level)
    local char = M_HELPERS.CreateCharacter(species, level)
    GAME:AddPlayerTeam(char)
  end,

  CreateCharacter = function(species, level)
    local mon_id = RogueEssence.Dungeon.MonsterID(species, 0, "normal", Gender.Unknown)
    local char = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, level, "", 0)
    return char
  end,

  DebugPopulateAssembly = function(level)
    M_HELPERS.AddToAssembly("charmander", level)
    M_HELPERS.AddToAssembly("squirtle", level)
    M_HELPERS.AddToAssembly("bulbasaur", level)
  end,

  DebugPopulateParty = function(level)
    M_HELPERS.AddToParty("charmander", level)
    M_HELPERS.AddToParty("squirtle", level)
    M_HELPERS.AddToParty("bulbasaur", level)
  end,

  SaveTeam = function(key)
    -- Will save team and inventory
    local save = _DATA.Save
    local team_data = {}
    local player_count = save.ActiveTeam.Players.Count
    for i = 0, player_count - 1 do
      local member = save.ActiveTeam.Players[i]
      local memberKey = key .. tostring(i)
      M_HELPERS.SaveCharacter(member, memberKey)
    end

    M_HELPERS.SaveInventory(key)
  end,

  GiveInventoryItemsToPlayer = function(items)
    local orig_settings = UI:ExportSpeakerSettings()
    local filter = function(inv_slot)
      local slot = inv_slot.Slot

      local item

      if (inv_slot.IsEquipped) then
        item = GAME:GetPlayerEquippedItem(slot)
      else
        item = _DATA.Save.ActiveTeam:GetInv(slot)
      end

      local entry = _DATA:GetItem(item.ID)
      return not entry.CannotDrop
    end


    -- local items_to_receive = { {
    --   Item = "apricorn_big",
    --   Amount = 1
    -- }, {
    --   Item = "ammo_stick",
    --   Amount = 3
    -- } }

    local amount = #items

    local bag_cap = _ZONE.CurrentZone.BagSize
    local bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()

    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize + amount

    for _, entry in ipairs(items) do
      print("Here is the item to give: " .. entry.Item .. " x" .. tostring(entry.Amount))
      M_HELPERS.GiftItemToInventory(entry.Item, entry.Amount)
    end

    _ZONE.CurrentZone.BagSize = _ZONE.CurrentZone.BagSize - amount

    bag_cap = _ZONE.CurrentZone.BagSize
    bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()

    while bag_count > bag_cap do
      local diff = bag_count - bag_cap

      UI:WaitShowDialogue("Your Treasure Bag is full! Choose item(s) to remove.")

      local ret = {}
      local choose = function(list)
        ret = list
      end
      local refuse = function()
      end

      local menu = InventorySelectMenu:new(string.format("Treasure Bag (%d/%d)", bag_count, bag_cap), filter,
        choose, refuse, "Trash", 176, true, diff)

      UI:SetCustomMenu(menu.menu)
      UI:WaitForChoice()

      if #ret > 0 then
        for i = #ret, 1, -1 do
          if ret[i].IsEquipped then
            GAME:TakePlayerEquippedItem(ret[i].Slot, true)
          else
            GAME:TakePlayerBagItem(ret[i].Slot, true)
          end
        end
      end

      bag_count = GAME:GetPlayerBagCount() + GAME:GetPlayerEquippedCount()
    end
    UI:ImportSpeakerSettings(orig_settings)
  end,

  LoadTeam = function(key)
    -- Will load team and inventory
    local save = _DATA.Save
    save.ActiveTeam.Players:Clear()
    local i = 0
    while true do
      local memberKey = key .. tostring(i)
      local c_data = SV.SavedCharacters[memberKey]
      if c_data == nil then
        break
      end
      local character = M_HELPERS.LoadCharacter(memberKey)
      save.ActiveTeam.Players:Add(character)
      i = i + 1
    end

    M_HELPERS.LoadInventory(key)
  end,

  ClearInventory = function(override_cannot_drop)
    -- NOTE: Does not account for equipped items.
    local save = _DATA.Save
    local inv_count = save.ActiveTeam:GetInvCount() - 1

    -- remove bag items
    for i = inv_count, 0, -1 do
      local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(save.ActiveTeam:GetInv(i)
        .ID)
      if not entry.CannotDrop or override_cannot_drop then
        save.ActiveTeam:RemoveFromInv(i)
      end
    end
  end,

  --   function COMMON.ProcessOneTimeTreasure(orig_item, result_chest_item, save_var)
  --   local got_treasure = false
  --   --bag items
  --   local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
  --   for i = inv_count, 0, -1 do
  --   local item = _DATA.Save.ActiveTeam:GetInv(i)
  --     if item.ID == "box_deluxe" and item.HiddenValue == "empty" then
  --       item.HiddenValue = result_chest_item
  --       got_treasure = true
  --     end
  --     if item.ID == orig_item and item.HiddenValue == "empty" then
  --       save_var.TreasureTaken = true
  --       got_treasure = true
  --     end
  --   end

  --   --equips
  --   local player_count = _DATA.Save.ActiveTeam.Players.Count
  --   for i = 0, player_count - 1, 1 do
  --     local player = _DATA.Save.ActiveTeam.Players[i]
  --     if player.EquippedItem.ID == "box_deluxe" and player.EquippedItem.HiddenValue == "empty" then
  --       player.EquippedItem.HiddenValue = result_chest_item
  --       got_treasure = true
  --     end
  --     if player.EquippedItem.ID == orig_item and player.EquippedItem.HiddenValue == "empty" then
  --       save_var.TreasureTaken = true
  --       got_treasure = true
  --     end
  --   end

  --   return got_treasure
  -- end
  SaveInventory = function(key)
    -- NOTE: This function does not account for the equipped items of characters. Use SaveCharacter for that
    -- SV.SavedInventories = {}
    local inv_data = {}
    local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
    for i = 0, inv_count - 1 do
      local item = _DATA.Save.ActiveTeam:GetInv(i)
      local item_data = {}
      item_data.ID = item.ID
      item_data.HiddenValue = item.HiddenValue
      item_data.Cursed = item.Cursed
      item_data.Amount = item.Amount
      item_data.Price = item.Price
      table.insert(inv_data, item_data)
    end
    SV.SavedInventories[key] = inv_data
    -- print(Serpent.dump(SV.SavedInventories))
  end,

  LoadInventory = function(key)
    local save = _DATA.Save

    local inv_data = SV.SavedInventories[key] or {}
    M_HELPERS.ClearInventory(true)

    for _, item_data in ipairs(inv_data) do
      local item = RogueEssence.Dungeon.InvItem(item_data.ID, item_data.Cursed, item_data.Amount, item_data.Price)
      item.HiddenValue = item_data.HiddenValue
      save.ActiveTeam:AddToInv(item, true)
    end
  end,

  SaveCharacter = function(chara, key)
    SV.SavedCharacters = SV.SavedCharacters or {}
    local c_data = {}

    -- Following the format of making a clone of...
    -- https://github.com/RogueCollab/RogueEssence/blob/master/RogueEssence/Dungeon/Characters/CharData.cs#L13

    c_data.Nickname = chara.Nickname

    c_data.BaseForm = {}
    c_data.BaseForm.Species = chara.BaseForm.Species
    c_data.BaseForm.Form = chara.BaseForm.Form
    c_data.BaseForm.Skin = chara.BaseForm.Skin
    c_data.BaseForm.Gender = GenderToNum(chara.BaseForm.Gender)

    c_data.Level = chara.Level
    c_data.MaxHPBonus = chara.MaxHPBonus
    c_data.AtkBonus = chara.AtkBonus
    c_data.DefBonus = chara.DefBonus
    c_data.MAtkBonus = chara.MAtkBonus
    c_data.MDefBonus = chara.MDefBonus
    c_data.SpeedBonus = chara.SpeedBonus
    c_data.Unrecruitable = chara.Unrecruitable
    c_data.Skills = {}
    for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
      local skill = chara.BaseSkills[ii].SkillNum
      if skill ~= nil then
        table.insert(c_data.Skills, skill)
      end
    end

    c_data.BaseIntrinsics = {}
    for ii = 0, chara.BaseIntrinsics.Count - 1 do
      local intrinsic = chara.BaseIntrinsics[ii]
      table.insert(c_data.BaseIntrinsics, intrinsic)
    end

    c_data.FormIntrinsicSlot = chara.FormIntrinsicSlot

    c_data.Relearnables = {}
    for skill in luanet.each(chara.Relearnables.Keys) do
      local unlocked = chara.Relearnables[skill]
      c_data.Relearnables[skill] = unlocked
    end
    c_data.OriginalUUID = chara.OriginalUUID
    c_data.OriginalTeam = chara.OriginalTeam
    c_data.MetAt = chara.MetAt
    c_data.MetLoc = {}
    c_data.MetLoc.ID = chara.MetLoc.ID
    c_data.MetLoc.StructID = {}
    c_data.MetLoc.StructID.Segment = chara.MetLoc.StructID.Segment
    c_data.MetLoc.StructID.ID = chara.MetLoc.StructID.ID
    c_data.MetLoc.EntryPoint = chara.MetLoc.EntryPoint
    c_data.DefeatAt = chara.DefeatAt
    c_data.DefeatLoc = {}
    c_data.DefeatLoc.ID = chara.DefeatLoc.ID
    c_data.DefeatLoc.StructID = {}
    c_data.DefeatLoc.StructID.Segment = chara.DefeatLoc.StructID.Segment
    c_data.DefeatLoc.StructID.ID = chara.DefeatLoc.StructID.ID
    c_data.DefeatLoc.EntryPoint = chara.DefeatLoc.EntryPoint
    c_data.IsFounder = chara.IsFounder
    c_data.IsFavorite = chara.IsFavorite
    c_data.Discriminator = chara.Discriminator
    c_data.ActionEvents = {}

    -- NOTE: We only serialize BattleScriptEvent
    for battle_event in luanet.each(chara.ActionEvents) do
      if (LUA_ENGINE:TypeOf(battle_event) == luanet.ctype(BattleScriptEventType)) then
        local event = {}
        event.Script = battle_event.Script
        event.ArgTable = battle_event.ArgTable
        table.insert(c_data.ActionEvents, event)
      end
    end

    c_data.LuaDataTable = chara.LuaDataTable

    c_data.EquippedItem = {}
    c_data.EquippedItem.ID = chara.EquippedItem.ID
    c_data.EquippedItem.HiddenValue = chara.EquippedItem.HiddenValue
    c_data.EquippedItem.Cursed = chara.EquippedItem.Cursed
    c_data.EquippedItem.Amount = chara.EquippedItem.Amount
    c_data.EquippedItem.Price = chara.EquippedItem.Price

    SV.SavedCharacters[key] = c_data
    print(Serpent.dump(SV.SavedCharacters))
  end,

  LoadCharacter = function(key)
    local c_data = SV.SavedCharacters[key]
    local charData = RogueEssence.Dungeon.CharData()

    charData.Nickname = c_data.Nickname

    charData.BaseForm = RogueEssence.Dungeon.MonsterID(c_data.BaseForm.Species, c_data.BaseForm.Form,
      c_data.BaseForm.Skin, NumToGender(c_data.BaseForm.Gender))

    charData.Level = c_data.Level
    charData.MaxHPBonus = c_data.MaxHPBonus
    charData.AtkBonus = c_data.AtkBonus
    charData.DefBonus = c_data.DefBonus
    charData.MAtkBonus = c_data.MAtkBonus
    charData.MDefBonus = c_data.MDefBonus
    charData.SpeedBonus = c_data.SpeedBonus
    charData.Unrecruitable = c_data.Unrecruitable

    for i, skill in ipairs(c_data.Skills) do
      if i <= RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS then
        charData.BaseSkills[i - 1] = RogueEssence.Dungeon.SlotSkill(skill)
      end
    end
    for i, intrinsic in ipairs(c_data.BaseIntrinsics) do
      if i <= RogueEssence.Dungeon.CharData.MAX_INTRINSIC_SLOTS then
        charData.BaseIntrinsics[i - 1] = intrinsic
      end
    end
    charData.FormIntrinsicSlot = c_data.FormIntrinsicSlot

    for skill, unlocked in pairs(c_data.Relearnables) do
      charData.Relearnables:Add(skill, unlocked)
    end

    charData.OriginalUUID = c_data.OriginalUUID
    charData.OriginalTeam = c_data.OriginalTeam
    charData.MetAt = c_data.MetAt

    local metSegLoc = RogueEssence.Dungeon.SegLoc(c_data.MetLoc.StructID.Segment, c_data.MetLoc.StructID.ID)
    charData.MetLoc = RogueEssence.Dungeon.ZoneLoc(c_data.MetLoc.ID, metSegLoc, c_data.MetLoc.EntryPoint)
    charData.DefeatAt = c_data.DefeatAt

    local defeatSegLoc = RogueEssence.Dungeon
        .SegLoc(c_data.DefeatLoc.StructID.Segment, c_data.DefeatLoc.StructID.ID)
    charData.DefeatLoc = RogueEssence.Dungeon
        .ZoneLoc(c_data.DefeatLoc.ID, defeatSegLoc, c_data.DefeatLoc.EntryPoint)
    charData.IsFounder = c_data.IsFounder
    charData.IsFavorite = c_data.IsFavorite
    charData.Discriminator = c_data.Discriminator
    for _, event in ipairs(c_data.ActionEvents) do
      local battleEvent = RogueEssence.Dungeon.BattleScriptEvent(event.Script, event.ArgTable)
      charData.ActionEvents:Add(battleEvent)
    end

    charData.LuaDataTable = c_data.LuaDataTable

    local character = RogueEssence.Dungeon.Character(charData)

    local invItem = RogueEssence.Dungeon.InvItem(c_data.EquippedItem.ID, c_data.EquippedItem.Cursed,
      c_data.EquippedItem.Amount, c_data.EquippedItem.Price)

    invItem.HiddenValue = c_data.EquippedItem.HiddenValue
    character.EquippedItem = invItem

    return character
  end,

  AddStatus = function (chara, status_id)
    chara = chara or _DATA.Save.ActiveTeam.Leader
    local status = RogueEssence.Dungeon.StatusEffect(status_id)
    TASK:WaitTask(chara:AddStatusEffect(nil, status, true))
  end,

  UpgradeVariables = function()
    if SV.Wishmaker == nil then
      SV.Wishmaker = {
        RecruitedJirachi = false,
        MadeWish = false,
        RemoveBonusMoney = false,
        TempItemString = nil,
        BonusScore = 0
      }
    end


    if SV.Wishmaker.RecruitedJirachi == nil then SV.Wishmaker.RecruitedJirachi = false end
    if SV.Wishmaker.MadeWish == nil then SV.Wishmaker.MadeWish = false end
    if SV.Wishmaker.RemoveBonusMoney == nil then SV.Wishmaker.RemoveBonusMoney = false end


    if SV.SavedCharacters == nil then
      SV.SavedCharacters = {}
    end

    if SV.SavedInventories == nil then
      SV.SavedInventories = {}
    end

    

    if SV.EmberFrost == nil then
      SV.EmberFrost = {
        Enchantments = {
          Seen = {},
          Selected = {},
          Data = {},
          Collection = {},
          RerollCounts = {1, 1, 1},
        },

        Quests = {
          Active = {},
          Data = {},
        },
        LastFloor = 0,
        GotEnchantmentFromCheckpoint = false
      }


      InitializeEnchantmentCollection()
    end


    -- end
    -- if SV.EmberFrost.ShouldSwap == nil then SV.EmberFrost.ShouldSwap = false end
    -- if SV.EmberFrost.SelectedEnchantments == nil then SV.EmberFrost.SelectedEnchantments = {} end
    -- if SV.EmberFrost.RerollCounts == nil then SV.EmberFrost.RerollCounts = { 1, 1, 1 } end
    -- if SV.EmberFrost.SeenEnchantments == nil then SV.EmberFrost.SeenEnchantments = {} end

    -- if SV.EmberFrost.EnchantmentData == nil then
    --   SV.EmberFrost.EnchantmentData = {}
    -- end
    -- if SV.EmberFrost.GotEnchantmentFromCheckpoint == nil then SV.EmberFrost.GotEnchantmentFromCheckpoint = false end

    if SV.TemporaryFlags == nil then
      SV.TemporaryFlags = {
        OldDirection = nil
      }
    end

    SV.TemporaryFlags.OldDirection = nil
  end
}
