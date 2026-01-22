-- Trigger: elder_woman_speak1
-- Zone: 481, ID: 41
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48141

-- Converted from DG Script #48141: elder_woman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: spell spell? help help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "spell?") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
wait(2)
local stage = 2
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == "stage" then
            person.name:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            local ash = 1
        elseif person:get_quest_stage("fieryisle_quest") == 3 or person:get_quest_stage("fieryisle_quest") == 4 then
            local ash = 2
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
if ash == 1 then
    self.room:send(tostring(self.name) .. " says, 'If you want me to help you, then you must do me a favor.  Kill the ash lord and bring me his crown.'")
    if world.count_mobiles("48107") < 1 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(481, 7)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):spawn_object(481, 24)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):command("wear crown")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):teleport(get_room(481, 57))
        end)
    end
elseif ash == 2 then
    self:say("Bring me the ash lord's crown first.")
else
    self:say("I have no idea what you are talking about.")
    self:command("eye " .. tostring(actor.name))
end