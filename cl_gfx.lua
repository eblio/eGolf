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
        -- -1 = all
        -- 0 = nothing
        -- 1 = map
        -- 2 = top right
        -- 3 = top right + map
        -- 8 = player list
        -- 9 = player list + map
        -- 10 = player list + top right
        -- 11 = player list + map + top right
        -- 16 = scoreboard
        -- 17 = scoreboard + map
        -- 18 = scoreboard + top right
        -- 19 = scoreboard + top right + map
        -- 24 = scoreboard + player list
        -- 25 = scoreboard + player list + map
        -- 26 = scoreboard + player list + top right
        -- 27 = scoreboard + player list + top right + map
function gfx:display(id)
    sHud:CallFunction('SET_DISPLAY', { id })
end

-- @desc Set the informations of the current shot
-- @param surface surface informations
-- @param wind wind informations
-- @param club club informations
-- @param hole hole informations
function gfx:setSwingDisplay(display, surface, windForce, windDirection, club, shots)
    local s = surfaces[surface]
    local c = clubs[club]
    sHud:CallFunction('SET_SWING_DISPLAY', {
        display,                                          -- Display type (47 = display lot of stuff)
        { s.label }, s.icon,                              -- Surface informations
        { 'GOLF_WIND_PLUS', windForce }, windDirection,   -- Wind informations
        { c.label }, c.icon,                              -- Club informations
        { 'collision_9b95m6d' }, false,                   -- Power types (not used atm)
        { 'GOLF_SPIN' }, 0, 0.0,                          -- Ball spin infos (nerver displayed)
        { 'SHOT_NUM', shots },                            -- Hole number of shots : IT IS WRONG ATM
    })
end

-- @desc Set the informations of the current hole
-- @param id hole number
function gfx:setHoleDisplay(id)
    local c = holes[id]
    sHud:CallFunction('SET_HOLE_DISPLAY', {
        { 'GOLF_HOLE_NUM', id },            -- Hole number
        { 'GOLF_PAR_NUM', c.par },          -- Hole par
        { 'DIST_METER', c.distance },       -- Hole initial distance
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
-- @param id hole id
function gfx:setMinimapHole(id)
    local c = holes[id]
    SetRadarZoom(c.mapZoom)
    SetMinimapGolfCourse(id)
    LockMinimapPosition(c.mapCenter)
    LockMinimapAngle(c.mapAngle)
    ToggleStealthRadar(false)

    if holeBlip ~= nil then RemoveBlip(holeBlip) end

    holeBlip = AddBlipForCoord(c.holeCoords)
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

function gfx:playHoleAnim(id, during)
    local c = holes[id].anim

    gfx:fadeOut(250, true)

    PlayCamAnim(holeCam, c.clip, holeDict, -1317.17, 60.494, 53.56, 0.0, 0.0, 0.0, 0, 2)
    SetCamActiveWithInterp(holeCam, GetRenderingCam(), c.time, 1, 1)
    RenderScriptCams(1, 0, 3000, 1, 0, 0)

    gfx:fadeIn(250, false)

    local currentTime = GetGameTimer()
    local endTime = currentTime + (GetAnimDuration(holeDict, c.clip) * 1000)
    
    while currentTime < endTime do
        currentTime = GetGameTimer()
        HideHudAndRadarThisFrame()
        Wait(0)
    end

    gfx:fadeOut(250, true)

    SetCamActive(holeCam, false)
    RenderScriptCams(0, 0, 0, 1, 0, 0)
    if during  ~= nil then during() end

    gfx:fadeIn(250, false)
end
