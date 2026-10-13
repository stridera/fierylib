-- Trigger: Berix bounty hunt new contract
-- Zone: 60, ID: 60
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6060

-- Converted from DG Script #6060: Berix bounty hunt new contract
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new contract (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new contract", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
    if (actor:get_quest_var("bounty_hunt:bounty") or 0) ~= 0 then
        -- Hoisted: branch-scoped `local` would not be visible below.
        local contract
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_stage("bounty_hunt") == 1 then
            contract = 50
        elseif actor:get_quest_stage("bounty_hunt") == 2 then
            contract = 51
        elseif actor:get_quest_stage("bounty_hunt") == 3 then
            contract = 52
        elseif actor:get_quest_stage("bounty_hunt") == 4 then
            contract = 53
        elseif actor:get_quest_stage("bounty_hunt") == 5 then
            contract = 54
        elseif actor:get_quest_stage("bounty_hunt") == 6 then
            contract = 55
        elseif actor:get_quest_stage("bounty_hunt") == 7 then
            contract = 56
        elseif actor:get_quest_stage("bounty_hunt") == 8 then
            contract = 57
        elseif actor:get_quest_stage("bounty_hunt") == 9 then
            contract = 58
        elseif actor:get_quest_stage("bounty_hunt") == 10 then
            contract = 59
        else
            contract = 50
        end
        self:command("whap " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't be such an idiot again!'")
        self.room:spawn_object(60, contract)
        self:command("give contract " .. tostring(actor))
    end
end