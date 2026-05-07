-- Trigger: Ziijhan forgets someone
-- Zone: 85, ID: 8
-- Type: MOB, Flags: RANDOM
--
-- If a quest was started (globals.start_q) but the original player has
-- left Ziijhan's room, he muses about their absence and clears the flag.
--
-- Original DG Script: #8508

-- Converted from DG Script #8508: Ziijhan forgets someone
-- Original: MOB trigger, flags: RANDOM, probability: 100%
if globals.start_q and globals.q_plyr then
    local questerhere = false
    for _, person in ipairs(self.room.actors) do
        if person.name == globals.q_plyr then
            questerhere = true
            break
        end
    end
    if not questerhere then
        self:say("Hmm, where did " .. tostring(globals.q_plyr) .. " go?")
        globals.start_q = nil
        globals.q_plyr = nil
    end
end