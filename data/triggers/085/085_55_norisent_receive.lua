-- Trigger: Norisent Receive
-- Zone: 85, ID: 55
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 8417 chars
--
-- Original DG Script: #8555

-- Converted from DG Script #8555: Norisent Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 4008 then
    if actor:get_quest_stage("resurrection_quest") == 4 then
        _return_value = false
        self:emote("refuses to take it.")
        self:say("First, give me the talisman, to be sure this was done right.")
        return _return_value
    elseif actor:get_quest_stage("resurrection_quest") == 5 then
        wait(1)
        world.destroy(object)
        actor.name:advance_quest("resurrection_quest")
        self:say("Excellent.  The Tres Keeper was using this ring to gain power over the connection between soul and body.  It should not be in such careless hands as his.")
        wait(3)
        self:say("Another of the dark mages focused his research on extending life.  He is using robes imbued with the power of a mighty dragon to manipulate the flow of time and extend his life.'")
        self:command("sigh")
        wait(3)
        self:say("However, his tempering with the mysterious time elementals left behind from the Time Cataclysm opened a rift that he could not control.  Monstrous tentacled abominations wriggled through the rift and are now wreaking havoc on the material plane.")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'With that talisman, you must remove the <b:blue>two Xeg-Yi</> from this world.  They do not belong.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'When you're finished, remove the <b:blue>dragon-cult mage</> by the same means.  His meddling is over.'")
        return _return_value
    end
    return _return_value
elseif object.id == 53307 then
    if actor:get_quest_stage("resurrection_quest") == 6 then
        _return_value = false
        self:emote("refuses your item.")
        self:say("First, give me the talisman.  I want to be sure things are in order.")
        return _return_value
    elseif actor:get_quest_stage("resurrection_quest") == 7 then
        wait(1)
        world.destroy(object)
        actor.name:advance_quest("resurrection_quest")
        self:say("Good.  Aelfric's work with lengthening life was disrupting the flow of time itself.  Very foolish of him.")
        wait(3)
        self:say("There is one whose necromancy has become quite advanced, as brutish as it is.")
        self:command("chuckle")
        wait(3)
        self:say("His works have sunken a castle into the swamps, leaving it to the local lizard men.  But more critically, he is continuing his vulgar practice in a nearby village, severing spirits and bodies, magic and reality, and even losing demons into the world.  The situation is utterly out of his control.  He seeks a relic that he believes will aid him in his research.")
        wait(5)
        if actor.class == "diabolist" then
            self:say("Help him find the heart of the phoenix that he seeks, but bring it here.")
        else
            self:say("Find the book he seeks, before he discovers its resting place.  You must bring it to me.")
        end
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'There is a man that resists the oppressor, with both his <b:blue>soul in the castle</>, and his <b:blue>animated bloody remains</> in the village where the <b:blue>dark mage</> has made his dwelling.'")
        wait(3)
        self:say("Remove them all!  Dark mage and the bloody abomination by means of the talisman, and the remaining spirit by means of the divine utterance, \"Dhewsost Konre.\"")
        return _return_value
    end
    return _return_value
elseif actor:get_quest_stage("resurrection_quest") == 9 and (object.id == 51023 or object.id == 51028 or object.id == 51022) then
    if object.id == 51023 then
        -- switch on actor.class
        if actor.class == "CLERIC" or actor.class == "PRIEST" then
            wait(2)
            world.destroy(object)
            self:say("Ah, the angelic book!  You have done well to keep this from him.")
            actor.name:advance_quest("resurrection_quest")
        elseif actor.class == "DIABOLIST" then
            _return_value = false
            self:say("Wrong one, dummy.")
        else
            _return_value = false
            self:say("What's your class?")
            return _return_value
        end
    elseif object.id == 51028 then
        -- switch on actor.class
        if actor.class == "diabolist" then
            wait(2)
            world.destroy(object)
            self:say("Ah, the phoenix heart!  You've done well to keep this from him.")
            actor.name:advance_quest("resurrection_quest")
        elseif actor.class == "cleric" or actor.class == "priest" then
            _return_value = false
            self:say("Wrong one, dummy.")
        else
            _return_value = false
            self:say("What's your class?")
            return _return_value
        end
    elseif object.id == 51022 then
        -- switch on actor.class
        if actor.class == "CLERIC" or actor.class == "PRIEST" then
            _return_value = false
            self:say("This book is incomplete!  Something has drained its magic!  Fix that and then bring the book back.")
        elseif actor.class == "DIABOLIST" then
            _return_value = false
            self:say("Wrong one, dummy.")
        else
            _return_value = false
            self:say("What's your class?")
            return _return_value
        end
        _return_value = false
        self:say("This isn't the power Luchiaans seeks.  Go find it.")
        return _return_value
    end
    -- 
    -- the old version where you had to go to Doom for the quest
    -- 
    -- wait 3s
    -- say There is another mage trapped by a malevolent god between life and death.  The continued existence of the mighty battlemage, Solek, is the cause of great instability.  Along with him, his compatriot Velocity, named for the speeds she harnessed in life, is bound by the same god in his keep.  Their continued existence as puppets of a cruel god tears at the very fabric of order and structure.
    -- wait 3s
    -- say You must find the power to stop Velocity. The utterance will help you.  Bring swift and lasting death to Solek, and return the source of his arcane wisdoms.
    -- elseif %actor.quest_stage[resurrection_quest]% == 10
    -- if %object.vnum% == 48906
    -- say Give me the talisman first. I must know that Solek is truly dead.
    -- return 0
    -- emote refuses your item.
    -- endif
    -- 
    wait(3)
    self:say("There is another mage who has managed to ensconce himself in a place where no living being should be.  As a side effect of making his home at the boundary between the mortal realm and the Nine Hells, he has been driven insane.  He still survives all these centuries later through magic stolen from the elves of old.  Along with him, several souls have been marooned in the city's ruins.")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'One in particular, <b:blue>the city's weaponsmith</>, cries out for release from her eternal torment.  You must find the power to grant her wish.  The utterance will help you.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'Bring swift and lasting death to <b:blue>the crazed mage</>, and return the source of his arcane longevity.'")
elseif actor:get_quest_stage("resurrection_quest") == 10 then
    if object.id == 52001 then
        self:say("Give me the talisman first.  I must know the crazed mage is truly dead at last.")
        _return_value = false
        self:emote("refuses your item.")
    end
elseif actor:get_quest_stage("resurrection_quest") == 11 then
    if object.id == 52001 then
        wait(2)
        world.destroy(object)
        self:say("The ring is secure again.  It holds more power than a mortal can imagine.")
        wait(3)
        self:say("One yet remains of the foolish necromancers, who threatened the very existence of the world with their foolish search for immortality.  End me now, and let this be finished!")
        actor:advance_quest("resurrection_quest")
        local complete = 1
        globals.complete = globals.complete or true
    end
else
    _return_value = false
    wait(1)
    self:emote("refuses your offering.")
    self:say("This isn't what we're after.")
end
return _return_value