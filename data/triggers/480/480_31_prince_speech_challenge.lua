-- Trigger: Prince speech challenge
-- Zone: 480, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48031

-- Converted from DG Script #48031: Prince speech challenge
-- Original: MOB trigger, flags: SPEECH, probability: 0%
-- Note: original DG probability was 0%; the trigger fires only on the exact
-- proxy-challenge phrase and is intentionally not gated by random chance.

-- Speech keywords: full phrase "the champion wishes to challenge you by proxy"
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "the champion wishes to challenge you by proxy", 1, true) then
    return true  -- No matching keywords
end
self.room:send(tostring(self.name) .. " shutters at the challenge.")
globals.drop_head = 1
if actor.level > 70 then
    self:say("You look like a true threat.  But do not wonder, I have grown greatly since my death.")
else
    self:say("A shame he sends one still so inexperienced.  However, this should put the result beyond doubt.")
end
if world.count_mobiles(480, 12) < 2 then
    local needed = 2 - world.count_mobiles(480, 12)
    self.room:send(tostring(self.name) .. " calls out the spirits of his Royal Guard!")
    local loop = 0
    while loop < needed do
        self.room:send(tostring(self.name) .. " summons " .. tostring(mobiles.template(480, 12).name) .. "!")
        self.room:spawn_mobile(480, 12)
        loop = loop + 1
    end
end
if not self:has_equipped(480, 3) then
    self.room:send(tostring(self.name) .. " lifts " .. tostring(objects.template(480, 3).name) .. " from the chamber floor.")
    self.room:spawn_object(480, 3)
    self:command("wie indigo-blade")
end
if not self:has_equipped(480, 10) then
    self.room:send(tostring(self.name) .. " lifts " .. tostring(objects.template(480, 10).name) .. " from the chamber floor.")
    self.room:spawn_object(480, 10)
    self:command("wear breastplate")
end
self:say("En garde!")
wait(1)
combat.engage(actor)