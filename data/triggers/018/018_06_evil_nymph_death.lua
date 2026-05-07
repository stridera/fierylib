-- Trigger: evil_nymph_death
-- Zone: 18, ID: 6
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1806

-- Converted from DG Script #1806: evil_nymph_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): debug "running" send is a leftover from DG; remove once verified.
-- TODO(parity): legacy group iteration uses DG-specific group_member[i]/next_in_room
-- semantics that may not match the Rust runtime. Validate that actor.group_size and
-- actor.group_member[a] resolve correctly, otherwise rewrite using a proper group
-- iterator (e.g. for _, p in ipairs(actor:group()) do ...).
if self.room.zone_id == 18 and self.room.local_id == 2 and world.count_mobiles(18, 13) > 0 then
    self.room:send("As the nymph dies, the shade of Thelmor dissipates in peace.")
    world.destroy(self.room:find_actor("shade"))
end
local person = actor
local i = person.group_size
if i then
    local a = 1
    while i > a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person.class == "Ranger" and person.level > 80 and not person:get_quest_stage("blur") then
                person:start_quest("blur")
                person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
elseif person.class == "Ranger" and person.level > 80 and not person:get_quest_stage("blur") then
    person:start_quest("blur")
    person:send("A voice from the forest whispers, 'You have done the forest a great service.  Meet me at the nearby spring.'")
end