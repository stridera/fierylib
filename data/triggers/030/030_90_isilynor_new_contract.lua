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
        local notice
        -- switch on actor:get_quest_stage("dragon_slayer")
        if actor:get_quest_stage("dragon_slayer") == 1 then
            notice = 80
        elseif actor:get_quest_stage("dragon_slayer") == 2 then
            notice = 81
        elseif actor:get_quest_stage("dragon_slayer") == 3 then
            notice = 82
        elseif actor:get_quest_stage("dragon_slayer") == 4 then
            notice = 83
        elseif actor:get_quest_stage("dragon_slayer") == 5 then
            notice = 84
        elseif actor:get_quest_stage("dragon_slayer") == 6 then
            notice = 85
        elseif actor:get_quest_stage("dragon_slayer") == 7 then
            notice = 86
        elseif actor:get_quest_stage("dragon_slayer") == 8 then
            notice = 87
        elseif actor:get_quest_stage("dragon_slayer") == 9 then
            notice = 88
        elseif actor:get_quest_stage("dragon_slayer") == 10 then
            notice = 89
        end
        self:command("grumble")
        self.room:spawn_object(30, notice)
        self:command("give notice " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Truly, be less caprecious.'")
    end
end