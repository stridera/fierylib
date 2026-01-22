-- Trigger: moonwell_quest_status_checker
-- Zone: 163, ID: 50
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16350

-- Converted from DG Script #16350: moonwell_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("moonwell_spell_quest") then
    self:say("I have already taught you to travel through moonwells.")
    return _return_value
end
local stage = actor:get_quest_stage("moonwell_spell_quest")
-- switch on stage
if stage == 1 or stage == 2 then
    -- Vine of Mielikki
    local item = 16350
    local place = "an island of lava and fire."
elseif stage == 3 then
    -- The Heartstone
    local item = 48024
    local place = "an ancient burial site far to the north"
elseif stage == 4 then
    -- Flask of Eleweiss
    local item = 16356
    local place = "the cult of the ice dragon"
elseif stage == 5 then
    -- Flask of Eleweiss
    local item = 16356
    local place = "the cult of the ice dragon"
elseif stage == 6 then
    -- Glittering ruby ring
    local item = 5201
    local place = "a temple dedicated to fire"
elseif stage == 7 then
    -- Orb of Winds
    local item = 16006
    local place = "a dark fortress to the east"
elseif stage == 8 then
    -- update map
    self:say("Please give me your map to update.")
    return _return_value
elseif stage == 9 then
    -- Jade ring
    local item = 49011
    local place = "a wood nymph on an island of our brothers beset by beasts"
elseif stage == 10 then
    -- Chaos Orb
    local item = 4003
    local place = "a great dragon hidden in a hellish labyrinth"
elseif stage == 11 then
    -- Granite Ring
    local item = 55020
    local place = "a large temple hidden in a mountain"
elseif stage == 12 then
    -- update diagram
    self:say("Please give me your map to make the final markings.")
    return _return_value
else
    self:say("You haven't agreed to help me yet.")
    return _return_value
end
self:say("We need:")
self.room:send("</>" .. "%get.obj_shortdesc[%item%]% from")
self.room:send("</>" .. tostring(place) .. ".")
if stage > 6 then
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you need a new map, say \"<b:green>I lost my map</>\".'")
end