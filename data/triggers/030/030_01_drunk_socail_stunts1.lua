-- Trigger: Drunk_Socail_stunts1
-- Zone: 30, ID: 1
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #3001

-- Converted from DG Script #3001: Drunk_Socail_stunts1
-- Original: MOB trigger, flags: RANDOM, probability: 70%

-- 70% chance to trigger
if not percent_chance(70) then
    return true
end
local antic = random(1, 4)
-- switch on antic
if antic == 1 then
    self:command("sing")
    self:command("dance drunk")
    self:say("Good day to you.")
    self:command("wave")
elseif antic == 2 then
    self:command("ponder")
    self:say("I uh..")
    wait(2)
    self:say("Er wonder where I put that beeeer...")
    self:command("giggle")
elseif antic == 3 then
    self:command("sing")
    self:command("hiccup")
    self:say("I used to be a big cheese round here you know.")
    self:command("hiccup")
else
    self:command("drink drunkdrink")
    self:command("burp")
    self:emote("wipes his mouth.")
    self:say("Aaaahhhh thas the good stuff...")
end