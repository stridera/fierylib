-- Trigger: Prince speech challenge
-- Zone: 480, ID: 31
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #48031

-- Converted from DG Script #48031: Prince speech challenge
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: the champion wishes to challenge you by proxy
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "the") or string.find(string.lower(speech), "champion") or string.find(string.lower(speech), "wishes") or string.find(string.lower(speech), "to") or string.find(string.lower(speech), "challenge") or string.find(string.lower(speech), "you") or string.find(string.lower(speech), "by") or string.find(string.lower(speech), "proxy")) then
    return true  -- No matching keywords
end
self.room:send(tostring(self.name) .. " shutters at the challenge.")
local drop_head = 1
globals.drop_head = globals.drop_head or true
if actor.level > 70 then
    self:say("You look like a true threat.  But do not wonder, I have grown greatly since my death.")
else
    self:say("A shame he sends one still so inexperienced.  However, this should put the result beyond doubt.")
end
if world.count_mobiles("48012") < 2 then
    local needed = 2 - world.count_mobiles("48012")
    self.room:send(tostring(self.name) .. " calls out the spirits of his Royal Guard!")
    local loop = 0
    while loop < needed do
        self.room:send(tostring(self.name) .. " summons " .. tostring(mobiles.template(480, 12).name) .. "!")
        self.room:spawn_mobile(480, 12)
        local loop = loop + 1
    end
end
if not self:has_equipped("48003") then
    self.room:send(tostring(self.name) .. " lifts " .. tostring(objects.template(480, 3).name) .. " from the chamber floor.")
    self.room:spawn_object(480, 3)
    self:command("wie indigo-blade")
end
if not self:has_equipped("48010") then
    self.room:send(tostring(self.name) .. " lifts " .. tostring(objects.template(480, 10).name) .. " from the chamber floor.")
    self.room:spawn_object(480, 10)
    self:command("wear breastplate")
end
self:say("En garde!")
wait(1)
combat.engage(self, actor)