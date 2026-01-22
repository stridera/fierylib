-- Trigger: mccabe dialog
-- Zone: 482, ID: 56
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Large script: 8236 chars
--
-- Original DG Script: #48256

-- Converted from DG Script #48256: mccabe dialog
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: meteor meteors meteors? meteorswarm yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "meteor") or string.find(string.lower(speech), "meteors") or string.find(string.lower(speech), "meteors?") or string.find(string.lower(speech), "meteorswarm") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
-- **McCabes Speech Trigger***
-- This trigger represents the launching point, ending point, and intersection of the 3 parts of the meteor quest.
-- stage 1 deals with finding Jemnon
-- stage 2 is getting a mastery of earth, and ends back here.
-- stage 3 sends the quester off to the fire temple high priest, and ends back here.
-- stage 4 sends the quester to dargentans lair to master air, which then ends back here.
-- stage 5 means the player has mastered all 3 elements, combined them into an item, and can now cast a meteorswarm with that item.
-- the quest is actually completed by the item itself, when the player casts its one and only charge of meteorswarm.
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
if (string.find(actor.class, "sorcerer") or string.find(actor.class, "pyromancer")) and actor.level > 72 then
    if not stage and (string.find(speech, "meteor") or string.find(speech, "meteors") or string.find(speech, "meteors?") or string.find(speech, "no")) then
        actor:send(tostring(self.name) .. " tells you, 'Yes, they are the culmination of my life's work.  They are the perfect balance of earth, fire, and air.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Now leave me to my fun.  I have a seagull to obliterate.'")
        wait(3)
        actor:send(tostring(self.name) .. " tells you, 'If you like, you may stand by and observe.'")
        wait(3)
        self.room:send(tostring(self.name) .. " starts casting '<b:yellow>celneptin</>'...")
        wait(2)
        run_room_trigger(48257)
        wait(3)
        self:command("sigh")
        actor:send(tostring(self.name) .. " tells you, 'I suppose you wish to do more than observe, am I right?  " .. tostring(actor.name) .. ", would you like to try to learn this rather difficult spell?'")
    elseif string.find(speech, "yes") then
        if actor:get_quest_var("meteorswarm:new") ~= "no" then
            self:say("Show me the meteorite.")
        elseif not stage then
            actor.name:start_quest("meteorswarm")
            actor:send(tostring(self.name) .. " tells you, 'Yes, well first you need a powerful piece of earth.  Not just any rock will do.  It needs to be positively alive with great energy.'")
            wait(2)
            self:command("consider " .. tostring(actor))
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'I doubt that you would be able to summon such earth yourself...  At least, not until you have mastered the element.'")
            wait(5)
            self:command("ponder")
            wait(4)
            actor:send(tostring(self.name) .. " tells you, 'There was once a powerful mage that created a massive guardian of stone to bar the way into the Nine Hells.  Such a creature would be a perfect source of powerfully imbued earth.'")
            self:command("dream")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'Unfortunately, I do not know where the location of that entry is.  But I know someone who might.'")
            wait(1)
            self:command("grumble")
            wait(5)
            actor:send(tostring(self.name) .. " tells you, 'There's a drunken lout, goes by the name Jemnon the Lionhearted.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'His exploits are as idiotic as the greatest heroes are brave.  While he causes far more problems than he solves, he has stumbled upon more secret knowledge than I care to admit.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'He may very well know the location of this rocky behemoth.'")
            wait(5)
            actor:send(tostring(self.name) .. " tells you, 'Your first challenge will be <b:cyan>locating Jemnon</>.  He's almost certainly drinking himself stupid in a <b:cyan>bar</> or <b:cyan>tavern</> somewhere.  If you do find him, you'll have to <b:cyan>ask him about the rock monster</>.'")
            -- switch on random(1, 13)
            if random(1, 13) == 1 then
                -- Tavern of the Fallen Star in Southern Borderhold
                local bar_num = 2334
            elseif random(1, 13) == 2 then
                -- Sloshed Squirrel in Mielikki
                local bar_num = 3033
            elseif random(1, 13) == 3 then
                -- Forest Tavern in Mielikki
                local bar_num = 3053
            elseif random(1, 13) == 4 then
                -- Ole Witch Tavern in Anduin
                local bar_num = 6037
            elseif random(1, 13) == 5 then
                -- Phillips Backdoor Bar in Anduin
                local bar_num = 6044
            elseif random(1, 13) == 6 then
                -- Red Feathered Nest Anduin
                local bar_num = 6054
            elseif random(1, 13) == 7 then
                -- Shawns Tavern in Anduin
                local bar_num = 6112
            elseif random(1, 13) == 8 then
                -- Drunken Ogre Inn in Anduin
                local bar_num = 6131
            elseif random(1, 13) == 9 then
                -- Golden Goblet Inn and Tavern in Anduin
                local bar_num = 6226
            elseif random(1, 13) == 10 then
                -- Karrs Pub in Ickle
                local bar_num = 10029
            elseif random(1, 13) == 11 then
                -- Mermaid's Tail in Ogakh
                local bar_num = 30008
            elseif random(1, 13) == 12 then
                -- Biergarten in Ogakh
                local bar_num = 30089
            else
                -- Flirting Puppy
                local bar_vnum = 51045
            end
            actor.name:set_quest_var("meteorswarm", "bar_num", bar_num)
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You can check on your <b:cyan>[spell progress]</> with me at any time.'")
        elseif stage == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Magnificent!  Bring back a piece of it as a magical focus and I can continue teaching you this spell.'")
        elseif stage == 3 then
            actor:send(tostring(self.name) .. " tells you, 'Splendid!  May I see it?'")
            wait(2)
        elseif stage == 4 then
            actor:set_quest_var("meteorswarm", "fire", 2)
            actor:send(tostring(self.name) .. " tells you, 'The last element you must master is the sky itself.  But this must be no mere demonstration of the power of flight, or even a large gust of wind.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'No, in order to understand the sheer magnitude of energy involved, you will need to learn from a true master of air.'")
            wait(3)
            actor:send(tostring(self.name) .. " tells you, 'But who would be most appropriate...?'")
            self:command("think")
            wait(4)
            actor:send(tostring(self.name) .. " tells you, 'Wait, I've got it!  It's a long shot...'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'But...'")
            wait(1)
            actor:send(tostring(self.name) .. " tells you, 'You should <b:cyan>meet with the dragon who created the floating fortress in southern Caelia</>.'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Ask him to teach you.  And be certain to show him the proper respect when you do!'")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'Good luck!  You'll need it...'")
        elseif stage == 5 then
            actor:send(tostring(self.name) .. " tells you, 'Let me check the meteorite.'")
        end
    end
end