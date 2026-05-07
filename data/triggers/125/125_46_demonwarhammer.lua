-- Trigger: DemonWarhammer
-- Zone: 125, ID: 46
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12546

-- Converted from DG Script #12546: DemonWarhammer
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: brother vengeance revenge hammer warhammer halfling
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "brother") or string.find(speech_lower, "vengeance") or string.find(speech_lower, "revenge") or string.find(speech_lower, "hammer") or string.find(speech_lower, "halfling")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor:advance_quest("krisenna_quest")
    actor:send("<b:white>You have furthered the quest!</>")
    actor:send("<b:white>Group credit will not be awarded for the next step of this quest.</>")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Its owner's death was such a shame, but unavoidable nonetheless.'")
    wait(2)
    self:say("Please, return his hammer to his family.")
    wait(2)
    self:emote("stops using a large stone warhammer.")
    self.room:spawn_object(125, 2)
    self:command("drop hammer")
end