-- Trigger: Ill-subclass: Grand Master restarts
-- Zone: 172, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17204

-- Converted from DG Script #17204: Ill-subclass: Grand Master restarts
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: restart
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "restart")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Sorcerer") and actor.level > 9 and actor.level < 46 then
    if actor:get_quest_stage("illusionist_subclass") > 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Very well, if you insist.'")
        actor.name:restart_quest("illusionist_subclass")
        wait(1)
        self:emote("rummages about in his things.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Here is another vial.'")
        wait(1)
        self.room:spawn_object(172, 15)
        self:command("give vial " .. tostring(actor.name))
        self:destroy_item("vial")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'And don't muck it up this time!'")
    end
end