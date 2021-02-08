-- @desc Handle most of the golf stuff
-- @author Elio
-- @version 2.0

golf = {} -- *Static class*

-- @section Constants that you should not modify
local BALL_HASH = `prop_golf_ball`
local TEE_HASH = `prop_golf_tee`
local GOLF_ANIM_DICT = 'mini@golfai'
local GOLF_IPL = 'GolfFlags'

-- @section Player
local localPlayer = GetLocalPlayer()

-- @section Objects handles
local ball = nil
local tee = nil
local club = nil

-- @section Current game
local currentClub = 1
local currentSurface = 'tee'
local currentHole = 0
local currentHoles = {}

-- @section Local functions to factor code (mostly)

local function createNewObject(handle, hash, pos)
    if DoesEntityExist(handle) then DeleteEntity(handle) end
    return CreateObject(hash, pos, false, false, false) -- This will probably be dispatched to the server later on
end

local function getWind()
    local wd = GetWindDirection()
    local mag = Vmag(wd) * GetWindSpeed()

    wd = GetHeadingFromVector_2d(wd.x, wd.y) + GetGameplayCamRelativeHeading() + localPlayer:Heading()

    return wd, math.ceil(mag)
end

-- @section General stuff

function golf:init()
    gfx:init()
    RequestAdditionalText('SP_GOLF', 3)
    -- RequestStreamedTextureDict('GolfPutting', false)
    RequestAnimDict(GOLF_ANIM_DICT)
    -- RequestNamedPtfxAsset('scr_minigamegolf')

    RequestModel(BALL_HASH)
    RequestModel(TEE_HASH)

    for i = 1, #clubs do
        RequestModel(clubs[i].hash)
    end

    RequestIpl(GOLF_IPL)

    for i = 1, #holes do
        currentHoles[i] = { shots = 0 }
    end
end


function golf:clear()
    gfx:clear()
    ClearAdditionalText(3, 1)
    -- SetStreamedTextureDictAsNoLongerNeeded('GolfPutting')
    RemoveAnimDict(GOLF_ANIM_DICT)
    -- RemoveNamedPtfxAsset('scr_minigamegolf')

    SetModelAsNoLongerNeeded(BALL_HASH)
    SetModelAsNoLongerNeeded(TEE_HASH)

    for i = 1, #clubs do
        SetModelAsNoLongerNeeded(clubs[i].hash)
    end

    RemoveIpl(GOLF_IPL)
end

function golf:startHole(id)
    local c = holes[id]

    gfx:playHoleAnim(id, function()
        -- HUD initialization
        gfx:setMinimapHole(id)
        gfx:display(15)
        gfx:setHoleDisplay(id, currentHoles[id].shots)
        gfx:setButtons(buttons.shooting)
        gfx:enableSwingPreview(true)

        -- Other initializations
        currentHole = id
        currentSurface = 'tee'
        
        -- Create of the objects
        tee = createNewObject(tee, TEE_HASH, c.teeCoords)
        ball = createNewObject(ball, BALL_HASH, c.teeCoords + vector3(0.0, 0.0, 0.05))
        club = createNewObject(club, clubs[currentClub].hash, localPlayer:Pos())

        gfx:addBlipForEntity(ball, ballBlipSprite, { 0, 255 }, 0.8, 2)

        -- Placement of everything
        AttachEntityToEntity(club, localPlayer:Ped(), localPlayer:BoneIndex(28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        AttachEntityToEntity(localPlayer:Ped(), ball, 20, clubs[currentClub].pos, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
        TaskPlayAnim(localPlayer:Ped(), GOLF_ANIM_DICT, clubs[currentClub].idle, 1.0, -1.0, -1, 0, 0.0, false, false, false)
    end)

    return SHOOTING
end

function golf:handleShoot()
    -- Display the HUD
    gfx:renderHud()
    gfx:renderButtons()

    -- Update the informations
    local windDirection, windForce = getWind()
    gfx:setSwingDisplay(47, currentSurface, windForce, windDirection, currentClub, currentHoles[currentHole].shots)

    -- Handle animations and key press
    

    return SHOOTING
end

-- local math = math -- localization

-- local blip = nil

-- local clubIndex = 1
-- local currentClub = clubs[clubIndex]
-- local clubObject = nil

-- local holeIndex = 1
-- local currentHole = holes[holeIndex]

-- local powerTypeIndex = 1
-- local currentPowerType = powerTypes[powerTypeIndex]

-- local ballObject = nil

-- local currentState = state.idle
-- local charge = 0

-- -- PED FUNCTIONS

-- function golf:disableControls()
--     DisableControlAction(0, 142, 1)
--     DisableControlAction(0, 143, 1)
--     DisableControlAction(0, 79, 1)
--     DisableControlAction(0, 287, 1)
--     DisableControlAction(0, 286, 1)
--     DisableControlAction(0, 44, 1)
--     DisableControlAction(0, 37, 1)
--     DisableControlAction(0, 66, 1)
--     DisableControlAction(0, 67, 1)
--     DisableControlAction(0, 68, 1)
--     DisableControlAction(0, 69, 1)
--     DisableControlAction(0, 70, 1)
--     DisableControlAction(0, 99, 1)
--     DisableControlAction(0, 100, 1)
-- end

-- -- Place the ped according to the ball posisiton.
-- function golf:placePed()
--     AttachEntityToEntity(localPlayer:Ped(), ballObject, 20, currentClub.pos, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
-- end

-- function golf:playAnim(anim)
--     TaskPlayAnim(localPlayer:Ped(), 'mini@golfai', anim, 1.0, -1.0, -1, 0, 0.0, false, false, false)
--     -- TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
-- end

-- function golf:isPlayingAnim(anim)
--     return IsEntityPlayingAnim(localPlayer:Ped(), 'mini@golfai', anim, 3)
-- end

-- function golf:animTime(anim)
--     return GetEntityAnimCurrentTime(localPlayer:Ped(), 'mini@golfai', anim)
-- end

-- -- Play the animation accordingly to the current club.
-- function golf:handleAnim()
--     local anim = currentClub.anim.prefix

--     if currentState == state.idle then
--         anim = anim .. anims.idle .. '_a'

--         if not golf:isPlayingAnim(anim) then
--             golf:playAnim(anim)
--         end
--     elseif currentState == state.charging then
--         anim = anim .. anims.swingIntro

--         if not golf:isPlayingAnim(anim) then
--             golf:playAnim(anim)
--         else
--             charge = golf:animTime(anim)
--         end
--     elseif currentState == state.shooting then
--         anim = anim .. anims.swingAction

--         if not golf:isPlayingAnim(anim) then
--             golf:playAnim(anim)
--         end
--     end

-- end

-- function golf:handleShot()
--     local b = buttons.shooting

--     -- Manage clubs
--     if IsControlJustPressed(1, b[2].id) then
--         golf:nextClub()
--     end

--     if IsControlJustPressed(1, b[3].id) then
--         golf:previousClub()
--     end

--     -- Manage swing
--     if IsControlPressed(1, b[4].id) then
--         if charge <= 0 then
--             currentState = state.charging
--         end
--     else
--         if currentState == state.charging then
--             currentState = state.shooting
--         elseif currentState == state.shooting then
--             currentState = state.nothing
--         end
--     end

-- end

-- -- HOLE FUNCTIONS

-- -- Launch the next hole.
-- function golf:nextHole()
--     holeIndex = (holeIndex + 1)
--     if holeIndex > #holes then holeIndex = 1 end
--     currentHole = holes[holeIndex]
-- end

-- -- Get the hole informations
-- function golf:holeInfo()
--     return holeIndex, currentHole.par, currentHole.distance, currentHole.shots
-- end

-- -- CLUB FUNCTIONS

-- -- Create the club object.
-- function golf:createClub()
--     if clubObject ~= nil and DoesEntityExist(clubObject) then
--         DeleteObject(clubObject)
--     end

--     clubObject = CreateObject(currentClub.prop, localPlayer:Pos(), 1, 1, 0)
--     AttachEntityToEntity(clubObject, localPlayer:Ped(), localPlayer:BoneIndex(28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
-- end

-- -- Loop to the next club.
-- function golf:nextClub()
--     clubIndex = (clubIndex + 1)
--     if clubIndex > #clubs then clubIndex = 1 end
--     currentClub = clubs[clubIndex]

--     golf:createClub()
--     golf:placePed()
-- end

-- -- Loop to the previoujs club.
-- function golf:previousClub()
--     clubIndex = (clubIndex - 1)
--     if clubIndex < 1 then clubIndex = #clubs end
--     currentClub = clubs[clubIndex]
    
--     golf:createClub()
--     golf:placePed()
-- end

-- -- BALL'N'TEE FUNCTIONS

-- -- Get the informations of the surface the ball is on.
-- function golf:ballSurface()
--     local bm = GetLastMaterialHitByEntity(ballObject)
--     local bs = surfaces[bm]

--     if bs == nil then
--         if currentHole.shots == 0 then
--             bs = surfaces['tee']
--         else
--             bs = surfaces['invalid']
--         end
--     end

--     return bs
-- end

-- function golf:powerInfo()
--     return currentPowerType
-- end
