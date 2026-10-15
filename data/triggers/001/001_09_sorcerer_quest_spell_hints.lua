-- Trigger: Sorcerer Quest Spell Hints
-- Zone: 1, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Rewritten by a builder in Muditor (prod, 2026-10-15) on top of the string_util
-- script library (data/script_libraries/string_util.lua). Original DG Script: #109

local string_util = require("string_util")

local function major_globe(self)
    if string_util.contains_any(self.class, { "sorcerer", "cryomancer", "pyromancer" }) then
        self:say("The battle mage Lirne was talking about developing a new spell called <b:blue>Major Globe</> to defend himself against powerful magicians.")
        self:say("Last I heard, he was going to test it out against a powerful demonic agent of chaos in the far north.")
    else
        self:say("I'm afraid Major Globe isn't a spell I know how to cast.")
    end
end

local function relocate(self)
    if string_util.contains_any(self.class, { "sorcerer", "cryomancer", "pyromancer" }) then
        self:say("A student of Bigby's in Mielikki was working on a powerful teleportation spell she called <b:magenta>Relocate</>.")
        self:say("Bigby or one of his lab assistants might know more.")
    else
        self:say("Our Guild doesn't keep records of esoteric magics exclusive to other guilds. Sorry.")
    end
end

local function charm_person(self)
    if string_util.contains_any(self.class, { "sorcerer", "illusionist" }) then
        self:say("Charming is both a magical and a personal skill. <b:magenta>Charm Person</> relies on mixing both.")
        self:say("However, those that make charming others a profession, particularly courtesans, are the best teachers.")
    else
        self:say("As charming as you are, I cannot point you in a better direction.")
    end
end

local function wizard_eye(self)
    if self.class:lower() == "sorcerer" then
        self:say("A simple but highly effective spell! The shamans of the Great Snow Leopard are particularly adept at teaching <b:cyan>Wizard Eye</> to interested scholars.")
        self:say("Seek them out to learn more.")
    else
        self:say("That is a highly exclusive sorcerer spell. I am unable to help with that.")
    end
end

local responses = {
    major = major_globe,
    globe = major_globe,
    relocate = relocate,
    charm = charm_person,
    person = charm_person,
    wizard = wizard_eye,
    eye = wizard_eye,
}
local func = string_util.match_table(speech, responses)
if func then
    wait(0.2)
    func(self)
end
return true