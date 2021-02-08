-- @desc Configuration of the fold game
-- at the moment most of these should not be changed
-- @author Elio
-- @version 1.0

-- Start point config
resort = {
    pos = vector3(-1366.49, 56.64, 54.09),
    dist = 2.5,
    control = 51, -- Linked to the label, don't change it
    blip = { s = 109, c = { 0, 255 }, sc = 1.0, d = 2 }
}

holeBlipSprite = 358
aimBlipSprite = 390
ballBlipSprite = 1

state = {
    nothing = 'nothing',
    idle = 'idle',
    charging = 'charging',
    shooting = 'shooting',
}

holes = {
    {
        par = 5,
        distance = 531,
        mapZoom = math.ceil(0.81 * 1100),
        mapAngle = 280,
        mapCenter = vector2(-1222.0, 83.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1114.121, 220.789, 63.78),
        teeCoords = vector3(-1370.93, 173.98, 57.01),
        anim = { clip = "hole_01_cam", time = 1000 },
    },
    {
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 89,
        mapCenter = vector2(-1216.0, 247.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1322.07, 158.77, 56.69),
        teeCoords = vector3(-1107.26, 157.15, 62.04),
        anim = { clip = "hole_02_cam", time = 1300 },
    },
    {
        par = 3,
        distance = 436,
        mapZoom = math.ceil(0.1 * 1100),
        mapAngle = 264,
        mapCenter = vector2(-1274.5, 65.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1237.419, 112.988, 56.086),
        teeCoords = vector3(-1312.97, 125.64, 56.39),
        anim = { clip = "hole_03_cam", time = 2500 },
    },
    {
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.55 * 1100),
        mapAngle = 232,
        mapCenter = vector2(-1197.0, 1.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1096.541, 7.848, 49.63),
        teeCoords = vector3(-1218.56, 107.48, 57.04),
        anim = { clip = "hole_04_cam", time = 1200 },
    },
    {
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 220,
        mapCenter = vector2(-1090.0, -70.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-957.386, -90.412, 39.161),
        teeCoords = vector3(-1098.15, 69.5, 53.09),
        anim = { clip = "hole_05_cam", time = 2000 },
    },
    {
        par = 3,
        distance = 436,
        mapZoom = math.ceil(0.4 * 1100),
        mapAngle = 90,
        mapCenter = vector2(-1051.0, -55.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1103.516, -115.163, 40.444),
        teeCoords = vector3(-987.7, -105.42, 39.59),
        anim = { clip = "hole_06_cam", time = 1800 },
    },
    {
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.75 * 1100),
        mapAngle = 57,
        mapCenter = vector2(-1164.0, 40.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1290.632, 2.754, 49.217),
        teeCoords = vector3(-1117.793, -104.069, 40.8406),
        anim = { clip = "hole_07_cam", time = 2000 },
    },
    {
        par = 5,
        distance = 436,
        mapZoom = math.ceil(0.825 * 1100),
        mapAngle = 240,
        mapCenter = vector2(-1212.0, -120.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1034.944, -83.144, 42.919),
        teeCoords = vector3(-1272.63, 38.4, 48.75),
        anim = { clip = "hole_08_cam", time = 1800 },
    },
    {
        par = 4,
        distance = 436,
        mapZoom = math.ceil(0.675 * 1100),
        mapAngle = 63,
        mapCenter = vector2(-1173.0, 117.0),
        spawn = vector3(-1367.2, 176.44, 58.01),
        holeCoords = vector3(-1294.775, 83.51, 53.804),
        teeCoords = vector3(-1138.381, 0.60467, 47.98225),
        anim = { clip = "hole_09_cam", time = 2100 },
    },
}

clubs = {
    {
        hash = `prop_golf_driver`,
        label = 'CLUB_1',
        icon = 1,
        pos = vector3(0.38, -0.79, 0.94),
        idle = 'wood_idle_a',
        action = 'wood_swing_action',
        intro = 'wood_swing_intro'
    },
    {
        hash = `prop_golf_wood_01`,
        label = 'CLUB_2',
        icon = 3,
        pos = vector3(0.3, -0.92, 0.99),
        idle = 'wood_idle_a',
        action = 'wood_swing_action',
        intro = 'wood_swing_intro'
    },
    {
        hash = `prop_golf_wood_01`,
        label = 'CLUB_3',
        icon = 5,
        pos = vector3(0.3, -0.92, 0.99),
        idle = 'wood_idle_a',
        action = 'wood_swing_action',
        intro = 'wood_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_4',
        icon = 9,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_5',
        icon = 10,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_6',
        icon = 11,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_7',
        icon = 12,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_8',
        icon = 13,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_9',
        icon = 14,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_iron_01`,
        label = 'CLUB_10',
        icon = 15,
        pos = vector3(0.4, -0.83, 0.94),
        idle = 'iron_idle_a',
        action = 'iron_swing_action',
        intro = 'iron_swing_intro'
    },
    {
        hash = `prop_golf_pitcher_01`,
        label = 'CLUB_11',
        icon = 16,
        pos = vector3(0.38, -0.79, 0.94),
        idle = 'wedge_idle_a',
        action = 'wedge_swing_action',
        intro = 'wedge_swing_intro'
    },
    {
        hash = `prop_golf_pitcher_01`,
        label = 'CLUB_12',
        icon = 17,
        pos = vector3(0.38, -0.79, 0.94),
        idle = 'wedge_idle_a',
        action = 'wedge_swing_action',
        intro = 'wedge_swing_intro'
    },
    {
        hash = `prop_golf_pitcher_01`,
        label = 'CLUB_13',
        icon = 18,
        pos = vector3(0.38, -0.79, 0.94),
        idle = 'wedge_idle_a',
        action = 'wedge_swing_action',
        intro = 'wedge_swing_intro'
    },
    {
        hash = `prop_golf_putter_01`,
        label = 'CLUB_14',
        icon = 19,
        pos = vector3(0.14, -0.62, 0.99),
        idle = 'putt_idle_a',
        action = 'putt_action',
        intro = 'putt_intro'
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

-- Controls
-- You probably don't want to touch to these as the display isn't
-- automaticly sinced to 
INPUT_GROUP = 0
INPUT_CLUB_UP = 241
INPUT_CLUB_DOWN = 242
INPUT_AIM_LEFT = 
INPUT_AIM_RIGHT = 

BUTTONS_DISPLAY = {
    shooting = {
        { id = 24, display = GetControlInstructionalButton(0, 24, true), desc = 'INST_SHOT' },
        { id = 241, display = GetControlGroupInstructionalButton(2, 24, true), desc = 'INST_CLUB' },
        { id = 242 },
        { id = 24, display = GetControlGroupInstructionalButton(2, 5, true), desc = 'INST_AIM' },
        { id = 175 },
    }
}
