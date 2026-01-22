-- Trigger: instant reboot
-- Zone: 0, ID: 25
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #25

-- Converted from DG Script #25: instant reboot
-- Original: WORLD trigger, flags: SPEECH, probability: 0%
-- NOTE: This trigger is disabled (0% chance) - likely a test trigger

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: reboot now
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "reboot") or string.find(speech_lower, "now")) then
    return true  -- No matching keywords
end
-- Original code tried to access people.3054 and people.51036 which is invalid Lua syntax
-- These appear to be mob vnums - use mobiles.find_by_vnum() if needed
local mob1 = self.room:find_actor_by_vnum(30, 54)
local mob2 = self.room:find_actor_by_vnum(510, 36)
if mob1 then
    self.room:send(tostring(mob1.name))
end
if mob2 then
    self.room:send(tostring(mob2.name))
end