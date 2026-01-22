-- Trigger: pat_chinok
-- Zone: 31, ID: 25
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #3125

-- Converted from DG Script #3125: pat_chinok
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pat
if not (cmd == "pat") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "p" or cmd == "pa" then
    _return_value = false
    return _return_value
end
local test1 = (arg  ~=  doll)  and  (arg  ~=  chinok)  and  (arg  ~=  chinok-doll)  and  (arg  ~=  chinok-rag)  and  (arg  ~=  rag -doll)  and  (arg  ~=  rag)  and  (arg  ~=  chinok-rag-doll)
local test2 = (arg  ~=  little)  and  (arg  ~=  hooded)  and  (arg  ~=  figure)  and  (arg  ~=  little-hooded)  and  (arg  ~=  hooded -figure)  and  (arg  ~=  little-hooded-figure)
if test1 and test2 then
    _return_value = false
    return _return_value
end
_return_value = true
self.room:send_except(actor, tostring(actor.name) .. " pats a Chinok rag doll on its head.")
actor:send("You pat a Chinok rag doll on its head.")
self.room:send("The Chinok rag doll swings its lightsabers dangerously, narrowly missing you!")
return _return_value