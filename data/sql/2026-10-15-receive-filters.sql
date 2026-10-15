-- Mob RECEIVE triggers: restore the legacy item filter (arg list) and make `return 0` refusals return false before any wait (playtest r12 F1/F2).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/018/018_27_blur_ranger_receive.lua
  (18, 27, $trig$-- Converted from DG Script #1827: blur_ranger_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- TODO(parity): legacy 5-digit vnum 58420 needs translation to (zone_id, local_id)
-- composite. Likely (zone=584, id=20) — Syric Warder's blade. Verify against
-- objects.template lookup and replace with `object.zone_id == 584 and object.local_id == 20`.
if (object.zone_id == 584 and object.id == 20) then
    if actor:get_quest_stage("blur") == 3 then
        actor:advance_quest("blur")
        wait(0.2)
        self.room:send(tostring(self.name) .. " says, 'Thank you for ending his suffering.  That was a")
        self.room:send("</>truly heroic effort.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'But this test is about more than just strength.")
        self.room:send("</>The true signature of a ranger is speed.'")
        wait(2)
        self:emote("whistles a complex tune to the sky and listens.")
        wait(8)
        self.room:send("A breeze rustles the leaves of the trees.")
        wait(3)
        self:emote("smiles.")
        wait(1)
        self:command("nod")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Your true teachers will be the four winds.  I have")
        self.room:send("</>called out to them.  They have agreed to teach you the spell if you can pass")
        self.room:send("</>the test we all have passed.'")
        wait(5)
        self:say("You must best them in a race.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'The four winds are notoriously difficult to locate.")
        self.room:send("</>The North Wind blows through the frozen town of Ickle.")
        self.room:send("</>The South Wind blows around the hidden standing stones in South Caelia.")
        self.room:send("</>The East Wind blows through an enormous volcano in the sea.")
        self.room:send("</>The West Wind blows through ruins across the vast Gothra plains.'")
        wait(7)
        self.room:send(tostring(self.name) .. " says, 'You may challenge them in any order, but even if")
        self.room:send("</>you find where the winds blow, there may be additional challenges to connecting")
        self.room:send("</>with them.'")
        wait(5)
        self:command("give forgotten-kings " .. tostring(actor.name))
        self:say("You may need this.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Are you ready to try?'")
    elseif actor:get_quest_stage("blur") == 2 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'It seems the Warder still roams.  Please go back and")
        self.room:send("</>destroy him.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("blur") > 3 then
        self.room:send(tostring(self.name) .. " says, 'You have already brought me " .. tostring(object.name) .. ".")
        self.room:send("</>Please, keep it.'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif actor:get_quest_stage("blur") == 3 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("This is not the proper blade.")
    return false  -- legacy return 0: the giver keeps the item
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I have no need for this at the moment.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '8667bd8c09697648186a7f9425b51f48'),
  -- data/triggers/023/023_01_patriarch_receives_truthstone.lua
  (23, 1, $trig$local _return_value = true  -- Default: allow action
-- 
-- original Smoldering Trident trigger
-- 
if (object.zone_id == 23 and object.id == 0) then
    wait(0.1)
    local object_shortdesc = object.shortdesc
    world.destroy(object)
    wait(0.3)
    self.room:send_except(actor, tostring(self.name) .. " stops tossing meat into the fire and peers at " .. tostring(actor.name) .. ".")
    actor:send(tostring(self.name) .. " stops tossing meat into the fire and looks at you.")
    wait(3)
    if actor.class == "diabolist" then
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
            self.room:send("The <b:black>un</><magenta>ho<blue>ly</> <blue>fi<blue>re</> continues to grow, nearly engulfing " .. tostring(self.name) .. "!")
            wait(2)
            self:emote("chants, 'Yarak tilaru kenzo jing!'")
            self.room:send("As " .. tostring(self.name) .. " completes " .. tostring(self.possessive) .. " chant, the <blue>fla<blue>mes</> suddenly contract into a ball.")
            wait(3)
            self.room:send("A <yellow>chi<blue>ll<green>ing</> voice croaks something in a language you do not understand.")
            wait(2)
            self.room:send("The ball of <blue>fl<blue>ame</> slowly begins to change shape, elongating and pulsating.")
            self.room:send("The <blue>fl<blue>ames</> take the shape of a <red>scar<blue>let <yellow>trident</>.")
            wait(3)
            self.room:send("The trident falls to the ground by the <b:black>smoldering <red>emb<blue>ers</>.")
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
            if actor:get_quest_stage("hell_trident") == 0 then
                actor:start_quest("hell_trident")
            end
            wait(1)
            -- 
            -- for Hellfire Trident
            -- 
            if actor.level >= 65 then
                self:say("Hell hungers for more and will reward you greatly if you feed it.  Attack with that trident 666 times then seek out the Black Priestess, the left hand of Ruin Wormheart.  She will guide your offerings.")
            else
                self:say("Other forces of Hell will eventually take notice of you too now.  Seek out the left hand of Ruin Wormheart, the Black Priestess, after you have grown more.  She will be your emissary.")
                actor:send("<red>Reach level 65 to continue this quest.</>")
            end
            -- 
            -- for Hellfire and Brimstone
            -- 
            if (actor.level > 56) and actor:get_quest_stage("hellfire_brimstone") == 0 then
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
    if (object.zone_id == 43 and object.id == 18) or (object.zone_id == 52 and object.id == 11) or (object.zone_id == 52 and object.id == 12) or (object.zone_id == 173 and object.id == 8) or (object.zone_id == 481 and object.id == 10) or (object.zone_id == 530 and object.id == 0) then
        if actor:get_quest_var("hellfire_brimstone:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I have no need for a second " .. tostring(objects.template(object.zone_id, object.local_id).name) .. "!")
            return false  -- legacy return 0: the giver keeps the item
        else
            wait(0.2)
            actor:set_quest_var("hellfire_brimstone", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            self.room:send(tostring(self.name) .. " holds " .. tostring(object.shortdesc) .. " in his gnarled fist.")
            self:say("You have done well " .. tostring(actor.name) .. ".")
            world.destroy(object)
        end
        wait(0.2)
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
            actor:complete_quest("hellfire_brimstone")
            if not actor:get_quest_var("hell_trident:helltask4") and actor:get_quest_stage("hell_trident") == 1 then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
            skills.set_level(actor, "hellfire and brimstone", 1000)
        else
            self:say("Bring me the rest of the fiery tributes!")
        end
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("I have no need for this!")
        return false  -- legacy return 0: the giver keeps the item
    end
end
return _return_value$trig$, '0ad7f150efae511af4b07477ba3f6e7e'),
  -- data/triggers/023/023_07_high-druid-receive.lua
  (23, 7, $trig$local _return_value = true  -- Default: allow action
if actor.is_player then
    if string.find(actor.class, "druid") then
        if (object.zone_id == 23 and object.id == 31) then
            self:command("smile " .. tostring(actor.name))
            globals.blessings = 1
            wait(2)
            self:destroy_item("blessing")
            self:say("I am grateful the monoliths are still serving their purpose.")
            self:say("Perhaps the one to the west still retains its blessing as well?")
            wait(2)
            self:say("Please bring that to me as well!")
            self:command("sigh")
            self:say("I would go myself, but I cannot leave the Vale.")
        elseif (object.zone_id == 23 and object.id == 33) then
            if globals.blessings == 1 then
                globals.blessings = 2
                self.room:send(tostring(self.name) .. " closes his eyes and smiles.")
                wait(2)
                self:destroy_item("blessing")
                self:say("This is heartening!  I do hope the sprites were not too much trouble.")
                self:say("They tricked us long ago and kept the powers of nature for themselves.")
                wait(2)
                self:say("Another power point is to the north.  Bring me that blessing and we shall be one step closer to restoring the stones.")
                self:command("bow " .. tostring(actor.name))
            else
                self:say("Why thank you.  But how did you know I wanted this?")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif (object.zone_id == 23 and object.id == 32) then
            if globals.blessings == 2 then
                self.room:send("The ancient druid's eyes light up as he receives the blessing.")
                globals.blessings = 3
                wait(2)
                self:destroy_item("blessing")
                self:say("At last, the restoration is almost complete!")
                self:say("The only one remaining is the blessing of the east.")
                wait(2)
                self:say("But be careful - it was placed far from the others.")
                self:say("Since many of the ancient roads are no more, you may have some difficulty finding it.")
            else
                self:say("Why thank you.  But this does me little good right now.")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif (object.zone_id == 23 and object.id == 30) then
            if globals.blessings == 3 then
                self.room:send(tostring(self.name) .. " heaves a great sigh of relief as he places the blessings on the stone slab.")
                globals.blessings = 0
                wait(1)
                self.room:send("The <b:black>stone slab</> begins to <b:white>glow brightly!</>")
                wait(2)
                self.room:send("<b:green>Tendrils of power shoot out from the stone slab, lighting the vale!</>")
                self.room:send(tostring(self.name) .. " smiles hapily as he watches Nature's power at work.")
                wait(4)
                self.room:send("The <b:green>glow</> begins to fade.")
                wait(1)
                actor:send(tostring(self.name) .. " turns to you and bows.")
                self.room:send_except(actor, tostring(self.name) .. " bows to " .. tostring(actor.name) .. ".")
                self:say("Truly, you have performed a great service to the Druids of Anlun Vale.")
                self:say("Please, it is not much, but accept this s a token of my gratitude.")
                wait(1)
                self.room:send(tostring(self.name) .. " pulls something out of his robes.")
                self.room:spawn_object(23, 35)
                self:command("give gaia-cloak " .. tostring(actor.name))
                wait(1)
                self:say("Truly, you have the makings of a great druid within you.")
                self:say("Never lose sight of that, and you shall prosper.")
            else
                self:say("Very interesting - but I cannot use that just now.")
                wait(2)
                self:destroy_item("blessing")
                self:command("eye " .. tostring(actor.name))
                self:say("And why should I need this?")
            end
        else
            self:say("Thank you, but I do not need this.")
            actor:send(tostring(self.name) .. " returns the item to you.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        self:say("I am sorry, but I am only looking for help from a fellow druid.")
        actor:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back to you.")
    end
end
return _return_value$trig$, '6bcf4d6848b0a988721eaa1d439ec1fc'),
  -- data/triggers/028/028_02_waterform_wave_receive.lua
  (28, 2, $trig$local stage = actor:get_quest_stage("waterform")
if actor:get_quest_var("waterform:new") == "yes" then
    if object.zone_id == 28 and object.local_id == 7 then
        wait(0.2)
        self:say("Yes, I can make a new dragon bone cup from this.")
        world.destroy(object)
        actor:set_quest_var("waterform", "new", 0)
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(2)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self:say("Don't lose this again!")
    else
        self:say("I can't make a new cup from this.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 1 then
    if object.zone_id == 510 and object.local_id == 9 then
        actor:advance_quest("waterform")
        wait(0.2)
        self:destroy_item("shield")
        self:say("Yes, this will do nicely.")
        self.room:send(tostring(self.name) .. " absorbs " .. tostring(objects.template(510, 9).name) .. " into its massive form!")
        wait(2)
        self:say("Now hold still.")
        wait(2)
        self.room:send(tostring(self.name) .. " crests up to a monumental height and pauses for just a moment.")
        wait(4)
        actor:send(tostring(self.name) .. " CRASHES down and engulfs you!")
        self.room:send_except(actor, tostring(self.name) .. " CRASHES down and engulfs " .. tostring(actor.name) .. "!")
        wait(4)
        actor:send("You feel your body start to soften and flow!")
        actor:send("You feel at one with the Great Wave!")
        self.room:send_except(actor, tostring(actor.name) .. " to merges with the Great Wave!")
        wait(6)
        actor:send("Suddenly you feel your body solidify again.")
        actor:send("You begin to choke!")
        self.room:send_except(actor, tostring(actor.name) .. " begins to struggle against the torrent!")
        wait(5)
        self.room:send_except(actor, tostring(self.name) .. " recedes leaving " .. tostring(actor.name) .. " heaving for breath.")
        actor:send(tostring(self.name) .. " recedes, leaving you gasping for air.")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'That didn't work quite right.  The Amorphous Shield alone")
        self.room:send("</>must not be powerful enough to sustain the transformation.  Perhaps we will")
        self.room:send("</>need to add a few other elements.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I apologize, but if you wish to continue, you will have")
        self.room:send("</>to find a few other things.'")
    else
        self:say("This isn't armor made of water.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 3 then
    if object.zone_id == 28 and object.local_id == 7 then
        actor:advance_quest("waterform")
        wait(0.2)
        self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
        self:destroy_item("thigh-bone")
        self:say("This bone will make an excellent water vessel.")
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        wait(5)
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(1)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'Take this cup.  With it, take samples of <b:blue>four living</>")
        self.room:send("</>water creatures</>.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Each creature must come from a <b:cyan>different region</> of")
        self.room:send("</>the world.  So you'll need samples from more than just the denizens of the")
        self.room:send("</>Blue-Fog river and road.'")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you've gathered the four samples, return and give me")
        self.room:send("</>the cup.'")
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This won't make a usable vessel.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 4 then
    if object.zone_id == 28 and object.local_id == 8 then
        self:say("It seems you haven't collected all four samples yet.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
        return false  -- legacy return 0: the giver keeps the item
    else
        self:say("Why are you bringing me this?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You should be out collecting living water samples.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 5 then
    if object.zone_id == 28 and object.local_id == 8 then
        actor:advance_quest("waterform")
        -- Legacy DG returned 0 here: the giver keeps the cup. Hand it back explicitly (this path waits).
        require("dg").give(self, object, actor)
        self:say("Yes, these samples are perfect.")
        wait(2)
        self:emote("rises up, coaxing wavering orbs of water out of the dragon bone cup.")
        self:emote("raises up the shield and merges the watery orbs with it.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'One last thing, just to be sure.  Develop a deeper")
        self.room:send("</>personal insight on the nature of water.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Using the cup again, <b:cyan>examine</> six unique sources of")
        self.room:send("</>water.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Seek out:'")
        self.room:send("- <b:blue>a granite pool in the village of Mielikki</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a sparkling artesian well in the Realm of the King of Dreams</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a crystal clear fountain in the caverns of the Ice Cult</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the creek in the Eldorian Foothills</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the wishing well at the Dancing Dolphin in South Caelia</>")
        -- (empty room echo)
        self.room:send("- <b:blue>an underground brook in the Minithawkin Mines</>")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you have examined all six sites, return and I shall")
        self.room:send("</>try the transformation again.'")
    else
        self.room:send(tostring(self.name) .. " says, 'You haven't been trying to collect samples in this have")
        self.room:send("</>you?'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 6 then
    if object.zone_id == 28 and object.local_id == 8 then
        self:say("You haven't completed all of your examinations yet!")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
        return false  -- legacy return 0: the giver keeps the item
    else
        self:say("What is this for?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 7 then
    if object.zone_id == 28 and object.local_id == 8 then
        wait(0.2)
        self:destroy_item("dragon-bone-cup")
        self.room:send(tostring(self.name) .. " says, 'Everything is ready!  I shall attempt the transformation")
        self.room:send("</>again.'")
        wait(2)
        self.room:send(tostring(self.name) .. " rises up like a tower on the water.")
        self.room:send("The Great Wave swells as the waters of the Blue Lake rise to meet it.")
        wait(4)
        actor:send(tostring(self.name) .. " crests and breaks, washing over you!")
        self.room:send_except(actor, tostring(self.name) .. " crests and breaks, washing over " .. tostring(actor.name) .. "!")
        wait(6)
        actor:send("You feel your body liquify as the Great Wave swirls over, in, and through you.")
        actor:send("You can feel the rushing waters of the world in every particle of your being as you join with the Great Wave and the Blue Lake.")
        self.room:send_except(actor, tostring(actor.name) .. " liquifies and joins with the waters of the Great Wave and the Blue Lake.")
        wait(5)
        skills.set_level(actor, "waterform", 1000)
        actor:send("<b:blue>The Great Wave imparts the method to transform your body into pure raging water!</>")
        actor:complete_quest("waterform")
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not the dragon bone cup.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self:say("I don't remember asking you to retrieve this.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'd9da4907c36da4282cc2f29252f4db7b'),
  -- data/triggers/030/030_00_receptionist_no_item_trigger.lua
  (30, 0, $trig$-- Converted from DG Script #3000: Receptionist_no_item_trigger
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
actor:send(tostring(self.name) .. " says, 'I'm sorry, but I cannot accept this.'")
actor:send(tostring(self.name) .. " refuses your item.")
return false  -- legacy return 0: the giver keeps the item$trig$, 'bbc7a102656a94fc730b3f9ec453df00'),
  -- data/triggers/030/030_30_myst_quest_reward.lua
  (30, 30, $trig$-- Converted from DG Script #3030: Myst_quest_reward
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (16023): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 160 and object.id == 23)
) then
    return true
end

wait(0.1)
self:destroy_item("shard")
-- Create a random number by which to judge prize table off of.
local rnd = random(1, 100)
if rnd >= 90 then
    self.room:spawn_object(4, 1)
elseif rnd < 90 and rnd >= 70 then
    self.room:spawn_object(30, 40)
elseif rnd < 70 and rnd >= 30 then
    -- switch on random(1, 19)
    if random(1, 19) == 1 then
        -- cure crit x3
        self.room:spawn_object(83, 42)
    elseif random(1, 19) == 2 then
        -- strength
        self.room:spawn_object(30, 274)
    elseif random(1, 19) == 3 then
        -- wisdom
        self.room:spawn_object(30, 278)
    elseif random(1, 19) == 4 then
        -- monk fire
        self.room:spawn_object(30, 249)
    elseif random(1, 19) == 5 then
        -- monk acid
        self.room:spawn_object(30, 258)
    elseif random(1, 19) == 6 then
        -- bless, remove curse, cure serious
        self.room:spawn_object(117, 1)
    elseif random(1, 19) == 7 then
        -- prot evil, enhance con, remove poison
        self.room:spawn_object(117, 2)
    elseif random(1, 19) == 8 then
        -- prot evil, enhance wis
        self.room:spawn_object(178, 8)
    elseif random(1, 19) == 9 then
        -- prot cold, monk ice
        self.room:spawn_object(30, 241)
    elseif random(1, 19) == 10 then
        -- monk lightning
        self.room:spawn_object(30, 255)
    elseif random(1, 19) == 11 then
        -- monk ice
        self.room:spawn_object(30, 252)
    elseif random(1, 19) == 12 then
        -- prot cold
        self.room:spawn_object(30, 265)
    elseif random(1, 19) == 13 then
        -- prot fire
        self.room:spawn_object(30, 262)
    elseif random(1, 19) == 14 then
        -- prot air
        self.room:spawn_object(30, 268)
    elseif random(1, 19) == 15 then
        -- prot earth
        self.room:spawn_object(30, 271)
    elseif random(1, 19) == 16 then
        -- intelligence
        self.room:spawn_object(30, 282)
    elseif random(1, 19) == 17 then
        -- charisma
        self.room:spawn_object(30, 286)
    elseif random(1, 19) == 18 then
        -- constitution
        self.room:spawn_object(30, 290)
    elseif random(1, 19) == 19 then
        -- dexterity
        self.room:spawn_object(30, 294)
    else
        self:say("This quest reward has a broken potion random chance, let a god know.")
    end
elseif rnd < 30 then
    self.room:spawn_object(30, 41)
else
    self:say("The reward for this quest is broken, contact a god and let them know.")
end
self:shout("Hark all and listen, " .. tostring(actor.name) .. " has fended off a great evil for our fair town!")
wait(0.1)
self:say("Here, " .. tostring(actor.name) .. " you have earned this as a reward.")
wait(0.1)
self:command("give all " .. tostring(actor.name))
if not actor:get_has_completed("mystwatch_quest") and actor:get_quest_var("mystwatch_quest:step") == "complete" then
    actor:complete_quest("mystwatch_quest")
    local expcap
    if actor.level < 50 then
        expcap = actor.level
    else
        expcap = 50
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
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + ((expmod * 2) / 5))
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
end
if world.count_mobiles(160, 7) < 1 then
    get_room(160, 64):at(function()
        self.room:spawn_mobile(160, 7)
    end)
end$trig$, '7a1247c71e88a25dc95595ab4f2741e2'),
  -- data/triggers/030/030_53_armor_exchange_receive_exchange.lua
  (30, 53, $trig$-- Converted from DG Script #3053: Armor Exchange receive exchange
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local item = actor:get_quest_var("armor_exchange:armor_id")
if (item or 0) ~= 0 then
    local found
    if (item or 0) <= 55303 then
        if (object.zone_id == 553 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55307 then
        if (object.zone_id == 553 and object.id >= 4 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55311 then
        if (object.zone_id == 553 and object.id >= 8 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55315 then
        if (object.zone_id == 553 and object.id >= 12 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55319 then
        if (object.zone_id == 553 and object.id >= 16 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55323 then
        if (object.zone_id == 553 and object.id >= 20 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55327 then
        if (object.zone_id == 553 and object.id >= 24 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55331 then
        if (object.zone_id == 553 and object.id >= 28 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55335 then
        if (object.zone_id == 553 and object.id >= 32 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55339 then
        if (object.zone_id == 553 and object.id >= 36 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55343 then
        if (object.zone_id == 553 and object.id >= 40 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55347 then
        if (object.zone_id == 553 and object.id >= 44 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55351 then
        if (object.zone_id == 553 and object.id >= 48 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55355 then
        if (object.zone_id == 553 and object.id >= 52 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55359 then
        if (object.zone_id == 553 and object.id >= 56 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55363 then
        if (object.zone_id == 553 and object.id >= 60 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55367 then
        if (object.zone_id == 553 and object.id >= 64 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55371 then
        if (object.zone_id == 553 and object.id >= 68 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55375 then
        if (object.zone_id == 553 and object.id >= 72 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55379 then
        if (object.zone_id == 553 and object.id >= 76 and object.id <= 83) then
            found = 1
        end
    elseif (item or 0) <= 55783 then
        if (object.zone_id == 553 and object.id >= 80 and object.id <= 83) then
            found = 1
        end
    end
    if found == 1 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Here you are my dear!'")
        world.destroy(object)
        self.room:spawn_object(math.floor((item or 0) / 100), (item or 0) % 100)
        self:command("give all " .. tostring(actor))
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'A pleasure connecting lost things to their owners!'")
        actor:set_quest_var("armor_exchange", "armor_id", 0)
    else
        actor:send(tostring(self.name) .. " refuses to perform the exchange.")
        if (object.zone_id == 553 and object.id <= 83) then
            actor:send(tostring(self.name) .. " says, 'That's not rare enough!  I won't take " .. tostring(object.shortdesc) .. " for " .. objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name .. "!'")
        else
            actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing I keep around here...'")
        end
        return false  -- legacy return 0: the giver keeps the item
    end
else
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'I don't have any lost treasures for you dearie.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '254b8d8f665f9c6d19171264dc57f9ef'),
  -- data/triggers/030/030_83_dragon_slayer_isilynor_receive.lua
  (30, 83, $trig$-- Converted from DG Script #3083: Dragon Slayer Isilynor Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, pendantstage, item
if (object.zone_id == 30 and object.id == 80) then
    stage = 1
    victim1 = "a dragon hedge"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 81) then
    stage = 2
    victim1 = "the green wyrmling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 82) then
    stage = 3
    victim1 = "Wug the Fiery Drakling"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 83) then
    stage = 4
    victim1 = "the young blue dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 84) then
    stage = 5
    victim1 = "a faerie dragon"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 85) then
    stage = 6
    victim1 = "the wyvern"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 86) then
    stage = 7
    victim1 = "an ice lizard"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 87) then
    stage = 8
    victim1 = "the Beast of Borgan"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 88) then
    stage = 9
    victim1 = "Tri-Aszp"
    go = "hunt"
elseif (object.zone_id == 30 and object.id == 89) then
    stage = 10
    victim1 = "the Hydra"
    go = "hunt"
    -- paladin pendant items start here
elseif object.id == 360 then
    pendantstage = 1
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 120 and object.id == 3) then
    pendantstage = 1
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 82) then
    pendantstage = 1
    item = "gem"
    go = "necklace"
elseif object.id == 361 then
    pendantstage = 2
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 237 and object.id == 8) then
    pendantstage = 2
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 555 and object.id == 90) then
    pendantstage = 2
    item = "gem"
    go = "necklace"
elseif object.id == 362 then
    pendantstage = 3
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 580 and object.id == 5) then
    pendantstage = 3
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 22) then
    pendantstage = 3
    item = "gem"
    go = "necklace"
elseif object.id == 363 then
    pendantstage = 4
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 481 and object.id == 23) then
    pendantstage = 4
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 54) then
    pendantstage = 4
    item = "gem"
    go = "necklace"
elseif object.id == 364 then
    pendantstage = 5
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 123 and object.id == 36) then
    pendantstage = 5
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 62) then
    pendantstage = 5
    item = "gem"
    go = "necklace"
elseif object.id == 365 then
    pendantstage = 6
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 430 and object.id == 19) then
    pendantstage = 6
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 556 and object.id == 77) then
    pendantstage = 6
    item = "gem"
    go = "necklace"
elseif object.id == 366 then
    pendantstage = 7
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 370 and object.id == 15) then
    pendantstage = 7
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 9) then
    pendantstage = 7
    item = "gem"
    go = "necklace"
elseif object.id == 367 then
    pendantstage = 8
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 584 and object.id == 29) then
    pendantstage = 8
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 38) then
    pendantstage = 8
    item = "gem"
    go = "necklace"
elseif object.id == 368 then
    pendantstage = 9
    item = "quest"
    go = "necklace"
elseif (object.zone_id == 520 and object.id == 10) then
    pendantstage = 9
    item = "necklace"
    go = "necklace"
elseif (object.zone_id == 557 and object.id == 39) then
    pendantstage = 9
    item = "gem"
    go = "necklace"
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What is this for?")
    return false  -- legacy return 0: the giver keeps the item
end
if go == "hunt" then
    if actor:get_quest_stage("dragon_slayer") == "stage" and actor:get_quest_var("dragon_slayer:hunt") == "dead" then
        local anti = "Anti-Paladin"
        wait(0.2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
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
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("dragon_slayer", "target1", 0)
        actor:set_quest_var("dragon_slayer", "hunt", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("dragon_slayer")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest dragon slayers in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'I bestow upon you this crest in recognition of your might.  Wear this proudly.'")
            self.room:spawn_object(4, 149)
            self:command("give crest " .. tostring(actor))
        end
        if (string.find(actor.class, "paladin") or string.find(actor.class, "anti")) and actor:get_quest_stage("paladin_pendant") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 160)
            self:command("give necklace " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Necklaces like these are proof of your devotion to your causes.'")
            actor:start_quest("paladin_pendant")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further prove your <b:cyan>[devotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that necklace after you reach level 10.  We can discuss acts of devotion then.'")
            end
        end
    elseif actor:get_quest_stage("dragon_slayer") > stage then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        actor:send(tostring(self.name) .. " says, 'You already killed this dragon!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("dragon_slayer") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("dragon_slayer:hunt") ~= "dead" then
        self.room:send(tostring(self.name) .. " refuses the notice.")
        actor:send(tostring(self.name) .. " says, 'You have to slay the dragon first!  " .. tostring(victim1) .. " is still out there.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif go == "necklace" then
    if actor:get_quest_stage("dragon_slayer") < actor:get_quest_stage("paladin_pendant") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Slay some more dragons first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor.level < (actor:get_quest_stage("paladin_pendant") * 10) then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif pendantstage > actor:get_quest_stage("paladin_pendant") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Your devotional act doesn't involve that yet.  Be patient!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif pendantstage < actor:get_quest_stage("paladin_pendant") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You've already performed that act of devotion.'")
        return false  -- legacy return 0: the giver keeps the item
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your devotion.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give necklace " .. tostring(actor))
                local expcap = pendantstage * 10
                local expmod
                if expcap < 17 then
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
                expmod = expmod + ((expmod * 2) / 15)
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("paladin_pendant", "necklacetask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("paladin_pendant") < 9 then
                    actor:advance_quest("paladin_pendant")
                else
                    actor:complete_quest("paladin_pendant")
                end
            else
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you offer up your necklace!'")
                return false  -- legacy return 0: the giver keeps the item
            end
        elseif item == "necklace" then
            if actor:get_quest_var("paladin_pendant:necklacetask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("paladin_pendant:necklacetask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("paladin_pendant", "necklacetask3", object.id)
            end
        end
        if accept == "no" then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("paladin_pendant:necklacetask1")
            local job2 = actor:get_quest_var("paladin_pendant:necklacetask2")
            local job3 = actor:get_quest_var("paladin_pendant:necklacetask3")
            local job4 = actor:get_quest_var("paladin_pendant:necklacetask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now turn over your current necklace as the final proof of your devotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '30df0956fb5d5e97f4933a23acff41de'),
  -- data/triggers/030/030_92_bigby_assistant_refuse.lua
  (30, 92, $trig$-- Converted from DG Script #3092: Bigby Assistant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (300 310 320 330 55577 55575 55574 55576) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 2 and object.id == 100)
    or (object.zone_id == 2 and object.id == 110)
    or (object.zone_id == 2 and object.id == 120)
    or (object.zone_id == 2 and object.id == 130)
    or (object.zone_id == 555 and object.id == 77)
    or (object.zone_id == 555 and object.id == 75)
    or (object.zone_id == 555 and object.id == 74)
    or (object.zone_id == 555 and object.id == 76) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:command("shake")
    self:say("I don't need this.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '71b63aa150d5a378328efab0740b52dc'),
  -- data/triggers/043/043_01_catherine_key.lua
  (43, 1, $trig$-- Converted from DG Script #4301: catherine_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local refuse
local accept_lashes
local accept_key
self:set_flag("sentinel", true)
if actor:get_quest_stage("theatre") >= 1 then
    if (object.zone_id == 43 and object.id == 51) then
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            local member = actor.group_member[a]
            if member and member.room == self.room then
                if member:get_quest_stage("theatre") >= 1 and (member:get_quest_var("theatre:lashes") or 0) == 0 then
                    member:set_quest_var("theatre", "lashes", 1)
                    if member:get_quest_stage("theatre") == 1 then
                        member:send("<b:white>You have helped return Catherine's eyelashes.</>")
                    end
                    accept_lashes = 1
                end
            elseif member then
                i = i + 1
            end
            a = a + 1
        end
        if not accept_lashes then
            refuse = "lashes"
        else
            wait(0.2)
            self:say("Thank you so much!")
            wait(1)
            self:command("sit")
            self:command("wear eyelashes")
            self:emote("flutters her eyelids a few times.")
            wait(2)
            self:command("stand")
            wait(0.2)
            self:say("Finally!  Now if I could just have my dressing room key back too please...")
        end
    elseif (object.zone_id == 43 and object.id == 3) then
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            local member = actor.group_member[a]
            if member and member.room == self.room then
                if member:get_quest_stage("theatre") >= 1 and (member:get_quest_var("theatre:lashes") or 0) == 1 then
                    if member:get_quest_stage("theatre") == 1 then
                        member:advance_quest("theatre")
                        member:send("<b:white>You have advanced the quest!</>")
                    end
                    member:set_quest_var("theatre", "lashes", 0)
                    accept_key = 1
                end
            elseif member then
                i = i + 1
            end
            a = a + 1
        end
        if not accept_key then
            wait(0.2)
            self.room:send(tostring(self.name) .. " makes a weird, embarrassed face.")
            wait(1)
            self:say("Can you be a dear and bring me my eyelashes first?")
            wait(1)
            self:say("Thaaaaaaanks!")
            self:command("give key " .. tostring(actor.name))
        else
            wait(0.2)
            self:emote("looks incredibly relieved.")
            self:say("I can't believe those monkeys made off with my key but not my costumes.")
            wait(2)
            self:command("shrug")
            self:say("It's the little things I guess.")
            wait(1)
            self:say("Oh!  I think Lewis's key got locked in my dressing room...")
            get_room(43, 51):at(function()
                run_room_trigger(43, 65)
            end)
            wait(2)
            self:say("He might want that back.")
            wait(3)
            self:say("Now, if only I could find my shoes...")
            self:emote("trails off and wanders away.")
        end
    else
        refuse = "item"
    end
else
    refuse = "person"
end
if refuse then
    if refuse == "lashes" then
        self.room:send(tostring(self.name) .. " blinks in confusion.")
        self:say("N...o?  You already gave me my eyelashes.")
        actor:send(tostring(self.name) .. " slowly pushes the eyelashes back to you.")
        self.room:send_except(actor, tostring(self.name) .. " slowly pushes the eyelashes back to " .. tostring(actor.name) .. ".")
    elseif refuse == "item" then
        self.room:send("A confused look crosses Catherine's face as she refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This isn't what I was looking for!")
        self:say("Please help me or I'll miss my cue!")
    elseif refuse == "person" then
        self.room:send(tostring(self.name) .. " looks at " .. tostring(object.shortdesc) .. " with confusion.")
        self:say("Ummm, what is that?")
        self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " with confusion.")
        actor:send(tostring(self.name) .. " looks at you with confusion.")
        self:say("I'm sorry, who are you?")
    end
    return false  -- legacy return 0: the giver keeps the item
end
self:set_flag("sentinel", false)
return _return_value$trig$, '23ed3afdc02734f78bcc7154ce8d1fa8'),
  -- data/triggers/043/043_02_charlemagne_key.lua
  (43, 2, $trig$-- Converted from DG Script #4302: charlemagne_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local accept
local refuse
local outcome
self:set_flag("sentinel", true)
local i = actor.group_size
local stage = 4
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person and person.room == self.room then
        if (object.zone_id == 43 and object.id == 1) then
            if person:get_quest_stage("theatre") >= stage then
                if (person:get_quest_var("theatre:charles") or 0) == 0 then
                    person:set_quest_var("theatre", "charles", 1)
                    accept = 1
                    if person:get_quest_stage("theatre") == stage then
                        person:send("<b:white>You have helped return Charlemagne's key.</>")
                    end
                else
                    refuse = "key"
                end
            else
                refuse = "person"
            end
        elseif (object.zone_id == 43 and object.id == 20) then
            if person:get_quest_stage("theatre") <= stage then
                accept = 3
                if person:get_quest_stage("theatre") == stage then
                    if (person:get_quest_var("theatre:sash") or 0) == 0 then
                        person:set_quest_var("theatre", "sash", 1)
                        person:send("<b:white>You have helped return Charlemagne's sash.</>")
                    end
                end
            else
                if accept ~= 3 then
                    accept = 2
                end
            end
        else
            refuse = "item"
        end
        if person:get_quest_stage("theatre") == 4 and (person:get_quest_var("theatre:sash") or 0) ~= 0 and (person:get_quest_var("theatre:charles") or 0) ~= 0 then
            person:advance_quest("theatre")
            person:set_quest_var("theatre", "charles", 0)
            person:set_quest_var("theatre", "sash", 0)
            person:send("<b:white>You have advanced the quest!</>")
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end
if actor:get_quest_stage("theatre") == 4 then
    if (actor:get_quest_var("theatre:sash") or 0) == 0 then
        outcome = 2
    elseif (actor:get_quest_var("theatre:charles") or 0) == 0 then
        outcome = 3
    else
        outcome = 1
    end
else
    outcome = 1
end
if accept then
    wait(0.2)
    if accept == 1 then
        self:say("Ah marvelous!")
        wait(2)
    elseif accept > 1 then
        if accept == 2 then
            wait(0.2)
            self:say("Another?")
            wait(0.2)
            self:command("ponder")
            wait(2)
            self:say("Well I guess one never can be too prepared!")
        elseif accept == 3 then
            self:say("Where did you find this?  It must have been stolen in the scuffle this afternoon.  Thank you for returning it to me.")
        end
        self:command("remove sash")
        self:command("wear charlemagne's-fire-sash")
        self:destroy_item("sash")
        wait(0.5)
        self:command("bow")
        wait(2)
        self:say("Oh, since you seem to be so good at returning things, I think I might have something for you to do...")
        wait(0.2)
        self:emote("goes searching around through the room, tossing aside bedding and clothing.")
        wait(5)
        self:say("Ah ha!  Here it is!")
        self.room:spawn_object(43, 5)
        self:emote("pulls the <red>F<b:yellow>i<b:red>r</><red>e G<b:yellow>o<b:red>dd</><b:yellow>e</><red>ss<b:red>'s</> skirt from a pile of clothing.")
        wait(2)
        self:say("The actress, umm, left this here by accident last night...")
        wait(0.2)
        self:command("cough")
        wait(2)
        self:say("I've been meaning to return it to her, but I've been locked in here all day.  I'm sure she would be most happy to have it back.")
        wait(3)
        self:command("give skirt " .. tostring(actor.name))
        wait(2)
        self:say("Thank you kindly.")
        wait(2)
    end
    if outcome == 1 then
        self:say("Now be off!  I have to prepare for my performance!")
        wait(2)
        actor:send(tostring(self.name) .. " dismisses you.")
    elseif outcome == 2 then
        self:say("Now if only I could find my sash, I would be ready to go on tonight.")
    elseif outcome == 3 then
        self:say("If you have my dressing room key, please hand it over.")
    end
elseif refuse then
    if refuse == "item" then
        wait(0.2)
        self:command("roll " .. tostring(actor))
        wait(1)
        self:say("This isn't what I'm looking for.  Stop wasting time and help me look.")
    else
        if refuse == "person" then
            self:command("gasp")
            self:say("Are you a Ceiling Monkey in disguise?!")
            self:command("point " .. tostring(actor.name))
        elseif refuse == "key" then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("You already gave me my key back, thank you.")
        end
        return false  -- legacy return 0: the giver keeps the item
    end
end
self:set_flag("sentinel", false)
return _return_value$trig$, '5a225a5b0664aff25a26c84278c1e563'),
  -- data/triggers/043/043_03_lewis_key.lua
  (43, 3, $trig$-- Converted from DG Script #4303: lewis_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local refuse
self:set_flag("sentinel", true)
if (object.zone_id == 43 and object.id == 0) then
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local member = actor.group_member[a]
        if member and member.room == self.room then
            if member:get_quest_stage("theatre") == 2 then
                member:advance_quest("theatre")
                member:send("<b:white>You have advanced the quest!</>")
            end
        elseif member then
            i = i + 1
        end
        a = a + 1
    end
    if actor:get_quest_stage("theatre") >= 2 then
        wait(0.2)
        self:say("Hurray!  Thank you!")
        self:command("clap")
        wait(2)
        self:say("Oh!  Mummy's going to want her key back too!")
        wait(0.2)
        self.room:send(tostring(self.name) .. " fishes a key out of his armor.")
        wait(1)
        self:say("Please, give this to her.")
        self.room:spawn_object(43, 2)
        self:command("give key " .. tostring(actor.name))
        wait(2)
        self:say("Ta!")
        wait(0.3)
        self:emote("makes air kisses.")
    else
        refuse = "quest"
    end
else
    refuse = "item"
end
if refuse then
    if refuse == "quest" then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("What is this??  How did you get in here??")
    elseif refuse == "item" then
        self.room:send(tostring(self.name) .. " looks blankly at " .. tostring(object.shortdesc) .. ".")
        self:say("Well yes that's nice but it doesn't exactly help the situation.")
    end
    return false  -- legacy return 0: the giver keeps the item
end
self:set_flag("sentinel", false)
return _return_value$trig$, 'cc63224e5945bd8f0a386ec4f6cf2e4a'),
  -- data/triggers/043/043_04_fastrada_key.lua
  (43, 4, $trig$-- Converted from DG Script #4304: fastrada_key
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
if (object.zone_id == 43 and object.id == 2) then
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local member = actor.group_member[a]
        if member and member.room == self.room then
            if member:get_quest_stage("theatre") == 3 then
                member:advance_quest("theatre")
                member:send("<b:white>You have advanced the quest!</>")
            end
        elseif member then
            i = i + 1
        end
        a = a + 1
    end
    if actor:get_quest_stage("theatre") >= 3 then
        wait(0.3)
        self:say("Thank you sooooo much.")
        self.room:send_except(actor, tostring(self.name) .. " drapes herself all over " .. tostring(actor.name) .. ".")
        actor:send(tostring(self.name) .. " drapes herself all over you.")
        wait(1)
        self:emote("bends over slowly...")
        wait(2)
        self:emote("picks up a key.")
        self.room:spawn_object(43, 1)
        wait(0.2)
        self:command("give key " .. tostring(actor.name))
        wait(2)
        self:say("My darling husband, the King, will probably want that.")
        wait(4)
        self:say("Go let him out of his cage, he'll enjoy some fresh air.")
        wait(0.5)
        self:command("wave")
    else
        self.room:send(tostring(self.name) .. " refused " .. tostring(object.shortdesc) .. ".")
        self:say("How did you get this?")
        self:command("peer " .. tostring(actor))
        self:say("Are you stalking me?")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    wait(0.2)
    self:say("Why thank you!  I love a good gift!")
end
self:set_flag("sentinel", false)
return _return_value$trig$, '81676639a2cdfef05ddf86cd830b0d1c'),
  -- data/triggers/043/043_38_fire_goddess_skirt.lua
  (43, 38, $trig$-- Converted from DG Script #4338: fire_goddess_skirt
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local accept
self:set_flag("sentinel", true)
if (object.zone_id == 43 and object.id == 5) then
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local member = actor.group_member[a]
        if member and member.room == self.room then
            if member:get_quest_stage("theatre") >= 5 then
                accept = "yes"
                if member:get_quest_stage("theatre") == 5 then
                    member:advance_quest("theatre")
                    member:send("<b:white>You have advanced the quest!</>")
                end
            end
        elseif member then
            i = i + 1
        end
        a = a + 1
    end
    wait(0.2)
    self:command("blush")
    self:emote("says sheepishly, 'I was wondering where I left that.'")
    self:command("rest")
    wait(0.5)
    self:command("remove sash")
    self:command("drop sash")
    self:command("wear skirt")
    wait(3)
    self:emote("composes herself.")
    wait(2)
    if accept == "yes" then
        self:emote("clears her throat.")
        wait(2)
        self:say("Well, I suppose this means you dealt with the monkeys and helped our cast.  Thanks to you, our show has a chance of going on!")
        wait(4)
        self:say("However, we're still missing one important thing...")
        wait(2)
        actor:send("The Fire Goddess eyes you suspiciously.")
        self.room:send_except(actor, "The Fire Goddess eyes " .. tostring(actor.name) .. " suspiciously.")
        wait(2)
        actor:send("The Fire Goddess gives you an approving nod.")
        self.room:send_except(actor, tostring(actor) .. " The Fire Goddess gives " .. tostring(actor.name) .. " an approving nod.")
        self:say("Yes, I think you can help.")
        wait(4)
        -- (empty say)
        self:say("We need to find our Pippin in order to perform the grand Finale.  He's somewhere out in the world, trying to find his corner of the sky.")
        wait(4)
        self:say("I want you to bring him to us.")
        wait(2)
        -- (empty say)
        self:say("Take this.  Use its magic to lure him back to the theater.")
        self.room:spawn_object(43, 18)
        self:command("give torch " .. tostring(actor.name))
        wait(4)
        self:say("Hold it in your hand when you find him.  He won't be able to resist the beauty of one perfect flame.")
        wait(4)
        self:say("Now, when you get him back here, order him to enter the Fire Box.  We've prepared and hidden it upstage center just for him.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, <b:red>'Be careful not to get inside it yourself!'</>")
        wait(3)
        self:say("It's only for an extraordinary person like Pippin.")
        wait(4)
        self:say("We'll be waiting for you.")
    end
else
    actor:send("The Fire Goddess looks at you funny.")
    self.room:send_except(actor, "The Fire Goddess looks at " .. tostring(actor.name) .. " with an odd expression.")
    self:say("What is this?")
    return false  -- legacy return 0: the giver keeps the item
end
self:set_flag("sentinel", false)
return _return_value$trig$, '1f0d70ecf67266a9e63029047ed5d897'),
  -- data/triggers/043/043_53_leading_player_refuse.lua
  (43, 53, $trig$-- Converted from DG Script #4353: Leading Player refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (4357) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 43 and object.id == 57) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    if actor:get_quest_stage("bard_subclass") == 4 then
        actor:send(tostring(self.name) .. " says, 'This isn't the script I sent you for.'")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'I sure hope you didn't memorize anything from that!'")
        return false  -- legacy return 0: the giver keeps the item
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
        return false  -- legacy return 0: the giver keeps the item
    end
end
return _return_value$trig$, '29fba67bdce710330f2805757461a1d2'),
  -- data/triggers/043/043_61_lp2_bard_subclass_receive.lua
  (43, 61, $trig$-- Converted from DG Script #4361: LP2_bard_subclass_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (4357): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 43 and object.id == 57)
) then
    return true
end

local _return_value = true  -- Default: allow action
-- switch on actor:get_quest_stage("bard_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("bard_subclass") or ""))
    if tonumber(_sw1) == 3 then
        actor:send(tostring(self.name) .. " says, 'Ummmmm, what exactly is this for?'")
        actor:send(tostring(self.name) .. " slaps " .. tostring(object.shortdesc) .. " out of your hand!")
        self.room:send_except(actor, tostring(self.name) .. " slaps " .. tostring(object.shortdesc) .. " out of " .. tostring(actor.name) .. "'s hand!")
        actor:command("drop berthe-script")
        actor:send(tostring(self.name) .. " says, 'Pick it up and take a look again.  Make sure it's the the right thing.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif tonumber(_sw1) == 4 then
        actor:advance_quest("bard_subclass")
        wait(0.2)
        self:destroy_item("berthe-script")
        self.room:send(tostring(self.name) .. " flips through the script.")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Yeah, this is it for sure.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Alright, let's <b:cyan>hear a line or two</>.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Since you already gave me the script I sure hope you're off book!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'That means \"memorized\" in the biz.'")
        self:command("wink " .. tostring(actor))
    else
        wait(0.2)
        self:destroy_item("berthe-script")
        actor:send(tostring(self.name) .. " says, 'Huh, I was looking for that.  Thanks!'")
    end
end
return _return_value$trig$, '4e529693aa1ead0737b79b433308db4d'),
  -- data/triggers/043/043_64_lp_receive.lua
  (43, 64, $trig$-- Converted from DG Script #4364: LP_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local response
-- switch on object.id
do
    if actor:get_quest_stage("bard_subclass") > 0 then
        response = "Nah nah nah.  We need to go down to the studio before you do anything else.  You ready to keep going?"
    else
        response = "Ummmmm, what exactly is this for?"
    end
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '37cc558c53f4e76902ecbc493bfd74ef'),
  -- data/triggers/051/051_04_arre_matu_refuse.lua
  (51, 4, $trig$-- Converted from DG Script #5104: Arre Matu refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
--
-- Arre Matu refuses any object the player tries to give her that doesn't
-- match a more specific receive trigger (the sash receive lives in 51/12).
-- Note: legacy DG header listed probability 0%, but receive triggers in
-- DG fired on every receive event regardless of header probability -- the
-- converter's percent_chance(0) gate has been removed.
-- DG receive arg list (16110) with num_arg 0: this trigger ran for every other item.
-- The runtime does not filter on arg_list, so the exclusion lives here.
if (object.zone_id == 161 and object.id == 10) then
    return true
end

self.room:send(self.name .. " refuses " .. object.shortdesc .. ".")
self:command("eye " .. actor.name)
actor:send(self.name .. " says, 'What is this? I have no need for " .. object.shortdesc .. ".'")
return false  -- legacy return 0: the giver keeps the item$trig$, '27e07ca3d4c6aa562e47baf714f9fed2'),
  -- data/triggers/051/051_12_monk_subclass_quest_arre_receieve.lua
  (51, 12, $trig$-- Converted from DG Script #5112: monk_subclass_quest_arre_receieve
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- Receive trigger filtered to the bronze sash (object 16110 in legacy
-- vnum, no longer mapped here -- DG scoped this trigger to that object).
-- Stage gating:
--   1 / 2 - Quest not far enough along (player still owes the "fiend"
--           keyword); reject playfully.
--   3     - Player got the sash but didn't trigger the get hook (i.e.
--           handed off / stole it); refuse and call them out.
--   4     - Recover stage: complete the subclass quest.
--   else  - Stage 0/nil/5+: thank them, but no quest progress.
-- After all branches, junk the sash.
-- DG receive arg list (16110): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 161 and object.id == 10)
) then
    return true
end

wait(0.2)
local stage = actor:get_quest_stage("monk_subclass")
if stage == 1 or stage == 2 then
    actor:send(self.name .. " says, 'Funny, I don't even remember telling you what you were questing for.'")
elseif stage == 3 then
    -- Player has the sash but never picked it up themselves.
    actor:send(self.name .. " says, 'How on earth did you get me this?  Did you come by it through your own means?'")
    self:command("eye " .. actor.name)
    self:emote("shakes her head.")
    wait(2)
    actor:send(self.name .. " says, 'I cannot help those who cheat themselves.'")
elseif stage == 4 then
    self:emote("cheers wildly, dancing all around the room.")
    wait(0.3)
    self:emote("pants heavily for a moment calming down.")
    wait(0.1)
    self:command("shake " .. actor.name)
    actor:send(self.name .. " says, 'Wonderful, this shows your true dedication to helping one of the brotherhood.'")
    self:command("grin")
    wait(0.2)
    actor:send(self.name .. " says, 'Type <b:black>'subclass'</> to proceed.'")
    actor:complete_quest("monk_subclass")
else
    actor:send(self.name .. " says, 'What a wonderful sash, thank you.'")
    wait(1)
    actor:send(self.name .. " says, 'Shame you were not questing for me, this is a great prize you have given me.'")
end
self:destroy_item("sash")$trig$, '695d430aa664dfd5921e3f559ba54696'),
  -- data/triggers/052/052_08_emmath_flames_receive.lua
  (52, 8, $trig$local dg = require("dg")
local wand_quest = (globals.type or "type") .. "_wand"
local subclass_item, right_item, flameball_item, count

if (object.zone_id == 238 and object.id == 22) then
    get_room(238, 90):at(function()
        run_room_trigger(238, 14)
    end)
    if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep and not dg.flag(actor:get_quest_var(wand_quest .. ":wandtask2")) then
        return true
    elseif actor:get_quest_stage("emmath_flameball") > 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 173 and object.id == 8) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "black" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 52 and object.id == 11) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "white" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
elseif (object.zone_id == 52 and object.id == 12) then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "gray" then
            right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        flameball_item = "yes"
    end
end
if subclass_item then
    wait(0.2)
    self:destroy_item("questobject")
    -- switch on actor:get_quest_stage("pyromancer_subclass")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_stage("pyromancer_subclass") or ""))
        if tonumber(_sw1) == 4 then
            if right_item == "yes" then
                self:emote("hops up down rapidly.")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Goodness the spirit of the flame is complete once again!'")
                self:command("shake " .. tostring(actor.name))
                self:command("grin")
                wait(2)
                actor:complete_quest("pyromancer_subclass")
                actor:command("subclass")
            else
                self:command("eyebrow")
                actor:send(tostring(self.name) .. " says, 'No, I already control this part of the flame.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
            end
        elseif tonumber(_sw1) == 3 then
            self:command("frown " .. tostring(actor.name))
            if right_item == "yes" then
                actor:send(tostring(self.name) .. " says, 'A shame you didn't retrieve the flame yourself.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'Maybe you should do it yourself this time.'")
            else
                actor:send(tostring(self.name) .. " says, 'No, no.  You brought me the wrong flame!'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
            end
        elseif tonumber(_sw1) == 2 or tonumber(_sw1) == 1 then
            actor:send(tostring(self.name) .. " says, 'Curious...  I have not even told you what the quest is yet...'")
        else
            actor:send(tostring(self.name) .. " says, 'What a lovely gift, it will fit nicely on my shelf.'")
            self:command("thank " .. tostring(actor.name))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Shame you were not performing a quest, you seem like a friend of fire.'")
        end
    end
elseif flameball_item then
    if actor:get_quest_stage("emmath_flameball") == 1 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'But I didn't even tell you what I wanted yet!'")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'How do you expect to gain power like this?'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("emmath_flameball") == 2 then
        if (object.zone_id == 52 and object.id == 11) or (object.zone_id == 52 and object.id == 12) or (object.zone_id == 173 and object.id == 8) then
            if (actor:get_quest_var("emmath_flameball:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) ~= 1 then
                count = 1 + (actor:get_quest_var("emmath_flameball:count") or 0)
                actor:set_quest_var("emmath_flameball", "count", count)
                actor:set_quest_var("emmath_flameball", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            else
                actor:send(tostring(self.name) .. " says, 'You have already brought me " .. tostring(object.shortdesc) .. "!'")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                return false  -- legacy return 0: the giver keeps the item
            end
            if count then
                wait(0.2)
                self:destroy_item("questobject")
                -- switch on count
                do
                    local _sw2 = string.lower(tostring(count or ""))
                    if tonumber(_sw2) == 1 then
                        actor:send(tostring(self.name) .. " says, 'Excellent.  That's one.  Two to go.'")
                    elseif tonumber(_sw2) == 2 then
                        actor:send(tostring(self.name) .. " says, 'Good, good.  That's two.  One more!'")
                    elseif tonumber(_sw2) == 3 then
                        actor:advance_quest("emmath_flameball")
                        self:command("smile")
                        actor:send(tostring(self.name) .. " says, 'I'm glad you were able to tame the three flames.'")
                        wait(2)
                        self:command("scratch")
                        actor:send(tostring(self.name) .. " says, 'There is one more, though, a renegade flame.'")
                        wait(1)
                        self:command("sigh")
                        wait(2)
                        actor:send(tostring(self.name) .. " says, 'Some time ago, I battled my counterpart, the illustrious Suralla Iceeye.'")
                        self:emote("looks thoughtful, reminiscing in his mind.")
                        wait(2)
                        actor:send(tostring(self.name) .. " says, 'Nothing terrible came of it, but she succeeded in...'")
                        wait(1)
                        actor:send(tostring(self.name) .. " says, '... changing one of my flames.'")
                        self:emote("looks around himself.")
                        wait(3)
                        actor:send(tostring(self.name) .. " says, 'She was able to meld flame and ice, and form one neither cold nor warm.'")
                        wait(2)
                        self:command("lick")
                        actor:send(tostring(self.name) .. " says, 'I'm sure you understand when I say I cannot allow this flame to exist.'")
                        wait(3)
                        self:command("ponder")
                        actor:send(tostring(self.name) .. " says, 'Return it to me so that I might destroy it.'")
                        wait(7)
                        actor:send(tostring(self.name) .. " says, 'Well, don't wait around all day.'")
                    end
                end
            end
        elseif (object.zone_id == 238 and object.id == 22) then
            self:destroy_item("blue-flame")
            self:command("eye")
            actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.")
            self.room:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
        end
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        if (object.zone_id == 238 and object.id == 22) then
            wait(0.2)
            self:destroy_item("blue-flame")
            actor:send(tostring(self.name) .. " says, 'Ah yes... the blue flame.'")
            self:command("smile self")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Such a pity to destroy such an artifact as this.'")
            self:emote("pauses momentarily.")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'But it must be done.'")
            wait(1)
            self:emote("crushes the blue flame in his hand, its essence evaporating into the air.")
            wait(2)
            self:command("lick")
            wait(2)
            self:command("look " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I?  You seem ready for the power.'")
            actor:erase_quest("emmath_flameball")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
            self.room:spawn_object(52, 10)
            self:command("give ball " .. tostring(actor.name))
        end
    end
end
return _return_value$trig$, 'e18475721da3d79d8b539d94b59f9575'),
  -- data/triggers/052/052_14_emmath_blue_flame_receive.lua
  (52, 14, $trig$-- DG receive arg list (23822): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 238 and object.id == 22)
) then
    return true
end

get_room(238, 90):at(function()
    run_room_trigger(238, 14)
end)
-- flameball
if actor:get_quest_stage("emmath_flameball") == 2 and actor:get_quest_stage("type_wand") ~= "step" then
    wait(0.2)
    self:destroy_item("blue-flame")
    self:command("eye")
    actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.'")
    actor:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    wait(0.2)
    self:destroy_item("blue-flame")
    actor:send(tostring(self.name) .. " says, 'Ah yes... the blue flame.'")
    self:command("smile self")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Such a pity to destroy such an artifact as this.'")
    self:emote("pauses momentarily.")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'But it must be done.'")
    wait(1)
    self:emote("crushes the blue flame in his hand, its essence evaporating into the air.")
    wait(2)
    self:command("lick")
    wait(2)
    self:command("look " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I.  You seem ready for the power.'")
    actor:erase_quest("emmath_flameball")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
    self.room:spawn_object(52, 10)
    self:command("give ball " .. tostring(actor.name))
end
-- TODO: phase-wand branch elided pending crafting-quest schema rewrite.
-- The legacy DG required globals `step`, `type`, `weapon` and used
-- `%type%_wand` percent-substituted quest names; none of those exist in
-- the Lua runtime. Re-introduce after the type_wand quest is redesigned.
return true$trig$, '9374e6ef972118d2da72c5744508ab89'),
  -- data/triggers/053/053_13_beast_master_ranger_trophy_receive.lua
  (53, 13, $trig$-- Converted from DG Script #5313: Beast Master Ranger Trophy receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt notices here
local stage, victim1, go, trophystage, item
if (object.zone_id == 53 and object.id == 0) then
    stage = 1
    victim1 = "an abominable slime creature"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 1) then
    stage = 2
    victim1 = "a large buck"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 2) then
    stage = 3
    victim1 = "the giant scorpion"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 3) then
    stage = 4
    victim1 = "a monstrous canopy spider"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 4) then
    stage = 5
    victim1 = "the chimera"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 5) then
    stage = 6
    victim1 = "the drider king"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 6) then
    stage = 7
    victim1 = "a beholder"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 7) then
    stage = 8
    victim1 = "the Banshee"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 8) then
    stage = 9
    victim1 = "Baba Yaga"
    go = "hunt"
elseif (object.zone_id == 53 and object.id == 9) then
    stage = 10
    victim1 = "the medusa"
    go = "hunt"
    -- ranger trophy items start here
elseif object.id == 370 then
    trophystage = 1
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 16 and object.id == 7) then
    trophystage = 1
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 79) then
    trophystage = 1
    item = "gem"
    go = "trophy"
elseif object.id == 371 then
    trophystage = 2
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 178 and object.id == 6) then
    trophystage = 2
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 555 and object.id == 91) then
    trophystage = 2
    item = "gem"
    go = "trophy"
elseif object.id == 372 then
    trophystage = 3
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 18 and object.id == 5) then
    trophystage = 3
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 28) then
    trophystage = 3
    item = "gem"
    go = "trophy"
elseif object.id == 373 then
    trophystage = 4
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 625 and object.id == 13) then
    trophystage = 4
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 52) then
    trophystage = 4
    item = "gem"
    go = "trophy"
elseif object.id == 374 then
    trophystage = 5
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 238 and object.id == 3) then
    trophystage = 5
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 64) then
    trophystage = 5
    item = "gem"
    go = "trophy"
elseif object.id == 375 then
    trophystage = 6
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 430 and object.id == 9) then
    trophystage = 6
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 556 and object.id == 85) then
    trophystage = 6
    item = "gem"
    go = "trophy"
elseif object.id == 376 then
    trophystage = 7
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 470 and object.id == 8) then
    trophystage = 7
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 5) then
    trophystage = 7
    item = "gem"
    go = "trophy"
elseif object.id == 377 then
    trophystage = 8
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 533 and object.id == 23) or (object.zone_id == 533 and object.id == 11) then
    trophystage = 8
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 29) then
    trophystage = 8
    item = "gem"
    go = "trophy"
elseif object.id == 378 then
    trophystage = 9
    item = "quest"
    go = "trophy"
elseif (object.zone_id == 520 and object.id == 14) then
    trophystage = 9
    item = "trophy"
    go = "trophy"
elseif (object.zone_id == 557 and object.id == 41) then
    trophystage = 9
    item = "gem"
    go = "trophy"
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What is this for?")
    return false  -- legacy return 0: the giver keeps the item
end
if go == "hunt" then
    if actor:get_quest_stage("beast_master") == "stage" and actor:get_quest_var("beast_master:hunt") == "dead" then
        wait(0.2)
        world.destroy(object)
        self:command("cheer")
        actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        local expcap
        if stage == 1 then
            expcap = 5
        else
            local bonus = (stage - 1) * 10
            expcap = bonus
        end
        local expmod
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
        local anti = "Anti-Paladin"
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        else
            expmod = expmod
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("beast_master", "target1", 0)
        actor:set_quest_var("beast_master", "hunt", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more hunts.'")
        else
            actor:complete_quest("beast_master")
            actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest Beast Masters in the realm!'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take these gloves.  Wear them to show everyone your unstoppable prowess.'")
            self.room:spawn_object(4, 13)
            self:command("give gloves " .. tostring(actor))
        end
        if (string.find(actor.class, "ranger") or string.find(actor.class, "warrior") or string.find(actor.class, "berserker") or string.find(actor.class, "mercenary")) and actor:get_quest_stage("ranger_trophy") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 170)
            self:command("give trophy " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Trophies like these are proof of your skill as a hunter.'")
            actor:start_quest("ranger_trophy")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This is an opportune time to further demonstrate your <b:cyan>[skill]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that trophy after you reach level 10.  We can discuss your skills then.'")
            end
        end
    elseif actor:get_quest_stage("beast_master") > stage then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the notice.")
        actor:send(tostring(self.name) .. " says, 'You already killed this creature!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("beast_master") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the notice!")
        world.destroy(object)
    elseif actor:get_quest_var("beast_master:hunt") ~= "dead" then
        self.room:send(tostring(self.name) .. " refuses the notice.")
        actor:send(tostring(self.name) .. " says, 'You have to slay kill the beast first!  " .. tostring(victim1) .. " is still out there.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif go == "trophy" then
    if actor.class ~= "warrior" and actor.class ~= "ranger" and actor.class ~= "mercenary" and actor.class ~= "berserker" then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, '" .. tostring(actor.class) .. "s aren't fit for these kinds of tests.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("beast_master") < actor:get_quest_stage("ranger_trophy") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Defeat some more monsters first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor.level < (actor:get_quest_stage("ranger_trophy") * 10) then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif trophystage > actor:get_quest_stage("ranger_trophy") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You don't need that to demonstrate your skills yet.  Be patient!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif trophystage < actor:get_quest_stage("ranger_trophy") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You've already used that as proof.'")
        return false  -- legacy return 0: the giver keeps the item
    else
        local accept
        if item == "quest" then
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've demonstrated your skills well.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give trophy " .. tostring(actor))
                local expcap = trophystage * 10
                local expmod
                if expcap < 17 then
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
                -- switch on actor.class
                if actor.class == "warrior" or actor.class == "berserker" then
                    expmod = (expmod + (expmod / 10))
                elseif actor.class == "ranger" then
                    expmod = (expmod + ((expmod * 2) / 15))
                else
                    expmod = expmod
                end
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    actor:set_quest_var("ranger_trophy", "trophytask%number%", 0)
                    number = number + 1
                end
                if actor:get_quest_stage("ranger_trophy") < 9 then
                    actor:advance_quest("ranger_trophy")
                else
                    actor:complete_quest("ranger_trophy")
                end
            else
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you exchange your trophy!'")
                return false  -- legacy return 0: the giver keeps the item
            end
        elseif item == "trophy" then
            local task2 = actor:get_quest_var("ranger_trophy:trophytask2")
            if task2 == object.id or ((object.zone_id == 533 and object.id == 11) and (task2 or 0) == 53323) or ((object.zone_id == 533 and object.id == 23) and (task2 or 0) == 53311) then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("ranger_trophy:trophytask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("ranger_trophy", "trophytask3", object.id)
            end
        end
        if accept == "no" then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("ranger_trophy:trophytask1")
            local job2 = actor:get_quest_var("ranger_trophy:trophytask2")
            local job3 = actor:get_quest_var("ranger_trophy:trophytask3")
            local job4 = actor:get_quest_var("ranger_trophy:trophytask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your current trophy.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '94537dae1773d7d0679b374fb2a7ba79'),
  -- data/triggers/053/053_23_honus_order_receive.lua
  (53, 23, $trig$-- Converted from DG Script #5323: Honus order receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- hunt orders here
local stage, treasure1
if (object.zone_id == 53 and object.id == 10) then
    stage = 1
    treasure1 = "a singing chain"
elseif (object.zone_id == 53 and object.id == 11) then
    stage = 2
    treasure1 = "a fire ring"
elseif (object.zone_id == 53 and object.id == 12) then
    stage = 3
    treasure1 = "a sandstone ring"
elseif (object.zone_id == 53 and object.id == 13) then
    stage = 4
    treasure1 = "a crimson-tinged electrum hoop"
elseif (object.zone_id == 53 and object.id == 14) then
    stage = 5
    treasure1 = "a Rainbow Shell"
elseif (object.zone_id == 53 and object.id == 15) then
    stage = 6
    treasure1 = "the Stormshield"
elseif (object.zone_id == 53 and object.id == 16) then
    stage = 7
    treasure1 = "the Snow Leopard Cloak"
elseif (object.zone_id == 53 and object.id == 17) then
    stage = 8
    treasure1 = "a coiled rope ladder"
elseif (object.zone_id == 53 and object.id == 18) then
    stage = 9
    treasure1 = "a glowing phoenix feather"
elseif (object.zone_id == 53 and object.id == 19) then
    stage = 10
    treasure1 = "a piece of sleet armor"
end
if actor:get_quest_stage("treasure_hunter") == "stage" and actor:get_quest_var("treasure_hunter:hunt") == "returned" then
    local anti = "Anti-Paladin"
    wait(0.2)
    world.destroy(object)
    self:command("cheer")
    actor:send(tostring(self.name) .. " says, 'Congratulations!  Here's your reward.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
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
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("treasure_hunter", "treasure1", 0)
    actor:set_quest_var("treasure_hunter", "hunt", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
    else
        actor:complete_quest("treasure_hunter")
        actor:send(tostring(self.name) .. " says, 'You have earned your place among the greatest treasure hunters in the realm!'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Here, take this bracelet as payment for all you've done.  Wear this proudly.'")
        self.room:spawn_object(123, 117)
        self:command("give bracelet " .. tostring(actor))
    end
    if (string.find(actor.class, "rogue") or string.find(actor.class, "thief") or string.find(actor.class, "bard")) and actor:get_quest_stage("rogue_cloak") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
        self.room:spawn_object(2, 180)
        self:command("give cloak " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Cloaks like these show off your rank in the various cloak and dagger guilds.'")
        actor:start_quest("rogue_cloak")
        wait(2)
        if actor.level > 9 then
            actor:send(tostring(self.name) .. " says, 'This puts you in line for a <b:cyan>[promotion]</>.'")
        else
            actor:send(tostring(self.name) .. " says, 'Come back with that cloak after you reach level 10.  We can discuss a promotion then.'")
        end
    end
elseif actor:get_quest_stage("treasure_hunter") > stage then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_stage("treasure_hunter") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the order!")
    world.destroy(object)
elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You have to find the treasure still!  " .. tostring(treasure1) .. " is still out there.")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    self.room:send(tostring(self.name) .. " refuses the order.")
    actor:send(tostring(self.name) .. " says, 'You have to give me the treasure first!  You still have " .. tostring(treasure1) .. " in your possession.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '3f1ddbb0a489ed37577e6dfffd1f8223'),
  -- data/triggers/053/053_25_honus_treasure_receive.lua
  (53, 25, $trig$-- Converted from DG Script #5325: Honus treasure receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local accept, refuse
local _return_value = true  -- Default: allow action
-- switch on object.id
local stage
if (object.zone_id == 615 and object.id == 14) then
    -- singing chain
    stage = 1
elseif (object.zone_id == 43 and object.id == 19) then
    -- fire ring
    stage = 2
elseif (object.zone_id == 161 and object.id == 3) then
    -- sandstone ring
    stage = 3
elseif (object.zone_id == 502 and object.id == 15) then
    -- electrum hoop
    stage = 4
elseif (object.zone_id == 481 and object.id == 1) then
    -- rainbow shell
    stage = 5
elseif (object.zone_id == 160 and object.id == 9) then
    -- stormshield
    stage = 6
elseif (object.zone_id == 550 and object.id == 8) then
    -- snow leopard cloak
    stage = 7
elseif (object.zone_id == 490 and object.id == 41) then
    -- rope ladder
    stage = 8
elseif (object.zone_id == 584 and object.id == 1) then
    -- phoenix feather
    stage = 9
elseif (object.zone_id == 534 and object.id == 100) or (object.zone_id == 534 and object.id == 101) or (object.zone_id == 534 and object.id == 105) or (object.zone_id == 534 and object.id == 106) then
    -- sleet armor
    stage = 10
end
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("treasure_hunter") == "stage" then
            if person:get_quest_var("treasure_hunter:hunt") == "found" then
                person:set_quest_var("treasure_hunter", "hunt", "returned")
                accept = 1
                refuse = 0
            elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
                if accept then
                    refuse = 0
                else
                    refuse = 1
                end
            elseif actor:get_quest_var("treasure_hunter:hunt") == "returned" then
                if accept then
                    refuse = 0
                else
                    refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") > stage then
                if accept then
                    refuse = 0
                else
                    refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") < stage then
                if accept then
                    refuse = 0
                else
                    refuse = 3
                end
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if accept == 1 then
    wait(0.2)
    world.destroy(object)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Excellent!  Now just give me the order paperwork and I can pay you.'")
elseif refuse then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    if refuse == 1 then
        self.room:send(tostring(self.name) .. " says, 'Nah nah nah, you gotta put in at least a little effort toward finding this yourself, come on.'")
    elseif refuse == 2 then
        self.room:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    elseif refuse == 3 then
        self.room:send(tostring(self.name) .. " says, 'I'm not looking for that...  Yet.'")
    end
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '7300f4fd202eaf53de78dca53b354726'),
  -- data/triggers/053/053_26_honus_cloak_receive.lua
  (53, 26, $trig$-- Converted from DG Script #5326: Honus cloak receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
local cloakstage, item
do
    if (object.zone_id == 2 and object.id == 180) then
        cloakstage = 1
        item = "quest"
    elseif (object.zone_id == 588 and object.id == 1) then
        cloakstage = 1
        item = "cloak"
    elseif (object.zone_id == 555 and object.id == 85) then
        cloakstage = 1
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 181) then
        cloakstage = 2
        item = "quest"
    elseif (object.zone_id == 173 and object.id == 7) then
        cloakstage = 2
        item = "cloak"
    elseif (object.zone_id == 555 and object.id == 93) then
        cloakstage = 2
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 182) then
        cloakstage = 3
        item = "quest"
    elseif (object.zone_id == 103 and object.id == 8) then
        cloakstage = 3
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 19) then
        cloakstage = 3
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 183) then
        cloakstage = 4
        item = "quest"
    elseif (object.zone_id == 123 and object.id == 25) then
        cloakstage = 4
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 59) then
        cloakstage = 4
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 184) then
        cloakstage = 5
        item = "quest"
    elseif (object.zone_id == 430 and object.id == 22) then
        cloakstage = 5
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 63) then
        cloakstage = 5
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 185) then
        cloakstage = 6
        item = "quest"
    elseif (object.zone_id == 238 and object.id == 10) then
        cloakstage = 6
        item = "cloak"
    elseif (object.zone_id == 556 and object.id == 74) then
        cloakstage = 6
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 186) then
        cloakstage = 7
        item = "quest"
    elseif (object.zone_id == 510 and object.id == 13) then
        cloakstage = 7
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 14) then
        cloakstage = 7
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 187) then
        cloakstage = 8
        item = "quest"
    elseif (object.zone_id == 584 and object.id == 10) then
        cloakstage = 8
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 40) then
        cloakstage = 8
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 188) then
        cloakstage = 9
        item = "quest"
    elseif (object.zone_id == 520 and object.id == 9) then
        cloakstage = 9
        item = "cloak"
    elseif (object.zone_id == 557 and object.id == 41) then
        cloakstage = 9
        item = "gem"
    end
end
if actor:get_quest_stage("treasure_hunter") < actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Find some more treasure first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor.level < (actor:get_quest_stage("rogue_cloak") * 10) then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif cloakstage > actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Your promotion doesn't involve that yet.  Be patient!'")
    return false  -- legacy return 0: the giver keeps the item
elseif cloakstage < actor:get_quest_stage("rogue_cloak") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You've already earned that promotion.'")
    return false  -- legacy return 0: the giver keeps the item
else
    local accept
    if item == "quest" then
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        if job1 and job2 and job3 and job4 then
            wait(0.2)
            local reward = object.id + 1
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your promotion.'")
            self.room:spawn_object(math.floor(reward / 100), reward % 100)
            self:command("give cloak " .. tostring(actor))
            local expcap = cloakstage * 10
            local expmod
            if expcap < 17 then
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
            expmod = expmod + ((expmod * 2) / 15)
            actor:send("<b:yellow>You gain experience!</>")
            local setexp = (expmod * 10)
            local loop = 0
            while loop < 7 do
                actor:award_exp(setexp)
                loop = loop + 1
            end
            local number = 1
            while number < 5 do
                actor:set_quest_var("rogue_cloak", "cloaktask%number%", 0)
                number = number + 1
            end
            if actor:get_quest_stage("rogue_cloak") < 9 then
                actor:advance_quest("rogue_cloak")
            else
                actor:complete_quest("rogue_cloak")
            end
        else
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your cloak!'")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif item == "cloak" then
        if actor:get_quest_var("rogue_cloak:cloaktask2") == object.id then
            accept = "no"
        else
            accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask2", object.id)
        end
    elseif item == "gem" then
        if actor:get_quest_var("rogue_cloak:cloaktask3") == object.id then
            accept = "no"
        else
            accept = "yes"
            actor:set_quest_var("rogue_cloak", "cloaktask3", object.id)
        end
    end
    if accept == "no" then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif accept == "yes" then
        wait(0.2)
        world.destroy(object)
        local job1 = actor:get_quest_var("rogue_cloak:cloaktask1")
        local job2 = actor:get_quest_var("rogue_cloak:cloaktask2")
        local job3 = actor:get_quest_var("rogue_cloak:cloaktask3")
        local job4 = actor:get_quest_var("rogue_cloak:cloaktask4")
        if job1 and job2 and job3 and job4 then
            actor:send(tostring(self.name) .. " says, 'Excellent.  Now trade in your cloak for your promotion.'")
        else
            actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
        end
    end
end
return _return_value$trig$, '23d2d035c426f045c854974c868fa877'),
  -- data/triggers/053/053_31_honus_receive_refuse.lua
  (53, 31, $trig$-- Converted from DG Script #5331: Honus receive refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local treasurestage = actor:get_quest_stage("treasure_hunter")
local cloakstage = actor:get_quest_stage("rogue_cloak")
-- switch on object.id
if object.id == 380 or (object.zone_id == 588 and object.id == 1) or (object.zone_id == 555 and object.id == 85) or object.id == 381 or (object.zone_id == 173 and object.id == 7) or (object.zone_id == 555 and object.id == 93) or object.id == 382 or (object.zone_id == 103 and object.id == 8) or (object.zone_id == 556 and object.id == 19) or object.id == 383 or (object.zone_id == 123 and object.id == 25) or (object.zone_id == 556 and object.id == 59) or object.id == 384 or (object.zone_id == 430 and object.id == 22) or (object.zone_id == 556 and object.id == 63) or object.id == 385 or (object.zone_id == 238 and object.id == 10) or (object.zone_id == 556 and object.id == 74) or object.id == 386 or (object.zone_id == 510 and object.id == 13) or (object.zone_id == 557 and object.id == 14) or object.id == 387 or (object.zone_id == 584 and object.id == 10) or (object.zone_id == 557 and object.id == 40) or object.id == 388 or (object.zone_id == 520 and object.id == 9) or (object.zone_id == 557 and object.id == 41) or (object.zone_id == 615 and object.id == 14) or (object.zone_id == 53 and object.id == 10) or (object.zone_id == 43 and object.id == 19) or (object.zone_id == 53 and object.id == 11) or (object.zone_id == 161 and object.id == 3) or (object.zone_id == 53 and object.id == 12) or (object.zone_id == 502 and object.id == 15) or (object.zone_id == 53 and object.id == 13) or (object.zone_id == 481 and object.id == 1) or (object.zone_id == 53 and object.id == 14) or (object.zone_id == 160 and object.id == 9) or (object.zone_id == 53 and object.id == 15) or (object.zone_id == 550 and object.id == 8) or (object.zone_id == 53 and object.id == 16) or (object.zone_id == 490 and object.id == 41) or (object.zone_id == 53 and object.id == 17) or (object.zone_id == 584 and object.id == 1) or (object.zone_id == 53 and object.id == 18) or (object.zone_id == 534 and object.id == 100) or (object.zone_id == 534 and object.id == 101) or (object.zone_id == 534 and object.id == 105) or (object.zone_id == 534 and object.id == 106) or (object.zone_id == 53 and object.id == 19) then
    return _return_value
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '0ccad5ee34a32e9eb36cf2fb773ba390'),
  -- data/triggers/053/053_38_elemental_chaos_hakujo_mission_receive.lua
  (53, 38, $trig$-- Converted from DG Script #5338: Elemental Chaos Hakujo mission receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
-- mission targets here
local stage, target1
if (object.zone_id == 53 and object.id == 20) then
    stage = 1
    target1 = "an imp"
elseif (object.zone_id == 53 and object.id == 21) then
    stage = 2
    target1 = "the Leading Player"
elseif (object.zone_id == 53 and object.id == 22) then
    stage = 3
    target1 = "the Chaos"
elseif (object.zone_id == 53 and object.id == 23) then
    stage = 4
    target1 = "whatever waits at the end of the shaman's vision quest"
elseif (object.zone_id == 53 and object.id == 24) then
    stage = 5
    target1 = "the Fangs of Yeenoghu"
elseif (object.zone_id == 53 and object.id == 25) then
    stage = 6
    target1 = "the fire elemental lord"
elseif (object.zone_id == 53 and object.id == 26) then
    stage = 7
    target1 = "an acolyte of Betrayal"
elseif (object.zone_id == 53 and object.id == 27) then
    stage = 8
    target1 = "for Cyprianum the Reaper"
elseif (object.zone_id == 53 and object.id == 28) then
    stage = 9
    target1 = "a Chaos Demon"
elseif (object.zone_id == 53 and object.id == 29) then
    stage = 10
    target1 = "the Norhamen"
end
if actor:get_quest_stage("elemental_chaos") == "stage" and actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    local anti = "Anti-Paladin"
    wait(0.2)
    world.destroy(object)
    self:command("bow")
    actor:send(tostring(self.name) .. " says, 'Harmony follows your actions.'")
    local money = stage * 10
    self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
    local expcap
    if stage == 1 then
        expcap = 5
    else
        local bonus = (stage - 1) * 10
        expcap = bonus
    end
    local expmod
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
    -- switch on actor.class
    if actor.class == "warrior" or actor.class == "berserker" then
        expmod = (expmod + (expmod / 10))
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        expmod = (expmod + ((expmod * 2) / 15))
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        expmod = (expmod + (expmod / 5))
    elseif actor.class == "necromancer" or actor.class == "monk" then
        expmod = (expmod + (expmod * 2) / 5)
    else
        expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 3 do
        actor:award_exp(setexp)
        loop = loop + 1
    end
    actor:set_quest_var("elemental_chaos", "target1", 0)
    actor:set_quest_var("elemental_chaos", "bounty", 0)
    wait(0.2)
    if stage < 10 then
        actor:advance_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'I will investigate further.  Return later and I shall tell you my findings.'")
    else
        actor:complete_quest("elemental_chaos")
        actor:send(tostring(self.name) .. " says, 'You have done Balance a great service.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'May this ring ever remind you to ever walk the Way.'")
        self.room:spawn_object(123, 106)
        self:command("give ring " .. tostring(actor))
    end
    if string.find(actor.class, "monk") and actor:get_quest_stage("monk_vision") == 0 then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You are ready to begin your own path to <b:cyan>[Enlightenment]</>.'")
        self.room:spawn_object(2, 190)
        self:command("give vision " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " says, 'These markings represent your voyage.'")
        actor:start_quest("monk_vision")
        wait(2)
        if actor.level < 10 then
            actor:send(tostring(self.name) .. " says, 'Come back with that vision after you reach level 10.  We can discuss your voyage toward enlightenment then.'")
        end
    end
elseif actor:get_quest_stage("elemental_chaos") > stage then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses the mission.")
    actor:send(tostring(self.name) .. " says, 'You already accomplished this!'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_stage("elemental_chaos") < stage then
    wait(0.2)
    self:command("eye " .. tostring(actor))
    actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
    self.room:send(tostring(self.name) .. " rips up the mission!")
    world.destroy(object)
elseif actor:get_quest_var("elemental_chaos:bounty") == "running" then
    self.room:send(tostring(self.name) .. " refuses the mission.")
    actor:send(tostring(self.name) .. " says, 'You have to complete your mission first!")
    if stage == 5 then
        actor:send(tostring(target1) .. " are still out there.'")
    else
        actor:send(tostring(target1) .. " is still out there.'")
    end
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'b3944f11115d0e3b604740d07cbfeb55'),
  -- data/triggers/053/053_40_monk_vision_hakujo_receive.lua
  (53, 40, $trig$-- Converted from DG Script #5340: Monk Vision Hakujo receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
local visionstage, item
do
    if (object.zone_id == 2 and object.id == 190) then
        visionstage = 1
        item = "quest"
    elseif (object.zone_id == 590 and object.id == 6) then
        visionstage = 1
        item = "book"
    elseif (object.zone_id == 555 and object.id == 82) then
        visionstage = 1
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 191) then
        visionstage = 2
        item = "quest"
    elseif (object.zone_id == 185 and object.id == 5) then
        visionstage = 2
        item = "book"
    elseif (object.zone_id == 555 and object.id == 91) then
        visionstage = 2
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 192) then
        visionstage = 3
        item = "quest"
    elseif (object.zone_id == 85 and object.id == 1) then
        visionstage = 3
        item = "book"
    elseif (object.zone_id == 556 and object.id == 23) then
        visionstage = 3
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 193) then
        visionstage = 4
        item = "quest"
    elseif (object.zone_id == 125 and object.id == 32) then
        visionstage = 4
        item = "book"
    elseif (object.zone_id == 556 and object.id == 55) then
        visionstage = 4
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 194) then
        visionstage = 5
        item = "quest"
    elseif (object.zone_id == 162 and object.id == 9) then
        visionstage = 5
        item = "book"
    elseif (object.zone_id == 556 and object.id == 65) then
        visionstage = 5
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 195) then
        visionstage = 6
        item = "quest"
    elseif (object.zone_id == 430 and object.id == 13) then
        visionstage = 6
        item = "book"
    elseif (object.zone_id == 556 and object.id == 78) then
        visionstage = 6
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 196) then
        visionstage = 7
        item = "quest"
    elseif (object.zone_id == 530 and object.id == 9) then
        visionstage = 7
        item = "book"
    elseif (object.zone_id == 557 and object.id == 10) then
        visionstage = 7
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 197) then
        visionstage = 8
        item = "quest"
    elseif (object.zone_id == 584 and object.id == 15) then
        visionstage = 8
        item = "book"
    elseif (object.zone_id == 557 and object.id == 22) then
        visionstage = 8
        item = "gem"
    elseif (object.zone_id == 2 and object.id == 198) then
        visionstage = 9
        item = "quest"
    elseif (object.zone_id == 584 and object.id == 12) then
        visionstage = 9
        item = "book"
    elseif (object.zone_id == 557 and object.id == 41) then
        visionstage = 9
        item = "gem"
    end
end
if actor:get_quest_stage("elemental_chaos") < actor:get_quest_stage("monk_vision") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Undertake more missions in service of Balance first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor.level < (actor:get_quest_stage("monk_vision") * 10) then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
    return false  -- legacy return 0: the giver keeps the item
elseif visionstage > actor:get_quest_stage("monk_vision") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Your vision doesn't involve that yet.  Be patient!'")
    return false  -- legacy return 0: the giver keeps the item
elseif visionstage < actor:get_quest_stage("monk_vision") then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'You've already seen that vision.'")
    return false  -- legacy return 0: the giver keeps the item
else
    local accept
    if item == "quest" then
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        if job1 and job2 and job3 and job4 then
            wait(0.2)
            local reward = object.id + 1
            world.destroy(object)
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'Well done!  You've earned your next vision mark.'")
            self.room:spawn_object(math.floor(reward / 100), reward % 100)
            self:command("give vision " .. tostring(actor))
            local expcap = visionstage * 10
            local expmod
            if expcap < 17 then
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
            expmod = expmod + ((expmod * 2) / 15)
            actor:send("<b:yellow>You gain experience!</>")
            local setexp = (expmod * 10)
            local loop = 0
            while loop < 7 do
                actor:award_exp(setexp)
                loop = loop + 1
            end
            local number = 1
            while number < 5 do
                actor:set_quest_var("monk_vision", "visiontask%number%", 0)
                number = number + 1
            end
            if actor:get_quest_stage("monk_vision") < 9 then
                actor:advance_quest("monk_vision")
            else
                actor:complete_quest("monk_vision")
            end
            if actor:get_quest_stage("monk_vision") >= 4 then
                wait(2)
                if actor:get_quest_stage("monk_chants") == 0 then
                    actor:send(tostring(self.name) .. " says, 'Your awareness has grown enough to handle the esoteric <b:cyan>[chants]</>.  I can give you instruction if you wish.'")
                elseif (actor:get_quest_stage("monk_chants") == 7 and actor.level < 75) or (actor:get_quest_stage("monk_chants") > 9 and actor.level < 99) then
                    actor:send(tostring(self.name) .. " says, 'You will be ready for a new chant once you have gained more experience.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Your awareness has grown enough to comprehend a new esoteric <b:cyan>[chant]</>.'")
                end
            end
        else
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You need to do everything else before you trade in your vision mark!'")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif item == "book" or item == "gem" then
        if not actor:get_quest_var("monk_vision:visiontask4") then
            self:command("shake")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(actor) .. " " .. tostring(self.name) .. " says, 'You need to bring the gem and the text to the prescribed place and read first.'")
            return false  -- legacy return 0: the giver keeps the item
        else
            if item == "book" then
                if actor:get_quest_var("monk_vision:visiontask3") == object.id then
                    accept = "no"
                else
                    accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask3", object.id)
                end
            elseif item == "gem" then
                if actor:get_quest_var("monk_vision:visiontask2") == object.id then
                    accept = "no"
                else
                    accept = "yes"
                    actor:set_quest_var("monk_vision", "visiontask2", object.id)
                end
            end
        end
    end
    if accept == "no" then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif accept == "yes" then
        wait(0.2)
        world.destroy(object)
        local job1 = actor:get_quest_var("monk_vision:visiontask1")
        local job2 = actor:get_quest_var("monk_vision:visiontask2")
        local job3 = actor:get_quest_var("monk_vision:visiontask3")
        local job4 = actor:get_quest_var("monk_vision:visiontask4")
        if job1 and job2 and job3 and job4 then
            actor:send(tostring(self.name) .. " says, 'Excellent.  Now trade in your current vision mark.'")
        else
            actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
        end
    end
end
return _return_value$trig$, '7ab25f92e0482d375755bd5f882e9721'),
  -- data/triggers/053/053_44_hakujo_refuse.lua
  (53, 44, $trig$-- Converted from DG Script #5344: Hakujo refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local treasurestage = actor:get_quest_stage("elemental_chaos")
local visionstage = actor:get_quest_stage("monk_vision")
-- switch on object.id
if object.id == 390 or (object.zone_id == 590 and object.id == 6) or (object.zone_id == 555 and object.id == 82) or object.id == 391 or (object.zone_id == 185 and object.id == 5) or (object.zone_id == 555 and object.id == 91) or object.id == 392 or (object.zone_id == 85 and object.id == 1) or (object.zone_id == 556 and object.id == 23) or object.id == 393 or (object.zone_id == 125 and object.id == 32) or (object.zone_id == 556 and object.id == 55) or object.id == 394 or (object.zone_id == 162 and object.id == 9) or (object.zone_id == 556 and object.id == 65) or object.id == 395 or (object.zone_id == 430 and object.id == 13) or (object.zone_id == 556 and object.id == 78) or object.id == 396 or (object.zone_id == 530 and object.id == 9) or (object.zone_id == 557 and object.id == 10) or object.id == 397 or (object.zone_id == 584 and object.id == 15) or (object.zone_id == 557 and object.id == 22) or object.id == 398 or (object.zone_id == 584 and object.id == 12) or (object.zone_id == 557 and object.id == 41) or (object.zone_id == 53 and object.id == 20) or (object.zone_id == 53 and object.id == 21) or (object.zone_id == 53 and object.id == 22) or (object.zone_id == 53 and object.id == 23) or (object.zone_id == 53 and object.id == 24) or (object.zone_id == 53 and object.id == 25) or (object.zone_id == 53 and object.id == 26) or (object.zone_id == 53 and object.id == 27) or (object.zone_id == 53 and object.id == 28) or (object.zone_id == 53 and object.id == 29) then
    return _return_value
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'What is this for?'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '9d01fade9575a8ea81d42878159e6838'),
  -- data/triggers/053/053_55_hell_trident_receive.lua
  (53, 55, $trig$-- Converted from DG Script #5355: Hell Trident receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local function proto_key(vnum)
    vnum = tonumber(vnum)
    if not vnum then return nil end
    local zone = math.floor(vnum / 100)
    if zone == 0 then zone = 1000 end
    return zone, vnum % 100
end
local function proto_short(vnum)
    local zone, id = proto_key(vnum)
    local name = zone and objects.template(zone, id).name
    if not name or name == "" then return "[no description for object " .. tostring(vnum) .. "]" end
    return name
end
local function proto_noa(vnum)
    local zone, id = proto_key(vnum)
    if not zone then return "[no description for object " .. tostring(vnum) .. "]" end
    return get_obj_noadesc(zone, id)
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = proto_noa(vnum)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
local _return_value = true  -- Default: allow action
local hellstage = actor:get_quest_stage("hell_trident")
-- switch on self.id
-- Black Priestess p2
local reward, phase, level, spell1, spell2, go
if (self.zone_id == 60 and self.id == 32) then
    reward = 39
    phase = 1
    level = 65
    spell1 = actor:get_has_completed("banish")
    spell2 = actor:get_has_completed("hellfire_brimstone")
    if not actor:get_quest_var("hell_trident:helltask6") then
        if actor:get_quest_stage("vilekka_stew") > 3 then
            actor:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    if (object.zone_id == 556 and object.id == 62) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 34) then
        go = "trident"
    end
elseif (self.zone_id == 125 and self.id == 26) then
    reward = 40
    phase = 2
    level = 90
    spell1 = actor:get_has_completed("resurrection_quest")
    spell2 = actor:get_has_completed("hell_gate")
    if (object.zone_id == 557 and object.id == 39) then
        go = "gem"
    elseif (object.zone_id == 23 and object.id == 39) then
        go = "trident"
    end
end
-- adding in case it's not caught somewhere else
if hellstage == "phase" then
    if not actor:get_quest_var("hell_trident:helltask5") then
        if spell1 then
            actor:set_quest_var("hell_trident", "helltask5", 1)
        end
    end
    if not actor:get_quest_var("hell_trident:helltask4") then
        if spell2 then
            actor:set_quest_var("hell_trident", "helltask4", 1)
        end
    end
end
local refuse, reason
if actor:get_has_completed("hell_trident") then
    go = nil
    refuse = 1
    reason = "You already command the greatest power imaginable!"
elseif actor.level < level then
    go = nil
    refuse = 1
    reason = "You are not yet strong enough to handle more power."
elseif hellstage < phase then
    go = nil
    refuse = 1
    reason = "Your trident is not ready to upgrade yet."
elseif hellstage > phase then
    go = nil
    refuse = 1
    reason = "I've already done everything I can to help."
end
local refuse, reason
if go == "gem" then
    local gem_id = object.id
    local gem_count = actor:get_quest_var("hell_trident:gems") or 0
    if gem_count < 6 then
        wait(0.2)
        world.destroy(object.name)
        gem_count = gem_count + 1
        actor:set_quest_var("hell_trident", "gems", gem_count)
        actor:send(tostring(self.name) .. " says, 'Yes, this is perfect.'")
        wait(0.2)
        if gem_count == 1 then
            actor:send(tostring(self.name) .. " says, 'You have given me 1 of 6 " .. proto_plural(gem_id) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'You have given me " .. tostring(gem_count) .. " of 6 " .. proto_plural(gem_id) .. ".'")
        end
        wait(0.2)
        if gem_count >= 6 then
            actor:set_quest_var("hell_trident", "helltask3", 1)
            local job1 = actor:get_quest_var("hell_trident:helltask1")
            local job2 = actor:get_quest_var("hell_trident:helltask2")
            local job3 = actor:get_quest_var("hell_trident:helltask3")
            local job4 = actor:get_quest_var("hell_trident:helltask4")
            local job5 = actor:get_quest_var("hell_trident:helltask5")
            local job6 = actor:get_quest_var("hell_trident:helltask6")
            if job1 and job2 and job3 and job4 and job5 and job6 then
                actor:send(tostring(self.name) .. " says, 'Now present the trident.'")
            else
                actor:send(tostring(self.name) .. " says, 'Complete your other sacrifices then return to me.'")
            end
        end
    else
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You have already given me 6 " .. proto_plural(gem_id) .. ".'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif go == "trident" then
    local job1 = actor:get_quest_var("hell_trident:helltask1")
    local job2 = actor:get_quest_var("hell_trident:helltask2")
    local job3 = actor:get_quest_var("hell_trident:helltask3")
    local job4 = actor:get_quest_var("hell_trident:helltask4")
    local job5 = actor:get_quest_var("hell_trident:helltask5")
    local job6 = actor:get_quest_var("hell_trident:helltask6")
    if job1 and job2 and job3 and job4 and job5 and job6 then
        wait(0.2)
        world.destroy(object)
        if (self.zone_id == 125 and self.id == 26) then
            actor:send(tostring(self.name) .. " says, 'We are pleased.'")
            self:command("grin")
            wait(1)
            self.room:send(tostring(self.name) .. " turns and faces out into the endless void of his vast realm.")
            wait(1)
            self.room:send(tostring(self.name) .. " growls, 'Ir ya roza aem ya iz ednuyt...'")
            wait(2)
            self.room:send("The inner <b:blue>ire</> of the " .. get_obj_noadesc(23, 39) .. " ignites and <red>b<blue>urn</><red>s</>!")
            wait(2)
            self.room:send(tostring(self.name) .. " roars, 'Liy ya gaoh yaezk'aqa, ir ya aehg mol'tiaer I kiwa yiz laodaer zes mina...'")
            wait(2)
            self.room:send(tostring(self.name) .. " erupts in glorious <red>f<blue>l<yellow>a<red>m</><red>e</>!")
            wait(2)
            self.room:send("The <red>f<b:yellow>i<red>r</><red>es<blue>t<yellow>o<red>r</><red>m</> forms a vortex about the " .. get_obj_noadesc(23, 39) .. ", like an explosion in reverse.")
            wait(1)
            self.room:send("The trident <b:magenta>t</><magenta>w<b:black>i</><magenta>s<blue>ts</> and contorts in the wild <red>f<b:yellow>i<red>r</><red>e</>!")
            wait(3)
            self.room:send("The fire subsides, leaving a <b:black>midnight-black</> weapon pulsing with dark radiance.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Our bond is forged.'")
        else
            actor:send(tostring(self.name) .. " says, 'The infernal ones are pleased.'")
            wait(1)
            self.room:send(tostring(self.name) .. "'s neck goes limp as her eyes roll back into her head.")
            wait(2)
            self.room:send(tostring(self.name) .. " begins to murmur... 'Hin tel'quiet nehel -nal rillis fis...'")
            wait(3)
            self.room:send("Brilliant <blue>b<b:black>lac</><blue>k fire seeps out of " .. get_obj_noadesc(23, 34) .. " and spreads across its surface.")
            wait(2)
            self.room:send(tostring(self.name) .. " babbles in an alien voice, 'Aul adoe shunti mor ik mor...'")
            wait(2)
            self.room:send("<red>Scarlet</> <blue>fl<blue>ames</> ignite in " .. tostring(self.name) .. "'s hands, pulsing in rhythm with her speech.")
            wait(2)
            self.room:send(tostring(self.name) .. " utters, 'Slidc ya qnoes oynaezz ya khozz qaed...' as she holds her hand over the " .. get_obj_noadesc(23, 34) .. ".")
            wait(2)
            self.room:send("The flames burn away the trident, leaving only a blazing tendril.")
            wait(2)
            self.room:send(tostring(self.name) .. " grabs the burning spire and commands, 'Le yaezzoth esaeu qae qota maenz!'")
            self.room:send("The wild flames contort as they cool into a new three-pointed form.")
            wait(2)
            if actor.level >= 90 then
                actor:send(tostring(self.name) .. " says, 'The Demon Lord Krisenna is known to traffic with mortals from time to time.  Impress him and perhaps he will grant you a boon.'")
            else
                actor:send(tostring(self.name) .. " says, 'Continue to prove your value to Hell and perhaps a Demon Lord might be willing to grant your their patronage.'")
                actor:send("<red>You must be level " .. tostring(level) .. " or greater to continue this quest.</>")
            end
        end
        self.room:spawn_object(23, reward)
        self:command("give trident " .. tostring(actor))
        local expcap = level
        local expmod
        if expcap < 17 then
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
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 10 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        local number = 1
        while number < 7 do
            actor:set_quest_var("hell_trident", "helltask%number%", 0)
            number = number + 1
        end
        actor:set_quest_var("hell_trident", "gems", 0)
        actor:set_quest_var("hell_trident", "greet", 0)
        if actor:get_quest_stage("hell_trident") == 1 then
            actor:advance_quest("hell_trident")
        else
            actor:complete_quest("hell_trident")
        end
    else
        refuse = 1
        reason = "You have to complete all your other offerings before you give me your trident."
    end
end
if refuse then
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(reason) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'b558285b39cdb48a46170c7bbb92ecae'),
  -- data/triggers/055/055_21_degeneration_cat_receive.lua
  (55, 21, $trig$-- Converted from DG Script #5521: degeneration_cat_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("degeneration")
if stage == 0 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:command("hiss actor")
    self:say("Who are you?  Why are you giving me this?")
    return false  -- legacy return 0: the giver keeps the item
elseif stage == 1 and (object.zone_id == 580 and object.id == 8) then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("studies the book closely.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Hmmm, that's an unusual configuration...  The cage must have")
    self.room:send("</>been part of the secret.'")
    wait(2)
    self:emote("closes the book.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yajiro was on to something, though his understanding was")
    self.room:send("</>quite rudimentary.  I need to dig a little deeper.'")
    wait(4)
    self:say("Literally and figuratively!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'A troll sorcerer by the name of Mesmeriz has set up an")
    self.room:send("</>illusory lair in the Minithawkin Mines.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Word among the dark practitioners is, he's trying to perform")
    self.room:send("</>the Ritual of Night and become a lich.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Bring back the necklace he carries so I can see how much")
    self.room:send("</>progress he's made.'")
elseif stage == 2 and (object.zone_id == 370 and object.id == 15) then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("necklace")
    self.room:send(tostring(self.name) .. " utters the words, '<b:yellow>oculoinfra kariq</>'.")
    self.room:send(tostring(self.name) .. "'s eyes flash bright yellow!")
    wait(1)
    self:emote("examines " .. tostring(objects.template(370, 15).name))
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Mesmeriz was remarkably close to his goal.  The principles")
    self.room:send("</>of energy transfer he was using were quite unique.'")
    wait(4)
    self:say("It seems all he was missing was a suitable phylactery.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'There's another wizard who has been working in body")
    self.room:send("</>modification, but on a massive scale.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He's enchanted the entire town of Nordus and is")
    self.room:send("</>experimenting on the villagers.  Rumor is he's trying to grow bodies as fodder")
    self.room:send("</>for mass animation.'")
    wait(5)
    self:say("I must admit, I'm impressed.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'He has a mask made from the face of one of his many victims")
    self.room:send("</>which he uses as his focus.  It's a bit vulgar, but it should serve my")
    self.room:send("</>purposes.  Secure it and bring it back.'")
elseif stage == 3 and (object.zone_id == 510 and object.id == 75) then
    actor:advance_quest("degeneration")
    wait(0.1)
    self:destroy_item("mask")
    wait(1)
    self:emote("greedily devours the " .. get_obj_noadesc(510, 75) .. "!")
    wait(3)
    self:command("lick")
    self:say("Nothing makes you more familiar with magic than the taste!")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Some impressive potency to use transmutation at that scale.")
    self.room:send("</>Plus some powerful evocation.'")
    wait(4)
    self:command("burp")
    self:say("Spicy!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'But Luchiaans wasn't a very skilled necromancer it seems.")
    self.room:send("</>Still, it gives me some ideas.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'I need something of a more demonic nature to compare notes")
    self.room:send("</>to.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Cyprianum, the ruler of Demise Keep, has a particularly")
    self.room:send("</>prized servant, Voliangloch the Evil.  As a devotee of the demonic Cyprianum,")
    self.room:send("</>Voliangloch may have struck that special balance between arcane and divine.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'Bring me his magical focus, " .. tostring(objects.template(430, 20).name) .. ".")
    self.room:send("</>It should give me sufficient insight to Voliangloch's magic.'")
elseif stage == 4 and (object.zone_id == 430 and object.id == 20) then
    actor:advance_quest("degeneration")
    wait(0.1)
    self:destroy_item("rod")
    wait(1)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around a bit.")
    wait(3)
    self:emote("bats " .. tostring(objects.template(430, 20).name) .. " around some more.")
    wait(5)
    self:emote("frantically swats " .. tostring(objects.template(430, 20).name) .. " around and sends it flying!")
    self:command("hiss")
    wait(3)
    self:say("Well that was most informative.")
    wait(3)
    self:say("Interesting blending technique Voliangloch employed.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'It looks like we have to approach the big players for more")
    self.room:send("</>information now.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'The first of the true necromancers I need you to \"visit\" is")
    self.room:send("</>Kryzanthor.  He's created a vast necropolis near Anduin, the likes of which")
    self.room:send("</>most beings can only dream about!'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'He wears a unique robe that I'd like to get my paws on.  Get")
    self.room:send("</>it and bring it back to me.'")
elseif stage == 5 and (object.zone_id == 470 and object.id == 3) then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("robe")
    self:emote("gingerly sniffs " .. tostring(objects.template(470, 3).name) .. ".")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Yes, this makes more sense.  Needing a physical conduit to")
    self.room:send("</>focus the transference of energies through while simultaneously shielding the")
    self.room:send("</>body appears to be critical here.'")
    wait(6)
    self.room:send(tostring(self.name) .. " says, 'Kryzanthor had mastered suffusing the dead with animating")
    self.room:send("</>energies, but he didn't quite have the mastery of draining life force from")
    self.room:send("</>the living.'")
    wait(6)
    self:say("There is one whom I have heard does have such a power.")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'In the Iron Hills there is an ancient barrow where several")
    self.room:send("</>kings have been laid to rest.  What's more, those of us who deal in death know")
    self.room:send("</>it's the lair of one of the two known liches in the world, King Ureal.'")
    wait(7)
    self.room:send(tostring(self.name) .. " says, 'In particular, he has a statuette I'm most interested in.")
    self.room:send("</>It supposedly can drain the energy of the living.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'If that's true, then it would be a huge missing piece of the")
    self.room:send("</>puzzle.'")
    wait(3)
    self:say("I'm quite excited for this one, so hurry up!")
elseif stage == 6 and (object.zone_id == 480 and object.id == 9) then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("statuette")
    self:say("Well done my little one, well done.")
    self:emote("meows in gratitude.")
    wait(2)
    self:emote("repeatedly rubs up against the statuette.")
    self.room:send("The statuette begins to glow <b:green>bright green!</>")
    wait(1)
    self:say("Fascinating...")
    wait(3)
    self:say("This is definitely helpful.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'The last person I need information from is a curmudgeonly")
    self.room:send("</>old thing, Norisent.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'He sought to raise the dead, not just in a state of undeath,")
    self.room:send("</>but to truly restore them to life.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Unfortunately for him, his experiments failed and he turned")
    self.room:send("</>himself into a lich instead.'")
    wait(2)
    self:command("roll")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Regardless, he's been hiding out at the Cathedral of")
    self.room:send("</>Betrayal for decades now.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Find Norisent and whatever book he's keeping notes in these")
    self.room:send("</>days.  While I think I could manage this without his notes, I want to be")
    self.room:send("</>completely sure.'")
elseif stage == 8 and (object.zone_id == 85 and object.id == 51) then
    actor:advance_quest("degeneration")
    wait(1)
    self:destroy_item("book")
    self:emote("flips through the pages of the book.")
    wait(2)
    self:command("gasp")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'It's a good thing I have these notes or my planned matrix")
    self.room:send("</>configuration would have completely backfired!  I'll make the necessary")
    self.room:send("</>adjustments to the final casting.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The other thing these notes show me is I'm missing")
    self.room:send("</>something to channel the transferring energy through.'")
    wait(4)
    self:say("Hmmmmm...")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'The statuette is too strongly attuned to Ureal to be")
    self.room:send("</>suitable...'")
    wait(3)
    self:say("Let me see...")
    wait(3)
    self.room:send(tostring(self.name) .. " utters the words, <b:yellow>'hiqi avykamina'</>.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'It seems there is a dangerous ruby hidden under some kind")
    self.room:send("</>of stairway?  That makes no sense.  Yet my divination indicates it would be an")
    self.room:send("</>acceptable conduit for this spell.'")
    wait(6)
    self:say("Seek it out!")
elseif stage == 9 and (object.zone_id == 125 and object.id == 26) then
    wait(1)
    self:destroy_item("ruby")
    self.room:send(tostring(self.name) .. "'s eyes widen and gleam at the sight of the ruby!")
    self:say("Magnificent!  I've never seen anything quite like it.")
    wait(3)
    self:emote("scratches out a huge diagram in the earth inside the tent.")
    self.room:send(tostring(self.name) .. " carefully places " .. tostring(objects.template(125, 26).name) .. " in the center of the diagram.")
    wait(4)
    self.room:send(tostring(self.name) .. " utters the word, <b:yellow>'oculotunsofihuab'</>.")
    self.room:send("Waves of necrotic energy rush blast out from the diagram bolstering the forces of the Third Black Legion!")
    wait(4)
    self:command("cackle")
    self.room:send(tostring(self.name) .. " says, 'I've done it!  I've perfected the formula for Degeneration!!")
    self.room:send("</>Here, see how it works!!'")
    wait(4)
    actor:send("Looking at the notes, you understand what " .. tostring(self.name) .. " has done.")
    actor:send("<b:white>You have learned <black>Degeneration<white>!</>")
    skills.set_level(actor, "degeneration", 1000)
    actor:complete_quest("degeneration")
else
    self:command("hiss " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'This isn't what I asked for. What are you, stupid?")
    self.room:send("</>Do you need me to remind you of your <b:white>[spell progress]</>?'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'a47d83a6e29910f6e3dde121701825d8'),
  -- data/triggers/060/060_21_merc_subclass_timulos_receive.lua
  (60, 21, $trig$-- Converted from DG Script #6021: merc_subclass_timulos_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (41014): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 410 and object.id == 14)
) then
    return true
end

wait(0.2)
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if actor:get_quest_stage("merc_ass_thi_subclass") == 1 or actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, I have not even told you what to do yet...  So how did you do it?'")
elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'How ever did you get what I ask for without getting it yourself?'")
    self:command("spank " .. tostring(actor.name))
    -- TODO(parity): converter mangled this branch. Original DG likely had a
    -- cloak-id check here that, when satisfied, advanced the quest and ran the
    -- reward emotes. We restore the reward block guarded only by subclass_name
    -- since the wrapping `quest_stage == 3` already gates this.
    if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" then
        self:emote("grins from ear to ear.")
        actor:send(tostring(self.name) .. " says, 'You have done me a great service.  The lord will reward me kindly to get this back.'")
        self:command("flex")
        self:emote("shouts, 'Yes, yes, yes!!!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Type '<yellow>subclass</>' to proceed.'")
        actor:complete_quest("merc_ass_thi_subclass")
    end
else
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Shame you were not on a quest for me.'")
end
self:destroy_item("questobject")$trig$, 'd424918b71967bcbc2d885c01485ffb1'),
  -- data/triggers/060/060_22_assassin_subclass_timulos_receive.lua
  (60, 22, $trig$-- Converted from DG Script #6022: assassin_subclass_timulos_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (3033): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 30 and object.id == 33)
) then
    return true
end

wait(0.2)
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if actor:get_quest_stage("merc_ass_thi_subclass") == 1 or actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, I have not even told you what to do yet...  So how did you do it?'")
elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'How ever did you get what I ask for without getting it yourself?'")
    self:command("spank " .. tostring(actor.name))
    -- TODO(parity): converter dropped the cane-id check here; preserved
    -- subclass-name guard so the reward path executes for assassins on stage 3.
    if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" then
        self:emote("smiles widely.")
        actor:send(tostring(self.name) .. " says, 'Wonderful, now they shall reward me, excellent.'")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'You have done well by me, so in return your request is granted.'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Type '<red>subclass</>' to proceed.'")
        actor:complete_quest("merc_ass_thi_subclass")
    end
else
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Shame you were not on a quest for me.'")
end
self:destroy_item("questobject")$trig$, '95ebe4e7f046085e5cbc7b249b128841'),
  -- data/triggers/060/060_23_thief_subclass_timulos_receive.lua
  (60, 23, $trig$-- Converted from DG Script #6023: thief_subclass_timulos_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (8813): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 88 and object.id == 13)
) then
    return true
end

wait(0.2)
-- switch on actor:get_quest_stage("merc_ass_thi_subclass")
if actor:get_quest_stage("merc_ass_thi_subclass") == 1 or actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor:send(tostring(self.name) .. " says, 'Interesting, I have not even told you what to do yet...  So how did you do it?'")
elseif actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'How ever did you get what I ask for without getting it yourself?'")
    self:command("spank " .. tostring(actor.name))
    -- TODO(parity): converter dropped the package-id check here; preserved
    -- subclass-name guard so the reward path executes for thieves on stage 3.
    if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" then
        actor:send(tostring(self.name) .. " says, 'Wonderful, now I can return this to its rightful owner.'")
        wait(0.2)
        self:emote("mutters something about how a true thief would try to take it back.")
        self:emote("clears his throat and says, 'You have done well, congratulations!'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Type '<b:red>subclass</>' to proceed.'")
        actor:complete_quest("merc_ass_thi_subclass")
    end
else
    actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Shame you were not on a quest for me.'")
end
self:destroy_item("questobject")$trig$, 'e658c42bc818cdc7211be886ecee207b'),
  -- data/triggers/060/060_24_timulos_refuse.lua
  (60, 24, $trig$-- Converted from DG Script #6024: Timulos refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (41014 3033 8813) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 410 and object.id == 14)
    or (object.zone_id == 30 and object.id == 33)
    or (object.zone_id == 88 and object.id == 13) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
local response
do
    if actor:get_quest_stage("merc_ass_thi_subclass") == 4 then
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Well this is nifty, I think I will hold on to that, thank you.  Now go bring me what you were told.'")
        world.destroy(object)
    else
        response = "What is this? Are you trying to trick me?"
    end
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'd72f15182f5dfc074ca02966ee677acd'),
  -- data/triggers/060/060_33_green_woman_refuse.lua
  (60, 33, $trig$-- Converted from DG Script #6033: Green Woman refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- `response` is hoisted so the inner else and the outer else
-- can both write to the same binding. The converter emitted
-- `local` per branch; the post-block test below would never see
-- those values.
local response = nil
if actor:get_quest_stage("wizard_eye") == 7 then
    if (object.zone_id == 237 and object.id == 54) or (object.zone_id == 30 and object.id == 298) or (object.zone_id == 238 and object.id == 47) or (object.zone_id == 180 and object.id == 1) then
        return _return_value
    else
        response = "This " .. tostring(object.shortdesc) .. " isn't roses or cinnamon."
    end
else
    response = "I only take coin, not trade."
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'dcfb09f508d5d5ea2084d7622988131a'),
  -- data/triggers/060/060_53_berix_bounty_hunt_receive.lua
  (60, 53, $trig$-- Converted from DG Script #6053: Berix bounty hunt receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Hoisted: branch-scoped `local` would not be visible to the rest of the script.
local stage, victim1, victim2, victim3, go, maskstage, item
-- switch on object.id
-- bounty contracts here
if (object.zone_id == 60 and object.id == 50) then
    stage = 1
    victim1 = "The King of the Meer Cats"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 51) then
    stage = 2
    victim1 = "the Noble"
    victim2 = "the Abbot"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 52) then
    stage = 3
    victim1 = "the O'Connor Chieftain"
    victim2 = "the McLeod Chieftain"
    victim3 = "the Cameron Chieftain"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 53) then
    stage = 4
    victim1 = "The Frakati Leader"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 54) then
    stage = 5
    victim1 = "Cyrus"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 55) then
    stage = 6
    victim1 = "Lord Venth"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 56) then
    stage = 7
    victim1 = "The high druid of Anlun Vale"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 57) then
    stage = 8
    victim1 = "The Lizard King"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 58) then
    stage = 9
    victim1 = "Sorcha"
    go = "hunt"
elseif (object.zone_id == 60 and object.id == 59) then
    stage = 10
    victim1 = "The Goblin King"
    go = "hunt"
    -- assassin mask items start here
elseif object.id == 350 then
    maskstage = 1
    item = "quest"
    go = "mask"
elseif (object.zone_id == 45 and object.id == 0) then
    maskstage = 1
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 92) then
    maskstage = 1
    item = "gem"
    go = "mask"
elseif object.id == 351 then
    maskstage = 2
    item = "quest"
    go = "mask"
elseif (object.zone_id == 178 and object.id == 9) then
    maskstage = 2
    item = "mask"
    go = "mask"
elseif (object.zone_id == 555 and object.id == 94) then
    maskstage = 2
    item = "gem"
    go = "mask"
elseif object.id == 352 then
    maskstage = 3
    item = "quest"
    go = "mask"
elseif (object.zone_id == 590 and object.id == 23) then
    maskstage = 3
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 20) then
    maskstage = 3
    item = "gem"
    go = "mask"
elseif object.id == 353 then
    maskstage = 4
    item = "quest"
    go = "mask"
elseif (object.zone_id == 103 and object.id == 4) then
    maskstage = 4
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 38) then
    maskstage = 4
    item = "gem"
    go = "mask"
elseif object.id == 354 then
    maskstage = 5
    item = "quest"
    go = "mask"
elseif (object.zone_id == 162 and object.id == 0) then
    maskstage = 5
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 66) then
    maskstage = 5
    item = "gem"
    go = "mask"
elseif object.id == 355 then
    maskstage = 6
    item = "quest"
    go = "mask"
elseif (object.zone_id == 430 and object.id == 17) then
    maskstage = 6
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 75) then
    maskstage = 6
    item = "gem"
    go = "mask"
elseif object.id == 356 then
    maskstage = 7
    item = "quest"
    go = "mask"
elseif (object.zone_id == 510 and object.id == 75) then
    maskstage = 7
    item = "mask"
    go = "mask"
elseif (object.zone_id == 556 and object.id == 93) then
    maskstage = 7
    item = "gem"
    go = "mask"
elseif object.id == 357 then
    maskstage = 8
    item = "quest"
    go = "mask"
elseif (object.zone_id == 490 and object.id == 62) then
    maskstage = 8
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 19) then
    maskstage = 8
    item = "gem"
    go = "mask"
elseif object.id == 358 then
    maskstage = 9
    item = "quest"
    go = "mask"
elseif (object.zone_id == 484 and object.id == 27) then
    maskstage = 9
    item = "mask"
    go = "mask"
elseif (object.zone_id == 557 and object.id == 43) then
    maskstage = 9
    item = "gem"
    go = "mask"
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What is this for?")
    return false  -- legacy return 0: the giver keeps the item
end
if go == "hunt" then
    -- Bug fix: the converter compared quest_stage to the string "stage" instead of
    -- the local variable `stage` set above; restore the variable comparison.
    if actor:get_quest_stage("bounty_hunt") == stage and actor:get_quest_var("bounty_hunt:bounty") == "dead" then
        wait(0.2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Well done.  Here's your payment.'")
        local money = stage * 10
        self:command("give " .. tostring(money) .. " platinum " .. tostring(actor))
        -- Hoisted: branch-scoped `local` would not be visible later.
        local expcap, expmod
        if stage == 1 then
            expcap = 5
        else
            expcap = (stage - 1) * 10
        end
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
        -- Bug fix: original referred to `person.class` but `person` is undefined
        -- here; use `actor.class`.
        if actor.class == "warrior" or actor.class == "berserker" then
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            expmod = (expmod + (expmod * 2) / 5)
        end
        actor:send("<b:yellow>You gain experience!</>")
        local setexp = (expmod * 10)
        local loop = 0
        while loop < 3 do
            actor:award_exp(setexp)
            loop = loop + 1
        end
        actor:set_quest_var("bounty_hunt", "target1", 0)
        actor:set_quest_var("bounty_hunt", "target2", 0)
        actor:set_quest_var("bounty_hunt", "target3", 0)
        actor:set_quest_var("bounty_hunt", "bounty", 0)
        wait(0.2)
        if stage < 10 then
            actor:advance_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Check in again if you have time for more work.'")
        else
            actor:complete_quest("bounty_hunt")
            actor:send(tostring(self.name) .. " says, 'Congratulations, you've really proven yourself out there!  'Fraid there ain't much more we can toss your way.'")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Take this to commemorate your hunt.'")
            self.room:spawn_object(4, 43)
            self:command("give shroud " .. tostring(actor))
        end
        if string.find(actor.class, "assassin") and actor:get_quest_stage("assassin_mask") == 0 then
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I think you've earned this too.'")
            self.room:spawn_object(2, 150)
            self:command("give mask " .. tostring(actor))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Masks like these show the rank of members of the Assassin Guild.'")
            actor:start_quest("assassin_mask")
            wait(2)
            if actor.level > 9 then
                actor:send(tostring(self.name) .. " says, 'This might be a good time to talk about a <b:cyan>[promotion]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Come back with that mask after you reach level 10 and let's talk about a promotion.'")
            end
        end
    elseif actor:get_quest_stage("bounty_hunt") > stage then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses the contract.")
        actor:send(tostring(self.name) .. " says, 'You already completed this contract!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("bounty_hunt") < stage then
        wait(0.2)
        self:command("eye " .. tostring(actor))
        actor:send(tostring(self.name) .. " says, 'How'd you get this?!  You steal it off someone else??'")
        self.room:send(tostring(self.name) .. " rips up the contract!")
        world.destroy(object)
    elseif actor:get_quest_var("bounty_hunt:bounty") ~= "dead" then
        self.room:send(tostring(self.name) .. " refuses the contract.")
        actor:send(tostring(self.name) .. " says, 'You have to finish the job first!'")
        if stage ~= 2 and stage ~= 3 then
            actor:send(tostring(victim1) .. " is still out there.")
        elseif stage == 2 or stage == 3 then
            if (actor:get_quest_var("bounty_hunt:target1") or 0) == 0 then
                actor:send(tostring(victim1) .. " is still out there.")
            end
            if (actor:get_quest_var("bounty_hunt:target2") or 0) == 0 then
                actor:send(tostring(victim2) .. " is still out there.")
            end
            if stage == 3 and (actor:get_quest_var("bounty_hunt:target3") or 0) == 0 then
                actor:send(tostring(victim3) .. " is still out there.")
            end
        end
        return false  -- legacy return 0: the giver keeps the item
    end
elseif go == "mask" then
    if actor:get_quest_stage("bounty_hunt") < actor:get_quest_stage("assassin_mask") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Complete some more contract jobs first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor.level < (actor:get_quest_stage("assassin_mask") * 10) then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You need to gain some more experience first.'")
        return false  -- legacy return 0: the giver keeps the item
    elseif maskstage > actor:get_quest_stage("assassin_mask") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'Your mask doesn't involve that yet.  Be patient!'")
        return false  -- legacy return 0: the giver keeps the item
    elseif maskstage < actor:get_quest_stage("assassin_mask") then
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You've already gained that rank.'")
        return false  -- legacy return 0: the giver keeps the item
    else
        if item == "quest" then
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                wait(0.2)
                local reward = object.id + 1
                world.destroy(object)
                self:command("nod")
                actor:send(tostring(self.name) .. " says, 'Well done!  You've proven your qualifications.'")
                self.room:spawn_object(math.floor(reward / 100), reward % 100)
                self:command("give mask " .. tostring(actor))
                local expcap = maskstage * 10
                -- Hoisted: branch-scoped `local expmod` would not be visible.
                local expmod
                if expcap < 17 then
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
                actor:send("<b:yellow>You gain experience!</>")
                local setexp = (expmod * 10)
                local loop = 0
                while loop < 7 do
                    actor:award_exp(setexp)
                    loop = loop + 1
                end
                local number = 1
                while number < 5 do
                    -- Bug fix: DG `%number%` interpolation; use Lua concat.
                    actor:set_quest_var("assassin_mask", "masktask" .. tostring(number), 0)
                    number = number + 1
                end
                if actor:get_quest_stage("assassin_mask") < 9 then
                    actor:advance_quest("assassin_mask")
                else
                    actor:complete_quest("assassin_mask")
                end
            else
                self:command("shake")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                actor:send(tostring(self.name) .. " says, 'You need to do everything else before you give me your guild mask!'")
                return false  -- legacy return 0: the giver keeps the item
            end
        end
        -- Hoisted: branch-scoped `local accept` would not be visible to the
        -- accept-check below. Default nil (skips the `accept` ladder when
        -- the item == "quest" branch above was taken).
        local accept
        if item == "mask" then
            if actor:get_quest_var("assassin_mask:masktask2") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask2", object.id)
            end
        elseif item == "gem" then
            if actor:get_quest_var("assassin_mask:masktask3") == object.id then
                accept = "no"
            else
                accept = "yes"
                actor:set_quest_var("assassin_mask", "masktask3", object.id)
            end
        end
        if accept == "no" then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You already gave me that.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif accept == "yes" then
            wait(0.2)
            world.destroy(object)
            local job1 = actor:get_quest_var("assassin_mask:masktask1")
            local job2 = actor:get_quest_var("assassin_mask:masktask2")
            local job3 = actor:get_quest_var("assassin_mask:masktask3")
            local job4 = actor:get_quest_var("assassin_mask:masktask4")
            if job1 and job2 and job3 and job4 then
                actor:send(tostring(self.name) .. " says, 'Excellent.  Now give me your guild mask for your promotion.'")
            else
                actor:send(tostring(self.name) .. " says, 'Good, now finish the rest.'")
            end
        end
    end
end
return _return_value$trig$, '3dce0dfc8183a961014b6d406579a85a'),
  -- data/triggers/062/062_03_shift_corpse_lokari_receive.lua
  (62, 3, $trig$if object.zone_id == 62 and object.local_id == 28 and actor:get_quest_stage("shift_corpse") == 1 then
    actor:advance_quest("shift_corpse")
    self.room:send(tostring(objects.template(62, 28).name) .. " flares with <b:black>darkness visible!</>")
    self.room:send("<b:black>" .. tostring(self.name) .. "</> <red>ROARS</> <b:black>with divine fury!</>")
    self:say("You will never destroy me!!")
    combat.engage(actor)
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '70fd31099d1ab864431ea0ee230710f6'),
  -- data/triggers/062/062_12_supernova_phayla_receive.lua
  (62, 12, $trig$-- TODO(parity): legacy used `skills.set_level(actor.name, "supernova", 100)`.
-- Confirm the runtime API (likely `actor:set_skill_level("supernova", 100)`)
-- and migrate; left as-is to preserve original behavior.

local function payment_key(obj)
    return tostring(obj.zone_id) .. "_" .. tostring(obj.local_id)
end

local is_sun = (object.zone_id == 510 and object.local_id == 73)
local is_lamp = (object.zone_id == 489 and object.local_id == 17)

if is_sun or is_lamp then
    if (actor:get_quest_var("supernova:" .. payment_key(object)) or 0) == 1 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You've already given me this.")
        return false  -- legacy return 0: the giver keeps the item
    else
        actor:set_quest_var("supernova", payment_key(object), 1)
        wait(0.2)
        self:command("nod")
        world.destroy(object)
        if (actor:get_quest_var("supernova:510_73") or 0) == 1 and (actor:get_quest_var("supernova:489_17") or 0) == 1 then
            self:say("Alright, get comfortable.  This may take a while.")
            wait(3)
            self.room:send(tostring(self.name) .. " demonstrates some of the basics.")
            actor:send("You take notes and try to follow along.")
            wait(5)
            self:say("No, the diagrams need to look like this...")
            self.room:send_except(actor, tostring(self.name) .. " makes changes to " .. tostring(actor.name) .. "'s notes.")
            actor:send(tostring(self.name) .. " makes changes to your notes.")
            wait(5)
            self:say("Yes, that's good.  Move your hands like this.")
            self.room:send(tostring(self.name) .. " waves her hands about.")
            wait(5)
            self:say("Yes, that's much closer.")
            actor:send("You feel you're starting to get the hang of it!")
            self.room:send_except(actor, "It seems " .. tostring(actor.name) .. " is starting to get the hang of it!")
            wait(9)
            actor:send("You have a breakthrough!")
            self.room:send_except(actor, tostring(actor.name) .. " has a breakthrough!")
            wait(1)
            self:say("That's it!!  You've got it!")
            self.room:send_except(actor, tostring(actor.name) .. " radiates with inner arcane fire!")
            actor:send("<b:red>You have mastered Supernova!</>")
            skills.set_level(actor, "supernova", 1000)
            actor:complete_quest("supernova")
        else
            self:say("And the other?")
        end
    end
else
    self:say("This isn't acceptable payment.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '192ad9b137d41cac7c5f8ab92fb32dee'),
  -- data/triggers/062/062_95_gem_exchange_receive_exchange.lua
  (62, 95, $trig$-- TODO(parity): the legacy script gates `object.id` on the 5-digit vnum.
-- Here `object.id` is the local id within the gem's zone -- we reconstruct
-- the 5-digit form (zone*100 + local_id) before comparing. Verify that all
-- gems being handed in really live in zone 555.

local item = actor:get_quest_var("gem_exchange:gem_id")
if (item or 0) == 0 or item == nil then
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'I don't have any exchange orders listed for you at the")
    actor:send("</>moment...'")
    return false  -- legacy return 0: the giver keeps the item
end

local obj_vnum = object.zone_id * 100 + object.local_id

-- Decode the minimum-acceptable vnum cutoff for the requested item.
local function cutoff_for(it)
    if it <= 55569 then return 55566
    elseif it <= 55573 then return 55570
    elseif it <= 55577 then return 55574
    elseif it <= 55581 then return 55578
    elseif it <= 55585 then return 55582
    elseif it <= 55589 then return 55586
    elseif it <= 55593 then return 55590
    elseif it <= 55604 then return 55594
    elseif it <= 55615 then return 55605
    elseif it <= 55626 then return 55616
    elseif it <= 55637 then return 55627
    elseif it <= 55648 then return 55638
    elseif it <= 55659 then return 55649
    elseif it <= 55670 then return 55660
    elseif it <= 55681 then return 55671
    elseif it <= 55692 then return 55682
    elseif it <= 55703 then return 55693
    elseif it <= 55714 then return 55704
    elseif it <= 55725 then return 55715
    elseif it <= 55736 then return 55726
    elseif it <= 55747 then return 55737
    end
    return nil
end

-- Upper bound: highest-tier consumables stop at 55747 (top tier 3 set);
-- lower-class tiers are valid up through 55751 in the original.
local function upper_for(it)
    if it <= 55703 then return 55751 end
    return 55747
end

local lo = cutoff_for(item)
local hi = upper_for(item)
local in_gem_range = obj_vnum >= 55566 and obj_vnum <= 55751
local found = lo and hi and obj_vnum >= lo and obj_vnum <= hi

if found then
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Here you are, as requested!'")
    world.destroy(object)
    self.room:spawn_object(math.floor((item or 0) / 100), (item or 0) % 100)
    self:command("give all " .. tostring(actor))
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'A pleasure doing business with you!'")
    actor:set_quest_var("gem_exchange", "gem_id", 0)
else
    actor:send(tostring(self.name) .. " refuses to perform the exchange.")
    if in_gem_range then
        local item_name = tostring(objects.template(math.floor((item or 0) / 100), (item or 0) % 100).name)
        actor:send(tostring(self.name) .. " says, 'I'm afraid " .. tostring(object.shortdesc) .. " isn't of high enough rarity")
        actor:send("</>to exchange for " .. item_name .. ".'")
    else
        actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing")
        actor:send("</>we trade around here...'")
    end
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '3a7793570d45f5ded8956b113b31ecb3'),
  -- data/triggers/085/085_06_give_head_ziijhan.lua
  (85, 6, $trig$-- Converted from DG Script #8506: give_head_ziijhan
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (8504): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 85 and object.id == 4)
) then
    return true
end

wait(0.2)
-- switch on actor:get_quest_stage("nec_dia_ant_subclass")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("nec_dia_ant_subclass") or ""))
    if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
        -- not in final stage of quest
        actor:send(tostring(self.name) .. " says, 'Hmmm, jumping the gun a bit aren't we?  I didn't even tell you the quest yet.'")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Thanks for the gift, weirdo.'")
    elseif tonumber(_sw1) == 3 then
        -- somehow they have the head without GETTING it
        actor:send(tostring(self.name) .. " says, 'Hmmm, how did you get this head without GETTING it?'")
        self:command("whap " .. tostring(actor.name))
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'I can't abide that sort of foolishness!'")
    elseif tonumber(_sw1) == 4 then
        self:emote("throws back his head and howls devilishly with pleasure.")
        wait(0.3)
        self:command("shake " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " says, 'You have done me a great service, and earned your place among the truly dark.")
        self:command("smi")
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Type <red>'subclass'</> to proceed.'")
        actor:complete_quest("nec_dia_ant_subclass")
    else
        actor:send(tostring(self.name) .. " says, 'Well, what a lovely gift, I must stuff it and mount it on my wall.'")
        self:command("thank " .. tostring(actor.name))
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Shame you weren't performing the quest, you seem to be a nasty piece of work.'")
    end
end
-- junk the head
self:destroy_item("head")$trig$, '976dd6ee600ebeb9804e69607f7198a3'),
  -- data/triggers/085/085_55_norisent_receive.lua
  (85, 55, $trig$-- Converted from DG Script #8555: Norisent Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if (object.zone_id == 40 and object.id == 8) then
    if actor:get_quest_stage("resurrection_quest") == 4 then
        self:emote("refuses to take it.")
        self:say("First, give me the talisman, to be sure this was done right.")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("resurrection_quest") == 5 then
        wait(1)
        world.destroy(object)
        actor:advance_quest("resurrection_quest")
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
elseif (object.zone_id == 533 and object.id == 7) then
    if actor:get_quest_stage("resurrection_quest") == 6 then
        self:emote("refuses your item.")
        self:say("First, give me the talisman.  I want to be sure things are in order.")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("resurrection_quest") == 7 then
        wait(1)
        world.destroy(object)
        actor:advance_quest("resurrection_quest")
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
elseif actor:get_quest_stage("resurrection_quest") == 9 and ((object.zone_id == 510 and object.id == 23) or (object.zone_id == 510 and object.id == 28) or (object.zone_id == 510 and object.id == 22)) then
    if (object.zone_id == 510 and object.id == 23) then
        -- switch on actor.class
        do
            local _sw1 = string.lower(tostring(actor.class or ""))
            local _run1 = false
            repeat
                if _run1 or _sw1 == "cleric" or _sw1 == "priest" then
                    _run1 = true
                    wait(0.2)
                    world.destroy(object)
                    self:say("Ah, the angelic book!  You have done well to keep this from him.")
                    actor:advance_quest("resurrection_quest")
                    break
                end
                if _run1 or _sw1 == "diabolist" then
                    _run1 = true
                    self:say("Wrong one, dummy.")
                    return false  -- legacy return 0: the giver keeps the item
                end
                do  -- default
                    _run1 = true
                    self:say("What's your class?")
                    return false  -- legacy return 0: the giver keeps the item
                end
            until true
        end
    elseif (object.zone_id == 510 and object.id == 28) then
        -- switch on actor.class
        do
            local _sw2 = string.lower(tostring(actor.class or ""))
            local _run2 = false
            repeat
                if _run2 or _sw2 == "diabolist" then
                    _run2 = true
                    wait(0.2)
                    world.destroy(object)
                    self:say("Ah, the phoenix heart!  You've done well to keep this from him.")
                    actor:advance_quest("resurrection_quest")
                    break
                end
                if _run2 or _sw2 == "cleric" or _sw2 == "priest" then
                    _run2 = true
                    self:say("Wrong one, dummy.")
                    return false  -- legacy return 0: the giver keeps the item
                end
                do  -- default
                    _run2 = true
                    self:say("What's your class?")
                    return false  -- legacy return 0: the giver keeps the item
                end
            until true
        end
    elseif (object.zone_id == 510 and object.id == 22) then
        -- switch on actor.class
        do
            local _sw3 = string.lower(tostring(actor.class or ""))
            local _run3 = false
            repeat
                if _run3 or _sw3 == "cleric" or _sw3 == "priest" then
                    _run3 = true
                    self:say("This book is incomplete!  Something has drained its magic!  Fix that then bring the book back.")
                    break
                end
                if _run3 or _sw3 == "diabolist" then
                    _run3 = true
                    self:say("Wrong one, dummy.")
                    return false  -- legacy return 0: the giver keeps the item
                end
                do  -- default
                    _run3 = true
                    self:say("What's your class?")
                    return false  -- legacy return 0: the giver keeps the item
                end
            until true
        end
        self:say("This isn't the power Luchiaans seeks.  Go find it.")
        return false  -- legacy return 0: the giver keeps the item
    end
    -- 
    -- the old version where you had to go to Doom for the quest
    -- 
    -- wait 3s
    -- say There is another mage trapped by a malevolent god between life and death.  The continued existence of the mighty battlemage, Solek, is the cause of great instability.  Along with him, his compatriot Velocity, named for the speeds she harnessed in life, is bound by the same god in his keep.  Their continued existence as puppets of a cruel god tears at the very fabric of order and structure.
    -- wait 3s
    -- say You must find the power to stop Velocity. The utterance will help you.  Bring swift and lasting death to Solek, and return the source of his arcane wisdoms.
    -- (Stale converter-output dead code removed; the live branch
    -- below handles the resurrection-quest stage 10 talisman path.)
    -- 
    wait(3)
    self:say("There is another mage who has managed to ensconce himself in a place where no living being should be.  As a side effect of making his home at the boundary between the mortal realm and the Nine Hells, he has been driven insane.  He still survives all these centuries later through magic stolen from the elves of old.  Along with him, several souls have been marooned in the city's ruins.")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'One in particular, <b:blue>the city's weaponsmith</>, cries out for release from her eternal torment.  You must find the power to grant her wish.  The utterance will help you.'")
    wait(5)
    self.room:send(tostring(self.name) .. " says, 'Bring swift and lasting death to <b:blue>the crazed mage</>, and return the source of his arcane longevity.'")
elseif actor:get_quest_stage("resurrection_quest") == 10 then
    if (object.zone_id == 520 and object.id == 1) then
        self:say("Give me the talisman first.  I must know the crazed mage is truly dead at last.")
        self:emote("refuses your item.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif actor:get_quest_stage("resurrection_quest") == 11 then
    if (object.zone_id == 520 and object.id == 1) then
        wait(0.2)
        world.destroy(object)
        self:say("The ring is secure again.  It holds more power than a mortal can imagine.")
        wait(3)
        self:say("One yet remains of the foolish necromancers, who threatened the very existence of the world with their foolish search for immortality.  End me now, and let this be finished!")
        actor:advance_quest("resurrection_quest")
                globals.complete = true
    end
else
    self:emote("refuses your offering.")
    self:say("This isn't what we're after.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'febe18b52074911e19428d3b7b4d7e25'),
  -- data/triggers/103/103_13_ice_shards_khysan_receive1.lua
  (103, 13, $trig$-- DG receive arg list (16209 18505 55003 58415): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 162 and object.id == 9) or
    (object.zone_id == 185 and object.id == 5) or
    (object.zone_id == 550 and object.id == 3) or
    (object.zone_id == 584 and object.id == 15)
) then
    return true
end

if actor:get_quest_stage("ice_shards") ~= 1 then
    return true
end

local key = "ice_shards:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)
local prior = actor:get_quest_var(key)
if prior and prior ~= 0 and prior ~= "" and prior ~= "0" then
    self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("Thanks, but you already delivered " .. tostring(object.shortdesc) .. " to me.")
    return false
end

actor:set_quest_var("ice_shards", tostring(object.zone_id) .. "_" .. tostring(object.local_id), 1)
self:destroy_item("book")
wait(0.2)
self.room:send(self.name .. "'s eyes grow wide.")
self:say("This is incredible!  I never imagined I'd be holding a copy of " .. tostring(object.shortdesc) .. "!")
wait(0.2)

-- The four target books, looked up by composite (zone, id):
--   16209 → (162, 9)   the Book of Kings
--   18505 → (185, 5)   the Book of Discipline
--   55003 → (550, 3)   the Xapizan Codex
--   58415 → (584, 15)  the Enchiridion
local function got(z, i)
    local v = actor:get_quest_var("ice_shards:" .. tostring(z) .. "_" .. tostring(i))
    return v and v ~= 0 and v ~= "" and v ~= "0"
end

if got(162, 9) and got(185, 5) and got(550, 3) and got(584, 15) then
    actor:advance_quest("ice_shards")
    self:emote("slowly reads through the contents of each book.")
    wait(4)
    self:emote("takes copious notes.")
    wait(1)
    self:say("Hmmmm, I wonder if...")
    wait(1)
    self:say("No, that won't work...")
    wait(4)
    self:emote("sighs with frustration.")
    self:say("I hate to say it, but this isn't going to cut it.  The texts just don't have enough information about the spell.")
    wait(3)
    self:command("ponder")
    self.room:send(self.name .. " says, 'There is a mention of Shiran being near Mt. Frostbite in the Xapizan Codex however.  It also mentions a brother codex called <b:yellow>\"The Codex of War\"</>.")
    wait(2)
    self:say("Supposedly, the Codex of War contains a detailed history of battles in the region.  Maybe if Shiran was destroyed in some kind of conflict, the Codex of War might have more clues.")
    wait(2)
    self:say("Try to find a copy and bring it back so we can take a look at it!")
else
    self:say("Did you manage to find any of the other books?")
end

return true$trig$, '4107c50197e29cf21cf0caf5fbf289eb'),
  -- data/triggers/103/103_19_ice_shards_khysan_receive2.lua
  (103, 19, $trig$-- DG receive arg list (55004): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 4)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 2 then
    wait(0.2)
    actor:advance_quest("ice_shards")
    self:destroy_item("book")
    self:emote("cautiously takes " .. object.shortdesc .. " and places it on the reception desk.")
    wait(0.2)
    self:say("Yikes, this looks pretty dangerous.")
    self:emote("opens " .. object.shortdesc .. " and begins to read.")
    wait(3)
    self:emote("quietly continues to read.")
    wait(2)
    self:say("The Codex talks extensively about the wars fought in Frost Valley and the surrounding areas.  It says the Frost Elves have been here since long before people arrived in Technitzitlan.")
    wait(1)
    self:say("The Codex also says something catastrophic happened to the elves' majestic city Shiran \"ages ago,\" though it doesn't say what or when exactly.")
    wait(7)
    self:emote("closes " .. object.shortdesc .. ".")
    wait(3)
    self:say("But the fact that the elves are still here must mean something, right?")
    wait(3)
    self:say("Frost Valley is one of the only places left in Caelia where elves are frequently spotted.")
    wait(3)
    self:say("They've been locked in combat with a group of Amazons just east of here.  Why, I don't know, but I do know they've been skirmishing for a long time.")
    wait(4)
    self:say("The commander of the ice warriors, Thraja, certainly knows more.  Go and see if she keeps any records or journals.")
    wait(3)
    self:say("Bring back anything you find and we can look over it together.")
end$trig$, '9746b7a0c13b9cbb6cf0bf8cfd9be1da'),
  -- data/triggers/103/103_20_ice_shards_khysan_receive3.lua
  (103, 20, $trig$-- DG receive arg list (58806): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 588 and object.id == 6)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 3 then
    wait(0.2)
    actor:advance_quest("ice_shards")
    self:destroy_item("book")
    self:emote("sits down and reads through Commander Thraja's journal.")
    wait(3)
    self:say("There is quite a lot of detail about the Frost Elves and their general movements, but it doesn't look like Thraja ever figured out where they were coming from.  She also notes the elves don't seem to be invading so much as patrolling the area.")
    wait(3)
    self:emote("flips a few more pages.")
    wait(3)
    self:say("Thraja also notes maps of the region are unreliable as the terrain can subtly shift, almost like the valley is changing somehow.")
    wait(3)
    self:say("She says the best map she ever had of the region was a slightly magical one she received from Kara-Sithri but it was stolen by someone called \"The Butcher of Anduin.\"")
    wait(6)
    self:emote("looks up from the journal.")
    self:say("Oh my, that's not a subtle name at all is it?")
    wait(3)
    self:say("Apparently some kind of serial killer, the Butcher may have wanted the map to expand his reign of terror into the region around Ickle.  Or he may have just been looking for some valuables to pawn near his hideout.")
    wait(6)
    self:say("Thraja hasn't seen the map since.")
    wait(4)
    self:emote("closes the journal.")
    wait(3)
    self:say("Well if this map really was some kind of ancient magical device, it might help us determine where Shiran was.")
    wait(4)
    self:say("I guess you could ask around the pawnshop in Anduin, see if you can figure out what the Butcher did with the map.")
end$trig$, '3e9baf3c89d5e436e177bb0a019c2060'),
  -- data/triggers/103/103_21_ice_shards_khysan_receive4.lua
  (103, 21, $trig$-- DG receive arg list (48502): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 484 and object.id == 102)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 6 then
    wait(0.2)
    actor:advance_quest("ice_shards")
    self:destroy_item("map")
    self:say("Incredible, you found it!")
    self:emote("excitedly lays out the map.")
    wait(1)
    self:emote("scours every tiny detail of the map.")
    wait(3)
    self:say("Let me compare...")
    -- (empty room echo)
    self:emote("opens to a passage in the Codex of War.")
    self:emote("glances between the Codex and the map.")
    wait(4)
    self:say("And in Thraja's journal...")
    self:emote("compares a passage in Thraja's journal.")
    wait(3)
    self:say("The Codex mentions a site of incredible significance in the middle of Frost Lake, and both the map and Thraja's journal point to the remains of a tower of some kind on an island in the lake.")
    wait(6)
    self:say("The map indicates the edges of a huge city that once overlooked the plateau at the west edge of the valley.  Thraja notes a man named Ysgarran built some kind of fortification over a preexisting structure out there...")
    wait(7)
    self:say("Go check it out.  Assuming that was Shiran, maybe there's a clue there?  Bring back anything you find, especially if you find any written records of the region.")
end$trig$, 'a8d17ba2c63af1a3c518b0f228eda8fd'),
  -- data/triggers/103/103_22_ice_shards_khysan_receive5.lua
  (103, 22, $trig$-- DG receive arg list (53423): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 23)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 7 then
    wait(0.2)
    actor:advance_quest("ice_shards")
    self:destroy_item("book")
    self.room:send(tostring(self.name) .. " reads aloud, '\"The Lost Library of Shiran\".'")
    self:say("I... can't believe it's that obvious.")
    wait(3)
    self:emote("combs through the pages of the book.")
    wait(4)
    self:say("Okay, it's not that obvious. The book does talk about the library being destroyed for being a repository of too much mystical knowledge.  But it doesn't definitively say it was in Frost Valley.")
    wait(6)
    self:say("It does say the gods destroyed the library, claiming it was out of an abundance of caution, but was really an act of jealousy.")
    wait(5)
    self:say("What's even more interesting is what happened after!  A few of the gods repented and sought to atone for their crimes against Shiran.  They chronicled stories of good and evil as parables for what they had done and wrote those stories down into something called the \"Book of Redemption.\"")
    wait(7)
    self:say("This book serves as the basis for a mystic path to salvation for wayward beings.  The writings themselves are so powerful they pose to drive the reader insane if they're unable to withstand the strain on their will.")
    wait(6)
    self:say("I hate to say it, but this sounds like a 'no stone unturned' situation.  If you can find a copy of this book, I'm willing to try to read it.")
end$trig$, '872325e4e1268953042602357c3c6c7b'),
  -- data/triggers/103/103_23_ice_shards_khysan_receive6.lua
  (103, 23, $trig$-- DG receive arg list (43013): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 430 and object.id == 13)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 8 then
    wait(0.2)
    actor:advance_quest("ice_shards")
    self.room:send("Khysan carefully opens " .. tostring(object.shortdesc) .. " and starts to read.")
    wait(2)
    self.room:send("<b:yellow>Letters and images float up out of " .. tostring(object.shortdesc) .. " and begin to dance around Khysan.</>")
    self:destroy_item("book")
    wait(3)
    self.room:send("Khysan's eyes glaze over and his jaw goes slack.")
    -- TODO(parity): legacy DG had a bare `zone` here (see header).
    wait(5)
    self.room:send("Khysan shakes his head and snaps back into reality.")
    wait(2)
    self:say("Here's what it says: The gods were so afraid of the sheer amount of mystical knowledge in Shiran they tried to destroy it.")
    wait(3)
    self:say("Only it turns out, by then the library was so magically defended even the gods couldn't just obliterate it.")
    wait(2)
    self:say("So instead, they ripped open the time stream and tossed the library into it, causing the Time Cataclysm that destroyed Shiran and loosed the Time Elementals on Ethilien!")
    wait(6)
    self:say("But according to the book, the people trapped in the library were eventually able to create a sort of \"time key\".  They convinced a mighty Time Elemental Lord to bring it to our epoch where, in theory, it should still be!  By bringing the key to the ruins of the tower and somehow activating it, one can traverse between the ages!!")
    wait(9)
    self:say("WHAT?!")
    self:command("bounce")
    wait(2)
    self:say("This is AMAZING!!")
    wait(3)
    self:say("Well, I guess that means there's one more place to go!  Find that key, travel into the past, find a copy of Ice Shards, and bring it back to the future!")
    wait(2)
    self:command("salute " .. actor.name)
    self:say("Good luck my friend!")
end$trig$, 'e49d40ef506661e8a7a7040a1c2ed6ae'),
  -- data/triggers/103/103_24_ice_shards_khysan_receive7.lua
  (103, 24, $trig$-- DG receive arg list (10325): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 103 and object.id == 25)
) then
    return true
end

if actor:get_quest_stage("ice_shards") == 10 then
    wait(0.2)
    self:destroy_item("book")
    self:command("hug " .. actor.name)
    self:say("I don't know how I can ever express my gratitude to you for bringing this to me.  The Sunfire clan will be sure this knowledge is never lost again.")
    wait(4)
    self:say("Come, let's read this together.")
    self:emote("opens the book and flips forward a few pages.")
    wait(3)
    self:emote("points to a page.")
    self:say("Here it is!")
    wait(2)
    actor:send("Although the spell is written in ancient Elvish, the intent and meaning are clear enough to replicate it!")
    actor:complete_quest("ice_shards")
    skills.set_level(actor, "ice shards", 1000)
    actor:send("<b:cyan>You have learned Ice Shards!</>")
end$trig$, 'f3f9e0c312310ac5dd84f46e067617c0'),
  -- data/triggers/123/123_15_megalith_quest_keeper_receive.lua
  (123, 15, $trig$-- Converted from DG Script #12315: megalith_quest_keeper_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55020 48109 8301 41110 41111 18512): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 20) or
    (object.zone_id == 481 and object.id == 9) or
    (object.zone_id == 83 and object.id == 1) or
    (object.zone_id == 411 and object.id == 10) or
    (object.zone_id == 411 and object.id == 11) or
    (object.zone_id == 185 and object.id == 12)
) then
    return true
end

local _return_value = true  -- Default: allow action
-- This trigger is used to collect all the items for stage 2.
--
-- TODO(parity): self.id checks use legacy 5-digit vnums (12303..12306).
-- Once split, swap to self.local_id (3..6 in zone 123). Same for the
-- vessel checks (41110, 41111, 18512) and per-Keeper "need" object IDs
-- (55020, 48109, 8301).

local item = object.id
local me = self.id

-- Hoisted from branch-scoped locals in the converter output.
local direction
local part
local nxt
local need

if (self.zone_id == 123 and self.id == 3) then
    -- North, Earth - Granite Ring from Tech
    direction = "north"
    part = 4
    nxt = 12301
    need = 55020
elseif (self.zone_id == 123 and self.id == 4) then
    -- South, Fire - Fiery Eye from Fiery Island
    direction = "south"
    part = 2
    nxt = 12306
    need = 48109
elseif (self.zone_id == 123 and self.id == 5) then
    -- East, Air - cumulus bracelet from Dargentan
    direction = "east"
    part = 1
    nxt = 12304
    need = 8301
elseif (self.zone_id == 123 and self.id == 6) then
    -- West, Water - water from the hidden spring, or not - BAD STUFF
    -- This Keeper's request is the one to watch out for.
    direction = "west"
    part = 3
    nxt = 12303
    need = actor:get_quest_var("megalith_quest:goblet")
end

if actor:get_quest_stage("megalith_quest") == 2 then
    if (item == need) or ((self.zone_id == 123 and me == 6) and ((object.zone_id == 411 and item == 10) or (object.zone_id == 411 and item == 11) or (object.zone_id == 185 and item == 12))) then
        -- Already given, right item.
        local part_key = "item" .. tostring(part)
        if (actor:get_quest_var("megalith_quest:" .. part_key) or 0) == 1 then
            self:command("shake")
            self:say("You've already given me this.")
            return false  -- legacy return 0: the giver keeps the item
        elseif (actor:get_quest_var("megalith_quest:" .. direction) or 0) == 1 then
            -- Right item, wrong order.
            if part > 1 then
                local check = part - 1
                local check_key = "item" .. tostring(check)
                if (actor:get_quest_var("megalith_quest:" .. check_key) or 0) == 0 then
                    self:command("shake")
                    self.room:send(tostring(self.name) .. " says, 'We must cast the circle in order:")
                    self.room:send("East, South, West, North.")
                    self.room:send("Please deliver your offerings in that order.'")
                    return false  -- legacy return 0: the giver keeps the item
                end
            end
            -- Right set, wrong specific vessel at West.
            if (self.zone_id == 123 and me == 6) and ((item ~= need) or (object.val2 ~= 0)) then
                self:command("shake")
                self:say("I need water returned in the cup " .. tostring(mobiles.template(123, 1).name) .. " has consecrated.")
                return false  -- legacy return 0: the giver keeps the item
            else
                wait(0.2)
                actor:set_quest_var("megalith_quest", direction, 0)
                actor:set_quest_var("megalith_quest", part_key, 1)
                if direction == "north" then
                    self:say("Ah, excellent!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " before the menhir and kneels.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the North")
                    self.room:send("</>Spirits of Earth and Determination")
                elseif direction == "south" then
                    self:say("Marvelous!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " raises " .. tostring(object.shortdesc) .. " above her head.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the South")
                    self.room:send("</>Spirits of Fire and Feeling")
                elseif direction == "east" then
                    self:say("Great!  This will make a perfect offering.")
                    wait(0.6)
                    self.room:send(tostring(self.name) .. " shakes out " .. tostring(object.shortdesc) .. " like a blanket.")
                    self.room:send("She watches with delight as it dissolves into wisps of cloudy mist.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the East")
                    self.room:send("</>Spirits of Air and Intellect")
                elseif direction == "west" then
                    if (actor:get_quest_var("megalith_quest:item5") or 0) == 1 then
                        self:say("Ah, delightful!  This water will make a perfect offering.")
                        wait(0.6)
                    else
                        self:say("This will do.")
                        actor:set_quest_var("megalith_quest", "bad2", 1)
                        wait(0.6)
                    end
                    self.room:send(tostring(self.name) .. " pours the water from " .. tostring(object.shortdesc) .. " before the menhir.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " chants:")
                    self.room:send("'Hail to the guardian Spirits of the West")
                    self.room:send("</>Spirits of Water and Intuition")
                end
                self.room:send("</>I present this offering to you.")
                self.room:send("</>Aid us in our magical working on this great day.'")
                wait(5)
                world.destroy(object)
                self.room:send("The menhir begins to hum and glow!")
                wait(3)
                -- Next person.
                if ((actor:get_quest_var("megalith_quest:item1") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item2") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item3") or 0) == 1) and ((actor:get_quest_var("megalith_quest:item4") or 0) == 1) then
                    self:say("Now, return to " .. tostring(mobiles.template(123, 1).name) .. " at the altar and help her finish the call!")
                else
                    -- TODO(parity): nxt is still a legacy 5-digit vnum.
                    -- Translate to (zone, local_id) for catalog lookup.
                    local nxt_zone = math.floor(nxt / 100)
                    local nxt_id = nxt % 100
                    local nxt_template = mobiles.template(nxt_zone, nxt_id)
                    local nxt_name = nxt_template and nxt_template.name or ("the next Keeper")
                    self:say("Now, proceed to " .. tostring(nxt_name) .. " and continue invoking the elements.")
                end
            end
        end
    end
end
return _return_value$trig$, '44118bad7a42d68cca740a4f11e3bb52'),
  -- data/triggers/123/123_43_megalith_priestess_refuse.lua
  (123, 43, $trig$-- Converted from DG Script #12343: megalith_priestess_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("megalith_quest")
local response  -- hoisted from converter's branch-scoped locals

if stage ~= 1 and stage ~= 3 then
    response = "I need your help with something else."
elseif stage == 1 then
    -- TODO(parity): legacy 5-digit object vnums; split to (zone, id) once
    -- the canonical mapping is settled.
    if (object.zone_id == 237 and object.id == 56) or (object.zone_id == 411 and object.id == 11) or (object.zone_id == 411 and object.id == 10) or (object.zone_id == 185 and object.id == 12) or (object.zone_id == 85 and object.id == 7) or (object.zone_id == 173 and object.id == 0) or (object.zone_id == 86 and object.id == 12) or (object.zone_id == 588 and object.id == 9) then
        return _return_value
    else
        response = "Unfortunately, that's not going to help empower the ritual."
    end
elseif stage == 3 then
    if (object.zone_id == 238 and object.id == 17) or (object.zone_id == 43 and object.id == 5) or (object.zone_id == 43 and object.id == 18) or (object.zone_id == 580 and object.id == 15) or (object.zone_id == 580 and object.id == 18) or (object.zone_id == 584 and object.id == 26) or (object.zone_id == 584 and object.id == 18) then
        return _return_value
    else
        response = "Unfortunately, that's not going to help empower the ritual."
    end
end
if response then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say(tostring(response))
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '9f69976e7c9bfbce82709597a7e5576c'),
  -- data/triggers/125/125_19_brothersreunion.lua
  (125, 19, $trig$-- Converted from DG Script #12519: BrothersReunion
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.zone_id == 125 and object.local_id == 2 then
    _return_value = false
    if actor:get_quest_stage("krisenna_quest") == 4 then
        self:destroy_item("warhammer")
        wait(1)
        self:emote("weeps as he realizes that his brother is dead.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Thank you for finding him.  I will take word to my")
        self.room:send("</>family.'")
        wait(1)
        self:say("Please, take this for your efforts.")
        wait(1)
        self:say("It was our great grandfather's.")
        self.room:spawn_object(125, 50)
        self:command("give monocle " .. tostring(actor.name))
        wait(2)
        self:say("And take these as well.")
        local gem = 0
        while gem < 3 do
            self.room:spawn_object(557, 3 + random(1, 11))
            gem = gem + 1
        end
        self:command("give all.gem " .. tostring(actor.name))
        actor:complete_quest("krisenna_quest")
        --
        -- Set X to the level of the award - code does not run without it
        --
        local expcap
        if actor.level < 40 then
            expcap = actor.level
        else
            expcap = 40
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
        -- Adjust exp award by class so all classes receive the same proprotionate amount
        --
        -- switch on actor.class
        if actor.class == "warrior" or actor.class == "berserker" then
            --
            -- 110% of standard
            --
            expmod = (expmod + (expmod / 10))
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            --
            -- 115% of standard
            --
            expmod = (expmod + ((expmod * 2) / 15))
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            --
            -- 120% of standard
            --
            expmod = (expmod + (expmod / 5))
        elseif actor.class == "necromancer" or actor.class == "monk" then
            --
            -- 130% of standard
            --
            expmod = (expmod + (expmod * 2) / 5)
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
        wait(2)
        self.room:send(tostring(self.name) .. " becomes very silent.")
    else
        wait(2)
        self:say("Why yes, this -was- mine, thanks!")
        self:destroy_item("warhammer")
    end
else
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:say("I don't want this.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'e10d5219035c64a376914652257de525'),
  -- data/triggers/125/125_29_krisenna_refuse.lua
  (125, 29, $trig$-- Converted from DG Script #12529: Krisenna refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
-- DG receive arg list (55739 2339) with num_arg 0: this trigger ran for every other item.
-- The runtime does not filter on arg_list, so the exclusion lives here.
if (object.zone_id == 557 and object.id == 39) or
    (object.zone_id == 23 and object.id == 39) then
    return true
end

self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:command("snarl " .. tostring(actor.name))
self:say("You try to appease me with trinkets?  Bah.")
return false  -- legacy return 0: the giver keeps the item$trig$, '4b32e9544405126e637618b187dc08bf'),
  -- data/triggers/163/163_08_quest_eleweiss_ranger_druid_subclass_receive.lua
  (163, 8, $trig$if not (
    (object.zone_id == 172 and object.id == 12)
) then
    return true
end

wait(0.2)
if actor:get_quest_stage("ran_dru_subclass") == 4 then
    self:emote("throws back his head and howls loudly with pleasure.")
    wait(0.3)
    self:command("shake " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'You have done me a great service!  I cannot believe I have it back!'")
    self:command("grin")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Type <b:green>'subclass'</> to proceed.'")
    actor:complete_quest("ran_dru_subclass")
else
    -- switch on actor:get_quest_stage("ran_dru_subclass")
    do
        local _sw1 = string.lower(tostring(actor:get_quest_stage("ran_dru_subclass") or ""))
        if tonumber(_sw1) == 1 or tonumber(_sw1) == 2 then
            actor:send(tostring(self.name) .. " says, 'Woah, slow down, I have not even told you the quest yet!'")
        elseif tonumber(_sw1) == 3 then
            actor:send(tostring(self.name) .. " says, 'How on earth did you bring me the jewel of the heart without getting it yourself?'")
            self:command("chuckle")
        else
            actor:send(tostring(self.name) .. " says, 'Nice little gift, thanks much.'")
            self:emote("tucks it into his cloak.")
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'Pity you were not on a quest for me, this could have been worth it for you.'")
        end
    end
end
self:destroy_item("jewel")$trig$, '02f77d6526ee18c9334cde69fe8c0f71'),
  -- data/triggers/163/163_49_moonwell_vine_receive.lua
  (163, 49, $trig$if not (
    (object.zone_id == 163 and object.id == 50)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 1 then
    wait(0.2)
    self:destroy_item("vine")
    actor:send(tostring(self.name) .. " tells you, 'How did you get this?  No, go get it yourself.'")
elseif actor:get_quest_stage("moonwell_spell_quest") == 2 then
    wait(0.2)
    self:destroy_item("vine")
    actor:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Very good.  I can now lay out the well's boundaries.'")
    wait(1)
    self.room:send(tostring(self.name) .. " places the vine in a small circle on the ground.")
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Excellent.  Now we must have stone.  Of course there is")
    actor:send("</>plenty of stone here, but we need to have a stone with significant energy to")
    actor:send("</>act as a magical anchor point.'")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Far to the north there is an ancient burial site.  Within")
    actor:send("</>its catacombs lays a stone of great power, shaped like a heart.  Obtain this")
    actor:send("</>stone and it will surely increase our well's power.'")
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'Go now while I continue construction of our well.'")
    wait(2)
    self.room:send(tostring(self.name) .. " begins to collect some rocks and place them around the vine circle.")
end$trig$, 'ceefc837d3a0ee08bf4663fb09bc05d8'),
  -- data/triggers/163/163_52_moonwell_heartstone_receive.lua
  (163, 52, $trig$if not (
    (object.zone_id == 480 and object.id == 24)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 3 then
    wait(0.2)
    actor:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Very good! This will work perfectly as an anchor stone.'")
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " in the center of the well's outline.")
    self:destroy_item("jewel")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Back when I was still mortal, I frequently traveled with")
    actor:send("</>Eleweiss, a ranger of great skill and magical acumen.  We once ventured north")
    actor:send("</>into the frozen mountains, and came across a cult that worshipped a")
    actor:send("</>particularly nasty white dragon.  Due to some unfortunate circumstances, we")
    actor:send("</>ended up having to battle the dragon and were forced to retreat.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'In our retreat, Eleweiss lost a flask which contained")
    actor:send("</>water blessed by the Goddess Herself.  That water would be ideal for our magic")
    actor:send("</>well.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'I imagine the flask is the kind of thing a dragon would")
    actor:send("</>add to its treasure hoard.  Please take revenge for us and obtain the flask.'")
end$trig$, '7e4264938e3b31c6f66a7e29bbf49c86'),
  -- data/triggers/163/163_53_moonwell_flask_receive.lua
  (163, 53, $trig$if not (
    (object.zone_id == 163 and object.id == 56)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 4 then
    wait(0.2)
    self:destroy_item("flask")
    actor:send(tostring(self.name) .. " tells you, 'How did you get this?  No no, go get it yourself.'")
elseif actor:get_quest_stage("moonwell_spell_quest") == 5 then
    wait(0.2)
    self:destroy_item("flask")
    actor:advance_quest("moonwell_spell_quest")
    actor:send(tostring(self.name) .. " tells you, 'Thank you, thank you.'")
    wait(1.5)
    self.room:send(tostring(self.name) .. " opens the flask and pours the water into the boundary of the well while reciting a prayer to Mielikki.")
    wait(0.4)
    self.room:send("The boundary of the well becomes translucent and starts to glow!")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Okay now we need some items of power to place around the")
    actor:send("</>outside edge of the well.'")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Each needs to be either an orb or circle to reflect the")
    actor:send("</>circular boundary of the well itself.'")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'The first item shall be a ring representing Fire.  Fire")
    actor:send("</>is most closely associated with rubies, so a ruby ring would be good.  One from")
    actor:send("</>a place connected with fire would be ideal!'")
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'Oh, before you leave.  Here takes this.'")
    self.room:spawn_object(163, 51)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'That will help you keep track of everything.'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Now go!'")
end$trig$, 'ca9ce3dd8915a19d709a0083c68bd77e'),
  -- data/triggers/163/163_54_moonwell_ruby_receive.lua
  (163, 54, $trig$if not (
    (object.zone_id == 52 and object.id == 1)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 6 then
    wait(0.2)
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    actor:send(tostring(self.name) .. " tells you, 'Good.  Thank you!'")
    wait(1.5)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " starts flickering with sparking lights!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Now that we have the first symbol, we can go for the")
    actor:send("</>second.  The second item we need is an orb, representing the element of Air.")
    actor:send("</>This orb is somewhere in a dark fortress to the east.  Please obtain the orb.'")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Oh wait, please allow me to update your map.'")
    world.destroy(object)
end$trig$, '61f27a388eb7747a74fe6751edf2f087'),
  -- data/triggers/163/163_55_moonwell_map_1_receive.lua
  (163, 55, $trig$-- DG receive arg list (16351): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 163 and object.id == 51)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") ~= 6 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    self.room:spawn_object(163, 52)
    wait(1.5)
    self.room:send(tostring(self.name) .. " quickly marks something on the bark map.")
    self:command("give map " .. tostring(actor.name))
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'There you go!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '5f181d18ff2cceebab0b77707c571af2'),
  -- data/triggers/163/163_56_moonwell_winds_receive.lua
  (163, 56, $trig$if not (
    (object.zone_id == 160 and object.id == 6)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 7 then
    wait(0.2)
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(1.5)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " begins to swirl like the howling winds!")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'We're making good progress.'")
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Now that you have obtained the second element, please let")
    actor:send("</>me mark your map.'")
    self:destroy_item("orb")
end$trig$, '5b43b050b72a2ebb99709cbb65a16393'),
  -- data/triggers/163/163_57_moonwell_map_2_receive.lua
  (163, 57, $trig$-- DG receive arg list (16352): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 163 and object.id == 52)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") ~= 7 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(1.5)
    self:destroy_item("map")
    self.room:spawn_object(163, 53)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    wait(0.5)
    actor:send(tostring(self.name) .. " tells you, 'Okay, the third element in this ritual is Water.  In\n"
        .. "</>magic, water is often represented by jade.'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'I know of a jade ring held by a wood nymph on an island\n"
        .. "</>where other members of our Order are beset by beasts.'")
    wait(4)
    actor:send("</>But be careful, for 'tis a dangerous place for the unprepared!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'f93ffec4a1637a59b2ce04c12708d377'),
  -- data/triggers/163/163_58_moonwell_jade_receive.lua
  (163, 58, $trig$if not (
    (object.zone_id == 490 and object.id == 11)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 9 then
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(0.5)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " dissipates into a circle of undulating soft blue-green light.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Good.  Please give me your map so I may update it.'")
    self:destroy_item("ring")
end$trig$, '13ffed292dae4bae1655cd84585de455'),
  -- data/triggers/163/163_59_moonwell_map_3_receive.lua
  (163, 59, $trig$-- DG receive arg list (16353): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 163 and object.id == 53)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") ~= 9 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    wait(1.5)
    self.room:spawn_object(163, 54)
    self.room:send(tostring(self.name) .. " quickly marks another check on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Okay, there are two items left.  This next might seem\n"
        .. "</>odd, but we need a single item of evil and chaos to mislead forces that wish to\n"
        .. "</>harm us while traveling through the well.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'There is an orb that will serve this function well.  But\n"
        .. "</>as with so many such powerful relics, it is guarded by a great dragon hidden in\n"
        .. "</>a hellish labyrinth.'")
    wait(5)
    actor:send(tostring(self.name) .. " tells you, 'Get this orb that we might protect ourselves!'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'cc6eb403d44d67056c4bc99948a7e99f'),
  -- data/triggers/163/163_60_moonwell_chaos_receive.lua
  (163, 60, $trig$if not (
    (object.zone_id == 40 and object.id == 3)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 10 then
    wait(0.2)
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(1)
    self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " along the circumference of the circle and utters a prayer.")
    wait(1)
    self.room:send(tostring(object.shortdesc) .. " crackles and shatters, shooting streaks of red lightning around the periphery of the well.")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Please give me the map to update!'")
    self:destroy_item("orb")
end$trig$, '045e205ea1d6e36eef2364ed284550ee'),
  -- data/triggers/163/163_61_moonwell_map_4_receive.lua
  (163, 61, $trig$-- DG receive arg list (16354): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 163 and object.id == 54)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") ~= 10 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) == 1 then
    actor:advance_quest("moonwell_spell_quest")
    actor:set_quest_var("moonwell_spell_quest", "map", 0)
    wait(0.2)
    self:destroy_item("map")
    wait(1.5)
    self.room:spawn_object(163, 55)
    self.room:send(tostring(self.name) .. " marks something on the bark map.")
    wait(1.5)
    self:command("give map " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'Lastly, we need the item for the Earth.  There is a ring\n"
        .. "</>made of mundane stone kept in a large temple hidden in a mountain.  Obtain this\n"
        .. "</>final ring and we can finish this ceremony.'")
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'I need the orb first.'")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, '39122fde07087e4a01e7f4a4eae51906'),
  -- data/triggers/163/163_62_moonwell_granite_receive.lua
  (163, 62, $trig$if not (
    (object.zone_id == 550 and object.id == 20)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") == 11 then
    wait(0.2)
    self:destroy_item("ring")
    actor:set_quest_var("moonwell_spell_quest", "map", 1)
    wait(1.5)
    actor:send(tostring(self.name) .. " tells you, 'Excellent, hand me your map so that I may finish this.'")
end$trig$, '406bbb67d6b0a235d445565dde8161e1'),
  -- data/triggers/163/163_63_moonwell_map_5_receive.lua
  (163, 63, $trig$-- DG receive arg list (16355): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 163 and object.id == 55)
) then
    return true
end

if actor:get_quest_stage("moonwell_spell_quest") ~= 11 then
    return true
end

if (actor:get_quest_var("moonwell_spell_quest:map") or 0) ~= 1 then
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    return false  -- legacy return 0: the giver keeps the item
end

wait(1.5)
self:destroy_item("map")
self.room:spawn_object(163, 66)
self.room:send(tostring(self.name) .. " completes her drawing on the bark map.")
wait(1.5)
self:command("give map " .. tostring(actor.name))
if actor.gender == "female" then
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Sister, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
else
    actor:send(tostring(self.name) .. " tells you, 'Keep that map Brother, that you may never forget how to\n"
        .. "</>conduct this ceremony.'")
end
wait(2)
actor:send(tostring(self.name) .. " tells you, 'Let us finish the ceremony.'")
self.room:send(tostring(self.name) .. " places " .. tostring(objects.template(550, 20).name) .. " at the edge of the circle and prays.")
wait(0.5)
self.room:send("<magenta>A </>moonwell <magenta>appears at " .. tostring(self.name) .. "'s feet!</>")
wait(2)
self.room:send("<b:cyan>The moonwell begins to <b:magenta>swirl</>!")
wait(2.5)
run_room_trigger(163, 48)
wait(3)
self.room:send("A soft yet loud voice says, 'You have done well young dryad.  Perhaps you truly\n"
    .. "</>are repentant.  For your service, I release you from your shackles.'")
wait(1)
self.room:send("The voice says, 'Remember this always.'")
wait(1.5)
self.room:send("A bright flash of light pierces the area and the dryad is transformed into a beautiful mortal woman!")
wait(1)
self.room:send("The beautiful druid says, 'Thank you my Goddess, Mielikki!  At last, I am free\n"
    .. "</>again!'")
wait(2)
self.room:send("The beautiful druid bows deeply, enters the moonwell and disappears!")
actor:complete_quest("moonwell_spell_quest")
skills.set_level(actor, "moonwell", 1000)
world.destroy(self)
return true$trig$, '3128bfee60e759a6edb280b1f5215b4c'),
  -- data/triggers/163/163_64_moonwell_receive_decline.lua
  (163, 64, $trig$local stage = actor:get_quest_stage("moonwell_spell_quest")

if (stage == 1 or stage == 2 or stage == 3) and (object.zone_id == 163 and object.id == 50) then
    return true
elseif (stage == 3 or stage == 4) and (object.zone_id == 480 and object.id == 24) then
    return true
elseif (stage == 4 or stage == 5 or stage == 6) and (object.zone_id == 163 and object.id == 56) then
    return true
elseif stage == 6 and (object.zone_id == 52 and object.id == 1) then
    return true
elseif stage == 7 and ((object.zone_id == 160 and object.id == 6) or (object.zone_id == 163 and object.id == 51)) then
    return true
elseif stage == 8 and (object.zone_id == 163 and object.id == 52) then
    return true
elseif stage == 9 and (object.zone_id == 490 and object.id == 11) then
    return true
elseif stage == 10 and ((object.zone_id == 40 and object.id == 3) or (object.zone_id == 163 and object.id == 53)) then
    return true
elseif stage == 11 and ((object.zone_id == 550 and object.id == 20) or (object.zone_id == 163 and object.id == 54) or (object.zone_id == 163 and object.id == 55)) then
    return true
end

actor:send(tostring(self.name) .. " tells you, 'I do not want this from you.'")
actor:send(tostring(self.name) .. " returns your item to you.")
return false  -- block the receive: bounce the item back to the actor$trig$, 'd2cfd263cc5ba549ad39f903d50c455d'),
  -- data/triggers/172/172_05_ill-subclass_return_the_choker_to_the_grand_master.lua
  (172, 5, $trig$-- DG receive arg list (17214): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 172 and object.id == 14)
) then
    return true
end

if actor:get_quest_stage("illusionist_subclass") == 6 then
    wait(0.2)
    self:destroy_item("choker")
    wait(0.2)
    self:command("smile " .. tostring(actor.name))
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Fantastic work!  The smugglers must be in utter disarray!  You've done well.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I can see that your skill in misdirection is extremely extremely promising.  You have my leave to join the illusionists.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now, type <b:magenta>'subclass'</>.'")
    actor:complete_quest("illusionist_subclass")
    wait(2)
    self:command("wink " .. tostring(actor.name))
    return true
end
self:command("frown")
self:emote("peers closely at the choker.")
actor:send(tostring(self.name) .. " says, 'I'm sorry... there must be some mistake.  This isn't the choker I gave Cestia.'")
actor:send(tostring(self.name) .. " says, 'I'm certain of it.'")
self:emote("returns the choker.")
return false  -- legacy return 0: the giver keeps the item$trig$, '2d9e380089a7bc5bde9a5dd1246fdc55'),
  -- data/triggers/185/185_05_give_chalice_silania.lua
  (185, 5, $trig$if not (
    (object.zone_id == 185 and object.id == 12)
) then
    return true
end

wait(2)
-- stage is set to 3 when chalice retrieved
if actor:get_quest_stage("pri_pal_subclass") == 3 then
    self:emote("beams a huge smile.")
    wait(3)
    self:command("hug " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'You have done me a great service, and earned your place among the truly holy.'")
    self:command("smi")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Type <b:white>'subclass'</> to proceed.'")
    actor:complete_quest("pri_pal_subclass")
elseif actor:get_quest_stage("pri_pal_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'Hmmm, jumping the gun a bit aren't we?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I didn't even tell you the quest yet.'")
else
    actor:send(tostring(self.name) .. " says, 'Thank you greatly for returning this.'")
    self:command("thank " .. tostring(actor.name))
    wait(2)
    if actor:get_quest_stage("pri_pal_subclass") == 2 then
        -- hmm..they got the chalice without running the appropriate trigger
        -- could they be cheating?
        actor:send(tostring(self.name) .. " says, 'Hmm... I don't know how you got hold of this, but I will give you the benefit of the doubt and not fail you.'")
        self:command("poke " .. tostring(actor.name))
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Now... go and get the chalice properly yourself!'")
    else
        actor:send(tostring(self.name) .. " says, 'Shame you were not performing the quest.  Your selfless act would have qualified you for our holy brotherhood.'")
    end
end
-- junk the chalice
self:destroy_item("chalice")$trig$, '710a93df1888941c840d6545e3a6b4f6'),
  -- data/triggers/185/185_20_group_heal_doctor_receive.lua
  (185, 20, $trig$local stage = actor:get_quest_stage("group_heal")

if stage == 2 then
    if object.zone_id == 185 and object.local_id == 13 then
        self:destroy_item("supplies")
        wait(2)
        self:say("Thank you so much!  This is an enormous relief!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Now I can get to working on that ritual to create a portable")
        self.room:send("</>healing spell and teach you about healing groups of people in the process,")
        self.room:send("</>" .. tostring(actor.name) .. ".'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Based on books I found in our library, historical records")
        self.room:send("</>indicate the last anyone heard of this spell a hearth priest was working on")
        self.room:send("</>perfecting it.  He worked out of a kitchen somewhere in the")
        self.room:send("</><green>Great Northern Swamps</>.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'I'm not sure how helpful that is, but maybe if you <b:white>search</>")
        self.room:send("</>through some of the abandoned kitchens out there, you'll find something useful.'")
        local roll = random(1, 3)
        local target_room
        if roll == 1 then
            target_room = 16051   -- Mystwatch (TODO: split to (zone,id))
        elseif roll == 2 then
            target_room = 51012   -- Nordus    (TODO: split to (zone,id))
        else
            target_room = 53178   -- Sunken    (TODO: split to (zone,id))
        end
        actor:set_quest_var("group_heal", "room", target_room)
        actor:advance_quest("group_heal")
    else
        self.room:send(tostring(self.name) .. " says, 'These aren't our missing supplies.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 4 then
    if object.zone_id == 185 and object.local_id == 14 then
        actor:advance_quest("group_heal")
        wait(2)
        self:emote("scans through the book.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Strange, this doesn't look like a ritual at all, at least")
        self.room:send("</>not in the strictest sense.  It looks more like... like a meal.'")
        wait(1)
        self:say("A very BIG meal...")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Huh... Well those sure are some unusual dishes.  I've never")
        self.room:send("</>seen anything quite like this before.  I don't even know what half these")
        self.room:send("</>ingredients are.'")
        wait(4)
        self:say("I'm a doctor, dammit, not a chef!")
        wait(2)
        self:command("ponder")
        wait(2)
        self:say("A chef!  That's it!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Could you go consult with different <b:white>chefs</> and <b:white>cooks</> to")
        self.room:send("</>figure out what these things are?  I'm sure I can procure the ingredients once")
        self.room:send("</>I know what I actually need.'")
        wait(5)
        self:say("It looks like there are six parts to this.")
        wait(1)
        self:command("give rite " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Seek out a professional for each part, <b:white>give them the rite</>,")
        self.room:send("</>and get some notes from them.'")
        wait(3)
        self:say("Thank you for your help!")
    else
        self:say("This doesn't look like it will be of any help.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 5 then
    if object.zone_id == 185 and (object.local_id == 15 or object.local_id == 16 or object.local_id == 17 or object.local_id == 18 or object.local_id == 19 or object.local_id == 20) then
        local notes_key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
        if (actor:get_quest_var("group_heal:" .. notes_key) or 0) == 1 then
            self:command("shake")
            self:say("You already brought me " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
            return false  -- legacy return 0: the giver keeps the item
        else
            self:destroy_item("notes")
            actor:set_quest_var("group_heal", notes_key, 1)
            local total = (actor:get_quest_var("group_heal:total") or 0) + 1
            actor:set_quest_var("group_heal", "total", total)
            wait(2)
            self:say("Thank you!")
            wait(1)
            self:emote("studies the notes.")
            wait(2)
            self:say("Ah yes, I see.")
            wait(1)
            local roll = random(1, 4)
            if roll == 1 then
                self:say("I can substitute that with that?  Interesting!")
            elseif roll == 2 then
                self:say("That looks like a very reasonable suggestion!")
            elseif roll == 3 then
                self:say("Oh so that's what that thing is called now...")
            else
                self:say("I see how this works!")
            end
            if total == 6 then
                actor:advance_quest("group_heal")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'That looks like everything!  May I have that copy of the Rite")
                self.room:send("</>please?'")
            else
                wait(1)
                self:say("Please, bring me the notes on the rest of the rite!")
            end
        end
    end
elseif stage == 6 then
    if object.zone_id == 185 and object.local_id == 14 then
        actor:set_quest_var("group_heal", "total", 0)
        wait(2)
        self:destroy_item("heroes-feast")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I think I can put this together now!!  Wait here while I")
        self.room:send("</>prepare the feast.'")
        wait(2)
        self:emote("leaves for the kitchens.")
        self:teleport(get_room(11, 0))
        wait(8)
        get_room(185, 30):at(function()
            self.room:send("Delicious smells and the sound of chanting begin to waft in from the courtyard.")
        end)
        wait(10)
        self:teleport(get_room(185, 30))
        self:emote("returns with an incredible feast!")
        wait(4)
        self:emote("carefully divides up the feast and neatly packages it along with medical supplies.")
        for _ = 1, 5 do
            self.room:spawn_object(185, 21)
        end
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'The final thing I ask is for you to go out into the world")
        self.room:send("</>and help those in need.'")
        wait(4)
        self:say("Here, take these care packages of food and medicine.")
        wait(2)
        self:command("give all.food " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Seek out five creatures who are <b:white>sick</>, <b:white>injured</>, <b:white>dying</>,")
        self.room:send("</><b:white>wounded</>, or <b:white>hobbling</>. Bring them succor with those packages.'")
        wait(4)
        self:say("Except for Lirne.")
        wait(2)
        self:command("grumble")
        wait(2)
        self:say("He needs to learn his lesson eventually.")
        wait(4)
        self:say("May St. George ever smile upon your endeavors!")
        wait(2)
        self:command("wave " .. tostring(actor.name))
    else
        self:say("I'm afraid this won't be of much use to me right now.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self:say("I'm afraid this won't be of much use to me right now.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    return false  -- legacy return 0: the giver keeps the item
end

return true$trig$, '69d7e79a533c49a40f7b1a203f245476'),
  -- data/triggers/185/185_22_group_heal_chefs_receive.lua
  (185, 22, $trig$local function is_mob(zone, id)
    return self.zone_id == zone and self.local_id == id
end

local function chef_already_consulted()
    return (actor:get_quest_var("group_heal:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) or 0) == 1
end

local function refuse_misc()
    if is_mob(502, 3) then  -- zombified pirate cook
        actor:send(tostring(self.name) .. " moans and swats your hand away.")
        self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
    elseif is_mob(510, 7) then  -- crazy chef
        self:command("cackle " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " inches away from you.")
        self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
    else
        self:say("Sorry, what is this?")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
end

if object.zone_id ~= 185 or object.local_id ~= 14 or actor:get_quest_stage("group_heal") ~= 5 then
    refuse_misc()
    return false  -- legacy return 0: the giver keeps the item
end

if chef_already_consulted() then
    if is_mob(502, 3) then
        actor:send(tostring(self.name) .. " moans and swats your hand away.")
        self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
    elseif is_mob(510, 7) then
        self:command("cackle " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " inches away from you.")
        self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
    else
        self:say("I've told you everything I can.  Good luck!")
    end
    return false  -- legacy return 0: the giver keeps the item
end

-- Legacy DG opened with `return 0`: the giver always keeps the item. This path waits below, so
-- the engine counts the item as accepted; hand it back explicitly.
require("dg").give(self, object, actor)
actor:set_quest_var("group_heal", tostring(self.zone_id) .. "_" .. tostring(self.local_id), 1)

local notes_id = nil
if is_mob(83, 7) then            -- the Frakati Chef
    self:say("So you would like some help?  Looks like quite a meal.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Roasting methods may be a little difficult to control.")
    self.room:send("</>I can share with you some methods the Frakati people use to prepare and roast")
    self.room:send("</>wild game.'")
    wait(4)
    self:emote("writes down several notes.")
    wait(3)
    notes_id = 15
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'These small tips will make sure your meats stay tender")
    self.room:send("</>and juicy while soaking up as much flavor as possible.'")
    wait(2)
    self:say("Good luck.")
elseif is_mob(510, 7) then       -- the crazy chef
    self:emote("begins to run in a circle laughing hysterically.")
    wait(4)
    self:emote("stops running and starts writing.")
    wait(2)
    self.room:send(tostring(self.name) .. " keeps laughing and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(2)
    self.room:send("... and writing...")
    wait(4)
    notes_id = 16
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
    self:command("laugh " .. tostring(actor.name))
elseif is_mob(185, 12) then      -- a scruffy cook
    self.room:send(tostring(self.name) .. " says, 'Well what is this?  I heard the doctor talking about a")
    self.room:send("</>feast of some kind...'")
    wait(2)
    self:emote("trails off while reading the ritual recipe.")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Well I can definitely help out with some of this.")
    self.room:send("</>Desserts aren't considered a specialty of our Abbey because most bakers")
    self.room:send("</>prefer techniques and ingredients no longer suited for monastic life.'")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'But since we still see the value in what you can grow")
    self.room:send("</>and process by hand, I can easily help replicate a recipe this old.'")
    wait(4)
    notes_id = 17
    self.room:spawn_object(185, notes_id)
    self:emote("writes down a list of notes.")
    self:command("give notes " .. tostring(actor.name))
    wait(1)
    self:say("This should meet the doctor's needs.")
elseif is_mob(300, 3) then       -- Dugrik
    self.room:send(tostring(self.name) .. " says, 'Normally I'd charge for this.  But since that's \"illegal\" here")
    self.room:send("</>now, I guess you got lucky.'")
    wait(3)
    self:say("Yeah, I see something I can help with.")
    wait(3)
    self:emote("points to several spots on the paper.")
    self:say("Make this adjustment here, here, and here.")
    wait(4)
    self:emote("points to another section.")
    self.room:send(tostring(self.name) .. " says, 'This word just means \"boil.\"  It will do exactly the same thing if")
    self.room:send("</>you just boil it.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Oh and be real careful with that one there.  Unless you got an")
    self.room:send("</>orcish constitution, cook it wrong and you can poison yourself.'")
    self:command("chuckle")
    wait(1)
    notes_id = 18
    self.room:spawn_object(185, notes_id)
    self:command("give notes " .. tostring(actor.name))
elseif is_mob(502, 3) then       -- the zombified pirate cook
    self.room:send(tostring(self.name) .. " moans.")
    wait(2)
    self:emote("shambles into the wall with a great THUD!")
    self.room:send("A book of barely preserved pieces of paper falls from a shelf onto what remains of " .. tostring(self.name) .. "'s head.")
    notes_id = 19
    self.room:spawn_object(185, notes_id)
    wait(1)
    self:command("drop notes")
end

return true$trig$, '53dd4874aeadd8e982a5a390e2a759ce'),
  -- data/triggers/237/237_28_serin-receive.lua
  (237, 28, $trig$-- Converted from DG Script #23728: serin-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Responding to trigger 23723 after they actually have the items.
-- Tracks each treasure individually via quest vars; on the third real piece,
-- advances and completes the quest with an XP/badge reward.

-- Helper: identify which elven treasure (zone 520) was offered.
-- Returns one of: "boots", "cloak", "ring", "cursed_boots", "cursed_cloak",
-- "cursed_ring", or nil for anything else.
local function identify_treasure(obj)
    if obj.zone_id ~= 520 then
        return nil
    end
    local id = obj.local_id
    if id == 8 then return "boots"
    elseif id == 24 then return "cursed_boots"
    elseif id == 9 then return "cloak"
    elseif id == 26 then return "cursed_cloak"
    elseif id == 1 then return "ring"
    elseif id == 18 then return "cursed_ring"
    end
    return nil
end

if actor.is_npc then
    return false  -- legacy return 0: the giver keeps the item
end
if actor.level > 99 then
    self:command("eyebrow")
    return false  -- legacy return 0: the giver keeps the item
end

local boots = actor:get_quest_var("sunfire_rescue:boots") or 0
local cloak = actor:get_quest_var("sunfire_rescue:cloak") or 0
local ring = actor:get_quest_var("sunfire_rescue:ring") or 0

if actor:get_has_completed("sunfire_rescue") then
    self:say("You have already helped me.  I am grateful to you.")
    return false  -- legacy return 0: the giver keeps the item
end

if actor:get_quest_stage("sunfire_rescue") ~= 1 then
    self:say("What are you doing?")
    return false  -- legacy return 0: the giver keeps the item
end

local kind = identify_treasure(object)

-- Reject cursed items outright.
if kind == "cursed_boots" then
    self:emote("looks at the boots carefully.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'These are the cursed boots.  If you have the real ones,")
    self.room:send("</>please...  These cannot help me at all.  Do you have the real ones?  I need")
    self.room:send("</>them.'")
    return false  -- legacy return 0: the giver keeps the item
elseif kind == "cursed_cloak" then
    self:emote("runs his hands over the cloak quickly.")
    self:say("This is the cursed cloak!")
    self:emote("looks angry.")
    actor:send("shoves " .. tostring(object.shortdesc) .. " back in your face.")
    self.room:send_except(actor, "shoves " .. tostring(object.shortdesc) .. " back in " .. tostring(actor.name) .. "'s face.")
    self:say("Well?  Do you have the real cloak to give to me?")
    self:emote("taps his foot impatiently.")
    return false  -- legacy return 0: the giver keeps the item
elseif kind == "cursed_ring" then
    self:command("frown " .. tostring(actor.name))
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("What kind of cruel trick is this?")
    self:say("Well, do you have the real one to give to me?")
    return false  -- legacy return 0: the giver keeps the item
end

-- Real treasures: accept each at most once.
if kind == "boots" then
    if boots == 1 then
        self:say("You have already given me these.")
        return false  -- legacy return 0: the giver keeps the item
    end
    actor:set_quest_var("sunfire_rescue", "boots", 1)
    boots = 1
    wait(0.2)
    world.destroy(object)
    self:command("smile " .. tostring(actor.name))
    self:say("Thank you.")
    wait(1)
elseif kind == "cloak" then
    if cloak == 1 then
        self:say("You have already given me the cloak.")
        return false  -- legacy return 0: the giver keeps the item
    end
    actor:set_quest_var("sunfire_rescue", "cloak", 1)
    cloak = 1
    wait(0.2)
    world.destroy(object)
    self:emote("carefully looks at the cloak.")
    self:say("This is it!  Thank you!")
    wait(1)
    self:say("Then I can finally escape....")
elseif kind == "ring" then
    if ring == 1 then
        self:say("You have already given me this ring.")
        return false  -- legacy return 0: the giver keeps the item
    end
    actor:set_quest_var("sunfire_rescue", "ring", 1)
    ring = 1
    wait(0.2)
    self.room:send("Looking at the ring, the prisoner looks overwhelmed with emotion.")
    self:say("Escape is so close I can feel it!")
    world.destroy(object)
else
    self:say("This isnt going to help me!")
    self:command("roll")
    return false  -- legacy return 0: the giver keeps the item
end

-- Has the player now turned in all three treasures?
local total = boots + cloak + ring
if total < 3 then
    wait(1)
    self:say("Do you have the other treasures of my people?")
    return true
end

-- All three -- complete the quest.
wait(2)
self:emote("slips his feet out of the shackles and wears the boots.")
wait(2)
self:emote("unshackles his arms and wears the cloak on his shoulders.")
wait(2)
self.room:send("Looking hesitant, the prisoner slowly slides the ring onto his finger.")
actor:advance_quest("sunfire_rescue")
self.room:spawn_object(237, 16)
self:destroy_item("all.elven")
wait(3)
self:emote("vanishes from sight.")

-- The badge reward is level 50, but the players have to be 70 or so
-- to handle the boots, cloak etc anyway.
local expcap
if actor.level < 85 then
    expcap = actor.level
else
    expcap = 85
end

local expmod
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

-- Adjust exp award by class so all classes receive the same proportionate amount.
if actor.class == "warrior" or actor.class == "berserker" then
    -- 110% of standard
    expmod = expmod + (expmod / 10)
elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
    -- 115% of standard
    expmod = expmod + ((expmod * 2) / 15)
elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
    -- 120% of standard
    expmod = expmod + (expmod / 5)
elseif actor.class == "necromancer" or actor.class == "monk" then
    -- 130% of standard
    expmod = expmod + ((expmod * 2) / 5)
end

actor:send("<b:yellow>You gain experience!</>")
local setexp = expmod * 10
for _ = 1, 10 do
    actor:award_exp(setexp)
end
actor:complete_quest("sunfire_rescue")
wait(2)
actor:send(tostring(self.name) .. " whispers to you, 'Thank you for your help!  Please wear this badge as a token of my respect.'")
self:command("give badge " .. tostring(actor.name))
wait(2)
self.room:send("A voice softly echos, 'Good-bye...'")
world.destroy(self.room:find_actor("serin"))
return true$trig$, '6792b124c58019781a540c67c2c884fb'),
  -- data/triggers/237/237_52_receive-rewards.lua
  (237, 52, $trig$-- Converted from DG Script #23752: receive-rewards
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Vilekka receives the heart (stage 1 -> 2), the drider king's head
-- (stage 3 -> 4), or the ten herbs/spices (stage 5 completion).

-- Helper: is this object one of the accepted spices for stage 5?
-- Returns the canonical spice key (string) or nil.
local function spice_key(obj)
    local z, id = obj.zone_id, obj.local_id
    if z == 125 and id == 52 then return "12552" end
    if z == 490 and id == 22 then return "49022" end
    if z == 237 and id >= 50 and id <= 60 then
        return tostring(23700 + id)
    end
    return nil
end

local accepted = false

-- Stage 1 -> 2: drow master's heart (object 237/21).
if object.zone_id == 237 and object.local_id == 21 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 1 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.heart")
        self:say("Excellent!")
        wait(1)
        self.room:send("The High Priestess takes the heart and places it gently on the altar.")
        self:command("smirk")
        wait(1)
        self:say("You have done me and my city a great service!  Do you wish to continue or stop now?")
        self:command("tap")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 3 -> 4: drider king's head (object 237/20).
if object.zone_id == 237 and object.local_id == 20 then
    for _, person in ipairs(actor.group) do
        if person.room == self.room and person:get_quest_stage("vilekka_stew") == 3 then
            person:advance_quest("vilekka_stew")
            person:send("<b:white>You have advanced the quest!</>")
            accepted = true
            -- Cross-quest credit for hell_trident.
            if not person:get_quest_var("hell_trident:helltask6")
                and person:get_quest_stage("hell_trident") == 1 then
                person:set_quest_var("hell_trident", "helltask6", 1)
                person:send("<magenta>You have successfully assisted " .. tostring(self.name) .. " in service of Lolth!</>")
            end
        end
    end
    if accepted then
        wait(1)
        self:destroy_item("all.head")
        actor:send(tostring(self.name) .. " says, 'You are quite resourceful!  This is a great benefit to the entire city.'")
        self:emote("places the severed head on the altar, where it lolls around.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'But your work may not yet be finished...  Do you wish to continue, or stop here?'")
        self.room:send("<b:white>All characters must choose individually.</>")
        return true
    end
end

-- Stage 5: spices and herbs.
if actor:get_quest_stage("vilekka_stew") == 5 then
    local key = spice_key(object)
    local is_spice = key ~= nil
    -- Reject duplicates.
    local already_given = key
        and (actor:get_quest_var("vilekka_stew:got_spice:" .. key) or 0) == 1
    if (not is_spice) or already_given then
        self:emote("refuses to accept " .. tostring(object.shortdesc) .. ".")
        if is_spice then
            actor:send(tostring(self.name) .. " says, 'You have already given me " .. tostring(object.shortdesc) .. ".'")
        else
            actor:send(tostring(self.name) .. " says, 'What is this?  I need the spices!'")
        end
        return false  -- legacy return 0: the giver keeps the item
    end
    wait(1)
    local num_spices = 1 + (actor:get_quest_var("vilekka_stew:num_spices") or 0)
    actor:set_quest_var("vilekka_stew", "num_spices", num_spices)
    actor:set_quest_var("vilekka_stew", "got_spice:" .. key, 1)
    accepted = true
    if num_spices < 10 then
        self:destroy_item("herb")
        -- Per-spice progress acknowledgement.
        if num_spices == 1 then
            actor:send(tostring(self.name) .. " says, 'Very good!  But I still need nine more.'")
        elseif num_spices == 2 then
            self:command("lick")
            actor:send(tostring(self.name) .. " says, 'Eight more....'")
        elseif num_spices == 3 then
            actor:send(tostring(self.name) .. " says, 'Seven more spices, and my stew will be perfect!'")
        elseif num_spices == 4 then
            self:emote("is starting to look excited.")
            actor:send(tostring(self.name) .. " says, 'Six more!'")
        elseif num_spices == 5 then
            self:command("grin")
            actor:send(tostring(self.name) .. " says, 'You're halfway there!  Five more!'")
        elseif num_spices == 6 then
            self:emote("sniffs the spices carefully.")
            actor:send(tostring(self.name) .. " says, 'Yes!  Only four more!'")
        elseif num_spices == 7 then
            actor:send(tostring(self.name) .. " says, 'Three more!  Give them to me!'")
        elseif num_spices == 8 then
            self:emote("looks very excited now.")
            actor:send(tostring(self.name) .. " says, 'Two more spices!'")
        elseif num_spices == 9 then
            actor:send(tostring(self.name) .. " says, 'One more!  Give it to me!'")
        end
        return true
    end

    -- num_spices >= 10: complete the quest.
    self:command("cackle")
    actor:send(tostring(self.name) .. " says, 'Most excellent!  Now I may complete the will of my Queen!'")
    wait(1)
    self:emote("puts all the ingredients for the nasty stew into a small bag.")
    self.room:send("A servant silently enters and bows.")
    self:emote("gives a small bag to the servant.")
    self.room:send("The servant leaves.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Oh yes, your reward....'")
    -- Reward boots depend on whether saffron (23760) and salt (23756) were
    -- among the ten spices delivered.
    local has_saffron = (actor:get_quest_var("vilekka_stew:got_spice:23760") or 0) == 1
    local has_salt = (actor:get_quest_var("vilekka_stew:got_spice:23756") or 0) == 1
    local expcap
    if has_saffron and has_salt then
        self.room:spawn_object(237, 98)
        expcap = math.min(actor.level, 60)
    elseif has_saffron then
        self.room:spawn_object(237, 99)
        expcap = math.min(actor.level, 85)
    elseif has_salt then
        self.room:spawn_object(237, 96)
        expcap = math.min(actor.level, 50)
    else
        self.room:spawn_object(237, 97)
        expcap = math.min(actor.level, 55)
    end

    local expmod
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

    -- Class proportional adjustment.
    if actor.class == "warrior" or actor.class == "berserker" then
        -- 110% of standard
        expmod = expmod + (expmod / 10)
    elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
        -- 115% of standard
        expmod = expmod + ((expmod * 2) / 15)
    elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
        -- 120% of standard
        expmod = expmod + (expmod / 5)
    elseif actor.class == "necromancer" or actor.class == "monk" then
        -- 130% of standard
        expmod = expmod + ((expmod * 2) / 5)
    end

    actor:send("<b:yellow>You gain experience!</>")
    local setexp = expmod * 10
    for _ = 1, 10 do
        actor:award_exp(setexp)
    end
    self:command("give boots " .. tostring(actor.name))
    wait(1)
    self:command("smile")
    actor:send(tostring(self.name) .. " says, 'Wear them proudly!'")
    actor:complete_quest("vilekka_stew")
    return true
end

if not accepted then
    actor:send(tostring(self.name) .. " haughtily refuses your gift.")
    self.room:send_except(actor, tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    self:say("No thank you.")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'ab975a4f255c3861f341798dee583db9'),
  -- data/triggers/238/238_15_mage_receive.lua
  (238, 15, $trig$-- If a Tempest is still in 238:90, reset its quest state.
-- DG receive arg list (23822): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 238 and object.id == 22)
) then
    return true
end

if world.count_mobiles(238, 3) > 0 then
    get_room(238, 90):at(function()
        run_room_trigger(238, 14)
    end)
end
wait(1)
self:destroy_item("blue-flame")
wait(1)
self.room:send("The mage's face brightens.")
actor:send(tostring(self.name) .. " says, 'You have banished the Tempest!  Excellent!  I think I can use this to remove the ice...'")
self:emote("murmers some arcane phrases and the symbols on the wall begin to glow.")
wait(2)
actor:send(tostring(self.name) .. " says, 'It says...")
local question = random(1, 4)
globals.question = question
if question == 1 then
    actor:send("What is the race of the one from Ickle?'")
elseif question == 2 then
    actor:send("What is the race of the one who fought demons?'")
elseif question == 3 then
    actor:send("What is the class of the one who stood fourth in line from the right?'")
elseif question == 4 then
    actor:send("What is the favored enemy of the barbarian?'")
else
    actor:send(tostring(self.name) .. " says, 'Hrm... I can't seem to read it.'")
    wait(2)
    self:command("frown")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Something is terribly wrong.  I think you should notify a god immediately.'")
end
wait(2)
actor:send(tostring(self.name) .. " says, 'Do you have the answer?'")$trig$, '3cac8518ba5b5478116efb58fbe86334'),
  -- data/triggers/300/300_08_give_things_to_the_wrong_officer.lua
  (300, 8, $trig$-- Converted from DG Script #30008: give things to the wrong officer
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Subordinate officer redirects message-bearing items (302:12 spy scroll,
-- 302:8 paladin parchment) to the general; refuses everything else outright.
self.room:send_except(actor, tostring(actor.name) .. " tries to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You try to give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ", but " .. tostring(self.name) .. " refuses.")
if object.zone_id == 302 and (object.local_id == 12 or object.local_id == 8) then
    self:say("Eh?  Don't bother me with this stuff.")
    self:say("Give it to the general, he does all the planning around here.")
else
    self:say("What?  Don't bother me with such trifles!")
end
return false  -- legacy return 0: the giver keeps the item$trig$, '0b66083cf82f2daeab5e532148ad383b'),
  -- data/triggers/364/364_04_illusory_wall_lyara_receive.lua
  (364, 4, $trig$local function obj_id_matches(obj, z, lid)
    return obj.zone_id == z and obj.local_id == lid
end
local lens_a_z, lens_a_id = 103, 7
local lens_b_z, lens_b_id = 185, 11
local spur_z,   spur_id   = 410, 5
local magic_z,  magic_id  = 510, 17
local obj_short = object.short_description or object.name
if actor:get_quest_stage("illusory_wall") == 1 then
    local key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
    local lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
    local lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
    local spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
    local magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
    if (actor:get_quest_var("illusory_wall:" .. key) or 0) == 1 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self:say("You have already given me this.")
        return false  -- legacy return 0: the giver keeps the item
    elseif (lens_a == 1 and obj_id_matches(object, lens_b_z, lens_b_id))
        or (lens_b == 1 and obj_id_matches(object, lens_a_z, lens_a_id)) then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self.room:send(tostring(self.name) .. " says, 'You have already given me something suitable for")
        self.room:send("</>magic lenses.'")
        return false  -- legacy return 0: the giver keeps the item
    else
        if obj_id_matches(object, lens_a_z, lens_a_id) or obj_id_matches(object, lens_b_z, lens_b_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self:say("These are excellent lenses.")
        elseif obj_id_matches(object, spur_z, spur_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'Yes, this will do nicely.  Hopefully you gained a")
            self.room:send("</>few insights on bending light from the prisms in the Hive as well.'")
        elseif obj_id_matches(object, magic_z, magic_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(0.2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " looks at the odd glowing lump.")
            self:say("Ah yes, plenty of extra juice in here.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
            self:command("shake")
            self:say("This won't help you see through illusions any better.")
            return false  -- legacy return 0: the giver keeps the item
        end
        lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
        lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
        spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
        magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
        if (lens_a or lens_b) and spur and magic then
            actor:advance_quest("illusory_wall")
            actor:set_quest_var("illusory_wall", "total", 0)
            wait(2)
            self:say("Wonderful, looks like this is everything.")
            wait(2)
            self.room:send(tostring(self.name) .. " holds the prismatic leg spur and the lenses next to each other and utters a few words.")
            self.room:send("<b:yellow>The lenses fuse with the leg spur, taking on a prismatic quality!</>")
            wait(4)
            self.room:send(tostring(self.name) .. " holds the lump of magic over the prismatic lenses and whispers an incantation.")
            self.room:send("<b:yellow>The magic melds with the lenses!</>")
            wait(3)
            self.room:spawn_object(364, 0)
            self.room:send(tostring(self.name) .. " says, 'These lenses will show you little hidden details")
            self.room:send("</>about doors and exits.'")
            self:command("give lenses " .. tostring(actor.name))
            wait(3)
            self.room:send(tostring(self.name) .. " says, '<b:white>[Examine]</> 20 different closeable exits in 20")
            self.room:send("</>different parts of the world.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Once you have, you should know enough to replicate")
            self.room:send("</>such barriers on your own.'")
            wait(4)
            self:say("Good luck!")
        else
            wait(2)
            self:say("Do you have the other necessities?")
        end
    end
elseif actor:get_quest_stage("illusory_wall") > 1 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("There's nothing else you need to bring me.")
    return false  -- legacy return 0: the giver keeps the item
else
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("No need for supplies, soldier.")
    self:command("salute " .. tostring(actor.name))
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'd92549a4e3a7456edc5764db38d96865'),
  -- data/triggers/390/390_07_flood_spirits_receive.lua
  (390, 7, $trig$local color
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
do
    if (self.zone_id == 390 and self.id == 12) then
        if stage == 2 then
            if (object.zone_id == 390 and object.id == 0) then
                self:destroy_item("heart-ocean")
                wait(1)
                self.room:send(tostring(self.name) .. " screams, 'LET THE SIEGE BEGIN!!'")
                -- (empty room echo)
                self.room:send("The ocean erupts in a violent frenzy.")
                wait(3)
                self.room:send("Massive waves begin to crest and smash against the settlement gate.")
                self.room:send(tostring(self.name) .. " screams with reckless abandon like the most terrifying of barbarian berserkers.")
                wait(6)
                self.room:send("Spirits rise up through the churning ocean.")
                self.room:send("Giant black waves and enormous icebergs assault the rocky shores!")
                self.room:send(tostring(self.name) .. " wails, 'YOU SHALL DIE FOR STEALING FROM ME.'")
                wait(7)
                self.room:send("The nine Great Waters pull away from the settlement's borders as if granting a moment of reprieve.")
                wait(4)
                self.room:send("The ocean's level drops as the waters quickly rush away.")
                wait(4)
                self.room:send("On the horizon, a titanic wall of water rises up like a hellish behemoth.")
                wait(2)
                self.room:send("The gargantuan tsunami rushes toward the rocks and SMASHES through the settlement gate!")
                wait(6)
                self.room:send("Screaming voices are instantly snuffed out.")
                self.room:send("Dozens of bodies smash into the rocks and shatter like glass as the tsunami obliterates the settlement.")
                wait(8)
                self.room:send("As quickly as it began, the flood waters recede leaving nothing but chilling silence and carnage in its wake.")
                wait(6)
                self.room:send("The Lady of the Sea vanishes beneath the waves.")
                run_room_trigger(390, 13)
                wait(4)
                actor:send("A watery voice floats past your ear:")
                actor:send("'Never forget what you have witnessed here today.'")
                wait(1)
                actor:send("It whispers the eldritch formula for summoning such a cataclysm again.")
                actor:complete_quest("flood")
                skills.set_level(actor, "flood", 1000)
                actor:send("<b:blue>You have learned Flood.</>")
                wait(2)
                actor:send("'Thank you for the role you played.'")
                world.destroy(self)
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:say("This is not my heart!")
                self.room:send(tostring(self.name) .. " bellows, 'GIVE IT BACK OR I WILL DESTROY YOU.'")
                return false  -- legacy return 0: the giver keeps the item
            end
        end
    elseif (self.zone_id == 390 and self.id == 14) then
        color = "<cyan>"
        if stage == 1 then
            if (object.zone_id == 584 and object.id == 1) then
                self:destroy_item("feather")
                wait(1)
                self.room:send(tostring(self.name) .. " submerges the feather in the steaming water.")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I can entrust the safety of the springs to this</>")
                self.room:send("</>" .. tostring(color) .. "feather's magical energy for a short while.  I will join the ocean's crusade.'</>")
                actor:set_quest_var("flood", "water2", 1)
                wait(2)
                self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
            else
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This will not keep my spring sufficiently warm.'</>")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I need nothing from you.'</>")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif (self.zone_id == 390 and self.id == 16) then
        color = "<green>"
        if stage == 1 then
            if object.type == "FOOD" then
                if actor:get_quest_var("flood:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                    wait(0.2)
                    self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                    self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
                else
                    actor:set_quest_var("flood", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                    local full = actor:get_quest_var("flood:hunger")
                    local hunger = ((full or 0) + object.val0)
                    actor:set_quest_var("flood", "hunger", hunger)
                    self:destroy_item("food")
                    self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                    if hunger >= 200 then
                        wait(0.2)
                        self.room:send(tostring(self.name) .. " licks her massive chops.</>")
                        wait(1)
                        self:command("burp")
                        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The dead within me are sated.'")
                        wait(1)
                        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'For now.'")
                        wait(1)
                        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'We will join with the ocean in her revenge.'")
                        wait(1)
                        self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
                        actor:set_quest_var("flood", "water4", 1)
                    else
                        wait(0.2)
                        self.room:send(tostring(self.name) .. " licks her massive chops.")
                        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me more!'</>")
                        return _return_value
                    end
                end
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This is not food!!'</>")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I want nothing from you.'</>")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif (self.zone_id == 390 and self.id == 19) then
        color = "<b:black>"
        if stage == 1 then
            if object.type == "LIGHT" then
                if object.val1 == -1 then
                    actor:set_quest_var("flood", "water7", 1)
                    wait(0.2)
                    self.room:send(tostring(self.name) .. " grins with a sick malevolence.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I'll take great joy in this!'</>")
                    wait(2)
                    self.room:send(tostring(self.name) .. " plunges the light into the depths of the Black Lake.")
                    world.destroy(object)
                    wait(3)
                    self.room:send("The light twinkles for a few moments as it sinks into the darkness before fading forever.")
                    wait(4)
                    self:command("laugh")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Intoxicating.'</>")
                    wait(2)
                    self.room:send(tostring(self.name) .. " says," .. tostring(color) .. " 'I will join the Arabel Ocean with pleasure.'</>")
                    self:command("bow")
                    wait(2)
                    self.room:send(tostring(color) .. tostring(self.name) .. " splashes back into the inky blackness of the lake.</>")
                else
                    self.room:send(tostring(self.name) .. " scoffs.")
                    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This wouldn't glow forever even before I consume it.'</>")
                    return false  -- legacy return 0: the giver keeps the item
                end
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This isn't even a light!'</>")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'You have nothing to offer me.'</>")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have no need for this.'</>")
        return false  -- legacy return 0: the giver keeps the item
    end
end
if stage == 1 then
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end
world.destroy(self)
return _return_value$trig$, '8de334e6d60891df25bc7bf6b4abf433'),
  -- data/triggers/462/462_25_nukreth_spire_kobold_receive.lua
  (462, 25, $trig$-- Converted from DG Script #46225: Nukreth Spire kobold receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path2") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 14 then
                wait(0.2)
                world.destroy(object)
                self.room:send(tostring(self.name) .. " trills excitedly!")
                wait(1)
                self:say("It's okay, momma's got you now.")
                self.room:send(tostring(self.name) .. " coos at the egg as she cradles it in her arms.")
                wait(2)
                self:say("Thank you!!  Now let's get out of here.")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my egg.")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my egg.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'fe0a51738b65a33f9c07d556347ffb94'),
  -- data/triggers/462/462_26_nukreth_spire_orc_receive.lua
  (462, 26, $trig$-- Converted from DG Script #46226: Nukreth Spire orc receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path3") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 13 then
                wait(0.2)
                self.room:send(tostring(self.name) .. " grins wickedly as he wraps his fingers around the axe.")
                self:command("wie axe")
                wait(1)
                self:say("Revenge will be sweet...")
                wait(2)
                self:say("Now move out!")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only need my axe.")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have my axe.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'cf07cde49474bd0bb137454705229e22'),
  -- data/triggers/462/462_27_nukreth_spire_goblin_receive.lua
  (462, 27, $trig$-- Converted from DG Script #46227: Nukreth Spire goblin receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path4") or 0) == 0 then
        if globals.task ~= "done" then
            if object.zone_id == 462 and object.local_id == 15 then
                wait(0.2)
                world.destroy(object)
                self:command("cheer")
                self:say("Come to papa!")
                self.room:send(tostring(self.name) .. " grins like a fool at the stone.")
                wait(2)
                self:say("Thanks matey.  Now get me outta 'ere.")
                self:follow(actor)
                globals.task = "done"
                globals.leader = actor.name
            else
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self:command("shake")
                self:say("I only want me stone.")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("shake")
            self:say("I already have me stone.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '4119dec8111745af292f811a2a3d83be'),
  -- data/triggers/480/480_33_infidel_receive.lua
  (480, 33, $trig$-- Converted from DG Script #48033: Infidel receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (48025): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 480 and object.id == 25)
) then
    return true
end

wait(0.2)
world.destroy(object)
self.room:send(tostring(self.name) .. " grins as he crushes the Prince's skull to dust.")
wait(1)
self:command("laugh")
self:say("Good, just as it should be.")
wait(2)
self.room:send(tostring(self.name) .. " dusts off his hands and produces a sickly gnarled staff from his belongings.")
wait(1)
self:say("Take this as a reward.")
self.room:spawn_object(480, 39)
self:command("give infidels-staff " .. tostring(actor.name))

-- Credit every nearby group member with quest progress.
local function credit(person)
    if person.room == self.room then
        if person:get_quest_stage("hell_trident") == 2 then
            if not person:get_quest_var("hell_trident:helltask6") then
                person:set_quest_var("hell_trident", "helltask6", 1)
            end
        end
        person:send("<b:yellow>You have finished the infidel's duel!</>")
    end
end

if actor.group then
    for _, person in ipairs(actor.group) do
        credit(person)
    end
else
    credit(actor)
end$trig$, '5be1f0cbd3cc1decc52ed8e8e402fcb3'),
  -- data/triggers/481/481_158_mccabe_receive.lua
  (481, 158, $trig$-- Converted from DG Script #48258: mccabe_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (48252 48251): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 481 and object.id == 152) or
    (object.zone_id == 481 and object.id == 151)
) then
    return true
end

local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("meteorswarm")
local earth = actor:get_quest_var("meteorswarm:earth")
local air = actor:get_quest_var("meteorswarm:air")
if object.zone_id == 481 and object.local_id == 151 then
    self:command("shake")
    actor:send(tostring(self.name) .. " tells you, 'Go <b:cyan>use</> this new treasure; don't give it back to me!'")
    return false  -- legacy return 0: the giver keeps the item
elseif actor:get_quest_var("meteorswarm:new") ~= "no" then
    self.room:send(tostring(self.name) .. " accepts the meteorite.")
    actor:send(tostring(self.name) .. " tells you, 'Good, this will work.'")
    self.room:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " tells you, 'Go, resume your studies.'")
    actor:set_quest_var("meteorswarm", "new", 0)
    return false  -- legacy return 0: the giver keeps the item
else
    -- switch on stage
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find Jemnon first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 2 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find the rock demon first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 3 then
            if (earth or 0) == 0 then
                actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
                actor:send(tostring(self.name) .. " tells you, 'Such wonderfully powerful stone.  This will do perfectly.'")
                actor:send(tostring(self.name) .. " tells you, 'Next, you need to demonstrate mastery over fire.'")
                actor:send(tostring(self.name) .. " tells you, 'The northern cult of fire provides an excellent opportunity to do so.'")
                actor:send(tostring(self.name) .. " tells you, 'Take the meteor, <b:cyan>slay the high priest, and find the secret lava well</>.'")
                actor:send(tostring(self.name) .. " tells you, 'The charge from such energy will be ideal for conjuring.'")
                actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
                actor:set_quest_var("meteorswarm", "earth", 1)
                return false  -- legacy return 0: the giver keeps the item
            else
                actor:send(tostring(self.name) .. " tells you, 'Yes yes, you have already proven it's a lovely focus.'")
                return false  -- legacy return 0: the giver keeps the item
            end
        elseif tonumber(_sw1) == 4 then
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'No, go find Dargentan first.'")
            return false  -- legacy return 0: the giver keeps the item
        elseif tonumber(_sw1) == 5 then
            if (air or 0) == 0 then
                self:destroy_item("meteorite")
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'This meteorite, representing the force of earth, has been imbued with the spirits of fire and air.  It will serve as the perfect focus for casting meteorswarm.'")
                wait(4)
                actor:send(tostring(self.name) .. " tells you, 'You are ready.'")
                wait(3)
                self.room:spawn_object(481, 151)
                self:command("give meteorite " .. tostring(actor.name))
                wait(1)
                actor:send(tostring(self.name) .. " tells you, 'Go somewhere safe, and <b:cyan>use it</> to unlock its potential.'")
                actor:set_quest_var("meteorswarm", "air", 1)
            else
                actor:send(tostring(self.name) .. " tells you, 'Where did you find a second one of these?  You don't need it.'")
                return false  -- legacy return 0: the giver keeps the item
            end
        else
            self:command("eye")
            actor:send(tostring(self.name) .. " tells you, 'And what exactly am I supposed to do with this?'")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, 'cc8c4dee5094ae277777cc130667dbc0'),
  -- data/triggers/481/481_21_give_ivory_vulcera.lua
  (481, 21, $trig$-- Converted from DG Script #48121: give_ivory_vulcera
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (48116): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 481 and object.id == 16)
) then
    return true
end

if actor:get_quest_stage("fieryisle_quest") == 8 then
    wait(0.2)
    actor:advance_quest("fieryisle_quest")
    actor:send("<b:white>You have advanced your quest!</>")
    if world.count_mobiles(481, 27) == 0 then
        get_room(481, 97):at(function()
            self.room:spawn_mobile(481, 27)
        end)
    end
    self:say("You did well to find this, even with my powers I was unable to locate it.  On the other hand, you were a bit dumb to just hand it over to me!  It would seem Lokari taught me well.")
    wait(3)
    self:command("unlock chest")
    self:command("open chest")
    self:command("get all chest")
    self:emote("examines the ivory ring.")
    wait(2)
    self:say("Pah, humans!")
    if self:has_item(481, 14) then
        self:destroy_item("ivory-ring")
    end
    self.room:spawn_object(481, 27)
    self:command("wear ring")
    wait(2)
    self:say("Heh, it still fits after all these years, but Lokari won't be happy.")
    self:destroy_item("key")
    self:command("peer " .. tostring(actor.name))
    wait(2)
    self.room:spawn_object(481, 26)
    self:command("wear cloak-fire")
    self:say("If you want this cloak, you better think again, begone mortal!")
    self.room:teleport_all(get_room(481, 100))
    get_room(481, 100):at(function()
        self.room:send("You can hear Vulcera's laughter ringing in your ears.")
    end)
    self:teleport(get_room(481, 123))
end$trig$, '059b82ffe9a9b05f501a0be7ea30e8b5'),
  -- data/triggers/484/484_25_wild-hunt-rec-antlers.lua
  (484, 25, $trig$-- Converted from DG Script #48425: wild-hunt-rec-antlers
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (48429): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 484 and object.id == 29)
) then
    return true
end

wait(0.2)
self:destroy_item("antlers")
local accept = 0
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("doom_entrance") == 2 then
            person:advance_quest("doom_entrance")
            self:command("bow " .. tostring(person.name))
            person:send(tostring(self.name) .. " says, 'You are indeed worthy, " .. tostring(person.name) .. ".  Please continue on to the Oracle of Justice.'")
            person:send("<b:white>You have advanced the quest!</>")
            accept = 1
        end
    elseif person then
        i = i + 1
    end
    a = a + 1
end
if accept == 0 then
    actor:send(tostring(self.name) .. " says, 'What is this?'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'You mock the Goddess of the Hunt!'")
end$trig$, 'df5114f0a369ec1ca8fc26dc81147f06'),
  -- data/triggers/484/484_28_justice_refuse.lua
  (484, 28, $trig$-- Converted from DG Script #48428: Justice refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- `response` is set inside the branches below; declared here so
-- both the outer if/else and the inner else can write to the
-- same binding (the converter emitted `local response = ...`
-- inside each branch, scoping each to its branch and breaking
-- the post-block `if response then` test).
local response = nil
do
    if actor:get_quest_stage("wizard_eye") == 10 then
        -- switch on object.id
        do
            if (object.zone_id == 30 and object.id == 218) or (object.zone_id == 534 and object.id == 24) or (object.zone_id == 430 and object.id == 21) or (object.zone_id == 40 and object.id == 3) then
                return _return_value
            else
                response = "This " .. tostring(object.shortdesc) .. " can't possibly be what you needed to ask me about."
            end
        end
    else
        response = "I'm sorry, do you need something?"
    end
end
if response then
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'f22f68f9eca9e067b6ad5c7d72bacf18'),
  -- data/triggers/484/484_29_hunt_refuse.lua
  (484, 29, $trig$-- Converted from DG Script #48429: Hunt refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (48429) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
local response
if (object.zone_id == 484 and object.id == 29) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
do
    response = "Why do you bother the Goddess of the Hunt?"
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '711c5cc5d39c316d90a9d17e83d105de'),
  -- data/triggers/490/490_15_crowley_receive1.lua
  (490, 15, $trig$-- Converted from DG Script #49015: crowley_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if (object.zone_id == 490 and object.id == 1) then
    _return_value = false
    wait(0.4)
    self:emote("examines the griffin skin carefully.")
    self.room:send(tostring(self.name) .. " says, 'This is fantastic!  You have defeated his earthly form!")
    self.room:send("</>However, this was merely a material manifestation, and his true incarnation")
    self.room:send("</>continues its nefarious existence.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Please, I beg of you, find and destroy him, before he")
    self.room:send("</>gathers the strength to return as Dagon yet again!'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Oh!  I nearly forgot.  This belongs to you, if you can")
    self.room:send("</>bear to touch it.'")
    self:command("give griffin-skin " .. tostring(actor.name))
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you can't bear to use it, give it to Awura who will")
    self.room:send("</>destroy it.  Maybe she will give you something more to your taste.'")
elseif (object.zone_id == 490 and object.id == 42) then
    _return_value = false
    wait(0.8)
    self:emote("looks rather surprised.")
    wait(2)
    self:say("Well now, you found it!  How very resourceful of you!")
    wait(2)
    self:emote("peers suspiciously into " .. tostring(object.shortdesc) .. ".")
    wait(2)
    if object.val1 ~= 16 then
        self:command("glare " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Well you had to help yourself, now, didn't you!")
        self.room:send("</>You have no idea how thirs*HIC* I am!  Bah.'")
        wait(2)
        self:command("drop clear-glass-bottle")
    elseif object.val2 ~= 5 then
        self:say("What's this?  I'm not drinking that!")
        self:command("glare " .. tostring(actor.name))
        wait(2)
        self:command("drop clear-glass-bottle")
    else
        self:emote("smiles and takes a healthy swig from " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("Thank you, " .. tostring(actor.name) .. ".  You're a lifesaver!")
        self:destroy_item("clear-glass-bottle")
        wait(2)
        self:emote("staggers a bit as he carefully pours the whiskey into his waterskin.")
        self.room:spawn_object(490, 66)
        self:command("drop mirror-lettered-scroll")
    end
else
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'No, thank you.'</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'f192af748a5cb9f2da4b94f6b14e1157'),
  -- data/triggers/490/490_16_earle_receive_branch.lua
  (490, 16, $trig$-- Converted from DG Script #49016: Earle receive branch
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Small oak branch given
-- DG receive arg list (49037): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 37)
) then
    return true
end

wait(0.2)
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") == 0 then
            person:start_quest("griffin_quest")
            person:send("<b:white>You have now begun the Griffin Isle quest!</>")
        end
        person:set_quest_var("griffin_quest", "oak", 1)
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
self:destroy_item("small-oak-branch")
if world.count_mobiles(490, 1) == 0 then
    get_room(490, 81):at(function()
        self.room:spawn_mobile(490, 1)
    end)
end
get_room(490, 81):at(function()
    self.room:find_actor("undead-captain"):spawn_object(490, 37)
end)
self:say("Ah, excellent work, " .. tostring(actor.name) .. ".")
self:emote("examines the oak branch.")
wait(2)
self:say("The centuries have taken their toll, but it is still powerful.")
self:emote("utters some incantations and the branch starts to sprout roots and leaves!")
self.room:spawn_object(490, 45)
self:command("give sapling " .. tostring(actor.name))
wait(3)
self:say("This sapling needs to be placed near the altar to be effective.  May the tree spirits guard you.")
if actor:get_quest_stage("griffin_quest") == 1 then
    wait(2)
    self:say("Now, did you also retrieve the sword?  Give it to me.")
end$trig$, 'b675d287979369ef61d9971e247d1fe2'),
  -- data/triggers/490/490_23_derceta_receive1.lua
  (490, 23, $trig$-- Converted from DG Script #49023: derceta_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if (object.zone_id == 490 and object.id == 16) then
    self:set_flag("sentinel", true)
    local person = actor
    local stage = 3
    local i = person.group_size
    local a
    local leader = actor
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        person = person.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("griffin_quest") == stage then
                person:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
            end
            if actor:get_quest_stage("griffin_quest") < stage then
                leader = person
            else
                leader = actor
            end
        elseif person and person.is_player then
            i = i + 1
        end
        a = a + 1
    end
    wait(0.2)
    self:command("smile")
    self:say("Thanks " .. tostring(leader.name) .. ".  Now, lead me to the boulder.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'When you want it shifted, say <b:white>'push now'</> and I will get to work.'")
    self:follow(leader.name)
    wait(0.4)
    self:say("Be ready to move quick - I won't be able to hold it forever.")
    self:emote("polishes the earring.")
    self:emote("peers at the earring and says 'Hello little midget.'")
    wait(0.8)
    self:command("wear earring ear")
else
    self:command("shake")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '53557ed4e7e5227e2bcc92fbba33c1df'),
  -- data/triggers/490/490_27_earle_receive_sword.lua
  (490, 27, $trig$-- Converted from DG Script #49027: Earle receive sword
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49029): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 29)
) then
    return true
end

-- Rune sword given
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
local person = actor
local oak = 0
local accept = 0
local stage = 1
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_var("griffin_quest:oak") then
            oak = oak + 1
            if person:get_quest_stage("griffin_quest") == stage then
                person:advance_quest("griffin_quest")
                person:send("<b:white>You have advanced the quest!</>")
                accept = accept + 1
            end
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if oak == 0 then
    self:say("A fine weapon, but it will be of no use without the holy tree.")
    self:emote("returns the sword.")
else
    self:say("Ah... this sword would have saved a lot of trouble.")
    self:command("ponder")
    self.room:send(tostring(self.name) .. " says, 'If you didn't have too much trouble getting this sword, then perhaps you can help.  Go to the seer and say <b:cyan>\"Earle sends me\"</> and she will give you what aid she can.'")
    self:say("Please return to me when you have defeated Dagon.  And be sure to bring proof of the deed!")
    self:emote("hands back the sword.")
    if accept > 0 then
        self.room:send(tostring(self.name) .. " says, 'If you need, you can come to me and check your <b:cyan>[quest progress]</>.'")
    else
        self:emote("glances back with a thoughtful look.")
        self:say("Did I give you the sapling for the altar?  I can be so forgetful...'")
    end
end
return false  -- legacy return 0: the giver keeps the item$trig$, '75760a6863bfb177748304abcb1c6af7'),
  -- data/triggers/490/490_28_earle_receive_skin.lua
  (490, 28, $trig$-- Converted from DG Script #49028: Earle receive skin
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49001): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 1)
) then
    return true
end

-- griffin skin given
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
self:emote("grimaces a bit as he accepts " .. tostring(object.shortdesc) .. ".")
self:say("An ugly thing, is it not?  It must be utterly destroyed, for it carries Dagon's taint and stench wherever it goes.")
self:say("Take it to Awura.  She will know how to deal with it.")
self:emote("lifts " .. tostring(object.shortdesc) .. " on one finger, and hands it back.")
actor:send("<b:white>You have advanced the quest!</>")
actor:send("<b:white>Group credit will not be given when delivering the skin to Awura.</>")
return false  -- legacy return 0: the giver keeps the item$trig$, 'f510a874c8356b744beab62b11e8897f'),
  -- data/triggers/490/490_29_earle_receive_sapling.lua
  (490, 29, $trig$-- Converted from DG Script #49029: Earle receive sapling
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (49045): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 490 and object.id == 45)
) then
    return true
end

-- sapling given back
self:say("Keep it, " .. tostring(actor.name) .. "!  You'll need to drop it by the altar.  Otherwise you will never defeat Dagon's material form!")
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return false  -- legacy return 0: the giver keeps the item$trig$, '7b4ecee3cfe05b2486f5ee51f9943f4b'),
  -- data/triggers/490/490_30_earle_refuse.lua
  (490, 30, $trig$-- Converted from DG Script #49030: Earle refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%

-- DG receive trigger, num_arg 0: the arg list (49001 49029 49037 49045) holds the items
-- other triggers handle; this one runs for every other item. The runtime does not filter on
-- arg_list, so the exclusion lives here. (The converter's percent_chance(0) guard blocked it all.)
if (object.zone_id == 490 and object.id == 1)
    or (object.zone_id == 490 and object.id == 29)
    or (object.zone_id == 490 and object.id == 37)
    or (object.zone_id == 490 and object.id == 45) then
    return true
end
local _return_value = true  -- Default: allow action
-- switch on object.id
if actor:get_quest_stage("major_globe_spell") == 2 then
    if (object.zone_id == 534 and object.id == 51) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 3 then
    elseif (object.zone_id == 580 and object.id == 2) then
        return _return_value
    end
    if actor:get_quest_stage("major_globe_spell") == 4 then
    elseif (object.zone_id == 586 and object.id == 9) then
        return _return_value
    end
end
self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
self:command("shake")
self:say("Sorry, I don't think this will be of any use.")
self:emote("returns " .. tostring(object.shortdesc) .. ".")
return false  -- legacy return 0: the giver keeps the item$trig$, '767ce96e31635df2de3d838c4d82d567'),
  -- data/triggers/490/490_36_hermit_receive1.lua
  (490, 36, $trig$-- Converted from DG Script #49036: hermit_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.type == "DRINKCONTAINER" then
    wait(0.2)
    if object.val2 == 5 then
        self:command("cheer")
        self:say("Thank you " .. tostring(actor.name) .. ", you have made an old man very happy.")
        self.room:spawn_object(490, 41)
        local person = actor
        local i = person.group_size
        local a
        if i then
            a = 1
        else
            a = 0
        end
        while i >= a do
            person = person.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("griffin_quest") == 0 then
                    person:start_quest("griffin_quest")
                end
                person:set_quest_var("griffin_quest", "ladder", 1)
            elseif person and person.is_player then
                i = i + 1
            end
            a = a + 1
        end
        self:command("give ladder " .. tostring(actor.name))
        self:say("That completes my part of the bargain.")
        wait(0.2)
        self:command("drink bottle")
        self:command("smile")
    else
        self:say("I'm not drinking this!")
        self:command("pour " .. tostring(object.shortdesc) .. " out")
        self:command("drop " .. tostring(object.shortdesc))
    end
else
    self:say("What's this for?")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '2db2c823d225601b2b93d2e8d5430092'),
  -- data/triggers/490/490_42_awura_receive1.lua
  (490, 42, $trig$-- Converted from DG Script #49042: awura_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if (object.zone_id == 490 and object.id == 1) then
    wait(0.2)
    self:destroy_item("griffin-skin")
    if world.count_mobiles(490, 10) == 0 then
        get_room(490, 190):at(function()
            self.room:spawn_mobile(490, 10)
        end)
    end
    if actor:get_quest_stage("griffin_quest") == 7 then
        get_room(490, 190):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 62)
        end)
        get_room(490, 190):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 19)
        end)
        actor:advance_quest("griffin_quest")
        actor:send("<b:white>You have advanced the quest!</>")
    end
    self.room:send("A look of disgust crosses Awura's features as she handles the skin.")
    self:emote("utters a short spell.")
    wait(0.8)
    self.room:send("The griffin skin turns to smoke and blows away in the breeze.")
    wait(0.4)
    actor:send("Awura studies you closely, to be sure of your intentions.")
    self.room:send_except(actor, "Awura studies " .. tostring(actor.name) .. " closely, to be sure of " .. tostring(actor.possessive) .. " intentions.")
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", thank you so much for saving our home from Dagon's rule.'")
    wait(0.4)
    self.room:send(tostring(self.name) .. " says, 'As a small token of gratitude, please accept this helmet.  It is not much, but I pray it will help you in the future.'")
    self.room:spawn_object(490, 61)
    self:command("give helmet " .. tostring(actor.name))
    wait(0.4)
    self:command("curtsey " .. tostring(actor.name))
    wait(0.4)
    self.room:send(tostring(self.name) .. " says, 'Now, seek out and destroy Dagon's demonic essence, Adramalech.  A portal to its home realm is locked beneath the well.  The cult leader must have had a key of some kind.'")
else
    actor:send("<b:white>" .. tostring(self.name) .. " tells you, 'No, thank you.'</>")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'dd8f8ccb56e4c6f7a0d251faf8c2587a'),
  -- data/triggers/492/492_54_quest_relocate_receive.lua
  (492, 54, $trig$-- Converted from DG Script #49254: quest_relocate_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action (item kept by mob)
-- 
-- edit 3-7-2021 by Daedela: Acerites code was throwing errors because of the logic flow.
-- It worked when the questor did exactly as told, but deviating risked system failure.
-- The quest is identical, but the logic has been completely re-written to eliminate the errors.
-- Comments about Acerites hatred of ampersands is preserved for posterity and the previous code is logged on the Wiki.
local stage = actor:get_quest_stage("relocate_spell_quest")
if stage == 1 then
    if (object.zone_id == 492 and object.id == 50) then
        wait(1)
        self:destroy_item("mystics")
        self.room:send("A lost mage examines the Druidstaff carefully.")
        wait(1)
        self:command("glare " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'No no, it is of no use to me unless you destroy the druid")
        self.room:send("</>YOURSELF!  Try again.'")
        wait(1)
        self:command("frown")
    end
elseif stage == 2 then
    if (object.zone_id == 492 and object.id == 50) then
        wait(0.2)
        actor:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Excellent, thank you! Thank you!'")
        wait(1)
        self:command("hold mystics")
        wait(1)
        actor:send("A lost mage tells you, 'Ok, the next thing required is the Crystal")
        actor:send("</>Telescope.  An observer of the cold village holds it, but you must not harm")
        actor:send("</>him.  Convince him to give it to you, then bring it back to me.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(2)
        actor:send("A lost mage tells you, 'Go now, I must start with the staff!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 4 then
    if (object.zone_id == 492 and object.id == 52) then
        wait(1)
        self:destroy_item("telescope")
        self.room:send("A lost mage examines the telescope carefully.")
        wait(1)
        self:command("frown " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'How did you get this? There's something missing here.")
        self.room:send("</>You must earn this properly. Go NOW!'")
    end
elseif stage == 5 then
    if (object.zone_id == 492 and object.id == 52) then
        wait(0.2)
        actor:advance_quest("relocate_spell_quest")
        actor:send("A lost mage tells you, 'Yes, yes! Thank you!")
        wait(1)
        self:command("hold telescope")
        wait(1)
        actor:send("A lost mage tells you, 'Ok ok, you've done well, the next item I need is the")
        actor:send("</>spellbook.'")
        wait(2)
        actor:send("A lost mage tells you, 'But not just any spellbook.  This one is held deep")
        actor:send("</>inside a very powerful tower.  To find the tower you must look within the")
        actor:send("</>destroyed land.  That is all I can say.  Go now!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 6 then
    if (object.zone_id == 125 and object.id == 20) then
        actor:advance_quest("relocate_spell_quest")
        actor:save()
        wait(0.2)
        actor:send("A lost mage tells you, 'Perfect! Only two items left!'")
        wait(1)
        self:command("rem mystics")
        self:destroy_item("mystics")
        self:command("hold spellbook")
        wait(1)
        actor:send("A lost mage tells you, 'There is something I need from South Caelia.  I don't")
        actor:send("</>know the area well, but I know someone who does.  I once met a man that mapped")
        actor:send("</>everything he saw.  Please get me his map.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(1)
        self:command("ponder")
        wait(1)
        actor:send("A lost mage tells you, 'I think he said something about the ocean and the")
        actor:send("</>beach, that's all I know.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
    end
elseif stage == 7 then
    if (object.zone_id == 586 and object.id == 8) then
        actor:advance_quest("relocate_spell_quest")
        wait(0.2)
        actor:send("A lost mage tells you, 'Almost there, one more!'")
        wait(1)
        self:command("rem telescope")
        self:destroy_item("telescope")
        self:command("hold map")
        wait(1)
        actor:send("A lost mage tells you, 'The only thing left that I need is something to write")
        actor:send("</>with.  A while back I dropped something while engaged in a little confrontation")
        actor:send("</>with that witch Baba.  Luckily, I don't think she saw me drop it, so it should")
        actor:send("</>still be hidden around there.'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(4)
        self:command("sigh")
        wait(1)
        actor:send("A lost mage tells you, 'Please get my quill back, then I shall share the spell")
        actor:send("</>with you!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        run_room_trigger(492, 25)
    end
elseif stage == 8 then
    if (object.zone_id == 492 and object.id == 51) then
        wait(1)
        self.room:send("A lost mage examines the golden quill.")
        wait(1)
        self:command("sigh")
        self.room:send(tostring(self.name) .. " says, 'You did not get this yourself.  Unfortunately this is a")
        self.room:send("</>problem, as now that another has touched this it has lost its power.'")
        self:command("frown")
    end
elseif stage == 9 then
    if (object.zone_id == 492 and object.id == 51) then
        wait(2)
        actor:send("A lost mage tells you, 'Excellent, Thank you so much, please wait while I")
        actor:send("</>scribe my spell!'")
        self.room:send_except(actor, "A lost mage tells something to " .. tostring(actor.name) .. ".")
        wait(1)
        self:command("sit")
        self:command("rem map")
        self:destroy_item("map")
        self:command("hold quill")
        self.room:send("A lost mage puts on her spectacles and begins to scribe.")
        wait(2)
        self.room:send("A lost mage puts away her spectacles and stops scribing.")
        self:command("stand")
        self:command("fly")
        wait(1)
        actor:send("A lost mage tells you, 'Very well, I'm done!  Thank you so much,")
        actor:send("</>" .. tostring(actor.name) .. "!'")
        wait(2)
        actor:send("A lost mage tells you, 'And, as I promised, here is the spell!'")
        actor:send("A lost mage shows you the spell scribed in her spellbook.")
        skills.set_level(actor, "relocate", 1000)
        actor:complete_quest("relocate_spell_quest")
        self.room:send_except(actor, "A lost mage shows " .. tostring(actor.name) .. " her spellbook, teaching " .. tostring(actor.possessive) .. " her secrets.")
        wait(2)
        self.room:send("A lost mage starts casting <b:yellow>'relocate'</>...")
        wait(1.5)
        self.room:send("<b:white>A lost mage's molecules loosen and eventually dissipate into thin air.</>")
        self:teleport(get_room(492, 99))
        world.destroy(self)
    end
else
    -- Legacy DG returned 0 here (refuse the item, return it to actor).
    actor:send("A lost mage tells you, 'This item doesn't help me.'")
    actor:send("A lost mage returns your item.")
    self.room:send_except(actor, "A lost mage returns " .. tostring(actor.name) .. "'s item.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'cf819d5581dbbfdf0b84af13f903316e'),
  -- data/triggers/492/492_56_telescope_subquest_receive.lua
  (492, 56, $trig$-- Converted from DG Script #49256: telescope_subquest_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Check for proper actor stage and item
if (object.zone_id == 534 and object.id == 24) then
    if actor:get_quest_stage("relocate_spell_quest") == 4 then
        wait(1)
        actor:send("The observer tells you, 'Thank you so much, you have recovered the lost globe!'")
        self:command("thank " .. tostring(actor.name))
        self:command("rem telescope")
        actor:send("The observer tells you, 'Here, you may now have my Crystal Telescope.'")
        self:command("give telescope " .. tostring(actor.name))
        actor:advance_quest("relocate_spell_quest")
        self:command("bow " .. tostring(actor.name))
        self.room:send("The observer leaves down.")
        world.destroy(self.room:find_actor("globe"))
        world.destroy(self.room:find_actor("observer"))
        return _return_value
    else
        wait(1)
        self:command("eyebrow " .. tostring(actor.name))
        actor:send("The observer tells you, 'Yes, this is what I seek, but how did you come by it?")
        actor:send("</>Only the one that did retrieve the glass for me can be rewarded!'")
        self.room:send_except(actor, "The observer questions " .. tostring(actor.name) .. " harshly.")
        self:command("junk snow-globe")
    end
else
    -- Legacy DG returned 0 here (refuse the item, return it to actor).
    actor:send("The observer tells you, 'This isn't my globe!'")
    actor:send("The observer returns your item to you.")
    self.room:send_except(actor, "The observer refuses " .. tostring(object.shortdesc) .. " from " .. tostring(actor.name) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'b85313e9edd824072ae070c4f75e5cd9'),
  -- data/triggers/502/502_01_ghostly_diplomat_earring_quest.lua
  (502, 1, $trig$-- Converted from DG Script #50201: Ghostly Diplomat Earring Quest
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- TODO: object.id is now the string "zone:local" (e.g. "502:3"), so the
-- numeric vnum equality checks below never match. Rewrite as
-- `object.zone_id == 502 and object.local_id == N` once intended objects
-- are confirmed (legacy vnums 50203, 50201/2, 50204/9, 50215 -> 502:3,
-- 502:1/2, 502:4/9, 502:15 in current composite ID scheme).
-- TODO: actor.group_size / actor.group_member[] are DG-Script idioms with
-- no Rust runtime bindings; the loops below are dead code (locals scoped
-- to if/elseif blocks make `a` nil in the while condition). Replace with
-- a real party iteration once group bindings are exposed.
local _return_value = true  -- Default: allow action
-- switch on object.id
if (object.zone_id == 502 and object.id == 3) then
    -- The ghost of a diplomat has received the magical golden
    -- earring. He knows of this talisman from his studies and
    -- travels. He knows how to make it much more powerful. Now
    -- that he has it, he will do so. However, the process will
    -- drive him mad. The player's job will then be to find
    -- him (with the help of the quiet ranger) and retrieve the
    -- enhanced earring (now a crimson-tinged electrum hoop).
    wait(0.2)
    world.destroy(object)
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("bayou_quest") == 0 then
                person:start_quest("bayou_quest")
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
    self:command("thank " .. tostring(actor.name))
    self:emote("gazes upon the earring, overwhelmed by its beauty.")
    self.room:send(tostring(self.name) .. " says, 'You fool!  You should never have given it up so easily!'")
    self:emote("dashes out of the room.")
    self:teleport(get_room(502, 43))
    if world.count_mobiles(502, 9) < 1 then
        self.room:spawn_mobile(502, 9)
        self:command("remove all")
        self:command("give all maddened-diplomat-spectre")
        self.room:find_actor("maddened-diplomat-spectre"):command("wear all")
        self.room:find_actor("maddened-diplomat-spectre"):move("d")
    end
    world.destroy(self)
elseif (object.zone_id == 502 and object.id == 1) or (object.zone_id == 502 and object.id == 2) then
    -- China from Odz
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:emote("looks over " .. tostring(object.shortdesc) .. " fondly.")
    self.room:send(tostring(self.name) .. " says, 'Attractive, is it not?  A gift from our island friends.'")
    self.room:send(tostring(self.name) .. " says, 'But alas, it has no intrinsic magic that I can detect.'")
    self:emote("politely returns the item.")
    return false  -- legacy return 0: the giver keeps the item
elseif (object.zone_id == 502 and object.id == 4) or (object.zone_id == 502 and object.id == 9) then
    -- Magical eq from bayou
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:emote("stares closely at " .. tostring(object.shortdesc) .. " for a time.")
    self:command("sigh")
    self.room:send(tostring(self.name) .. " says, 'There is something here, but this is far too weak.  No, the captain was after something much more valuable.'")
    self:emote("returns the item.")
    return false  -- legacy return 0: the giver keeps the item
elseif (object.zone_id == 502 and object.id == 15) then
    -- The electrum hoop!
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("bayou_quest") == 0 then
                person:start_quest("bayou_quest")
            end
        elseif person then
            i = i + 1
        end
        a = a + 1
    end
    wait(0.2)
    world.destroy(object)
    if world.count_mobiles(502, 9) < 1 then
        get_room(502, 43):at(function()
            self.room:spawn_mobile(502, 9)
        end)
        get_room(502, 43):at(function()
            self:command("remove all")
        end)
        get_room(502, 43):at(function()
            self:command("give all maddened-diplomat-spectre")
        end)
        get_room(502, 43):at(function()
            self.room:find_actor("maddened-diplomat-spectre"):command("wear all")
        end)
    end
    wait(1)
    self:command("gasp")
    wait(1)
    self:say("What... how... I cannot believe it!")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'And you willingly gave it to me!  Oh the gods of Garl'lixxil smile upon me this day!'")
    wait(1)
    self.room:send("The ghost of a diplomat cackles, and seems to grow before your very eyes!")
    -- Now: move dip to secret room; load maddip; give earring maddip; purge dip; bring maddip back
    local startroom = self.room
    self.room:find_actor("maddened-diplomat-spectre"):teleport(startroom)
    wait(0.1)
    world.destroy(self)
else
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:command("laugh")
    self:say("I'm afraid not.")
    self:emote("politely returns the item.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '7abab795326e34362ac6e528eabb78ad'),
  -- data/triggers/510/510_11_give_to_luchiaans.lua
  (510, 11, $trig$local clericquest = globals.clericquest or 0
local magequest = globals.magequest or 0
local zone = object.zone_id
local id = object.id

if zone == 510 and id == 22 then
    -- Damaged book - more work to do.
    wait(0.5)
    self:say("Hmm...a damaged spellbook.")
    wait(2)
    self:say("Look, " .. tostring(actor.name) .. ", why don't you fix this then maybe we can talk.")
    globals.clericquest = 2
    return true
elseif zone == 510 and id == 23 then
    -- Completed spellbook - reward depends on whether they did it solo.
    wait(0.5)
    self:command("grin")
    self:say(tostring(actor.name) .. ", you've done me proud.")
    self:say("Although I guess you haven't really done any favours for the rest of the world!")
    self:command("cackle")
    local book = self.room:find_object("book-of-healing")
    if book then
        world.destroy(book)
    end
    if clericquest == 1 then
        self:say("And you did it all on your own initiative!  Well, here's a gift you can use.")
        self.room:spawn_object(510, 24)
        self:command("give wand " .. tostring(actor.name))
    elseif clericquest == 2 then
        self:say("Even though I had to help you, you did succeed, so here is a small reward.")
        self.room:spawn_object(510, 25)
        self:command("give wand " .. tostring(actor.name))
    else
        self:say("Best of all, I didn't even ask you to do this, so I don't owe you anything.")
        self:command("cackle")
    end
    globals.clericquest = 3
    return true
elseif zone == 510 and id == 28 then
    -- Phoenix heart.
    wait(0.5)
    self:say("Thanks, " .. tostring(actor.name) .. ".")
    self:say("Now I can generate an army of undead, unkillable zombies to help in my plans.")
    self:command("cackle")
    local heart = self.room:find_object("phoenix-heart")
    if heart then
        world.destroy(heart)
    end
    if magequest == 1 then
        self:say("Oh... about that partner thing.  You know I was joking right?")
        self:emote("looks a bit sheepish.")
        self:say("Well... here's a token of my thanks, but that's all you're getting.")
        self.room:spawn_object(510, 29)
        self:command("give green " .. tostring(actor.name))
        globals.magequest = 2
    else
        self:say("It was very generous of you to give this when I didn't ask for it!")
        self:command("grin")
    end
    return true
elseif zone == 85 and id == 50 then
    -- Generic gate item - silently accept and stop.
    return true
else
    -- Unrecognized gift - return it.
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:say("What am I supposed to do with this?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false
end$trig$, 'de640d35687175e6bf42cfd0e141aadc'),
  -- data/triggers/519/519_14_academy_instructor_command_give.lua
  (519, 14, $trig$-- Converted from DG Script #51914: academy_instructor_command_give
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (51902): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 519 and object.id == 2)
) then
    return true
end

if (actor:get_quest_var("school:gear") or 0) == 12 then
    actor:set_quest_var("school", "gear", 13)
    wait(0.2)
    world.destroy(object)
    actor:send(tostring(self.name) .. " tells you, 'Why thank you, what a lovely gift.'")
    self:command("grin")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Lastly, you can <b:cyan>(P)UT</> objects in containers.")
    actor:send("The command is <b:cyan>PUT [object] [container]</>.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'You started with a bag, but just in case here's another.'")
    self.room:spawn_object(0, 18)
    self:command("give bag " .. tostring(actor))
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Put a stick in it by typing <b:green>put stick bag</>.'")
end$trig$, 'ee0f4cb7252dc03ab0496c9b3eb6ca5c'),
  -- data/triggers/533/533_12_wall_ice_sculptor_receive.lua
  (533, 12, $trig$-- DG receive arg list (53327): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 533 and object.id == 27)
) then
    return true
end

if actor:get_quest_stage("wall_ice") == 1 then
    wait(0.2)
    local blocks = (tonumber(actor:get_quest_var("wall_ice:blocks")) or 0) + 1
    actor:set_quest_var("wall_ice", "blocks", blocks)
    self:say("Great, this is exactly what I need!")
    self.room:send(tostring(self.name) .. " adds " .. tostring(object.shortdesc) .. " to the wall blocking the tunnel.")
    self:destroy_item("all.block-living-ice")
    if blocks == 20 then
        wait(1)
        actor:advance_quest("wall_ice")
        self.room:send(tostring(self.name) .. " says, 'Excellent, this looks like enough ice!  Now all we have to do is cast the spell.  If you'd like to do the honors, just command the ice to <b:cyan>crystalize</>.'")
    else
        wait(0.2)
        self:say("Got any more?")
    end
else
    wait(0.2)
    self:destroy_item("all.block-living-ice")
    self:say("Hey thanks!  I could always use more of those.")
end$trig$, 'f8dad693d823d1b8b01cc0afe2266460'),
  -- data/triggers/534/534_54_lirne_refuse.lua
  (534, 54, $trig$-- Converted from DG Script #53454: Lirne Refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 0%
-- NOTE: legacy probability 0% on RECEIVE means "always run", not "never";
-- the converter's percent_chance(0) gate has been removed.

-- Lirne refuses any item handed to him that isn't the right ingredient for
-- his current quest stage. The salve/sake/marigold quest items belong with
-- Earle, not Lirne, so they get a redirect message; everything else gets a
-- generic "no thanks".
-- DG receive arg list (53450 53452 53453 53454 53455 53456 53457 53458 53459 53460 53461) with num_arg 0: this trigger ran for every other item.
-- The runtime does not filter on arg_list, so the exclusion lives here.
if (object.zone_id == 534 and object.id == 50) or
    (object.zone_id == 534 and object.id == 52) or
    (object.zone_id == 534 and object.id == 53) or
    (object.zone_id == 534 and object.id == 54) or
    (object.zone_id == 534 and object.id == 55) or
    (object.zone_id == 534 and object.id == 56) or
    (object.zone_id == 534 and object.id == 57) or
    (object.zone_id == 534 and object.id == 58) or
    (object.zone_id == 534 and object.id == 59) or
    (object.zone_id == 534 and object.id == 60) or
    (object.zone_id == 534 and object.id == 61) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
-- TODO(parity): legacy DG checked object vnums 53451 (shale, zone 534/id 51),
-- 58002 (sake, zone 580/id 2), 58609 (marigold poultice, zone 586/id 9). The
-- converter incorrectly nested stage==3 / stage==4 inside the stage==2 branch
-- and lost the redirect message for stages 3 and 4. Reconstructed below using
-- composite (zone_id, local_id) checks; verify zone numbers against the
-- canonical ingredient definitions.
local response = "No thanks."
if stage == 2 then
    if object.zone_id == 534 and object.local_id == 51 then
        response = "Give this to Earle, not me."
    end
elseif stage == 3 then
    if object.zone_id == 580 and object.local_id == 2 then
        response = "Give this to Earle, not me."
    end
elseif stage == 4 then
    if object.zone_id == 586 and object.local_id == 9 then
        response = "Give this to Earle, not me."
    end
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(response)
return false  -- legacy return 0: the giver keeps the item$trig$, 'f0b84fc688d240bbbe4df35a6e3f0bea'),
  -- data/triggers/534/534_62_major_globe_earle_receive_shale.lua
  (534, 62, $trig$-- Converted from DG Script #53462: major_globe_earle_receive_shale
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (53451): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 51)
) then
    return true
end

if actor:get_quest_stage("major_globe_spell") == 2 then
    -- chunk of shale
    wait(0.1)
    actor:advance_quest("major_globe_spell")
    self:destroy_item("majorglobe-shale")
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'This will do.'")
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Next you will need to retrieve some alcohol for the salve.  Make it <b:yellow>sake</>, actually.  That would be best.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well, go on then!  Don't keep Lirne waiting.'")
    self:emote("starts crushing the shale in a bowl.")
end$trig$, 'b891c4ca26a8c32a544153be3d4972a1'),
  -- data/triggers/534/534_63_major_globe_earle_receive_sake.lua
  (534, 63, $trig$-- Converted from DG Script #53463: major_globe_earle_receive_sake
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (58002): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 580 and object.id == 2)
) then
    return true
end

if actor:get_quest_stage("major_globe_spell") == 3 then
    -- bottle of sake
    wait(0.1)
    actor:advance_quest("major_globe_spell")
    self:destroy_item("sake")
    actor:send(tostring(self.name) .. " says, 'Good, good.  This will mix well.  Just one more ingredient.  We'll need some <b:yellow>marigold poultice</> to complete this salve.'")
    self:command("think")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'It's commonly used by healers, perhaps you should track one down.'")
end$trig$, 'd33974d5f0626ca1bdb1b77f4ed985da'),
  -- data/triggers/534/534_64_major_globe_earle_receive_marigold.lua
  (534, 64, $trig$-- Converted from DG Script #53464: major_globe_earle_receive_marigold
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (58609): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 586 and object.id == 9)
) then
    return true
end

if actor:get_quest_stage("major_globe_spell") == 4 then
    -- marigold salve
    wait(0.1)
    actor:advance_quest("major_globe_spell")
    self:destroy_item("marigold-poultice")
    actor:send(tostring(self.name) .. " says, 'Excellent, let me just finish this salve then...'")
    self:emote("begins mixing the items in a clay bowl.")
    wait(2)
    self:emote("recites a short incantation over the bowl.")
    wait(2)
    self:emote("pours the salve into a tiny jar.")
    actor:send(tostring(self.name) .. " says, 'There we are, this will surely cure whatever ails Lirne.'")
    self.room:spawn_object(534, 50)
    self:command("give herbal-salve " .. tostring(actor.name))
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well, don't keep him waiting.  Go, go!'")
end$trig$, 'c5e2b38d7039a88ccb7cb7ce068be28f'),
  -- data/triggers/534/534_65_major_globe_lirne_receive_1.lua
  (534, 65, $trig$-- Converted from DG Script #53465: Major Globe Lirne receive 1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (53450): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 50)
) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
if stage == 5 then
    actor:advance_quest("major_globe_spell")
    -- TODO(parity): legacy DG stored a single room vnum in the
    -- `major_globe_spell:room` quest var, then trigger 53455 used
    -- `actor.room == quest_var` to check if the questor was in the right
    -- search room. With composite ids that single integer no longer
    -- identifies a room; consider storing a (zone, id) pair or a packed
    -- value once a quest-var schema is settled. Vnums below: 16903 haunted
    -- house, 12553 tower in the wastes, 16063 mystwatch, 18582 abbey,
    -- 53079 / 53078 sunken (zone 530).
    local roll = random(1, 5)
    local target_vnum
    if roll == 1 then
        target_vnum = 16903
    elseif roll == 2 then
        target_vnum = 12553
    elseif roll == 3 then
        target_vnum = 16063
    elseif roll == 4 then
        target_vnum = 18582
    elseif roll == 5 then
        target_vnum = 53079
    else
        target_vnum = 53078
    end
    actor:set_quest_var("major_globe_spell", "room", target_vnum)
    wait(0.1)
    self:destroy_item("majorglobe-salve")
    self:command("smile")
    self:emote("sniffs " .. tostring(objects.template(534, 50).name) .. ".")
    actor:send(tostring(self.name) .. " says, 'Smells powerful.'")
    wait(1)
    self:emote("begins spreading the salve across his lesions.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can feel it working.'")
    self:command("smile")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Well, no time to waste.  The demon still walks the valley.  To defeat it, we will need to combat its magic.'")
    self:command("ponder")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I think I know a way...  Yes...'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Lore speaks of a spell powerful enough to deflect great magic.'")
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The spellbook containing the spell was lost, though.  Perhaps you can find it.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Search</> in each <b:cyan>stack</> and <b:cyan>library</>!  Surely it will be found in one of them.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm sure it still exists...  It must.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well?  Quickly, now!'")
elseif stage < 5 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'Perhaps you should do the steps of this quest in order.  Go talk to Earle.'")
    return false  -- legacy return 0: the giver keeps the item
elseif stage > 5 then
    wait(0.1)
    self:destroy_item("majorglobe-salve")
    actor:send(tostring(self.name) .. " says, 'But... you've already given me this.  I'm healed already.'")
end
return true$trig$, 'f4c2d410547de5eb0cdb699676087182'),
  -- data/triggers/534/534_66_major_globe_lirne_receive_2.lua
  (534, 66, $trig$-- Converted from DG Script #53466: Major Globe Lirne receive 2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (53452): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 52)
) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
if stage == 7 then
    actor:advance_quest("major_globe_spell")
    wait(0.1)
    self:destroy_item("majorglobe-spellbook")
    self:command("gasp")
    actor:send(tostring(self.name) .. " says, 'This is fantastic!  I knew you would find it.'")
    self:emote("opens the spellbook and begins leafing through it.")
    wait(3)
    self:emote("begins to look very excited.")
    actor:send(tostring(self.name) .. " says, 'Ah ha!  Here it is...  The spell to protect against powerful magic.  We'll need some <b:yellow>elemental wards</> to power it, though.'")
    self:command("snap")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'You must banish some elementals and return their energies to me.  I think five should do it: mist, water, ice, flame, or plant.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Yes... go and <b:cyan>banish five unique elementals</> and bring back their energies!'")
elseif stage < 7 then
    self:command("eyebrow")
    actor:send(tostring(self.name) .. " says, 'How could you have found this?  Do the quest in order!'")
    return false  -- legacy return 0: the giver keeps the item
elseif stage > 7 then
    wait(0.1)
    self:destroy_item("majorglobe-spellbook")
    actor:send(tostring(self.name) .. " says, 'You've already brought me this!")
end
return true$trig$, '6617a4de9a1768a6d0d051efa40f3d00'),
  -- data/triggers/534/534_67_major_globe_lirne_receive_3.lua
  (534, 67, $trig$-- Converted from DG Script #53467: Major Globe Lirne receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (53453 53454 53455 53456 53457): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 53) or
    (object.zone_id == 534 and object.id == 54) or
    (object.zone_id == 534 and object.id == 55) or
    (object.zone_id == 534 and object.id == 56) or
    (object.zone_id == 534 and object.id == 57)
) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
if stage == 8 then
    wait(0.1)
    -- TODO(parity): original DG keyed the quest var by global vnum
    -- of the handed-in ward. With composite ids, key by the object's
    -- local id within zone 534 (wards are objects 53-57 in zone 534 —
    -- see trigger 53457).
    local number = object.local_id
    local ward = actor:get_quest_var("major_globe_spell:ward_" .. tostring(number))
    self:destroy_item("majorglobe-ward")
    if (ward or 0) == 0 then
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'How could you have gotten this?  Do the quest yourself!'")
    elseif (ward or 0) == 1 then
        -- mark this specific ward as turned in (2 = consumed)
        actor:set_quest_var("major_globe_spell", "ward_" .. tostring(number), 2)
        local wards = (actor:get_quest_var("major_globe_spell:ward_count") or 0) + 1
        actor:set_quest_var("major_globe_spell", "ward_count", wards)
        local wards_left = 5 - wards
        self:command("smile")
        if wards_left > 0 then
            actor:send(tostring(self.name) .. " says, 'Excellent, only " .. tostring(wards_left) .. " more, and we'll be almost ready.'")
        else
            actor:advance_quest("major_globe_spell")
            actor:send(tostring(self.name) .. " says, 'Okay!  That's enough elemental wards to power the spell.  We only need one more item to channel the power...'")
            self:command("think")
            self:emote("quickly studies the spellbook again.")
            -- final_item: pick one of the four legendary items (objects in
            -- zone 534 ids 58-61); store its local id in the quest var.
            local roll = random(1, 4)
            local final_local
            local place
            if roll == 1 then
                final_local = 58
                place = "in a border keep"
            elseif roll == 2 then
                final_local = 59
                place = "on an emerald isle"
            elseif roll == 3 then
                final_local = 60
                place = "within a misty fortress"
            else
                final_local = 61
                place = "in an underground city"
            end
            actor:set_quest_var("major_globe_spell", "final_item", final_local)
            wait(3)
            local final_name = objects.template(534, final_local).name
            actor:send(tostring(self.name) .. " says, 'Yes, the last item for the spell is here.  It is <b:yellow>" .. tostring(final_name) .. "</>.'")
            self:emote("thinks hard for a moment.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'It is rumored that it can be found <b:cyan>" .. tostring(place) .. "</>.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Quickly, go now and retrieve it so that we might defeat the demon!'")
        end
    elseif (ward or 0) == 2 then
        local wards_left = 5 - (actor:get_quest_var("major_globe_spell:ward_count") or 0)
        self:command("eyebrow")
        if wards_left > 1 then
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different ones!")
        else
            actor:send(tostring(self.name) .. " says, 'You've already given me this ward.  We still need " .. tostring(wards_left) .. " different one!")
        end
    end
elseif stage < 8 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'I'm not quite ready to deal with those yet.  Do the quest in order.'")
    return false  -- legacy return 0: the giver keeps the item
elseif stage > 8 then
    wait(0.1)
    self:destroy_item("majorglobe-ward")
    actor:send(tostring(self.name) .. " says, 'You already gave me all the elemental wards!'")
end
return true$trig$, '11408d7472b799e0a8f477ea35c1e401'),
  -- data/triggers/534/534_68_major_globe_lirne_receive_4.lua
  (534, 68, $trig$-- Converted from DG Script #53468: Major Globe Lirne receive 4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (53458 53459 53460 53461): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 534 and object.id == 58) or
    (object.zone_id == 534 and object.id == 59) or
    (object.zone_id == 534 and object.id == 60) or
    (object.zone_id == 534 and object.id == 61)
) then
    return true
end

local stage = actor:get_quest_stage("major_globe_spell")
local response
if stage == 10 then
    -- final_item quest var stores the chosen object's local id within zone 534
    if actor:get_quest_var("major_globe_spell:final_item") == object.local_id then
        wait(0.1)
        self:destroy_item("majorglobe-channel")
        skills.set_level(actor, "major globe", 1000)
        self:emote("grins excitedly.")
        actor:send(tostring(self.name) .. " says, 'Yes!  Now I can cast the spell... and defeat the demon!'")
        self:emote("holds the wards in one hand.")
        wait(2)
        actor:send(tostring(self.name) .. " starts casting <b:yellow>'major globe'</>...")
        wait(2)
        self:emote("completes his spell...")
        self:emote("closes his eyes and utters the words, 'wiyaf travo'.")
        self.room:send("<b:red>A shimmering globe of force wraps around " .. tostring(self.name) .. "'s body.</>")
        wait(2)
        self:command("smile")
        actor:send(tostring(self.name) .. " says, 'I feel much better too!  My sincerest thanks for your help.  As thanks, I offer you knowledge of this ancient spell also.'")
        wait(1)
        actor:send(tostring(self.name) .. " stares at you and utters a quick incantation.")
        actor:send("<b:white>You feel your skill in spell knowledge improving!</>")
        self.room:send_except(actor, tostring(self.name) .. " stares at " .. tostring(actor.name) .. " and utters a quick incantation.")
        wait(1)
        actor:complete_quest("major_globe_spell")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Now I must take my leave.  Wish me well!'")
        self:emote("hurries out of the room.")
        self:teleport(get_room(11, 0))
        world.destroy(self)
    else
        response = "This isn't what the spell calls for..."
    end
elseif stage < 10 then
    response = "I'm not ready for that yet.  Do the quest in the right order."
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    return false  -- legacy return 0: the giver keeps the item
end
return true$trig$, 'd9043cff5cd00532c94e1e924ad70460'),
  -- data/triggers/550/550_06_master_shaman_receive_tear.lua
  (550, 6, $trig$-- Converted from DG Script #55006: Master Shaman receive tear
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55023): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 23)
) then
    return true
end

wait(0.1)
self:command("eye " .. tostring(actor.name))
self:destroy_item("golden")
self:say("This looks like one of the legendary keys!")
wait(0.2)
self:command("thank " .. tostring(actor.name))
wait(0.2)
self:say("Oh thank you!  Take this as a reward.")
self.room:spawn_object(550, 19)
self:command("give fang " .. tostring(actor.name))
self:command("drop fang")$trig$, '698389fa5c0810489d9cd0ca853a66a6'),
  -- data/triggers/550/550_07_master_shaman_skull_receive.lua
  (550, 7, $trig$-- Converted from DG Script #55007: Master Shaman skull receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55005): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 5)
) then
    return true
end

wait(0.2)
local i = actor.group_size or 0
local a = 1
while a <= i do
    local person = actor.group_member[a]
    if person and person.room == self.room then
        if person:get_quest_stage("tech_mysteries_quest") == 0 then
            person:start_quest("tech_mysteries_quest")
        end
        person:set_quest_var("tech_mysteries_quest", "cloak", 1)
    end
    a = a + 1
end
self:destroy_item("skull")
self:say("Oh my!  You have destroyed a great evil!  My kingdom will never be threatened by it again!")
wait(0.2)
self:command("thank " .. tostring(actor.name))
wait(0.2)
self:say("I know the Snow Leopard would want you to have this!")
self.room:spawn_object(550, 8)
self:command("give cloak " .. tostring(actor.name))
self:command("drop cloak")$trig$, '13015ecf47b9552fc90706b089db97ae'),
  -- data/triggers/550/550_24_wizard_eye_master_shaman_receive_1.lua
  (550, 24, $trig$-- Converted from DG Script #55024: Wizard Eye Master Shaman receive 1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (58609): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 586 and object.id == 9)
) then
    return true
end

local stage = actor:get_quest_stage("wizard_eye")
if stage == 2 then
    wait(0.2)
    world.destroy(object)
    actor:advance_quest("wizard_eye")
    actor:send(tostring(self.name) .. " says, 'Ah, marigold for clairvoyance.  That makes sense.  I will store it while you seek the advice of the next sage.'")
    actor:send(tostring(self.name) .. " tucks the marigold poultice away in her chamber.")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'There are a handful of true visionaries in Ethilien, but one stands out among the rest.  The <b:cyan>Seer of Griffin Isle</> always receives the most cryptic of visions.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Whatever a \"sun screen\" is I have no idea, but she speaks of it often.'")
    self:command("ponder")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Often I am forced to question her sanity...'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Regardless of her mental state, she is a truly master diviner.  <b:cyan>Visit her</> and see what she recommends you do to attune to your future crystal ball.'")
end$trig$, 'c2fa640c5c650c5aa2066a6216765980'),
  -- data/triggers/550/550_36_wizard_eye_seer_receive.lua
  (550, 36, $trig$-- Converted from DG Script #55036: wizard_eye_seer_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 4 then
    local item = nil
    if object.zone_id == 23 and object.local_id == 29 then
        item = 1
    elseif object.zone_id == 237 and object.local_id == 53 then
        item = 2
    elseif object.zone_id == 480 and object.local_id == 5 then
        item = 3
    end
    if not item then
        return true
    end
    local var_key = "item" .. tostring(item)
    if actor:get_quest_var("wizard_eye:" .. var_key) then
        actor:send(tostring(self.name) .. " says, 'You already brought me this!'")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    else
        actor:set_quest_var("wizard_eye", var_key, 1)
        wait(0.2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Yep, this'll do.'")
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
            end
            wait(0.2)
            actor:send(tostring(self.name) .. " says, 'Let me just stitch up a little bag for you.'")
            wait(1)
            self:emote("cuts a large square from the indigo silk dress.")
            self:emote("quickly sews the square into a little pouch.")
            self:emote("fills the pouch with the thyme and bay leaves and stitches it shut.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Here ya go!'")
            self.room:spawn_object(550, 30)
            self:command("give sachet " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Sweet dreams!'")
            self:command("cackle")
        else
            wait(0.2)
            if not actor:get_quest_var("wizard_eye:item1") then
                actor:send(tostring(self.name) .. " says, 'What about the bay?'")
            end
            if not actor:get_quest_var("wizard_eye:item3") then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Did you find a dress I can upcycle?'")
            end
            if not actor:get_quest_var("wizard_eye:item2") then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Oh do you have the thyme?'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Of course you don't, you don't have a wristwatch!'")
                self:command("laugh")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'No but really, if you have it, give it to me.'")
            end
        end
    end
end
return true$trig$, '0e6e3dbc904ba6dd12eed27722c566f3'),
  -- data/triggers/550/550_39_wizard_eye_apothecary_receive.lua
  (550, 39, $trig$-- Converted from DG Script #55039: wizard_eye_apothecary_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 7 then
    local item = nil
    if object.zone_id == 237 and object.local_id == 54 then
        item = 1
    elseif object.zone_id == 30 and object.local_id == 298 then
        item = 2
    elseif object.zone_id == 238 and object.local_id == 47 then
        item = 3
    elseif object.zone_id == 180 and object.local_id == 1 then
        item = 4
    end
    if not item then
        return true
    end
    local var_key = "item" .. tostring(item)
    if actor:get_quest_var("wizard_eye:" .. var_key) then
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already brought me " .. tostring(object.shortdesc) .. ".'")
        return false  -- legacy return 0: the giver keeps the item
    else
        actor:set_quest_var("wizard_eye", var_key, 1)
        world.destroy(object)
        wait(0.2)
        actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".'")
        wait(0.4)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
            end
            actor:send(tostring(self.name) .. " says, 'That looks like everything.  Let me grind this all up!'")
            wait(2)
            self:emote("pulls out a mortar and pestle from behind the counter.")
            wait(1)
            self:emote("grinds the roses and cinnamon to a fine powder and shapes it into a small brick.")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'This incense should be perfect for you!'")
            self.room:spawn_object(550, 32)
            self:command("give incense " .. tostring(actor.name))
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Be careful!'")
            self:command("grin " .. tostring(actor.name))
        else
            actor:send(tostring(self.name) .. " says, 'Do you have the rest of the ingredients?'")
        end
    end
end
return true$trig$, 'ce627af78332d9b528732ad82b13475f'),
  -- data/triggers/550/550_40_wizard_eye_oracle_receive.lua
  (550, 40, $trig$-- Converted from DG Script #55040: wizard_eye_oracle_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 10 then
    local item = nil
    if object.zone_id == 30 and object.local_id == 218 then
        item = 1
    elseif object.zone_id == 534 and object.local_id == 24 then
        item = 2
    elseif object.zone_id == 430 and object.local_id == 21 then
        item = 3
    elseif object.zone_id == 40 and object.local_id == 3 then
        item = 4
    end
    if not item then
        return true
    end
    local var_key = "item" .. tostring(item)
    if actor:get_quest_var("wizard_eye:" .. var_key) then
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already brought me " .. tostring(object.shortdesc) .. ".'")
        return false  -- legacy return 0: the giver keeps the item
    else
        actor:set_quest_var("wizard_eye", var_key, 1)
        wait(0.2)
        world.destroy(object)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
            end
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'This seems to be all of them.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'O Rhalean, show me the balance of Justice!'")
            self:emote("utters a few words of power!")
            wait(2)
            actor:send("The four orbs begin to <b:white>glow</>!")
            actor:send("They become fully transparent and colorless.")
            wait(3)
            self:emote("scrutinizes the four now identical mystic orbs.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Yes I see...'")
            self:emote("picks up one of the four clear crystal balls.")
            self.room:spawn_object(550, 33)
            self:command("give crystal-ball " .. tostring(actor.name))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'This will be your window to the universe.'")
            wait(2)
            self:command("bow " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'May Justice follow you always.'")
        else
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'And the rest?'")
        end
    end
end
return true$trig$, '4e1719c8edc2926fa70786b030686c6d'),
  -- data/triggers/550/550_43_wizard_eye_master_shaman_receive_2.lua
  (550, 43, $trig$-- Converted from DG Script #55043: Wizard Eye Master Shaman receive 2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55030): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 30)
) then
    return true
end

local stage = actor:get_quest_stage("wizard_eye")
if stage == 5 then
    wait(0.2)
    self:destroy_item("sachet")
    actor:advance_quest("wizard_eye")
    actor:send(tostring(self.name) .. " says, 'Very smart blend of herbs.  It will bring prophetic dreams.  She always did know her sachets.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I will store it for you.'")
    actor:send(tostring(self.name) .. " tucks the herbal sachet away in her chamber.")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'I believe it's time to <b:cyan>visit the witchy woman who runs the apothecary in Anduin</>.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Like the others you have visited, she has no name any can recall, simply going by \"the Green Woman.\"'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Though she may not look like much, she is both a powerful diviner and a master of secrets.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Other peoples' secrets.  Which she sells to the highest bidder.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'See what she recommends.  Surely she has a trick or two up her sleeve.'")
end$trig$, '59cd791a4345d95bdaf9fc3988893eed'),
  -- data/triggers/550/550_44_wizard_eye_master_shaman_receive_3.lua
  (550, 44, $trig$-- Converted from DG Script #55044: Wizard Eye Master Shaman receive 3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55032): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 32)
) then
    return true
end

local stage = actor:get_quest_stage("wizard_eye")
if stage == 8 then
    wait(0.2)
    actor:advance_quest("wizard_eye")
    world.destroy(object)
    self:emote("smells the cinnamon-rose blend.")
    actor:send(tostring(self.name) .. " says, 'Ahhh, what a gorgeous fragrance!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Cinnamon and rose both open the third eye andincrease psychic awareness.  And I would never have thought to use powdered sapphire in an incense.  Very clever.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I shall put this with the other necessaries.'")
    actor:send(tostring(self.name) .. " tucks the incense away in her chamber.")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'It looks like you have everything prepared.  Now for the most difficult part.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I have been scrying on my cauldron to determine the final steps of your journey.  I believe I have located <b:yellow>four potential orbs</> to serve as your crystal ball.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Unfortunately, I'm not sure which of the four will be best suited to you:")
    actor:send("</>")
    actor:send("</>- First is a simple <b:yellow>quartz ball</>.")
    actor:send("</>  But be careful!  It is in the possession of a priest of Blackmourne in Anduin, and they are as dangerous as they are homicidal.")
    actor:send("</>")
    actor:send("</>- Second is an <b:yellow>orb of pure Chaos</>.")
    actor:send("</>  It is kept by the Beast of Borgan, which dwells in the Layveran Labyrinth in the Black Ice Desert.")
    actor:send("</>")
    actor:send("</>- Third is the <b:yellow>Orb of Catastrophe</>.")
    actor:send("</>  Cyprianum the Reaper, the ruler of Demise Keep in the Syric Mountains lays claim to that one.")
    actor:send("</>")
    actor:send("</>- Fourth is a <b:yellow>glass globe</> which controls the flow of time.")
    actor:send("</>  The mysterious Time Elemental Lord, stranded in Frost Valley after the Time Cataclysm, carries this one.'")
    wait(6)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Gather all four and bring them to the Oracle of Justice</> at our sister pyramid in the ancient forest near Anduin.  Only he can tell you which is best for you.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Once the proper choice has been determined, bring the final selection back to me.  I will lead you through the full casting process.'")
end$trig$, 'dc76d283919b165cc7d6e774081a8d04'),
  -- data/triggers/550/550_45_wizard_eye_master_shaman_receive_4.lua
  (550, 45, $trig$-- Converted from DG Script #55045: Wizard Eye Master Shaman receive 4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (55033): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 550 and object.id == 33)
) then
    return true
end

local stage = actor:get_quest_stage("wizard_eye")
if stage == 11 then
    wait(0.2)
    actor:advance_quest("wizard_eye")
    self:emote("admires the crystal ball.")
    actor:send(tostring(self.name) .. " says, 'Truly a perfect tool for scrying.  It suits you.  Keep it and treasure it.'")
    self:command("give crystal-ball " .. tostring(actor.name))
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Everything is prepared!'")
    self:emote("retrieves the poultice, the sachet, and the incense.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'First, the poultice.'")
    self:emote("scoops up some of the pungent poultice and smears it on the crystal ball.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now your turn " .. tostring(actor.name) .. "'")
    actor:send(tostring(self.name) .. " spreads the stinky poultice across your face.  Yuck!")
    self.room:send_except(actor, tostring(self.name) .. " spreads the stinky poultice across " .. tostring(actor.name) .. "'s face.")
    actor:command("gag")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Next the sachet.'")
    self:emote("lays out a pillow and places the herbal sachet beneath it.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'And now, the incense.'")
    self:emote("lights the incense.")
    actor:send("The sweet smell of roses and cinnamon fills the chamber.")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Now, all that's left is for you to <b:cyan>sleep</>, " .. tostring(actor.name) .. ".'")
end$trig$, '1be41e03d4892bed5cd81e80f37ee9cb'),
  -- data/triggers/556/556_32_phase_armor_refuse.lua
  (556, 32, $trig$-- Converted from DG Script #55632: phase_armor_refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
actor:send(tostring(self.name) .. " tells you, 'Why are you handing me this stuff?  I don't want it!'")
actor:send(tostring(self.name) .. " refuses to accept " .. tostring(object.shortdesc) .. " from you.")
return false  -- legacy return 0: the giver keeps the item$trig$, '7f30755d6ba62ca539def8650408ab58'),
  -- data/triggers/557/557_03_phase_armor_-_receive.lua
  (557, 3, $trig$-- Converted from DG Script #55703: Phase Armor - Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG `%get.obj_shortdesc/noadesc/pldesc[VNUM]%` (legacy dg_scripts.cpp): VNUM = zone * 100 + id.
local function proto_short(vnum)
    vnum = tonumber(vnum)
    if not vnum then return "[no description for object ?]" end
    local name = objects.template(math.floor(vnum / 100), vnum % 100).name
    if name == nil or name == "" then return "[no description for object " .. vnum .. "]" end
    return name
end
local function without_article(s)
    for _, a in ipairs({"a pair ", "a ", "an ", "some ", "the "}) do
        if string.lower(string.sub(s, 1, #a)) == a then return string.sub(s, #a + 1) end
    end
    return s
end
local function proto_noa(vnum)
    return without_article(proto_short(vnum))
end
local function proto_plural(vnum)
    local s = proto_short(vnum)
    if string.lower(string.sub(s, 1, 5)) == "some " then
        return "quantities of " .. string.sub(s, 6)
    end
    local u = without_article(s)
    local last2, last1 = string.sub(u, -2, -2), string.sub(u, -1)
    local function consonant(c) return c:match("%a") ~= nil and not c:match("[aeiouAEIOU]") end
    if #u < 2 then return u .. "'s" end
    if last1 == "s" and last2 ~= "s" then return u end  -- already plural ("mittens")
    if (last2 == "e" or last2 == "i") and last1 == "z" then return u .. "zes" end
    if last1 == "x" or last1 == "z" or u:sub(-2) == "sh" or u:sub(-2) == "ss" or u:sub(-2) == "ch"
       or (consonant(last2) and last1 == "o") then
        return u .. "es"
    end
    if consonant(last2) and last1 == "y" then return u:sub(1, -2) .. "ies" end
    return u .. "s"
end
-- DG globals set on this mob by its init (LOAD) trigger, 557:10-39
local classes = self:getvar("classes")
local phase = self:getvar("phase")
local feet_gem = self:getvar("feet_gem")
local head_gem = self:getvar("head_gem")
local hands_gem = self:getvar("hands_gem")
local arms_gem = self:getvar("arms_gem")
local legs_gem = self:getvar("legs_gem")
local body_gem = self:getvar("body_gem")
local wrist_gem = self:getvar("wrist_gem")
local feet_armor = self:getvar("feet_armor")
local head_armor = self:getvar("head_armor")
local hands_armor = self:getvar("hands_armor")
local arms_armor = self:getvar("arms_armor")
local legs_armor = self:getvar("legs_armor")
local body_armor = self:getvar("body_armor")
local wrist_armor = self:getvar("wrist_armor")
local feet_reward = self:getvar("feet_reward")
local head_reward = self:getvar("head_reward")
local hands_reward = self:getvar("hands_reward")
local arms_reward = self:getvar("arms_reward")
local legs_reward = self:getvar("legs_reward")
local body_reward = self:getvar("body_reward")
local wrist_reward = self:getvar("wrist_reward")
if classes == nil or phase == nil then
    return true  -- the init trigger has not run for this mob
end
local _return_value = true  -- Default: allow action
-- The init trigger stores legacy vnums (zone * 100 + id); compare the
-- turned-in object the same way.
local object_id = (tonumber(object.zone_id) or 0) * 100 + (tonumber(object.local_id) or 0)
if object_id == hands_armor or object_id == hands_gem or object_id == feet_armor or object_id == feet_gem or object_id == wrist_armor or object_id == wrist_gem or object_id == head_armor or object_id == head_gem or object_id == arms_armor or object_id == arms_gem or object_id == legs_armor or object_id == legs_gem or object_id == body_armor or object_id == body_gem then
    local anti = "Anti-Paladin"
    if not actor or not actor.can_be_seen then
        self:command("peer")
        actor:send(tostring(self.name) .. " says, 'I can't help you if I can't see you.'")
        return false  -- legacy return 0: the giver keeps the item
    end
    if not string.find(string.lower(classes), actor.class, 1, true) or (classes == anti and actor.class == "paladin") then
        if string.find(classes, "and") then
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " classes only.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Sorry, this quest is for the " .. tostring(classes) .. " class only.'")
        end
        return false  -- legacy return 0: the giver keeps the item
    elseif actor.level <= 20 * (phase - 1) then
        actor:send(tostring(self.name) .. " tells you, 'Sorry, why don't you come back when you've gained more experience?'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return false  -- legacy return 0: the giver keeps the item
    elseif actor:get_quest_stage("phase_armor") < phase then
        actor:send(tostring(self.name) .. " tells you, 'I don't think you're ready for my armor quests yet.'")
        actor:send(tostring(self.name) .. " refuses your item.")
        return false  -- legacy return 0: the giver keeps the item
    end
    -- DG `case <armor>` falls through into `case <gem>`: both set the slot's
    -- multiplier and reward, only the armor sets `is_armor`.
    local is_armor, exp_x, reward_id
    local slot_table = {
        {hands_armor, hands_gem, 1, hands_reward},
        {feet_armor, feet_gem, 2, feet_reward},
        {wrist_armor, wrist_gem, 3, wrist_reward},
        {head_armor, head_gem, 4, head_reward},
        {arms_armor, arms_gem, 6, arms_reward},
        {legs_armor, legs_gem, 8, legs_reward},
        {body_armor, body_gem, 10, body_reward},
    }
    for _, sl in ipairs(slot_table) do
        if object_id == sl[1] then
            is_armor = 1
        end
        if object_id == sl[1] or object_id == sl[2] then
            exp_x = sl[3]
            reward_id = sl[4]
            break
        end
    end
    if is_armor then
        local armor_key = tostring(object_id) .. "_armor_acquired"
        local armor_count = actor:get_quest_var("phase_armor:" .. armor_key) or 0
        if armor_count < 1 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            armor_count = armor_count + 1
            actor:set_quest_var("phase_armor", armor_key, armor_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey now, what have we here!?")
            actor:send("</>I've been looking for this for some time.")
            actor:send("</>You have now given me " .. proto_short(object_id) .. ".'")
        else
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me one of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        local gem_key = tostring(object_id) .. "_gems_acquired"
        local gem_count = actor:get_quest_var("phase_armor:" .. gem_key) or 0
        if gem_count < 3 then
            _return_value = false
            wait(0.1)
            world.destroy(object)
            gem_count = gem_count + 1
            actor:set_quest_var("phase_armor", gem_key, gem_count)
            actor:send(tostring(self.name) .. " tells you, 'Hey, very nice.'")
            wait(0.2)
            actor:send(tostring(self.name) .. " tells you, 'It is good to see that adventurers are out conquering the realm.'")
            wait(0.2)
            if gem_count == 1 then
                actor:send(tostring(self.name) .. " tells you, 'You have given me 1 " .. proto_noa(object_id) .. ".'")
            else
                actor:send(tostring(self.name) .. " tells you, 'You have given me " .. tostring(gem_count) .. " " .. proto_plural(object_id) .. ".'")
            end
        else
            self:command("eye " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " tells you, 'Hey now, you've already given me " .. tostring(gem_count) .. " of these!'")
            actor:send(tostring(self.name) .. " refuses your item.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
    --
    -- Check to see if the quest is complete and if the reward can be given.
    -- The original DG looked up `<gem_id>_gems_acquired` and
    -- `<armor_id>_armor_acquired`; we mirror that using the same
    -- `<id>_..._acquired` keying pattern used above. Per-slot pairing
    -- is derived from whichever gem/armor slot matches `object_id`.
    --
    local function _slot_for(oid)
        if oid == hands_armor or oid == hands_gem then return hands_armor, hands_gem end
        if oid == feet_armor  or oid == feet_gem  then return feet_armor,  feet_gem  end
        if oid == wrist_armor or oid == wrist_gem then return wrist_armor, wrist_gem end
        if oid == head_armor  or oid == head_gem  then return head_armor,  head_gem  end
        if oid == arms_armor  or oid == arms_gem  then return arms_armor,  arms_gem  end
        if oid == legs_armor  or oid == legs_gem  then return legs_armor,  legs_gem  end
        if oid == body_armor  or oid == body_gem  then return body_armor,  body_gem  end
    end
    local slot_armor_id, slot_gem_id = _slot_for(object_id)
    if slot_armor_id
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_gem_id) .. "_gems_acquired") or 0) == 3)
       and ((actor:get_quest_var("phase_armor:" .. tostring(slot_armor_id) .. "_armor_acquired") or 0) == 1) then
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, 'Excellent work, intrepid adventurer!")
        actor:send("</>You have provided me with all I need to reward you with:")
        actor:send("</>" .. proto_short(reward_id) .. "!'")
        wait(0.2)
        actor:send("<b:white>You gain experience!</>")
        local exp
        if actor.class == "warrior" or actor.class == "berserker" then
            exp = 7590
        elseif actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            exp = 7935
        elseif actor.class == "sorcerer" or actor.class == "pyromancer" or actor.class == "cryomancer" or actor.class == "illusionist" or actor.class == "bard" then
            exp = 8280
        elseif actor.class == "necromancer" or actor.class == "monk" then
            exp = 8970
        else
            exp = 6900
        end
        if phase == 2 then
            exp = math.floor(exp * 608 / 100)
        elseif phase == 3 then
            exp = math.floor(exp * 1340 / 100)
        end
        local lap = 1
        while lap <= exp_x do
            actor:award_exp(exp)
            lap = lap + 1
        end
        self.room:spawn_object(math.floor(reward_id / 100), reward_id % 100)
        self:command("give all " .. tostring(actor.name))
        self:command("drop all")
        actor:save()
    end
end  -- auto-close block
return _return_value$trig$, 'd32dcef293a08ec447d19d1eeb10db60'),
  -- data/triggers/557/557_06_guild_master_refuse.lua
  (557, 6, $trig$-- Converted from DG Script #55706: Guild Master refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Item ids in the DG globals are legacy vnums (zone * 100 + local id).
-- Mace-quest ids: DG globals set on this mob by the mace LOAD trigger (002_118), if it has one.
local vnum = object.zone_id * 100 + object.id
if vnum == globals.maceitem2 or vnum == globals.maceitem3 or vnum == globals.maceitem4 or vnum == globals.maceitem5 or vnum == globals.mace_id then
    return _return_value
end
-- TODO(parity): 55662 / 2334 are 5-digit legacy vnums. Verify intent
-- (likely (556, 62) ghost crystal and (23, 34) hell trident) and
-- switch to (zone_id, local_id) once confirmed.
if (object.zone_id == 556 and object.id == 62) or (object.zone_id == 23 and object.id == 34) then
    return _return_value
end
-- Phase-armor inputs: stored on the mob by its init (LOAD) trigger, 557:10-39.
local wanted = false
for _, key in ipairs({"hands_armor", "hands_gem", "feet_armor", "feet_gem", "wrist_armor", "wrist_gem", "head_armor", "head_gem", "arms_armor", "arms_gem", "legs_armor", "legs_gem", "body_armor", "body_gem"}) do
    if vnum == self:getvar(key) then
        wanted = true
        break
    end
end
if wanted then
    return _return_value
else
    self:command("eye " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " tells you, 'I am not interested in this from you.'")
    actor:send(tostring(self.name) .. " returns your item to you.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '7ec326804b38144c891218d50c0825ef'),
  -- data/triggers/580/580_05_charm_person_hinazuru_receive.lua
  (580, 5, $trig$local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("charm_person")
if stage == 1 then
    if (object.zone_id == 480 and object.id == 8) then
        actor:advance_quest("charm_person")
        wait(2)
        self:destroy_item("discipline")
        wait(1)
        self:say("Thank you kindly for bringing this so quickly.")
        self:command("bow " .. tostring(actor.name))
        wait(2)
        actor:send(tostring(self.name) .. " gives you an explanation and demonstration of " .. tostring(objects.template(480, 8).name) .. "'s power and function.")
        wait(3)
        self:say("Having seen this magic in a controlled environment now, I believe it's best to see it in action.")
        wait(2)
        self:say("Many people underestimate the power of charms and enchantments.  They discard them as ineffective or weak compared to more violent magic.")
        wait(4)
        self:say("Yet there is a company of performers in Anduin that proves the most insidious spells do not harm people directly, but convince them to harm themselves.")
        wait(4)
        self:say("They perform a deadly song and dance number which results in the sacrifice of an unwitting accomplice.  They give out rings of fire to those who participated at the end of the show.")
        wait(4)
        self:say("Go and watch this in action.  Bring back the fire ring as a token of your experience.")
        self:command("bow " .. tostring(actor.name))
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not the Rod of Discipline.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 2 then
    if (object.zone_id == 43 and object.id == 19) then
        actor:advance_quest("charm_person")
        wait(2)
        self:destroy_item("ring")
        wait(1)
        self:say("Thank you kindly for bringing this so quickly.")
        self:command("bow " .. tostring(actor.name))
        wait(2)
        self:say("It's horrific what charms can make people do, isn't it?")
        wait(1)
        self:command("shake")
        wait(1)
        self:say("Yet I am glad you have seen it now so you understand the risks involved in charming and beguiling.")
        wait(3)
        self:say("I also had you observe the theatre because you need to have at least a limited knowledge of music.")
        wait(3)
        self:say("As a courtesan, I am expected to be a master of several instruments, as well as song and dance.  As a magician, I use this same mastery as a key element in my spells.")
        wait(2)
        self:say("You will need to seek out musical instruments to hone your charming skills.")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'There are five instruments you must find:")
        self.room:send("- One is merely the <b:yellow>biwa</> held by Yoshino down the hall_")
        self.room:send("- Two are <b:yellow>flutes</> hidden from the sun:")
        self.room:send("</>    One <b:yellow>deep in the sea to the east</>")
        self.room:send("</>    The other <b:yellow>in a mine near Anduin</>_")
        self.room:send("- One is a <b:yellow>hand-fashioned reed pipe</>, popular with people far far to the west_")
        self.room:send("- The final is <b:yellow>a mandolin</>, found in the homes of the gods'")
        wait(4)
        self:say("Once you have found all five of these, come back to me so I may check their condition and ensure their proper tuning.")
        self:command("bow " .. tostring(actor.name))
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not one of the souvenirs the theatre company gives out after a performance.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 3 then
    if (object.zone_id == 580 and object.id == 17) or (object.zone_id == 163 and object.id == 12) or (object.zone_id == 489 and object.id == 25) or (object.zone_id == 370 and object.id == 12) or (object.zone_id == 411 and object.id == 19) then
        if actor:get_quest_var("charm_person:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("You have already brought me " .. tostring(object.shortdesc) .. ".")
            return false  -- legacy return 0: the giver keeps the item
        else
            actor:set_quest_var("charm_person", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(2)
            self.room:send(tostring(self.name) .. " checks " .. tostring(object.shortdesc) .. " for tuning and quality.")
            wait(1)
            self:say("Yes, this should do.  Now come sit, it is time for a lesson.")
            wait(2)
            actor:send(tostring(self.name) .. " begins to teach you several basic techniques and a few melodies.")
            self.room:send_except(actor, tostring(self.name) .. " begins to teach " .. tostring(actor.name) .. " several basic techniques and a few melodies.")
            wait(5)
            actor:send("You begin to get a feel for it...")
            wait(7)
            actor:send("After several hours, you seem to have picked up the basics!")
            self.room:send_except(actor, "After several hours, " .. tostring(actor.name) .. " seems to have picked up the basics!")
            self:command("give all " .. tostring(actor))
            self:say("Hold on to that instrument, you'll need it later.")
            wait(2)
            if actor:get_quest_var("charm_person:58017") and actor:get_quest_var("charm_person:16312") and actor:get_quest_var("charm_person:48925") and actor:get_quest_var("charm_person:37012") and actor:get_quest_var("charm_person:41119") then
                actor:advance_quest("charm_person")
                wait(4)
                self:say("You now have at least a modicum of experience in five instruments.  It is time to put your skills to the test and see what you have learned!")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'There are five master charmers in the world.  Take these instruments out and see if you can impress them.  Each one prefers a different kind of music, so be ready to show off your skills!")
                self.room:send("</>")
                self.room:send("</>- One runs the <b:magenta>jewelry shop in Mielikki.</>")
                self.room:send("</>- One is a local <b:magenta>actor</> here on the <b:magenta>Emerald Island.</>")
                self.room:send("</>- One works with the <b:magenta>acting company in Anduin</>, playing their <b:magenta>Queen.</>")
                self.room:send("</>- One is a <b:magenta>hideous creature that enslaves minds</> in the dark <b:magenta>drow city.</>")
                self.room:send("</>- The last can be any of the <b:magenta>river nymphs</> in the <b:magenta>Realm of the King of Dreams.</>_")
                self.room:send("</>Say to them <b:magenta>[Let me serenade you]</> and see what they do.'")
                wait(5)
                self:say("It is here our paths must split.")
                wait(1)
                self:say("It has been my pleasure to work with you.")
                wait(1)
                self:say("Farewell.")
                self:command("bow " .. tostring(actor.name))
            else
                local function _have(k) return (actor:get_quest_var(k) and 1) or 0 end
                local music = _have("charm_person:58017") + _have("charm_person:16312") + _have("charm_person:48925") + _have("charm_person:37012") + _have("charm_person:41119")
                if music > 0 and music < 4 then
                    self:say("Do you have the other instruments?")
                elseif music == 4 then
                    self:say("Do you have the last instrument?")
                end
            end
        end
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say(tostring(object.shortdesc) .. " is not a musical instrument.")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self:say("I am in need of nothing at the moment, thank you.")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'a46ecc4a15272bce70bde5865a3c9160'),
  -- data/triggers/586/586_02_dragons_health_myorrhed_receive.lua
  (586, 2, $trig$local _return_value = true  -- Default: allow the give to proceed
local stage = actor:get_quest_stage("dragons_health")
if stage == 1 then
    if object.zone_id == 125 and object.local_id == 9 then
        wait(0.2)
        self:emote("examines " .. tostring(object.shortdesc) .. ".")
        world.destroy(object)
        wait(1)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'I had little doubt you would succeed.'")
        actor:advance_quest("dragons_health")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your next target is considerably more powerful so be prepared.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'The dragon Tri-Aszp has a cult dedicated to her in the")
        actor:send("</>northern reaches.  She uses them to commit heinous acts and keep the")
        actor:send("</>region in her clutches.'")
        wait(5)
        self:emote("places her hands on the egg.")
        actor:send(tostring(self.name) .. " says, 'It would be a boon to both this dragon's future and to all")
        actor:send("</>dragonkind if you could eliminate her.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Dragon scales have incredible monetary and ancestral value.")
        actor:send("</>A scale from Tri-Aszp will remind our hatchling of the legacy it bears.")
        actor:send("</>Bring back one of her scales as a trophy.'")
    else
        actor:send(tostring(self.name) .. " says, 'Hmmm, this doesn't seem to have the proper draconic energies.'")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 2 then
    if object.zone_id == 533 and object.local_id == 25 then
        actor:advance_quest("dragons_health")
        wait(0.2)
        self:emote("runs her eyes over " .. tostring(object.shortdesc) .. ".")
        world.destroy(object)
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Excellent work.  With the Cult of the Ice Dragon in shambles,")
        actor:send("</>the world is that much safer.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Tri-Aszp's children may grow to be a threat in the future")
        actor:send("</>which is why this next generation is so important.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'That next generation of chromatic dragons is actually what")
        actor:send("</>we should address next.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sagece of Raymif, the half-demon dragon that rules Templace,")
        actor:send("</>had two spawn sometime after she crawled into our world.  They are entombed in")
        actor:send("</>a crypt far to the north as guardians of a soul-shredding lich.'")
        wait(5)
        actor:send(tostring(self.name) .. " says, 'In their position is a wondrous stone unlike anything else in")
        actor:send("</>existence.  It flickers with an inner green light.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Destroy her spawn, the black dragons Thelriki and Jerajai, and")
        actor:send("</>return with the stone.'")
    else
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, '" .. tostring(object.shortdesc) .. " is not one of Tri-Aszp's scales.'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 3 then
    if object.zone_id == 480 and object.local_id == 24 then
        if actor:get_quest_var("dragons_health:thelriki") and actor:get_quest_var("dragons_health:jerajai") then
            actor:advance_quest("dragons_health")
            wait(0.2)
            self:emote("looks suspiciously at " .. tostring(object.shortdesc) .. ".")
            world.destroy(object)
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Thank you for ending them.  They shall blight the world no more.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Now for the hardest task of all.  When Templace fell and demons")
            actor:send("</>from Garl'lixxil were loosed on Ethilien, the balance of the Dragonwars")
            actor:send("</>was forever changed.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'The time has come to right that balance.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Lay siege to Templace and slay the ancient black dragon Sagece")
            actor:send("</>of Raymif.  Bring back her skin and a shield she keeps, plus the two decoys")
            actor:send("</>she keeps in her cursed hoard.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'And know, you must be there when the demon dragon falls.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'May Bahamut watch over you and grant you fortune!'")
        elseif actor:get_quest_var("dragons_health:thelriki") and not actor:get_quest_var("dragons_health:jerajai") then
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'Jerajai still lives!  You must destroy him first!'")
            return false  -- legacy return 0: the giver keeps the item
        elseif not actor:get_quest_var("dragons_health:thelriki") and actor:get_quest_var("dragons_health:jerajai") then
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'Thelriki still lives!  You must destroy her first!'")
            return false  -- legacy return 0: the giver keeps the item
        else
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'The hell-dragon spawn still live!  You must destroy them first!'")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'This is not part of their hoard.'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 4 then
    local sagece = actor:get_quest_var("dragons_health:sagece")
    if object.zone_id == 520 and (object.local_id == 16 or object.local_id == 17 or object.local_id == 22 or object.local_id == 23) then
        if not sagece then
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You must slay Sagece first!'")
            return false  -- legacy return 0: the giver keeps the item
        else
            if actor:get_quest_var("dragons_health:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) then
                actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                actor:send(tostring(self.name) .. " says, 'You have already given this to me.'")
                return false  -- legacy return 0: the giver keeps the item
            else
                actor:set_quest_var("dragons_health", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                wait(0.2)
                local emote = random(1, 4)
                -- switch on emote
                do
                    local _sw1 = string.lower(tostring(emote or ""))
                    if tonumber(_sw1) == 1 then
                        self:emote("looks at " .. tostring(object.shortdesc) .. " with disdain.")
                    elseif tonumber(_sw1) == 2 then
                        self:emote("regards " .. tostring(object.shortdesc) .. " with caution.")
                    elseif tonumber(_sw1) == 3 then
                        self:emote("grimaces at " .. tostring(object.shortdesc) .. ".")
                    else
                        self:emote("sneers at " .. tostring(object.shortdesc) .. ".")
                    end
                end
                world.destroy(object)
            end
        end
        local item1 = actor:get_quest_var("dragons_health:520_16")
        local item2 = actor:get_quest_var("dragons_health:520_17")
        local item3 = actor:get_quest_var("dragons_health:520_22")
        local item4 = actor:get_quest_var("dragons_health:520_23")
        wait(1)
        if item1 and item2 and item3 and item4 then
            actor:advance_quest("dragons_health")
            actor:send(tostring(self.name) .. " says, 'I can't believe she's finally gone.'")
            wait(2)
            self:emote("places the remnants of the other dragons' hoards around the egg.")
            wait(0.2)
            actor:send("The egg shifts and rocks slightly with signs of life!")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'The last thing the egg needs is money.  Lots of it.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " says, 'Bring anything of value you can find. You can even offer coin.")
            actor:send("</>About 10,000 platinum worth of treasure should be satisfactory.  That's about")
            actor:send("</>10,000,000 copper, in case it needed to be said.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Some very powerful objects are so unique they are priceless.")
            actor:send("</>Bring them to me and I shall see if they are worth including as well.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'And remember, just because someone sells something for a")
            actor:send("</>certain price, doesn't mean it's actually worth that much!'")
        else
            actor:send(tostring(self.name) .. " says, 'Good.  Do you have the remaining artifacts?'")
        end
    else
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'This is not significant enough to Sagece.'")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 5 then
    if object.cost == 0 and object.level < 60 then
        self:emote("examines " .. tostring(object.shortdesc) .. " closely.")
        actor:send(tostring(self.name) .. " says, 'Unfortunately there isn't enough inherent value to <b:yellow>" .. tostring(object.shortdesc) .. " to be part of the hatchling's hoard.'")
        return false  -- legacy return 0: the giver keeps the item
    end

        wait(0.2)
        self:emote("examines " .. tostring(object.shortdesc) .. " closely.")
    local price = 0
        if (object.level >= 60) and (object.cost == 0) then
        price = (object.level * 1000)
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  Although it has no inherent price, the mystic value of it is: <b:yellow>" .. tostring(price) .. "</> copper.'")
        elseif object.level >= 60 and object.cost < (object.level * 1000) then
            price = (object.level * 1000)
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  Even though it has some material value, the mystic value of it is: <b:yellow>" .. tostring(price) .. "</> copper.'")
        elseif (object.level < 60 and object.cost > 0) or (object.level >= 60 and object.cost >= (object.level * 1000)) then
            price = object.cost
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  It has a value of: <b:yellow>" .. tostring(object.cost) .. "</> copper.'")
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'It shall be included in the offerings.'")
        self:emote("places " .. tostring(object.shortdesc) .. " next to the egg.")
        world.destroy(object)
        wait(0.2)

    local hoard = actor:get_quest_var("dragons_health:hoard") or 0
    local wealth = hoard + price
    actor:set_quest_var("dragons_health", "hoard", wealth)
    if wealth >= 10000000 then
        actor:advance_quest("dragons_health")
        run_room_trigger(586, 4)
    else
        local total = 10000000 - wealth
        local plat = total // 1000
        local gold = (total // 100) - (plat * 10)
        local silv = (total // 10) - (plat * 100) - (gold * 10)
        local copp = total - (plat * 1000) - (gold * 100) - (silv * 10)
        actor:send(tostring(self.name) .. " says, 'We need " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper more in treasure and coins.'")
    end
else
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    actor:send(tostring(self.name) .. " says, 'I'm not looking for anything right now.'")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '54f35a5faacb0f1e63a69b6b0ab8cf0d'),
  -- data/triggers/590/590_46_group_armor_forgemaster_receive.lua
  (590, 46, $trig$-- Converted from DG Script #59046: group_armor_forgemaster_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("group_armor")
-- switch on stage
do
    local _sw1 = string.lower(tostring(stage or ""))
    if tonumber(_sw1) == 1 then
        if (object.zone_id == 61 and object.id == 18) or (object.zone_id == 117 and object.id == 4) or (object.zone_id == 117 and object.id == 7) or (object.zone_id == 169 and object.id == 6) then
            if (actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
                self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
                return false  -- legacy return 0: the giver keeps the item
            else
                actor:set_quest_var("group_armor", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                wait(0.2)
                world.destroy(object.name)
                wait(0.2)
                self:say("Aye, this'll do.")
                local item1 = actor:get_quest_var("group_armor:6118")
                local item2 = actor:get_quest_var("group_armor:11704")
                local item3 = actor:get_quest_var("group_armor:11707")
                local item4 = actor:get_quest_var("group_armor:16906")
                if item1 and item2 and item3 and item4 then
                    actor:advance_quest("group_armor")
                    wait(0.2)
                    self:say("That looks like everything!")
                    self:emote("places the four objects near the altar.")
                    wait(4)
                    self:say("Bad news though.")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, 'The Haven was attacked by orcs from Bluebonnet Pass")
                    self.room:send("</>while you were gone!'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " says, 'Fortunately no one was killed, but I had to use")
                    self.room:send("</>my consecrated forging hammer to defend myself.  It's no good for works of")
                    self.room:send("</>holy creation now.'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " says, 'Since I need to fix up the forge after the attack")
                    self.room:send("</>would you be willing to find me another forging hammer?'")
                else
                    local total = ((item1 or 0) + (item2 or 0) + (item3 or 0) + (item4 or 0))
                    wait(0.2)
                    if total <= 2 then
                        self:say("Do you have any of the other items?")
                    elseif total == 3 then
                        self:say("Do you have the last one?")
                    end
                end
            end
        else
            self:say(tostring(object.shortdesc) .. " doesn't cast Armor ya daffy spriggan!")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:command("laugh")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif tonumber(_sw1) == 2 then
        if (object.zone_id == 87 and object.id == 1) then
            wait(0.2)
            self:emote("examines the hammer.")
            self:say("This will do!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'To consecrate the hammer again you'll need to")
            self.room:send("</>find a place where the light of the sun reaches deep into the bowels of")
            self.room:send("</>Ethilien and <b:white>[commune]</> with the spirits there.'")
            wait(0.2)
            self:command("give hammer " .. tostring(actor.name))
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Places where ore and stone are mined often become")
            self.room:send("</>sacred places for us dwarves.'")
            actor:advance_quest("group_armor")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't a forging hammer!")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif tonumber(_sw1) == 3 then
        if (object.zone_id == 590 and object.id == 39) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("Where did you find this?")
            self:say("This can't be the same hammer you brought me before.")
        elseif (object.zone_id == 87 and object.id == 1) then
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, 'You need to bring me the consecrated hammer.")
            self.room:send("</>Another mundane forging hammer is useless.'")
        end
        return false  -- legacy return 0: the giver keeps the item
    elseif tonumber(_sw1) == 4 then
        if (object.zone_id == 590 and object.id == 39) then
            actor:advance_quest("group_armor")
            wait(0.2)
            world.destroy(object.name)
            wait(0.2)
            self:say("Moradin's flames, this is splendid!")
            wait(1)
            self.room:send(tostring(self.name) .. " gives the new hammer a few practice swings.")
            self:say("Aye, that's a fine hammer!")
            wait(3)
            self:say("Let us continue!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'This spell needs to be contained in a holy symbol of")
            self.room:send("</>some kind.  There is an amulet, an Aegis amulet, that would serve well for this")
            self.room:send("</>purpose.'")
            wait(3)
            self:say("Find it and bring it back here.")
        else
            self:say("What in the heck is this?")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif tonumber(_sw1) == 5 then
        if (object.zone_id == 125 and object.id == 0) then
            wait(0.2)
            self.room:send(tostring(self.name) .. " scrutinizes " .. tostring(object.shortdesc) .. " with a discerning glance.")
            world.destroy(object.name)
            wait(2)
            self:command("nod")
            self:say("Mmhmmm.  Mhmmm.")
            wait(1)
            self:say("Yes, this will be an excellent divine focus.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Finally, I need to capture the intangible protective")
            self.room:send("</>essence of ethereal armor to finish the amulet.  I know of three pieces:'")
            self.room:send("<b:white>a breastplate</>")
            self.room:send("<b:white>a ring</>")
            self.room:send("<b:white>a bracelet</>")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'See if you can find them.  Items like these are")
            self.room:send("</>often worn by the dead as they can interact with them.'")
            wait(2)
            self:say("Good luck and Moradin guard you!")
            actor:advance_quest("group_armor")
        else
            self:say("This won't be a very effective focus.")
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false  -- legacy return 0: the giver keeps the item
        end
    elseif tonumber(_sw1) == 6 then
        if (object.zone_id == 470 and object.id == 4) or (object.zone_id == 470 and object.id == 18) or (object.zone_id == 530 and object.id == 3) then
            if (actor:get_quest_var("group_armor:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
                self:say("You already brought me " .. tostring(object.shortdesc) .. "!")
                return false  -- legacy return 0: the giver keeps the item
            else
                wait(0.2)
                actor:set_quest_var("group_armor", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
                self.room:send(tostring(self.name) .. " places " .. tostring(object.shortdesc) .. " near the altar.")
                world.destroy(object.name)
                wait(1)
                local item1 = actor:get_quest_var("group_armor:47004")
                local item2 = actor:get_quest_var("group_armor:47018")
                local item3 = actor:get_quest_var("group_armor:53003")
                if item1 and item2 and item3 then
                    self:command("grin")
                    self:say("With everything gathered, I can get to work!")
                    wait(2)
                    self.room:send(tostring(self.name) .. " lays the ethereal breastplate on the anvil.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " thrusts his hammer into the forge.")
                    self.room:send(tostring(self.name) .. " entones, 'Dwarffather, hear my prayer.'")
                    wait(4)
                    self.room:send(tostring(self.name) .. " raises the <b:red>glowing</> hamer.")
                    wait(4)
                    self.room:send(tostring(self.name) .. " entones, 'Bless my hammer in this act of Creation.'")
                    wait(3)
                    self.room:send("The hammer turns <b:white>white</> with holy energy.")
                    wait(5)
                    self.room:send(tostring(self.name) .. " brings the hammer down on the ethereal breastplate!")
                    self.room:send("The breastplate ripples from the force of the hit like the surface of a lake struck by a drop of water.")
                    wait(5)
                    self:say("Now we add the extra magic!")
                    wait(2)
                    self.room:send(tostring(self.name) .. " grabs the broom and the hardened stick of leather.")
                    self.room:send(tostring(self.name) .. " points them at the ethereal breastplate and releases their magic.")
                    wait(4)
                    self.room:send("The ethereal breastplate glows white-hot and starts to sizzle!")
                    wait(4)
                    self.room:send(tostring(self.name) .. " takes a pair of tongs and lays the ethereal bracelet on the radiating breastplate.")
                    wait(5)
                    self.room:send(tostring(self.name) .. " uncorks the violet potion and pours it over the breastplate.")
                    self.room:send("The glow of the breastplate begins to seep into the bracelet!")
                    wait(5)
                    self:say("Let Creation ring throughout this hallowed forge!")
                    wait(4)
                    self.room:send(tostring(self.name) .. " strikes the ethereal metals again, melding the bracelet into the armor.")
                    wait(4)
                    self.room:send("The armor begins to decohere.")
                    wait(5)
                    self.room:send(tostring(self.name) .. " places the ethereal ring on the shifting energies.")
                    self.room:send(tostring(self.name) .. " pours the green potion over the ring, which quickly dissolves.")
                    wait(5)
                    self.room:send(tostring(self.name) .. " strikes the ethereal mass over and over, chanting prayers to Moradin.")
                    wait(5)
                    self.room:send("The ethereal energies completely decohere!")
                    self.room:send("The forge is filled with hot energy like a basin filled with water.")
                    wait(5)
                    self.room:send(tostring(self.name) .. " raises the Aegis amulet over his head.")
                    wait(2)
                    self:say("Soul Forger, let this amulet grant us Your protection!")
                    wait(4)
                    self.room:send("The Aegis amulet begins to <b:yellow>glow!</>")
                    wait(4)
                    self.room:send("All sound falls away as the radiant energies of the forge are absorbed into the amulet!")
                    wait(4)
                    self.room:send(tostring(self.name) .. " places the amulet on the forge anvil.")
                    wait(4)
                    self.room:send("With a final ceremonial blow, " .. tostring(self.name) .. " seals the protective energies into their new form!")
                    wait(7)
                    self.room:send("Slowly sound returns as the ringing of an anvil.")
                    wait(2)
                    self.room:send(tostring(self.name) .. " inspects the new holy amulet.")
                    wait(2)
                    self:say("Aye, our work is finished.  Thank you acolyte.")
                    self:emote("bows and says, 'May the Dwarffather shield you ever more!'")
                    wait(2)
                    actor:complete_quest("group_armor")
                    actor:send("You feel a stirring in your soul!")
                    actor:send("<b:white>Moradin blesses you with the knowledge of Group Armor!</>")
                    skills.set_level(actor, "group armor", 1000)
                else
                    self:say("Did ya find anything else?")
                end
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't going to serve for Group Armor.")
            return false  -- legacy return 0: the giver keeps the item
        end
    else
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("What is this for?")
        return false  -- legacy return 0: the giver keeps the item
    end
end
return _return_value$trig$, '9a8a06a0580bddffe147e9de6f920bfe'),
  -- data/triggers/615/615_11_giving_a_wisp_heart_to_someone.lua
  (615, 11, $trig$-- Converted from DG Script #61511: Giving a wisp heart to someone
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if globals.heart_inplace == 1 then
    -- Note: the mud appears to prevent this trigger from being activated
    -- again when it's in progress, so this really does nothing, but I've
    -- left it here just in case.
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'Hang on a minute!'</>")
    return false  -- legacy return 0: the giver keeps the item
else
    _return_value = false
    globals.heart_inplace = 1
    wait(2)
    self:emote("looks over " .. tostring(object.shortdesc) .. " carefully.")
    wait(3)
    actor:send("<blue>" .. tostring(self.name) .. " tells you, 'Ok, let's see if this does any good.'</>")
    wait(3)
    self:emote("flutters up to the top of the menhir and puts " .. tostring(object.shortdesc) .. " in the depression.")
    if object.zone_id == 615 and object.local_id == 4 then
        self:destroy_item("fiery-wisp-heart")
        run_room_trigger(615, 12)
    else
        wait(5)
        self:emote("peers thoughtfully at " .. tostring(object.shortdesc) .. ", with her tiny chin held between her thumb and forefinger.")
        wait(3)
        self:emote("zips up to the top of the menhir and yanks " .. tostring(object.shortdesc) .. " out of the hole.")
        wait(2)
        self:say("I guess that wasn't it!")
        self:command("drop " .. tostring(object.name))
    end
    globals.heart_inplace = 0
end
return _return_value$trig$, '61c27396b80d6f394d7a305df34d3d29'),
  -- data/triggers/615/615_24_wise_leprechaun_receiving_goodies.lua
  (615, 24, $trig$-- Converted from DG Script #61524: Wise leprechaun receiving goodies
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local function obj_is(z, l)
    return object.zone_id == z and object.local_id == l
end
-- switch on object id
if obj_is(615, 1) or obj_is(120, 1) or obj_is(0, 146) or obj_is(0, 147) then
    wait(0.4)
    self:emote("sniffs " .. tostring(object.shortdesc) .. " carefully.")
    wait(1)
    self:emote("munches heartily on " .. tostring(object.shortdesc) .. ", juice running down his cheeks.")
    world.destroy(object.name)
    if actor.gender == "male" then
        self:say("Why thank you, good sir!")
    else
        self:say("Why thank you, my dear!")
    end
    wait(1)
    self:say("But that's not my favorite fruit is it, oh no.")
elseif obj_is(615, 2) then
    -- spotted apple
    wait(0.8)
    self:emote("turns " .. tostring(object.shortdesc) .. " over and peers at it thoughtfully.")
    wait(1)
    self:emote("swiftly eats " .. tostring(object.shortdesc) .. " with loud chewing noises.")
    world.destroy(object.name)
    if actor.gender == "female" then
        self:say("Well that was nice, wasn't it my darling?")
    else
        self:say("Well that was nice, wasn't it my boy?")
    end
    wait(1)
    self:say("But it just isn't what I'm looking for.")
    wait(0.4)
    self:command("sigh")
elseif obj_is(615, 3) then
    -- This is the wizened apple.
    wait(0.8)
    self:emote("stares daggers at " .. tostring(object.shortdesc) .. ", as if he'd been handed a spider.")
    wait(1)
    self:emote("angrily hurls " .. tostring(object.shortdesc) .. " off into the bushes!")
    world.destroy(object.name)
    wait(0.4)
    if actor.gender == "female" then
        self:say("Well now what's the big idea, lassie?")
    elseif actor.gender == "male" then
        self:say("Well now what's the big idea, laddie?")
    else
        self:say("Well now what's the big idea?")
    end
    wait(0.4)
    self.room:send(tostring(self.name) .. " says, 'That was an insult of a fruit, if ever there was one!'")
elseif obj_is(615, 51) then
    -- Purple cherry: leprechaun's favourite. Eats it, marks the giver
    -- (and any group-mates in the room) as ready for the knife
    -- enchantment, then waits for a flint knife.
    wait(0.8)
    self:emote("gazes lovingly at " .. tostring(object.shortdesc) .. ".")
    wait(1)
    if globals.got_cherry == 1 then
        self.room:send(tostring(self.name) .. " says, 'I've already had one of these... but I can't turn them down!'")
    end
    wait(0.4)
    globals.got_cherry = 1
    self:emote("happily pops " .. tostring(object.shortdesc) .. " into his mouth and chews gleefully!")
    wait(0.8)
    world.destroy(object.name)
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", I thank you from the bottom of my heart.'")
    wait(1)
    self:say("That was a rare treat.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Alright then, hand me a knife and I'll enchant it for ye.'")
    -- Mark all group-mates in the room as eligible for the enchantment.
    local size = (actor.group_size or 0)
    local a = (actor.group_size and 1) or 0
    while a <= size do
        local person = actor.group_member and actor.group_member[a]
        if person and person.room == self.room then
            if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                person:start_quest("enchanted_hollow_quest")
            end
            person:set_quest_var("enchanted_hollow_quest", "got_cherry", 1)
        end
        a = a + 1
    end
elseif obj_is(615, 4) then
    self:emote("quickly shields his eyes from " .. tostring(object.shortdesc) .. "'s intense glow.")
    self:say("Ach!  Are you trying to blind me?")
    return false  -- legacy return 0: the giver keeps the item
elseif obj_is(615, 5) or obj_is(615, 6) then
    -- Flint knife (615,6) or already-enchanted (615,5).
    -- If the giver has fed a cherry, enchant it. Otherwise return it.
    if (actor:get_quest_var("enchanted_hollow_quest:got_cherry") or 0) == 1 then
        wait(0.8)
        -- Clear the per-group eligibility flag now that we've earned the knife.
        local size = (actor.group_size or 0)
        local a = (actor.group_size and 1) or 0
        while a <= size do
            local person = actor.group_member and actor.group_member[a]
            if person and person.room == self.room then
                if person:get_quest_stage("enchanted_hollow_quest") == 0 then
                    person:start_quest("enchanted_hollow_quest")
                end
                person:set_quest_var("enchanted_hollow_quest", "got_cherry", 0)
            end
            a = a + 1
        end
        self:say("Well now!  I suppose I owe you an enchantment!")
        wait(4)
        self:emote("turns and thrusts " .. tostring(object.shortdesc) .. " into the earth.")
        wait(2)
        self:emote("says a few magical words, then touches " .. tostring(object.shortdesc) .. " on the hilt.")
        wait(4)
        world.destroy(object.name)
        self:emote("pulls an emblazoned flint knife out of the ground.")
        self.room:spawn_object(615, 5)
        wait(2)
        self:command("give emblazoned-flint-knife " .. tostring(actor.name))
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'If you see a web, just drop this nearby it.  I've given it an innate hatred of webs, you'll see!'")
    else
        self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
        self:say("Eh?  What have you done for me lately?")
        self.room:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back.")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif obj_is(557, 55) then
    -- dried fruit
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:emote("looks wistfully at " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, 'Ach, what a waste.  Sorry, it's no use trying to eat this now!'")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false  -- legacy return 0: the giver keeps the item
elseif obj_is(620, 76) then
    -- banana
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self:emote("seems a bit perplexed.")
    self:emote("sniffs " .. tostring(object.shortdesc) .. ".")
    self:say("Well now... it smells nice, doesn't it?")
    self:command("peer " .. tostring(actor.name))
    self:emote("licks " .. tostring(object.shortdesc) .. " carefully.")
    self:say("I'm not sure I want to bite this, though, do I?")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false  -- legacy return 0: the giver keeps the item
else
    self.room:send_except(actor, tostring(actor.name) .. " gives " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    actor:send("You give " .. tostring(object.shortdesc) .. " to " .. tostring(self.name) .. ".")
    self.room:send(tostring(self.name) .. " says, 'Now I wouldn't know what to do with this, now would I?'")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    self.room:send_except(actor, tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to " .. tostring(actor.name) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, '0215c20aa6e8ef5b426ac4d82baa08cb'),
  -- data/triggers/615/615_53_creeping_doom_pixie_receive.lua
  (615, 53, $trig$-- Converted from DG Script #61553: creeping_doom_pixie_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("creeping_doom")
local function obj_is(z, l)
    return object.zone_id == z and object.local_id == l
end
if stage == 1 then
    if obj_is(118, 12) or obj_is(162, 13) or obj_is(480, 29) then
        if (actor:get_quest_var("creeping_doom:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
            self:say("You already brought me " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false  -- legacy return 0: the giver keeps the item
        else
            actor:set_quest_var("creeping_doom", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(0.2)
            world.destroy(object)
            self:say("Just what we need.")
            if actor:get_quest_var("creeping_doom:118_12") and actor:get_quest_var("creeping_doom:162_13") and actor:get_quest_var("creeping_doom:480_29") then
                actor:advance_quest("creeping_doom")
                wait(1)
                self:say("Yesssss... Raaaaaaage...")
                wait(2)
                self:say("Now we need all the doom!  Swarms of DOOM!!")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Ethilien is chock-full of creepy-crawlies:")
                self.room:send("</>Flies, bugs, spiders, scorpions, giant ant creatures...")
                wait(2)
                self:say("The list goes on.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Creeping Doom is just swarms of these things.  You'll")
                self.room:send("</>need to gather <b:green>11 essence of swarms</> from these creatures, one for every circle")
                self.room:send("</>of magic the spell requires.'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Harvesting these essences'll take time and patience.")
                self.room:send("</>The more powerful the insect you kill, the more likely you'll find acceptable")
                self.room:send("</>essences.  Bring those essences to me.'")
            else
                wait(0.2)
                self:say("Where's the rest?")
            end
        end
    else
        self:say("This isn't going to help.")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 2 then
    if obj_is(615, 17) then
        wait(0.2)
        self:say("Yesssss...  More essences!")
        local spiders = (actor:get_quest_var("creeping_doom:spiders") or 0) + 1
        actor:set_quest_var("creeping_doom", "spiders", spiders)
        self:destroy_item("essence-of-swarms")
        wait(0.2)
        if spiders == 11 then
            actor:advance_quest("creeping_doom")
            self.room:send(tostring(self.name) .. " says, 'The Rage and Doom are hyped, but we need to keep 'em")
            self.room:send("</>from going too aggro.  Trophies from ending Nature's suffering'll temper them")
            self.room:send("</>into a focused, deadly weapon.  The scythe to cut down Nature's enemies...'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'There are three particular trees that suffer in")
            self.room:send("</>unnatural agony.  Help them and bring a trophy of the experience.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'One is a treant plagued by invasive dogs in the")
            self.room:send("</>forest of the oldest Rhell.  Ease the tree's suffering and bring back a limb")
            self.room:send("</>as a relic of peace.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Another is an eternally burning tree in the ruined")
            self.room:send("</>city Templace.  End the tree's suffering and bring back one of its burning")
            self.room:send("</>branches as a relic of succor.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'The final is an elder tremaen in an ancient forest")
            self.room:send("</>beset by the elemental Plane of Fire.  The tremaen carries the holy Seed of")
            self.room:send("</>the Silveroak.  Return with the Seed as a relic of the promise of new life")
            self.room:send("</>even in the face of extreme burnination.'")
        else
            local remaining = 11 - spiders
            self.room:send(tostring(self.name) .. " says, 'You have brought me " .. tostring(spiders) .. " <b:green>essence of swarms</>.")
            self.room:send(tostring(remaining) .. " more to go.'")
        end
    else
        self:say("This isn't a swarm!!")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
elseif stage == 3 then
    if obj_is(484, 16) or obj_is(520, 34) or obj_is(625, 3) then
        if (actor:get_quest_var("creeping_doom:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)) or 0) == 1 then
            self:say("You already found this.")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            return false  -- legacy return 0: the giver keeps the item
        else
            actor:set_quest_var("creeping_doom", (tostring(object.zone_id) .. "_" .. tostring(object.local_id)), 1)
            wait(1)
            self:say("This is it!")
            world.destroy(object)
            if actor:get_quest_var("creeping_doom:484_16") and actor:get_quest_var("creeping_doom:520_34") and actor:get_quest_var("creeping_doom:625_3") then
                self:say("These are all the parts we need!")
                actor:advance_quest("creeping_doom")
                wait(1)
                self.room:send(tostring(self.name) .. " ties the bit of vine to the treant limb.")
                wait(2)
                self.room:send("Using the burning branch, she lights the vine on fire and crushes the scarab and spider.")
                wait(3)
                self.room:send(tostring(self.name) .. " sprinkles the Seed of the Silveroak with the ash mixture.")
                wait(1)
                self.room:send("One by one " .. tostring(self.name) .. " blows the essences of swarms onto the Seed of the Silveroak.")
                wait(2)
                self.room:send("The Seed of the Silveroak glows <green>green</> and <red>red</>!")
                wait(1)
                self.room:spawn_object(615, 18)
                self:command("give essence-natures-vengeance " .. tostring(actor.name))
                wait(2)
                -- (empty say)
                self.room:send(tostring(self.name) .. " says, 'Now to rain doom on the doomed heads of our doomed")
                self.room:send("</>enemies!'")
                wait(2)
                self:say("In the Black Woods is a logging camp clearcutting the forest.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Take this new seed and drop it at the")
                self.room:send("</><b:white>entrance to the logging camp</>.'")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'Death will wash over the camp and annihilate")
                self.room:send("</>everything there.  Stay and watch.  Hear every last scream.  Feel")
                self.room:send("</>every last death.  Then you'll understand Creeping Doom.'")
                wait(4)
                self:say("That is the strength of Nature's vengeance.")
                wait(4)
                self:say("Once you've done the deed, come back.")
            else
                wait(1)
                self:say("Help the other trees and bring the trophies to me.")
            end
        end
    else
        self:say("The heck is this??")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        return false  -- legacy return 0: the giver keeps the item
    end
else
    self:say("The heck is this??")
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    return false  -- legacy return 0: the giver keeps the item
end
return _return_value$trig$, 'fcda3f964889ed375a6d37719a88c1d4'),
  -- data/triggers/625/625_16_treant_receive.lua
  (625, 16, $trig$-- Converted from DG Script #62516: treant receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (62504): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 4)
) then
    return true
end

if world.count_mobiles(625, 0) > 0 then
    wait(0.2)
    world.destroy(object)
    wait(0.8)
    self:say("You've done pretty well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs his shoulder and peels some bark off.")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 6)
    self:command("give badge " .. tostring(actor))
elseif world.count_mobiles(625, 0) == 0 then
    wait(0.2)
    world.destroy(object)
    wait(0.8)
    self:say("You've done exceptionally well clearing out those pests for me.  The trees thank you, and so do I.")
    self:emote("grabs a branch growing off his back and breaks it off!")
    wait(1)
    self:say("Accept this token of gratitude on behalf of the forest.")
    self.room:spawn_object(625, 3)
    self:command("give limb " .. tostring(actor))
end$trig$, '88abd915464c863063502fcb36625b0c'),
  -- data/triggers/625/625_19_rhell_merchant_refuse.lua
  (625, 19, $trig$-- Converted from DG Script #62519: Rhell merchant refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local response
if actor:get_has_completed("ursa_quest") then
    response = "I don't really need this."
elseif actor:get_quest_stage("ursa_quest") == 0 or actor:get_quest_stage("ursa_quest") == 0 then
    response = "I don't think this will help me."
elseif actor:get_quest_stage("ursa_quest") == 1 then
    -- Three letter-objects (625, 10/11/12) advance the quest; pass them through.
    if object.zone_id == 625 and (object.local_id == 10 or object.local_id == 11 or object.local_id == 12) then
        return true
    else
        response = "This isn't helpful."
    end
end
if not response then
    return true
end
self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
self:say(tostring(response))
if actor:get_quest_stage("ursa_quest") == 1 then
    self:say("Maybe you could ask someone who might know.")
end
return false  -- legacy return 0: the giver keeps the item$trig$, '74b0268370bc763f36f6f8eb8c116773'),
  -- data/triggers/625/625_22_rhell_merchant_receive_1-1.lua
  (625, 22, $trig$-- Converted from DG Script #62522: Rhell Merchant receive 1-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- the emperor's letter is returned, 'choice' is set to path 1: item is pepper, from graveyard.
-- DG receive arg list (62511): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 11)
) then
    return true
end

if actor:get_quest_stage("ursa_quest") == 1 then
    wait(1)
    actor:set_quest_var("ursa_quest", "choice", 1)
    actor:advance_quest("ursa_quest")
    self:say("News from the Emperor?!  This is fantastic!")
    wait(1)
    self:emote("breathes a sigh of relief.")
    wait(2)
    self:emote("reads " .. tostring(object.shortdesc) .. ".")
    world.destroy(object)
    wait(3)
    self:say("He tells me this spring, if it's the spring he's read about in the archives, has the power to heal me, but not without the help of a few other items of power.")
    wait(1)
    self:emote("continues to read.")
    wait(2)
    self:say("The first thing his instructions call for is peppercorn.  I'm not sure where to get that, but sales prices for pepper always always seem lowest in the Anduin area.  Please bring me some.")
end$trig$, '74644a3a4befd82d2cf5ca7b01ee43c7'),
  -- data/triggers/625/625_23_rhell_merchant_receive_1-2.lua
  (625, 23, $trig$-- Converted from DG Script #62523: Rhell Merchant receive 1-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- if the player returns the letter from Ruin, 'choice' is set to path 2: the golden sceptre of imanhotep
-- DG receive arg list (62510): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 10)
) then
    return true
end

if actor:get_quest_stage("ursa_quest") == 1 then
    wait(0.2)
    world.destroy(object)
    actor:set_quest_var("ursa_quest", "choice", 2)
    actor:advance_quest("ursa_quest")
    wait(0.8)
    self:command("gasp")
    wait(1)
    self:say("Ruin has unlocked the secrets of lycanthropy?!")
    wait(2)
    self:emote("skims over the letter.")
    wait(3)
    self:command("frown")
    wait(2)
    self:say("I'm going to need some more help, it seems.")
    wait(2)
    self:say("Ruin speaks of an ancient king that once overcame his own case of lycanthropy.  He suggests if I follow this king's procedure closely, I may have a slight chance.")
    wait(2)
    self:say("He doesn't inspire much hope, does he?")
    self:command("sigh")
    wait(2)
    self:say("At any rate, the first thing he mentions here is a particular gold sceptre that symbolized the king's undying leadership.")
    wait(1)
    self:say("Such a symbol would likely have made its way into the hands of other mighty rulers.  Find the sceptre and bring it to me.")
end$trig$, 'ba937bd3c35e81ba8516737aef0c41f4'),
  -- data/triggers/625/625_24_rhell_merchant_receive_1-3.lua
  (625, 24, $trig$-- Converted from DG Script #62524: Rhell Merchant receive 1-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- if the player returns the letter from the hermit, 'choice' is set to path 3: the ring of stolen life
-- DG receive arg list (62512): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 625 and object.id == 12)
) then
    return true
end

if actor:get_quest_stage("ursa_quest") == 1 then
    wait(0.2)
    world.destroy(object)
    actor:set_quest_var("ursa_quest", "choice", 3)
    actor:advance_quest("ursa_quest")
    wait(0.8)
    self:say("He has always told me he's found a cure for everything he's ever heard of.  I just need you to help gather some things.")
    wait(2)
    self:say("He says a devourer has a ring with power to heal.  Do you know what ring he means?  Please, go get this ring.  Devourers are drawn to magic, and burrow to avoid the sun.  That is all I know.")
end$trig$, '6c0c7dff2f3e15c684205bc1da28de53'),
  -- data/triggers/625/625_25_rhell_merchant_receive_2-1.lua
  (625, 25, $trig$-- Converted from DG Script #62525: Rhell Merchant receive 2-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after pepper, the merchant needs a plant, found in the form of 'a bit of bones and plants' from blue fog trail.
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 237 and object.local_id == 55 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Good!  You managed to find some pepper.")
            wait(1)
            self:say("I've been looking over this next item, and it should be a lot less hassle.")
            wait(2)
            self:say("Just west of here, there is a plant that roots to sticks and rocks, and even beings if they hold still long enough.  I need some of that plant.  It shouldn't be too hard.")
            wait(1)
            self:say("... I think.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't what I need right now.  Please bring me some pepper.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, 'abd91b415645a5e750f09671124e1789'),
  -- data/triggers/625/625_26_rhell_merchant_receive_2-2.lua
  (625, 26, $trig$-- Converted from DG Script #62526: Rhell Merchant receive 2-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: if the golden sceptre is returned, the merchant asks for the sunstone diadem from tech.
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 162 and object.local_id == 1 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(0.1)
            self:emote("runs his hand down the shaft of the golden sceptre.")
            wait(2)
            self:say("What power!")
            wait(2)
            self:say("The king also wore an emblem of the sun.")
            wait(1)
            self:say("Ruin believes this emblem to be the very one written of in the legends of the warring gods in the far north.")
            wait(2)
            self:say("I feel the sceptre longing for it.  Find the sunstone and bring it to me.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't the king's golden sceptre.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '18289527b8424756d7ef76944d78483b'),
  -- data/triggers/625/625_27_rhell_merchant_receive_2-3.lua
  (625, 27, $trig$-- Converted from DG Script #62527: Rhell Merchant receive 2-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: ring of stolen life is returned, merchant asks for the golden druidstaff
if actor:get_quest_stage("ursa_quest") == 2 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 125 and object.local_id == 38 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at the ring.")
            self:say("Incredible!  I can feel it's magic working!")
            wait(2)
            self:say("Now I need the... gothen droolstall?  I can't read his chicken scratch!  But he says it's in the Highlands, with \"their\" leader.")
            wait(1)
            self:command("blink")
            wait(2)
            -- Orphaned text: Who's leader?!
            wait(1)
            self:command("grumble")
            self:say("I guess you'll just have to search the Highlands.  Let me know when you figure out what the hermit meant.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I don't think this is the ring...")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '2e9e33b26b4f98f4c93b6bb197072f17'),
  -- data/triggers/625/625_28_rhell_merchant_receive_3-1.lua
  (625, 28, $trig$-- Converted from DG Script #62528: Rhell Merchant receive 3-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, after the plant, comes the thorny staff, from The Citadel of Betrayal.
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 118 and object.local_id == 10 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:emote("looks at " .. tostring(object.shortdesc) .. ".")
            world.destroy(object)
            wait(1)
            self:say("What an odd item to have rooted itself to.")
            self:command("chuckle")
            wait(1)
            self:say("Now, I need a particular thorny wood.  Because of it's unpleasant nature there are some unpleasant people that make staves and walking sticks out of it.")
            wait(1)
            self:say("Please find one, and bring it back here.  I have almost everything called for on these instructions.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't it.  What I'm after right now is a plant from the Blue-Fog Trail that binds itself to just about anything.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '33eb8ab2cff796d40e42131cfb15b67e'),
  -- data/triggers/625/625_29_rhell_merchant_receive_3-2.lua
  (625, 29, $trig$-- Converted from DG Script #62529: Rhell Merchant receive 3-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 2: after bringing the sunstone diadem, merchant asks for the radiant dagger, an mload in sacred haven
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 550 and object.local_id == 14 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:emote("inspects the stone.")
            wait(2)
            self:say("You are quite resourceful.  This was the ancient king's pendant.")
            wait(2)
            self:say("It is said the sunstone captured the sun's light over 2 ages.  Now it shines with that stolen light.")
            wait(3)
            self:say("There is a dagger that the king used that does quite the opposite.")
            wait(3)
            self:say("It absorbs no light, it seems, but is made of such fine gold and gems that it radiates light.  The priests of South Caelia recognize its fierce beauty.  You will find it there still.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't the sunstone.  Find and return it.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '668d0c34ccc8f4f2ad85cd7fe6371135'),
  -- data/triggers/625/625_30_rhell_merchant_receive_3-3.lua
  (625, 30, $trig$-- Converted from DG Script #62530: Rhell Merchant receive 3-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Path 3: after the druidstaff, the merchant asks for milk
if actor:get_quest_stage("ursa_quest") == 3 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 163 and object.local_id == 5 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Oh, Golden Druidstaff!  Well, now that makes a lot of sense.")
            wait(1)
            self:say("Now we are to crush up this ring, and put the powder in milk.  Please, bring me some milk.")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I don't think this is the Golhen DrubStatt the hermit had in mind.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '1b4c9f140441e63a8a67d33f3818d8ce'),
  -- data/triggers/625/625_31_rhell_merchant_receive_4-1.lua
  (625, 31, $trig$-- Converted from DG Script #62531: Rhell Merchant receive 4-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 1, the merchant thinks he's done, but realizes he needs a pitcher to pour water over the other items.
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if object.zone_id == 85 and object.local_id == 16 then
            wait(0.2)
            actor:advance_quest("ursa_quest")
            world.destroy(object)
            wait(1)
            self:say("Excellent!  Now I have everything I need: the pepper, the plant, the staff, this spring's water...")
            wait(2)
            self:emote("stares blankly at the spring.")
            wait(3)
            self:say("So...")
            wait(1)
            self:say("I need to get the water in something functional.  Can you go get a pitcher?  That would do the job wonderfully.")
            self:command("smile " .. tostring(actor))
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This isn't the thorny wood I need.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '7a18fc2e52baa8371392b62a724136a4'),
  -- data/triggers/625/625_32_rhell_merchant_receive_4-2.lua
  (625, 32, $trig$-- Converted from DG Script #62532: Rhell Merchant receive 4-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- for path 2, the merchant asks for hard liquor - firebreather is best.
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.zone_id == 590 and object.local_id == 12 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            self:say("Fantastic.  Rylee knew it had too much power to be wielded by just anyone.  Only this dagger can end the curse inside me.")
            wait(1)
            self:say("Now, it says here that the king was placed in his sarcophagus and slew the beast inside himself.")
            wait(2)
            self:say("I'm willing to do that... but not sober.  Fetch me something to drink, and make it strong!")
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("What is this garbage?  I need the king's jeweled dagger.  Only it has the radiant power to kill the beast.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '6709a9e84deafd7f9aafe577e07eb816'),
  -- data/triggers/625/625_33_rhell_merchant_receive_4-3.lua
  (625, 33, $trig$-- Converted from DG Script #62533: Rhell Merchant receive 4-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 4 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        -- for path 3, the merchant asks for an anvil
        -- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
        if object.type == "DRINKCONTAINER" then
            if object.val2 == 10 then
                wait(0.2)
                world.destroy(object)
                actor:advance_quest("ursa_quest")
                wait(1)
                self:say("Excellent.  Now to crush this ring...")
                self:emote("drops the ring of stolen life.")
                self:emote("wields the Golden Druidstaff.")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("blink")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("grumble")
                self.room:send(tostring(self.name) .. " says, This isn't going to work.  Off the Great Road is a lumber mill.  Their smith has an anvil that will do perfectly.")
            else
                wait(0.2)
                self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
                wait(1)
                self:say("Good, now put some milk in this, and bring it to me again.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor) .. ".")
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I'm not sure how one gets milk out of this.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '13a5a2d2a33e2335712bd3ada7d9346a'),
  -- data/triggers/625/625_34_rhell_merchant_receive_5-1.lua
  (625, 34, $trig$-- Converted from DG Script #62534: Rhell Merchant receive 5-1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on good quest: either the pitcher from dancing dolphin or hot springs will work; merchant is healed and the thorny staff transforms into the redeeming staff.
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 1 then
        if (object.zone_id == 103 and object.local_id == 9) or (object.zone_id == 587 and object.local_id == 6) then
            wait(1)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(625, 50)
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This just won't work.  Really, what I need is a pitcher, so I can quickly and accurately pour a large amount of water.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '0e30efdafc1f283a08bed61a57fb2019'),
  -- data/triggers/625/625_35_rhell_merchant_receive_5-2.lua
  (625, 35, $trig$-- Converted from DG Script #62535: Rhell Merchant receive 5-2
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        -- extra step for evil path: merchant drinks and asks for a big bag - either a saddle or the tattered bag will work
        if object.type == "DRINKCONTAINER" then
            wait(1)
            self:command("drink " .. tostring(object))
            wait(1)
            if object.val2 == 7 then
                self:say("This is the good stuff!")
                actor:advance_quest("ursa_quest")
                wait(1)
                self:command("drink " .. tostring(object))
                wait(1)
                self:say("Okay...  Now I'm ready.  All I need now is something to kill myself in.")
                wait(1)
                self:emote("looks around for a makeshift sarcophagus.")
                wait(2)
                self:say("Do you have something big enough for me to fit in?  Like a big box or a bag or something?")
            else
                self:command("spit " .. tostring(actor.name))
                wait(1)
                self:say("This isn't going to cut it, kid.")
                wait(2)
                self:say("Got anything stronger?")
                self:command("give " .. tostring(object) .. " " .. tostring(actor.name))
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I'm looking for a drink.  A strong one!")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '987f274112ce3d39832ad1d9771cefc1'),
  -- data/triggers/625/625_36_rhell_merchant_receive_5-3.lua
  (625, 36, $trig$-- Converted from DG Script #62536: Rhell Merchant receive 5-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- final step on neutral quest: merchant turns into Ursa and fights!
-- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
if actor:get_quest_stage("ursa_quest") == 5 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 3 then
        if object.zone_id == 87 and object.local_id == 2 then
            wait(0.2)
            world.destroy(object)
            actor:advance_quest("ursa_quest")
            wait(1)
            run_room_trigger(625, 50)
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This won't do the job.  I need the anvil.")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, 'ae34b4e47226077dee7b0f68086c1eda'),
  -- data/triggers/625/625_37_rhell_merchant_receive_6.lua
  (625, 37, $trig$-- Converted from DG Script #62537: Rhell Merchant receive 6
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 6 then
    if (actor:get_quest_var("ursa_quest:choice") or 0) == 2 then
        if object.type == "CONTAINER" then
            wait(0.2)
            self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
            if object.val0 > 120 then
                -- The following regular items can be picked up and have large enough values: 3147, 16102, 55029
                wait(0.2)
                world.destroy(object)
                run_room_trigger(625, 50)
            else
                wait(1)
                self:command("shake")
                self:say("I don't think I can fit in here.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor))
            end
        else
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("I need a body-bag or a large chest...")
            return false  -- legacy return 0: the giver keeps the item
        end
    end
end
return _return_value$trig$, '2f2533dac01959fc518044e69c65a2af')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
