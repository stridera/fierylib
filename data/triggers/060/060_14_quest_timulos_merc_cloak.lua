-- Trigger: quest_timulos_merc_cloak
-- Zone: 60, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6014

-- Converted from DG Script #6014: quest_timulos_merc_cloak
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: cloak
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "cloak")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "mercenary" and actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Well yes, this cloak is worth much to him.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'It was made off with in a raid on his castle by some bothersome insect warriors.'")
    self:command("mutter")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'All the Lord was able to tell me is they said something about wanting it for their queen.'")
    self:command("shrug")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I think you should go find it now.  Come back when you have the <b:yellow>cloak</>, or do not come back at all.'")
    self:command("open fence")
    self:emote("pushes " .. tostring(actor.name) .. " away.")
    actor.name:move("north")
    self:command("close fence")
end