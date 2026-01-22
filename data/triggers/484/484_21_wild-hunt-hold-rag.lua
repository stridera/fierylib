-- Trigger: wild-hunt-hold-rag
-- Zone: 484, ID: 21
-- Type: MOB, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48421

-- Converted from DG Script #48421: wild-hunt-hold-rag
-- Original: MOB trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: hold
if not (cmd == "hold") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- Like trigger 48418, only when they are not already holding the rag.
if actor:get_quest_stage("doom_entrance") == 1 then
    actor:command("hold ragtoscarewhitetaileddeer")
    wait(1)
    if self.id == 55214 then
        self.room:send("The deer flees wildly at the sight of the blood-soaked rag!")
        self:command("flee")
    elseif self.id == 55244 then
        self.room:send("The deer boldly stands its ground, nostrils flaring at the scent of blood.")
    end
else
    _return_value = false
end
return _return_value