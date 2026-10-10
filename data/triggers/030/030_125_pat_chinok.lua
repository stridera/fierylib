-- Trigger: pat_chinok
-- Zone: 30, ID: 125
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3125

-- Converted from DG Script #3125: pat_chinok
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pat
if not (cmd == "pat") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
-- switch on cmd
if cmd == "p" or cmd == "pa" then
    _return_value = true
    return _return_value
end
local test1 = (arg ~= "doll") and (arg ~= "chinok") and (arg ~= "chinok-doll") and (arg ~= "chinok-rag") and (arg ~= "rag-doll") and (arg ~= "rag") and (arg ~= "chinok-rag-doll")
local test2 = (arg ~= "little") and (arg ~= "hooded") and (arg ~= "figure") and (arg ~= "little-hooded") and (arg ~= "hooded-figure") and (arg ~= "little-hooded-figure")
if test1 and test2 then
    _return_value = true
    return _return_value
end
_return_value = false
self.room:send_except(actor, tostring(actor.name) .. " pats a Chinok rag doll on its head.")
actor:send("You pat a Chinok rag doll on its head.")
self.room:send("The Chinok rag doll swings its lightsabers dangerously, narrowly missing you!")
return _return_value