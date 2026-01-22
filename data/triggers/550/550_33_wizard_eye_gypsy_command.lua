-- Trigger: wizard_eye_gypsy_command
-- Zone: 550, ID: 33
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #55033

-- Converted from DG Script #55033: wizard_eye_gypsy_command
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: show
if not (cmd == "show") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("wizard_eye") == 1 and (string.find(arg, "palm") or string.find(arg, "hand")) then
    actor:send("You show your palm to " .. tostring(self.name) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " looks at your palm for a long moment.")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Hmmmmm...'")
    wait(2)
    actor:damage(5)  -- type: physical
    actor:send(tostring(self.name) .. " suddenly stabs your hand with a knife! <red>(" .. tostring(damage_dealt) .. ")</>")
    self.room:send_except(actor, tostring(self.name) .. " suddenly stabs " .. tostring(actor.name) .. "'s hand with a knife!  <red>(" .. tostring(damage_dealt) .. ")</>")
    actor:send(tostring(self.name) .. " watches the blood drip from your hand.")
    self.room:send_except(actor, tostring(self.name) .. " watches the blood drip from " .. tostring(actor.name) .. "'s hand.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Ah, I see.  All you need is a simple <b:yellow>marigold poultice</>.  It's popular with the healers out on the beachhead.  I'm sure you can \"procure\" some from one of them.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'When the time comes, smear it on both your face and the crystal ball.  I'll send a note ahead to the Master Shaman.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Good luck!  Come back and see me sometime!'")
    self:command("wave")
    actor.name:advance_quest("wizard_eye")
else
    _return_value = false
end
return _return_value