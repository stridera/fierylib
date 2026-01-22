-- Trigger: moonwell_dryad_map_replacement
-- Zone: 163, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16351

-- Converted from DG Script #16351: moonwell_dryad_map_replacement
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: I lost my map
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "lost") or string.find(string.lower(speech), "my") or string.find(string.lower(speech), "map")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("moonwell_spell_quest")
if stage > 6 then
    self:command("sigh")
    self:say("It will be difficult to complete this ritual without it.")
    wait(1)
    self:emote("begins to draw a new map.")
    wait(2)
    self:emote("continues to draw...")
    wait(2)
    self:emote("continues to draw...")
    wait(4)
    self:say("There!  All set!")
    wait(1)
    -- switch on stage
    if stage == 8 then
        self.room:spawn_object(163, 52)
    elseif stage == 9 or stage == 10 then
        self.room:spawn_object(163, 53)
    elseif stage == 11 then
        self.room:spawn_object(163, 54)
    elseif stage == 12 then
        self.room:spawn_object(163, 55)
    elseif stage == 7 then
    else
        self.room:spawn_object(163, 51)
    end
    self:command("give map " .. tostring(actor.name))
end