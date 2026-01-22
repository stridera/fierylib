-- Trigger: major_globe_speech_lirne_sends_me
-- Zone: 534, ID: 52
-- Type: MOB, Flags: GLOBAL, SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53452

-- Converted from DG Script #53452: major_globe_speech_lirne_sends_me
-- Original: MOB trigger, flags: GLOBAL, SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: Lirne sends me
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "lirne") or string.find(string.lower(speech), "sends") or string.find(string.lower(speech), "me")) then
    return true  -- No matching keywords
end
wait(1)
if actor:get_quest_stage("major_globe_spell") == 1 then
    actor.name:advance_quest("major_globe_spell")
    self:command("smirk")
    actor:send(tostring(self.name) .. " says, 'Ah yes, Lirne.  He never writes and only drops by when he's injured.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Well, what got him this time?  Lions?  Tigers?  Be- ah, it doesn't matter.'")
    self:command("sigh")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I will prepare an all-purpose healing salve for him.  But you will need to retrieve the components for me.'")
    self:command("ponder")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'First, I will need some <b:yellow>shale</> to create a base.  You can probably find some on the nearby volcanic island.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Return to me when you have procured the shale.'")
elseif actor:get_quest_stage("major_globe_spell") == 2 then
    actor:send(tostring(self.name) .. " says, 'Well yes, I already know that.  Did you get the shale yet?'")
elseif actor:get_quest_stage("major_globe_spell") then
    actor:send(tostring(self.name) .. " says, 'Yes, yes, I know!  You told me already!'")
else
    self:command("smirk")
    actor:send(tostring(self.name) .. " says, 'I doubt it.'")
end