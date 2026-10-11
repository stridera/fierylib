-- Trigger: Honus new order
-- Zone: 53, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `local order = N` branch-scoped. 0% probability never
-- fires. Same shape as 053_33. Full rewrite from DG #5334.
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
        local order
        if actor:get_quest_stage("treasure_hunter") == 1 then
            order = 10
        elseif actor:get_quest_stage("treasure_hunter") == 2 then
            order = 11
        elseif actor:get_quest_stage("treasure_hunter") == 3 then
            order = 12
        elseif actor:get_quest_stage("treasure_hunter") == 4 then
            order = 13
        elseif actor:get_quest_stage("treasure_hunter") == 5 then
            order = 14
        elseif actor:get_quest_stage("treasure_hunter") == 6 then
            order = 15
        elseif actor:get_quest_stage("treasure_hunter") == 7 then
            order = 16
        elseif actor:get_quest_stage("treasure_hunter") == 8 then
            order = 17
        elseif actor:get_quest_stage("treasure_hunter") == 9 then
            order = 18
        elseif actor:get_quest_stage("treasure_hunter") == 10 then
            order = 19
        end
        self:command("grumble")
        self.room:spawn_object(53, order)
        self:command("give order " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Be more careful next time.'")
    end
end