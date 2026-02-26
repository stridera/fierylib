-- Trigger: Elemental Chaos Hakujo new mission
-- Zone: 53, ID: 45
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5345

-- Converted from DG Script #5345: Elemental Chaos Hakujo new mission
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new note
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "note")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
    if actor:get_quest_var("elemental_chaos:bounty") then
        -- switch on actor:get_quest_stage("elemental_chaos")
        if actor:get_quest_stage("elemental_chaos") == 1 then
            local mission = 5320
        elseif actor:get_quest_stage("elemental_chaos") == 2 then
            local mission = 5321
        elseif actor:get_quest_stage("elemental_chaos") == 3 then
            local mission = 5322
        elseif actor:get_quest_stage("elemental_chaos") == 4 then
            local mission = 5323
        elseif actor:get_quest_stage("elemental_chaos") == 5 then
            local mission = 5324
        elseif actor:get_quest_stage("elemental_chaos") == 6 then
            local mission = 5325
        elseif actor:get_quest_stage("elemental_chaos") == 7 then
            local mission = 5326
        elseif actor:get_quest_stage("elemental_chaos") == 8 then
            local mission = 5327
        elseif actor:get_quest_stage("elemental_chaos") == 9 then
            local mission = 5328
        elseif actor:get_quest_stage("elemental_chaos") == 10 then
            local mission = 5329
        end
        self:command("grumble")
        self.room:spawn_object(vnum_to_zone(mission), vnum_to_local(mission))
        self:command("give mission " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end