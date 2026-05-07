-- Trigger: dar-return
-- Zone: 238, ID: 3
-- Type: MOB, Flags: GREET
--
-- If Dargentan is greeted anywhere other than his lair (238:92),
-- he teleports back to his lair after a brief blink.
if self.room ~= get_room(238, 92) then
    self:command("blink")
    wait(1)
    self.room:send("&9<blue>Dargentan slowly fades out of existence and is gone.</>")
    self:teleport(get_room(238, 92))
    self.room:send("<b:white>Dargentan blinks into existence.</>")
end
