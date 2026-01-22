-- Trigger: DemonHorn
-- Zone: 125, ID: 28
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12528

-- Converted from DG Script #12528: DemonHorn
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: horn horns
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "horn") or string.find(string.lower(speech), "horns")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("krisenna_quest") == 3 then
    actor.name:advance_quest("krisenna_quest")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Well, I suppose I must honor my obligations, and you have")
    self.room:send("</>certainly earned it.'")
    wait(1)
    self:emote("grasps a horn with both hands, grunts, and breaks it off.")
    wait(1)
    self:say("Not as painful as I thought.")
    wait(2)
    self.room:spawn_object(125, 54)
    self:command("drop horn")
end