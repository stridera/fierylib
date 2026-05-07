-- Trigger: shaman_speak1
-- Zone: 178, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17801

-- Converted from DG Script #17801: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0% (always-fires gate; pattern-matched)

-- TODO(parity): DG keyword list "master let the test begin" was a phrase match;
-- converter emitted per-word OR which over-triggers (any sentence with "the" matches).
-- Treating as phrase match here for fidelity.
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "master let the test begin") then
    return true  -- No matching keywords
end
if self.is_fighting then
    self:say("Your test may begin when mine has finished!")
else
    if world.count_mobiles(178, 11) > 0 then
        self:say("I'm sorry.  I'm already helping someone else face their fears.")
        self:say("You may try when they are finished.")
    else
        self:say("It is your right to face your fears.")
        self:say("Let us hope you have the power to overcome them.")
        wait(1)
        actor:send("Everything blurs for a second as the shaman gestures.")
        actor:teleport(get_room(178, 69))
        self:emote("gestures, and " .. tostring(actor.name) .. " disappears in a blur.")
        wait(1)
        actor:send("<blue>" .. tostring(self.name) .. " tells you, 'If you need to leave, my apprentice will show you the way out.'</>")
        get_room(178, 72):at(function()
            self.room:spawn_mobile(178, 11)
        end)
        if world.count_mobiles(178, 12) == 0 then
            get_room(178, 72):at(function()
                self.room:spawn_mobile(178, 12)
            end)
        end
    end
end