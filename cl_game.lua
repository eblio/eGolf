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
end

function game:stop()
    inGame = false
end

function game:intro()
    
end

function game:into()
    return inGame
end

function game:handle()

end

function game:display()
    
end
