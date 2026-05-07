-- Trigger: quest_eleweiss_ranger_druid_subclass_speak2
-- Zone: 163, ID: 3
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #16303
--
-- Yes/no follow-up to speak1's offer. If yes and the actor is class- and
-- level-eligible, starts the ran_dru_subclass quest (variant from
-- globals.use_subclass set by speak1). If no, banishes them back to room 74.

if not (string.find(speech, "yes") or string.find(speech, "no")) then
    return true
end

if actor:get_quest_stage("ran_dru_subclass") ~= 0 then
    return true
end

-- TODO(parity): legacy DG had a race switch ("ADD NEW RESTRICTED RACES HERE")
-- that halted on disallowed races before each class branch.

local classquest = nil
if string.find(actor.class, "Cleric") then
    if actor.level >= 10 and actor.level <= 35 then
        classquest = "yes"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
elseif string.find(actor.class, "Warrior") then
    if actor.level >= 10 and actor.level <= 25 then
        classquest = "yes"
    elseif actor.level < 10 then
        actor:send(tostring(self.name) .. " says, 'I cannot guide you yet.  Return to me when you have more experience.'")
    else
        actor:send(tostring(self.name) .. " says, 'You have traveled too far on your current path to change your way.'")
    end
end

wait(2)
if classquest == "yes" then
    if string.find(speech, "yes") then
        if not globals.use_subclass then
            actor:send(tostring(self.name) .. " says, 'I cannot help until we talk about the ways of the woods.'")
            return true
        end
        actor:start_quest("ran_dru_subclass", globals.use_subclass)
        actor:send(tostring(self.name) .. " says, 'Only the most dedicated to the forests shall complete the <b:cyan>quest</> I set upon you.  You may inquire about your <b:cyan>[subclass progress]</> or ask me to <b:cyan>[repeat]</> myself at any time.'")
    else
        actor:send(tostring(self.name) .. " says, 'Leave my sight, you tire me.'")
        self:command("wave " .. tostring(actor.name))
        actor:send("Eleweiss calls upon the air and moves you away.")
        self.room:send_except(actor, "Eleweiss removes " .. tostring(actor.name) .. " from his presence.")
        actor:teleport(get_room(163, 74))
    end
    globals.use_subclass = nil
end
