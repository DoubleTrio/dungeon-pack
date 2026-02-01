import json
import csv

NORMAL = 0
SUPPORT = 1
LEADER = 2 
LONER = 3

roles_arr = ["Normal", "Support", "Leader", "Loner"]




# spheal,
# vulpix, ninetiles
 
# fire


# fighting

# zubat
# diglett, dugtrio
# psyduck, golduck
# growlithe
# poliwag, poliwhirl, poliwrath
# machop, machoke, machamp
# abra, kadabra, alakazam
# geodude, graveler, golem
# ponyta, rapidash
# slowpoke, slowbro, slowking
# seal, # dewgong
# sheldeer, cloyster
# horsea, seadra, kingdra
# staryu, starmie
# goldeen, seaking
# mr mime, mr rime
# jynx
# electabuzz, electivire
# magmar, magmortar
# tauros
# magikarp, gyarados
# lapras
# ditto
# eevee, vaporeon, jolteon, flareon, espeon, umbreon, leafeon, glaceon, sylveon
# omanyte, omastar
# cyndaquil, quilava, typhlosion
# hoothoot, noctowl
# sentret, furret
# chinchou, lanturn
# cleffa, clefairy, clefable
# togepi, togetic, togekiss
# natu xatu
# marill, azumarill
# mareep, flaaffy, ampharos
# sudowoodo
# aipom, ambipom
# wooper, quagsire
# espeon, umbreon
# murkrow, honchkrow
# misdreavus, mismagius
# wobbuffet
# girafarig
# dunsparce
# onix, steelix
# snubbull, granbull
# qwilfish, overqwil
# scizor
# shuckle
# sneasel, weavile (hisuan)
# teddiursa, ursaring
# slugma, magcargo
# swinub, piloswine, mamoswine
# corsola, corsola_galarian, coquillier
# remoraid, octillery
# delibird, skarmory
# phanpy, donphan
# stantler
# smeargle
# tyrogue, hitmonlee, hitmonchan, hitmontop
# smoochum
# chansey, blissey
# larvitar, pupitar, tyranitar
# torchic, combusken, blaziken
# mudkip, marshtomp, swampert
# zigzagoon, linoone, obstagoon
# poochyena, mightyena
# wailmer, wailord
# numel, camerupt
# tailow, swellow
# ralts, kirlia, gardevoir, gallade
# surskit, masquereain
# slakoth, vigoroth, slaking
# nincada, ninjask, shedinja
# whismur, loudred, exploud
# makuhita, hariyama
# nosepass, probopass
# skitty, delcatty
# sableye
# mawile
# aron, lairon, aggron
# meditite, medicham
# electrike, manectric
# plusle, minun
# gulpin, swalot
# trapinch, vibrava, flygon
# swablu, altaria
# zangoose, seviper
# lunatone, solrock
# barboach, whiscash
# corphish, crawdaunt
# baltoy, claydol
# lileep, cradily
# anorith, armaldo
# castform
# kecleon
# shuppet, banette
# duskull, dusclops, dusknoir
# snorunt, glalie, froslass
# spheal, sealeo, walrein
# clamperl, huntail, gorebyss
# relicanth
# chimchar, monferno, infernape
# piplup, prinplup, empoleon
# starly, staravia, staraptor
# bidoof, bibarel
# kricketot, kricketune
# shinx, luxio, luxray
# cranidos, rampardos
# shieldon, bastiodon
# buizel, floatzel
# pachirisu
# drifloon, driftblim
# shellos, gastrodon
# misdreavus, mismagius
# glameow, purugly
# bronzor, bronzong
# spiritomb
# gible, gabite, garchomp
# munchlax, snorlax
# riolu, lucario
# finneon, lumineon
# mantyke, mantine
# snover, abomasnow
# magnemite, magneton, magnezone
# rotom
# emboar
# patrat, watchog
# lillipup, herdier, stoutland
# purrloin, liepard
# pansear, simisear
# panpour, simipour
# blitzle, zebstrika
# roggenrola, boldore, gigalith
# drilbur, excadrill
# timburr, gurdurr, conkeldurr
# throh, sawk
# darumaka, darmanitan
# dwebble, crustle
# yamask, cofagrigus
# tirtouga, carracosta
# zorua, zoroark
# solosis, duosion, reuniclus
# vanillite, vanillish, vanilluxe
# dearling 
# frilLish, jellicent
# elgyem, beheeyem
# axew, fraxure, haxorus
# cubchoo, beartic
# mienfoo, mienshao
# druddigon
# golett, golurk
# bouffalant
# heatmor, durant
# deinos, zweilous, hydreigon
# larvesta, volcarona
# bunnelby, diggersby
# litleo, pyroar
# furfrou
# espurr, meowstic
# honedge, doublade, aegislash
# skrelp, dragalge
# clauncher, clawitzer
# tyrunt, tyrantrum
# amaura, aurorus
# hawlucha
# dedenne
# carbink
# goomy, sliggoo, goodra
# bergmite, avalugg
# litten, torracat, incineroar
# crabrawler, crabominable
# rockruff, lycanroc
# salandit, salazzle
# koffing, weezing
# Turtonator 	Turtonator
# drampa
# jangmo-o, hakamo-o, kommo-o
# Skwovet 	Skwovet, Greedent
# rookie, corvisquire, corviknight
# nickit, thievul
# wooloo, dubwool
# Chewtle 	Chewtle, Drednaw
# Yamper 	Yamper
# rolycoly, carkol, coalossal
# Mr. Rime
# snom, frosmoth
# eiscue, 
# indeedee

#Dracozolt 	Dracozolt

#0881 	Arctozolt 	Arctozolt

#0882 	Dracovish 	Dracovish

#0883 	Arctovish 	Arctovish

# Duraludon 	Duraludon, Arc
# dreepy, drakloak, dragapult	
# wydeer, kleavor, urshifu, basculin, sableye_hisuan, braviary_hisuan
# ursaluna, basculegion, enamorus
# sneasler
# nacli, naclstack, garganacl
# charcadet, armarouge, ceruledge
# wiglett, wugtrio
# tinkatink, tinkatuff, tinkaton
# finizen, palafin
# glimnira
# cetoddle, cetitan
# annihilape
# clodsire
# kingambit


# ["Name", "Tactic", "Ablity", "Move 1", "Move 2",
#                             "Move 3", "Move 4", "Min Lev", "Max Lev", "Min Floor", "Max Floor", "Role", "Rate"]
if __name__ == "__main__":


    # cynda - ember
# rowlet - leafage
# oshawott - water gun
# eevee - tickle, tackle
# pikachu - thunder shock, quick attack
# munchlax - sleeping, snore, body slam
# budew - absorb, poison sting
# psychduck - confusion, water gun, Amnesia
# buizel - sonicboom waterspart, soak
# chimxhar - counter, double kick, flame wheel
# starly - wing attack, quick attack
# bidoof - super-fang, tackle
# Machop - 	Karate Chop, focus-enery
# paras
# shinx
# cherubi
# happiny
# ponyta




# eevee, crobat, burmy, wormadam, golem, snorlax, parasect, raichu, infernape (personal one), golduck, combee, vespiquen, scizor, heracross, aipom, ambipom, shellos, gastrodon, blissey, togepi, togetic, togekiss, machamp 
# bidoof, starly, shinx, drifloon, kirketo, stantler, geodude, chimca, lopunny, munchlax, scyther, ponyta, rapiddash, metamod, eevee
# ice, floatzel




    mons = [

        # PikachuPikachu
        # RaichuRaichu
        # ZubatZubat
        # GolbatGolbat
        # ParasParas
        # ParasectParasect
        # PsyduckPsyduck
        # GolduckGolduck
        # AbraAbra
        # KadabraKadabra
        # AlakazamAlakazam
        # MachopMachop
        # MachokeMachoke
        # GeodudeGeodude
        # GravelerGraveler
        # GolemGolem
        # PonytaPonyta
        # RapidashRapidash
        # HaunterHaunter
        # GengarGengar
        # OnixOnix
        # LickitungLickitung
        # ChanseyChansey
        # Mr. MimeMr. Mime
        # ScytherScyther
        # MagikarpMagikarp
        # GyaradosGyarados
        # EeveeEevee
        # SnorlaxSnorlax
        # CrobatCrobat
        # PichuPichu
        # AipomAipom
        # UnownUnown
        # SteelixSteelix
        # QwilfishQwilfish
        # HeracrossHeracross
        # SneaselSneasel
        # UrsaringUrsaring
        # StantlerStantler
        # BlisseyBlissey
        # WurmpleWurmple
        # SilcoonSilcoon
        # BeautiflyBeautifly
        # CascoonCascoon
        # DustoxDustox
        # SphealSpheal
        # SealeoSealeo
        # ChimcharChimchar
        # MonfernoMonferno
        # InfernapeInfernape
        # StarlyStarly
        # StaraviaStaravia
        # StaraptorStaraptor
        # BidoofBidoof
        # BibarelBibarel
        # KricketotKricketot
        # KricketuneKricketune
        # ShinxShinx
        # LuxioLuxio
        # LuxrayLuxray
        # BurmyBurmy
        # WormadamWormadam
        # MothimMothim
        # CombeeCombee
        # VespiquenVespiquen
        # BuizelBuizel
        # FloatzelFloatzel
        # CherubiCherubi
        # CherrimCherrim
        # ShellosShellos
        # GastrodonGastrodon
        # DrifloonDrifloon
        # DrifblimDrifblim
        # BunearyBuneary
        # LopunnyLopunny
        # Mime Jr.Mime Jr.
        # HappinyHappiny
        # ChatotChatot
        # MunchlaxMunchlax
        # ToxicroakToxicroak
        # WeavileWeavile
        # LickilickyLickilicky
        # TogekissTogekiss
        # LeafeonLeafeon
        # MespritMesprit
        # ShayminShaymin
        # ZoruaZorua
        # ZoroarkZoroark
        # LandorusLandorus
        # SylveonSylveon
        # WyrdeerWyrdeer
        # KleavorKleavor
        #1
        ('buneary', 0, 'wander_normal', '', ['double_hit', 'foresight'], 4, 5, 0, 3, 0, 10),
        ('shinx', 0, 'wander_normal', '', ['howl', 'tackle'], 4, 5, 0, 3, LONER, 10),
        ('starly', 0, 'wander_normal', '', ['tackle', 'sand_attack'], 4, 5, 0, 3, 0, 10),


        #2
        ('psyduck', 0, 'weird_tree', '', ['water_pulse', 'flip_turn'], 8, 9, 1, 6, 0, 6),
        ('bidoof', 0, 'wander_normal', '', ['super_fang', 'tackle'], 6, 7, 1, 5, 0, 10),
        ('silcoon', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 6, 7, 1, 3, 0, 5),
        ('paras', 0, 'retreater', '', ['leech_seed', 'poison_powder'], 6, 7, 1, 5, SUPPORT, 10),
        ('burmy', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 6, 7, 1, 5, 0, 5),
        ('budew', 0, 'wander_normal', '', ['nature_power'], 5, 6, 1, 3, 0, 10),
        ('eevee', 0, 'wander_normal', '', ['tickle', 'yawn', 'quick_attack'], 5, 6, 1, 5, 0, 10),
        


        #3
        ('machop', 0, 'wander_normal', '', ['focus_energy', 'low_kick'], 7, 8, 2, 5, LONER, 10),
        ('buizel', 0, 'wander_normal', '', ['sonic_boom'], 8, 9, 2, 5, 0, 10),

        #4 
        ('geodude', 0, 'patrol', '', ['rollout', 'tackle'], 9, 10, 3, 5, 0, 10),
        ('cascoon', 0, 'wait_attack', '', ['bug_bite', 'string_shot'], 9, 10, 3, 5, 0, 5),
        ('cyndaquil', 0, 'wander_normal', '', ['ember', 'smokescreen'], 8, 9, 3, 5, 0, 10),
        ('oshawott', 0, 'wander_normal', '', ['water_gun', 'encore'], 9, 10, 3, 5, 0, 10),
        ('rowlet', 0, 'wander_normal', '', ['leafage', 'dual_wingbeat'], 8, 9, 3, 5, 0, 10),
        ('pichu', 0, 'wander_normal', '', ['nuzzle', 'charm', 'fake_out'], 10, 11, 3, 5, SUPPORT, 10),


        #5
        ('onix', 0, 'slow_wander', '', ['block', 'iron_tail'], 11, 12, 4, 5, 0, 10),

        #6
        ('pancham', 0, 'wander_normal', 'mold_breaker', ['taunt', 'circle_throw'], 12, 13, 5, 7, 0, 10),
        ('corsola', 0, 'wander_normal', 'natural_cure', ['aqua_ring', 'amnesia', 'icicle_spear'], 11, 12, 5, 7, SUPPORT, 10),
        ('shellos', 0, 'wander_normal', 'storm_drain', ['mud_sport', 'water_pulse'], 12, 13, 5, 7, 0, 10),       
        ('krabby', 0, 'wander_normal', '', ['bubble_beam', 'vice_grip'], 11, 12, 5, 7, 0, 10),
        ('corphish', 0, 'retreater_item', '', ['knock_off', 'fling'], 11, 12, 5, 7, 0, 10),
        ('staryu', 0, 'wander_normal', 'illuminate', ['confuse_ray', 'light_screen', 'water_gun'], 12, 13, 5, 8, SUPPORT, 10),

        #7
        ('rattata', 1, 'retreater', 'hustle', ['screech', 'sucker_punch'], 11, 12, 6, 8, 0, 10),
        ('diglett', 1, 'wander_normal', 'tangling_hair', ['bulldoze', 'sucker_punch'], 12, 13, 6, 8, 0, 10),
        ('meowth', 1, 'thief', '', ['pay_day', 'thief'], 13, 14, 6, 8, 0, 10),
        ('vulpix', 1, 'wander_normal', 'snow_cloak', ['nasty_plot', 'dazzling_gleam'], 11, 12, 6, 7, 0, 10),
        ('geodude', 1, 'wander_normal', 'galvanize', ['rock_climb'], 11, 12, 6, 8, 0, 10),
        ('grimer', 1, 'retreater_item', 'stench', ['haze', 'belch'], 11, 12, 6, 8, 0, 10),


        #8
        ('dratini', 0, 'wander_smart', 'shed_skin', ['twister', 'dragon_rage'], 14, 15, 7, 9, 0, 10),
        ('wimpod', 0, 'fleeing', '', ["sand_attack", "struggle_bug"], 15, 16, 7, 8, 0, 10),
        ('dwebble', 0, 'retreater', 'sturdy', ['rock_tomb', 'bug_bite'], 13, 14, 7, 9, 0, 10),
        ('anorith', 0, 'wander_normal', 'swift_swim', ['stealth_rock', 'ancient_power'], 12, 13, 7, 9, 0, 10),
        ('wailmer', 0, 'wander_normal', 'pressure', ['rest', 'amnesia', 'growl'], 14, 15, 7, 9, SUPPORT, 10),
        ('mareanie', 0, 'wander_normal', '', ['wide_guard', 'toxic_spikes', 'pounce'], 15, 16, 7, 10, SUPPORT, 10),
    

        #9
        ('quaxwell', 0, 'wander_normal', 'torrent', ['water_pledge', 'detect'], 16, 17, 8, 10, SUPPORT, 6),
        ('scyther', 0, 'wander_normal', 'technician', ['agility', 'false_swipe'], 17, 18, 8, 10, LONER, 10),
        ('sandygast', 0, 'wander_normal', 'water_compaction', ['destiny_bond', 'stockpile', 'swallow', 'spit_up'], 19, 20, 8, 10, NORMAL, 10),
        ('tatsugiri', 0, 'wander_smart', '', ['dragon_dance', 'icy_wind'], 15, 16, 8, 10, SUPPORT, 10),
        ('krabby', 0, 'wander_normal', 'hyper_cutter', ['bubble_beam', 'vice_grip', 'knock_off'], 17, 18, 8, 10, 0, 10),

        #10
        ('crocinaw', 0, 'wander_normal', 'sheer_force', ['ice_fang', 'psychic_fangs'], 18, 19, 9, 10, LONER, 10),
        ('bruxish', 0, 'wander_normal', 'dazzling', ['aqua_jet', 'disable'], 19, 20, 9, 10, SUPPORT, 10),




        # Rocks begin to fall from the dungeon!
        # https://theworldofpokemon.com/habitats/habitat_8.html
        # https://theworldofpokemon.com/HabitatPage.html
        # raticate
        # https://pokemondb.net/pokedex/raticate/moves/7
        #11

        ('geodude', 0, 'patrol', '', ['rollout', 'tackle', 'rock_slide'], 18, 19, 9, 10, NORMAL, 10),
        ('druddigon', 0, 'wander_smart', '', ['glare', 'scale_shot'], 19, 20, 9, 10, LONER, 10),
        ('graveler', 0, 'wander_normal', 'sheer_force', ['magnitude', 'rocks_slide'], 18, 19, 9, 10, NORMAL, 10),
        ('bruxish', 0, 'wander_normal', 'dazzling', ['aqua_jet', 'disable'], 19, 20, 9, 10, SUPPORT, 10),
        ('salandit', 0, 'wander_smart', 'corrosion', ['flame_burst', 'toxic'], 19, 20, 9, 10, LONER, 10),
        ('machoke', 0, 'wander_normal', 'guts', ['cross_chop', 'rock_tomb'], 19, 20, 9, 10, LONER, 10),





        # ('dwe', 1, 'fleeing', '', ["sand_attack", "struggle_bug"], 11, 12, 4, 5, LONER, 10),

        # ('marowak', 1, 'retreater', 'rock_head', ['bone_club', 'bone_rush'], 11, 12, 4, 5, LONER, 10),
        # ('raichu', 1, 'wander_normal', 'surge_surfer', ['spark', 'quick_attack'], 11, 12, 4, 5, 0, 10),
        # ('exeggcute', 1, 'wander_normal', 'harvest', ['leech_seed', 'stun_spore'], 11, 12, 4, 5, SUPPORT, 10),
        # ('marill', 1, 'wander_normal', 'thick_fat', ['bubble_beam', 'aqua_jet'], 11, 12, 4, 5, 0, 10),
        # ('wimpod', 1, 'retreater', '', ['aqua_jet', 'bug_bite'], 11, 12, 4, 5, LONER, 10),
        # ('sneasel', 1, 'wander_normal', 'inner_focus', ['ice_shard', 'feint_attack'], 11, 12, 4, 5, LONER, 10),
        # ('krokorok', 1, 'wander_smart', '', ['sand_attack', 'bite'], 11, 12, 4, 5, LONER, 10),

        # ('tirtouga', 1, 'wander_smart', '', ['water_gun', 'rock_throw'], 11, 12, 4, 5, LONER, 10),


        # ('sandyshrew', 1, 'retreater',
        # Have lots of berries in this area

        # ('oricorio', 0, 'wander_normal', '', ['feather_dance', 'quiver_dance', 'attract', 'teeter_dance'], 4, 5, 0, 3, SUPPORT, 10),

        # Have lots of iron balls in this area





        # mons standing on this target get range

        # Relicanth
        # corphish
        # Anorith
        # oricorio
        # alolan rat
        # alolan diglett
        # alolan geodude
        # alolan vulpix
        # alolan meowth
        # alolan grimer
        # eggxecute 
        # alolan eggxecute (sleeping)
        # alolan marow
        # alolan raichu (sleeping)
        # mareanie
        # wimpod
        # snease
        # pancham
        # krok (tototile evo)
        # Dwebble
        # quaxly
        # tirtouga
        # gimme
        # dratini
   
        # Tirtouga
        # tatsugiri


        #2
        # ('skitty', 0, 'wander_normal', 'wonder_skin', ['fake_out', 'copycat'], 10, 11, 0, 4, 0, 10),
        # ('cleffa', 0, 'wander_normal', 'friend_guard', ['covet', 'mimic'], 10, 11, 0, 3, 0, 10),
        
        # #2
        # ('ralts', 0, 'wander_normal', 'trace', ['disarming_voice', 'teleport'], 12, 13, 1, 4, 0, 10),
        # ('goomy', 0, 'wander_normal', '', ['water_gun', 'absorb'], 11, 12, 1, 4, 0, 10),
        # ('diglett', 0, 'wander_normal', 'arena_trap', ['astonish', 'sand_attack'], 12, 13, 1, 4, 0, 10),
        
        # #3
        # ('togepi', 0, 'wander_dumb', 'super_luck', ['metronome'], 14, 15, 2, 5, 0, 10),
        # ('hatenna', 0, 'wander_normal', 'healer', ['play_nice', 'life_dew'], 13, 14, 2, 6, SUPPORT, 10),
        # ('whismur', 0, 'wander_normal', 'rattled', ['echoed_voice', 'round'], 14, 15, 2, 6, 0, 10),
        
        # #4
        # ('zubat2', 0, 'wander_normal', '', ['poison_fang'], 14, 15, 3, 6, 0, 10),
        # ('houndour', 0, 'wander_normal', '', ['ember', 'leer', 'smog'], 14, 15, 3, 6, LONER, 10),
        # ('azurill', 0, 'wander_normal', 'thick_fat', ['charm', 'sing', 'bubble_beam'], 15, 16, 3, 5, 0, 10),
        
        # #5
        # ('noibat', 0, 'wander_normal', 'telepathy', ['double_team', 'gust'], 15, 16, 4, 7, LEADER, 10),
        # ('solosis', 0, 'wander_normal', 'magic_guard', ['confusion', 'reflect'], 15, 16, 4, 7, 0, 10),
        


        # 2
        # remoraid
        # octillary
        # shelder 
        # cloyster
        # carvanah fish
        # krabby
        # boss
        # heracross
        # scyther
        # gyrados
        

        # Tentacool

        # Bruxish

        # Corsola

        # Mareanie

        # Clamperl


        # Luvdisc

        # Pyumuku

        # Lapras

        # Qwilfish

        # Chinchou 
        #6
       
    ]

    def create_monster_house(mon_name, form):
        base = {
            "Spawn": {
                "BaseForm": {
                    "Species": mon_name,
                    "Form": form,
                    "Skin": "",
                    "Gender": -1
                },
                "Level": {
                    "Min": 1,
                    "Max": 1
                },
                "SpecifiedSkills": [],
                "Intrinsic": "",
                "Tactic": "wander_smart",
                "SpawnConditions": [],
                "SpawnFeatures": [
                    {
                        "$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"
                    },
                    {
                        "$type": "PMDC.LevelGen.MobSpawnLevelScale, PMDC",
                        "StartFromID": 0,
                        "AddNumerator": 4,
                        "AddDenominator": 3
                    },
                    {
                        "$type": "PMDC.LevelGen.MobSpawnLuaTable, PMDC",
                        "LuaTable": "{ EmberfrostRun = true }"
                    }
                ]
            },
            "Rate": 10,
            "Range": {
                "Min": 0,
                "Max": 27
            }
        }
        return base

    monster_house_mons = [
        "cleffa", "clefairy", "clefable",
        "hatenna", "hattrem", "hatterene",
        "zubat", "golbat", "crobat",
        "meowth", "persian", 
        "vulpix", "ninetales",
        "tinkatink", "tinkatuff", "tinkaton",
        "ledian",
        "audino",
        "beldum", "metang",
        "pichu", "pikachu", "raichu",
        "togepi", "togetic", "togekiss",
        "mawile",
        "baltoy", "claydol",
        "gulpin", "swalot",
        "swinub", "piloswine",
        "minun", "plusle",
        "ralts", "kirlia", "gardevoir", "gallade",
        "azurill", "marill", "azumarill",
        "baltoy", "claydol",
        "woobat", "swoobat",
        "illumise", "volbeat",
        "bagon", "shelgon",
        "jigglypuff", "wigglytuff",
        "mime_jr", "mr_mime",
        "aron", "lairon", "aggron",
        "elekid", "electabuzz", "electivire",
        "sneasel", "weavile",
        "nickit", "thievul",
        "eevee",
        "morelull",
        "girafarig",
        "tentacool", "tentacruel",
        "dunsparce",
        "skitty", "delcatty",
        "houndour", "houndoom",
        "whismur", "loudred", "exploud",
        "solosis", "duosion", "reuniclus",
        "luvdisc",
        "clauncher", "clawitzer",
        "meditite", "medicham",
        "bronzor",  "bronzong",
        "rhyhorn", "rhydon",
        "nosepass", "probopass",
        "chingling", "chimecho",
        "chinchou", "lanturn"
    ]

    monster_house_result = []
    for mon_name in monster_house_mons:
        struct = create_monster_house(mon_name, 0)
        monster_house_result.append(struct)

    def create_mon(mon):
        name, form, tactic, ability, moves, min_lev, max_lev, min_floor, max_floor, role, rate = mon[0], mon[1], mon[2], mon[3], mon[4], mon[5], mon[6], mon[7], mon[8], mon[9], mon[10]
        
        base_structure = {
            "Spawn": {
                "Spawn": {
                    "BaseForm": {
                        "Species": name,
                        "Form": form,
                        "Skin": "",
                        "Gender": -1
                    },
                    "Level": {
                        "Min": min_lev,
                        "Max": max_lev
                    },
                    "SpecifiedSkills": moves,
                    "Intrinsic": ability,
                    "Tactic": tactic,
                    "SpawnConditions": [],
                    "SpawnFeatures": [
                        {
                            "$type": "PMDC.LevelGen.MobSpawnMovesOff, PMDC",
                            "StartAt": len(moves),
                            "Remove": False
                        },
                        {
                            "$type": "PMDC.LevelGen.MobSpawnWeak, PMDC"
                        },
                        {
                            "$type": "PMDC.LevelGen.MobSpawnLuaTable, PMDC",
                            "LuaTable": "{ EmberfrostRun = true }"
                        }
                    ]
                },
                "Role": role
            },
            "Rate": rate,
            "Range": {
                "Min": min_floor,
                "Max": max_floor
            }
        }
        return base_structure

    mons.sort(key=lambda item: (item[-4], item[0]))
    result = []
    for mon in mons:
        name = mon[0]
        min_lev = mon[5]
        if (min_lev < 60):
            result.append(create_mon(mon))

    with open('../Data/Zone/emberfrost_depths.json', 'r', encoding='utf-8-sig') as file:
        data = json.load(file)

    data['Object']['Segments'][0]["ZoneSteps"][4]["Spawns"] = result

    # data['Object']['Segments'][0]["ZoneSteps"][5]["Mobs"] = monster_house_result

    # data['Object']['Segments'][0]["ZoneSteps"][6]["Mobs"] = monster_house_result

    # data['Object']['Segments'][0]["ZoneSteps"][7]["Mobs"] = monster_house_result

    with open('../Data/Zone/emberfrost_depths.json', 'w') as file:
        json.dump(data, file, indent=2)

    csv_filename = 'emberfrost_encounters.csv'
    with open(csv_filename, mode='w', newline='') as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow(["Name", "Form", "Tactic", "Ablity", "Move 1", "Move 2",
                            "Move 3", "Move 4", "Min Lev", "Max Lev", "Min Floor", "Max Floor", "Role", "Rate"])
        for row in mons:
            while len(row[4]) != 4:
                row[4].append("")
            csv_writer.writerow(
                [row[0], row[1], row[2], *row[3], row[4], row[5], row[6] + 1, row[7] + 1, row[8], roles_arr[row[9]], row[10]])