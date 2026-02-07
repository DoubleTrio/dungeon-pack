require 'origin.common'
require 'trios_dungeon_pack.emberfrost.enchantments'
require 'trios_dungeon_pack.wish_table.wish_table'
require 'trios_dungeon_pack.helpers'

beholder = require 'trios_dungeon_pack.beholder'

StackStateType = luanet.import_type('RogueEssence.Dungeon.StackState')
DamageDealtType = luanet.import_type('PMDC.Dungeon.DamageDealt')
CountDownStateType = luanet.import_type('RogueEssence.Dungeon.CountDownState')
ListType = luanet.import_type('System.Collections.Generic.List`1')
MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')



SpawnListType = luanet.import_type('RogueElements.SpawnList`1')

function math.round(x)
    return math.floor(x + 0.5)
end

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

function SINGLE_CHAR_SCRIPT.EmberFrostSwapEvent(owner, ownerChar, context, args)
	-- print("HI THEREEEEE")
	GAME:RemovePlayerTeam(0)
	print("EMBER FROST SWAP EVENT TRIGGERED")
end


function SINGLE_CHAR_SCRIPT.AddStatusToLeader(owner, ownerChar, context, args)
    if context.User ~= _DUNGEON.ActiveTeam.Leader then
        return
    end
	local status = RogueEssence.Dungeon.StatusEffect(args.StatusID)
    status:LoadFromData()
    TASK:WaitTask(_DUNGEON.ActiveTeam.Leader:AddStatusEffect(nil, status, true))
end

-- function SINGLE_CHAR_SCRIPT.AddEnchantmentStatus(owner, ownerChar, context, args)
--     local enchantment_id = args.EnchantmentID
--     local status_id = args.StatusID
--     local char = FindCharacterWithEnchantment(enchantment_id)
--     if context.User == char then
--         local status = RogueEssence.Dungeon.StatusEffect(status_id)
--         TASK:WaitTask(context.User:AddStatusEffect(nil, status, true))
--     end
-- end


function Contains(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end


function SINGLE_CHAR_SCRIPT.PandorasItems(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end


    local function RandomDifferent(tbl, current_id)
        if #tbl <= 1 then
            return current_id
        end

        local idx = _DATA.Save.Rand:Next(#tbl - 1) + 1
        local chosen = tbl[idx]
        if chosen == current_id then
            chosen = tbl[#tbl]
        end

        return chosen
    end

    local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1

    for i = inv_count, 0, -1 do
        local item = _DATA.Save.ActiveTeam:GetInv(i)
        local item_id = item.ID
        if Contains(ORBS, item_id) then
            item.ID = RandomDifferent(ORBS, item_id)
        elseif Contains(EQUIPMENT, item_id) then
            item.ID = RandomDifferent(EQUIPMENT, item_id)
        end
    end
end

function SINGLE_CHAR_SCRIPT.EmberfrostOnDeath(owner, ownerChar, context, args)
    print("DEATH TRIGGERED")
    beholder.trigger("OnDeath", owner, ownerChar, context, args)
end

function SINGLE_CHAR_SCRIPT.LogQuests(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end

    local selected = QuestRegistry:GetSelected()

    _DUNGEON:LogMsg("Quests:")
    for _, quest in pairs(selected) do
        _DUNGEON:LogMsg(string.format("%s (%s)", quest:getDescription(), M_HELPERS.MakeColoredText(tostring(quest.reward), PMDColor.Cyan) .. " " ..  PMDSpecialCharacters.Money))
    end
end

function SINGLE_CHAR_SCRIPT.EmberfrostOnMapStarts(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end
    beholder.trigger("OnMapStarts", owner, ownerChar, context, args)
    SV.EmberFrost.LastFloor = _ZONE.CurrentMapID.ID
end

function SINGLE_CHAR_SCRIPT.EmberfrostOnMapTurnEnds(owner, ownerChar, context, args)
    beholder.trigger("OnMapTurnEnds", owner, ownerChar, context, args)
end

function SINGLE_CHAR_SCRIPT.EmberfrostOnTurnEnds(owner, ownerChar, context, args)

    if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
        return
    end

    beholder.trigger("OnTurnEnds", owner, ownerChar, context, args)
end



function SINGLE_CHAR_SCRIPT.EmberfrostOnTurnStarts(owner, ownerChar, context, args)

    if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
        return
    end

    beholder.trigger("OnTurnStarts", owner, ownerChar, context, args)
end



function SINGLE_CHAR_SCRIPT.EmberfrostOnWalks(owner, ownerChar, context, args)

    if context.User.MemberTeam ~= _DUNGEON.ActiveTeam then
        return
    end

    beholder.trigger("OnWalks", owner, ownerChar, context, args)
end

function SINGLE_CHAR_SCRIPT.SupplyDrop(owner, ownerChar, context, args)

    local drop_table = args.DropTable
    local enchant_id = args.EnchantmentID
    
    if context.User ~= _DUNGEON.ActiveTeam.Leader then
        return
    end

     
    local data = EnchantmentRegistry:GetData(enchant_id)

    if not data["can_receive_supply_drop"] then
        return
    end

    data["can_receive_supply_drop"] = false
    local arguments = {}
    arguments.MinAmount = drop_table.Min
    arguments.MaxAmount = drop_table.Max
    arguments.Guaranteed = drop_table.Guaranteed
    arguments.Items = drop_table.Items
    arguments.UseUserCharLoc = true
    _DUNGEON:LogMsg(STRINGS:Format("A supply drop arrived!"))

    SOUND:PlayBattleSE("_UNK_EVT_124")
     GAME:WaitFrames(10)
    SINGLE_CHAR_SCRIPT.WishSpawnItemsEvent(owner, ownerChar, context, arguments)
  
    GAME:WaitFrames(60)
end

function SINGLE_CHAR_SCRIPT.PlantYourSeeds(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end

    local min_seed = args.MinimumSeeds
    local amt_per_seed = args.MoneyPerSeed
    local enchant_id = args.EnchantmentID
    

    local seed_index_arr = {}

    local inv_count = _DATA.Save.ActiveTeam:GetInvCount() - 1
    for i = inv_count, 0, -1 do
        local item = _DATA.Save.ActiveTeam:GetInv(i)
        local item_id = item.ID
        if Contains(SEED, item_id) then
            table.insert(seed_index_arr, i)
        end        
    end


    if (#seed_index_arr >= min_seed) then
        local total_money = #seed_index_arr * amt_per_seed
        for _, index in ipairs(seed_index_arr) do
            _DATA.Save.ActiveTeam:RemoveFromInv(index)
        end
        local team_name = _DATA.Save.ActiveTeam.Name
        GAME:AddToPlayerMoney(total_money)
        local data = EnchantmentRegistry:GetData(enchant_id)
        data["money_earned"] = data["money_earned"] + total_money
        SOUND:PlayBattleSE("DUN_Money")
        _DUNGEON:LogMsg(
            string.format(
                "%s planted %s seed(s) and gained %s!", 
                team_name, 
                M_HELPERS.MakeColoredText(tostring(#seed_index_arr), PMDColor.Cyan),
                M_HELPERS.MakeColoredText(tostring(total_money) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
            )
        )
    
    end
end

function SINGLE_CHAR_SCRIPT.Minimalist(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end

    local enchant_id = args.EnchantmentID
    local slot_amt = args.AmountPerSlot
    local data = EnchantmentRegistry:GetData(enchant_id)
    local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
    local max_inv_slots = _DATA.Save.ActiveTeam:GetMaxInvSlots(_ZONE.CurrentZone)

    local available_slots = max_inv_slots - inv_count

    local total_money = available_slots * slot_amt
    data["money_earned"] = data["money_earned"] + total_money
    GAME:AddToPlayerMoney(total_money)
    SOUND:PlayBattleSE("DUN_Money")
    _DUNGEON:LogMsg(
        string.format(
            "Gained %s from Minimalist!", 
            M_HELPERS.MakeColoredText(tostring(total_money) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
        )
    )
end


function GetSpawnCandidates(origin, radius)
    local top_left = RogueElements.Loc(origin.X - radius, origin.Y - radius)
    local bottom_right = RogueElements.Loc(origin.X + radius, origin.Y + radius)

    local near_candidates = {}
    local far_candidates = {}

    for x = top_left.X, bottom_right.X do
        for y = top_left.Y, bottom_right.Y do
            local testLoc = RogueElements.Loc(x, y)

            if not _ZONE.CurrentMap:TileBlocked(testLoc)
                and _ZONE.CurrentMap:GetCharAtLoc(testLoc) == nil then
                local min_dist = math.huge

                -- check party
                for i = 0, GAME:GetPlayerPartyCount() - 1 do
                    local member = GAME:GetPlayerPartyMember(i)
                    local dx = math.abs(member.CharLoc.X - x)
                    local dy = math.abs(member.CharLoc.Y - y)
                    min_dist = math.min(min_dist, math.max(dx, dy))
                end

                -- check guests
                for i = 0, GAME:GetPlayerGuestCount() - 1 do
                    local member = GAME:GetPlayerGuestMember(i)
                    local dx = math.abs(member.CharLoc.X - x)
                    local dy = math.abs(member.CharLoc.Y - y)
                    min_dist = math.min(min_dist, math.max(dx, dy))
                end

                if min_dist == 1 then
                    table.insert(near_candidates, testLoc)
                elseif min_dist == 2 then
                    table.insert(far_candidates, testLoc)
                end
            end
        end
    end

   
    if #near_candidates > 0 then
        return near_candidates
    end

    return far_candidates
end



function CloneCharacter(chara)
    local character = RogueEssence.Dungeon.CharData()

    character.BaseForm = chara.BaseForm
    character.Nickname = chara.Nickname
    character.Level = chara.Level
    character.MaxHPBonus = chara.MaxHPBonus
    character.AtkBonus = chara.AtkBonus
    character.DefBonus = chara.DefBonus
    character.MAtkBonus = chara.MAtkBonus
    character.MDefBonus = chara.MDefBonus
    character.SpeedBonus = chara.SpeedBonus
    character.Unrecruitable = chara.Unrecruitable

    for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
        character.BaseSkills[ii] = RogueEssence.Dungeon.SlotSkill(chara.BaseSkills[ii])
    end

    for ii = 0, RogueEssence.Dungeon.CharData.MAX_INTRINSIC_SLOTS - 1 do
        character.BaseIntrinsics[ii] = chara.BaseIntrinsics[ii]
    end
    character.FormIntrinsicSlot = chara.FormIntrinsicSlot

    local new_mob = RogueEssence.Dungeon.Character(chara)

    new_mob.IdleOverride = chara.IdleOverride
    local idleAction = RogueEssence.Dungeon.CharAnimIdle(chara.CharLoc, chara.CharDir)
    if chara.IdleOverride > -1 then
        idleAction.Override = chara.IdleOverride
    end
    -- new_mob.currentCharAction = RogueEssence.Dungeon.EmptyCharAction(idleAction)

    new_mob.Tactic = RogueEssence.Data.AITactic(chara.Tactic)
    -- new_mob.EquippedItem = RogueEssence.Dungeon.InvItem(chara.EquippedItem)

    for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
        new_mob.Skills[ii].Element.Enabled = chara.Skills[ii].Element.Enabled
    end

    -- for key, status in pairs(chara.StatusEffects) do
    --     new_mob.StatusEffects:Add(key, status:Clone())
    -- end

    return new_mob
end

function SINGLE_CHAR_SCRIPT.RemoveGuestWithIDBackground(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end

    local id = args.ID
    RemoveGuestsWithValue(id)
end

function SINGLE_CHAR_SCRIPT.Puppeteer(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end

    local type = args.Type
    local enchant_id = args.EnchantmentID
    local include_assembly = args.IncludeAssembly or false
    RemoveGuestsWithValue(enchant_id)

    local members = GetCharacterOfMatchingType(type, include_assembly)

    for i, member in ipairs(members) do

        local spawn_candidates = GetSpawnCandidates(member.CharLoc, 2)
        local clone = CloneCharacter(member)
        local tbl = LTBL(clone)
        clone.CharLoc = spawn_candidates[_DATA.Save.Rand:Next(#spawn_candidates) + 1]
        tbl[enchant_id] = true
        local tactic = _DATA:GetAITactic("go_after_foes")
        clone.Tactic = tactic
        clone.Nickname = "Puppet"
        for ii = 0, 3 do
            local skill = clone.Skills[ii].Element
            if skill.SkillNum ~= nil and skill.SkillNum ~= "" then
                clone:SetSkillCharges(ii, 5)
            end

            skill.Enabled = true
        end

        -- Debating whether to keep the abilities or not
        -- clone.BaseIntrinsics[0] = ""
        -- clone.Intrinsics[0].Element.ID = ""
        clone.Element1 = "ghost"
        clone.Element2 = _DATA.DefaultElement

        clone.ActionEvents:Clear()
        local talk_evt = RogueEssence.Dungeon.BattleScriptEvent("PuppetInteract")
        clone.ActionEvents:Add(talk_evt)
        local tbl = LTBL(clone)
        tbl["species"] = member.BaseForm.Species
        tbl[enchant_id] = true
        
        
        
        local status = RogueEssence.Dungeon.StatusEffect("emberfrost_appearance_proxy")
        status:LoadFromData()
        TASK:WaitTask(clone:AddStatusEffect(nil, status, true))
        -- for ii = 0, RogueEssence.Dungeon.CharData.MAX_SKILL_SLOTS - 1 do
        --     clone.BaseSkills[ii].Charges = 5
        -- end

            --         for (int ii = 0; ii < target.Skills.Count; ii++)
            -- {
            --     if (!String.IsNullOrEmpty(target.Skills[ii].Element.SkillNum))
            --         target.SetSkillCharges(ii, 1);
            -- }

      

        -- local monster = RogueEssence.Dungeon.MonsterID("missingno",
        --     1,
        --     "normal",
        --     Gender.Genderless)
        -- clone.ProxySprite = monster
        -- clone

       
        _DATA.Save.ActiveTeam.Guests:Add(clone)
        -- Dark_Void_Front


        local anim = RogueEssence.Dungeon.CharAbsentAnim(clone.CharLoc, clone.CharDir)

        -- COMMON.RemoveCharEffects(player)
        -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))


        TASK:WaitTask(clone:StartAnim(anim))

        local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Dark_Void_Front", 1))

        -- emitter.DrawLayer = DrawLayer.Front
        emitter.Layer = DrawLayer.Front

        DUNGEON:PlayVFX(emitter, clone.CharLoc.X * 24 + 12, clone.CharLoc.Y * 24 + 12)
        SOUND:PlayBattleSE("DUN_Night_Shade_3")
        GAME:WaitFrames(30)

        local anim = RogueEssence.Dungeon.CharAbsentAnim(clone.CharLoc, clone.CharDir)
        

        -- COMMON.RemoveCharEffects(player)
        -- TASK:WaitTask(_DUNGEON:ProcessBattleFX(player, player, _DATA.SendHomeFX))


        -- for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        --     if member.Dead == false then
  
        --     end
        -- end
        TASK:WaitTask(clone:StartAnim(anim))


        local stand_anim = RogueEssence.Dungeon.CharAnimNone(clone.CharLoc, clone.CharDir)
        stand_anim.MajorAnim = true
        TASK:WaitTask(clone:StartAnim(stand_anim))

        -- DUNGEON:PlayVFX(emitter, base_loc.X * 24 + 12, base_loc.Y * 24)
        -- GROUND:Hide("Apple")
        -- GROUND:PlayVFX(emitter, apple.Bounds.Center.X, apple.Bounds.Center.Y)


    end
end

function SINGLE_CHAR_SCRIPT.TarotCards(owner, ownerChar, context, args)
    -- print("PUPPET MASTER TRIGGERED")
    if context.User ~= nil then
        return
    end


    local type = args.Type
    local enchant_id = args.EnchantmentID
    local include_assembly = args.IncludeAssembly or false


    local members = GetCharacterOfMatchingType(type, include_assembly)
    for i, member in ipairs(members) do


        SOUND:PlayBattleSE('_UNK_DUN_TWINKLE')

        -- if 


        -- GAME:

	-- 		--print("Set crit health!")
	-- 	elseif player.HP > player.MaxHP / 4 and player:GetStatusEffect("critical_health") ~= nil then
	-- 		TASK:WaitTask(player:RemoveStatusEffect("critical_health"))


        -- local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Card", 3))
        -- arriveAnim:SetupEmitted(RogueElements.Loc(member.CharLoc.X * 24 + 12, member.CharLoc.Y * 24 + 12), 32,
        --     RogueElements.Dir8.Down)
        -- DUNGEON:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)


        -- local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Card", 3))
        -- arriveAnim:SetupEmitted(RogueElements.Loc(member.CharLoc.X * 24 + 12, member.CharLoc.Y * 24 + 12))
        -- DUNGEON:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)


        local card = TarotRegistry:GetRandom(1, 1)[1][1]

        --initialize status data before adding it to anything

        -- if card.add_as_status then
        local card_status = RogueEssence.Dungeon.StatusEffect("emberfrost_card")
        card_status:LoadFromData()
        TASK:WaitTask(member:AddStatusEffect(nil, card_status, false))
        -- end
        -- else
        --     local emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Card", 3), 1)
        --     emitter.Layer = DrawLayer.Front
        --     DUNGEON:PlayVFX(emitter, member.CharLoc.X * 24 + 12, member.CharLoc.Y * 24 - 6)
        --     -- GraphicsManager.GetChara(Appearance).TileHeight
        -- end
        card:apply(owner, ownerChar, context, args, member)


        -- if card.add_as_status then
        GAME:WaitFrames(20)
        TASK:WaitTask(member:RemoveStatusEffect("emberfrost_card"))
        -- end

    end
end

        -- local enchant_id = args.EnchantmentID
        -- local slot_amt = args.AmountPerSlot
        -- local data = EnchantmentRegistry:GetData(enchant_id)
        -- local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
        -- local max_inv_slots = _DATA.Save.ActiveTeam:GetMaxInvSlots(_ZONE.CurrentZone)

        -- local available_slots = max_inv_slots - inv_count

        -- local total_money = available_slots * slot_amt
        -- data["money_earned"] = data["money_earned"] + total_money
        -- GAME:AddToPlayerMoney(total_money)
        -- SOUND:PlayBattleSE("DUN_Money")
        -- _DUNGEON:LogMsg(
        --     string.format(
        --         "Gained %s from Minimalist for %s!", 
        --         M_HELPERS.MakeColoredText(tostring(total_money) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan),
        --         member:GetDisplayName(true)
        --     )
        -- )


    -- local enchant_id = args.EnchantmentID
    -- local slot_amt = args.AmountPerSlot
    -- local data = EnchantmentRegistry:GetData(enchant_id)
    -- local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
    -- local max_inv_slots = _DATA.Save.ActiveTeam:GetMaxInvSlots(_ZONE.CurrentZone)

    -- local available_slots = max_inv_slots - inv_count

    -- local total_money = available_slots * slot_amt
    -- data["money_earned"] = data["money_earned"] + total_money
    -- GAME:AddToPlayerMoney(total_money)
    -- SOUND:PlayBattleSE("DUN_Money")
    -- _DUNGEON:LogMsg(
    --     string.format(
    --         "Gained %s from Minimalist!",
    --         M_HELPERS.MakeColoredText(tostring(total_money) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan)
    --     )
    -- )


function SINGLE_CHAR_SCRIPT.GiveRandomForEachType(owner, ownerChar, context, args)
    if context.User ~= nil then
        return
    end


    local type = args.Type
    local item_tbl = args.ItemTable
    local include_assembly = args.IncludeAssembly or false
    local sound = args.Sound or "DUN_Me_First_2"
    local anim_name = args.AnimName or "Circle_Green_Out"

    local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
    local max_inv_slots = _DATA.Save.ActiveTeam:GetMaxInvSlots(_ZONE.CurrentZone)
    local available_slots = max_inv_slots - inv_count
    local members = GetCharacterOfMatchingType(type, include_assembly)
    local count = #members

    local give_count = math.min(count, available_slots)

    -- Sound\      SOUND:PlayBattleSE("DUN_Ice_Shard")
    -- TODO: Play a visual effect for each party member that matches that type

    --     },
    -- "Value": {
    -- "$type": "PMDC.Dungeon.BerryAoEEvent, PMDC",
    -- "Msg": {
    -- "Key": "MSG_HARVEST"
    -- },
    -- "Emitter": {
    -- "$type": "RogueEssence.Content.RepeatEmitter, RogueEssence",
    -- "LocHeight": 0,
    -- "Anim": {
    -- "$type": "RogueEssence.Content.StaticAnim, RogueEssence",
    -- "Anim": {
    -- "AnimIndex": "Circle_Green_Out",
    -- "FrameTime": 2,
    -- "StartFrame": -1,
    -- "EndFrame": -1,
    -- "AnimDir": -1,
    -- "Alpha": 255,
    -- "AnimFlip": 0
    -- },
    -- "TotalTime": 0,
    -- "Cycles": 1,
    -- "FrameOffset": 0
    -- },
    -- "Bursts": 3,
    -- "BurstTime": 8,
    -- "Layer": 2,
    -- "Offset": 0
    -- },
    -- "Sound": "DUN_Me_First_2"
    -- }
    -- }
    if give_count == 0 then
        return
    end



    for i, member in ipairs(members) do

        SOUND:PlayBattleSE(sound)

        -- public AnimData(string animIndex, int frameTime, int startFrame, int endFrame)

        local anim_data = RogueEssence.Content.AnimData(anim_name, 2, -1, -1, 255)

        -- AnimData(string animIndex, int frameTime, int startFrame, int endFrame, byte alpha, Dir8 dir)
        -- public ParticleAnim(AnimData anim, int cycles, int totalTime)
        local emitter = RogueEssence.Content.RepeatEmitter(anim_data)
        -- local emitter = RogueEssence.Content.SqueezedAreaEmitter(repeat_anim)
        emitter.Bursts = 3
        emitter.BurstTime = 8

        -- print(tostring(emitter) .. " emitter")

        -- SOUND:PlayBattleSE("DUN_Tri_Attack_2")
        -- SOUND:PlayBattleSE("_UNK_EVT_085")

        -- SOUND:PlayBattleSE("_UNK_EVT_043")
        DUNGEON:PlayVFX(emitter, member.MapLoc.X, member.MapLoc.Y)
        GAME:WaitFrames(10)
        

    end

        --     public override IEnumerator<YieldInstruction> Apply(GameEventOwner owner, Character ownerChar, BattleContext context)
        -- {
        --     if (context.ActionType == BattleActionType.Item)
        --     {
        --         ItemData itemData = DataManager.Instance.GetItem(context.Item.ID);
        --         if (itemData.ItemStates.Contains<BerryState>())
        --         {
        --             AreaAction newAction = new AreaAction();
        --             newAction.TargetAlignments = (Alignment.Self | Alignment.Friend);
        --             newAction.Range = 1;
        --             newAction.ActionFX.Emitter = Emitter;
        --             newAction.Speed = 10;
        --             newAction.ActionFX.Sound = Sound;
        --             newAction.ActionFX.Delay = 30;
        --             context.HitboxAction = newAction;
        --             context.Explosion.TargetAlignments = (Alignment.Self | Alignment.Friend);

        --             DungeonScene.Instance.LogMsg(Text.FormatGrammar(Msg.ToLocal(), ownerChar.GetDisplayName(false), owner.GetDisplayName()));
        --         }
        --     }
        --     yield break;
        -- }
    
    for i = 1, give_count do
        print("GIVE RANDOM FOR EACH TYPE TRIGGERED3")
        local rand_index = _DATA.Save.Rand:Next(#item_tbl) + 1
        local item = item_tbl[rand_index]
        print("Giving item: " .. item)
        GAME:GivePlayerItem(item)
    end
end

function SINGLE_CHAR_SCRIPT.TheBubble(owner, ownerChar, context, args)

    if context.User ~= _DUNGEON.ActiveTeam.Leader then
        return
    end

    local enchantment_id = args.EnchantmentID
    local data = EnchantmentRegistry:GetData(enchantment_id)
    -- local money_lost = data["money_lost"]
    local pop_chance = data["pop_chance"]
    local enchantment = EnchantmentRegistry:Get(enchantment_id)
    local interest = enchantment.interest
    local pop_increase = enchantment.pop_increase
    local loss = enchantment.loss
    local item_name = M_HELPERS.GetItemName("emberfrost_bubble")

    local total_money = _DATA.Save.ActiveTeam.Money

    if (_DATA.Save.Rand:NextDouble() * 100 < pop_chance) then
        SOUND:PlayBattleSE("DUN_Ice_Shard")
        local total_money = _DATA.Save.ActiveTeam.Money

        local lost_amount = math.round(total_money * loss)
        GAME:RemoveFromPlayerMoney(lost_amount)
        data["money_lost"] = data["money_lost"] + lost_amount
        data["pop_chance"] = 0


        _DUNGEON:LogMsg(
            string.format(
                "Oh no! The %s popped! %s was lost...", 
                item_name,
                M_HELPERS.MakeColoredText(tostring(lost_amount) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Red)
            )
        )
    else
        

        local gained = math.round(total_money * interest)

        if (gained > 0) then
            SOUND:PlayBattleSE("DUN_Money")
            data["pop_chance"] = data["pop_chance"] + pop_increase
            GAME:AddToPlayerMoney(gained)
            data["money_earned"] = data["money_earned"] + gained
            _DUNGEON:LogMsg(
            string.format(
                "%s was gained from the %s", 
                M_HELPERS.MakeColoredText(tostring(gained) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Cyan),
                item_name
            )
        )
            
        end

    end

    -- if _DATA.Save.Rand:Next(100) < pop_chance then
    --     SOUND:PlayBattleSE("DUN_Money_Loss")
    --     local team_name = _DATA.Save.ActiveTeam.Name
    --     local lost_amount = math.min(money_earned, money_lost)
    --     GAME:TakeFromPlayerMoney(lost_amount)
    --     data["money_earned"] = money_earned - lost_amount
    --     _DUNGEON:LogMsg(
    --         string.format(
    --             "%s's bubble popped! Lost %s!", 
    --             team_name, 
    --             M_HELPERS.MakeColoredText(tostring(lost_amount) .. " " .. STRINGS:Format("\\uE024"), PMDColor.Red)
    --         )
    --     )
    -- end
    print("BUBBLE EVENT")
end

function SINGLE_CHAR_SCRIPT.AddEnchantmentStatus(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end

    local enchantment_id = args.EnchantmentID
    local status_id = args.StatusID
    local apply_to_all = args.ApplyToAll or false
    local char = FindCharacterWithEnchantment(enchantment_id)

    --    print(enchantment_id)
    if apply_to_all then
        for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
            if member ~= nil then
                local status = RogueEssence.Dungeon.StatusEffect(status_id)
                status:LoadFromData()
                TASK:WaitTask(member:AddStatusEffect(nil, status, true))
            end
        end

        for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
            if member ~= nil then
                local status = RogueEssence.Dungeon.StatusEffect(status_id)
                status:LoadFromData()
                TASK:WaitTask(member:AddStatusEffect(nil, status, true))
            end
        end
        return
    end


    if context.User == char then
       
        if not char.Dead then
             print("did it find the char?" .. enchantment_id)
            local status = RogueEssence.Dungeon.StatusEffect(status_id)
            status:LoadFromData()
            TASK:WaitTask(context.User:AddStatusEffect(nil, status, true))
        end
    end
end


function SINGLE_CHAR_SCRIPT.EmberFrostJeweledBugEvent(owner, ownerChar, context, args)
	if context.User == _DUNGEON.ActiveTeam.Leader then
		return
	end

	local valid_slots = {}
	
	local inv_count = _DATA.Save.ActiveTeam:GetInvCount()
	local jeweled_bug_slot = -1
	for i = 0, inv_count - 1 do
		local item = _DATA.Save.ActiveTeam:GetInv(i)
		local entry = _DATA.DataIndices[RogueEssence.Data.DataManager.DataType.Item]:Get(item.ID)
		if item.ID == "emberfrost_jeweled_bug" then
			jeweled_bug_slot = i
		end
		if not entry.CannotDrop then
			table.insert(valid_slots, i)
		end
	end

	local jeweled_bug_item = _DATA.Save.ActiveTeam:GetInv(jeweled_bug_slot)
	if (#valid_slots > 0) then
		local rand_index = _DATA.Save.Rand:Next(#valid_slots)
		local swap_slot = valid_slots[(rand_index + 1)]
		local item = _DATA.Save.ActiveTeam:GetInv(swap_slot)
		_DUNGEON:LogMsg("The " .. jeweled_bug_item:GetDisplayName() .. " has eaten the " .. item:GetDisplayName() .. "!")
		SOUND:PlayBattleSE("_UNK_DUN_Twinkle")
		_DATA.Save.ActiveTeam:RemoveFromInv(swap_slot)
	else
		if (jeweled_bug_slot ~= -1) then
			_DUNGEON:LogMsg("The " .. jeweled_bug_item:GetDisplayName() .. " couldn't find anything to eat and left!")
			SOUND:PlayBattleSE("_UNK_EVT_002") -- DUN_Wing_Attack
			_DATA.Save.ActiveTeam:RemoveFromInv(jeweled_bug_slot)
		end
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



function SINGLE_CHAR_SCRIPT.ApplyStatusIfTypeMatches(owner, ownerChar, context, args)

    if context.User ~= nil then
        return
    end
    
    local status_id = args.StatusID
    local types = args.Types

    for member in luanet.each(_DATA.Save.ActiveTeam.Players) do
        for _, t in ipairs(types) do
            if member.Element1 == t or member.Element2 == t then
                print("Applying status to " .. member:GetDisplayName(true))
                print("Status ID: " .. status_id)
                local status = RogueEssence.Dungeon.StatusEffect(status_id)
                status:LoadFromData()
                TASK:WaitTask(member:AddStatusEffect(nil, status, true))
                break
            end
        end
    end

    for member in luanet.each(_DATA.Save.ActiveTeam.Assembly) do
        local tbl = LTBL(member)
        if tbl.EmberfrostRun then
            for _, t in ipairs(types) do
                if member.Element1 == t or member.Element2 == t then
                    print("Applying status to " .. member:GetDisplayName(true))
                    print("Status ID: " .. status_id)
                    local status = RogueEssence.Dungeon.StatusEffect(status_id)
                    TASK:WaitTask(member:AddStatusEffect(nil, status, true))
                    break
                end
            end
        end
    end

    

    -- if context.User == char then
    --     if not char.Dead then
    --         print("did it find the char?" .. enchantment_id)
    --         local status = RogueEssence.Dungeon.StatusEffect(status_id)
    --         TASK:WaitTask(context.User:AddStatusEffect(nil, status, true))
    --     end
    -- end
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

	--  print("EMBER FROST TEST TRIGGERED GRRR")
    if context.User == GAME:GetPlayerPartyMember(1) then
        -- print("EMBER FROST TEST TRIGGERED HIHI")
					-- local powerup = Bag

					-- if powerup:can_apply() then
					-- 	powerup:apply()
					-- end
        -- GAME:RemovePlayerTeam(0)
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
    print("eeeememem")

    local map = _ZONE.CurrentMap
    for xx = 0, map.Width - 1, 1 do
        for yy = 0, map.Height - 1, 1 do
            local loc = RogueElements.Loc(xx, yy)
            local tl = map:GetTile(loc)

            if tl.Effect.ID == "stairs_go_up" or tl.Effect.ID == "stairs_go_down" or tl.Effect.ID == "stairs_back_down" or
                tl.Effect.ID == "stairs_back_up" then
                print("Found stairs at " .. xx .. ", " .. yy)
                local sec_loc = RogueEssence.Dungeon.SegLoc(-1, args.NextID)
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
    local use_user_char_loc = args.UseUserCharLoc

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

    local base_loc
    if use_user_char_loc then   
        base_loc = context.User.CharLoc
    else
        base_loc = effect_tile.TileLoc
    end
    base_loc = base_loc + RogueElements.Loc(x_offset, y_offset)

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






-- --For use in the Terrakion Fight and his dungeon after the midway point.
-- function SINGLE_CHAR_SCRIPT.QueueRockFall(owner, ownerChar, context, args)
--     --random chance for floor tiles to become a "falling rock shadow" tile.
--     local map = _ZONE.CurrentMap

--     SOUND:PlayBattleSE("EVT_Tower_Quake")
--     --minshake, maxshake, shaketime
--     DUNGEON:MoveScreen(RogueEssence.Content.ScreenMover(3, 6, 40))
--     _DUNGEON:LogMsg(STRINGS:Format("A great power shakes the cavern!"))

--     --flavor rocks; rocks should fall all over, not just on you.
--     for xx = 0, map.Width - 1, 1 do
--         for yy = 0, map.Height - 1, 1 do
--             --1/8 chance to set a tile to rock fall.  is
--             if map.Rand:Next(1, 9) == 1 then
--                 local loc = RogueElements.Loc(xx, yy)
--                 local tile = map:GetTile(loc)
--                 --Make sure the tile is a floor tile and has nothing on it already (traps)
--                 if tile.ID == _DATA.GenFloor and tile.Effect.ID == '' then
--                     tile.Effect = RogueEssence.Dungeon.EffectTile('falling_rock_shadow', true, loc)
--                 end
--             end
--         end
--     end

--     --for every pokemon on the floor, queue up extra rocks around them. Always make sure a spot is clear within one tile of them though!
--     --todo: Improve code efficiency. Multiple for loops for each party instead of transferring to a lua table if this proves to be too slow.
--     local floor_mons = {}

--     --your team
--     for i = 0, GAME:GetPlayerPartyCount() - 1, 1 do
--         table.insert(floor_mons, GAME:GetPlayerPartyMember(i))
--         print("PlayerParty" .. i)
--     end

--     for i = 0, GAME:GetPlayerGuestCount() - 1, 1 do
--         table.insert(floor_mons, GAME:GetPlayerGuestMember(i))
--         print("GuestParty" .. i)
--     end

--     --enemy teams
--     for i = 0, map.MapTeams.Count - 1, 1 do
--         local team = map.MapTeams[i].Players
--         for j = 0, team.Count - 1, 1 do
--             table.insert(floor_mons, team[j])
--             print("EnemyTeam" .. i)
--         end
--     end

--     --neutrals
--     for i = 0, map.AllyTeams.Count - 1, 1 do
--         local team = map.AllyTeams[i].Players
--         for j = 0, team.Count - 1, 1 do
--             table.insert(floor_mons, team[j])
--             print("Neutral" .. i)
--         end
--     end

--     print("length = " .. tostring(#floor_mons))

--     for i = 1, #floor_mons, 1 do
--         local member = floor_mons[i] --RogueEssence.Dungeon.Character
--         local charLoc = member.CharLoc

--         --Spawn extra boulders near Pokemon in a 3x3 radius.
--         --Don't spawn boulders on top of terrakion; they'll be too good at killing him if this happens.
--         if member.CurrentForm.Species ~= 'terrakion' then
--             for xx = -1, 1, 1 do
--                 for yy = -1, 1, 1 do
--                     --pass a check with 66% success rate. If you do, spawn a boulder shadow.
--                     --Bound these values to stay in bounds. This has a byproduct of condensing boulders a bit when at map edges, but this shouldn't come into practice much.
--                     if map.Rand:Next(1, 4) ~= 1 then
--                         local boulderX = charLoc.X + xx
--                         local boulderY = charLoc.Y + yy

--                         if boulderX < 0 then boulderX = 0 end
--                         if boulderY < 0 then boulderY = 0 end

--                         if boulderX >= map.Width then boulderX = map.Width - 1 end
--                         if boulderY >= map.Height then boulderY = map.Height - 1 end

--                         local loc = RogueElements.Loc(charLoc.X + xx, charLoc.Y + yy)
--                         local tile = map:GetTile(loc)
--                         if tile.ID == _DATA.GenFloor and tile.Effect.ID == '' then
--                             tile.Effect = RogueEssence.Dungeon.EffectTile('falling_rock_shadow', true, loc)
--                         end
--                     end
--                 end
--             end
--         end
--     end


--     --loop through the pokemon on the floor again; this time clean 1 boulder next to each pokemon.
--     --this is to help prevent RNG screwing you over into a checkmate scenario
--     for i = 1, #floor_mons, 1 do
--         local member = floor_mons[i] --RogueEssence.Dungeon.Character
--         local charLoc = member.CharLoc

--         --Clear 1 space nearby each pokemon.
--         local nearby_boulder_locs = {}

--         --again, Terrakion is an exception. Dont remove boulders near him since we aren't spawning them near him.
--         --todo: make this less hacky? Maybe just remove him from the overall list instead of exceptioning him twice? but would such a search be too slow?
--         if member.CurrentForm.Species ~= 'terrakion' then
--             for xx = -1, 1, 1 do
--                 for yy = -1, 1, 1 do
--                     local boulderX = charLoc.X + xx
--                     local boulderY = charLoc.Y + yy

--                     if boulderX < 0 then boulderX = 0 end
--                     if boulderY < 0 then boulderY = 0 end

--                     if boulderX >= map.Width then boulderX = map.Width - 1 end
--                     if boulderY >= map.Height then boulderY = map.Height - 1 end

--                     local loc = RogueElements.Loc(charLoc.X + xx, charLoc.Y + yy)
--                     local tile = map:GetTile(loc)
--                     if tile.Effect.ID == 'falling_rock_shadow' then
--                         table.insert(nearby_boulder_locs, loc)
--                     end
--                 end
--             end

--             --Finally clear the tile.
--             if #nearby_boulder_locs > 0 then
--                 local loc = nearby_boulder_locs[map.Rand:Next(1, #nearby_boulder_locs + 1)]
--                 local tile = map:GetTile(loc)
--                 tile.Effect = RogueEssence.Dungeon.EffectTile('', true, loc)
--             end
--         end
--     end



--     GAME:WaitFrames(30)
-- end

-- function SINGLE_CHAR_SCRIPT.ResolveRockFall(owner, ownerChar, context, args)
--     --Resolve the queued up rock falls. Play the animation in 4 waves so the animations aren't 100% synced up; what wave you're in is your x pos + y pos modulo 4 + 1.

--     local waves = { {}, {}, {}, {} }
--     local map = _ZONE.CurrentMap
--     local width = map.Width
--     local height = map.Height

--     SOUND:PlayBattleSE("DUN_Rock_Throw")

--     --drops a boulder on a location
--     local function DropBoulder(loc)
--         --emitter for the result anim of our main emitter
--         local result_emitter = RogueEssence.Content.SingleEmitter(RogueEssence.Content.AnimData("Rock_Smash_Front", 2))
--         result_emitter.Layer = RogueEssence.Content.DrawLayer.Front

--         --falling boulder animation. Emitter attributes are mostly self explanatory.
--         local emitter = RogueEssence.Content.MoveToEmitter()
--         emitter.MoveTime = 30
--         emitter.Anim = RogueEssence.Content.AnimData("Rock_Piece_Rotating", 2)
--         emitter.ResultAnim =
--         result_emitter                --this result anim can be any other emitter i believe, not just an emptyfiniteemitter.
--         emitter.ResultLayer = RogueEssence.Content.DrawLayer.Front
--         emitter.HeightStart = 240
--         emitter.HeightEnd = 0
--         --emitter.OffsetStart = 0 --these are saved as Locations i believe, not as ints
--         --emitter.OffsetEnd = 0
--         emitter.LingerStart = 0 --linger is having the anim stay still before or after it moves
--         emitter.LingerEnd = 0
--         DUNGEON:PlayVFX(emitter, loc.X * 24 + 12, loc.Y * 24 + 16)

--         GAME:WaitFrames(30)

--         --clear the shadow
--         map:GetTile(loc).Effect = RogueEssence.Dungeon.EffectTile('', true, loc)

--         local flinch = RogueEssence.Dungeon.StatusEffect("flinch")
--         --initialize status data before adding it to anything
--         flinch:LoadFromData()
--         local chara = map:GetCharAtLoc(loc)

--         --damage anyone standing under a rock when it resolves.
--         if chara ~= nil then
--             --deal 1/4 max hp as damage, multiplied based on type effectiveness. Also flinch the target.
--             local damage = chara.MaxHP / 4

--             --get the type effectiveness on each of the chara's types, then add that together. then run it through GetEffectivenessMult to get the actual multiplier. This is the numerator for x/4. so divide by 4 after for true amount
--             local type_effectiveness = PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup('rock', chara.Element1) +
--             PMDC.Dungeon.PreTypeEvent.CalculateTypeMatchup('rock', chara.Element2)
--             type_effectiveness = PMDC.Dungeon.PreTypeEvent.GetEffectivenessMult(type_effectiveness)


--             damage = type_effectiveness * damage
--             damage = math.floor(damage / 4)

--             TASK:WaitTask(chara:InflictDamage(damage))
--             TASK:WaitTask(chara:AddStatusEffect(nil, flinch, true))
--         end
--     end

--     --local arriveAnim = RogueEssence.Content.StaticAnim(RogueEssence.Content.AnimData("Rock_Pieces", 1), 1)
--     --arriveAnim:SetupEmitted(RogueElements.Loc(waves[i][j].X * 24 + 12, waves[i][j].Y * 24 + 12), 32, RogueElements.Dir8.Down)
--     --DUNGEON:PlayVFXAnim(arriveAnim, RogueEssence.Content.DrawLayer.Front)


--     for xx = 0, map.Width - 1, 1 do
--         for yy = 0, map.Height - 1, 1 do
--             local loc = RogueElements.Loc(xx, yy)
--             local tile = map:GetTile(loc)
--             --queue up the shadow in that position for that wave.
--             if tile.Effect.ID == 'falling_rock_shadow' then
--                 table.insert(waves[((xx + yy) % #waves) + 1], loc)
--             end
--         end
--     end

--     local boulder_coroutines = {}
--     for i = 1, #waves, 1 do
--         for j = 1, #waves[i], 1 do
--             table.insert(boulder_coroutines,
--                 TASK:BranchCoroutine(function()
--                     GAME:WaitFrames((i - 1) * 10)
--                     DropBoulder(waves[i][j])
--                 end))
--         end
--     end

--     TASK:JoinCoroutines(boulder_coroutines)

--     --pause a bit after dropping all boulders
--     GAME:WaitFrames(20)
-- end

-- function SINGLE_CHAR_SCRIPT.RockfallTemors(owner, ownerChar, context, args)
--     --args.ShadowDuration - how long the shadows are out before they fall. Should be 1 pretty much always. Dont let it be less than 1!!!!
--     --args.TurnsBetweenTremors - how many turns after one tremor should another trigger? Much less during the bossfight.
--     if context.User == nil then
--         --failsafes
--         if SV.ClovenRuins.BoulderCountdown == nil then SV.ClovenRuins.BoulderCountdown = -1 end

--         --reset the counter when we go past 0. -1 or else it would end up taking 1 more turn than intended
--         if SV.ClovenRuins.BoulderCountdown < 0 then
--             SV.ClovenRuins.BoulderCountdown = args.TurnsBetweenTremors - 1
--         end

--         --when there's only ShadowDuration turns left, trigger the shadow spawns.
--         if SV.ClovenRuins.BoulderCountdown == args.ShadowDuration then
--             SINGLE_CHAR_SCRIPT.QueueRockFall(owner, ownerChar, context, args)
--         end

--         if SV.ClovenRuins.BoulderCountdown == 0 then
--             SINGLE_CHAR_SCRIPT.ResolveRockFall(owner, ownerChar, context, args)
--         end

--         SV.ClovenRuins.BoulderCountdown = SV.ClovenRuins.BoulderCountdown - 1
--     end
-- end
