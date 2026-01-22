-- Trigger: megalith_quest_keeper_greet
-- Zone: 123, ID: 13
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--   Large script: 7510 chars
--
-- Original DG Script: #12313

-- Converted from DG Script #12313: megalith_quest_keeper_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
if actor.quest_stage[type_wand] == "wandstep" and not actor:get_has_failed("megalith_quest") then
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor.quest_variable[type_wand:greet] == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("megalith_quest")
-- switch on self.id
-- 
-- North
-- 
if actor:get_has_completed("megalith_quest") then
    if self.id == 12303 then
        self:command("cheer")
        wait(1)
        self:say("I can feel the Earth rejoicing from here to Templace!  Surely with Her blessing we can move to cleanse the ancient home of my people.")
    elseif actor:get_has_failed("megalith_quest") then
        self:emote("drops to the ground.")
        wait(1)
        self:say("All hope is lost...  Without Her blessing, the demons will rampage forever.")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") == 1) then
        self:command("bow " .. tostring(actor.name))
        wait(1)
        self:say("I thank you most humbly for your assistance with calling the Spirits of Earth.")
    elseif stage > 2 then
        self:say("Finally, our Mother Goddess will be able to walk our world again!")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") /= 0) and (actor:get_quest_var("megalith_quest:north") /= 0) then
        self:command("bow " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " speaks in voice like a gentle breeze across sunlit grass, 'Are you here to help me summon the Spirits of Earth to protect our coven?'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") /= 0) and (actor:get_quest_var("megalith_quest:north") /= 1) then
        self:say("Do you have the granite ring?")
    end
    -- 
    -- South
    -- 
    if actor:get_has_completed("megalith_quest") then
    elseif self.id == 12304 then
        self:say("This land is again full with the pulse, the pull, the bloodpump of creation...")
        self:command("bow " .. tostring(actor.name))
        wait(1)
        self:say("Thanks to you.")
    elseif actor:get_has_failed("megalith_quest") then
        self.room:send(tostring(self.name) .. " begins to mutter to the standing stone, 'Destruction, greater than you or I can ever imagine...'")
        wait(1)
        self.room:send(tostring(self.name) .. " continues to mutter... 'A wave of protean fire curls around the planet and bares the world clean as bone...'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item2") == 1) then
        self:command("nod " .. tostring(actor.name))
        wait(1)
        self:say("I thank you most humbly for your assistance with calling the Spirits of Fire.")
    elseif stage > 2 then
        self.room:send(tostring(self.name) .. " whispers, 'Feel that?  That tingle in your veins?'")
        wait(1)
        self:say("That is the Lady of the Stars.  She approaches...")
        self.room:send(tostring(self.name) .. " takes a deep breath and exhales a cloud of <b:red>s</><red>p</><b:yellow>a</><red>r</><yellow>k</><b:yellow>s</>!")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item2") /= 0) and (actor:get_quest_var("megalith_quest:south") /= 0) then
        self:command("nod " .. tostring(actor.name))
        self:say("Hail traveler.")
        wait(2)
        self.room:send("In a whisper like smokey ash " .. tostring(self.name) .. " says, 'Are you here to help me summon the Spirits of Fire to protect our coven?'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item2") /= 0) and (actor:get_quest_var("megalith_quest:south") /= 1) then
        self:say("I hope you brought the flaming jewel from Vulcera.")  -- typo: sat
    end
    -- 
    -- East
    -- 
    if actor:get_has_completed("megalith_quest") then
    elseif self.id == 12305 then
        self:command("dance " .. tostring(actor.name))
        wait(4)
        self:say("Finally we might be able to heal my poor family in Nordus!")
        wait(3)
        self:say("Can't you feel it?  The breath, the pull...")
        self:emote("exclaims in a ringing voice, 'Glory to - !!'")
        self:command("laugh")
    elseif actor:get_has_failed("megalith_quest") then
        self:emote("stands completely still, staring off into the void.")
        wait(10)
        self:say("Huh.")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item3") == 1) then
        self:command("wave " .. tostring(actor.name))
        wait(4)
        self:say("Thanks so much for your help with the Air Spirits!")
    elseif stage > 2 then
        self.room:send(tostring(self.name) .. " proclaims, 'Rejoice, the Great Work continues!  Soon the Faerie Goddess will be with us!'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item3") /= 0) and (actor:get_quest_var("megalith_quest:east") /= 0) then
        self:command("wave " .. tostring(actor.name))
        wait(4)
        self.room:send("In a jubilant tone, " .. tostring(self.name) .. " says, 'Hi there! Are you here to help me summon the Spirits of Air to protect our coven?'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item3") /= 0) and (actor:get_quest_var("megalith_quest:east") /= 1) then
        wait(2)
        self:say("I hope you were able to recover that cloud bracelet!")
    end
    -- 
    -- West
    -- 
    if actor:get_has_completed("megalith_quest") then
    elseif self.id == 12306 then
        self:emote("stifles tears of joy.")
        wait(1)
        self:say("I am overjoyed to see my Mother once again!  I can hear the rivers sing across Ethilien.  Our coven may be able to bring balance where the Dreaming flooded into the mortal realm at last.")
    elseif actor:get_has_failed("megalith_quest") then
        self:say("A catastrophe...  As terrible as the night the Dream engulfed the Syric Mountains...")
        wait(2)
        self:emote("begins to slip into a fugue.")
        wait(4)
        self:say("I still remember that night...")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") == 1) then
        self:command("curtsy " .. tostring(actor.name))
        wait(2)
        self:say("Spirits of Water overflow from the Dreaming into this realm, thanks to you!")
    elseif stage > 2 then
        self:say("Thanks to you, soon the Great Mother will be able to come from the Deep Dreaming once more!")
        self:command("hug " .. tostring(actor.name))
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") /= 0) and (actor:get_quest_var("megalith_quest:west") /= 0) then
        self:command("curtsy " .. tostring(actor.name))
        wait(1)
        self:say("Merry met!")
        wait(2)
        self.room:send(tostring(self.name) .. " speaks in a silver voice, like bells reverberating over water, 'Are you here to help me summon the Spirits of Water to protect our coven?'")
    elseif (stage == 2) and (actor:get_quest_var("megalith_quest:item4") /= 0) and (actor:get_quest_var("megalith_quest:west") /= 1) then
        self:say("Have you been able to bring me some water?")
    end
end