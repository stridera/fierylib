-- Trigger: dar-return
-- Zone: 238, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #23803

-- Converted from DG Script #23803: dar-return
-- Original: MOB trigger, flags: GREET, probability: 100%
if self.room ~= 23892 then
    self:command("blink")
    wait(1)
    self.room:send("&9<blue>Dargentan slowly fades out of existence and is gone.</>")
    self:teleport(get_room(238, 92))
    self.room:send("<b:white>Dargentan blinks into existence.</>")
end