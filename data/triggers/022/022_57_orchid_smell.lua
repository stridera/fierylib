-- Trigger: Orchid_Smell
-- Zone: 22, ID: 57
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2257

-- Converted from DG Script #2257: Orchid_Smell
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: smell
if not (cmd == "smell") then
    return true  -- Not our command
end
actor:send("You reach down and smell the <b:blue>blue orchid</>, which gives off a <b:cyan>delictable</> scent.")
self.room:send_except(actor, tostring(actor.name) .. " smells a <b:blue>blue orchid</>, which sends the scent all through the room.")
wait(5)
self.room:send("The <b:magenta>scent</> from the <b:blue>blue orchid</> permeates through the area.")
wait(5)
self.room:send("For a moment, you a struck with a soothing <b:cyan>clairity</> and <b:white>calm</>.")
wait(5)
self.room:send("A strange <b:white>vision</> prevades your <b:yellow>moment</> of <b:green>enlightenment</>...")
wait(5)
self.room:send("In a land where <b:blue>liquid</> is rare and <b:red>warriors</> master thier skills well.")
self.room:send("Seek out the <b:white>hidden woman</>, but beware your imminent <b:yellow>imprisonment</>.")