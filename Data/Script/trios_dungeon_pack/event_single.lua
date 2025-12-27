require 'origin.common'
require 'trios_dungeon_pack.wish_table.wish_table'
require 'trios_dungeon_pack.helpers'

StackStateType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')
ListType = luanet.import_type('System.Collections.Generic.List`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')

SpawnListType = luanet.import_type('RogueElements.SpawnList`1')

local function JoinTeamWithFanfareAssembly(recruit, from_dungeon)
    local orig_settings = UI:ExportSpeakerSettings()

    if from_dungeon then
        recruit.MetAt = _ZONE.CurrentMap:GetColoredName()
    else
        recruit.MetAt = _ZONE.CurrentGround:GetColoredName()
    end
    recruit.MetLoc = RogueEssence.Dungeon.ZoneLoc(_ZONE.CurrentZoneID, _ZONE.CurrentMapID)

    _DATA.Save.ActiveTeam.Assembly:Add(recruit)
    SOUND:PlayFanfare("Fanfare/JoinTeam")
    _DATA.Save:RegisterMonster(recruit.BaseForm.Species)
    _DATA.Save:RogueUnlockMonster(recruit.BaseForm.Species)

    UI:ResetSpeaker(false)
    UI:SetCenter(true)

    if _DATA.Save.ActiveTeam.Name ~= "" then
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("MSG_RECRUIT"):ToLocal(),
            recruit:GetDisplayName(true), GAME:GetTeamName()))
    else
        UI:WaitShowDialogue(STRINGS:Format(RogueEssence.StringKey("MSG_RECRUIT_ANY"):ToLocal(),
            recruit:GetDisplayName(true)))
    end

    UI:ImportSpeakerSettings(orig_settings)
end

local function GetWishTier()
    local corner_tiles = {
        C8x9 = true,
        C10x7 = true,
        C12x9 = true,
        C9x11 = true,
        C11x11 = true
    }

    local wish_tier = 1
    local item_count = _ZONE.CurrentMap.Items.Count
    for item_idx = 0, item_count - 1, 1 do
        local map_item = _ZONE.CurrentMap.Items[item_idx]
        local x = map_item.TileLoc.X
        local y = map_item.TileLoc.Y
        local key = string.format("C%dx%d", x, y)
        local value = corner_tiles[key]
        if value ~= nil and map_item.Value == "wish_gem" then
            wish_tier = wish_tier + 1
        end
    end

    return wish_tier
end

local function WishCenterAnimStart(query_order, corner_tiles, corner_layer_map)

    -- C8x9 = true,
    -- C10x7 = true,
    -- C12x9 = true,
    -- C9x11 = true,
    -- C11x11 = true,
    local locations = {{
        X = 8,
        Y = 9
    }, {
        X = 10,
        Y = 7
    }, {
        X = 12,
        Y = 9
    }, {
        X = 9,
        Y = 11
    }, {
        X = 11,
        Y = 11
    }}

    local item_count = _ZONE.CurrentMap.Items.Count
    for item_idx = 0, item_count - 1, 1 do
        local map_item = _ZONE.CurrentMap.Items[item_idx]
        local x = map_item.TileLoc.X
        local y = map_item.TileLoc.Y
        local key = string.format("C%dx%d", x, y)
        local value = corner_tiles[key]
        if value ~= nil and map_item.Value == "wish_gem" then
            corner_tiles[key] = map_item.TileLoc
        end
    end

    for _, t in ipairs(locations) do
        local tile = _ZONE.CurrentMap.Tiles[t.X][t.Y]
        tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
    end

    GAME:WaitFrames(80)
    for _, v in ipairs(query_order) do
        local tile = corner_tiles[v]
        if tile then
            local t = _ZONE.CurrentMap.Tiles[tile.X][tile.Y]
            local layer_index = corner_layer_map[v]

            local copy = _DATA.SendHomeFX
            copy.Sound = "_UNK_EVT_029"
            GAME:WaitFrames(20)
            TASK:WaitTask(_DUNGEON:ProcessBattleFX(tile, tile, Direction.Down, copy))
            local item_count = _ZONE.CurrentMap.Items.Count
            for item_idx = 0, item_count - 1, 1 do
                local map_item = _ZONE.CurrentMap.Items[item_idx]
                local x = map_item.TileLoc.X
                local y = map_item.TileLoc.Y
                local key = string.format("C%dx%d", x, y)
                local value = corner_tiles[key]
                if key == v then
                    _ZONE.CurrentMap.Items:RemoveAt(item_idx)
                    goto skip_to_next
                end
            end
            ::skip_to_next::
            _ZONE.CurrentMap.Decorations[layer_index].Visible = false
        end
    end

    GAME:WaitFrames(40)
    SOUND:PlayBattleSE("_UNK_EVT_044")
    GAME:WaitFrames(10)
    GAME:FadeOut(true, 40)
    GAME:WaitFrames(50)
    for _, v in ipairs(query_order) do
        local tile = corner_tiles[v]
        if tile then
            local t = _ZONE.CurrentMap.Tiles[tile.X][tile.Y]
            t.Effect = RogueEssence.Dungeon.EffectTile("tile_mystery_portal", true)
        end
    end
    GAME:WaitFrames(40)
    GAME:FadeIn(60)
    GAME:WaitFrames(40)
    return corner_tiles
end

local function WishCenterAnimEnd(owner, query_order, corner_tiles)
    local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Miracle_Eye_Glow", 12), 1)

    SOUND:PlayBattleSE("_UNK_EVT_072")

    GAME:WaitFrames(15)
    -- local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(item).Sprite, RogueEssence.Content.GraphicsManager.TileSize / 2, 10)
    emitter:SetupEmit(owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
                          RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2),
        owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
            RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2), Direction.Left)
    _DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)

    GAME:WaitFrames(30)

    GAME:WaitFrames(50)
    SOUND:PlayBattleSE("_UNK_EVT_074")
    GAME:FadeOut(true, 40)
    GAME:WaitFrames(50)
    for _, v in ipairs(query_order) do
        local tile = corner_tiles[v]
        -- print(tostring(tile))
        if tile then
            local t = _ZONE.CurrentMap.Tiles[tile.X][tile.Y]
            t.Effect = RogueEssence.Dungeon.EffectTile(t.Effect.TileLoc)
        end
    end

    GAME:WaitFrames(40)
    GAME:FadeIn(60)
    GAME:WaitFrames(80)

end

local function IsCharOnWishSpot()
    local corner_tiles = {
        C8x9 = true,
        C10x7 = true,
        C12x9 = true,
        C9x11 = true,
        C11x11 = true
    }

    local chars = _DATA.Save.ActiveTeam.Players
    for i = 0, chars.Count - 1, 1 do
        local char = chars[i]
        local x = char.CharLoc.X
        local y = char.CharLoc.Y
        local key = string.format("C%dx%d", x, y)
        -- local key = string.format("C%dx%d", x, y)
        local value = corner_tiles[key]
        if value ~= nil then
            return true
        end
    end

    return false
end

function SINGLE_CHAR_SCRIPT.LogTempItemEvent(owner, ownerChar, context, args)
    if SV.Wishmaker.TempItemString ~= nil then
        -- _DUNGEON:LogMsg("The " .. SV.Wishmaker.TempItemString .. " was sent to the storage!")
        SV.Wishmaker.TempItemString = nil
    end
end

function SINGLE_CHAR_SCRIPT.WishGemCheckEvent(owner, ownerChar, context, args)
    local corner_tiles = {
        C8x9 = {
            LayerName = "LeftCorner",
            Index = 2
        },
        C10x7 = {
            LayerName = "TopCorner",
            Index = 1
        },
        C12x9 = {
            LayerName = "RightCorner",
            Index = 3
        },
        C9x11 = {
            LayerName = "BottomLeftCorner",
            Index = 4
        },
        C11x11 = {
            LayerName = "BottomRightCorner",
            Index = 5
        }
    }

    local layer_count = 6
    for idx = 1, _ZONE.CurrentMap.Decorations.Count - 1, 1 do
        local layer = _ZONE.CurrentMap.Decorations[idx]
        layer.Visible = false
    end

    local item_count = _ZONE.CurrentMap.Items.Count
    for item_idx = 0, item_count - 1, 1 do
        local map_item = _ZONE.CurrentMap.Items[item_idx]
        local x = map_item.TileLoc.X
        local y = map_item.TileLoc.Y
        local key = string.format("C%dx%d", x, y)
        local value = corner_tiles[key]
        if value ~= nil and map_item.Value == "wish_gem" then
            local layer = _ZONE.CurrentMap.Decorations[value.Index]
            layer.Visible = true
        end
    end
end

function SINGLE_CHAR_SCRIPT.LowHpNpcEvent(owner, ownerChar, context, args)
    local chara = context.User
    if chara ~= nil then
        local tbl = LTBL(chara)
        if tbl.NPC then
            chara.HP = 5
        end
    end
end

function SINGLE_CHAR_SCRIPT.WishCenterEvent(owner, ownerChar, context, args)
    local chara = context.User
    if chara == _DUNGEON.ActiveTeam.Leader and chara == _DUNGEON.FocusedCharacter then
        _DUNGEON:QueueTrap(context.User.CharLoc)
    end
end

function SINGLE_CHAR_SCRIPT.WishCenterInteractEvent(owner, ownerChar, context, args)

    GAME:WaitFrames(50)
    UI:ResetSpeaker()
    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        if member.Dead == false then
            member.CharDir = Direction.Up
            DUNGEON:CharSetAction(member, RogueEssence.Dungeon.CharAnimPose(member.CharLoc, member.CharDir, 0, -1))
            GAME:WaitFrames(20)
        end
    end

    if SV.Wishmaker.RecruitedJirachi and SV.Wishmaker.MadeWish then
        UI:WaitShowDialogue("...[pause=0]" .. context.User:GetDisplayName(true) .. " cannot make a wish right now.")
        return
    end

    if SV.Wishmaker.MadeWish then
        UI:WaitShowDialogue("...[pause=0]" .. context.User:GetDisplayName(true) .. " cannot make a wish right now.")
        UI:WaitShowDialogue("[color=#F8F800]Wishmaker[color] awaits for next time.")
        return
    end

    local chara = context.User

    local recruited = false

    _ZONE.CurrentMap.Decorations[0].Layer = RogueEssence.Content.DrawLayer.Top
    local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")

    crystal_moment_status:LoadFromData()
    -- if _DATA.CurrentReplay == nil then
    TASK:WaitTask(_DUNGEON:AddMapStatus(crystal_moment_status))
    -- end

    _ZONE.CurrentMap.HideMinimap = true
    local curr_song = RogueEssence.GameManager.Instance.Song
    SOUND:StopBGM()
    UI:WaitShowDialogue(
        "...[pause=0]Time momentarily pauses.[pause=0] The stars around you shine more brightly than ever.")
    UI:ChoiceMenuYesNo("Would you like to make a wish?", false)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    if result then

        if not SV.Wishmaker.MadeWish and not IsCharOnWishSpot() then
            local wish_tier = GetWishTier()
            local wish_table = FINAL_WISH_TABLE[wish_tier]
            local wish_choices = M_HELPERS.map(wish_table, function(item)
                return item.Category
            end)

            if not SV.Wishmaker.RecruitedJirachi then
                table.insert(wish_choices, 1, STRINGS:Format("\\uE10C") .. " A new friend")
            end
            table.insert(wish_choices, "Don't know")
            local end_choice = #wish_choices
            UI:BeginChoiceMenu("What is your final wish?", wish_choices, 1, end_choice)
            UI:WaitForChoice()
            choice = UI:ChoiceResult()
            if choice ~= end_choice then
                local corner_tiles = {
                    C10x7 = false,
                    C8x9 = false,
                    C9x11 = false,
                    C11x11 = false,
                    C12x9 = false
                }

                local layer_map = {
                    C8x9 = 2,
                    C10x7 = 1,
                    C12x9 = 3,
                    C9x11 = 4,
                    C11x11 = 5
                }
                local query_order = {"C10x7", "C8x9", "C9x11", "C11x11", "C12x9"}
                if not SV.Wishmaker.RecruitedJirachi and choice == 1 then
                    if wish_tier == 6 then
                        WishCenterAnimStart(query_order, corner_tiles, layer_map)
                        SV.Wishmaker.RecruitedJirachi = true
                        SV.Wishmaker.MadeWish = true
                        SV.Wishmaker.RemoveBonusMoney = true
                        recruited = true

                        -- Bonus points for recruiting Jirachi
                        if GAME:InRogueMode() then
                            GAME:AddToPlayerMoneyBank(100000)
                        else
                            GAME:AddToPlayerMoney(100000)
                        end
                        -----------------
                        UI:WaitShowVoiceOver("[speed=0.2].............", -1, -1, 200)
                        UI:WaitShowVoiceOver(
                            "[speed=0.1]Fwaaaaaaah...[pause=30] I...[pause=40] I...[pause=40] have been called upon?",
                            -1, -1, 200)
                        UI:WaitShowVoiceOver("[speed=0.2]...I'm a bit sleeeeepy.", -1, -1, 200)
                        UI:WaitShowVoiceOver("[speed=0.2]But I am almost awake.", -1, -1, 200)
                        ---------------
                        local emitter = RogueEssence.Content.SingleEmitter(
                            RogueEssence.Content.AnimData("Miracle_Eye_Glow", 12), 1)

                        SOUND:PlayBattleSE("_UNK_EVT_072")

                        GAME:WaitFrames(15)
                        -- local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(item).Sprite, RogueEssence.Content.GraphicsManager.TileSize / 2, 10)
                        emitter:SetupEmit(owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
                                              RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2),
                            owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
                                RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2), Direction.Left)
                        _DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)

                        GAME:WaitFrames(30)

                        GAME:WaitFrames(50)
                        SOUND:PlayBattleSE("_UNK_EVT_074")
                        GAME:FadeOut(true, 40)
                        GAME:WaitFrames(50)
                        for _, v in ipairs(query_order) do
                            local tile = corner_tiles[v]
                            -- print(tostring(tile))
                            if tile then
                                local t = _ZONE.CurrentMap.Tiles[tile.X][tile.Y]
                                t.Effect = RogueEssence.Dungeon.EffectTile(t.Effect.TileLoc)
                            end
                        end

                        GAME:WaitFrames(40)
                        local dead_count = 0
                        for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
                            if member.Dead then
                                dead_count = dead_count + 1
                            end
                        end

                        if dead_count == 0 then
                            for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
                                if _DATA.Save.ActiveTeam.Players.Count == 1 then
                                    member.CharLoc = RogueElements.Loc(10, 9)
                                else
                                    if member == _DUNGEON.ActiveTeam.Leader then
                                        member.CharLoc = RogueElements.Loc(9, 9)
                                    else
                                        member.CharLoc = RogueElements.Loc(11, 9)
                                    end
                                end
                            end
                        end
                        if dead_count == 1 then
                            for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
                                if not member.Dead then
                                    member.CharLoc = RogueElements.Loc(10, 9)
                                end
                            end
                        end

                        TASK:WaitTask(_DUNGEON:MoveCamera(RogueElements.Loc(10 * 24, 9 * 24) +
                                                              RogueElements.Loc(
                                RogueEssence.Content.GraphicsManager.TileSize / 2), 1))
                        GAME:FadeIn(60)
                        GAME:WaitFrames(80)

                        TASK:WaitTask(_DUNGEON:MoveCamera(RogueElements.Loc(10 * 24, 7 * 24 - 8) +
                                                              RogueElements.Loc(
                                RogueEssence.Content.GraphicsManager.TileSize / 2), 100))
                        local new_team = RogueEssence.Dungeon.MonsterTeam()
                        local mob_data = RogueEssence.Dungeon.CharData(true)
                        local base_form_idx = 0
                        local form = _DATA:GetMonster("jirachi").Forms[base_form_idx]
                        mob_data.BaseForm = RogueEssence.Dungeon.MonsterID("jirachi", base_form_idx, "normal",
                            Gender.Unknown)
                        mob_data.Level = 50
                        local ability = form:RollIntrinsic(RogueElements.MathUtils.Rand, 3)
                        mob_data.BaseIntrinsics[0] = ability
                        local jirachi = RogueEssence.Dungeon.Character(mob_data)
                        jirachi.Tactic = _DATA:GetAITactic("boss")
                        jirachi.CharLoc = RogueElements.Loc(10, 7)
                        jirachi.CharDir = Direction.Down
                        new_team.Players:Add(jirachi)
                        _ZONE.CurrentMap.AllyTeams:Add(new_team)
                        local base_name = RogueEssence.Data.DataManager.Instance.DataIndices[RogueEssence.Data
                                              .DataManager.DataType.Monster]:Get(jirachi.BaseForm.Species).Name:ToLocal()
                        GAME:SetCharacterNickname(jirachi, base_name)
                        local jirachiName = _DATA:GetMonster(jirachi.BaseForm.Species):GetColoredName()
                        local poseAction = RogueEssence.Dungeon.CharAnimPose(jirachi.CharLoc, jirachi.CharDir, 84, 0)
                        SOUND:PlayBattleSE("_UNK_EVT_072")
                        TASK:WaitTask(jirachi:StartAnim(poseAction))
                        GAME:WaitFrames(200)
                        -- if _DATA.CurrentReplay == nil then
                        TASK:WaitTask(_DUNGEON:RemoveMapStatus("crystal_moment", false))
                        GAME:WaitFrames(60)
                        -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.User, context.User, _DATA.SendHomeFX))
                        -- end

                        local poseAction2 = RogueEssence.Dungeon.CharAnimPose(jirachi.CharLoc, jirachi.CharDir, 82, 0)
                        TASK:WaitTask(jirachi:StartAnim(poseAction2))
                        UI:SetSpeaker(jirachi)
                        GAME:WaitFrames(60)
                        UI:SetSpeakerEmotion("Sigh")
                        UI:WaitShowDialogue("[speed=0.2]Yaaaaaaawn... So tired...")
                        local poseAction3 = RogueEssence.Dungeon.CharAnimPose(jirachi.CharLoc, jirachi.CharDir, 50, 0)
                        TASK:WaitTask(jirachi:StartAnim(poseAction3))
                        GAME:WaitFrames(40)
                        SOUND:PlayBattleSE("_UNK_EVT_087")
                        GAME:WaitFrames(80)
                        local stand_anim = RogueEssence.Dungeon.CharAnimNone(jirachi.CharLoc, jirachi.CharDir)
                        stand_anim.MajorAnim = true
                        TASK:WaitTask(jirachi:StartAnim(stand_anim))
                        GAME:WaitFrames(50)
                        UI:SetSpeakerEmotion("Normal")
                        DUNGEON:CharSetEmote(jirachi, "exclaim", 1)
                        SOUND:PlayBattleSE("EVT_Emote_Exclaim_2")
                        GAME:WaitFrames(20)
                        UI:WaitShowDialogue(
                            "Hah![pause=0] All right,[pause=30] I'm fully awake. So,[pause=20] so[pause=20] awake.",
                            {Emote})
                        UI:WaitShowDialogue(STRINGS:Format("It's been so long since I've seen anyone around here..."))
                        -- DUNGEON:CharSetEmote(jirachi, "glowing", 4)
                        UI:SetSpeakerEmotion("Happy")
                        UI:WaitShowDialogue(STRINGS:Format(
                            "I'm [color=#00F8F8]{0}[color].[pause=0] A[emote=Normal]s you may have noticed,[pause=30] it takes a lot for me to wake up.",
                            base_name))
                        UI:SetSpeakerEmotion("Normal")
                        UI:WaitShowDialogue(
                            "I'm happy to see that despite everything you could have wished for[speed=0.2]...")
                        UI:SetSpeakerEmotion("Happy")
                        UI:WaitShowDialogue("...You wished to see me!")
                        GAME:WaitFrames(20)
                        UI:SetSpeakerEmotion("Normal")
                        UI:WaitShowDialogue("So you're an exploration team,[pause=40] right?")
                        for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
                            if not member.Dead then
                                local walk_action = RogueEssence.Dungeon.CharAnimPose(member.CharLoc, member.CharDir, 2,
                                    0)
                                -- TASK:WaitTask(jirachi:StartAnim(poseAction3))
                                DUNGEON:CharSetAction(member, walk_action)
                                -- local stand_anim =  RogueEssence.Dungeon.CharAnimNone(member.CharLoc, member.CharDir)
                                -- stand_anim.MajorAnim = true
                                -- TASK:WaitTask(member:StartAnim(stand_anim))
                            end
                        end
                        GAME:WaitFrames(60)
                        for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
                            if member.Dead == false then
                                member.CharDir = Direction.Up
                                DUNGEON:CharSetAction(member, RogueEssence.Dungeon
                                    .CharAnimPose(member.CharLoc, member.CharDir, 0, -1))
                                GAME:WaitFrames(20)
                            end
                        end
                        GAME:WaitFrames(30)
                        UI:SetSpeakerEmotion("Happy")
                        UI:WaitShowDialogue(STRINGS:Format("Ah,[pause=20] {0}[speed=0.2]...", GAME:GetTeamName()))
                        DUNGEON:CharSetEmote(jirachi, "glowing", 4)
                        UI:WaitShowDialogue("You must be an amazing team if you made it through all the way here!")
                        UI:SetSpeakerEmotion("Normal")
                        UI:WaitShowDialogue(
                            "Then,[pause=20] I wish to join your team and accompany in your explorations.")
                        UI:WaitShowDialogue("Though...[speed=0.2]")
                        UI:SetSpeakerEmotion("Happy")
                        DUNGEON:CharSetEmote(jirachi, "glowing", 4)
                        UI:WaitShowDialogue("I hope you don't mind me being very tired every now and then.")
                        GAME:WaitFrames(60)
                        local mon_id = RogueEssence.Dungeon.MonsterID("jirachi", 0, "normal", Gender.Genderless)
                        local recruit = _DATA.Save.ActiveTeam:CreatePlayer(_DATA.Save.Rand, mon_id, 50, "", 0)
                        local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("AllyInteract")
                        recruit.ActionEvents:Add(talk_evt)
                        local player_tbl = LTBL(recruit)
                        player_tbl.Wishmaker = true
                        JoinTeamWithFanfareAssembly(recruit, true)
                        GAME:WaitFrames(20)
                        -- SV.Wishmaker.RecruitedJirachi = true

                        local zone =
                            _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Zone]:Get("wishmaker_cave")
                        UI:SetSpeakerEmotion("Normal")
                        UI:WaitShowDialogue(STRINGS:Format("As for " .. zone:GetColoredName() ..
                                                               " itself[pause=10].[pause=10].[pause=10]."))
                        UI:WaitShowDialogue(
                            "I sense that the area here is content[pause=10].[pause=10].[pause=10].[pause=20] and will continue to grant wishes in my place.")
                        UI:SetSpeakerEmotion("Happy")
                        DUNGEON:CharSetEmote(jirachi, "glowing", 4)
                        UI:WaitShowDialogue("So,[pause=20] no worries! \u{266A}")
                        UI:SetSpeakerEmotion("Normal")
                        UI:WaitShowDialogue("[speed=0.2]......")
                        UI:WaitShowDialogue("[speed=0.2]I am feeling a bit sleepy though...")
                        local poseAction4 = RogueEssence.Dungeon.CharAnimPose(jirachi.CharLoc, jirachi.CharDir, 82, 0)
                        TASK:WaitTask(jirachi:StartAnim(poseAction4))
                        GAME:WaitFrames(70)
                        UI:SetSpeakerEmotion("Sigh")
                        UI:WaitShowDialogue("[speed=0.2]Goodnight...")
                        GAME:WaitFrames(100)

                        SOUND:FadeOutBGM()
                        GAME:FadeOut(false, 70)
                        GAME:WaitFrames(90)
                        TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))
                        -- COMMON.EndDungeonDay(RogueEssence.Data.GameProgress.ResultType.Cleared, 'guildmaster_island', -1, 1, 0)
                    else
                        UI:ResetSpeaker(false)
                        UI:SetCenter(true)
                        UI:WaitShowDialogue("[speed=0.09]............")
                        UI:ResetSpeaker(true)
                        UI:WaitShowDialogue("...[pause=0]Wishmaker cannot be awoken right now.")
                    end
                else

                    corner_tiles = WishCenterAnimStart(query_order, corner_tiles, layer_map)
                    SV.Wishmaker.MadeWish = true
                    if not SV.Wishmaker.RecruitedJirachi then
                        UI:WaitShowVoiceOver("[speed=0.1].............", -1, -1, 200)
                        UI:WaitShowVoiceOver(
                            "[speed=0.2]ZZZzzz...[pause=40] I will make your [speed=0.05]wish [speed=0.2]come true....",
                            -1, -1, 200)
                    else
                        UI:ResetSpeaker(false)
                        UI:SetCenter(true)
                        UI:WaitShowDialogue("The stars resonated with your wish.")
                        UI:ResetSpeaker()
                    end
                    WishCenterAnimEnd(owner, query_order, corner_tiles)
                    local index = choice
                    if not SV.Wishmaker.RecruitedJirachi then
                        index = index - 1
                    end
                    local item_table = wish_table[index]
                    local arguments = {}
                    arguments.MinAmount = item_table.Min
                    arguments.MaxAmount = item_table.Max
                    arguments.Guaranteed = item_table.Guaranteed
                    arguments.AlwaysSpawn = item_table.AlwaysSpawn
                    arguments.Items = item_table.Items
                    arguments.MaxRangeWidth = 8
                    arguments.MaxRangeHeight = 5
                    arguments.OffsetX = 2
                    arguments.OffsetY = -1
                    SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
                    GAME:WaitFrames(80)
                    if not SV.Wishmaker.RecruitedJirachi then
                        -- UI:WaitShowDialogue("You fell")
                        -- UI:WaitShowVoiceOver("[speed=0.2]Fwaaaaaaah.", -1, 75, 200)
                        UI:WaitShowVoiceOver(
                            "[speed=0.2]ZZZzzz...[pause=30] All the items you collect will be sent to your storage.",
                            -1, -1, 200)
                        UI:WaitShowVoiceOver("[speed=0.2]ZZZzzz...[pause=30] So sleeeeepy.", -1, -1, 200)
                        UI:WaitShowVoiceOver("[speed=0.2]Goodnight.[pause=20] ZZZzz...", -1, -1, 200)
                    else
                        UI:ResetSpeaker()
                        SOUND:PlayFanfare("Fanfare/Note")
                        UI:SetCenter(true)
                        UI:WaitShowDialogue("Note:[pause=0] All items collected will be sent to your storage!")
                        UI:ResetSpeaker()
                    end
                end
            end
        else
            UI:ResetSpeaker(false)
            UI:SetCenter(true)
            UI:WaitShowDialogue("[speed=0.09]............")
            UI:ResetSpeaker()
            UI:WaitShowDialogue("...[pause=0]" .. context.User:GetDisplayName(true) .. " cannot make a wish right now.")
        end

    end

    if _DATA.CurrentReplay == nil then
        TASK:WaitTask(_DUNGEON:RemoveMapStatus("crystal_moment", false))
        -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.User, context.User, _DATA.SendHomeFX))
    end

    if not recruited then
        SOUND:PlayBGM(curr_song, true, 0)
    end
    GAME:WaitFrames(20)

    _ZONE.CurrentMap.HideMinimap = false
    GAME:WaitFrames(20)

    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        if member.Dead == false then
            local stand_anim = RogueEssence.Dungeon.CharAnimNone(member.CharLoc, member.CharDir)
            stand_anim.MajorAnim = true
            TASK:WaitTask(member:StartAnim(stand_anim))
        end
    end
    _ZONE.CurrentMap.Decorations[0].Layer = RogueEssence.Content.DrawLayer.Bottom
end

function SINGLE_CHAR_SCRIPT.WishExitEvent(owner, ownerChar, context, args)
    local function InArray(value, array)
        for index = 1, #array do
            if array[index] == value then
                return true
            end
        end

        return false -- We could ommit this part, as nil is like false
    end

    local chara = context.User
    local tile = _ZONE.CurrentMap.Tiles[chara.CharLoc.X][chara.CharLoc.Y]
    local valid_dirs = {Direction.Down, Direction.DownLeft, Direction.DownRight}
    if tile.Effect ~= "" and chara == _DUNGEON.ActiveTeam.Leader and InArray(chara.CharDir, valid_dirs) and chara ==
        _DUNGEON.FocusedCharacter then
        _DUNGEON:QueueTrap(context.User.CharLoc)
    end
end

function SINGLE_CHAR_SCRIPT.WishExitInteractEvent(owner, ownerChar, context, args)
    local delay = args.Delay
    if delay == nil then
        delay = 10
    end

    GAME:WaitFrames(delay)
    UI:ResetSpeaker()
    UI:ChoiceMenuYesNo(STRINGS:FormatKey("DLG_ASK_EXIT_DUNGEON"), true)
    UI:WaitForChoice()
    ch = UI:ChoiceResult()
    if ch then
        SOUND:FadeOutBGM()
        GAME:FadeOut(false, 30)
        GAME:WaitFrames(120)
        TASK:WaitTask(_GAME:EndSegment(RogueEssence.Data.GameProgress.ResultType.Cleared))
    end
end

function ResetEffectTile(owner)
    local effect_tile = owner
    local base_loc = effect_tile.TileLoc
    local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
    if tile.Effect == owner then
        tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
    end
end

function SINGLE_CHAR_SCRIPT.RevealGems(owner, ownerChar, context, args)
    local count = 0
    if _DATA.CurrentReplay ~= nil then
        if context.User ~= nil then
            return
        else
            local map = _ZONE.CurrentMap
            for xx = 0, map.Width - 1, 1 do
                for yy = 0, map.Height - 1, 1 do
                    local loc = RogueElements.Loc(xx, yy)
                    local tl = map:GetTile(loc)
                    if tl.Effect.ID == "crystal_glow" then
                        count = count + 1
                        tl.Effect.ID = "crystal_glow2"
                    end
                end
            end
            _DUNGEON:LogMsg("Secret Count: " .. count)
        end
    end
end

function SINGLE_CHAR_SCRIPT.CrystalStatusCheck(owner, ownerChar, context, args)
    local status = args.Status
    local max_stack = args.MaxStack
    -- print(tostringmax_stack)
    local string_key = args.StringKey
    local status_stack_event = PMDC.Dungeon.StatusStackBattleEvent(status, false, false, 1)
    local mock_context = RogueEssence.Dungeon.BattleContext(RogueEssence.Dungeon.BattleActionType.Trap)
    mock_context.User = context.User
    local stack = context.User:GetStatusEffect(status)
    if stack ~= nil then
        local s = stack.StatusStates:Get(luanet.ctype(StackStateType))
        if s.Stack < max_stack then
            ResetEffectTile(owner)
            TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
        else
            local msg = RogueEssence.StringKey(string_key):ToLocal()
            _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
        end

    else
        ResetEffectTile(owner)
        TASK:WaitTask(status_stack_event:Apply(owner, ownerChar, mock_context))
    end
end

function SINGLE_CHAR_SCRIPT.LogShimmeringEvent(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end
    local msg = RogueEssence.StringKey(args.StringKey):ToLocal()
    _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg))
end

-- function SINGLE_CHAR_SCRIPT.EmberfrostSwitchSegment(owner, ownerChar, context, args)
-- 	print("Emberfrost Switch Segment Triggered")
--   if context.User ~= nil then
--     return
--   end

--   -- local msg = RogueEssence.StringKey(args.StringKey):ToLocal()
--   _DUNGEON:LogMsg("HI THERE")
-- end

function SINGLE_CHAR_SCRIPT.EmberFrostTest(owner, ownerChar, context, args)

    if context.User == _DUNGEON.ActiveTeam.Leader then
        print("EMBER FROST TEST TRIGGERED")
        GAME:RemovePlayerTeam(0)
    end

    -- print("HHIHIHHIHI")

end

function SINGLE_CHAR_SCRIPT.EmberFrostTest2(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end
    UI:WaitShowDialogue("The elemental energies shift again why...")
    -- print("EMBER FROST TEST TRIGGERED")
    -- print("HHIHIHHIHI")
    -- GAME:RemovePlayerTeam(0)
end

function SINGLE_CHAR_SCRIPT.EmberFrostSwitchParties(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end
    UI:WaitShowDialogue("The elemental energies shift...")

    GAME:RemovePlayerTeam(0)
    local player_count = GAME:GetPlayerPartyCount()
    print(tostring(player_count) .. " players in party")

end

function SINGLE_CHAR_SCRIPT.AddSwitchSegmentStairs(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end

    local map = _ZONE.CurrentMap
    for xx = 0, map.Width - 1, 1 do
        for yy = 0, map.Height - 1, 1 do
            local loc = RogueElements.Loc(xx, yy)
            local tl = map:GetTile(loc)

            if tl.Effect.ID == "stairs_go_up" or tl.Effect.ID == "stairs_go_down" or tl.Effect.ID == "stairs_back_down" or
                tl.Effect.ID == "stairs_back_up" then
                local sec_loc = RogueEssence.Dungeon.SegLoc(args.NextSegment, args.NextID)
                local dest_state = PMDC.Dungeon.DestState(sec_loc, false)
                dest_state.PreserveMusic = false
                tl.Effect.TileStates:Set(dest_state)
            end
        end
    end
end
-- local new_context = RogueEssence.Dungeon.SingleCharContext(target)
-- TASK:WaitTask(monster_event:Apply(owner, ownerChar, new_context))
-- PMDC.Dungeon.StatusStackBattleEvent(string statusID, bool affectTarget, bool silentCheck, int stack)

function SINGLE_CHAR_SCRIPT.CrystalGlowEvent(owner, ownerChar, context, args)
    if context.User.MemberTeam ~= _DUNGEON.ActiveTeam.Leader.MemberTeam then
        return
    end

    if context.User.CharLoc ~= owner.TileLoc then
        return
    end

    local item_idx = _ZONE.CurrentMap:GetItem(owner.TileLoc)
    if item_idx ~= -1 then
        return
    end

    local base_loc = owner.TileLoc
    local entries = {{
        Item = "wish_gem",
        Weight = 1,
        Amount = 1
    }}
    GAME:WaitFrames(10)
    local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Dig", 3), 1)
    DUNGEON:PlayVFX(emitter, base_loc.X * 24 + 12, base_loc.Y * 24)
    SOUND:PlayBattleSE("DUN_Dig")
    GAME:WaitFrames(10)

    local entry = PickByWeights(entries)

    if entry.Item ~= "" then
        local inv_item = RogueEssence.Dungeon.InvItem(entry.Item, false, entry.Amount)
        local map_item = RogueEssence.Dungeon.MapItem(inv_item)
        map_item.TileLoc = owner.TileLoc
        local start_loc = base_loc * RogueEssence.Content.GraphicsManager.TileSize -
                              RogueElements.Loc(-RogueEssence.Content.GraphicsManager.TileSize / 2, -20)
        local end_loc = base_loc * RogueEssence.Content.GraphicsManager.TileSize -
                            RogueElements.Loc(-RogueEssence.Content.GraphicsManager.TileSize / 2, -10)
        local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(entry.Item).Sprite,
            RogueEssence.Content.GraphicsManager.TileSize / 2, 10)
        _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Normal)

        GAME:WaitFrames(10)
        local msg = RogueEssence.StringKey("MSG_GLOW_FOUND_ITEM"):ToLocal()
        _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true),
            inv_item:GetDisplayName()))
        GAME:WaitFrames(10)
        _ZONE.CurrentMap.Items:Add(map_item)
    else
        local msg = RogueEssence.StringKey("MSG_GLOW_FOUND_NO_ITEM"):ToLocal()
        _DUNGEON:LogMsg(RogueEssence.Text.FormatGrammar(msg, context.User:GetDisplayName(true)))
    end
    ResetEffectTile(owner)
end

function SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, args)

    -- if pause == nil then pause = true end
    -- if sound == nil then sound = false end
    local min_amount = 5
    local max_amount = 9
    local max_range_width = 3
    local max_range_height = 3
    local effect_tile = owner
    local x_offset = 0
    local y_offset = 1
    local Items = LUA_ENGINE:MakeGenericType(SpawnListType, {MapItemType}, {})
    local Guaranteed = args.Guaranteed
    local AlwaysSpawn = args.AlwaysSpawn
    -- print(tostring(Guaranteed))
    if type(args.MinAmount) == "number" then
        min_amount = args.MinAmount
    end
    if type(args.MaxAmount) == "number" then
        max_amount = args.MaxAmount
    end
    if type(args.MaxRangeWidth) == "number" then
        max_range_width = args.MaxRangeWidth
    end
    if type(args.MaxRangeHeight) == "number" then
        max_range_height = args.MaxRangeHeight
    end
    if type(args.OffsetX) == "number" then
        x_offset = args.OffsetX
    end
    if type(args.OffsetY) == "number" then
        y_offset = args.OffsetY
    end

    local base_loc = effect_tile.TileLoc + RogueElements.Loc(x_offset, y_offset)

    function checkOp(test_loc)
        local test_tile = _ZONE.CurrentMap:GetTile(test_loc)
        if test_tile ~= nil and not _ZONE.CurrentMap:TileBlocked(test_loc) and test_tile.Data:GetData().BlockType ==
            RogueEssence.Data.TerrainData.Mobility.Passable and
            (test_tile.Effect.ID == nil or test_tile.Effect.ID == "") then
            local item_count = _ZONE.CurrentMap.Items.Count
            for item_idx = 0, item_count - 1, 1 do
                local map_item = _ZONE.CurrentMap.Items[item_idx]
                if map_item.TileLoc == test_loc then
                    return false
                end
            end
            return true
        end
        return false
    end

    for _, value in ipairs(args.Items) do
        local item_name = value.Item
        if item_name == "money" then
            Items:Add(RogueEssence.Dungeon.MapItem.CreateMoney(value.Amount), value.Weight)
        else
            -- print(tostring(_DATA:GetItem(item_name).Price))
            -- _DATA:GetItem(item_name).Price * value.Amount
            Items:Add(RogueEssence.Dungeon.MapItem(item_name, value.Amount), value.Weight)
        end
    end

    local loc_x = base_loc.X
    local loc_y = base_loc.Y

    local x_with_borders = max_range_width + 1
    local y_with_borders = max_range_height + 1
    local bounds = RogueElements.Rect(loc_x - x_with_borders, loc_y - y_with_borders, (2 * y_with_borders) + 1,
        (2 * x_with_borders) + 1)
    local free_tiles = RogueElements.Grid.FindTilesInBox(bounds.Start + RogueElements.Loc(1),
        bounds.Size - RogueElements.Loc(2), checkOp)
    local spawn_items = LUA_ENGINE:MakeGenericType(ListType, {MapItemType}, {})

    local amount = _DATA.Save.Rand:Next(min_amount, max_amount)

    if AlwaysSpawn ~= nil then
        for _, item_name in ipairs(AlwaysSpawn) do
            if free_tiles.Count == 0 then
                break
            end
            local item = RogueEssence.Dungeon.MapItem(item_name, 1)
            local rand_index = _DATA.Save.Rand:Next(free_tiles.Count)
            local item_target_loc = free_tiles[rand_index]
            item.TileLoc = _ZONE.CurrentMap:WrapLoc(item_target_loc)
            free_tiles:RemoveAt(rand_index)
            local offset = RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2)
            local sprite
            if item.IsMoney then
                sprite = RogueEssence.Content.GraphicsManager.MoneySprite
            else
                sprite = _DATA:GetItem(item.Value).Sprite
            end
            local item_anim = RogueEssence.Content.ItemAnim(item_target_loc *
                                                                RogueEssence.Content.GraphicsManager.TileSize + offset -
                                                                RogueElements.Loc(0, 200), item_target_loc *
                RogueEssence.Content.GraphicsManager.TileSize + offset, sprite,
                RogueEssence.Content.GraphicsManager.TileSize * 2, 60)
            _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Bottom)
            GAME:WaitFrames(5)
            _ZONE.CurrentMap.Items:Add(item)
        end
    end
    for _, entries in ipairs(Guaranteed) do
        if free_tiles.Count == 0 then
            break
        end
        local entry = PickByWeights(entries)
        local item_name = entry.Item
        local item
        if item_name == "money" then
            item = RogueEssence.Dungeon.MapItem.CreateMoney(entry.Amount)
        else
            item = RogueEssence.Dungeon.MapItem(item_name, entry.Amount)
        end

        local rand_index = _DATA.Save.Rand:Next(free_tiles.Count)
        local item_target_loc = free_tiles[rand_index]
        item.TileLoc = _ZONE.CurrentMap:WrapLoc(item_target_loc)
        free_tiles:RemoveAt(rand_index)
        local offset = RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2)
        local sprite
        if item.IsMoney then
            sprite = RogueEssence.Content.GraphicsManager.MoneySprite
        else
            sprite = _DATA:GetItem(item.Value).Sprite
        end
        local item_anim = RogueEssence.Content.ItemAnim(
            item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset - RogueElements.Loc(0, 200),
            item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset, sprite,
            RogueEssence.Content.GraphicsManager.TileSize * 2, 60)
        _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Bottom)
        GAME:WaitFrames(5)
        _ZONE.CurrentMap.Items:Add(item)
    end

    for ii = 0, amount - 1, 1 do
        if free_tiles.Count == 0 then
            break
        end

        local spawn_index = Items:PickIndex(_ZONE.CurrentMap.Rand)
        local item = RogueEssence.Dungeon.MapItem(Items:GetSpawn(spawn_index))
        local rand_index = _DATA.Save.Rand:Next(free_tiles.Count)
        local item_target_loc = free_tiles[rand_index]
        item.TileLoc = _ZONE.CurrentMap:WrapLoc(item_target_loc)
        spawn_items:Add(item)
        free_tiles:RemoveAt(rand_index)
        local offset = RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2)
        local sprite
        if item.IsMoney then
            sprite = RogueEssence.Content.GraphicsManager.MoneySprite
        else
            sprite = _DATA:GetItem(item.Value).Sprite
        end
        local item_anim = RogueEssence.Content.ItemAnim(
            item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset - RogueElements.Loc(0, 200),
            item_target_loc * RogueEssence.Content.GraphicsManager.TileSize + offset, sprite,
            RogueEssence.Content.GraphicsManager.TileSize * 2, 60)
        _DUNGEON:CreateAnim(item_anim, RogueEssence.Content.DrawLayer.Bottom)
        GAME:WaitFrames(5)
        _ZONE.CurrentMap.Items:Add(spawn_items[ii])
    end
end

function SINGLE_CHAR_SCRIPT.ItemWishEvent(owner, ownerChar, context, args)
    local chara = context.User
    UI:ResetSpeaker()
    DUNGEON:CharSetAction(chara, RogueEssence.Dungeon.CharAnimPose(chara.CharLoc, chara.CharDir, 0, -1))
    local crystal_moment_status = RogueEssence.Dungeon.MapStatus("crystal_moment")
    crystal_moment_status:LoadFromData()
    if _DATA.CurrentReplay == nil then
        TASK:WaitTask(_DUNGEON:AddMapStatus(crystal_moment_status))
    end

    _ZONE.CurrentMap.HideMinimap = true
    local curr_song = RogueEssence.GameManager.Instance.Song
    SOUND:StopBGM()
    UI:WaitShowDialogue(
        "...[pause=0]Time momentarily pauses.[pause=0] The world around you holds their breath, as the crystal shines brightly.")
    UI:ChoiceMenuYesNo("Would you like to make a wish?", false)
    UI:WaitForChoice()
    local result = UI:ChoiceResult()
    if result then
        local slot = GAME:FindPlayerItem("wish_gem", true, true)
        if slot:IsValid() then
            local wish_choices = M_HELPERS.map(DUNGEON_WISH_TABLE, function(item)
                return item.Category
            end)
            table.insert(wish_choices, "Don't know")
            local end_choice = #wish_choices
            UI:BeginChoiceMenu("What do you desire?", wish_choices, 1, end_choice)
            UI:WaitForChoice()
            choice = UI:ChoiceResult()
            if choice ~= end_choice then
                if slot.IsEquipped then
                    GAME:TakePlayerEquippedItem(slot.Slot)
                else
                    GAME:TakePlayerBagItem(slot.Slot)
                end
                GAME:WaitFrames(50)
                SOUND:PlayBattleSE("_UNK_EVT_044")
                GAME:WaitFrames(10)
                GAME:FadeOut(true, 40)
                -- SOUND:PlayBattleSE("_UNK_EVT_091")
                -- SOUND:PlayBattleSE("_UNK_EVT_096")
                SOUND:PlayBattleSE("EVT_EP_Regi_Permission")
                -- SOUND:PlayBattleSE("EVT_Dimenstional_Scream")
                -- SOUND:PlayBattleSE("EVT_Fade_White")
                -- SOUND:PlayBattleSE("EVT_Evolution_Start")
                TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.User, context.User, _DATA.SendHomeFX))
                -- SOUND:PlayBattleSE("_UNK_EVT_074")
                -- SOUND:PlayBattleSE("_UNK_EVT_084")
                -- SOUND:PlayBattleSE("_UNK_EVT_087")
                local emitter = RogueEssence.Content.SingleEmitter(
                    RogueEssence.Content.AnimData("Last_Resort_Front", 4), 1)

                -- local item_anim = RogueEssence.Content.ItemAnim(start_loc, end_loc, _DATA:GetItem(item).Sprite, RogueEssence.Content.GraphicsManager.TileSize / 2, 10)
                emitter:SetupEmit(owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
                                      RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2),
                    owner.TileLoc * RogueEssence.Content.GraphicsManager.TileSize +
                        RogueElements.Loc(RogueEssence.Content.GraphicsManager.TileSize / 2), Direction.Left)
                _DUNGEON:CreateAnim(emitter, DrawLayer.NoDraw)
                GAME:FadeIn(60)
                GAME:WaitFrames(80)

                local item_table = DUNGEON_WISH_TABLE[choice]
                local arguments = {}
                arguments.MinAmount = item_table.Min
                arguments.MaxAmount = item_table.Max
                arguments.Guaranteed = item_table.Guaranteed
                arguments.Items = item_table.Items
                SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
                GAME:WaitFrames(60)
            end
        else
            UI:WaitShowDialogue("...[pause=0]" .. context.User:GetDisplayName(true) .. " cannot make a wish right now.")
        end
    end
    -- GAME:WaitFrames(5)
    UI:WaitShowDialogue("The crystal became dimmer.")

    if _DATA.CurrentReplay == nil then
        TASK:WaitTask(_DUNGEON:RemoveMapStatus("crystal_moment", false))
        -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(context.User, context.User, _DATA.SendHomeFX))
    end
    SOUND:PlayBGM(curr_song, true, 0)
    GAME:WaitFrames(20)

    _ZONE.CurrentMap.HideMinimap = false
    GAME:WaitFrames(20)
    local stand_anim = RogueEssence.Dungeon.CharAnimNone(context.User.CharLoc, context.User.CharDir)
    stand_anim.MajorAnim = true
    TASK:WaitTask(context.User:StartAnim(stand_anim))
end

function SINGLE_CHAR_SCRIPT.AskWishEvent(owner, ownerChar, context, args)
    local chara = context.User
    if chara.CharDir ~= Direction.Up or chara ~= _DUNGEON.ActiveTeam.Leader then
        return
    end

    _DUNGEON.PendingLeaderAction = _DUNGEON:ProcessPlayerInput(
        RogueEssence.Dungeon.GameAction(RogueEssence.Dungeon.GameAction.ActionType.Tile, Dir8.None, 1))
end

function SINGLE_CHAR_SCRIPT.AskExitEvent(owner, ownerChar, context, args)
    local chara = context.User
    if chara ~= _DUNGEON.ActiveTeam.Leader then
        return
    end

    _DUNGEON.PendingLeaderAction = _DUNGEON:ProcessPlayerInput(
        RogueEssence.Dungeon.GameAction(RogueEssence.Dungeon.GameAction.ActionType.Tile, Dir8.None, 1))
end

function SINGLE_CHAR_SCRIPT.RemoveStatusSingleCharEvent(owner, ownerChar, context, args)
    local chara = context.User
    if chara == nil then
        return
    end
    chara.StatusEffects:Clear()
    chara.ProxyAtk = -1
    chara.ProxyDef = -1
    chara.ProxyMAtk = -1
    chara.ProxyMDef = -1
    chara.ProxySpeed = -1
    chara:FullRestore()
end

function SINGLE_CHAR_SCRIPT.SwapTileEvent(owner, ownerChar, context, args)

    local se = args.SoundEffect
    local tile = args.Tile
    PrintInfo("YEP")
    PrintInfo(tostring(se))

    SOUND:PlaySE(se)
    GAME:WaitFrames(20)
    UI:WaitShowDialogue("............")
    -- local effect_tile = owner
    -- local base_loc = effect_tile.TileLoc
    -- local tile = _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y]
    -- if tile.Effect == owner then
    -- 	tile.Effect = RogueEssence.Dungeon.EffectTile(tile.Effect.TileLoc)
    -- end

    -- local switch_tile = RogueEssence.Dungeon.SwitchTile(effect_tile.TileLoc)
    -- switch_tile:LoadFromData()
    -- _ZONE.CurrentMap.Tiles[base_loc.X][base_loc.Y].Effect = switch_tile
end

SOUND:PlaySE("Menu/Skip")
function PickByWeights(entries)
    local total_weight = 0

    for _, entry in ipairs(entries) do
        total_weight = total_weight + entry.Weight
    end

    local rand_val = _DATA.Save.Rand:NextDouble() * total_weight

    local cummul_weight = 0
    for _, entry in ipairs(entries) do
        cummul_weight = cummul_weight + entry.Weight
        if rand_val <= cummul_weight then
            return entry
        end
    end
end
