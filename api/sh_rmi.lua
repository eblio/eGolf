-- @desc Synchronous remote method invocation.
-- @author Elio
-- @version 1.0

local IS_SERVER = IsDuplicityVersion()
local EVENT_PREFIX = GetCurrentResourceName() .. '-rmi:'
local DEBUG = false

local tse = TriggerServerEvent
local tce = TriggerClientEvent
local event = AddEventHandler

local function netEvent(name, func)
    RegisterNetEvent(name)
    AddEventHandler(name, func)
end

local function log(name, text)
    if DEBUG then
        Citizen.Trace('^1' .. name .. ': ^0' .. text .. '\n')
    end
end

if IS_SERVER then
    local function registerMethod(remoteObject, key, func)
        local eventName = remoteObject.prefix .. key .. ':'

        if type(func) == 'function' then   
            log('rmi-info', 'Registered a new method: "' .. eventName .. '".')

            remoteObject.functions[key] = true

            netEvent(eventName .. 'request', function(...)
                tce(eventName .. 'send', source, func(source, ...))
            end)
        else
            log('rmi-error', 'You tried to register something that isn\'t a method: "' .. eventName .. '".')
        end
    end

    -- @desc Create a new remote object that can be loaded by a client.
    -- @param name name of the object
    -- @return the remote object
    function CreateRemoteObject(name)
        local remoteObject = {}
        remoteObject.prefix = EVENT_PREFIX .. name .. ':'
        remoteObject.functions = {}

        setmetatable(remoteObject, { __newindex = registerMethod })

        netEvent(remoteObject.prefix .. 'get', function()
            tce(remoteObject.prefix .. 'set', source, remoteObject.functions)
        end)

        return remoteObject
    end
else
    local function registerMethods(remoteObject, functions)
        remoteObject.handlers = {}
        for key, _ in pairs(functions) do
            local eventName = remoteObject.prefix .. key .. ':'
            
            netEvent(eventName .. 'send', function(...) -- Register the event one time
                remoteObject.handlers[key](...)
            end)

            remoteObject[key] = function(...)
                local p = promise.new()

                log('rmi-info', 'New method called : "' .. eventName .. '".')
                tse(eventName .. 'request', ...)

                remoteObject.handlers[key] = function(args)
                    p:resolve(args)
                end

                return Citizen.Await(p)
            end
        end
    end

    -- @desc Get a remote object created by the server.
    -- @param name name of the object
    -- @return the remote object
    function LoadRemoteObject(name)
        local p = promise.new()
        local remoteObject = {}
        remoteObject.prefix = EVENT_PREFIX .. name .. ':'

        tse(remoteObject.prefix .. 'get')

        netEvent(remoteObject.prefix .. 'set', function(functions)
            registerMethods(remoteObject, functions)
            p:resolve(remoteObject)
        end)

        return Citizen.Await(p)
    end
end
