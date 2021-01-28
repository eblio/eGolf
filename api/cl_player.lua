-- @desc Manage local player efficiently
-- @author: Elio
-- @version: 2.0

LocalPlayer = {}
LocalPlayer.__index = LocalPlayer

setmetatable(LocalPlayer, {
    __call = function(cls, ...)
        return cls:New(...)
    end
})

function LocalPlayer:New(updateTime)
    self = setmetatable({}, self) -- self is not local so that this class is static

    local time = GetGameTimer()

    self.updateTime = updateTime
    self.updateTimePed = updateTime * 3
    self.timePed = time
    self.timePos = time
    self.timeHeading = time
    self.timeInVeh = time
    self.timeVeh = time

    self.id = PlayerId()
    self.serverId = GetPlayerServerId(self.id)
    self.ped = PlayerPedId()
    self.pos = GetEntityCoords(self.ped)
    self.heading = GetEntityHeading(self.ped)
    self.inVeh = IsPedInAnyVehicle(self.ped, true)

    self.veh = 0
    if self.inVeh then
        self.veh = GetVehiclePedIsIn(self.ped, false)
    end

    return self
end

function LocalPlayer:CheckCache(time, updateTime)
    local currentTime = GetGameTimer()
    local updateNeeded = currentTime - time > updateTime
    return updateNeeded, currentTime
end

function LocalPlayer:Id()
    return self.id
end

function LocalPlayer:ServerId()
    return self.serverId
end

function LocalPlayer:Ped()
    local handle, time = self:CheckCache(self.timePed, self.updateTimePed)
    
    if handle then
        self.ped = PlayerPedId()
        self.timePed = time
    end

    return self.ped
end

function LocalPlayer:Pos()
    local handle, time = self:CheckCache(self.timePos, self.updateTime)

    if handle then
        self.pos = GetEntityCoords(self:Ped())
        self.timePos = time
    end

    return self.pos
end

function LocalPlayer:Heading()
    local handle, time = self:CheckCache(self.timeHeading, self.updateTime)

    if handle then
        self.heading = GetEntityHeading(self:Ped())
        self.timeHeading = time
    end

    return self.heading
end

function LocalPlayer:InVeh()
    local handle, time = self:CheckCache(self.timeInVeh, self.updateTime)

    if handle then
        self.inVeh = IsPedInAnyVehicle(self:Ped())
        self.timeInVeh = time
    end

    return self.inVeh
end

function LocalPlayer:Veh()
    local handle, time = self:CheckCache(self.timeVeh, self.updateTime)

    if handle then
        self.veh = GetVehiclePedIsIn(self:Ped())
        self.timeVeh = time
    end

    return self.veh
end
    
function LocalPlayer:BoneIndex(bone)
    return GetPedBoneIndex(localPlayer:Ped(), bone)
end

-- Global creation
local localPlayer = LocalPlayer(300)

function GetLocalPlayer()
    return localPlayer
end
