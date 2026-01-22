-- Trigger: serin-receive
-- Zone: 237, ID: 28
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 8044 chars
--
-- Original DG Script: #23728

-- Converted from DG Script #23728: serin-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Responding to trigger 23723 after they actually have the items.
-- This actually advances and ends the quest.
local boots = actor:get_quest_var("sunfire_rescue:boots")
local cloak = actor:get_quest_var("sunfire_rescue:cloak")
local ring = actor:get_quest_var("sunfire_rescue:ring")
if actor.id ~= -1 then
    _return_value = false
elseif actor.level > 99 then
    _return_value = false
    wait(1)
    self:command("eyebrow")
else
    if actor:get_quest_stage("sunfire_rescue") == 1 then
        -- Handle boots (object 52008)
        if object.id == 52008 then
            if boots == 1 then
                _return_value = false
                self:say("You have already given me these.")
            else
                actor.name:set_quest_var("sunfire_rescue", "boots", 1)
                wait(2)
                world.destroy(object)
                self:command("smile " .. tostring(actor.name))
                self:say("Thank you.")
                wait(1)
            end
        -- Cursed boots
        elseif object.id == 52024 then
            _return_value = false
            self:emote("looks at the boots carefully.")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, 'These are the cursed boots.  If you have the real ones,")
            self.room:send("</>please...  These cannot help me at all.  Do you have the real ones?  I need")
            self.room:send("</>them.'")
        -- Cursed ring
        elseif object.id == 52018 then
            _return_value = false
            self:command("frown " .. tostring(actor.name))
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("What kind of cruel trick is this?")
            wait(1)
            self:say("Well, do you have the real one to give to me?")
        -- Handle cloak (object 52009)
        elseif object.id == 52009 then
            if cloak == 1 then
                _return_value = false
                self:say("You have already given me the cloak.")
            else
                wait(2)
                actor.name:set_quest_var("sunfire_rescue", "cloak", 1)
                world.destroy(object)
                self:emote("carefully looks at the cloak.")
                self:say("This is it!  Thank you!")
                wait(1)
                self:say("Then I can finally escape....")
            end
        -- Cursed cloak
        elseif object.id == 52026 then
            _return_value = false
            self:emote("runs his hands over the cloak quickly.")
            self:say("This is the cursed cloak!")
            self:emote("looks angry.")
            actor:send("shoves " .. tostring(object.shortdesc) .. " back in your face.")
            self.room:send_except(actor, "shoves " .. tostring(object.shortdesc) .. " back in " .. tostring(actor.name) .. "'s face.")
            wait(1)
            self:say("Well?  Do you have the real cloak to give to me?")
            self:emote("taps his foot impatiently.")
        -- Handle ring (object 52001)
        elseif object.id == 52001 then
            if ring == 1 then
                _return_value = false
                self:say("You have already given me this ring.")
            else
                wait(2)
                self.room:send("Looking at the ring, the prisoner looks overwhelmed with emotion.")
                actor.name:set_quest_var("sunfire_rescue", "ring", 1)
                self:say("Escape is so close I can feel it!")
                world.destroy(object)
                -- that ought to cover everything...
            end
        else
            _return_value = false
            self:say("This isnt going to help me!")
            self:command("roll")
        end
    elseif actor:get_has_completed("sunfire_rescue") then
        _return_value = false
        self:say("You have already helped me.  I am grateful to you.")
    else
        _return_value = false
        self:say("What are you doing?")
    end
    local boots = actor:get_quest_var("sunfire_rescue:boots")
    local cloak = actor:get_quest_var("sunfire_rescue:cloak")
    local ring = actor:get_quest_var("sunfire_rescue:ring")
    local total = boots + cloak + ring
    if total >= 3 then
        wait(2)
        self:emote("slips his feet out of the shackles and wears the boots.")
        wait(2)
        self:emote("unshackles his arms and wears the cloak on his shoulders.")
        wait(2)
        self.room:send("Looking hesitant, the prisoner slowly slides the ring onto his finger.")
        actor.name:advance_quest("sunfire_rescue")
        self.room:spawn_object(237, 16)
        self:destroy_item("all.elven")
        wait(3)
        self:emote("vanishes from sight.")
        -- The badge reward is level 50, but the players have to be 70 or so
        -- to handle the boots, cloak etc anyway....:)
        --
        -- Set X to the level of the award - code does not run without it
        --
        local expcap
        if actor.level < 85 then
            expcap = actor.level
        else
            expcap = 85
        end
        local expmod = 0
        if expcap < 9 then
            expmod = (((expcap * expcap) + expcap) / 2) * 55
        elseif expcap < 17 then
            expmod = 440 + ((expcap - 8) * 125)
        elseif expcap < 25 then
            expmod = 1440 + ((expcap - 16) * 175)
        elseif expcap < 34 then
            expmod = 2840 + ((expcap - 24) * 225)
        elseif expcap < 49 then
            expmod = 4640 + ((expcap - 32) * 250)
        elseif expcap < 90 then
            expmod = 8640 + ((expcap - 48) * 300)
        else
            expmod = 20940 + ((expcap - 89) * 600)
        end
        --
        -- Adjust exp award by class so all classes receive the same proportionate amount
        --
        -- switch on actor.class
        if actor.class == "Warrior" or actor.class == "Berserker" then
            --
            -- 110% of standard
            --
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "Paladin" or actor.class == "Anti-Paladin" or actor.class == "Ranger" then
            --
            -- 115% of standard
            --
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "Sorcerer" or actor.class == "Pyromancer" or actor.class == "Cryomancer" or actor.class == "Illusionist" or actor.class == "Bard" then
            --
            -- 120% of standard
            --
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "Necromancer" or actor.class == "Monk" then
            --
            -- 130% of standard
            --
            expmod = (expmod + ((expmod * 2) / 5))
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            --
            -- Xexp must be replaced by mexp, oexp, or wexp for this code to work
            -- Pick depending on what is running the trigger
            --
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor.name:complete_quest("sunfire_rescue")
        wait(2)
        actor:send(tostring(self.name) .. " whispers to you, 'Thank you for your help!  Please wear this badge as a token of my respect.'")
        self:command("give badge " .. tostring(actor.name))
        wait(2)
        self.room:send("A voice softly echos, 'Good-bye...'")
        world.destroy(self.room:find_actor("serin"))
    else
        wait(1)
        self:say("Do you have the other treasures of my people?")
    end
end
return _return_value
