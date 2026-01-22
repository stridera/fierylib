-- Trigger: Beast_25
-- Zone: 17, ID: 95
-- Type: MOB, Flags: HIT_PERCENT
-- Status: CLEAN
--
-- Original DG Script: #1795

-- Converted from DG Script #1795: Beast_25
-- Original: MOB trigger, flags: HIT_PERCENT, probability: 25%

-- 25% chance to trigger
if not percent_chance(25) then
    return true
end
if not done25 then
    self.room:send("The ground all around begins to rustle with life...")
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
    self.room:spawn_mobile(430, 1)
    self.room:find_actor("maudlin-panther"):command("kill " .. actor.name)
end
local done25 = "yes"
globals.done25 = globals.done25 or true