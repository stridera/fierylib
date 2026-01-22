-- Trigger: guardian_of_book
-- Zone: 510, ID: 9
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #51009

-- Converted from DG Script #51009: guardian_of_book
-- Original: OBJECT trigger, flags: GET, probability: 100%
if actor.room >= 51000 and actor.room <= 51099 and alreadyrun ~= 1 then
    self.room:spawn_mobile(510, 25)
    self.room:find_actor("guardian"):say("You are not worthy to handle the book of Nordus!")
    local alreadyrun = 1
    globals.alreadyrun = globals.alreadyrun or true
    self.room:find_actor("guardian"):command("hit %actor.name%")
end