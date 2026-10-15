-- Trigger: derceta_speak2
-- Zone: 490, ID: 26
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49026

-- Converted from DG Script #49026: derceta_speak2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"push", "now"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local person = actor
local location = get_room(490, 42)
local stage = 4
local i = person.group_size
local a
local accept = false
local level = false
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") >= stage then
            accept = true
            if self.room == location then
                level = true
                if person:get_quest_stage("griffin_quest") == stage then
                    person:advance_quest("griffin_quest")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            end
        elseif person and person.is_player then
            i = i + 1
        end
    end
    a = a + 1
end
wait(0.2)
if level then
    if accept then
        self:emote("spits on her hands and starts to move the boulder.")
        self:say("Phew this is one heavy rock!")
        run_room_trigger(490, 0)
        self:set_flag("sentinel", false)
        self:follow(self)
    else
        self:say("What?  The boulder isn't here!")
    end
    self:command("peer " .. tostring(actor.name))
    self:say("And why would I do a thing like that?")
end