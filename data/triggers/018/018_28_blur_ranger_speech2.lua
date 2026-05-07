-- Trigger: blur_ranger_speech2
-- Zone: 18, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1828
-- TODO(parity): legacy DG used branch-scoped `local count = time` re-declarations
-- that never updated the outer loop var — guarantees an infinite loop in Lua.
-- The polling loop below has been hoisted to update the outer `count`. Validate
-- the wait(25) / 1800-tick cadence matches the legacy 24-hour quest timer.

-- Converted from DG Script #1828: blur_ranger_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: let's begin
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "let's") or string.find(speech_lower, "begin")) then
    return true  -- No matching keywords
end
actor:set_quest_var("blur", "east", 0)
actor:set_quest_var("blur", "west", 0)
actor:set_quest_var("blur", "south", 0)
actor:set_quest_var("blur", "north", 0)
if actor:get_quest_stage("blur") == 4 then
    wait(2)
    self:say("Ready...")
    wait(3)
    self:say("Set...")
    wait(3)
    self.room:send(tostring(self.name) .. " says, '<b:green>GO!!</>  Your time has begun!'")
    actor:set_quest_var("blur", "race", "go")
    self.room:send(tostring(self.name) .. " fades into the trees.")
    self:teleport(get_room(11, 0))
    local count = 1800
    actor:send("<b:white>24 hours (30:00 minutes) remain.</>")
    while count > 0 do
        if actor:get_has_completed("blur") then
            count = 0
        else
            actor:set_quest_var("blur", "timer", count)
            wait(25)
            count = count - 25
            if count == 900 then
                actor:send("<b:white>12 hours (15:00 minutes) remain.</>")
            elseif count == 450 then
                actor:send("<b:white>6 hours (7:30 minutes) remain.</>")
            elseif count == 300 then
                actor:send("<b:white>4 hours (5:00 minutes) remain.</>")
            elseif count == 150 then
                actor:send("<b:white>2 hours (2:30 minutes) remain.</>")
            elseif count == 75 then
                actor:send("<b:white>1 hour (1:15 minutes) remain.</>")
            elseif count == 0 then
                actor:send("<b:red>Time's up!!</>")
            end
        end
    end
    if not actor:get_has_completed("blur") then
        actor:fail_quest("blur")
        actor:set_quest_var("blur", "race", "off")
        actor:send(self.name .. " tells you, '" .. "You'll have to be a little quicker on your toes next time." .. "'")
        wait(2)
        actor:send(self.name .. " tells you, '" .. "'Come back to me if you want to try again.'" .. "'")
    end
end
world.destroy(self)