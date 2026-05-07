-- Trigger: supernova_clue_rooms
-- Zone: 62, ID: 7
-- Type: WORLD, Flags: POSTENTRY
--
-- Postentry hook attached to the various "clue" rooms in the supernova quest.
-- For every person in the room, if they:
--   * are on the supernova quest at a matching stage (3..6),
--   * are carrying or wearing one of Phayla's lamps (489, 17), AND
--   * are in the room their quest_var step{N} points to,
-- drop the corresponding clue scroll (or, at stage 6, the gateway object) and
-- advance the quest one stage.
--
-- Original DG Script: #6207

-- TODO(parity): The original DG had `supernova:stepstage` as a string-valued
-- key (i.e. literal "stepstage"); we read step3/step4/step5 explicitly here
-- since each stage uses its own step var. Verify against DG #6207 source if
-- the legacy semantics differ.

for _, person in ipairs(self.room.people) do
    local stage = person:get_quest_stage("supernova")
    if not (person:has_item(489, 17) or person:has_equipped(489, 17)) then
        -- nothing
    elseif stage == 3 and person.room == get_room(math.floor(person:get_quest_var("supernova:step3") / 100), person:get_quest_var("supernova:step3") % 100) then
        self.room:spawn_object(62, 29)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 4 and person.room == get_room(math.floor(person:get_quest_var("supernova:step4") / 100), person:get_quest_var("supernova:step4") % 100) then
        self.room:spawn_object(62, 32)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 5 and person.room == get_room(math.floor(person:get_quest_var("supernova:step5") / 100), person:get_quest_var("supernova:step5") % 100) then
        self.room:spawn_object(62, 33)
        self.room:send("<magenta>" .. tostring(objects.template(489, 17).name) .. " begins emitting an eerie purple light!</>")
        self.room:send_except(person, tostring(person.name) .. " has found a clue to Phayla's whereabouts!")
        person:send("You have found a clue to Phayla's whereabouts!")
        person:advance_quest("supernova")
    elseif stage == 6 and person.room == get_room(math.floor(person:get_quest_var("supernova:step6") / 100), person:get_quest_var("supernova:step6") % 100) then
        self.room:spawn_object(62, 30)
        self.room:send("<magenta>Eerie purple light from " .. tostring(objects.template(489, 17).name) .. " reveals a gateway to another dimension!</>")
        person:advance_quest("supernova")
    end
end