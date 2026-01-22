-- Trigger: Herlequin volcano trigger 1
-- Zone: 63, ID: 91
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #6391

-- Converted from DG Script #6391: Herlequin volcano trigger 1
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
self.room:send("A blast of &9<blue>smoke</> and a burst of <b:red>flame</> charges into")
-- Fragment (possible truncation): the air!
wait(5)
self.room:send("As the smoke clears a figure appears.")
wait(5)
local val = random(1, 10)
-- switch on val
if val == 1 or val == 2 or val == 3 then
    self.room:send("A herlequin warrior lets off a horrible screech!")
    self.room:spawn_mobile(63, 90)
elseif val == 4 or val == 5 then
    self.room:send("A herlequin assassin finds a shadow to hide in.")
elseif val == 6 or val == 7 then
    self.room:spawn_mobile(63, 93)
    self.room:spawn_object(30, 20)
    self.room:find_actor("assassin"):command("get dagger")
    self.room:find_actor("assassin"):command("wield dagger")
    self.room:send("A herlequin mage begins to chant a demonic mantra.")
elseif val == 8 or val == 9 then
    self.room:spawn_mobile(63, 92)
else
end