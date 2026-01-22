-- Trigger: Isilynor new contract
-- Zone: 30, ID: 90
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3090

-- Converted from DG Script #3090: Isilynor new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new notice
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "notice")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_stage("dragon_slayer") then
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_stage("dragon_slayer") == 1 then
            local notice = 3080
        elseif actor:get_quest_stage("dragon_slayer") == 2 then
            local notice = 3081
        elseif actor:get_quest_stage("dragon_slayer") == 3 then
            local notice = 3082
        elseif actor:get_quest_stage("dragon_slayer") == 4 then
            local notice = 3083
        elseif actor:get_quest_stage("dragon_slayer") == 5 then
            local notice = 3084
        elseif actor:get_quest_stage("dragon_slayer") == 6 then
            local notice = 3085
        elseif actor:get_quest_stage("dragon_slayer") == 7 then
            local notice = 3086
        elseif actor:get_quest_stage("dragon_slayer") == 8 then
            local notice = 3087
        elseif actor:get_quest_stage("dragon_slayer") == 9 then
            local notice = 3088
        elseif actor:get_quest_stage("dragon_slayer") == 10 then
            local notice = 3089
        end
        self:command("grumble")
        self.room:spawn_object(vnum_to_zone(notice), vnum_to_local(notice))
        self:command("give notice " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Truly, be less caprecious.'")
    end
end