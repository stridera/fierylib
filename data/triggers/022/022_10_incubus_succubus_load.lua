-- Trigger: Incubus_Succubus_Load
-- Zone: 22, ID: 10
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #2210

-- Converted from DG Script #2210: Incubus_Succubus_Load
-- Original: MOB trigger, flags: GREET, probability: 100%
if not done then
    wait(2)
    self:say("So you wish to play do you?")
    wait(2)
    self:command("cackle")
    wait(2)
    self.room:spawn_mobile(22, 11)
    self.room:spawn_mobile(22, 11)
    self.room:spawn_mobile(22, 11)
    self.room:spawn_mobile(22, 11)
    self.room:send("Sounds of screetching can be heard from all around as mounds of cloth fly in from all directions.")
    local done = 1
    globals.done = globals.done or true
else
    wait(2)
    self:say("Back again are you?!")
    self:command("growl")
end