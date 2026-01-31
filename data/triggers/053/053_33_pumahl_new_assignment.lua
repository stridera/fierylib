-- Trigger: Pumahl new assignment
-- Zone: 53, ID: 33
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5333

-- Converted from DG Script #5333: Pumahl new assignment
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I need a new assignment
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "need") or string.find(string.lower(speech), "a") or string.find(string.lower(speech), "new") or string.find(string.lower(speech), "assignment")) then
    return true  -- No matching keywords
end
wait(2)
if actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
    if actor:get_quest_var("beast_master:hunt") then
        -- switch on actor:get_quest_stage("beast_master")
        if actor:get_quest_stage("beast_master") == 1 then
            local notice = 5300
        elseif actor:get_quest_stage("beast_master") == 2 then
            local notice = 5301
        elseif actor:get_quest_stage("beast_master") == 3 then
            local notice = 5302
        elseif actor:get_quest_stage("beast_master") == 4 then
            local notice = 5303
        elseif actor:get_quest_stage("beast_master") == 5 then
            local notice = 5304
        elseif actor:get_quest_stage("beast_master") == 6 then
            local notice = 5305
        elseif actor:get_quest_stage("beast_master") == 7 then
            local notice = 5306
        elseif actor:get_quest_stage("beast_master") == 8 then
            local notice = 5307
        elseif actor:get_quest_stage("beast_master") == 9 then
        elseif actor:get_quest_stage("beast_master") == 10 then
        end
        self:command("grumble")
        self.room:spawn_object(53, 9)
        self:command("give assignment " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'Don't lose this one!'")
    end
end