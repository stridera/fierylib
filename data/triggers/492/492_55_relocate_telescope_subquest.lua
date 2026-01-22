-- Trigger: relocate_telescope_subquest
-- Zone: 492, ID: 55
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #49255

-- Converted from DG Script #49255: relocate_telescope_subquest
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor:get_quest_stage("relocate_spell_quest") == 3 then
    actor:set_quest_var("relocate_spell_quest", "greet", 1)
    actor:send("The observer tells you, 'You were sent here for my crystal instrument.  I'll be")
    actor:send("</>more then happy to give it to you, but...'")
    self.room:send_except(actor, "The observer tells something to " .. tostring(actor.name) .. ".")
    wait(5)
    actor:send("The observer tells you, 'I cannot just give it away for free.'")
    self.room:send_except(actor, "The observer tells something to " .. tostring(actor.name) .. ".")
    wait(10)
    actor:send("The observer tells you, 'I have heard of a powerful artifact that I would")
    actor:send("</>greatly value...  For research purposes, of course.'")
    self.room:send_except(actor, "The observer tells something to " .. tostring(actor.name) .. ".")
    self:command("wink " .. tostring(actor.name))
    wait(2)
    actor:send("The observer tells you, 'I hear tell of a glass globe in the Valley of the")
    actor:send("</>Frost Elves that has the power to alter time!  Bring it to me and I will let")
    actor:send("</>you have my telescope.'")
elseif actor:get_quest_stage("relocate_spell_quest") == 4 then
    actor:send("The observer tells you, 'Do you have the globe?!  Please give it to me!'")
    self.room:send_except(actor, "The observer tells something to " .. tostring(actor.name) .. ".")
    self:command("bounce")
end