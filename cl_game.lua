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

function game:end()
    inGame = false
end

function game:intro()
    
end

function game:in()
    return inGame
end

function game:display()
    
end



