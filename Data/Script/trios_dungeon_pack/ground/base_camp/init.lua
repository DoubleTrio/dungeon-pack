require 'origin.common'

local base_tbl = require('origin.ground.base_camp')

local base_camp = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function base_camp.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_base_camp")
  
  base_tbl.Init(map)
  base_camp.SpawnModCharacters()
  SOUND:PlayBGM("Top Menu - The Lost Continent.ogg", true)
end

function base_camp.SpawnModCharacters()
  if GAME:GetCurrentGround():GetMapChar("Oshawott") == nil then
    local monster_data = RogueEssence.Dungeon.MonsterID("oshawott", 0, "normal", RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(345, 423), Dir8.Down,
      "Oshawott")
    ground_char:ReloadEvents()
    GAME:GetCurrentGround():AddMapChar(ground_char)
  end
end

function base_camp.Ferry_Action(obj, activator)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  local ferry = CH('Lapras')
  UI:SetSpeaker(ferry)
  if not SV.base_camp.FerryIntroduced then
    UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_001']))
	SV.base_camp.FerryIntroduced = true
  end

  GAME:UnlockDungeon('wishmaker_cave')
  -- GAME:UnlockDungeon('adventurers_peak')
  -- 'adventurers_peak', 
  local dungeon_entrances = { 'lava_floe_island', 'castaway_cave', 'wishmaker_cave', 'eon_island', 'lost_seas', 'inscribed_cave', 'prism_isles' }
  local ground_entrances = {}
  
  UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_002']))
  
  COMMON.ShowDestinationMenu(dungeon_entrances,ground_entrances, true,
  ferry,
  STRINGS:Format(STRINGS.MapStrings['Ferry_Line_003']))

  -- UI:WaitShowDialogue("You need exactly two team members to enter Emberfrost Depths.")
end


function base_camp.Oshawott_Action(chara, activator)
  GAME:UnlockDungeon('emberfrost_depths')
  local oshawott = CH('Oshawott')

  local dungeon_entrances = { 'emberfrost_depths' }
  -- local ground_entrances = {}
  local ground_entrances = {}

  if not SV.EmberFrost.OshawottIntroduction then
    local name = _DATA:GetZone('emberfrost_depths'):GetColoredName()
    M_HELPERS.StartConversation(chara, "Oh,[pause=20] you must be here for " .. name .. "!", "Happy")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Now,[pause=20] please be sure to provide feedback on the dungeon and report any bugs to the developer.")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("It would mean a lot since it took many months to develop!")
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Now then...")
    SV.EmberFrost.OshawottIntroduction = true
  else
    UI:SetSpeakerEmotion("Normal")
    M_HELPERS.StartConversation(chara, "Alright,[pause=20] where would you like to travel to?")

    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("You don't really have a choice!")
  end
  UI:SetSpeakerEmotion("Normal")

  local function confirm_callback(dest)
    UI:SetSpeaker(chara)
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("You might wanna close your eyes!")

    GAME:WaitFrames(20)

    for i = 1, 3 do
      local teammate = CH("Teammate" .. i)
      if teammate then
        SOUND:PlayBattleSE("DUN_Trace")
        local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Yellow", 3))
        GROUND:PlayVFX(emitter, teammate.MapLoc.X + 7, teammate.MapLoc.Y + 6)
        GROUND:Hide("Teammate" .. i)
        GAME:WaitFrames(25)
      end
    end

    local player = CH("PLAYER")
    SOUND:PlayBattleSE("DUN_Trace")
    local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Yellow", 3))
    GROUND:PlayVFX(emitter, player.MapLoc.X + 7, player.MapLoc.Y + 6)
    GROUND:Hide("PLAYER")
    GAME:WaitFrames(50)

  end

  local function cancel_callback(dest)
    UI:SetSpeaker(chara)
    UI:SetSpeakerEmotion("Normal")
    UI:WaitShowDialogue("Need more time to think about it?")
    UI:SetSpeakerEmotion("Happy")
    UI:WaitShowDialogue("All good!")
    UI:SetSpeaker(chara)
  end

  base_camp.ShowDestinationMenuAlt(dungeon_entrances, ground_entrances, true, oshawott, confirm_callback, cancel_callback)
  M_HELPERS.EndConversation(chara)
end


function base_camp.ShowDestinationMenuAlt(dungeon_entrances, ground_entrances, force_list, speaker, confirm_callback, cancel_callback)
  local open_dests = {}
  for ii = 1, #ground_entrances, 1 do
    if ground_entrances[ii].Flag then
      local ground_id = ground_entrances[ii].Zone
      local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(ground_id)
      local ground = _DATA:GetGround(zone_summary.Grounds[ground_entrances[ii].ID])
      local ground_name = ground:GetColoredName()
      table.insert(open_dests,
        { Name = ground_name, Dest = RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_entrances[ii].ID,
          ground_entrances[ii].Entry) })
    end
  end
  for ii = 1, #dungeon_entrances, 1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
      local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
      if zone_summary.Released then
        local zone_name = ""
        if _DATA.Save:GetDungeonUnlock(dungeon_entrances[ii]) == RogueEssence.Data.GameProgress.UnlockState.Completed then
          zone_name = zone_summary:GetColoredName()
        else
          zone_name = "[color=#00FFFF]" .. zone_summary.Name:ToLocal() .. "[color]"
        end
        table.insert(open_dests, { Name = zone_name, Dest = RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
      end
    end
  end

  local dest = RogueEssence.Dungeon.ZoneLoc.Invalid
  if #open_dests > 1 or force_list then
    if before_list ~= nil then
      before_list(dest)
    end

    SOUND:PlaySE("Menu/Skip")
    default_choice = 1
    while true do
      UI:ResetSpeaker()
      UI:DestinationMenu(open_dests, default_choice)
      UI:WaitForChoice()
      default_choice = UI:ChoiceResult()

      if default_choice == nil then
        break
      end
      ask_dest = open_dests[default_choice].Dest
      if ask_dest.StructID.Segment >= 0 then
        --chosen dungeon entry
        if speaker ~= nil then
          UI:SetSpeaker(speaker)
        else
          UI:ResetSpeaker(false)
        end
        UI:DungeonChoice(open_dests[default_choice].Name, ask_dest)
        UI:WaitForChoice()
        if UI:ChoiceResult() then
          dest = ask_dest
          break
        end
      else
        dest = ask_dest
        break
      end
    end
  elseif #open_dests == 1 then
    if open_dests[1].Dest.StructID.Segment < 0 then
      --single ground entry
      if speaker ~= nil then
        UI:SetSpeaker(speaker)
      else
        UI:ResetSpeaker(false)
        SOUND:PlaySE("Menu/Skip")
      end
      UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_ENTER_GROUND", open_dests[1].Name))
      UI:WaitForChoice()
      if UI:ChoiceResult() then
        dest = open_dests[1].Dest
      end
    else
      --single dungeon entry
      if speaker ~= nil then
        UI:SetSpeaker(speaker)
      else
        UI:ResetSpeaker(false)
        SOUND:PlaySE("Menu/Skip")
      end
      UI:DungeonChoice(open_dests[1].Name, open_dests[1].Dest)
      UI:WaitForChoice()
      if UI:ChoiceResult() then
        dest = open_dests[1].Dest
      end
    end
  else
    PrintInfo("No valid destinations found!")
  end

  if dest:IsValid() then
    if confirm_callback ~= nil then
      confirm_callback(dest)
    end
    if dest.StructID.Segment > -1 then
      --pre-loads the zone on a separate thread while we fade out, just for a little optimization
      _DATA:PreLoadZone(dest.ID)
      SOUND:PlayBGM("", true)
      GAME:FadeOut(false, 20)
      GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint,
        RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
    else
      SOUND:PlayBGM("", true)
      GAME:FadeOut(false, 20)
      GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
    end
  else
    cancel_callback()
  end
end
return base_camp