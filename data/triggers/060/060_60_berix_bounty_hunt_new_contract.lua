-- Trigger: Berix bounty hunt new contract
-- Zone: 60, ID: 60
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6060

-- Converted from DG Script #6060: Berix bounty hunt new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new contract
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "contract")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if actor:get_quest_var("bounty_hunt:bounty") then
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            local contract = 50
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            local contract = 51
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            local contract = 52
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            local contract = 53
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            local contract = 54
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            local contract = 55
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            local contract = 56
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            local contract = 57
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            local contract = 58
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            local contract = 59
        else
            local contract = 50
        end
        self:command("whap " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't be such an idiot again!'")
        self.room:spawn_object(60, contract)
        self:command("give contract " .. tostring(actor))
    end
end