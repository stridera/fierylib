-- Trigger: Dark pixies ambush
-- Zone: 120, ID: 13
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12013

-- Converted from DG Script #12013: Dark pixies ambush
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
--
-- When the haggard brownie (mob 120-19) enters one of the ambush rooms, drop
-- a bait item in room 120-50 (the staging room) so the ambushers chase.
if actor.zone_id == 120 and actor.local_id == 19 then
    wait(1)
    local brownie = self.room:find_actor("haggard-brownie")
    if not brownie then return true end
    brownie:follow(self)
    wait(3)
    if self.id == 12030 then
        brownie:spawn_object(120, 1)
        brownie:command("mat 12050 drop passionfruit")
    else
        brownie:spawn_object(120, 2)
        brownie:command("mat 12050 drop meat-pie")
    end
    self.room:send("&9<blue>Dark shadows</> move swiftly toward the haggard brownie.")
end