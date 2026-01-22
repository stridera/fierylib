-- Trigger: Hooded druid responds to 'hello'
-- Zone: 120, ID: 0
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12000

-- Converted from DG Script #12000: Hooded druid responds to 'hello'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hello hi Hello Hi
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "hi") or string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "hi")) then
    return true  -- No matching keywords
end
wait(1)
if actor:get_has_completed("twisted_sorrow") then
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Hello my friend.  The trees are still thankful for your service.")
else
    self:say("Hello, little one.")
    wait(2)
    self.room:send("The hooded druid says, 'I take it you have witnessed the the devastation beyond")
    self.room:send("</>this grove?  A great evil befell the land, while we were sleeping.  Now that it")
    self.room:send("</>has consumed even the one who wrought it, what hope is there of lifting it?")
    self.room:send("</>Surely, I have no idea.'")
    wait(5)
    self:command("sigh")
    wait(2)
    self.room:send("The hooded druid continues, 'But still, these trees are not so easily")
    self.room:send("</>perverted.  Though the corruption of the forest has harmed and saddened them,")
    self.room:send("</>they live on.  And indeed, they thirst, each in its own way.  But it has been")
    self.room:send("</>so long since they were slaked, that none can remember what satisfies them.'")
    wait(5)
    self.room:send("The hooded druid says, 'Tell me friend, do you think you may want to help")
    self.room:send("</>them?'")
end