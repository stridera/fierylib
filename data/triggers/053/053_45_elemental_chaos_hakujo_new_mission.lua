-- Trigger: Elemental Chaos Hakujo new mission
-- Zone: 53, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `local mission = N` branch-scoped. The dead 0% gate is
-- gone (DG #5345 filters on the phrase only). Full rewrite from DG
-- #5345.
--
-- Original DG Script: #5345

-- Converted from DG Script #5345: Elemental Chaos Hakujo new mission
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new note (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new note", 1, true) then
    return true  -- Not the phrase
end
wait(0.2)
if actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if (actor:get_quest_var("elemental_chaos:bounty") or 0) ~= 0 then
        -- switch on actor:get_quest_stage("elemental_chaos")
        local mission
        if actor:get_quest_stage("elemental_chaos") == 1 then
            mission = 20
        elseif actor:get_quest_stage("elemental_chaos") == 2 then
            mission = 21
        elseif actor:get_quest_stage("elemental_chaos") == 3 then
            mission = 22
        elseif actor:get_quest_stage("elemental_chaos") == 4 then
            mission = 23
        elseif actor:get_quest_stage("elemental_chaos") == 5 then
            mission = 24
        elseif actor:get_quest_stage("elemental_chaos") == 6 then
            mission = 25
        elseif actor:get_quest_stage("elemental_chaos") == 7 then
            mission = 26
        elseif actor:get_quest_stage("elemental_chaos") == 8 then
            mission = 27
        elseif actor:get_quest_stage("elemental_chaos") == 9 then
            mission = 28
        elseif actor:get_quest_stage("elemental_chaos") == 10 then
            mission = 29
        end
        self:command("grumble")
        self.room:spawn_object(53, mission)
        self:command("give mission " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end