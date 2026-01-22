-- Trigger: patriarch receives truthstone
-- Zone: 23, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--   Large script: 8069 chars
--
-- Original DG Script: #2301

-- Converted from DG Script #2301: patriarch receives truthstone
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- 
-- original Smoldering Trident trigger
-- 
if object.id == 2300 then
    wait(1)
    local object_shortdesc = object.shortdesc
    world.destroy(object.name)
    wait(3)
    self.room:send_except(actor, tostring(self.name) .. " stops tossing meat into the fire and peers at " .. tostring(actor.name) .. ".")
    actor:send(tostring(self.name) .. " stops tossing meat into the fire and looks at you.")
    wait(3)
    if actor.class == "Diabolist" then
        if actor.level >= 35 then
            self:command("smile")
            self:say("Excellent...very, very excellent.")
            self:emote("pockets " .. tostring(object_shortdesc) .. ".")
            wait(2)
            self:say("He will be very happy with this.")
            self:emote("turns towards the fire and begins chanting in an arcane tongue.")
            wait(3)
            self:emote("chants, 'Olarag hroshi nofaraio...'")
            wait(2)
            self.room:send("The flames begin to <blue>fl<blue>are</>, licking the cavern roof above!")
            wait(2)
            self:emote("chants, 'Dala kenthu sarijko dennal...'")
            wait(2)
            self.room:send("The &9<blue>un</><magenta>ho<blue>ly</> <blue>fi<blue>re</> continues to grow, nearly engulfing " .. tostring(self.name) .. "!")
            wait(2)
            self:emote("chants, 'Yarak tilaru kenzo jing!'")
            self.room:send("As " .. tostring(self.name) .. " completes " .. tostring(self.possessive) .. " chant, the <blue>fla<blue>mes</> suddenly contract into a ball.")
            wait(3)
            self.room:send("A <yellow>chi<blue>ll<green>ing</> voice croaks something in a language you do not understand.")
            wait(2)
            self.room:send("The ball of <blue>fl<blue>ame</> slowly begins to change shape, elongating and pulsating.")
            self.room:send("The <blue>fl<blue>ames</> take the shape of a <red>scar<blue>let <yellow>trident</>.")
            wait(3)
            self.room:send("The trident falls to the ground by the &9<blue>smoldering <red>emb<blue>ers</>.")
            wait(1)
            self:emote("gets a smoldering trident.")
            wait(1)
            self:say("Yes, I believe you have proven yourself indeed.")
            self:command("smile")
            wait(2)
            self:say("The weapon is for you.")
            wait(1)
            if actor.gender == "Female" then
                self:say("Go forth and smite those who might stand against us, sister.")
            elseif actor.gender == "Male" then
                self:say("Go forth and smite those who might stand against us, brother.")
            else
                self:say("Go forth and smite those who might stand against us.")
            end
            self.room:spawn_object(23, 34)
            self:command("give smoldering-trident " .. tostring(actor.name))
            if not actor:get_quest_stage("hell_trident") then
                actor:start_quest("hell_trident")
            end
            wait(1)
            -- 
            -- for Hellfire Trident
            -- 
            if actor.level >= 65 then
                self:say("Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times and then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.")
            else
                self:say("Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.")
                actor:send("<red>Reach level 65 to continue this quest.</>")
            end
            -- 
            -- for Hellfire and Brimstone
            -- 
            if (actor.level > 56) and not actor:get_quest_stage("hellfire_brimstone") then
                wait(2)
                self:say("You seem to be quite powerful already.  Powerful enough in fact to handle the Fire of the Dark One.")
                wait(2)
                self:say("Would you like to learn to rain fire and brimstone down on your enemies?")
            end
            -- 
            -- original Smoldering Trident trigger
            -- 
        else
            self:command("blink")
            self:say("Quite amazing that you were able to retrieve " .. tostring(object_shortdesc) .. ".")
            self:command("peer " .. tostring(actor.name))
            wait(2)
            self:say("Unfortunately, I don't think the Dark One would want to see such a weakling.  Return here again when you are more powerful.")
        end
    else
        self:command("snicker " .. tostring(actor.name))
        self:say("You are no diabolist!  You no more deserve this power than Mielikki herself!")
        self:emote("tosses " .. tostring(object_shortdesc) .. " in the flames.")
        wait(2)
        self:say("Run along now, there is nothing more for you here.")
    end
end
-- 
-- Hellfire and Brimstone continued
-- 
if actor:get_quest_stage("hellfire_brimstone") == 3 then
    if object.id == 4318 or object.id == 5211 or object.id == 5212 or object.id == 17308 or object.id == 48110 or object.id == 53000 then
        if actor.quest_variable[hellfire_brimstone:object.vnum] then
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            self:say("I have no need for a second " .. "%get.obj_noadesc[%object.vnum%]%!")
        else
            wait(2)
            actor.name:set_quest_var("hellfire_brimstone", "%object.vnum%", 1)
            self.room:send(tostring(self.name) .. " holds " .. tostring(object.shortdesc) .. " in his gnarled fist.")
            self:say("You have done well " .. tostring(actor.name) .. ".")
            world.destroy(object.name)
        end
        wait(2)
        local item1 = actor:get_quest_var("hellfire_brimstone:4318")
        local item2 = actor:get_quest_var("hellfire_brimstone:5211")
        local item3 = actor:get_quest_var("hellfire_brimstone:5212")
        local item4 = actor:get_quest_var("hellfire_brimstone:17308")
        local item5 = actor:get_quest_var("hellfire_brimstone:48110")
        local item6 = actor:get_quest_var("hellfire_brimstone:53000")
        if item1 and item2 and item3 and item4 and item5 and item6 then
            self:emote("laughs with dark pleasure!")
            self:say("A fine set of tributes to the Dark One!")
            wait(4)
            self:say("Now behold as I set this cavern alight!")
            wait(2)
            self.room:send("<b:red>" .. tostring(self.name) .. " spreads the flaming tributes throughout the cavern.</>")
            self.room:send("<b:red>The piles of brimstone burn hot and bright!</>")
            wait(3)
            self.room:send("<b:red>The fires trace out lines on the cavern floor, forming a huge burning sigil.</>")
            wait(4)
            actor:send("<b:red>Gazing into the burning sigil, you feel the words to a prayer to the Dark One forming in your soul.</>_")
            actor:send("You have learned the prayers for <b:red>H<yellow>e<red>llf<yellow>i<red>re</> <red>and <blue>Br<yellow>i<red>mst<yellow>o<red>ne</>!")
            actor.name:complete_quest("hellfire_brimstone")
            if not actor:get_quest_var("hell_trident:helltask4") and actor:get_quest_stage("hell_trident") == 1 then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
            skills.set_level(actor, "hellfire and brimstone", 100)
        else
            self:say("Bring me the rest of the fiery tributes!")
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("I have no need for this!")
    end
end
return _return_value