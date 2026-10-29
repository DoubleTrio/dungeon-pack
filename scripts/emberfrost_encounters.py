import csv
import json

NORMAL = 0
SUPPORT = 1
LEADER = 2 
LONER = 3

MONS = [

    # 1
    [
        ('buneary', 0, 'wander_normal', '', ['double_hit', 'foresight'], 4, 5, 3, 0, 10, "berry_oran"),
        ('shinx', 0, 'wander_normal', '', ['howl', 'tackle'], 4, 5, 3, LONER, 10),
        ('starly', 0, 'wander_dumb', '', ['tackle', 'sand_attack'], 4, 5, 3, 0, 10),
    ],

    # 2
    [
        ('bidoof', 0, 'wander_normal', '', ['super_fang', 'tackle'], 6, 7, 4, 0, 10),
        ('budew', 0, 'wander_normal', '', ['nature_power'], 5, 6, 2, 0, 10),
        ('burmy', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 6, 7, 4, 0, 5),
        ('eevee', 0, 'wander_normal', '', ['tickle', 'quick_attack'], 7, 9, 4, 0, 10),
        ('paras', 0, 'retreater', '', ['leech_seed', 'poison_powder'], 6, 7, 4, SUPPORT, 10),
        ('psyduck', 0, 'weird_tree', '', ['water_pulse', 'flip_turn'], 8, 9, 4, 0, 6),
    ],

    # 3
    [
        ('geodude', 0, 'patrol', '', ['rollout', 'tackle'], 7, 8, 3, 0, 10),
        ('machop', 0, 'wander_normal', '', ['focus_energy', 'low_kick'], 7, 8, 3, LONER, 10),
    ],

    # 4
    [
        ('cascoon', 0, 'wait_attack', '', ['bug_bite', 'string_shot'], 9, 10, 2, 0, 4),
        ('cyndaquil', 0, 'wander_normal', '', ['ember', 'smokescreen'], 9, 10, 2, 0, 10),
        ('oshawott', 0, 'wander_normal', '', ['water_gun', 'encore'], 9, 10, 2, 0, 10),
        ('rowlet', 0, 'wander_normal', '', ['leafage', 'dual_wingbeat'], 9, 10, 2, 0, 10),
        ('silcoon', 0, 'wait_attack', '', ['bug_bite', 'poison_sting'], 9, 10, 2, 0, 4),
    ],

    # 5
    [
        ('buizel', 0, 'wander_normal', '', ['sonic_boom'], 10, 11, 3, 0, 10),
        ('drifloon', 0, 'wander_normal', 'unburden', ['bind', 'night_shade'], 11, 12, 3, NORMAL, 10),
        ('pichu', 0, 'wander_normal', '', ['nuzzle', 'charm', 'fake_out'], 12, 13, 1, SUPPORT, 10),
    ],

    # 6
    [
        ('corphish', 0, 'wander_normal', '', ['knock_off', 'fling', 'harden'], 11, 12, 2, 0, 10),
        ('corsola', 0, 'wander_normal', 'natural_cure', ['aqua_ring', 'amnesia', 'icicle_spear'], 11, 12, 2, SUPPORT, 10),
        ('diglett', 1, 'wander_normal', 'tangling_hair', ['bulldoze', 'sucker_punch'], 10, 11, 3, 0, 10),
        ('krabby', 0, 'wander_normal', '', ['bubble_beam'], 10, 11, 2, 0, 10),
        ('meowth', 1, 'thief', '', ['pay_day', 'fury_swipes'], 11, 12, 2, 0, 10),
        ('pancham', 0, 'wander_normal', 'mold_breaker', ['taunt', 'circle_throw'], 12, 13, 2, 0, 10),
        ('shellos', 0, 'wander_normal', 'storm_drain', ['mud_sport', 'water_pulse'], 12, 13, 2, 0, 10),
    ],

    # 7
    [
        ('geodude', 1, 'wander_normal', 'galvanize', ['rock_climb'], 11, 12, 2, 0, 10),
        ('grimer', 1, 'retreater_item', 'stench', ['assurance', 'clear_smog'], 12, 13, 2, 0, 10),
        ('rattata', 1, 'retreater', 'hustle', ['screech', 'sucker_punch'], 12, 13, 2, 0, 10),
        ('staryu', 0, 'wander_normal', 'illuminate', ['confuse_ray', 'light_screen', 'water_gun'], 13, 14, 2, SUPPORT, 10),
        ('vulpix', 1, 'wander_normal', 'snow_cloak', ['nasty_plot', 'dazzling_gleam'], 11, 12, 1, 0, 10),
    ],

    # 8
    [
        ('anorith', 0, 'wander_normal', 'swift_swim', ['stealth_rock', 'ancient_power'], 12, 13, 2, 0, 10),
        ('dratini', 0, 'wander_smart', 'shed_skin', ['twister', 'dragon_rage'], 14, 15, 2, 0, 10),
        ('dwebble', 0, 'retreater', 'sturdy', ['rock_tomb', 'bug_bite'], 13, 14, 2, 0, 10),
        ('mareanie', 0, 'wander_normal', '', ['wide_guard', 'toxic_spikes', 'pounce'], 15, 16, 3, SUPPORT, 10),
        ('wailmer', 0, 'wander_normal', 'pressure', ['rest', 'amnesia', 'growl', 'round'], 14, 15, 3, SUPPORT, 10),
    ],

    # 9
    [
        ('krabby', 0, 'wander_normal', 'hyper_cutter', ['bubble_beam'], 17, 18, 2, 0, 10),
        ('quaxwell', 0, 'wander_normal', 'torrent', ['water_pledge', 'detect'], 16, 17, 2, SUPPORT, 6),
        ('sandygast', 0, 'wander_normal', 'water_compaction', ['destiny_bond', 'stockpile', 'swallow', 'spit_up'], 19, 20, 2, NORMAL, 10),
        ('scyther', 0, 'wander_normal', 'technician', ['agility', 'false_swipe'], 19, 20, 2, LONER, 10),
        ('tatsugiri', 0, 'wander_smart', '', ['whirlpool'], 16, 17, 2, SUPPORT, 10),
    ],

    # 10
    [
        ('croconaw', 0, 'wander_normal', 'sheer_force', ['waterfall'], 18, 19, 1, LONER, 10),
        ('bruxish', 0, 'wander_normal', 'dazzling', ['aqua_jet', 'psychic_fangs'], 19, 20, 1, SUPPORT, 10),

    ],

    # 11
    [
        ('aron', 0, 'wander_normal', '', ['protect', 'rock_tomb', 'screech'], 20, 21, 2, NORMAL, 10),
        ('cubone', 0, 'wander_normal', '', ['bonemerang', 'smack_down'], 20, 21, 2, NORMAL, 10),
        ('geodude', 0, 'patrol', '', ['wide_guard', 'rock_blast'], 20, 21, 3, NORMAL, 10),
        ('nacli', 0, 'wait_attack', 'purifying_salt', ['salt_cure'], 22, 23, 2, NORMAL, 10),
        ('sandile', 0, 'wander_normal', 'intimidate', ['dig', 'scary_face'], 20, 21, 2, NORMAL, 10),
    ],

    # 12
    [
        ('glimmet', 0, 'wander_normal', 'toxic_debris', ['toxic', 'venoshock'], 20, 21, 2, NORMAL, 10),
        ('natu', 0, 'wander_normal', 'magic_guard', ['future_sight', 'teleport'], 21, 22, 2, NORMAL, 10),
        ('shuckle', 0, 'wander_normal', 'contrary', ['shell_smash', 'infestation'], 19, 20, 2, LONER, 10),
        ('sigilyph', 0, 'wander_normal', 'magic_guard', ['ancient_power', 'psybeam', 'roost'], 21, 22, 3, NORMAL, 10),
    ],

    # 13
    [
        ('audino', 0, 'wander_normal', 'healer', ['heal_pulse', 'baton_pass', 'amnesia'], 21, 22, 3, SUPPORT, 10),
        ('binacle', 0, 'wander_normal', 'tough_claws', ['fling', 'razor_shell', 'x_scissor'], 22, 23, 2, NORMAL, 10),
        ('golett', 0, 'wander_normal', 'iron_fist', ['shadow_punch', 'thunder_punch', 'ice_punch'], 22, 23, 2, NORMAL, 10),
        ('joltik', 0, 'wander_normal', 'unnerve', ['electroweb', 'gastro_acid', 'struggle_bug'], 23, 24, 2, SUPPORT, 10),
        ('loudred', 0, 'wander_normal', 'soundproof', ['screech', 'round', 'supersonic'], 20, 21, 2, NORMAL, 10),
    ],

    # 14
    [
        ('druddigon', 0, 'wander_normal', 'rough_skin', ['glare', 'dragon_claw'], 22, 23, 2, LONER, 10),
        ('herdier', 0, 'wander_normal', 'sand_rush', ['work_up', 'take_down'], 22, 23, 2, NORMAL, 10),
        ('noibat', 0, 'wander_normal', 'infiltrator', ['supersonic', 'air_cutter', 'u_turn'], 24, 25, 2, SUPPORT, 10),
    ],
    # 15
    [
        ('donphan', 0, 'wander_normal', 'sand_veil', ['rollout', 'bulldoze'], 25, 26, 1, LONER, 10),
        ('heliolisk', 0, 'wander_normal', 'sand_veil', ['parabola_charge'], 25, 26, 1, NORMAL, 10),
        ('lycanroc', 0, 'wander_normal', 'sand_rush', ['quick_guard', 'accelerock', 'rock_throw'], 25, 26, 1, LONER, 10),
        ('parasect', 0, 'wander_normal', '', ['spore', 'leech_life', 'leech_seed'], 24, 25, 1, NORMAL, 10),
    ],

    # Snow (More Closed)
    # 16
    [
        ('stantler', 0, 'retreater', 'intimidate', ['take_down', 'jump_kick'], 27, 28, 1, NORMAL, 10),
        ('stantler', 0, 'retreater', 'intimidate', ['hypnosis', 'nightmare'], 27, 28, 1, NORMAL, 10),
        ('ursaring', 0, 'retreater', 'forecast', ['hammer_arm', 'thrash', 'taunt'], 27, 28, 1, NORMAL, 10),
        ('ursaring', 0, 'retreater', 'forecast', ['rock_slide', 'body_slam', 'taunt'], 27, 28, 1, NORMAL, 10),
    
        ('zoroark', 1, 'retreater', 'illusion', ['icy_wind', 'taunt', 'hex', 'will_o_wisp'], 27, 28, 2, NORMAL, 20),
        ('zoroark', 1, 'retreater', 'illusion', ['shadow_ball', 'memento'], 26, 27, 2, NORMAL, 20),
        ('misdreavus', 0, 'wander_normal', '', ['curse', 'hex', 'will_o_wisp'], 27, 28, 1, NORMAL, 10),
        ('misdreavus', 0, 'wander_normal', '', ['taunt', 'memento'], 27, 28, 1, NORMAL, 10),
        ('shuppet', 0, 'wander_normal', 'frisk', ['spite', 'disable', 'will_o_wisp'], 26, 27, 1, NORMAL, 10),
        ('shuppet', 0, 'wander_normal', 'frisk', ['shadow_ball', 'grudge'], 27, 28, 1, NORMAL, 10),

        ('snover', 0, 'retreater', 'snow_warning', ['leech_seed', 'energy_ball', 'powder_snow'], 28, 29, 2, NORMAL, 10),
        ('snover', 0, 'retreater', 'snow_warning', ['icy_wind', 'frost_breath'], 28, 29, 2, NORMAL, 10),
        ('snorunt', 0, 'retreater', 'ice_body', ['powder_snow', 'water_pulse'], 27, 28, 2, NORMAL, 10),
        ('snorunt', 0, 'retreater', 'ice_body', ['sing', 'icy_wind', 'hex'], 27, 28, 2, NORMAL, 10),

    ],

    # 17 Hail More Open
    [
        ('froslass', 0, 'wander_normal', 'cursed_body', ['ice_beam', 'spite', 'shadow_ball'], 28, 29, 2, NORMAL, 10),
        ('frosmoth', 0, 'retreater', '', ['bug_buzz', 'quiver_dance'], 28, 29, 1, NORMAL, 10),
        ('frosmoth', 0, 'retreater', '', ['ice_beam', 'leech_life'], 28, 29, 1, NORMAL, 10),

        ('castform', 0, 'retreater', 'forecast', ['weather_ball', 'powder_snow'], 30, 31, 1, NORMAL, 10),
        ('castform', 0, 'retreater', 'forecast', ['icy_wind', 'scald', 'thunder_wave'], 30, 31, 1, NORMAL, 10),

        ('ninetales', 1, 'retreater', 'forecast', ['aurora_veil', 'dazzling_gleam', 'icy_wind'], 30, 31, 1, NORMAL, 10),
    ],

    # 18 Snow Closed
    [

        ('wyrdeer', 0, 'retreater', '', ['take_down', 'psyshield_bash', 'rage'], 30, 31, 1, NORMAL, 10),
        ('wyrdeer', 0, 'retreater', '', ['calm_mind', 'extrasensory', 'secret_power'], 30, 31, 1, NORMAL, 10),
        ('spiritomb', 0, 'wander_normal', 'pressure', ['pain_split', 'shadow_sneak', 'nightmare'], 30, 31, 1, NORMAL, 10),
        ('spiritomb', 0, 'wander_normal', 'pressure', ['hypnosis', 'dream_eater'], 30, 31, 1, NORMAL, 10),

        ('noctowl', 0, 'retreater', 'tinted_lens', ['acrobatics', 'aerial_ace', 'haze'], 30, 31, 1, NORMAL, 10),
        ('noctowl', 0, 'retreater', 'tinted_lens', ['pluck', 'air_slash', 'hypnosis'], 30, 31, 1, NORMAL, 10),

        ('mightyena', 0, 'retreater', 'intimidate', ['foul_play', 'embargo', 'taunt'], 30, 31, 1, NORMAL, 10),
        ('mightyena', 0, 'retreater', 'intimidate', ['yawn', 'snarl', 'taunt', 'sucker_punch'], 30, 31, 1, NORMAL, 10),

 
        ('zoroark', 1, 'retreater', 'illusion', ['icy_wind', 'taunt', 'hex', 'will_o_wisp'], 30, 31, 2, NORMAL, 20),
        ('zoroark', 1, 'retreater', 'illusion', ['shadow_ball', 'memento'], 30, 31, 2, NORMAL, 20),
        
        ('cinccino', 0, 'wander_normal', 'cute_charm', ['uproar', 'tail_slap'], 31, 32, 1, SUPPORT, 20),
        
        ('greedent', 0, 'wander_normal', 'cheek_pouch', ['curse', 'body_press', 'seed_bomb'], 37, 38, 1, NORMAL, 10, ['sitrus_berry'], "sleep"),
        ('greedent', 0, 'wander_normal', 'cheek_pouch', ['double_edge', 'fire_fang'], 37, 38, 1, NORMAL, 10, ['sitrus_berry'], "sleep"),
    ],

    # 19 Hail Open
    [
        ('glaceon', 0, 'retreater', 'snow_cloak', ['double_team', 'icy_wind', 'mirror_coat'], 31, 32, 2, NORMAL, 10),
        ('glaceon', 0, 'retreater', 'ice_body', ['aurora_veil', 'ice_beam', 'calm_mind'], 31, 32, 2, NORMAL, 10),
        ('piloswine', 0, 'retreater', 'thick_fat', ['ancient_power', 'bulldoze', 'haze'], 33, 34, 2, NORMAL, 10),
        ('weavile', 0, 'retreater', 'pressure', ['nasty_plot', 'freeze_dry', 'chilling_water'], 32, 33, 1, NORMAL, 10),
        ('glalie', 0, 'retreater', 'snow_cloak', ['double_team', 'ice_beam', 'mirror_coat', 'crunch'], 28, 29, 1, NORMAL, 10),

        ('jynx', 0, 'retreater', 'forewarn', ['future_sight', 'nasty_plot'], 31, 32, 1, NORMAL, 10),
        ('jynx', 0, 'retreater', 'forewarn', ['ice_beam', 'psyshock'], 31, 32, 1, NORMAL, 10),

   
        ('sandslash', 0, 'retreater', 'snow_cloak', ['iron_head', 'icicle_spear'], 30, 31, 1, NORMAL, 10),
        ('sandslash', 0, 'retreater', 'snow_cloak', ['ice_ball', 'agility'], 30, 31, 1, NORMAL, 10),

    ],

    # 20 Snow Closed
    [

        ('spiritomb', 0, 'wander_normal', 'pressure', ['hypnosis', 'dream_eater', 'nightmare'], 34, 35, 1, NORMAL, 10),
        ('spiritomb', 0, 'wander_normal', 'pressure', ['will_o_wisp', 'hex'], 34, 35, 1, NORMAL, 10),
        ('furret', 0, 'retreater', 'frisk', ['blizzard', 'coil'], 34, 35, 1, NORMAL, 10),
        ('basculegion', 0, 'wander_normal', 'adaptability', ['flip_turn', 'crunch', 'agility'], 31, 32, 1, LONER, 10),
  
        ('mightyena', 0, 'retreater', 'intimidate', ['foul_play', 'snarl', 'taunt'], 33, 34, 1, NORMAL, 10),
        ('mightyena', 0, 'retreater', 'intimidate', ['yawn', 'embargo', 'taunt', 'sucker_punch'], 33, 34, 1, NORMAL, 10),


        ('zoroark', 1, 'retreater', 'illusion', ['icy_wind', 'taunt', 'hex', 'will_o_wisp'], 32, 33, 1, NORMAL, 20),
        ('zoroark', 1, 'retreater', 'illusion', ['shadow_ball', 'memento'], 32, 33, 1, NORMAL, 20),


        ('noctowl', 0, 'retreater', 'tinted_lens', ['pluck', 'uproar', 'haze'], 30, 31, 1, NORMAL, 10),
        ('cinccino', 0, 'retreater', 'cute_charm', ['uproar', 'tail_slap'], 32, 33, 1, SUPPORT, 20),
        ('greedent', 0, 'wander_normal', 'cheek_pouch', ['curse', 'body_press', 'seed_bomb'], 37, 38, 1, NORMAL, 10, ['berry_sitrus'], "sleep"),
        ('greedent', 0, 'wander_normal', 'cheek_pouch', ['double_edge', 'fire_fang'], 37, 38, 1, NORMAL, 10, ['berry_sitrus'], "sleep"),
        ('ursaluna', 0, 'wander_normal', 'unnerve', ['superpower', 'thrash'], 40, 41, 1, NORMAL, 10, ['berry_sitrus', 'berry_oran'], "sleep"),
        ('snorlax', 0, 'wander_normal', 'thick_fat', ['curse', 'rest', 'body_slam', 'bulldoze'], 40, 41, 1, NORMAL, 10, ['berry_sitrus', 'berry_oran'], "sleep"),
    ],


    
        # ('frosmoth', 0, 'retreater', '', ['bug_buzz', 'quiver_dance'], 28, 29, 1, NORMAL, 10),
        # ('frosmoth', 0, 'retreater', '', ['ice_beam', 'leech_life'], 28, 29, 1, NORMAL, 10),


   
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['curse', 'body_press', 'seed_bomb'], 28, 29, 1, NORMAL, 10),
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['double_edge', 'fire_fang'], 28, 29, 1, NORMAL, 10),
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['double_edge', 'fire_fang'], 28, 29, 1, NORMAL, 10),

        # ('lokix', 0, 'wander_normal', 'tinted_lens', ['first_impression', 'knock_off'], 25, 26, 1, LONER, 10),


        # ('relicanth', 0, 'wander_normal', '', ['aqua_tail', 'rock_blast'], 23, 24, 1, NORMAL, 10),

        # ('sneasler', 0, 'retreater', 'poison_touch', ['fake_out', 'poison_jab', 'u_turn'], 28, 29, 1, NORMAL, 10),
 
        # ('snover', 0, 'retreater', 'snow_warning', ['leech_seed', 'energy_ball', 'powder_snow'], 28, 29, 1, NORMAL, 10),
        # ('ursaluna', 0, 'wander_normal', 'unnerve', ['superpower', 'thrash'], 28, 29, 1, NORMAL, 10),

 
               
        # ('snorunt', 0, 'wander_normal', 'snow_cloak', ['powder_snow'], 25, 20, 9, 10, NORMAL, 10),


        # 17 Hail

        # ('piloswine', 0, 'retreater', 'thick_fat', ['ancient_power', 'freeze_dry', 'haze'], 28, 29, 9, 10, NORMAL, 10),
        # ('weavile', 0, 'retreater', 'pressure', ['nasty_plot', 'freeze_dry', 'chilling_water'], 28, 29, 9, 10, NORMAL, 10),






        # # 18 Snow
        # ('misdreavus', 0, 'wander_normal', '', ['curse', 'hex', 'will_o_wisp'], 27, 28, 14, 15, NORMAL, 10),
        # ('misdreavus', 0, 'wander_normal', '', ['taunt', 'memento'], 27, 28, 14, 15, NORMAL, 10),


        # ('ursaring', 0, 'retreater', 'forecast', ['hammer_arm', 'thrash', 'taunt'], 28, 29, 9, 10, NORMAL, 10),
        # ('ursaring', 0, 'retreater', 'forecast', ['rock_slide', 'body_slam', 'taunt'], 28, 29, 9, 10, NORMAL, 10),

        # ('stantler', 0, 'retreater', 'intimidate', ['take_down', 'jump_kick'], 27, 28, 14, 15, NORMAL, 10),
        # ('stantler', 0, 'retreater', 'intimidate', ['hypnosis', 'nightmare'], 27, 28, 14, 15, NORMAL, 10),

        # ('snorunt', 0, 'retreater', 'ice_body', ['powder_snow'], 27, 28, 14, 15, NORMAL, 10),
        # ('snorunt', 0, 'retreater', 'ice_body', ['sing', 'protect', 'hex'], 27, 28, 14, 15, NORMAL, 10),

        # ('zoroark', 0, 'retreater', 'illusion', ['icy_wind', 'taunt', 'hex','will_o_wisp'], 30, 31, 9, 10, NORMAL, 10),
        # ('zoroark', 0, 'retreater', 'illusion', ['shadow_ball', 'memento'], 30, 31, 9, 10, NORMAL, 10),

        # ('mightyena', 0, 'retreater', 'intimidate', ['foul_play', 'snarl', 'taunt'], 28, 29, 9, 10, NORMAL, 10),
        # ('mightyena', 0, 'retreater', 'intimidate', ['yawn', 'embargo', 'taunt', 'sucker_punch'], 28, 29, 9, 10, NORMAL, 10),


        # # Hold berry?
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['curse', 'body_press', 'seed_bomb'], 28, 29, 9, 10, NORMAL, 10, ["sitrus_berry", "oran_berry"]),
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['double_edge', 'fire_fang'], 28, 29, 9, 10, NORMAL, 10, ["sitrus_berry"]),




        # # 19 Hail



        # # 20 Snow

        # ('greedent', 0, 'retreater', 'cheek_pouch', ['curse', 'body_press', 'seed_bomb'], 28, 29, 9, 10, NORMAL, 10),
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['double_edge', 'fire_fang'], 28, 29, 9, 10, NORMAL, 10),
        # ('glaceon', 0, 'retreater', 'snow_cloak', ['double_team', 'ice_beam', 'mirror_coat'], 28, 29, 9, 10, NORMAL, 10),
        # ('glaceon', 0, 'retreater', 'ice_body', ['aurora_veil', 'ice_beam', 'calm_mind'], 28, 29, 9, 10, NORMAL, 10),

        # ('furret', 0, 'retreater', 'frisk', ['blizzard', 'coil'], 28, 29, 9, 10, NORMAL, 10),

        # ('glalie', 0, 'retreater', 'snow_cloak', ['double_team', 'ice_beam', 'mirror_coat'], 28, 29, 9, 10, NORMAL, 10),


        # # sleeping

        # ('ursaluna', 0, 'wander_normal', 'unnerve', ['superpower', 'thrash'], 28, 29, 9, 10, NORMAL, 10),
        # ('snorlax', 0, 'wander_normal', 'thick_fat', ['curse', 'rest', 'body_slam', 'bulldoze'], 28, 29, 9, 10, NORMAL, 10),
        # ('cinccino', 0, 'wander_normal', 'cute_charm', ['uproar', 'tail_slap'], 28, 29, 9, 10, SUPPORT, 10),
        # ('greedent', 0, 'retreater', 'cheek_pouch', ['double_edge', 'fire_fang'], 28, 29, 9, 10, NORMAL, 10),
        # ('sneasler', 0, 'retreater', 'poison_touch', ['fake_out', 'poison_jab', 'u_turn'], 28, 29, 9, 10, NORMAL, 10),

        # ('basculegion', 0, 'wander_normal', 'adaptability', ['flip_turn', 'crunch', 'agility'], 28, 29, 9, 10, LONER, 10),

]


MONSTER_HOUSE_MONS = [
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
    "bronzor", "bronzong",
    "rhyhorn", "rhydon",
    "nosepass", "probopass",
    "chingling", "chimecho",
    "chinchou", "lanturn",
]


def create_monster_house(mon_name, form):
    """Build a single monster-house spawn entry."""
    return {
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


def build_monster_house_spawns():
    return [create_monster_house(name, 0) for name in MONSTER_HOUSE_MONS]


def _build_spawn_features(moves, item_name=None, status_id=None):
    spawn_features = [
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

    if item_name:
        items = item_name if isinstance(item_name, list) else [item_name]
        item_entries = [
            {
                "Spawn": {
                    "ID": item,
                    "Cursed": False,
                    "HiddenValue": "",
                    "Amount": 1,
                    "Price": 0
                },
                "Rate": 10
            }
            for item in items
        ]
        spawn_features.append({
            "$type": "PMDC.LevelGen.MobSpawnItem, PMDC",
            "Items": item_entries,
            "MapStartOnly": True,
            "Chance": {
                "Numerator": 1,
                "Denominator": 1
            }
        })

    if status_id:
        statuses = status_id if isinstance(status_id, list) else [status_id]
        status_entries = [
            {
                "Spawn": {
                    "ID": status,
                    "StatusStates": [
                        {
                            "$type": "RogueEssence.Dungeon.CountDownState, RogueEssence",
                            "Counter": -1
                        }
                    ]
                },
                "Rate": 10
            }
            for status in statuses
        ]
        spawn_features.append({
            "$type": "RogueEssence.LevelGen.MobSpawnStatus, RogueEssence",
            "Statuses": status_entries
        })

    return spawn_features


def create_mon(mon, min_floor):
    name, form, tactic, ability, moves, min_lev, max_lev, length, role, rate = mon[0:10]
    max_floor = min_floor + length
    item_name = mon[10] if len(mon) > 10 else None
    status_id = mon[11] if len(mon) > 11 else None

    return {
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
                "SpawnFeatures": _build_spawn_features(moves, item_name, status_id)
            },
            "Role": role
        },
        "Rate": rate,
        "Range": {
            "Min": min_floor,
            "Max": max_floor
        }
    }


def build_spawn_list(mons, max_level=100):
    result = []
    for floor_idx, group in enumerate(mons):
        for mon in group:
            min_lev = mon[5]
            if min_lev < max_level:
                result.append(create_mon(mon, floor_idx))
    return result


def write_zone_json(spawn_list, zone_path="../Data/Zone/emberfrost_depths.json"):
    with open(zone_path, "r", encoding="utf-8-sig") as file:
        data = json.load(file)

    data["Object"]["Segments"][1]["ZoneSteps"][4]["Spawns"] = spawn_list

    # data["Object"]["Segments"][0]["ZoneSteps"][5]["Mobs"] = build_monster_house_spawns()
    # data["Object"]["Segments"][0]["ZoneSteps"][6]["Mobs"] = build_monster_house_spawns()
    # data["Object"]["Segments"][0]["ZoneSteps"][7]["Mobs"] = build_monster_house_spawns()

    with open(zone_path, "w") as file:
        json.dump(data, file, indent=2)


def write_encounters_csv(mons, csv_filename="emberfrost_encounters.csv"):
    roles_arr = ["Normal", "Support", "Leader", "Loner"]

    with open(csv_filename, mode="w", newline="") as csv_file:
        csv_writer = csv.writer(csv_file)
        csv_writer.writerow([
            "Name", "Form", "Tactic", "Ability",
            "Move 1", "Move 2", "Move 3", "Move 4",
            "Min Lev", "Max Lev", "Min Floor", "Max Floor",
            "Role", "Rate", "Item", "Status"
        ])

        for floor_idx, group in enumerate(mons):
            for row in group:
                moves = list(row[4])
                while len(moves) != 4:
                    moves.append("")

                length = row[7]
                min_floor = floor_idx
                max_floor = floor_idx + length

                item_name = row[10] if len(row) > 10 else ""
                status_id = row[11] if len(row) > 11 else ""

                item_str = ",".join(item_name) if isinstance(item_name, list) else item_name
                status_str = ",".join(status_id) if isinstance(status_id, list) else status_id

                csv_writer.writerow([
                    row[0], row[1], row[2], row[3],
                    *moves,
                    row[5], row[6] + 1, min_floor + 1, max_floor + 1,
                    roles_arr[row[8]] if isinstance(row[8], int) else row[8], row[9],
                    item_str, status_str
                ])


def main():
    spawn_list = build_spawn_list(MONS)
    write_zone_json(spawn_list)
    write_encounters_csv(MONS)

if __name__ == "__main__":
    main()
