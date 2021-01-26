-- @desc Manage scaleforms efficiently.
-- @author: Elio
-- @version: 2.0

Scaleform = {}
Scaleform.__index = Scaleform

setmetatable(Scaleform, {
    __call = function(cls, ...)
        return cls:New(...)
    end
})

local function ScaleformMovieMethodAddParamLabel(args)
    local label = args[1]
    local labelType = rtype(label)

    if DoesTextLabelExist(label) or labelType == 'int' then
        BeginTextCommandScaleformString(label)

        for i = 2, #args do
            local arg = args[i]
            local t = rtype(arg)

            if t == 'string' then
                if DoesTextLabelExist(arg) then
                    AddTextComponentSubstringTextLabel(arg)
                else
                    AddTextComponentSubstringKeyboardDisplay(arg)
                end
            elseif t == 'int' then
                AddTextComponentInteger(arg)
            elseif t == 'float' then
                AddTextComponentFloat(arg)
            end
        end

        EndTextCommandScaleformString()
    end
end

function Scaleform:New(id)
    local self = setmetatable({}, Scaleform)

    self.id = id
    self.handle = RequestScaleformMovie(self.id)

    return self
end

function Scaleform:Destroy()
    SetScaleformMovieAsNoLongerNeeded(self.handle)
    self = nil
end

function Scaleform:IsValid()
    return self.handle ~= 0
end

function Scaleform:IsLoaded()
    return HasScaleformMovieLoaded(self.handle)
end

function Scaleform:Wait()
    local j = 0

    if self:IsValid() then
        while not self:IsLoaded() and j < 10 do
            j = j + 1
            Wait(100)
        end
    end

    return self:IsValid() and not (j >= 10)
end

function Scaleform:CallFunction(func, args)
    BeginScaleformMovieMethod(self.handle, func)

    for i = 1, #args do
        local arg = args[i]
        local t = rtype(arg)

        if t == 'string' then
            if DoesTextLabelExist(arg) then
                ScaleformMovieMethodAddParamLabel({ arg })
            else
                ScaleformMovieMethodAddParamPlayerNameString(arg)
            end
        elseif t == 'int' then
            ScaleformMovieMethodAddParamInt(arg)
        elseif t == 'float' then
            ScaleformMovieMethodAddParamFloat(arg)
        elseif t == 'boolean' then
            ScaleformMovieMethodAddParamBool(arg)
        elseif t == 'table' then -- special format for labels
            ScaleformMovieMethodAddParamLabel(arg)
        end

    end

    EndScaleformMovieMethod()
end

function Scaleform:Render2D(r, g, b, a)
    DrawScaleformMovieFullscreen(self.handle, r or 255, g or 255, b or 255, a or 255, 0)
end

-- function Scaleform:Render2DScreenSpace()
--     -- not implemented, no idea of what it should do
-- end

function Scaleform:Render3D(pos, rot, scale)
    DrawScaleformMovie_3dNonAdditive(self.handle, pos, rot, 2.0, 2.0, 2.0, scale, 2)
end

function Scaleform:Render3DAdditive(pos, rot, scale)
    DrawScaleformMovie_3d(self.handle, pos, rot, 2.0, 2.0, 2.0, scale, 2)
end
