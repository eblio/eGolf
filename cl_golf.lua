local localPlayer = LocalPlayer(300)

golf = {} -- *Static class*

local math = math -- localization

local blip = nil

local clubIndex = 1
local currentClub = clubs[clubIndex]
local clubObject = nil

local holeIndex = 1
local currentHole = holes[holeIndex]

local powerTypeIndex = 1
local currentPowerType = powerTypes[powerTypeIndex]

local ballObject = nil

local currentState = state.idle
local charge = 0

-- SETUP FUNCTIONS

-- Load everything necessary to play golf.
function golf:runSetup()
    RequestAdditionalText('SP_GOLF', 3)
    RequestStreamedTextureDict('GolfPutting', false)
    RequestAnimDict('mini@golfai')
    RequestNamedPtfxAsset('scr_minigamegolf')

    RequestModel(ballHash)
    RequestModel(teeHash)
    for i = 1, #clubs do
        RequestModel(clubs[i].prop)
    end

    gfx:init()

    RequestIpl('GolfFlags')
end

-- Un-load everything.
function golf:clearSetup()
    ClearAdditionalText(3, 1)
    SetStreamedTextureDictAsNoLongerNeeded('GolfPutting')
    RemoveAnimDict('mini@golfai')
    RemoveNamedPtfxAsset('scr_minigamegolf')

    SetModelAsNoLongerNeeded(ballHash)
    SetModelAsNoLongerNeeded(teeHash)
    for i = 1, #clubs do
        SetModelAsNoLongerNeeded(clubs[i].prop)
    end

    gfx:clear()

    RemoveIpl('GolfFlags')
end

-- PED FUNCTIONS

function golf:disableControls()
    DisableControlAction(0, 142, 1);
    DisableControlAction(0, 143, 1);
    DisableControlAction(0, 79, 1);
    DisableControlAction(0, 287, 1);
    DisableControlAction(0, 286, 1);
    DisableControlAction(0, 44, 1);
    DisableControlAction(0, 37, 1);
    DisableControlAction(0, 66, 1);
    DisableControlAction(0, 67, 1);
    DisableControlAction(0, 68, 1);
    DisableControlAction(0, 69, 1);
    DisableControlAction(0, 70, 1);
    DisableControlAction(0, 99, 1);
    DisableControlAction(0, 100, 1);
end

-- Place the ped according to the ball posisiton.
function golf:placePed()
    AttachEntityToEntity(localPlayer:Ped(), ballObject, 20, currentClub.pos, 0.0, 0.0, 0.0, false, false, false, false, 1, true)
end

function golf:playAnim(anim)
    TaskPlayAnim(localPlayer:Ped(), 'mini@golfai', anim, 1.0, -1.0, -1, 0, 0.0, false, false, false)
    -- TaskPlayAnim(ped, animDictionary, animationName, blendInSpeed, blendOutSpeed, duration, flag, playbackRate, lockX, lockY, lockZ)
end

function golf:isPlayingAnim(anim)
    return IsEntityPlayingAnim(localPlayer:Ped(), 'mini@golfai', anim, 3)
end

function golf:animTime(anim)
    return GetEntityAnimCurrentTime(localPlayer:Ped(), 'mini@golfai', anim)
end

-- Play the animation accordingly to the current club.
function golf:handleAnim()
    local anim = currentClub.anim.prefix

    if currentState == state.idle then
        anim = anim .. anims.idle .. '_a'

        if not golf:isPlayingAnim(anim) then
            golf:playAnim(anim)
        end
    elseif currentState == state.charging then
        anim = anim .. anims.swingIntro

        if not golf:isPlayingAnim(anim) then
            golf:playAnim(anim)
        else
            charge = golf:animTime(anim)
        end
    elseif currentState == state.shooting then
        anim = anim .. anims.swingAction

        if not golf:isPlayingAnim(anim) then
            golf:playAnim(anim)
        end
    end

end

function golf:handleShot()
    local b = buttons.shooting

    -- Manage clubs
    if IsControlJustPressed(1, b[2].id) then
        golf:nextClub()
    end

    if IsControlJustPressed(1, b[3].id) then
        golf:previousClub()
    end

    -- Manage swing
    if IsControlPressed(1, b[4].id) then
        if charge <= 0 then
            currentState = state.charging
        end
    else
        if currentState == state.charging then
            currentState = state.shooting
        elseif currentState == state.shooting then
            currentState = state.nothing
        end
    end

end

-- HOLE FUNCTIONS

-- Launch the next hole.
function golf:nextHole()
    holeIndex = (holeIndex + 1)
    if holeIndex > #holes then holeIndex = 1 end
    currentHole = holes[holeIndex]
end

-- Get the hole informations
function golf:holeInfo()
    return holeIndex, currentHole.par, currentHole.distance, currentHole.shots
end

-- CLUB FUNCTIONS

-- Delete the club object.
function golf:deleteClub()
    if clubObject ~= nil and DoesEntityExist(clubObject) then
        DeleteObject(clubObject)
    end
end

-- Create the club object.
function golf:createClub()
    if clubObject ~= nil and DoesEntityExist(clubObject) then
        DeleteObject(clubObject)
    end

    clubObject = CreateObject(currentClub.prop, localPlayer:Pos(), 1, 1, 0)
    AttachEntityToEntity(clubObject, localPlayer:Ped(), localPlayer:BoneIndex(28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
end

-- Loop to the next club.
function golf:nextClub()
    clubIndex = (clubIndex + 1)
    if clubIndex > #clubs then clubIndex = 1 end
    currentClub = clubs[clubIndex]

    golf:createClub()
    golf:placePed()
end

-- Loop to the previoujs club.
function golf:previousClub()
    clubIndex = (clubIndex - 1)
    if clubIndex < 1 then clubIndex = #clubs end
    currentClub = clubs[clubIndex]
    
    golf:createClub()
    golf:placePed()
end

-- BALL'N'TEE FUNCTIONS

-- Delete the ball.
function golf:deleteBall()
    if ballObject ~= nil and DoesEntityExist(ballObject) then
        DeleteObject(ballObject)
    end
end

-- Create the ball and the tee.
function golf:createBall()
    if ballObject ~= nil and DoesEntityExist(ballObject) then
        DeleteObject(ballObject)
    end

    local teeObject = CreateObject(teeHash, currentHole.teeCoords, 1, 1, 0)
    ballObject = CreateObject(ballHash, currentHole.teeCoords + vector3(0.0, 0.0, 0.05), 1, 1, 0)
end

-- Get the informations of the surface the ball is on.
function golf:ballSurface()
    local bm = GetLastMaterialHitByEntity(ballObject)
    local bs = surfaces[bm]

    if bs == nil then
        if currentHole.shots == 0 then
            bs = surfaces['tee']
        else
            bs = surfaces['invalid']
        end
    end

    return bs
end

-- OTHER INFORMATIONS FUNCTIONS

-- Get the informations regarding the wind.
function golf:windInfo()
    local wd = GetWindDirection()
    local mag = Vmag(wd) * GetWindSpeed()

    wd = GetHeadingFromVector_2d(wd.x, wd.y) + GetGameplayCamRelativeHeading() + localPlayer:Heading()

    return wd, math.ceil(mag)
end

function golf:powerInfo()
    return currentPowerType
end
