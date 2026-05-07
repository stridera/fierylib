-- Trigger: pyromancer_subclass_quest_emmath_speech2
-- Zone: 52, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5204
--
-- Yes/no follow-up to the recruitment offer in trigger #5203. "Yes" starts
-- the pyromancer_subclass quest; "no" boots the actor back to room 51:91.

if not percent_chance(1) then
    return true
end

local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "no")) then
    return true
end

if not actor:get_quest_stage("pyromancer_subclass") and string.find(actor.class, "Sorcerer") then
    if string.find(speech_lower, "yes") then
        if actor.level >= 10 and actor.level <= 45 then
            if actor.race == "dragonborn_frost" or actor.race == "arborean" then
                actor:send("<red>Your race may not subclass to Pyromancer.</>")
                return true
            else
                wait(2)
                actor:start_quest("pyromancer_subclass", "Pyr")
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Only the best and most motivated of mages will complete the <b:red>quest</> I lay before you.'")
                self:command("smile")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'However, I am sure it is in you, if it is truly your desire, to complete this quest and become a pyromancer.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You may ask about your quest <b:red>[subclass progress]</> at any time.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Don't ask me to repeat myself though.'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'I hate that.'")
            end
        elseif actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back to me once you've gained more experience.'")
        elseif actor.level > 45 then
            actor:send(tostring(self.name) .. " says, 'Unfortunately you are too dedicated to your universalist ways for me to teach you now.'")
        end
    else
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Very well, then begone from here.  I suppose you do not have it in you to be a mage of fire anyway.'")
        actor:send("Emmath places his fiery palm in the air, making the room glow brightly.")
        self.room:send_except(actor, "Emmath raises his palm into the air, making the room very bright.")
        actor:send("The air around you wavers.")
        self.room:send_except(actor, tostring(actor.name) .. " suddenly disappears at Emmath's command.")
        actor:teleport(get_room(51, 91))
        actor:command("look")
    end
end