-- Trigger: Pumahl new assignment
-- Zone: 53, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
-- TODO(parity): `local notice = N` branch-scoped (used at line 47
-- spawn_object). the dead 0% gate is gone (DG #5333 arg 0 = phrase
-- match, not a chance). Full rewrite from DG #5333 still wanted.
--
-- Original DG Script: #5333

-- Converted from DG Script #5333: Pumahl new assignment
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: I need a new assignment (DG num_arg 0 = the speech contains the phrase, not a chance)
if not string.find(string.lower(speech), "i need a new assignment", 1, true) then
    return true  -- Not the phrase
end
wait(0.2)
if actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if (actor:get_quest_var("beast_master:hunt") or 0) ~= 0 then
        -- switch on actor:get_quest_stage("beast_master")
        local notice
        if actor:get_quest_stage("beast_master") == 1 then
            notice = 0
        elseif actor:get_quest_stage("beast_master") == 2 then
            notice = 1
        elseif actor:get_quest_stage("beast_master") == 3 then
            notice = 2
        elseif actor:get_quest_stage("beast_master") == 4 then
            notice = 3
        elseif actor:get_quest_stage("beast_master") == 5 then
            notice = 4
        elseif actor:get_quest_stage("beast_master") == 6 then
            notice = 5
        elseif actor:get_quest_stage("beast_master") == 7 then
            notice = 6
        elseif actor:get_quest_stage("beast_master") == 8 then
            notice = 7
        elseif actor:get_quest_stage("beast_master") == 9 then
            notice = 8
        elseif actor:get_quest_stage("beast_master") == 10 then
            notice = 9
        end
        self:command("grumble")
        self.room:spawn_object(53, notice)
        self:command("give assignment " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't lose this one!'")
    end
end