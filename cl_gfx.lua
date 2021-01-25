-- Golf minigame graphics.
-- @author Elio
-- @version 2.0

-- This file was written thanks to decompiled scripts and :
-- https://www.vespura.com/fivem/scaleform/
-- https://github.com/DevTestingPizza/FiveMGolf/blob/master/FiveMGolf/Gfx.cs

gfx = {}

local sHud = nil        -- Hole, wind, scoreboard ...
local sFloating = nil   -- Ball informations
local sButtons = nil    -- Instructional buttons
local sMessage = nil    -- Big message
local holeBlip = nil    -- Hole blip

-- @desc Initialize the graphics
function gfx:init()
    sHud = Scaleform('GOLF')
    sFloating = Scaleform('GOLF_FLOATING_UI')
    sButtons = Scaleform('INSTRUCTIONAL_BUTTONS')
    sMessage = Scaleform('MIDSIZED_MESSAGE')
end

-- @desc Clear everything that was requested
function gfx:clear()
    sHud:Destroy()
    sFloating:Destroy()
    sButtons:Destroy()
    sMessage:Destroy()
    gfx:clearMinimap()
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

function gfx:enableTrailPath(from, to)
    GolfTrailSetEnabled(true)
    GolfTrailSetPath(from, to.x, to.y, 10.5, 1.0, 0.5, false)
end

function gfx:disableTrailPath()
    GolfTrailSetEnabled(false)
end

function gfx:helpTextFrame(label)
    DisplayHelpTextThisFrame(label, 0)
end
