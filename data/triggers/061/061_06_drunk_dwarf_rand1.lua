-- Trigger: drunk_dwarf_rand1
-- Zone: 61, ID: 6
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6106

-- Converted from DG Script #6106: drunk_dwarf_rand1
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
local antic = random(1, 3)
-- switch on antic
if antic == 1 then
    self:emote("whistles tunelessly to himself.")
    self:say("Another day of drinking for me please.")
    self:command("hiccup")
    self:command("hiccup")
elseif antic == 2 then
    self:command("glare")
    self:say("What are you looking at?")
    self:emote("puts up his fists.")
    self:say("Do you want some?  Do ya?")
    self:command("fart")
else
    self:command("drink drunkdrink")
    self:command("burp")
    self:emote("wipes his mouth.")
    self:say("Aaaahhhh thas the good stuff...")
end