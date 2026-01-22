-- Trigger: Elemental Chaos Hakujo speech mission
-- Zone: 53, ID: 36
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--   Large script: 12742 chars
--
-- Original DG Script: #5336

-- Converted from DG Script #5336: Elemental Chaos Hakujo speech mission
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: news update updates mission
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "news") or string.find(string.lower(speech), "update") or string.find(string.lower(speech), "updates") or string.find(string.lower(speech), "mission")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("elemental_chaos") then
    actor:send(tostring(self.name) .. " says, 'We're still analyzing the information you brought us on your last mission.  Check back later.'")
elseif not actor:get_quest_stage("elemental_chaos") or (actor:get_quest_stage("elemental_chaos") == 1 and not actor:get_quest_var("elemental_chaos:bounty")) then
    actor:send(tostring(self.name) .. " says, 'Yes, something that will help bring Balance to the world.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Those who follow the Way seek to preserve Harmony through universal Balance.  We are the anathema of Chaos.  When unnatural forces rise in unlikely places, we follow the Way to restore Balance.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Recently, I have heard rumor a reliable warrior commander in the far north has made an alliance with a strange bedfellow - a necromancer who trafficks with minor demons, commonly called imps.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Please go north and investigate.  The compound sits just outside of the town of Ickle.  If you discover any creatures like these, dispose of them.'")
    wait(4)
    if actor.level < 20 then
        actor:send(tostring(self.name) .. " says, 'Getting to Ickle from Mielikki by foot is extremely dangerous for new adventurers.  You may want to purchase a blue scroll of recall from Bigby's Magic Shoppe to take you there safely.'")
        wait(4)
    end
    actor:send(tostring(self.name) .. " says, 'Can I count on you to get this done?'")
elseif actor:get_quest_var("elemental_chaos:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current mission first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("elemental_chaos") - 1) * 10 then
        -- switch on actor:get_quest_stage("elemental_chaos")
        if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            if actor:get_quest_stage("elemental_chaos") == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to complete.  Investigate the news of an imp and dispatch it if you find one.'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Silence the seductive song of the Leading Player.'")
            else
                actor:send(tostring(self.name) .. " says, 'I'm still analyzing the information you gleaned about from Thraja's Ice Warrior Compound, but I've identified a second source of chaos right in the heart of civilization.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'In Anduin is a suspicious theatre company, preparing for some ominous event.  Exactly what it is I do not know, but the are whispers they seek to bring death and destruction to their unwitting spectators!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I believe if you silence their leader, the troupe will fall apart.  Will you do this?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy the Chaos and the cult worshipping it!'")
            else
                actor:send(tostring(self.name) .. " says, 'I've discovered something concerning in what you found in the Ice Warrior Compound.  It seems the necromancer she allied herself with was a missionary of a more sinister cult, one dedicated to the worship of Chaos itself!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'My sources say they've erected a temple near the Gothra Desert, where they have managed to pull a manifestation of Chaos itself into our world!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'If this is true, they need to be stopped immediately lest Balance be forever altered.  Are you willing to help?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Undertake the vision quest from the shaman in Three-Falls Canyon and defeat whatever awaits at the end.'")
            else
                actor:send(tostring(self.name) .. " says, 'You have done well so far, but I sense something sinister growing in the heart of the world.  Something malevolent...  Whatever it is, it seems to have entangled all of our fates.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Undertake the vision quest of the shaman in Three-Falls Canyon.  It may reveal what is pulling at the strings of fate.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Are you willing to do this?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Dispatch the Fangs of Yeenoghu.  Be sure to destroy all of them.'")
            else
                actor:send(tostring(self.name) .. " says, 'From what you have seen in your vision, it seems the chaos in the world is a symptom of demonic energy gnawing at the Wheel of Ages.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'My own meditations have revealed several places where the fabric of reality is quickly unraveling due to their influence.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Of immediate concern is a den of filth-ridden animal abominations called gnolls in Nukreth Spire in South Caelia.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'These creatures are the progeny of the demon lord Yeenoghu.  Their spiritual connection is maintained by a triumverant of gnolls known as his \"Fangs.\"  Destroying them will certainly weaken the demonic chaos they spread.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you brave enough to take them on?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Extinguish the fire elemental lord who serves Krisenna.'")
            else
                actor:send(tostring(self.name) .. " says, 'With Yeenoghu crippled, other demon lords are putting their own plans into play.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Something is stirring within the tower in the wastelands West of the Black Rock Trail.  It appears there was once a gateway to another world there, but it has long since collapsed.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Something on the other side though seeks to return, a creature heralding the chaos and destruction of fire itself.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'What do you think?  Can you get to the bottom of this?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Stop the acolytes in the Cathedral of Betrayal.'")
            else
                actor:send(tostring(self.name) .. " says, 'I have avoided thus far sending you after the more powerful and entrenched orders dedicated to the dark forces.  Unfortunately I cannot delay any longer.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'It appears the diabolists who call the Cathedral of Betrayal their home are taking advantage of the disturbances across the world and using it to fuel their own dark purposes.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You can cripple their efforts if you kill the acolytes who prepare their altar.  It won't be a permanent solution but it will weaken them significantly.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Will you harry them?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Destroy Cyprianum the Reaper in the heart of his maze.'")
            else
                actor:send(tostring(self.name) .. " says, 'Thanks to you I've discovered the Cathedral was involved in a plot to summon forth a catastrophic force.  Unfortunately I'm unsure if they sought to create a new disaster or make an existing one worse.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'The greatest source of Chaos in Ethilian is a keep long ago overwhelmed by demonic forces.  Formerly the home of Seblan the Young, it is now his prison, ruled by Cyprianum the Reaper.  Cyprianum has warped the fortress into a maze, filled with soul-consuming beasts and mechanical abominations.  I believe this is what the Cathedral was attempting to bolster.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Cyprianum waits, surrounded by his disciples at the heart of the maze.  Destroy him and bring Balance back to the keep.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Can you do this?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Banish the Chaos Demon in Frost Valley.'")
            else
                actor:send(tostring(self.name) .. " says, 'I was wrong!  The Cathedral wasn't trying to help Cyprianum - they were summoning a terrifying Chaos Demon!'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Even though you stopped their efforts, the damage was done.  They took advantage of the remnant energy from the Time Cataclysm and loosed the demon on Frost Valley.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Please, will you put a stop to the demon's rampage?'")
            end
            if actor:get_quest_var("elemental_chaos:bounty") == "running" then
            elseif actor:get_quest_stage("elemental_chaos") == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a mission to accomplish.  Slay one of the Norhamen.'")
            else
                actor:send(tostring(self.name) .. " says, 'Having driven the Chaos Demon back beyond the veil, I can sense at last the source of all this Chaos.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'A pair of terrifying demon beasts called the Norhamen lurk deep in the remains of a fallen kingdom.  Long forgotten by time, the ruins have been warped and twisted into a hellish labyrinth of fallen angels and walking nightmares.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Help us restore Harmony.  Will you slay one of the Norhamen?'")
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'Give me more time to strategize how to bring Balance to Chaos.  Come back after you've gained some more experience.'")
    end
end