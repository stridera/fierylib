-- Trigger: Wise leprechaun random babbling
-- Zone: 615, ID: 22
-- Type: MOB, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #61522

-- Converted from DG Script #61522: Wise leprechaun random babbling
-- Original: MOB trigger, flags: RANDOM, probability: 40%

-- 40% chance to trigger
if not percent_chance(40) then
    return true
end
local val = random(1, 5)
-- switch on val
if val == 1 then
    self:say("I sure could use some fruit... mmmhmm, yep.")
elseif val == 2 or val == 3 then
    self:say("I don't suppose you whippersnappers are having any trouble with spiders, eh?")
elseif val == 4 then
    self:say("Golblasted fairies, always zipping around your head squeaking.")
    self:say("It's enough to drive you crazy!")
end