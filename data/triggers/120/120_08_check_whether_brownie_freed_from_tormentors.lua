-- Trigger: Check whether brownie freed from tormentors
-- Zone: 120, ID: 8
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #12008

-- Converted from DG Script #12008: Check whether brownie freed from tormentors
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(3)
local brownie = self.room:find_actor("haggard-brownie")
local tormentor = self.room:find_actor("dark-pixie-tormentor")
if brownie and not tormentor then
    -- The pixies are dead and the haggard brownie can be rescued.
    wait(8)
    brownie:say("Thank goodness!  You've killed them!")
    wait(3)
    brownie:say("I must return home... but there will be others...")
    wait(3)
    brownie:say("Please friend, help me!  If you can take me home, my family")
    brownie:say("will surely reward you!  And if you will do this thing, just")
    brownie:say("say 'I will escort you' and I will follow.")
end