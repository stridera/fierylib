-- Trigger: banish_murgbol_status_checker
-- Zone: 302, ID: 19
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #30219

-- Converted from DG Script #30219: banish_murgbol_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
local stage = actor:get_quest_stage("banish")
if actor:get_has_completed("banish") then
    self:say("I have tought you all I can.")
    return _return_value
elseif stage == 0 then
    self:say("I'm not teaching you right now...")
elseif stage then
    -- switch on stage
    local mob = nil
    local place = nil
    local known = nil
    if stage == 1 then
        mob = 41119
        place = "her chamber under the ocean waves"
        known = "Nothing."
    elseif stage == 2 then
        mob = 53313
        place = "the frozen tunnels of the north"
        known = "v"
    elseif stage == 3 then
        mob = 37000
        place = "a deep and ancient mine"
        known = "vi"
    elseif stage == 4 then
        mob = 48005
        place = "a room filled with art in an ancient barrow"
        known = "vib"
    elseif stage == 5 then
        mob = 53417
        place = "the cold valley of the far north"
        known = "vibu"
    elseif stage == 6 then
        mob = 23811
        place = "a nearby fortress of clouds and crystals"
        known = "vibug"
    elseif stage == 7 then
        self.room:send(tostring(self.name) .. " says, 'Come, speak the prayer aloud: <b:magenta>vibugp</>!'")
        return _return_value
    else
        _return_value = false
    end
    if mob then
        self.room:send(tostring(self.name) .. " says, 'To learn Banish you must next:'")
        self.room:send("- kill the target in " .. tostring(place) .. ".")
        self.room:send("Your knowledge of the prayer so far: \"<b:cyan>" .. tostring(known) .. "</>\"")
    end
end
return _return_value