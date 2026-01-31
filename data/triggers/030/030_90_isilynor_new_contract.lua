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
        -- All notices are in zone 30, local_id = 79 + stage
        local notice_zone = 30
        local notice_local = 79 + actor:get_quest_stage("dragon_slayer")
        self:command("grumble")
        self.room:spawn_object(notice_zone, notice_local)
        self:command("give notice " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Truly, be less caprecious.'")
    end
end