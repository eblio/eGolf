-- @desc Create a new golf game
-- @author Elio
-- @version 1.0

game = {} -- *Static class*

local currentHole = 0
local currentClub = 0
local inGame = false

function game:start()
    currentHole = 1
    currentClub = 1
    inGame = true
    golf:runSetup()
end

function game:stop()
    inGame = false
    golf:clearSetup()
end

function game:intro()
    -- Nothing to do there, yet ... 
end

function game:into()
    return inGame
end

function game:handle()

end

function game:display()
    
end
