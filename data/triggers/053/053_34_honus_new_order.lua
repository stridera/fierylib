-- Trigger: Honus new order
-- Zone: 53, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5334

-- Converted from DG Script #5334: Honus new order
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new order
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "order")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
    if actor:get_quest_var("treasure_hunter:hunt") then
        -- switch on actor:get_quest_stage("treasure_hunter")
        if actor:get_quest_stage("treasure_hunter") == 1 then
            local order = 5310
        elseif actor:get_quest_stage("treasure_hunter") == 2 then
            local order = 5311
        elseif actor:get_quest_stage("treasure_hunter") == 3 then
            local order = 5312
        elseif actor:get_quest_stage("treasure_hunter") == 4 then
            local order = 5313
        elseif actor:get_quest_stage("treasure_hunter") == 5 then
            local order = 5314
        elseif actor:get_quest_stage("treasure_hunter") == 6 then
            local order = 5315
        elseif actor:get_quest_stage("treasure_hunter") == 7 then
            local order = 5316
        elseif actor:get_quest_stage("treasure_hunter") == 8 then
            local order = 5317
        elseif actor:get_quest_stage("treasure_hunter") == 9 then
            local order = 5318
        elseif actor:get_quest_stage("treasure_hunter") == 10 then
            local order = 5319
        end
        self:command("grumble")
        self.room:spawn_object(vnum_to_zone(order), vnum_to_local(order))
        self:command("give order " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end