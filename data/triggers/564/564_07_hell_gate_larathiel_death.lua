-- Trigger: hell_gate_larathiel_death
-- Zone: 564, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #56407
--
-- Final stage of the hell-gate quest: when the defiled angel Larathiel
-- dies, every group member present in the room on stage 5 advances to
-- stage 6, then we kick off the gate-opening sequence in 564, 8.

self.room:send("With an anguished cry, Larathiel dies screaming in agony!")

local size = actor.group_size or 0
if size > 0 then
    for _, member in ipairs(actor.group_member) do
        if member and member.room == self.room and member:get_quest_stage("hell_gate") == 5 then
            member:advance_quest("hell_gate")
        end
    end
elseif actor:get_quest_stage("hell_gate") == 5 then
    actor:advance_quest("hell_gate")
end

run_room_trigger(564, 8)
return true
