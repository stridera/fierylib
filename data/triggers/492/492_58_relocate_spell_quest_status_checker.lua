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
    return true
end
-- switch on stage
local next_item, place
if stage == 1 or stage == 2 then
    next_item = "the Staff of the Mystics"
    place = "a druid past the Vale of Anlun"
elseif stage == 3 then
    next_item = "the Crystal Telescope"
    place = "an observer of the cold village"
elseif stage == 4 then
    next_item = "a glass globe"
    place = "the Valley of the Frost Elves"
elseif stage == 5 then
    next_item = "the Crystal Telescope by returning the glass globe"
    place = "an observer of the cold village"
elseif stage == 6 then
    next_item = "a silver-trimmed spellbook"
    place = "a tower within a destroyed land"
elseif stage == 7 then
    next_item = "a map"
    place = "from a mapper in South Caelia"
elseif stage == 8 then
    next_item = "the Golden Quill"
    place = "the forest near Baba Yaga's hut"
else
    -- Quest not started or stage outside the known item-fetch range.
    self:say("Please help me!")
    return true
end
self:say("You are trying to retrieve:")
self.room:send("<b:green>" .. next_item .. "</>")
self.room:send("</>from <b:white>" .. place .. ".</>")