-- @desc Manage golf game
-- @author: Elio
-- @version: 2.0

local floor, abs, min = math.floor, math.abs, math.min

local sleep = 2000
local maxSleep = 10000
local localPlayer = GetLocalPlayer()

CreateThread(function()
    while true do

        if game:in() then
            sleep = 0
            game:handle()
        else
            local d = #(localPlayer:Pos() - golfLocation)

            if d < dInt then
                gfx:helpTextFrame("PLAY_GOLF") -- LABEL : PLAY_GOLF | Press ~INPUT_CONTEXT~ to play Golf.

                if IsControlJustPressed(1, cStart) then
                    game:start()
                    game:intro()
                end

                sleep = 0
            else
                sleep = min(maxSleep, floor(abs(d)) * 10) -- Wait accordingly
            end
        end

        Wait(sleep)
    end
end)
