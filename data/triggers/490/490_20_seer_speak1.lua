-- Trigger: seer_speak1
-- Zone: 490, ID: 20
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #49020

-- Converted from DG Script #49020: seer_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Earle sends me
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "earle") or string.find(string.lower(speech), "sends") or string.find(string.lower(speech), "me")) then
    return true  -- No matching keywords
end
wait(2)
if self.room ~= 49078 then
    self:say("I am powerless to help you outside my cave.")
else
    -- switch on actor:get_quest_stage("griffin_quest")
    if actor:get_quest_stage("griffin_quest") == 0 then
        self.room:send(tostring(self.name) .. " says, 'You say Earle sent you?  Hmm, he may have done, but there is nothing I can do for you.'")
    elseif actor:get_quest_stage("griffin_quest") == 1 then
        self.room:send(tostring(self.name) .. " says, 'Did you give the rune sword to Earle yet?  He has to verify that you can go through with this.'")
    else
        self.room:send(tostring(self.name) .. " says, 'Ah... my vision is coming true.  The cult grows in strength and will soon be strong enough to summon Dagon, the powerful griffin god.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Seek ye that drunken lout, for he has found the path to the chapel.  Say to him, <b:white>'the seer requests your assistance'</> and he will tell you what he knows.'")
        self:emote("closers her eyes and goes into a trance.")
        wait(3)
        self:emote("wails with fear.")
        self.room:send(tostring(self.name) .. " says, 'I see the future, when an evil greater than Dagon will walk the island.'")
        self:emote("opens her eyes again.")
        wait(2)
        self:command("sigh")
        self:say("There is much to do, and little time to do it.")
    end
    local person = actor
    local stage = 2
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = person.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("griffin_quest") == "stage" then
                person.name:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
end