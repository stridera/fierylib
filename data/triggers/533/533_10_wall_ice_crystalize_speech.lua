-- Trigger: wall_ice_crystalize_speech
-- Zone: 533, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #53310

-- Converted from DG Script #53310: wall_ice_crystalize_speech
-- Original: MOB trigger, flags: SPEECH, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Speech keywords: crystalize crystalize!
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "crystalize") or string.find(string.lower(speech), "crystalize!")) then
    return true  -- No matching keywords
end
local drop = actor:get_quest_var("wall_ice:drop")
if actor:get_quest_stage("wall_ice") == 1 and actor:has_item("53326") and self.id ~= 53316 then
    if ice then
        actor:send("<cyan>You have already cast this spell on " .. tostring(self.name) .. "!</>")
    else
        local ice = random(1, 100)
        if drop < 21 then
            if ice <= self.level then
                self.room:send("<cyan>A dark glow surrounds <b:cyan>" .. tostring(self.name) .. "</><cyan> briefly!</>")
                local ice = 1
                globals.ice = globals.ice or true
                local count = (drop + 1)
                actor.name:set_quest_var("wall_ice", "drop", count)
            else
                self.room:send("<cyan>The spell seems to have no effect!</>")
                local ice = 2
                globals.ice = globals.ice or true
            end
        end
    end
elseif self.id == 53316 and actor:get_quest_stage("wall_ice") == 2 and actor:has_item("53326") then
    self.room:send("<b:cyan>The blocks of living ice slowly fuse together!</>")
    wait(1)
    self:say("Well done!")
    self:command("nod " .. tostring(actor.name))
    wait(1)
    self:say("All in a good day's work!")
    wait(1)
    self:say("Keep the notes.  It should be everything you need to cast Wall of Ice yourself.")
    actor.name:send("<b:cyan>You have learned Wall of Ice!</>")
    actor.name:complete_quest("wall_ice")
    skills.set_level(actor.name, "wall of ice", 100)
end