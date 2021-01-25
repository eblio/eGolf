-- @desc Utils functions
-- @author Elio
-- @version 1.0

-- @desc trigger aliases
te = TriggerEvent
tse = TriggerServerEvent
tce = TriggerClientEvent

-- @desc Handle net event
-- @param name name of the event
-- @param func the function attached to the event
function netEvent(name, func)
	RegisterNetEvent(name)
	AddEventHandler(name, func)
end

-- @desc Handle event
-- @param name name of the event
-- @param func the function attached to the event
function event(name, func)
	AddEventHandler(name, func)
end

-- @desc Get an objet real type (float included)
-- @param o object
function rtype(o)
    local t = type(o)

    if t == 'number' then
        local s = tostring(o)
        local float = s:find('%.')
        if float then t = 'float' else t = 'int' end
    end

    return t
end
