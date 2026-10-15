-- Trigger: dragons_health_myorrhed_speech
-- Zone: 586, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #58601
-- Myorrhed responds to player speech to offer / advance the dragons_health
-- quest. Stage 0: pitch the quest (egg / yes / no). Stage 1: lore explanation
-- (why / value / procured / task) culminating in the first hunt.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"egg", "egg?", "yes", "yes?", "no", "no?", "why", "why?", "procured", "procured?", "procure", "procure?", "task", "task?", "value", "value?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("dragons_health") == 0 then
    wait(0.2)
    if string.find(speech, "egg?") or string.find(speech, "egg") then
        self:say("Yes, this egg here.")
        self:emote("gestures to the large bronze egg.")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'It's the last egg of the old bronze wyrm Dormynalth.")
        self.room:send("</>I am sworn to guard it until it hatches.'")
        -- (empty room echo)
        self:emote("utters a prayer of health and strength for the hatchling.")
        wait(5)
        if actor.level > 88 then
            if string.find(actor.class, "cleric") or string.find(actor.class, "priest") then
                self.room:send(tostring(self.name) .. " says, 'However, I could use some assistance from someone as capable")
                self.room:send("</>as you are.  If you're willing to help me, I can teach you a prayer to invoke")
                self.room:send("</>the health of dragons in exchange.'")
                wait(4)
                self:say("Are you interested?")
            end
        end
    elseif string.find(speech, "yes") or string.find(speech, "yes?") then
        wait(0.2)
        if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and actor.level > 88 then
            self:emote("smiles with gratitude.")
            actor:start_quest("dragons_health")
            wait(1)
            self:say("Good.  Allow me to explain the plan.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Dragon eggs like this one need the proper environment to grow")
            self.room:send("</>and develop.  Often this is a slow process, taking months or even years for")
            self.room:send("</>certain species.  But this process can be sped up by accumulating wealth into")
            self.room:send("</>a hoard for the unhatched dragon.'")
            wait(6)
            self.room:send(tostring(self.name) .. " says, 'You may be wondering <b:cyan>why</>.'")
        end
    end
elseif actor:get_quest_stage("dragons_health") == 1 then
    if string.find(speech, "why") or string.find(speech, "why?") then
        wait(0.2)
        self:say("Dragons love treasure.  This is well-known.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'On one level, they just love having it.  To many, all dragons,")
        self.room:send("</>good or evil, are personifications of greed.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'What many don't know is this love of treasure is more than")
        self.room:send("</>just habitual; it is instinctual.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Dragons are compelled to hoard treasure because they draw")
        self.room:send("</>power directly from the <b:cyan>value</> of the artifacts they claim dominion over.'")
    elseif string.find(speech, "value") or string.find(speech, "value?") then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'That value isn't always monetary.  Things imbued with precious")
        self.room:send("</>memories, little physical bits of ruins, even a plant that has been carried")
        self.room:send("</>from one land to another, all of that contributes to something's value.'")
        wait(2)
        self:say("And then of course there's the monetary value.")
        self:command("laugh")
        wait(6)
        self:say("We help the egg mature by increasing the value of its hoard.")
        wait(2)
        self.room:send(tostring(self.name) .. "'s eyes twinkle with mischief.")
        self.room:send(tostring(self.name) .. " says, 'It would be... valuable if you <b:cyan>\"procured\"</> a few items from the")
        self.room:send("</>hoards of chromatic dragons.'")
    elseif string.find(speech, "procured") or string.find(speech, "procured?") or string.find(speech, "procure") or string.find(speech, "procure?") then
        wait(0.2)
        self:say("Yes, that probably means you would have to slay them.")
        self:command("shrug")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'There is long-standing enmity between chromatic dragons, who")
        self.room:send("</>embody the abstract concepts of evil and maliciousness, and the metallic")
        self.room:send("</>dragons, who personify aloof goodness and righteousness.'")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'Fewer chromatic dragons means more space for metallic dragons.")
        self.room:send("</>To see if you're up to the <b:cyan>task</> though, let's start with something less")
        self.room:send("</>dangerous.'")
    elseif string.find(speech, "task") or string.find(speech, "task?") then
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'A young blue dragon has made a lair near the old tower west of")
        self.room:send("</>Anduin.  Bring back the crystal it keeps in its hoard for our hatchling.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'You may ask me about your <b:cyan>[progress]</> if you need a reminder.'")
    elseif string.find(speech, "no") or string.find(speech, "no?") then
        if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and actor.level > 88 and actor:get_quest_stage("dragons_health") == 0 then
            self:say("That's alright.  We shall let nature take its course.")
            self:emote("gently pats the egg.")
        end
    end
end