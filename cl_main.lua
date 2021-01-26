-- @desc Manage golf game
-- @author: Elio
-- @version: 2.0

local floor, abs, min = math.floor, math.abs, math.min

local sleep = 2000
local maxSleep = 10000
local localPlayer = GetLocalPlayer()

gfx:addBlipForPos(resort.pos, resort.blip.s, resort.blip.c, resort.blip.sc, resort.blip.d)

CreateThread(function()
    while true do

        if game:into() then
            sleep = 0
            game:handle()
        elseif not localPlayer:InVeh() then
            local d = #(localPlayer:Pos() - resort.pos)

            if d < resort.dist then
                gfx:helpTextFrame("PLAY_GOLF") -- LABEL : PLAY_GOLF | Press ~INPUT_CONTEXT~ to play Golf.

                if IsControlJustPressed(1, resort.control) then
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
