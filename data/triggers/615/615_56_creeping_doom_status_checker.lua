-- Trigger: creeping_doom_status_checker
-- Zone: 615, ID: 56
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #61556

-- Converted from DG Script #61556: creeping_doom_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress? status status?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?") or string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("creeping_doom")
wait(2)
-- switch on stage
if stage == 1 then
    local item1 = 11812
    local place1 = "an assassin vine on Mist Mountain"
    local item2 = 16213
    local place2 = "the great pyramid"
    local item3 = 48029
    local place3 = "Rhalean's evil sister in the northern barrow"
    local step = "gathering Nature's Rage"
elseif stage == 2 then
    local essence = actor:get_quest_var("creeping_doom:spiders")
    local total = 11 - actor:get_quest_var("creeping_doom:spiders")
    self.room:send(tostring(self.name) .. " says, 'You are collecting essences of swarms from:")
    self.room:send("</>Flies, insects, spiders, bugs, scorpions, giant ant people, etc.'")
    -- (empty room echo)
    self.room:send("You have found " .. tostring(essence) .. " essences.")
    self.room:send("You need to find " .. tostring(total) .. " more.")
    -- (empty room echo)
    self.room:send("Remember, the tougher the bug, the better your chances of finding essences.")
    return _return_value
elseif stage == 3 then
    local step = "locate three sources of Nature's Vengeance."
    local item1 = 48416
    local place1 = "the elder tremaen in the elemental Plane of Fire"
    local item2 = 52034
    local place2 = "the burning tree in Templace"
    local item3 = 62503
    local place3 = "the Treant in the eldest Rhell's forest"
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'Take the Essence of Nature's Vengeance and")
    self.room:send("</>drop it at the entrance to the logging camp.'")
    return _return_value
else
    if actor:get_has_completed("creeping_doom") then
        self:say("I already taught you Creeping Doom!")
    else
        self:say("You haven't started to dream my Dream yet.")
    end
    return _return_value
end
self.room:send("You are trying to " .. tostring(step) .. ".")
-- (empty room echo)
if actor:get_quest_var("creeping_doom:" .. tostring(item1)) or actor:get_quest_var("creeping_doom:" .. tostring(item2)) or actor:get_quest_var("creeping_doom:" .. tostring(item3)) then
    self.room:send("You have brought me:")
    if actor:get_quest_var("creeping_doom:" .. tostring(item1)) then
        self.room:send("- " .. tostring(world.get_obj_shortdesc(item1)))
    end
    if actor:get_quest_var("creeping_doom:" .. tostring(item2)) then
        self.room:send("- " .. tostring(world.get_obj_shortdesc(item2)))
    end
    if actor:get_quest_var("creeping_doom:" .. tostring(item3)) then
        self.room:send("- " .. tostring(world.get_obj_shortdesc(item3)))
    end
end
-- (empty room echo)
self.room:send("I still need:")
if not actor:get_quest_var("creeping_doom:" .. tostring(item1)) then
    self.room:send("- " .. tostring(world.get_obj_shortdesc(item1)) .. " from " .. tostring(place1))
end
if not actor:get_quest_var("creeping_doom:" .. tostring(item2)) then
    self.room:send("- " .. tostring(world.get_obj_shortdesc(item2)) .. " from " .. tostring(place2))
end
if not actor:get_quest_var("creeping_doom:" .. tostring(item3)) then
    self.room:send("- " .. tostring(world.get_obj_shortdesc(item3)) .. " from " .. tostring(place3))
end