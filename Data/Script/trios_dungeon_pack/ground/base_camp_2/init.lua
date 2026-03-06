require 'origin.common'

require 'trios_dungeon_pack.GeneralFunctions'

local base_camp_2_tbl = require('origin.ground.base_camp_2')

local base_camp_2_mod = {}
--------------------------------------------------
-- Map Callbacks
--------------------------------------------------
function base_camp_2_mod.Init(map)
  DEBUG.EnableDbgCoro() --Enable debugging this coroutine
  PrintInfo("=>> Init_base_camp2")
  -- PrintInfo("tjejejeje")

  base_camp_2_tbl.Init(map)
  SV.Debug = true
  -- SOUND:PlayBGM("Top Menu - The Lost Continent.ogg", false)
end

function base_camp_2_mod.Enter(map)
  DEBUG.EnableDbgCoro()



  --   local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
  --   GeneralFunctions.MoveCharAndCamera(partner, 264, 112, false, 1)
  --   TASK:JoinCoroutines({ coro1 })


  -- base_camp_2_tbl.Enter(map)
  -- GAME:FadeOut(false, 10)
  if (SV.Debug) then
    base_camp_2_mod.DebugSpawnCharacters()
    base_camp_2_mod.DebugCutscene()
  end
  GAME:FadeIn(20)
end

function base_camp_2_mod.DebugSpawnCharacters()
  if GAME:GetCurrentGround():GetMapChar("Dratini") == nil then
    local monster_data = RogueEssence.Dungeon.MonsterID("dratini", 0, "normal", RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(-10, 566), Dir8.Right,
      "Dratini")
    ground_char:ReloadEvents()
    GAME:GetCurrentGround():AddMapChar(ground_char)
  end

  if GAME:GetCurrentGround():GetMapChar("Farfetch'd") == nil then
    local monster_data = RogueEssence.Dungeon.MonsterID("farfetchd", 0, "normal", RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(-35, 566), Dir8.Right,
      "Farfetch'd")
    ground_char:ReloadEvents()

    -- print(tostring(_ZONE.CurrentGround))
    GAME:GetCurrentGround():AddMapChar(ground_char)
  end

  if GAME:GetCurrentGround():GetMapChar("Snivy") == nil then
    local monster_data = RogueEssence.Dungeon.MonsterID("snivy", 0, "normal", RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(-70, 566), Dir8.Right,
      "Snivy")
    ground_char:ReloadEvents()

    -- print(tostring(_ZONE.CurrentGround))
    GAME:GetCurrentGround():AddMapChar(ground_char)
  end

  
  if GAME:GetCurrentGround():GetMapChar("Oshawott") == nil then
    local monster_data = RogueEssence.Dungeon.MonsterID("oshawott", 0, "normal", RogueEssence.Data.Gender.Male)
    local ground_char = RogueEssence.Ground.GroundChar(monster_data, RogueElements.Loc(108, 528), Dir8.Down,
      "Oshawott")
    ground_char:ReloadEvents()


    GAME:GetCurrentGround():AddMapChar(ground_char)
    GROUND:Hide("Oshawott")
  end
end

function base_camp_2_mod.DebugCutscene()
  GAME:CutsceneMode(true)
  GROUND:Hide("PLAYER")
  GAME:WaitFrames(30)



  local dratini = CH('Dratini')
  local dratini_name = dratini:GetDisplayName()
  local farfetchd = CH("Farfetch'd")
  local farfetchd_name = farfetchd:GetDisplayName()
  local snivy = CH('Snivy')
  local snivy_name = snivy:GetDisplayName()
  local kec = CH("Shop_Owner")
  local oshawott = CH('Oshawott')



  local zone =_DATA:GetZone("wishmaker_cave")
  local zone_name = zone:GetColoredName()

  local coro1 = TASK:BranchCoroutine(
    function ()
      GAME:FadeIn(20)
    end
  )

  local coro2 = TASK:BranchCoroutine(function() 
    GROUND:MoveToPosition(dratini, 134, 566, false, 1)
    GAME:WaitFrames(20)
    GROUND:CharTurnToCharAnimated(dratini, snivy, 4)

  end)
  local coro3 = TASK:BranchCoroutine(function() 
    GROUND:MoveToPosition(farfetchd, 134 - 25, 566, false, 1)
    GAME:WaitFrames(10)
    GROUND:CharTurnToCharAnimated(farfetchd, snivy, 4)
  end)

  local coro4 = TASK:BranchCoroutine(function() 

    GROUND:MoveToPosition(snivy, -20, 566, false, 1) 
    
    GROUND:MoveInDirection(snivy, Direction.Right, 20, false, 1)
    GAME:WaitFrames(30)
    GROUND:MoveInDirection(snivy, Direction.Right, 20, false, 1)
    GAME:WaitFrames(30)
    GROUND:MoveInDirection(snivy, Direction.Right, 20, false, 1)
    GAME:WaitFrames(30)

    GROUND:MoveInDirection(snivy, Direction.Right, 14, false, 1)
    GAME:WaitFrames(20)
    SOUND:PlayBattleSE("EVT_Emote_Sweating")
    GROUND:CharSetEmote(snivy, "sweating", 1)
    GAME:WaitFrames(30)


  end)

  local coro5 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(90)
    
    UI:SetSpeaker(snivy)
    UI:SetSpeakerEmotion("Worried")
    -- M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Middle, Vertical = PVerticalPosition.Top, FaceLeft = false })
    UI:WaitShowTimedDialogue(
      string.format("[speed=1.0]%s,[pause=20] this better be worth my time or else I'm going back to bed.", dratini_name),
    100)

  end)


  local coro6 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(220)
    GROUND:CharTurnToCharAnimated(kec, dratini, 4)
  end)

  -- local map_width = GAME:GetCurrentGround().GroundWidth
  -- local map_height = GAME:GetCurrentGround().GroundHeight
  -- GROUND:TeleportTo(hoopa, map_width / 2 - 6, hoopa.Position.Y, hoopa.CharDir)

  -- local coro1 = TASK:BranchCoroutine(function() GAME:MoveCamera(map_width / 2 - 6, 460, 100, false) end)
  -- local coro2 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(player, map_width / 2 - 6, 420, false, 1) end)

  TASK:JoinCoroutines({ coro1, coro2, coro3, coro4, coro5, coro6 })


  GAME:WaitFrames(20)


  -- local animId = RogueEssence.Content.GraphicsManager.GetAnimIndex("Pain")
  
  -- GROUND:CharSetAction(snivy,
  -- RogueEssence.Ground.FrameGroundAction(snivy.Position, snivy.LocHeight, Direction.Down, animId, 5))

  -- GROUND:CharSetAction(snivy,
  -- RogueEssence.Ground.FrameGroundAction(snivy.Position, snivy.LocHeight, Direction.Down, animId, 5))


  
  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Happy")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  GROUND:CharTurnToCharAnimated(farfetchd, dratini, 4)
  GROUND:CharSetEmote(dratini, "glowing", 4)
  UI:WaitShowTimedDialogue("[speed=1.0]Oh-ho-ho,[pause=20] you're gonna love today's adventure!", 80)
  UI:WaitShowTimedDialogue("[speed=1.0]I recently got wind that there's a dungeon that grants you wishes if you have a special...", 40)


  local coro02 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(rexio, "Pain", false)
    GAME:WaitFrames(30)
    GROUND:CharSetAnim(rexio, "Idle", false)
  end)


  GROUND:CharTurnToCharAnimated(farfetchd, snivy, 4)
  UI:ResetSpeaker()
  UI:SetSpeaker(snivy)
  UI:SetSpeakerEmotion("Happy")

  UI:WaitShowTimedDialogue("[speed=1.0]Oh,[pause=10] you mean " .. zone_name .."?", 50)


  UI:WaitShowTimedDialogue(
  "[speed=1.0]You mean the place that " ..
  M_HELPERS.MakeColoredText("Lapras", PMDColor.Cyan) .. " can take us to and only two of us can go.", 120)

  -- SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
  -- GROUND:CharSetEmote(chara, "exclaim", 1)
  
  
  SOUND:PlayBattleSE('EVT_Emote_Shock_2')
  GeneralFunctions.EmoteAndPause(dratini, "Shock", false)
  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })

  GROUND:CharTurnToCharAnimated(farfetchd, dratini, 4)

  UI:WaitShowTimedDialogue("[speed=1.0]What?[pause=20] When?[pause=20] How do you know about " .. zone_name .. "?",
  120)

  GROUND:CharTurnToCharAnimated(farfetchd, snivy, 4)
  UI:ResetSpeaker()
  UI:SetSpeaker(snivy)
  UI:SetSpeakerEmotion("Normal")
  UI:WaitShowTimedDialogue("[speed=1.0]It's a dungeon that grants you wishes,[pause=40] " .. dratini_name ..  ".[pause=20] Wishes!", 60)
  UI:SetSpeakerEmotion("Happy")

  GeneralFunctions.Hop(snivy)
  GROUND:CharSetEmote(snivy, "happy", 4)
  UI:WaitShowTimedDialogue("[speed=1.0]Of course I know about it!", 100)

  

  SOUND:PlayBattleSE("EVT_Emote_Sweatdrop")
  GROUND:CharSetEmote(dratini, "sweatdrop", 1)
  GAME:WaitFrames(60)


  GROUND:CharTurnToCharAnimated(farfetchd, dratini, 4)
  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]...And you decided not to tell neither of us...", 80)


  UI:SetSpeaker(farfetchd)
  UI:SetSpeakerEmotion("Sigh")
  M_HELPERS.SetSpeakerPosition({ Vertical = PVerticalPosition.Top, Horizontal = PHorizontalPosition.Middle })
  UI:WaitShowTimedDialogue("[speed=0.3]Pfffftt.[pause=20] [speed=1.0]Guys, " .. zone_name .. " is such old news.", 80)


  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]...You also know about it?", 80)


  coro1 = TASK:BranchCoroutine(function()
    UI:SetSpeaker(farfetchd)
    UI:SetSpeakerEmotion("Normal")
    M_HELPERS.SetSpeakerPosition({ Vertical = PVerticalPosition.Top, Horizontal = PHorizontalPosition.Middle })
    UI:WaitShowTimedDialogue("[speed=1.0]Yerp,[pause=20] it's been two years since it's discovery.", 80)


    UI:SetSpeakerEmotion("Sigh")
    UI:WaitShowTimedDialogue("[speed=1.0]All the hype and glory of the dungeon is long gone now.", 80)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(80)


    GROUND:CharAnimateTurn(farfetchd, Direction.Down, 4, false)

    GAME:WaitFrames(180)
    GROUND:CharSetEmote(snivy, "sweatdrop", 1)


  end)

  TASK:JoinCoroutines({ coro1, coro2 })


  GAME:WaitFrames(50)
  GROUND:CharTurnToCharAnimated(farfetchd, dratini, 4)
  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]Really?[pause=20] I can't believe you two knew about the dungeon before I did.", 80)
  UI:WaitShowTimedDialogue("[speed=1.0]I guess I can scout around for any new dungeons today.", 80)
  UI:ResetSpeaker()



  UI:SetSpeaker(snivy)
  UI:SetSpeakerEmotion("Happy")
  UI:WaitShowTimedDialogue(
  "[speed=1.0]While you're looking for a new dungeon,[pause=20] I'll head back to bed.", 60)
  UI:SetSpeakerEmotion("Happy")

  UI:ResetSpeaker()
  SOUND:FadeOutBGM(60)
  GAME:WaitFrames(80)

  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)
  UI:WaitShowTimedDialogue("[speed=1.0] Did somebody say...[pause=20]" .. M_HELPERS.MakeColoredText(" NEW DUNGEON", PMDColor.Yellow) .. "?", 80)



  coro1 = TASK:BranchCoroutine(function()
    GeneralFunctions.LookAround(snivy, 2, 4)
  end)
  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.LookAround(dratini, 2, 4)
  end)
  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GeneralFunctions.LookAround(farfetchd, 3, 4)
    GROUND:CharAnimateTurnTo(farfetchd, Direction.Up, 4)
  end)

  TASK:JoinCoroutines({ coro1, coro2, coro3 })



  GAME:WaitFrames(20)
  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]...Did anyone else hear that?", 80)
  
  GROUND:CharTurnToCharAnimated(farfetchd, dratini, 4)

  
  GAME:WaitFrames(20)
  
  coro1 = TASK:BranchCoroutine(function()
    GROUND:CharSetAnim(snivy, "Nod", false)
    -- GeneralFunctions.DoAnimation(snivy, "Nod")
    GAME:WaitFrames(10)
    GROUND:CharSetAnim(snivy, "Nod", false)
    -- GeneralFunctions.DoAnimation(snivy, "Nod")
  end)

  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(5)
    -- Farfetch'd doesn't have nod yet... :( 
    -- GeneralFunctions.DoAnimation(farfetchd, "Nod") 
    -- GROUND:CharSetAnim(farfetchd, "Nod", false)
    -- GAME:WaitFrames(10)
    -- GROUND:CharSetAnim(farfetchd, "Nod", false)
    -- GeneralFunctions.DoAnimation(farfetchd, "Nod")
  end)
  TASK:JoinCoroutines({ coro1, coro2 })

  GAME:WaitFrames(20)

  -- SOUND:FadeInSE("Raise Up Your Bat - Cut", 60)

  SOUND:PlayBGM("Raise Up Your Bat - Cut.ogg", true)
  GAME:WaitFrames(100)


  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]...Guys,[pause=20] where did the music come from?", 80)
  UI:SetSpeaker(STRINGS:Format("\\uE040"), true, "", -1, "", RogueEssence.Data.Gender.Unknown)

  -- GAME:WaitFrames(16)
  -- GROUND:PlayVFX(emitter, center.X, center.Y)
  -- SOUND:PlayBattleSE("EVT_Battle_Flash")
  -- GAME:WaitFrames(46)

  -- SOUND:PlayBattleSE('EVT_Battle_Transition')
  -- COMMON.MakeWhoosh(center, -32, 0, false)
  -- GAME:WaitFrames(5)
  -- COMMON.MakeWhoosh(center, -64, 0, true)
  -- COMMON.MakeWhoosh(center, 0, 0, true)
  -- GAME:WaitFrames(5)
  -- COMMON.MakeWhoosh(center, -112, 1, false)
  -- COMMON.MakeWhoosh(center, 48, 1, false)
  -- GAME:WaitFrames(5)
  -- COMMON.MakeWhoosh(center, -144, 2, true)
  -- COMMON.MakeWhoosh(center, 80, 2, true)
  -- GAME:WaitFrames(5)
  -- COMMON.MakeWhoosh(center, -176, 3, false)
  -- COMMON.MakeWhoosh(center, 112, 3, false)
  -- GAME:WaitFrames(40)
  -- GAME:FadeOut(true, 30)
  -- GAME:WaitFrames(80)


  -- UI:S


  coro1 = TASK:BranchCoroutine(function()
    SOUND:PlayBattleSE("DUN_Trace")
    local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Puff_Yellow", 3))
    GROUND:PlayVFX(emitter, oshawott.MapLoc.X + 7, oshawott.MapLoc.Y + 6)
    GROUND:Unhide("Oshawott")
    GeneralFunctions.Hop(oshawott)
    UI:SetSpeaker(oshawott)

    UI:SetSpeakerEmotion("Happy")
    M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Middle, Vertical = PVerticalPosition.Top, FaceLeft = true })
    UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby!", 80)
    local function hop()
      GeneralFunctions.Hop(oshawott)
    end

    M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Middle, Vertical = PVerticalPosition.Top, FaceLeft = true })

    UI:WaitShowTimedDialogue(
    "[speed=1.0]You want a new dungeon to explore,[pause=20][emote=Joyous][script=0] I've got a new dungeon for you!", 80,
      { hop })
  end)

  coro2 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(15)
    GROUND:CharTurnToCharAnimated(farfetchd, oshawott, 4)
  end)

  coro3 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(10)
    GROUND:CharTurnToCharAnimated(dratini, oshawott, 4)
    GROUND:CharSetEmote(dratini, "exclaim", 1)
  end)

  coro4 = TASK:BranchCoroutine(function()
    GAME:WaitFrames(5)
    GeneralFunctions.Hop(snivy)
    GROUND:CharTurnToCharAnimated(snivy, oshawott, 4)
  end)


  TASK:JoinCoroutines({ coro1, coro2, coro3, coro4 })

  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=0.7]...Who are you and where did you come from?", 60)


  GeneralFunctions.Hop(oshawott)
  UI:SetSpeaker(oshawott)
  UI:SetSpeakerEmotion("Happy")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Middle, Vertical = PVerticalPosition.Top, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]Cue the montage baby!", 60)

  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=0.5]...Who are you talking to?", 40)


  UI:SetSpeaker(farfetchd)
  UI:SetSpeakerEmotion("Happy")
  M_HELPERS.SetSpeakerPosition({ Vertical = PVerticalPosition.Top, Horizontal = PHorizontalPosition.Middle })
  UI:WaitShowTimedDialogue("[speed=1.0]You know,[pause=20] I kinda like your...", 30)


  GeneralFunctions.Hop(oshawott)
  UI:SetSpeaker(oshawott)
  UI:SetSpeakerEmotion("Happy")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Middle, Vertical = PVerticalPosition.Top, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=1.0]I said cue the montage!", 20)

  UI:SetSpeaker(dratini)
  UI:SetSpeakerEmotion("Stunned")
  M_HELPERS.SetSpeakerPosition({ Horizontal = PHorizontalPosition.Right, FaceLeft = true })
  UI:WaitShowTimedDialogue("[speed=0.5]Wha...", 60)



  -- UI:WaitShowDialogue(
  -- "Cool desert,[script=0][pause=40] over there nya,[script=1][pause=40] my important treasure is guarded by really bad people and we nyeeeeeed it.",
  --   { cat1turn, cat2turn })
  -- UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby, odhdhdh!", 80)
  -- UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby, odhdhdh!", 80)
  -- UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby!", 80)
  -- UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby!", 80)
  -- UI:WaitShowTimedDialogue("[speed=1.0]I'm back baby!", 80)




  -- local anim = RogueEssence.Dungeon.CharAbsentAnim(player.CharLoc, player.CharDir)
  -- GeneralFunctions.RemoveCharEffects(player)
  -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))
  -- TASK:WaitTask(player:StartAnim(anim))


-- [Oshawott]: I’m back baby!
-- [Oshawott]: You want a new dungeon, I’ve got a new dungeon for you 

  -- UI:WaitShowTimedDialogue("[speed=1.0]Blasted Invisibility Orb... I shall appear dramatically in 3, 2, 1", 80)






  -- [Dratini]: Really? I can’t believe you two knew about the dungeon before I did. I guess I can scout around for any new dungeons today.



  
  
    




  

  -- local emitter = RogueEssence.Content.FlashEmitter()
  -- emitter.FadeInTime = 2
  -- emitter.HoldTime = 2
  -- emitter.FadeOutTime = 2
  -- emitter.StartColor = Color(0, 0, 0, 0)
  -- emitter.Layer = DrawLayer.Top
  -- emitter.Anim = RogueEssence.Content.BGAnimData("White", 0)
  -- GROUND:PlayVFX(emitter, center.X, center.Y)

  -- function test2()

  -- end

  -- function test3()
  --   SOUND:PlayBattleSE("DUN_Explosion")
  --   emitter = RogueEssence.Content.FiniteAreaEmitter(RogueEssence.Content.AnimData("Explosion", 3))
  --   emitter.Range = 20
  --   emitter.Speed = 72
  --   emitter.TotalParticles = 2
  --   GROUND:PlayVFX(emitter, activator.MapLoc.X, activator.MapLoc.Y)
  --   GAME:WaitFrames(60)
  -- end



--   local coro1 = TASK:BranchCoroutine(function() test_grounds.Walk_Sequence(partner1) end)
-- local coro2 = TASK:BranchCoroutine(function() test_grounds.Walk_Sequence(partner2) end)
-- GROUND:MoveInDirection(player, Direction.Up, 72, false, 2)
-- GROUND:CharAnimateTurn(player, Direction.DownLeft, 4, false)
 
-- TASK:JoinCoroutines({coro1,coro2})



    -- local coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
    -- local coro2 = TASK:BranchCoroutine(function()
    --   GROUND:CharSetEmote(partner, "exclaim", 1)
    --   GROUND:CharTurnToCharAnimated(partner, hero, 4)
    -- end)
    -- TASK:JoinCoroutines({ coro1, coro2 })
  -- snivy
-- 
  -- GAME:FadeIn(20)

  GROUND:Unhide("PLAYER")
  GAME:CutsceneMode(false)
end

-- function altere_pond_ch_1.PrologueGoToRelicForest()
--   --Cutscene where partner enters Relic Forest after passing by the guild
--   --local hero = GAME:GetPartyMember(1)--and send the hero to assembly for now
--   --GAME:RemovePlayerTeam(1)
--   --GAME:AddPlayerAssembly(hero)
--   --COMMON.RespawnAllies()

--   local partner = CH('Teammate1')
--   local zone = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("relic_forest")
--   --print(partner:GetDisplayName())
--   GROUND:Hide(CH('PLAYER').EntName)
--   GROUND:Hide('East_Exit') --hide entrance prompt to go into relic forest
--   GAME:CutsceneMode(true)
--   AI:DisableCharacterAI(partner)
--   UI:ResetSpeaker()
--   GAME:MoveCamera(272, 8, 1, false)
--   GROUND:TeleportTo(partner, 264, -32, Direction.Down)
--   GAME:FadeIn(40)



--   local coro1 = TASK:BranchCoroutine(function() GAME:FadeIn(40) end)
--   GeneralFunctions.MoveCharAndCamera(partner, 264, 112, false, 1)
--   TASK:JoinCoroutines({ coro1 })

--   GeneralFunctions.MoveCharAndCamera(partner, 312, 112, false, 1)
--   GeneralFunctions.MoveCharAndCamera(partner, 312, 128, false, 1)
--   GAME:WaitFrames(20)

--   UI:SetSpeaker(partner)
--   --GeneralFunctions.LookAround(partner, 2, 4, false, false, GeneralFunctions.RandBool(), Direction.Down)
--   UI:SetSpeakerEmotion("Sad")
--   UI:WaitShowDialogue(".........")
--   UI:WaitShowDialogue("Everytime I walk past the guild I get like this...")
--   UI:WaitShowDialogue("It's hard not to feel down whenever it comes into my mind...")
--   UI:WaitShowDialogue("I want to become an adventurer so badly,[pause=10] but...")
--   UI:WaitShowDialogue(".........")
--   GAME:WaitFrames(20)
--   GeneralFunctions.ShakeHead(partner)
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Sad")
--   UI:WaitShowDialogue("Well,[pause=10] dwelling on it isn't going to do anything but make me feel worse.")
--   UI:WaitShowDialogue("Exploring the forest should help take my mind off it.")
--   GAME:WaitFrames(20)

--   --walk down the steps
--   GeneralFunctions.MoveCharAndCamera(partner, 312, 320, false, 1)


-- function GeneralFunctions.MoveCharAndCamera(chara, x, y, run, charSpeed, cameraFrames)
--   --remember Relicanth is there
--   local oldman = CH("Relicanth")
--   GROUND:CharSetAnim(oldman, 'Idle', true)
--   UI:SetSpeakerEmotion("Surprised")
--   GROUND:CharSetEmote(partner, "exclaim", 1)
--   SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
--   UI:WaitShowDialogue("Oh![pause=0] I almost forgot!")
--   --print(oldman:GetDisplayName())
--   GAME:WaitFrames(20)

--   --Move camera to show relicanth, then move back
--   coro1 = TASK:BranchCoroutine(GAME:_MoveCamera(544, 328, 112, false))
--   GROUND:CharTurnToCharAnimated(partner, oldman, 4)
--   TASK:JoinCoroutines({ coro1 })
--   GAME:WaitFrames(120)
--   GAME:MoveCamera(320, 328, 116, false)

--   --Remember that relicanth told you not to go in the forest
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Worried")
--   SOUND:PlayBattleSE('EVT_Emote_Sweating')
--   GROUND:CharSetEmote(partner, "sweating", 1)
--   GAME:WaitFrames(40)
--   UI:WaitShowDialogue("I can't let " .. oldman:GetDisplayName() .. " see me go into the forest.")
--   --[[this spot of dialogue commented out for being redundant with some things the partner tells the player later
-- 	UI:WaitShowDialogue("Last time he caught me I got an earful about how dangerous it is...")
-- 	UI:WaitShowDialogue('Something about ancient,[pause=10] powerful forces sleeping within there...')--foreshadow: the hero is the thing referred to here in a way.
	
-- 	GAME:WaitFrames(20)
-- 	--GROUND:CharSetEmote(partner, "question", 1)
-- 	--SOUND:PlayBattleSE("EVT_Emote_Confused")
-- 	--GAME:WaitFrames(40)
-- 	GROUND:CharAnimateTurnTo(partner, Direction.UpRight, 4)
-- 	UI:SetSpeakerEmotion("Worried")
-- 	UI:WaitShowDialogue("But I've been there plenty of times and nothing bad's ever happened.")


-- 	--Remember that you don't give a shit what relicanth has to say
-- 	UI:SetSpeakerEmotion("Normal")
-- 	GAME:WaitFrames(20)
-- 	--TODO:make him do a little jump
-- 	GROUND:CharAnimateTurnTo(partner, Direction.Right, 4)
-- 	UI:WaitShowDialogue("That old coot is always overexaggerating...[br]Something like that could never be right next to town.")
-- 	UI:SetSpeakerEmotion("Happy")
-- 	GROUND:CharSetEmote(partner, "glowing", 0)
-- 	UI:WaitShowDialogue("Besides,[pause=10] it's too much fun exploring in there to pass up anyway!")
-- 	GAME:WaitFrames(20)
-- 	GROUND:CharSetEmote(partner, "", 0)
-- 	GAME:WaitFrames(20)
-- 	GROUND:CharAnimateTurn(partner, Direction.Down, 4, false)
-- 	GeneralFunctions.LookAround(partner, 3, 4, true, false, GeneralFunctions.RandBool(), Direction.Down)
-- 	UI:SetSpeakerEmotion("Normal")
-- 	UI:WaitShowDialogue("I am going to need to sneak around though.[pause=0] I don't want " .. oldman:GetDisplayName() .. " seeing me.")
-- 	]] --

--   --sneak off towards the treeline, fade to black
--   GROUND:CharAnimateTurn(partner, Direction.DownLeft, 4, false)
--   GAME:WaitFrames(16)
--   UI:WaitShowDialogue("I need to stick to the trees so he won't spot me.")
--   GAME:WaitFrames(20)

--   coro1 = TASK:BranchCoroutine(function() GROUND:MoveToPosition(partner, 224, 400, false, 1) end)
--   GAME:WaitFrames(40)
--   GAME:FadeOut(false, 40)
--   TASK:JoinCoroutines({ coro1 })

--   GAME:WaitFrames(60)


--   --Fade back in by the entrance to the forest
--   GAME:MoveCamera(840, 312, 1, false)
--   GROUND:TeleportTo(partner, 840, 432, Direction.Up)
--   GAME:FadeIn(60)
--   GROUND:MoveToPosition(partner, 840, 336, false, 1)

--   --look all around
--   GeneralFunctions.LookAround(partner, 5, 4, true, false, GeneralFunctions.RandBool(), Direction.Left)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("Looks like he didn't notice.[pause=0] Now I won't have to hear him later...")
--   GROUND:CharAnimateTurn(partner, Direction.Right, 4, false)
--   GAME:WaitFrames(20)

--   UI:WaitShowDialogue("I need to head on into " .. zone:GetColoredName() .. " before he looks my way.")
--   GAME:WaitFrames(20)

--   --[[ removed as partner doesn't really need to hint that they're about to find the player
-- 	GAME:WaitFrames(20)
-- 	UI:SetSpeakerEmotion("Normal")
-- 	UI:WaitShowDialogue(zone:GetColoredName() .. "...")
-- 	UI:WaitShowDialogue("I've explored here a bunch of times before.[pause=0] It's usually pretty uneventful...")
-- 	UI:SetSpeakerEmotion("Worried")
-- 	UI:WaitShowDialogue("...Odds are that'll be the case again...")
-- 	GAME:WaitFrames(20)
	
-- 	UI:SetSpeakerEmotion("Normal")
-- 	UI:WaitShowDialogue("But who knows?[pause=0] In a mystery dungeon,[pause=10] you never know what you might find!")
-- 	UI:WaitShowDialogue("Maybe this time it'll be different?")
-- 	GAME:WaitFrames(20)
-- 	UI:SetSpeakerEmotion("Happy")
-- 	UI:WaitShowDialogue("Only one way to find out!")
-- 	GAME:WaitFrames(20)
-- ]] --

--   GROUND:MoveToPosition(partner, 880, 336, false, 1)
--   GROUND:MoveToPosition(partner, 936, 280, false, 1)
--   SOUND:FadeOutBGM()
--   GAME:FadeOut(false, 40)

--   SV.Chapter1.PartnerEnteredForest = true

--   --move hero to assembly for first dungeon
--   local p = GAME:GetPlayerPartyMember(0)
--   GAME:RemovePlayerTeam(0)
--   GAME:AddPlayerAssembly(p)

--   --Append [color=#FFFF00] [color] to partner name so their name stays yellow while they're the leader; this will be removed at the start of the relic forest arrival script
--   GAME:SetCharacterNickname(GAME:GetPlayerPartyMember(0),
--     "[color=#FFFF00]" .. GAME:GetCharacterNickname(GAME:GetPlayerPartyMember(0)) .. "[color]")

--   --enter dungeon
--   GAME:CutsceneMode(false)
--   GAME:UnlockDungeon("relic_forest")
--   GAME:EnterDungeon("relic_forest", 0, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, true)
--   --GAME:EnterGroundMap("relic_forest", "Main_Entrance_Marker")
-- end

-- function COMMON.RespawnStarterPartner()
--   -- SV.test_grounds.Starter.Gender = LUA_ENGINE:EnumToNumeric(Gender.Female)
--   local character = RogueEssence.Dungeon.CharData()
--   character.BaseForm = RogueEssence.Dungeon.MonsterID(SV.eontestroom.Starter.Species, SV.eontestroom.Starter.Form,
--     SV.eontestroom.Starter.Skin, LUA_ENGINE:LuaCast(SV.eontestroom.Starter.Gender, Gender))
--   GROUND:SetPlayer(character)
--   GROUND:RemoveCharacter("Partner")
--   local p = RogueEssence.Dungeon.CharData()
--   p.BaseForm = RogueEssence.Dungeon.MonsterID(SV.eontestroom.Partner.Species, SV.eontestroom.Partner.Form,
--     SV.eontestroom.Partner.Skin, LUA_ENGINE:LuaCast(SV.eontestroom.Partner.Gender, Gender))
--   GROUND:SpawnerSetSpawn("PARTNER_SPAWN", p)
--   local chara = GROUND:SpawnerDoSpawn("PARTNER_SPAWN")
-- end
-- function base_camp.Ferry_Action(obj, activator)
--   DEBUG.EnableDbgCoro() --Enable debugging this coroutine
--   local ferry = CH('Lapras')
--   UI:SetSpeaker(ferry)
--   if not SV.base_camp.FerryIntroduced then
--     UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_001']))
--     SV.base_camp.FerryIntroduced = true
--   end

--   GAME:UnlockDungeon('wishmaker_cave')
--   GAME:UnlockDungeon('adventurers_peak')
--   GAME:UnlockDungeon('emberfrost_depths')
--   local dungeon_entrances = { 'lava_floe_island', 'castaway_cave', 'wishmaker_cave', 'adventurers_peak',
--     'emberfrost_depths', 'eon_island', 'lost_seas', 'inscribed_cave', 'prism_isles' }
--   local ground_entrances = {}

--   UI:WaitShowDialogue(STRINGS:Format(STRINGS.MapStrings['Ferry_Line_002']))

--   COMMON.ShowDestinationMenu(dungeon_entrances, ground_entrances, true,
--     ferry,
--     STRINGS:Format(STRINGS.MapStrings['Ferry_Line_003']))

--   -- UI:WaitShowDialogue("You need exactly two team members to enter Emberfrost Depths.")
-- end

--TASK:BranchCoroutine(guild_guildmasters_room_ch_1.MeetGuildmaster)
-- function guild_guildmasters_room_ch_1.MeetGuildmaster()
--   local partner = CH('Teammate1')
--   local hero = CH('PLAYER')
--   local tropius = CH('Tropius')
--   GAME:CutsceneMode(true)
--   AI:DisableCharacterAI(partner)
--   UI:ResetSpeaker()
--   GAME:MoveCamera(192, 112, 1, false)
--   GROUND:EntTurn(tropius, Direction.Up)

--   local box = RogueEssence.Ground.GroundObject(RogueEssence.Content.ObjAnimData("Yellow_Box", 1), --anim data. Don't set that number to 0 for valid anims
--     RogueElements.Rect(184, 144, 16, 16),                                                        --xy coords, then size
--     RogueElements.Loc(4, 14),                                                                    --offset
--     true,
--     "Yellow_Box")                                                                                --object entity name
--   box:ReloadEvents()
--   GAME:GetCurrentGround():AddTempObject(box)
--   GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 0, 0, Direction.Down)
--   GROUND:Hide(box.EntName)
--   local noctowl =
--       CharacterEssentials.MakeCharactersFromList({
--         { "Noctowl", 184, 288, Direction.Up }
--       })

--   GROUND:TeleportTo(hero, 168, 344, Direction.Up)
--   GROUND:TeleportTo(partner, 200, 344, Direction.Up)

--   GAME:FadeIn(40)

--   GAME:WaitFrames(60)
--   UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form,
--     tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("Hmm...[pause=0] Two prospective teams in one day...")
--   UI:WaitShowDialogue("I don't think that's ever happened before.")

--   local coro1 = TASK:BranchCoroutine(function()
--     GROUND:MoveToPosition(noctowl, 184, 224, false, 1)
--     GeneralFunctions.EightWayMove(noctowl, 152, 120, false, 1)
--     GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
--   end)
--   local coro2 = TASK:BranchCoroutine(function()
--     GAME:WaitFrames(20)
--     GROUND:MoveToPosition(hero, 168, 152, false, 1)
--   end)
--   local coro3 = TASK:BranchCoroutine(function()
--     GAME:WaitFrames(10)
--     GROUND:MoveToPosition(partner, 200, 152, false, 1)
--   end)
--   TASK:JoinCoroutines({ coro1, coro2, coro3 })
--   GAME:WaitFrames(40)

--   --noctowl tells tropius
--   GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
--   --	GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
--   UI:SetSpeaker(noctowl)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("These are the two Pokémon I informed you of,[pause=10] Guildmaster.")

--   GROUND:CharTurnToCharAnimated(noctowl, hero, 4)
--   GAME:WaitFrames(40)
--   GROUND:CharTurnToCharAnimated(tropius, hero, 4)
--   GAME:WaitFrames(20)
--   UI:SetSpeaker('[color=#00FFFF]Guildmaster[color]', true, tropius.CurrentForm.Species, tropius.CurrentForm.Form,
--     tropius.CurrentForm.Skin, tropius.CurrentForm.Gender)
--   UI:WaitShowDialogue("Howdy![pause=0] My name is " ..
--   tropius:GetDisplayName() .. ",[pause=10] and I'm the Guildmaster here!")
--   UI:SetSpeaker(tropius)
--   GAME:WaitFrames(20)
--   UI:WaitShowDialogue(noctowl:GetDisplayName() .. " has told me that the two of you want to apprentice at the guild.")
--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("That's wonderful![pause=0] The world could always use more adventurers!")
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("I don't think I got your names,[pause=10] though.[pause=0] Could you tell me them please?")

--   --partner speaks up
--   GAME:WaitFrames(20)
--   UI:SetSpeaker(partner)
--   GROUND:CharSetEmote(partner, "sweating", 1)
--   UI:WaitShowDialogue("M-my n-name is...[pause=0] I-Is...")
--   GAME:WaitFrames(20)

--   GeneralFunctions.EmoteAndPause(partner, 'Sweating', true)
--   UI:SetSpeakerEmotion('Pain')
--   UI:WaitShowDialogue("(C'mon,[pause=10] I can't get cold feet now...)")

--   GAME:WaitFrames(20)
--   GeneralFunctions.ShakeHead(partner)
--   GAME:WaitFrames(10)

--   UI:SetSpeakerEmotion("Determined")
--   UI:WaitShowDialogue("(I just need to have a little confidence!)")
--   UI:WaitShowDialogue("(It'll be scary...[pause=0] But I know I can do it!)")
--   GAME:WaitFrames(20)
--   GeneralFunctions.Hop(partner)

--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("My name is " .. partner:GetDisplayName() .. "!")
--   --GAME:WaitFrames(20)
--   --GeneralFunctions.HeroDialogue(hero, "(Guess it's my turn now then.)", "Normal")
--   GAME:WaitFrames(20)
--   GeneralFunctions.HeroSpeak(hero, 60)

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:WaitShowDialogue(partner:GetDisplayName() .. " and " .. hero:GetDisplayName() .. "...[pause=0] Alright!")
--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("It's nice to meet the both of you!")
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("I understand that you two want to train here at the guild.")
--   UI:WaitShowDialogue("Do either of you have any experience adventuring already?")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Sad")
--   UI:WaitShowDialogue("Um...[pause=0] N-not really...[pause=0] We're pretty new to it...")
--   GAME:WaitFrames(10)
--   GeneralFunctions.Hop(partner)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("But we want to train here so we can become great adventurers,[pause=10] like you are!")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Happy")
--   GROUND:CharSetEmote(tropius, "glowing", 0)
--   UI:WaitShowDialogue("Ha ha,[pause=10] you flatter me!")
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Normal")
--   GROUND:CharSetEmote(tropius, "", 0)
--   UI:WaitShowDialogue(
--   "It's alright if you don't have experience![pause=0] That's what apprenticing is for,[pause=10] right?")
--   GAME:WaitFrames(20)

--   --[[
-- 	--Huh? trying times? what do you mean? something's wrong with the world or something?
-- 	--this part rmeoved because I decided that the calamity (the blight) should only start to manifest once the hero comes to the world
-- 	UI:SetSpeakerEmotion("Worried")
-- 	UI:WaitShowDialogue("Frankly,[pause=10] it amazes me that so many Pokémon still wish to become adventurers ...")
-- 	UI:WaitShowDialogue("...given the life force issues in recent times...")
	
-- 	GAME:WaitFrames(20)
-- 	GeneralFunctions.EmoteAndPause(hero, "Question", true)
-- 	GeneralFunctions.HeroDialogue(hero, "(Huh?[pause=0] Issues with life forces?[pause=0] What is he talking about?)", "Worried")
-- 	GAME:WaitFrames(20)
-- 	]] --

--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Normal")
--   --	UI:WaitShowDialogue("But I'm getting offtopic.[pause=0] What's important right now is your apprenticeship!")
--   UI:WaitShowDialogue(
--   "Before you can sign up with us though,[pause=10] I do need to ask the two of you an important question.")
--   UI:WaitShowDialogue("Don't be nervous.[pause=0] This isn't some sort of test of knowledge or anything.")
--   UI:WaitShowDialogue("...So it's crucial that you answer honestly.[pause=0] Your answer is only wrong if you lie.")

--   --what kind of questions is he about to ask us, oh goodness
--   GROUND:CharTurnToCharAnimated(partner, hero, 4)
--   GROUND:CharTurnToCharAnimated(hero, partner, 4)
--   GAME:WaitFrames(20)
--   coro1 = TASK:BranchCoroutine(function()
--     GAME:WaitFrames(10)
--     GeneralFunctions.EmoteAndPause(hero, 'Sweating', false)
--   end)
--   coro2 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, 'Sweating', true) end)
--   TASK:JoinCoroutines({ coro1, coro2 })
--   GAME:WaitFrames(20)

--   GROUND:CharTurnToCharAnimated(partner, tropius, 4)
--   GROUND:CharTurnToCharAnimated(hero, tropius, 4)

--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Stunned")
--   UI:WaitShowDialogue("O-of course![pause=0] Ask us a-anything,[pause=10] Guildmaster!")
--   GAME:WaitFrames(20)

--   --question 1: why do you wanna be an adventurer?
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("Great![pause=0] Now,[pause=10] first,[pause=10] let's hear from " ..
--   partner:GetDisplayName() .. "...")
--   GROUND:CharAnimateTurnTo(tropius, Direction.DownRight, 4)
--   GAME:WaitFrames(16)
--   UI:WaitShowDialogue("Why do you want to become an adventurer?")

--   GAME:WaitFrames(20)
--   GeneralFunctions.EmoteAndPause(partner, "Exclaim", true)
--   GeneralFunctions.Hop(partner)
--   UI:SetSpeaker(partner)
--   UI:WaitShowDialogue("Oh,[pause=10] that's an easy one![pause=0] I want to do all the things that adventurers do!")
--   UI:SetSpeakerEmotion("Inspired")
--   GAME:WaitFrames(20)
--   UI:WaitShowDialogue(
--   "I wanna explore new places,[pause=10] help Pokémon in trouble,[pause=10] and make friends all around the world!")
--   UI:WaitShowDialogue("Maybe if I'm lucky I'll find some treasure too![pause=0] That would be cool!")


--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("Adventurers sure do a lot of amazing things,[pause=10] don't we?")
--   UI:WaitShowDialogue("Helping other Pokémon is one of the most important jobs!")
--   UI:WaitShowDialogue("In doing so we get to meet so many unique and interesting Pokémon!")
--   UI:WaitShowDialogue(
--   "A lot of Pokémon think that adventuring is about the treasure.[pause=0] But that's a bonus,[pause=10] not the purpose.")
--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("You seem to understand that though.")
--   GAME:WaitFrames(20)
--   GROUND:CharAnimateTurnTo(tropius, Direction.DownLeft, 4)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("What about you,[pause=10] " .. hero:GetDisplayName() .. "?")
--   GAME:WaitFrames(20)

--   --hero question 1 response
--   GeneralFunctions.HeroDialogue(hero,
--     "(Uh...[pause=0] That's a good question actually.[pause=0] I haven't put that much thought into it.)", "Worried")
--   GeneralFunctions.HeroDialogue(hero,
--     "(It sounded fun,[pause=10] sure,[pause=10] but I didn't really have any other options given my circumstances.)",
--     "Worried")
--   GeneralFunctions.HeroDialogue(hero, "(I'm not really sure what my answer is then...)", "Worried")
--   UI:BeginChoiceMenu("(...Why do I want to be an adventurer?)",
--     { "It's a lot of fun", "Solve mysteries", partner:GetDisplayName() .. " is my friend" }, 3, 3)
--   UI:WaitForChoice()

--   --menu with 3 options here:
--   --Solve my origins (but i cant say that so i'll say solve mysteries of the world)
--   --it's really fun
--   --partner is my friend and they wanna be one
--   local result = UI:ChoiceResult()
--   GAME:WaitFrames(20)
--   if result == 1 then
--     GeneralFunctions.HeroDialogue(hero,
--       "(Hmm...[pause=0] I guess it just sounded like fun when " .. partner:GetDisplayName() .. " described it to me.)",
--       "Worried")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroDialogue(hero, "(I'll go with that as my answer then!)", "Normal")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroSpeak(hero, 60)
--     GAME:WaitFrames(20)
--     UI:SetSpeaker(tropius)
--     UI:SetSpeakerEmotion("Happy")
--     UI:WaitShowDialogue("I see![pause=0] It's true that adventuring can be a lot of fun!")
--     GAME:WaitFrames(20)
--     UI:SetSpeakerEmotion("Normal")
--     UI:WaitShowDialogue(
--     "But keep in mind that it's not always fun and games.[pause=0] It can be very serious work at times.")                   --foreshadowing
--   elseif result == 2 then
--     GeneralFunctions.HeroDialogue(hero,
--       "(Truthfully,[pause=10] I'd like to figure out who I used to be and how I lost my memory.)", "Worried")
--     GeneralFunctions.HeroDialogue(hero, "(Being an adventurer seems like it could help me with that...)", "Worried")
--     GeneralFunctions.HeroDialogue(hero,
--       "(But " .. partner:GetDisplayName() .. " said I shouldn't tell anyone that I was a human...)", "Worried")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroDialogue(hero, "(I guess if I phrase it a certain way it wouldn't sound suspicious.)", "Normal")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroSpeak(hero, 60)
--     GAME:WaitFrames(20)
--     UI:SetSpeaker(tropius)
--     UI:WaitShowDialogue(
--     "You want to solve mysteries?[pause=0] There's a lot of secrets in this world,[pause=10] isn't there?")
--     UI:WaitShowDialogue(
--     "The pursuit of knowledge is an admirable goal.[pause=0] So much good can come from learning more about the world.")
--     UI:WaitShowDialogue("...But bad things can too.[pause=0] There are some things we might be better off not knowing.") --foreshadowing
--   else
--     GeneralFunctions.HeroDialogue(hero,
--       "(The only reason I'm here in the first place is because of " .. partner:GetDisplayName() .. "...)", "Worried")
--     GeneralFunctions.HeroDialogue(hero,
--       "(I don't know " ..
--       GeneralFunctions.GetPronoun(partner, "them") ..
--       " that well yet,[pause=10] but " ..
--       GeneralFunctions.GetPronoun(partner, "they're") .. " still my only friend in this world...)", "Worried")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroDialogue(hero,
--       "(So I guess the real reason I'm here to be an adventurer is because of " .. partner:GetDisplayName() .. "!)",
--       "Normal")
--     GAME:WaitFrames(20)
--     GeneralFunctions.HeroSpeak(hero, 60)
--     GAME:WaitFrames(20)
--     UI:SetSpeaker(tropius)
--     --tropius likes this answer, partner is surprised by your answer
--     coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(tropius, "Exclaim", true) end)
--     coro2 = TASK:BranchCoroutine(function()
--       GROUND:CharSetEmote(partner, "exclaim", 1)
--       GROUND:CharTurnToCharAnimated(partner, hero, 4)
--     end)
--     TASK:JoinCoroutines({ coro1, coro2 })
--     UI:WaitShowDialogue("Oh?[pause=0] You want to be an adventurer so you can journey with your friend?")
--     GROUND:CharAnimateTurnTo(partner, Direction.Up, 4)
--     GAME:WaitFrames(16)
--     UI:SetSpeakerEmotion("Happy")
--     UI:WaitShowDialogue(
--     "That's quite admirable![pause=0] Many Pokémon forget that the most important part of a team is your partner!")
--     GAME:WaitFrames(20)
--     UI:SetSpeakerEmotion("Normal")
--     UI:WaitShowDialogue(
--     "The best teams are those whose members share a strong bond and put their teammates before anything else.")
--     GAME:WaitFrames(20)
--     UI:SetSpeakerEmotion("Worried")                                                  --foreshadowing
--     UI:WaitShowDialogue("...And the worst are those who put glory or treasure first.") --FORESHADOWING
--     UI:SetSpeakerEmotion("Normal")
--   end
--   GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
--   GAME:WaitFrames(40)
--   --hmm, how to reconcile that tropius wants to teach people the error of his ways but turned away team style because they were vain and had poor morals?
--   --either: they got kicked out because they weren't changing or were acting up, or they weren't allowed to join in the first place because of their bad attitude/philosophy


--   --looks at noctowl, they agree that they should be allowed to apprentice here
--   --that was too easy... as it this was meant to happen...
--   UI:WaitShowDialogue("That's all I needed to hear from you two.")
--   GAME:WaitFrames(20)
--   GROUND:CharTurnToCharAnimated(tropius, noctowl, 4)
--   GROUND:CharTurnToCharAnimated(noctowl, tropius, 4)
--   UI:WaitShowDialogue("What do you think,[pause=10] " .. noctowl:GetDisplayName() .. "?")

--   --	GAME:WaitFrames(20)
--   --	UI:SetSpeaker(noctowl)
--   --	UI:WaitShowDialogue("Of course I have thoughts,[pause=10] Guildmaster.[pause=0] I spend a lot of my time thinking,[pause=10] after all.")
--   --	GAME:WaitFrames(20)
--   --	UI:SetSpeaker(tropius)
--   --	UI:WaitShowDialogue("...What I meant was,[pause=10] do you have any thoughts on our prospective recruits here?")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(noctowl)
--   UI:WaitShowDialogue("I have no quarrels,[pause=10] Guildmaster.")
--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:WaitShowDialogue("That's what I figured![pause=0] In that case...")
--   GROUND:CharAnimateTurnTo(tropius, Direction.Down, 4)
--   GROUND:CharAnimateTurnTo(noctowl, Direction.DownRight, 4)
--   GAME:WaitFrames(10)


--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("Congratulations![pause=0] You two are now an official guild adventuring team!")


--   --yay we did it!!
--   --GAME:WaitFrames(20)
--   coro1 = TASK:BranchCoroutine(function() GeneralFunctions.EmoteAndPause(partner, "Exclaim", true) end)
--   coro2 = TASK:BranchCoroutine(function()
--     GAME:WaitFrames(10)
--     GeneralFunctions.EmoteAndPause(hero, "Exclaim", false)
--   end)
--   TASK:JoinCoroutines({ coro1, coro2 })
--   UI:SetSpeaker(partner)
--   GROUND:CharSetAnim(partner, "Idle", true)
--   UI:SetSpeakerEmotion("Inspired")
--   UI:WaitShowDialogue("R-really!?")

--   GROUND:CharTurnToCharAnimated(partner, hero, 4)
--   GROUND:CharTurnToCharAnimated(hero, partner, 4)
--   GAME:WaitFrames(10)

--   GROUND:CharSetEmote(partner, "happy", 0)
--   GROUND:CharSetAnim(hero, "Idle", true)
--   UI:SetSpeakerEmotion("Joyous")
--   GeneralFunctions.DoubleHop(partner, nil, nil, nil, true, true)
--   GROUND:CharSetAnim(partner, "Idle", true)
--   UI:WaitShowDialogue("We did it![pause=0] We're in the guild,[pause=10] " ..
--   hero:GetDisplayName() .. "![pause=0] I can't believe it!")

--   GAME:WaitFrames(40)
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Happy")
--   GROUND:CharSetEmote(tropius, "glowing", 0)
--   UI:WaitShowDialogue("Ha ha ha!")
--   GAME:WaitFrames(10)
--   GROUND:CharSetEmote(tropius, "", 0)
--   GROUND:CharSetEmote(partner, "", 0)
--   GROUND:CharSetAnim(partner, "None", true)
--   GROUND:CharSetAnim(hero, "None", true)
--   GROUND:CharTurnToCharAnimated(partner, tropius, 4)
--   GROUND:CharTurnToCharAnimated(hero, tropius, 4)
--   GAME:WaitFrames(20)


--   --what is your team's name?
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue(
--   "Your training will start tomorrow.[pause=0] But before that,[pause=10] I need to update our records with your info.")

--   GROUND:CharSetEmote(partner, "", 0)
--   GROUND:CharSetAnim(partner, "None", true)
--   GROUND:CharSetAnim(hero, "None", true)
--   GROUND:CharTurnToCharAnimated(partner, tropius, 4)
--   GROUND:CharTurnToCharAnimated(hero, tropius, 4)
--   GAME:WaitFrames(12)
--   UI:WaitShowDialogue(
--   "I have most of what I need already...[pause=0] But I still need your team's name.[pause=0] Have you decided on one?")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Worried")
--   UI:WaitShowDialogue("A team name?[pause=0] We hadn't thought of one yet.")

--   GROUND:CharTurnToCharAnimated(partner, hero, 4)
--   GROUND:CharTurnToCharAnimated(hero, partner, 4)

--   --give team name, tropius gives a couple of items and some adventurers tool (like a badge to tp others and urselves out of dungeons)
--   --then noctowl shows u to ur room

--   GAME:WaitFrames(12)
--   UI:WaitShowDialogue("What do you think our name should be,[pause=10] " .. hero:GetDisplayName() .. "?")

--   --give team name
--   GAME:WaitFrames(20)
--   UI:ResetSpeaker()
--   local yesnoResult = false
--   while not yesnoResult do
--     UI:NameMenu("What will your team's name be?", "You don't need to put 'Team' in the name itself.", 60)
--     UI:WaitForChoice()
--     result = UI:ChoiceResult()
--     GAME:SetTeamName(result)
--     UI:ChoiceMenuYesNo("Is Team " .. GAME:GetTeamName() .. " correct?", true)
--     UI:WaitForChoice()
--     yesnoResult = UI:ChoiceResult()
--   end

--   UI:SetSpeaker(partner)
--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Inspired")
--   UI:WaitShowDialogue(GAME:GetTeamName() .. "...[pause=0] I like it!")

--   --I'll register you as your teamname then!
--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("Alright then![pause=0] I'll register you as Team " .. GAME:GetTeamName() .. "!")
--   GROUND:CharTurnToCharAnimated(partner, tropius, 4)
--   GROUND:CharTurnToCharAnimated(hero, tropius, 4)

--   GAME:WaitFrames(12)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("Before I go and dive into the wonderful world of paperwork though...")
--   UI:WaitShowDialogue("I need to give you the essential items that all adventurers carry!")
--   GAME:WaitFrames(20)

--   GROUND:MoveInDirection(tropius, Direction.Down, 16, false, 1)
--   GAME:WaitFrames(10)
--   --tropius walks forward and places a chest
--   SOUND:PlayBattleSE('EVT_CH02_Item_Place')
--   GROUND:Unhide("Yellow_Box")
--   GAME:WaitFrames(20)
--   GROUND:AnimateInDirection(tropius, "Walk", Direction.Down, Direction.Up, 16, 1, 1)
--   GAME:WaitFrames(20)

--   UI:WaitShowDialogue(
--   "This box contains all the special tools that adventurers use.[pause=0] Go ahead,[pause=10] open it!")
--   GAME:WaitFrames(20)

--   --open the box
--   GROUND:CharAnimateTurnTo(hero, Direction.UpRight, 4)
--   GROUND:CharAnimateTurnTo(partner, Direction.UpLeft, 4)
--   GAME:WaitFrames(10)
--   GROUND:ObjectSetAnim(box, 4, 0, 5, Direction.Down, 1)
--   GROUND:ObjectSetDefaultAnim(box, 'Yellow_Box', 0, 5, 5, Direction.Down)
--   SOUND:PlayBattleSE('EVT_CH02_Box_Open')
--   GeneralFunctions.Monologue(hero:GetDisplayName() .. " opened the box.")

--   --local scarf_name = RogueEssence.Dungeon.InvItem("held_synergy_scarf"):GetDisplayName()
--   --have to hardcode this so I can have it say scarves instead of scarf
--   local scarf_name = STRINGS:Format('\\uE0AE') .. '[color=#FFCEFF]Synergy Scarves[color]'

--   --pipe dream todo: have scarves for the sprites from now on
--   GAME:WaitFrames(20)
--   UI:ResetSpeaker(false)
--   UI:SetCenter(true)
--   UI:WaitShowDialogue("Inside the box there was...")
--   SOUND:PlayFanfare("Fanfare/Item")
--   UI:WaitShowDialogue("A Wonder Map...[pause=40]")
--   SOUND:PlayFanfare("Fanfare/Item")
--   UI:WaitShowDialogue("A set of Adventurer Badges...[pause=40]")
--   SOUND:PlayFanfare("Fanfare/Item")
--   UI:WaitShowDialogue("A Treasure Bag...[pause=40]")
--   SOUND:PlayFanfare("Fanfare/Item")
--   UI:WaitShowDialogue("And a pair of " .. scarf_name .. "![pause=60]")
--   UI:SetCenter(false)


--   GAME:WaitFrames(30)
--   GeneralFunctions.Hop(partner)
--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Inspired")
--   UI:WaitShowDialogue("Wow![pause=0] There's a ton of items here!")
--   GAME:WaitFrames(20)

--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("You should find these items useful in your adventures to come.")
--   UI:WaitShowDialogue(
--   "The Wonder Map will help you locate discovered areas.[pause=0] It should keep you from getting lost.")
--   UI:WaitShowDialogue("The Adventurer Badges are incredible tools!")
--   UI:WaitShowDialogue("Not only are they unique trackers in case something should ever happen to you...")
--   UI:WaitShowDialogue("...They can also be used to rescue Pokémon in danger!")
--   UI:WaitShowDialogue("You can use them to warp out from the end of a dungeon,[pause=10] too.")
--   UI:WaitShowDialogue("That way you won't need to backtrack through the dungeon to get home.")
--   UI:WaitShowDialogue("The Treasure Bag is self-explanatory.")
--   UI:WaitShowDialogue("If you do enough good adventuring work,[pause=10] it'll be upgraded to carry more items!")
--   UI:WaitShowDialogue("Lastly,[pause=10] a pair of " .. scarf_name .. ".")
--   UI:WaitShowDialogue(
--   "These scarves are very special,[pause=10] so special in fact that they cannot be lost even if you faint in a dungeon!")
--   UI:WaitShowDialogue("By themselves,[pause=10] the scarves won't do anything.")
--   UI:WaitShowDialogue("But if the both of you wear the scarves and are close to each other...")
--   UI:WaitShowDialogue("...Then the scarves will give you a number of useful boons!")
--   UI:SetSpeakerEmotion("Happy") --change to a wink? how do you wink when only one eye shows
--   UI:WaitShowDialogue("They also make a great fashion statement!")

--   GAME:WaitFrames(20)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("We give a pair to all of our apprentices to help encourage teamwork.")
--   UI:WaitShowDialogue("Please make good use of them!")


--   --thank you for the items and letting us join guildmaster
--   GAME:WaitFrames(20)
--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Inspired")
--   GROUND:CharTurnToCharAnimated(partner, tropius, 4)
--   GROUND:CharTurnToCharAnimated(hero, tropius, 4)
--   UI:WaitShowDialogue("Th-these items are amazing![pause=0] Thank you Guildmaster!")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(tropius)
--   UI:SetSpeakerEmotion("Happy")
--   UI:WaitShowDialogue("Of course![pause=0] I expect great things from you two![pause=0] So work hard at your training!")

--   GAME:WaitFrames(20)
--   UI:SetSpeaker(partner)
--   UI:SetSpeakerEmotion("Normal")
--   UI:WaitShowDialogue("We'll train real hard![pause=0] We're gonna do what it takes to become great adventurers!")

--   GAME:WaitFrames(20)
--   GROUND:CharTurnToCharAnimated(partner, hero, 4)
--   GROUND:CharTurnToCharAnimated(hero, partner, 4)
--   UI:WaitShowDialogue("Right,[pause=10] " .. hero:GetDisplayName() .. "?")

--   GAME:WaitFrames(20)
--   GeneralFunctions.DoAnimation(hero, "Nod")
--   GAME:WaitFrames(20)

--   UI:SetSpeakerEmotion("Inspired")
--   UI:WaitShowDialogue("Yeah!")

--   --pose before fading out
--   GAME:WaitFrames(20)
--   GROUND:CharAnimateTurnTo(partner, Direction.Down, 4)
--   GROUND:CharAnimateTurnTo(hero, Direction.Down, 4)
--   GAME:WaitFrames(20)

--   coro1 = TASK:BranchCoroutine(function() GROUND:CharSetAction(partner,
--       RogueEssence.Ground.PoseGroundAction(partner.Position, partner.Direction,
--         RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
--   coro2 = TASK:BranchCoroutine(function() GROUND:CharSetAction(hero,
--       RogueEssence.Ground.PoseGroundAction(hero.Position, hero.Direction,
--         RogueEssence.Content.GraphicsManager.GetAnimIndex("Pose"))) end)
--   coro3 = TASK:BranchCoroutine(function()
--     GAME:WaitFrames(40)
--     GROUND:CharSetEmote(tropius, "glowing", 0)
--   end)
--   GAME:WaitFrames(120)

--   --rank up to normal rank upon joining guild
--   SOUND:FadeOutBGM(60)
--   GAME:FadeOut(false, 60)
--   _DATA.Save.ActiveTeam:SetRank("normal")
--   GAME:GivePlayerItem("held_synergy_scarf", 2) --give 2 vibrant scarves
--   GAME:CutsceneMode(false)
--   GAME:WaitFrames(60)
--   GAME:EnterGroundMap("guild_heros_room", "Main_Entrance_Marker")
-- end

return base_camp_2_mod
