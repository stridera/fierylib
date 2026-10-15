-- Trigger: Wise leprechaun responds to spoken greetings
-- Zone: 615, ID: 42
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61542

-- Converted from DG Script #61542: Wise leprechaun responds to spoken greetings
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"hi", "hello"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local _return_value = true  -- Default: allow action
if actor.is_player then
    _return_value = false
    wait(1)
    self:say("Why hello to you too!")
    wait(1)
    if actor.gender == "female" then
        self.room:send(tostring(self.name) .. " says, 'Well now, lassie, I don't suppose you have any fruit on ye?'")
    elseif actor.gender == "male" then
        self.room:send(tostring(self.name) .. " says, 'Well now, laddie, I don't suppose you have any fruit on ye?'")
    else
        self.room:send(tostring(self.name) .. " says, 'Well now, I dont suppose you have any fruit on ye?'")
    end
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you bring me some, I can help you with those awful spiders, oh yes...  Mind you, I'm particular to cherries.'")
else
    _return_value = true
end
return _return_value