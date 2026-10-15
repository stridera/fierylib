-- Trigger: keeper-keys-yes
-- Zone: 484, ID: 22
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48422

-- Converted from DG Script #48422: keeper-keys-yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
local begin
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("doom_entrance") == 0 then
            person:start_quest("doom_entrance")
            begin = 1
            person:send("<b:white>You have begun the quest to enter Lokari's Keep!</>")
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end
if begin then
    wait(0.2)
    self:command("bow " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " says, 'Then go ask the Oracle of the Hunt if you can prove your worth.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'When you have proved yourself to all three Oracles, please come see me again.'")
end