require 'origin.common'

function COMMON.ShowDestinationMenu(dungeon_entrances, ground_entrances, force_list, speaker, confirm_msg)
  
  local open_dests = {}
  --check for unlock of grounds
  for ii = 1,#ground_entrances,1 do
    if ground_entrances[ii].Flag then
	  local ground_id = ground_entrances[ii].Zone
	  local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(ground_id)
	  local ground = _DATA:GetGround(zone_summary.Grounds[ground_entrances[ii].ID])
	  local ground_name = ground:GetColoredName()
      table.insert(open_dests, { Name=ground_name, Dest=RogueEssence.Dungeon.ZoneLoc(ground_id, -1, ground_entrances[ii].ID, ground_entrances[ii].Entry) })
	end
  end
  
  --check for unlock of dungeons
  for ii = 1,#dungeon_entrances,1 do
    if GAME:DungeonUnlocked(dungeon_entrances[ii]) then
	local zone_summary = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get(dungeon_entrances[ii])
	  if zone_summary.Released then
	    local zone_name = ""
	    if _DATA.Save:GetDungeonUnlock(dungeon_entrances[ii]) == RogueEssence.Data.GameProgress.UnlockState.Completed then
		  zone_name = zone_summary:GetColoredName()
		else
		  zone_name = "[color=#00FFFF]"..zone_summary.Name:ToLocal().."[color]"
		end
        table.insert(open_dests, { Name=zone_name, Dest=RogueEssence.Dungeon.ZoneLoc(dungeon_entrances[ii], 0, 0, 0) })
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


    if dest.ID == "emberfrost_depths" then
      local player_count = GAME:GetPlayerPartyCount()
      if (player_count ~= 2) then
        UI:ResetSpeaker()
        local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("emberfrost_depths")
        UI:WaitShowDialogue("You need exactly two team members to enter " .. zone:GetColoredName() .. ".")
        return
      end
    end

    if confirm_msg ~= nil then
	    UI:WaitShowDialogue(confirm_msg)
	  end
	if dest.StructID.Segment > -1 then
	  --pre-loads the zone on a separate thread while we fade out, just for a little optimization
	  _DATA:PreLoadZone(dest.ID)
	  SOUND:PlayBGM("", true)
      GAME:FadeOut(false, 20)
	  GAME:EnterDungeon(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
	else
	  SOUND:PlayBGM("", true)
      GAME:FadeOut(false, 20)
	  GAME:EnterZone(dest.ID, dest.StructID.Segment, dest.StructID.ID, dest.EntryPoint)
	end
  end
end