-- Trigger: Isilynor new contract
-- Zone: 30, ID: 90
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3090

-- Converted from DG Script #3090: Isilynor new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: i need a new notice (DG num_arg 0 = the speech contains the whole phrase, on word boundaries)
local speech_padded = " " .. string.lower(speech) .. " "
if not string.find(speech_padded, "[%s%p]i need a new notice[%s%p]") then
    return true  -- Not the phrase
end
wait(0.2)
if actor.level >= (actor:get_quest_stage("dragon_slayer") - 1) * 10 then
    if actor:get_quest_stage("dragon_slayer") > 0 then
        local notice
        -- switch on actor:get_quest_stage("dragon_slayer")
        do
            local _sw1 = string.lower(tostring(actor:get_quest_stage("dragon_slayer") or ""))
            if tonumber(_sw1) == 1 then
                notice = 80
            elseif tonumber(_sw1) == 2 then
                notice = 81
            elseif tonumber(_sw1) == 3 then
                notice = 82
            elseif tonumber(_sw1) == 4 then
                notice = 83
            elseif tonumber(_sw1) == 5 then
                notice = 84
            elseif tonumber(_sw1) == 6 then
                notice = 85
            elseif tonumber(_sw1) == 7 then
                notice = 86
            elseif tonumber(_sw1) == 8 then
                notice = 87
            elseif tonumber(_sw1) == 9 then
                notice = 88
            elseif tonumber(_sw1) == 10 then
                notice = 89
            end
        end
        self:command("grumble")
        self.room:spawn_object(30, notice)
        self:command("give notice " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Truly, be less caprecious.'")
    end
end