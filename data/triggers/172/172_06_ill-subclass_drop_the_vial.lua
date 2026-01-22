-- Trigger: Ill-subclass: Drop the vial
-- Zone: 172, ID: 6
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #17206

-- Converted from DG Script #17206: Ill-subclass: Drop the vial
-- Original: OBJECT trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = true
wait(1)
if actor.room > 36314 and actor.room < 36340 and actor:get_quest_stage("illusionist_subclass") == 1 then
    self.room:send("The vial breaks easily, and the small gray puff of gas quickly disperses.")
    self.room:send("As the moments pass, you sense a magical tension building.")
    self.room:send("It spreads outward as its strength grows.")
    actor.name:advance_quest("illusionist_subclass")
    -- Now check for smugglers...
    local room = get.room[self.room]
    local person = room.people
    local smuggler_found = 0
    local chief_found = 0
    local leader_found = 0
    while person do
        if person:has_effect(Effect.Blind) or string.find(person.stance, "mortally") or string.find(person.stance, "incapacitated") or string.find(person.stance, "stunned") or string.find(person.stance, "sleeping") then
            local dummy = 0
        elseif person.id == 36300 or person.id == 36303 or person.id == 36304% then
            local smuggler_found = 1
        elseif person.id == 36306 then
            local chief_found = 1
            local smuggler_found = 1
        elseif person.id == 36301 then
            local leader_found = 1
            local smuggler_found = 1
        end
        local person = person.next_in_room
    end
    if leader_found == 1 then
        wait(1)
        self.room:find_actor("gannigan"):command("gasp")
        self.room:find_actor("gannigan"):say("Cestia... what on earth are you doing?")
    elseif chief_found == 1 then
        wait(1)
        self.room:find_actor("chief"):say("Hrnn?  Irksome wench!  Gannigan shall hear of this!")
    elseif smuggler_found == 1 then
        wait(1)
        self.room:find_actor("smuggler"):emote("looks somewhat confused, but also suspicious.")
        self.room:find_actor("smuggler"):say("Hey... ummm...  I'd better let the big guy know you're up to something...  No offense ma'am, but that didn't look too innocent.")
    end
    if smuggler_found == 1 then
        actor.name:advance_quest("illusionist_subclass")
    end
else
    self.room:send("The vial breaks easily, and a small gray puff of gas quickly disperses.")
    self.room:send("A sense of magic is felt, but it quickly fades.")
    self.room:send("It appears as though something has gone wrong.")
end
world.destroy(self)
return _return_value