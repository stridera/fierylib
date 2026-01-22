-- Trigger: banish_murgbol_greet
-- Zone: 302, ID: 12
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Large script: 6154 chars
--
-- Original DG Script: #30212

-- Converted from DG Script #30212: banish_murgbol_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("banish")
wait(4)
if string.find(actor.class, "priest") or string.find(actor.class, "diabolist") then
    if actor:get_quest_var("banish:greet") == 0 then
        if stage == 0 then
            self:say("Wanna learn some spells kid?")
            -- (empty room echo)
            self.room:send(tostring(self.name) .. " says, 'I can teach you to hurl your enemies far into the outer planes")
            self.room:send("</>so they can never bother you again.'")
        else
            if stage == 2 then
                self.room:send(tostring(self.name) .. " says, 'I can already tell you have made progress along your journey.")
                self.room:send("</>Let's keep going!'")
                wait(1)
                self:emote("closes her eyes and prays for further guidance.")
                wait(3)
                self:say("Yes, I see...")
                self:emote("nods.  'Quite challenging...'")
                wait(1)
                self:emote("opens her eyes.")
                wait(2)
                self:say("The gods wish to test your sway over the elemental forces.")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'Ice elementals wander deep in the frozen tunnels near the nest")
                self.room:send("</>of a mighty dragon.  Destroy the <b:cyan>most powerful of these elementals</> to receive")
                self.room:send("</>your next vision, then return to me.'")
            elseif stage == 3 then
                self.room:send(tostring(self.name) .. " says, 'It seems you've managed to destroy the ice elemental lord.")
                self.room:send("</>Let's press on!'")
                wait(1)
                self:emote("closes her eyes and prays for further guidance.")
                wait(3)
                self:say("Yes, most appropriate.")
                wait(1)
                self:emote("opens her eyes.")
                wait(2)
                self:say("The gods demand a sacrifice of life energy.")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'A powerful <b:magenta>troll wizard</> warps the tunnels of an ancient mine.")
                self.room:send("</>His blood will most please the gods.  After this is done, return to me.'")
            elseif stage == 4 then
                self.room:send(tostring(self.name) .. " says, 'The gods are greatly pleased with your sacrifice.")
                self.room:send("</>Let's continue!'")
                wait(1)
                self:emote("closes her eyes and prays for further guidance.")
                wait(3)
                self:say("Naturally, such a thing must be done.")
                wait(1)
                self:emote("opens her eyes.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Since you've dispatched something living, it's time to banish")
                self.room:send("</>something lingering after death.'")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'In a room of art in an ancient burial site waits a <magenta>long-dead</>")
                self.room:send("</><magenta>apparition</>.  Its threads to this world are tenuous at best.  Send it to the")
                self.room:send("</>next world to receive the next part of the prayer.  Afterward, come back and")
                self.room:send("</>we shall continue.'")
            elseif stage == 5 then
                self.room:send(tostring(self.name) .. " says, 'Your awareness continues to grow.")
                self.room:send("</>Let's keep moving!'")
                wait(1)
                self:emote("closes her eyes and prays for further guidance.")
                wait(3)
                self:say("Certainly, as you wish...")
                wait(1)
                self:emote("opens her eyes.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'The gods of light will have you undertake the next step and")
                self.room:send("</>prove mastery over demonic energy.'")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'Far to the north in Frost Valley, there is a &9<blue>demon corrupting</>")
                self.room:send("</>&9<blue>the world around it</> through its very presence.  Exorcise it from Ethilien and")
                self.room:send("</>receive the reward of the gods, then return here.'")
            elseif stage == 6 then
                self.room:send(tostring(self.name) .. " says, 'The gods of light are satisfied.")
                self.room:send("Let's see the final test!'")
                wait(1)
                self:emote("closes her eyes and prays for further guidance.")
                wait(3)
                self:command("grin")
                self:say("Delightful choice.")
                wait(1)
                self:emote("opens her eyes.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Destroying celestial energy for the dark gods shall be your")
                self.room:send("</>final task.'")
                wait(1)
                self.room:send(tostring(self.name) .. " says, 'Many celestial beings have made their home in a floating")
                self.room:send("</>crystal fortress on South Caelia.  One in particular, a <b:white>six-winged seraph</>,")
                self.room:send("</>stands sentinel over the uppermost floors.  Banish it from Ethilien and the")
                self.room:send("</>gods will reward you with the final part of the prayer.  Return to me after,")
                self.room:send("</>and I shall help you perform it.")
            elseif stage == 7 then
                self:say("I see you have been successful!")
                wait(1)
                self:say("Now, speak aloud the mystic word your visions revealed!")
            end
            actor:set_quest_var("banish", "greet", 1)
        end
    end
end