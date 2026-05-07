-- Trigger: Spectre death
-- Zone: 502, ID: 7
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #50207

-- Converted from DG Script #50207: Spectre death
-- Original: MOB trigger, flags: DEATH, probability: 100%
--
-- TODO: actor.group_size / actor.group_member[] are DG-Script idioms with
-- no Rust runtime bindings; the loop below is dead code (locals scoped to
-- if/else blocks make `a` nil in the while condition). Replace with a
-- real party iteration once group bindings are exposed. Intent: complete
-- the "bayou_quest" for every grouped player in the room when the spectre
-- dies.
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("bayou_quest") and not person:get_has_completed("bayou_quest") then
            person:complete_quest("bayou_quest")
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end