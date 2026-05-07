-- Trigger: Herlequin volcano trigger 1
-- Zone: 63, ID: 91
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6391
-- Random spawn: every random tick, the volcano spits a smoke/flame
-- preamble and (depending on a 1d10) summons a herlequin warrior,
-- assassin (with dagger), mage, or nothing.
-- Note: the legacy DG script had `oecho A herlequin mage...` after a
-- `break` statement in case 6/7, making it dead code. Preserved as
-- dead code below for fidelity (the mage echo never fires in DG).

-- Converted from DG Script #6391: Herlequin volcano trigger 1
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
self.room:send("A blast of &9<blue>smoke</> and a burst of <b:red>flame</> charges into the air!")
wait(5)
self.room:send("As the smoke clears a figure appears.")
wait(5)
local val = random(1, 10)
if val >= 1 and val <= 3 then
    self.room:send("A herlequin warrior lets off a horrible screech!")
    self.room:spawn_mobile(63, 90)
elseif val == 4 or val == 5 then
    self.room:send("A herlequin assassin finds a shadow to hide in.")
elseif val == 6 or val == 7 then
    self.room:spawn_mobile(63, 93)
    -- DG `oload obj 3020` (legacy vnum 3020) -> zone 30, id 20.
    self.room:spawn_object(30, 20)
    local assassin = self.room:find_actor("assassin")
    if assassin then
        assassin:command("get dagger")
        assassin:command("wield dagger")
    end
elseif val == 8 or val == 9 then
    self.room:spawn_mobile(63, 92)
end
-- val == 10: nothing happens (default branch in DG).