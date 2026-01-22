-- Trigger: Druid responds to 'assist'
-- Zone: 120, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12002

-- Converted from DG Script #12002: Druid responds to 'assist'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: assist
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "assist")) then
    return true  -- No matching keywords
end
wait(1)
if actor:get_has_completed("twisted_sorrow") then
    self:command("smile " .. tostring(actor.name))
    wait(1)
    self:say("The trees are satisfied, my friend.")
else
    if actor:get_quest_stage("twisted_sorrow") == 0 then
        actor.name:start_quest("twisted_sorrow")
    end
    self.room:send("The hooded druid says, 'Very well.  Each tree sups of its own liquid, that much")
    self.room:send("</>I know.  But what specifically they desire, I'm afraid, is knowledge from")
    self.room:send("</>before I began my watch.'")
    wait(5)
    self:emote("rubs his forehead thoughtfully.")
    wait(2)
    self.room:send("The hooded druid says, 'A prayer of greeting must be spoken to each tree")
    self.room:send("</>before it will awaken, so you will need my help.  Here is what you must do.'")
    wait(5)
    self:emote("looks sharply to ensure that you are paying attention.")
    wait(2)
    self.room:send("The hooded druid says, 'When you have a liquid to offer, say in my presence,")
    self.room:send("</><b:white>\"follow me\"</>.  Then I will accompany you to whichever tree you have chosen.")
    self.room:send("</>Then go to the tree, and give me the vessel.  I will commune with the tree and")
    self.room:send("</>provide it with the offering.'")
    wait(5)
    self:emote("stops to cough a few times, and leans up against a tree for support.")
    wait(2)
    self.room:send("The hooded druid says, 'Now go, and return when you have what is needed.'")
end