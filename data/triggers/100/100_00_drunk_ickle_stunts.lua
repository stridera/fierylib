-- Trigger: drunk_ickle_stunts
-- Zone: 100, ID: 0
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #10000

-- Converted from DG Script #10000: drunk_ickle_stunts
-- Original: MOB trigger, flags: RANDOM, probability: 20%

-- 20% chance to trigger
if not percent_chance(20) then
    return true
end
local antic = random(1, 3)
-- switch on antic
if antic == 1 then
    self:command("shiver")
    self:emote("tries to huddle in the snow for warmth.")
    self:command("hiccup")
    self:say("Need a little nip to warm the bones...")
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