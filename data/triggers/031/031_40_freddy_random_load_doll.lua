-- Trigger: Freddy random load doll
-- Zone: 31, ID: 40
-- Type: MOB, Flags: RANDOM, SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #3140

-- Converted from DG Script #3140: Freddy random load doll
-- Original: MOB trigger, flags: RANDOM, SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: refresh
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "refresh")) then
    return true  -- No matching keywords
end
-- Generate a random number
local p = random(1, 15)
-- If this is being triggered by an imm as a speech trig, ensure something loads
if actor and actor.level > 100 then
    local p = 15
end
if p ~= 15 then
    return _return_value
end
-- Figure out which object to load.  Better chance for lower vnums.
local p = random(1, 100)
if p < 31 then
    local p = 3139 + random(1, 7)
elseif p < 82 then
    local p = 3146 + random(1, 35)
elseif p < 93 then
    local p = 3181 + random(1, 10)
else
    local p = 3191 + random(1, 7)
end
-- In case one of the randoms returned 0 somehow
if p == 3139 then
    local p = 3140 + random(1, 58)
end
-- All dolls are in zone 31
local p_zone, p_local = p // 100, p % 100
self.room:spawn_object(p_zone, p_local)
-- Special handling for certain dolls:
-- Imanhotep's sarcophagus
if p == 3182 then
    self.room:spawn_object(31, 99)
    get_room(11, 0):at(function()
        self:command("open sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("put imanhotep sarcophagus")
    end)
    get_room(11, 0):at(function()
        self:command("close sarcophagus")
    end)
    -- The Chosen boxed set
elseif p == 3198 then
    self.room:spawn_object(31, 75)
    self.room:spawn_object(31, 76)
    self.room:spawn_object(31, 77)
    self.room:spawn_object(31, 78)
    self.room:spawn_object(31, 79)
    get_room(11, 0):at(function()
        self:command("open boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("put chosen boxed-set")
    end)
    get_room(11, 0):at(function()
        self:command("close boxed-set")
    end)
end