-- Trigger: mage_speak3
-- Zone: 238, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #23816

-- Converted from DG Script #23816: mage_speak3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: barbarian human half-elf half-elven halfling gnome sorcerer cleric warrior rogue mercenary bugs bug dragons dragon orcs orc demons demon undead
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "barbarian") or string.find(string.lower(speech), "human") or string.find(string.lower(speech), "half-elf") or string.find(string.lower(speech), "half-elven") or string.find(string.lower(speech), "halfling") or string.find(string.lower(speech), "gnome") or string.find(string.lower(speech), "sorcerer") or string.find(string.lower(speech), "cleric") or string.find(string.lower(speech), "warrior") or string.find(string.lower(speech), "rogue") or string.find(string.lower(speech), "mercenary") or string.find(string.lower(speech), "bugs") or string.find(string.lower(speech), "bug") or string.find(string.lower(speech), "dragons") or string.find(string.lower(speech), "dragon") or string.find(string.lower(speech), "orcs") or string.find(string.lower(speech), "orc") or string.find(string.lower(speech), "demons") or string.find(string.lower(speech), "demon") or string.find(string.lower(speech), "undead")) then
    return true  -- No matching keywords
end
local halfelf = "half-elf"
local halfelven = "half-elven"
if question then
    if question == 1 then
        if speech == "barbarian" then
            local correct = "yes"
        elseif speech == "human" or speech == "halfelf" or speech == "halfling" or speech == "gnome" or speech == "halfelven" then
            local correct = "no"
        end
    elseif question == 2 then
        if speech == "human" then
            local correct = "yes"
        elseif speech == "barbarian" or speech == "halfelf" or speech == "halfling" or speech == "gnome" or speech == "halfelven" then
            local correct = "no"
        end
    elseif question == 3 then
        if speech == "rogue" then
            local correct = "yes"
        elseif speech == "sorcerer" or speech == "cleric" or speech == "warrior" or speech == "mercenary" then
            local correct = "no"
        end
    elseif question == 4 then
        if speech == "orcs" or speech == "orc" then
            local correct = "yes"
        elseif speech == "bugs" or speech == "dragons" or speech == "demons" or speech == "undead" or speech == "bug" or speech == "dragon" or speech == "demon" then
            local correct = "no"
        end
    else
        self:command("wince")
        self:say("Something is terribly wrong...please inform a god.")
    end
    if correct == "no" then
        local question = 0
        if world.count_mobiles("23803") == 0 then
            get_room(238, 90):at(function()
                self.room:spawn_mobile(238, 3)
            end)
        end
        if world.count_mobiles("23803") > 0 then
            get_room(238, 90):at(function()
                run_room_trigger(23813)
            end)
        end
        globals.question = globals.question or true
        self:emote("swears profusely as the ice reforms over the symbols on the wall.")
        wait(1)
        actor:send(tostring(self.name) .. " casts a dirty look at you.")
        self.room:send_except(actor, tostring(self.name) .. " scowls angrily at " .. tostring(actor.name) .. ".")
        self:say("That was wrong!")
        wait(2)
        self:command("sigh")
        self:say("Now the Tempest is back...  We would need to banish him again for another chance.")
    elseif correct == "yes" then
        local question = 0
        globals.question = globals.question or true
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
end