golfLocation = vector3(0, 0, 0)
dInt = 2.5
cStart = 51

ballHash = `prop_golf_ball`
teeHash = `prop_golf_tee`

holeBlipSprite = 358
aimBlipSprite = 390
ballBlipSprite = 1

state = {
    nothing = 'nothing',
    idle = 'idle',
    charging = 'charging',
    shooting = 'shooting',
}

buttons = {
    idle = {
        -- { button = 200, desc = GetLabelText('GOLF_NEXT_HOLE') },
        -- { button = 18, desc = GetLabelText('GOLF_CONTINUE') },
    },
    shooting = {
        { id = 24, display = GetControlInstructionalButton(0, 24, true), desc = 'INST_SHOT' },
        { id = 241, display = GetControlGroupInstructionalButton(2, 24, true), desc = 'INST_CLUB' },
        { id = 242 },
        { id = 24, display = GetControlGroupInstructionalButton(2, 5, true), desc = 'INST_AIM' },
        { id = 175 },
    }
}

holes = {
    {
        id = 1,
        shots = 0,
        par = 5,
        distance = 531,
        mapZoom = math.ceil(0.81 * 1100),
        mapAngle = 280,
        mapCenter = vector2(-1222.0, 83.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1114.121, 220.789, 63.78),
        teeCoords = vector3(-1370.93, 173.98, 57.01)
    },
    {
        id = 2,
        shots = 0,
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 89,
        mapCenter = vector2(-1216.0, 247.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1322.07, 158.77, 56.69),
        teeCoords = vector3(-1107.26, 157.15, 62.04)
    },
    {
        id = 3,
        shots = 0,
        par = 3,
        distance = 436,
        mapZoom = math.ceil(0.1 * 1100),
        mapAngle = 264,
        mapCenter = vector2(-1274.5, 65.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1237.419, 112.988, 56.086),
        teeCoords = vector3(-1312.97, 125.64, 56.39)
    },
    {
        id = 4,
        shots = 0,
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.55 * 1100),
        mapAngle = 232,
        mapCenter = vector2(-1197.0, 1.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1096.541, 7.848, 49.63),
        teeCoords = vector3(-1218.56, 107.48, 57.04)
    },
    {
        id = 5,
        shots = 0,
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 220,
        mapCenter = vector2(-1090.0, -70.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-957.386, -90.412, 39.161),
        teeCoords = vector3(-1098.15, 69.5, 53.09)
    },
    {
        id = 6,
        shots = 0,
        par = 3,
        distance = 436,
        mapZoom = math.ceil(0.4 * 1100),
        mapAngle = 90,
        mapCenter = vector2(-1051.0, -55.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1103.516, -115.163, 40.444),
        teeCoords = vector3(-987.7, -105.42, 39.59)
    },
    {
        id = 7,
        shots = 0,
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 57,
        mapCenter = vector2(-1164.0, 40.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1290.632, 2.754, 49.217),
        teeCoords = vector3(-1117.793, -104.069, 40.8406)
    },
    {
        id = 8,
        shots = 0,
        par = 5,
        distance = 436,
        mapZoom = math.ceil(0.825 * 1100),
        mapAngle = 240,
        mapCenter = vector2(-1212.0, -120.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1034.944, -83.144, 42.919),
        teeCoords = vector3(-1272.63, 38.4, 48.75)
    },
    {
        id = 9,
        shots = 0,
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.675 * 1100),
        mapAngle = 63,
        mapCenter = vector2(-1173.0, 117.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1294.775, 83.51, 53.804),
        teeCoords = vector3(-1138.381, 0.60467, 47.98225)
    },
}

anims = {
    idle = 'idle',
    swingIntro = 'swing_intro',
    swingAction = 'swing_action',
}

clubs = {
    -- Driver
    {
        prop = `prop_golf_driver`,
        label = 'CLUB_1', -- 'collision_hmhne2',
        icon = 1,
        pos = vector3(0.38, -0.79, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        },
    },
    -- Woods
    {
        prop = `prop_golf_wood_01`,
        label = 'CLUB_2', -- 'collision_34g1vu',
        icon = 3,
        pos = vector3(0.3, -0.92, 0.99),
        anim = {
            prefix = 'wood_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_wood_01`,
        label = 'CLUB_3', -- 'collision_34g1vw',
        icon = 5,
        pos = vector3(0.3, -0.92, 0.99),
        anim = {
            prefix = 'wood_',
            suffix = '_high',
        }
    },
    -- Irons
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_4', -- 'collision_34g1vy',
        icon = 9,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_5', -- 'collision_34g1vz',
        icon = 10,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_6', -- 'collision_7u9nbd5',
        icon = 11,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_7', -- 'collision_94kanvh',
        icon = 12,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_8', -- 'collision_94kanvi',
        icon = 13,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_9', -- 'collision_94kanvj',
        icon = 14,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_iron_01`,
        label = 'CLUB_10', -- 'collision_94kanvk',
        icon = 15,
        pos = vector3(0.4, -0.83, 0.94),
        anim = {
            prefix = 'iron_',
            suffix = '_high',
        }
    },
    -- Pitchers
    {
        prop = `prop_golf_pitcher_01`,
        label = 'CLUB_11', -- 'collision_94kanvl',
        icon = 16,
        pos = vector3(0.38, -0.79, 0.94),
        anim = {
            prefix = 'wedge_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_pitcher_01`,
        label = 'CLUB_12', -- 'collision_94kanvn',
        icon = 17,
        pos = vector3(0.38, -0.79, 0.94),
        anim = {
            prefix = 'wedge_',
            suffix = '_high',
        }
    },
    {
        prop = `prop_golf_pitcher_01`,
        label = 'CLUB_13', -- 'collision_94kanvo',
        icon = 18,
        pos = vector3(0.38, -0.79, 0.94),
        anim = {
            prefix = 'wedge_',
            suffix = '_high',
        }
    },
    -- Putter
    {
        prop = `prop_golf_putter_01`,
        label = 'CLUB_14', -- 'collision_94kanvq',
        icon = 19,
        pos = vector3(0.14, -0.62, 0.99),
        anim = {
            prefix = 'putt_',
            suffix = '_low',
        }
    },
}

powerTypes = {
    'collision_9b95m6d', -- Normal
    'collision_8508fe1', -- Power
    'collision_g6wlm9', -- Punch
    'collision_9r0tisc', -- Approach
    'collision_lne5sx', -- Long Putt
    'collision_80yyqnp', -- Putt
    'collision_958446q' -- Short Putt
}

surfaces = {
    ['tee'] = { -- Tee (default)
        label = 'LIE_TEE',
        icon = 7,
        sound = 'GOLF_BALL_IMPACT_TREE_SOFT_MASTER',
    },
    [-1595148316] = { -- Sand
        label = 'LIE_BUNKER',
        icon = 2,
        sound = 'GOLF_BALL_IMPACT_SAND_LIGHT_MASTER',
    },
    [-461750719] = { -- Grass
        label = 'LIE_ROUGH',
        icon = 6,
        sound = 'GOLF_BALL_IMPACT_GRASS_LIGHT_MASTER',
    },
    [1333033863] = { -- Fairway
        label = 'LIE_FAIRWAY',
        icon = 4,
        sound = 'GOLF_BALL_IMPACT_FAIRWAY_LIGHT_MASTER',
    },
    [-1286696947] = { -- Green
        label = 'LIE_GREEN',
        icon = 3,
        sound = 'GOLF_BALL_IMPACT_FAIRWAY_MASTER', -- no sound ?
    },
    ['invalid'] = {
        label = 'LIE_UNKNOWN',
        icon = 1,
        sound = 'GOLF_BALL_IMPACT_TREE_SOFT_MASTER'
    }
}
