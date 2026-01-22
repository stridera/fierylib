-- Trigger: supernova_clue_rooms
-- Zone: 62, ID: 7
-- Type: WORLD, Flags: POSTENTRY
-- Status: CLEAN
--
-- Original DG Script: #6207

-- Converted from DG Script #6207: supernova_clue_rooms
-- Original: WORLD trigger, flags: POSTENTRY, probability: 100%
local person = self.people
local stage = person:get_quest_stage("supernova")
while person do
    if (stage < 6) and (person.room == person.quest_variable[supernova:stepstage]) and (person:has_item("48917") or person:has_equipped("48917")) then
        if stage == 3 then
            self.room:spawn_object(62, 29)
        elseif stage == 4 then
            self.room:spawn_object(62, 32)
        elseif stage == 5 then
            self.room:spawn_object(62, 33)
        end
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(actor, tostring(actor.name) .. " has found a clue to Phayla's whereabouts!")
        actor:send("You have found a clue to Phayla's whereabouts!")
        person.name:advance_quest("supernova")
    elseif (stage == 6) and (person.room == person:get_quest_var("supernova:step6")) and (person:has_item("48917") or person:has_equipped("48917")) then
        self.room:spawn_object(62, 30)
        self.room:send("<magenta>Eerie purple light from " .. tostring(objects.template(489, 17).name) .. " reveals a gateway to another dimension!</>")
        person.name:advance_quest("supernova")
    end
    local person = person.next_in_room
end