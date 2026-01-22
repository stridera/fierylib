-- Trigger: derceta_speak2
-- Zone: 490, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #49026

-- Converted from DG Script #49026: derceta_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: push now
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "push") or string.find(string.lower(speech), "now")) then
    return true  -- No matching keywords
end
local person = actor
local location = 49042
local stage = 4
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") >= stage then
            local accept = "yes"
            if self.room == "location" then
                local level = "yes"
                if person:get_quest_stage("griffin_quest") == "stage" then
                    person.name:advance_quest("griffin_quest")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
    end
    local a = a + 1
end
wait(2)
if level then
    if accept then
        self:emote("spits on her hands and starts to move the boulder.")
        self:say("Phew this is one heavy rock!")
        run_room_trigger(49000)
        self:set_flag("sentinel", false)
        self:follow(self.room:find_actor("self"))
    else
        self:say("What?  The boulder isn't here!")
    end
    self:command("peer " .. tostring(actor.name))
    self:say("And why would I do a thing like that?")
end