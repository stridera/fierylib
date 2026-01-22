-- Trigger: mage_greet
-- Zone: 238, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #23810

-- Converted from DG Script #23810: mage_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.quest_stage[type_wand] == "wandstep" then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor.quest_variable["type_wand:greet"] == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the " .. tostring(weapon) .. "?")
        end
    end
end
-- Only greet people wearing the Sunfire crest
if actor:has_equipped("23716") then
    wait(2)
    self:command("blink")
    wait(2)
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Far be it from me to ask how you got that crest...  But it appears you have done a service for one of my kin.")
    wait(2)
    self:say("Perhaps you can help me also in solving a riddle.")
end