-- Golf minigame graphics.
-- @author Elio
-- @version 2.0

-- This file was written thanks to decompiled scripts and (regarding scaleforms) :
-- https://www.vespura.com/fivem/scaleform/
-- https://github.com/DevTestingPizza/FiveMGolf/blob/master/FiveMGolf/Gfx.cs

gfx = {} -- *Static class*

-- Scaleforms stuff
local sHud = nil        -- Hole, wind, scoreboard ...
local sFloating = nil   -- Ball informations
local sButtons = nil    -- Instructional buttons
local sMessage = nil    -- Big message
local holeBlip = nil    -- Hole blip

-- Camera animation stuff
local holeCam = nil
local holeDict = 'mini@golfhole_preview'
local holeToClip = {
    [0] = "hole_01_cam",
    [1] = "hole_02_cam",
    [2] = "hole_03_cam",
    [3] = "hole_04_cam",
    [4] = "hole_05_cam",
    [5] = "hole_06_cam",
    [6] = "hole_07_cam",
    [7] = "hole_08_cam",
    [8] = "hole_09_cam"
}

local holeToTime = {
    [0] = 1000,
    [1] = 1300,
    [2] = 2500,
    [3] = 1200,
    [4] = 2000,
    [5] = 1800,
    [6] = 2000,
    [7] = 1800,
    [8] = 2100
}

-- @section Classic stuff

-- @desc Draw help text for a frame
-- @param label label of the text
function gfx:helpTextFrame(label)
    DisplayHelpTextThisFrame(label, 0)
end

-- @desc Apply options to the specific blip
-- @param blip blip handle
-- @param sprite sprite
-- @param color table = { color, alpha }
-- @param scale scale
-- @param display display type
function gfx:applyBlipOptions(blip, sprite, color, scale, display)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color[1])
    SetBlipAlpha(blip, color[2])
    SetBlipScale(blip, scale)
    SetBlipDisplay(blip, display)
end

-- @desc Add a blip to a specific location
-- @param pos position
-- @param sprite sprite
-- @param color table = { color, alpha }
-- @param scale scale
-- @param display display type
-- @return blip handle
function gfx:addBlipForPos(pos, sprite, color, scale, display)
    local blip = AddBlipForCoord(pos)
    gfx:applyBlipOptions(blip, sprite, color, scale, display)
    return blip
end

-- @desc Add a blip to a specific entity
-- @param ent entity
-- @param sprite sprite
-- @param color table = { color, alpha }
-- @param scale scale
-- @param display display type
-- @return blip handle
function gfx:addBlipForEntity(ent, sprite, color, scale, display)
    local blip = AddBlipForEntity(ent)
    gfx:applyBlipOptions(blip, sprite, color, scale, display)
    return blip
end

-- @desc Do a screen fade in
-- @param ms milliseconds
function gfx:fadeIn(ms, sync)
    DoScreenFadeIn(ms)
    if sync then Wait(ms + 100) end
end

-- @desc Do a screen fade out
-- @param ms milliseconds
function gfx:fadeOut(ms, sync)
    DoScreenFadeOut(ms)
    if sync then Wait(ms + 100) end
end

-- @section Golf specific stuff

-- @desc Initialize the scaleforms
function gfx:init()
    -- Scaleform stuff
    sHud = Scaleform('GOLF')
    sFloating = Scaleform('GOLF_FLOATING_UI')
    sButtons = Scaleform('INSTRUCTIONAL_BUTTONS')
    sMessage = Scaleform('MIDSIZED_MESSAGE')

    -- Camera stuff
    holeCam = CreateCamera(964613260, 0)
    RequestAnimDict(holeDict)
end

-- @desc Clear everything that was requested
function gfx:clear()
    -- Scaleform stuff
    sHud:Destroy()
    sFloating:Destroy()
    sButtons:Destroy()
    sMessage:Destroy()
    gfx:clearMinimap()

    -- Camera stuff
    DestroyCam(holeCam, false)
    holeCam = nil
end

-- @desc Render the global HUD
function gfx:renderHud()
    sHud:Render2D()
end

-- @desc Render the floating UI
function gfx:renderFloatingUI()
    sFloating:Render2D()
end

-- @desc Render the instructional buttons
function gfx:renderButtons()
    sButtons:Render2D()
end

-- @desc Render the message
function gfx:renderMessage()
    sMessage:Render2D()
end

-- @desc Set the display of the UI
-- @param id display identifier
function gfx:display(id)
    sHud:CallFunction('SET_DISPLAY', { id })
end

-- @desc Set the informations of the current shot
-- @param surface surface informations
-- @param wind wind informations
-- @param club club informations
-- @param hole hole informations
function gfx:setSwingDisplay(surface, wind, club, hole)    
    sHud:CallFunction('SET_SWING_DISPLAY', {
        47,                                               -- Display type (47 = display everything)
        { surface.label }, surface.icon,                  -- Surface informations
        { 'GOLF_WIND_PLUS', wind.force }, wind.direction, -- Wind informations
        { club.label }, club.icon,                        -- Club informations
        { 'collision_9b95m6d' }, false,                   -- Power types (not used atm)
        { 'GOLF_SPIN' }, 0, 0.0,                          -- Ball spin infos (nerver displayed)
        { 'SHOT_NUM', hole.shots },                       -- Hole number of shots
    })
end

-- @desc Set the informations of the current hole
-- @param hole hole informations
function gfx:setHoleDisplay(hole)
    sHud:CallFunction('SET_HOLE_DISPLAY', {
        { 'GOLF_HOLE_NUM', hole.id },       -- Hole number
        { 'GOLF_PAR_NUM', hole.par },       -- Hole par
        { 'GOLF_HOLE_DIST', hole.shots },   -- Hole number of shots
    })
end

-- @desc Enable of disable informations of the current swing
-- @param enable toggle
function gfx:enableSwingPreview(enable)
    if enable then
        sHud:CallFunction("SWING_METER_TRANSITION_IN", {});             -- Display the swing meter
        sHud:CallFunction("SWING_METER_POSITION", { 0.6, 0.6, 0.5 });   -- Position of swing meter
    else
        sHud:CallFunction("SWING_METER_TRANSITION_OUT", { 200 });   -- Remove the swing meter
    end
end

-- @desc Set the swing preview informations
-- @param markerPos marker position
-- @param targetPos target position
function gfx:setSwingPreview(markerPos, targetPos)
    sHud:CallFunction("SWING_METER_SET_MARKER", { true, markerPos, true, 0.0 }); -- Marker position
    sHud:CallFunction("SWING_METER_SET_TARGET", { 0.25, targetPos });            -- Target position
end

-- @desc Set the informations of the current shot
-- @param dist distance of the shot
-- @param distFlag distance from the flag
-- @param strength strength of the shot
-- @param height height of the shot
function gfx:setShotPreview(dist, distFlag, strength, height)
    sFloating:CallFunction('SET_SWING_DISTANCE', { { 'PREVIEW_DIST' }, { 'DIST_METER', dist } })    -- Distance shooting
    sFloating:CallFunction('SET_PIN_DISTANCE', { { 'PREVIEW_PIN' }, { 'DIST_METER', distFlag } })   -- Distance from the flag
    sFloating:CallFunction('SET_STRENGTH', { { 'PREVIEW_PCT' }, { 'STRENGTH_PER', strength } })     -- Force
    sFloating:CallFunction('SET_HEIGHT', { { 'PREVIEW_HT' }, { 'DIST_CM', height  } })              -- Max height
end

-- @desc Set the current instructional buttons
-- @param buttons buttons to display
function gfx:setButtons(buttons)
    sButtons:CallFunction('CLEAR_ALL', {})
    local index = 0

    for i = 1, #buttons do
        local button = buttons[i]
        if button.display ~= nil then
            sButtons:CallFunction('SET_DATA_SLOT', {
                index,
                button.display,
                button.desc
            })
            index = index + 1
        end
    end

    sButtons:CallFunction('DRAW_INSTRUCTIONAL_BUTTONS', { -1 })
end

-- @desc Set the minimap hole
-- @param hole hole informations
function gfx:setMinimapHole(hole)
    SetRadarZoom(hole.mapZoom)
    SetMinimapGolfCourse(hole.id)
    LockMinimapPosition(hole.mapCenter)
    LockMinimapAngle(hole.mapAngle)
    ToggleStealthRadar(false)

    if holeBlip ~= nil then
        RemoveBlip(holeBlip)
    end

    holeBlip = AddBlipForCoord(hole.holeCoords)
    SetBlipSprite(holeBlip, 358)
end

-- @desc Clear the minimap display
function gfx:clearMinimap()
    SetMinimapGolfCourseOff()
	UnlockMinimapAngle()
	UnlockMinimapPosition()
    SetRadarZoom(0)
    
    if holeBlip ~= nil then
        RemoveBlip(holeBlip)
        holeBlip = nil
    end
end

function gfx:playHoleAnim(id)
    if holeCam ~= nil and HasAnimDictLoaded(holeDict) then

        gfx:fadeOut(250, true)
        PlayCamAnim(holeCam, holeToClip[id], holeDict, -1317.17, 60.494, 53.56, 0.0, 0.0, 0.0, 0, 2)
        SetCamActiveWithInterp(holeCam, GetRenderingCam(), holeToTime[id], 1, 1)
        RenderScriptCams(1, 0, 3000, 1, 0, 0)
        gfx:fadeIn(250, false)

        Wait(GetAnimDuration(holeDict, holeToClip[id]) * 1000)

        gfx:fadeOut(250, true)
        SetCamActive(holeCam, false)
        RenderScriptCams(0, 0, 0, 1, 0, 0)
        gfx:fadeIn(250, false)
    end
end

-- Not working properly yet, math are needed
-- function gfx:enableTrailPath(from, to)
--     GolfTrailSetEnabled(true)
--     GolfTrailSetPath(from, to.x, to.y, 10.5, 1.0, 0.5, false)
-- end

-- function gfx:disableTrailPath()
--     GolfTrailSetEnabled(false)
-- end
