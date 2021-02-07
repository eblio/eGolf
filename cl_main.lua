-- @desc Manage golf game
-- @author: Elio
-- @version: 2.0

local floor, abs, min = math.floor, math.abs, math.min

local sleep = 2000
local maxSleep = 10000
local localPlayer = GetLocalPlayer()

gfx:addBlipForPos(resort.pos, resort.blip.s, resort.blip.c, resort.blip.sc, resort.blip.d)

CreateThread(function()
    -- while true do

        -- if game:into() then
        --     game:handle()
        --     sleep = 0
        -- elseif not localPlayer:InVeh() then
        --     local d = #(localPlayer:Pos() - resort.pos)

        --     if d < resort.dist then
        --         gfx:helpTextFrame("PLAY_GOLF") -- LABEL : PLAY_GOLF | Press ~INPUT_CONTEXT~ to play Golf.

        --         if IsControlJustPressed(1, resort.control) then
        --             game:intro()
        --             game:start()
        --         end

        --         sleep = 0
        --     else
        --         sleep = min(maxSleep, floor(abs(d)) * 10) -- Wait accordingly
        --     end
        -- end

        -- Wait(sleep)

        local from = localPlayer:Pos()
        Wait(5000)
        local to = localPlayer:Pos()
        local o = to - from
        local t = math.abs((math.cos(o.x) + math.sin(o.y)) * #(o))
        GolfTrailSetEnabled(true)
        print(t)
        GolfTrailSetPath(
            from.x, from.y, from.z, -- Starting point
            o.x, -- x offset
            o.y, -- y offset
            t, -- seems linearly related to the previous arguments, sometimes it is two times the diameter but might be unrelated
            1.0, -- Scale 
            to.z, -- Target height (z axis)
            false -- limits the trail to one axis (useless anyway)
        )

        while true do
            Wait(0)
            DrawLine(from, to, 255, 10, 10, 255)
        end

        -- GolfTrailSetEnabled(true)
        -- for i = 1, 100 do
        --     Wait(200)
        --     GolfTrailSetPath(
        --         from.x, from.y, from.z, -- Starting point
        --         5.0, -- x offset
        --         5.0, -- y offset
        --         6.7, -- seems linearly related to the previous arguments, sometimes it is two times the diameter but might be unrelated
        --         1.0, -- Scale 
        --         from.z, -- Target height (z axis)
        --         false -- limits the trail to one axis (useless anyway)
        --     )
        --     print(i)
        -- end
        -- GolfTrailSetRadius(from.x, from.y, from.z)
        -- GolfTrailSetRadius(0.025, 0.3, 0.025)
        -- GolfTrailSetColour(255, 255, 255, 100, 255, 255, 255, 100, 255, 255, 255, 100)
        -- GolfTrailSetShaderParams(1.0, 1.0, 1.0, 1.0, 0.3)

    -- end
end)

CreateThread(function()
    while true do
        Wait(0)
        local c = localPlayer:Pos()
        local x = c + vector3(1.0, 0.0, 0.0)
        local y = c + vector3(0.0, 1.0, 0.0)
        local z = c + vector3(0.0, 0.0, 1.0)

        DrawLine(c, x, 255, 10, 10, 255)
        DrawLine(c, y, 10, 255, 10, 255)
        DrawLine(c, z, 10, 10, 255, 255)
    end
end)

RegisterCommand('dist', function()
    local from = localPlayer:Pos()
    Wait(5000)
    local to = localPlayer:Pos()
    print(#(from - to))
end)
