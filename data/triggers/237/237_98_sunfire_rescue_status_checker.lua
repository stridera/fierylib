-- Trigger: sunfire_rescue_status_checker
-- Zone: 237, ID: 98
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #23798

-- Converted from DG Script #23798: sunfire_rescue_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
local boots = actor:get_quest_var("sunfire_rescue:boots")
local cloak = actor:get_quest_var("sunfire_rescue:cloak")
local ring = actor:get_quest_var("sunfire_rescue:ring")
local total = boots + cloak + ring
if actor:get_quest_stage("sunfire_rescue") == 1 then
    self:say("Please find the treasures of my people!")
    if total > 0 then
        -- (empty room echo)
        self.room:send("</>You have retrieved the following treasures:")
        if boots then
            self.room:send(tostring(objects.template(520, 8).name) .. ".")
        end
        if cloak then
            self.room:send(tostring(objects.template(520, 9).name) .. ".")
        end
        if ring then
            self.room:send(tostring(objects.template(520, 1).name) .. ".")
        end
    end
    -- (empty room echo)
    self.room:send("</>You still need to bring me:")
    if boots == 0 then
        self.room:send(tostring(objects.template(520, 8).name) .. ".")
    end
    if cloak == 0 then
        self.room:send(tostring(objects.template(520, 9).name) .. ".")
    end
    if ring == 0 then
        self.room:send(tostring(objects.template(520, 1).name) .. ".")
    end
elseif actor:get_has_completed("sunfire_rescue") then
    self:say("You have already helped me greatly.")
end