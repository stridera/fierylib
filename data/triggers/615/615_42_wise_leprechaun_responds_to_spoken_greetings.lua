-- Trigger: Wise leprechaun responds to spoken greetings
-- Zone: 615, ID: 42
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61542

-- Converted from DG Script #61542: Wise leprechaun responds to spoken greetings
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hi hello
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    _return_value = true
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
    _return_value = false
end
return _return_value