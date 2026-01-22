-- Trigger: Dark pixies ambush
-- Zone: 120, ID: 13
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #12013

-- Converted from DG Script #12013: Dark pixies ambush
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor.id == 12019 then
    wait(1)
    self.room:find_actor("haggard-brownie"):follow(self.room:find_actor("me"))
    wait(3)
    if self.id == 12030 then
        self.room:find_actor("haggard-brownie"):spawn_object(120, 1)
        self.room:find_actor("haggard-brownie"):command("mat 12050 drop passionfruit")
    else
        self.room:find_actor("haggard-brownie"):spawn_object(120, 2)
        self.room:find_actor("haggard-brownie"):command("mat 12050 drop meat-pie")
    end
    self.room:send("&9<blue>Dark shadows</> move swiftly toward the haggard brownie.")
end