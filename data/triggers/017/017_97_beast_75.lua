-- Trigger: Beast_75
-- Zone: 17, ID: 97
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1797

-- Converted from DG Script #1797: Beast_75
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 75%

-- 75% chance to trigger
if not percent_chance(75) then
    return true
end
if not done75 then
    self.room:send(tostring(self) .. " screeches as its face contorts in pain!")
    self.room:send("The despicable beast of the realm come to its assistance!")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
    self.room:spawn_mobile(160, 9)
    self.room:find_actor("demon"):command("kill %actor.name%")
end
local done75 = "yes"
globals.done75 = globals.done75 or true