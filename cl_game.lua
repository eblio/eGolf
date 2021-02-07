-- @desc Create a new golf game
-- @author Elio
-- @version 1.0

game = {} -- *Static class*

local currentHole = 0
local currentClub = 0
local inGame = false

local currentState = NONE

function game:start()
    currentHole = 1
    currentClub = 1
    currentState = NONE
    inGame = true
    golf:init()
end

function game:stop()
    inGame = false
    golf:clear()
end

function game:intro()
    -- Nothing to do there, yet ...
    -- A cinematic would be nice
end

function game:into()
    return inGame
end

function game:handle()
    if currentState == NONE then
        currentState = golf:startHole(currentHole)
    elseif currentState == SHOOTING then
        currentState = golf:handleShoot()
    elseif currentState == VIEWING then

    elseif currentState == TRANSITION then

    end

    -- Stuff to run every fram in order to restrict the player
    -- to a "normal" playing behaviour
    HudWeaponWheelIgnoreSelection()
end

RegisterCommand('clear', function()
    golf:init()
    golf:clear()
    ClearPedTasksImmediately(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
end)
