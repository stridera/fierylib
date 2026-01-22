-- Trigger: creeping_doom_pixie_greet
-- Zone: 615, ID: 51
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #61551

-- Converted from DG Script #61551: creeping_doom_pixie_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if string.find(actor.class, "Druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            self:emote("grumbles about pathetic mortals ruining the world.")
            self:say("Oh what's this?")
            self:command("peer " .. tostring(actor))
            wait(1)
            self:say("A servant of Nature!")
            wait(2)
            self:say("And a powerful one at that!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'You!")
            self.room:send("</>You can help us remind the mortals how to treat the majesty of Nature!'")
        elseif actor:get_quest_stage("creeping_doom") == 5 then
            actor:send(tostring(self.name) .. " rushes to congratulate you!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'The forest sings of your deed!  Raining doom down on")
            self.room:send("</>that place of genocide has restored balance to part of the Black Woods.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'You earned the right to be called Nature's Avenger")
            self.room:send("</>and the power that brings.'")
            wait(2)
            skills.set_level(actor, "creeping doom", 100)
            actor:send("<blue>&9The nightmare of the Deep Dreaming touches your soul!")
            actor:send("You have mastered</> <red>Creeping <green>Doom<blue>&9!</>")
            actor.name:complete_quest("creeping_doom")
        elseif actor:get_quest_stage("creeping_doom") == 4 then
            self.room:send(tostring(self.name) .. " says, 'Is everything alright?")
            self.room:send("</>Do you need another seed?'")
        elseif actor:get_has_completed("creeping_doom") then
            self:say("Welcome back Avenger.")
        else
            self:say("Welcome back Dreamer.")
        end
    else
        self:say("Oh what's this?")
        self:command("peer " .. tostring(actor))
        wait(1)
        self:say("A servant of Nature!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'You certainly have promise.  But you're too")
        self.room:send("</>inexperienced to act as Nature's Avenger.  Come back when you're ready for the")
        self.room:send("</>darkest of dreams.'")
    end
end