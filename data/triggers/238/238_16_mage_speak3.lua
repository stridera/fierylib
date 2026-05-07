-- Trigger: mage_speak3
-- Zone: 238, ID: 16
-- Type: MOB, Flags: SPEECH
--
-- Scores the player's answer to the riddle question previously stored in
-- globals.question by 238_15_mage_receive. On a correct answer the mage
-- spawns and gifts the glowing key (238:16). On a wrong answer the Tempest
-- is respawned and the player must banish it again for another attempt.

-- Speech keywords: barbarian human half-elf half-elven halfling gnome sorcerer
-- cleric warrior rogue mercenary bugs bug dragons dragon orcs orc demons demon undead
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "barbarian")
    or string.find(speech_lower, "human")
    or string.find(speech_lower, "half-elf")
    or string.find(speech_lower, "half-elven")
    or string.find(speech_lower, "halfling")
    or string.find(speech_lower, "gnome")
    or string.find(speech_lower, "sorcerer")
    or string.find(speech_lower, "cleric")
    or string.find(speech_lower, "warrior")
    or string.find(speech_lower, "rogue")
    or string.find(speech_lower, "mercenary")
    or string.find(speech_lower, "bug")
    or string.find(speech_lower, "dragon")
    or string.find(speech_lower, "orc")
    or string.find(speech_lower, "demon")
    or string.find(speech_lower, "undead")) then
    return true  -- No matching keywords
end
if not globals.question then
    return true  -- No question pending
end
local question = globals.question
local correct = nil
if question == 1 then
    if speech_lower == "barbarian" then
        correct = "yes"
    elseif speech_lower == "human" or speech_lower == "half-elf" or speech_lower == "halfling" or speech_lower == "gnome" or speech_lower == "half-elven" then
        correct = "no"
    end
elseif question == 2 then
    if speech_lower == "human" then
        correct = "yes"
    elseif speech_lower == "barbarian" or speech_lower == "half-elf" or speech_lower == "halfling" or speech_lower == "gnome" or speech_lower == "half-elven" then
        correct = "no"
    end
elseif question == 3 then
    if speech_lower == "rogue" then
        correct = "yes"
    elseif speech_lower == "sorcerer" or speech_lower == "cleric" or speech_lower == "warrior" or speech_lower == "mercenary" then
        correct = "no"
    end
elseif question == 4 then
    if speech_lower == "orcs" or speech_lower == "orc" then
        correct = "yes"
    elseif speech_lower == "bugs" or speech_lower == "dragons" or speech_lower == "demons" or speech_lower == "undead" or speech_lower == "bug" or speech_lower == "dragon" or speech_lower == "demon" then
        correct = "no"
    end
else
    self:command("wince")
    self:say("Something is terribly wrong...please inform a god.")
    return true
end

if correct == "no" then
    globals.question = nil
    -- Respawn the Tempest and re-arm its quest state
    if world.count_mobiles(238, 3) == 0 then
        get_room(238, 90):at(function()
            self.room:spawn_mobile(238, 3)
        end)
    end
    if world.count_mobiles(238, 3) > 0 then
        get_room(238, 90):at(function()
            run_room_trigger(238, 13)
        end)
    end
    self:emote("swears profusely as the ice reforms over the symbols on the wall.")
    wait(1)
    actor:send(tostring(self.name) .. " casts a dirty look at you.")
    self.room:send_except(actor, tostring(self.name) .. " scowls angrily at " .. tostring(actor.name) .. ".")
    self:say("That was wrong!")
    wait(2)
    self:command("sigh")
    self:say("Now the Tempest is back...  We would need to banish him again for another chance.")
elseif correct == "yes" then
    globals.question = nil
    wait(1)
    self:emote("nods slowly and traces one of the signs.")
    wait(1)
    self:emote("smiles happily.")
    self:say("Excellent!  That is indeed the correct answer!")
    wait(1)
    self:command("thank " .. tostring(actor.name))
    self:say("You have helped me more than I can say.  How can I ever repay you?")
    wait(2)
    self:emote("gets a big grin on his face.")
    self.room:spawn_object(238, 16)
    self:command("give glowing-key " .. tostring(actor.name))
    self:command("drop glowing-key")
    self:command("bow " .. tostring(actor.name))
    wait(1)
    self:say("Use it wisely!")
end
