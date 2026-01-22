-- Trigger: dwarven_exit_load
-- Zone: 16, ID: 86
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1686

-- Converted from DG Script #1686: dwarven_exit_load
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
if string.find(speech, "yes") then
    self:say("Excellent, come with me then!  I know another way out!")
    wait(2)
    self:emote("cautiously moves toward the back of the cell.")
    wait(3)
    self.room:send("A haggard dwarf scratches at some rocks in the wall.")
    run_room_trigger(1685)
end
if string.find(speech, "no") then
    self:say("Then you are not friend to us!")
    combat.engage(self, actor.name)
end