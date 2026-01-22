-- Trigger: relocate_spell_quest_status_checker
-- Zone: 492, ID: 58
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49258

-- Converted from DG Script #49258: relocate_spell_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("relocate_spell_quest")
wait(1)
if actor:get_has_completed("relocate_spell_quest") then
    self:say("I've already taught you my greatest spell.")
    return _return_value
end
-- switch on stage
if stage == 1 or stage == 2 then
    local next = "the Staff of the Mystics"
    local place = "a druid past the Vale of Anlun"
elseif stage == 3 then
    local next = "the Crystal Telescope"
    local place = "an observer of the cold village"
elseif stage == 4 then
    local next = "a glass globe"
    local place = "the Valley of the Frost Elves"
elseif stage == 5 then
    local next = "the Crystal Telescope by returning the glass globe"
    local place = "an observer of the cold village"
elseif stage == 6 then
    local next = "a silver-trimmed spellbook"
    local place = "a tower within a destroyed land"
elseif stage == 7 then
    local next = "a map"
    local place = "from a mapper in South Caelia"
elseif stage == 8 then
    local next = "the Golden Quill"
    local place = "the forest near Baba Yaga's hut"
else
    self:say("Please help me!")
end
self:say("You are trying to retrieve:")
self.room:send("<b:green>" .. tostring(next) .. "</>")
self.room:send("</>from <b:white>" .. tostring(place) .. ".</>")