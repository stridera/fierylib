-- Trigger: quest_timulos_thi_farmers
-- Zone: 60, ID: 16
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6016

-- Converted from DG Script #6016: quest_timulos_thi_farmers
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: farmers?  farmer? farmer farmers
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "farmers?") or string.find(string.lower(speech), "farmer?") or string.find(string.lower(speech), "farmer") or string.find(string.lower(speech), "farmers")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'That is right, a <b:yellow>package</> was taken by a farmer who should not have it.'")
    self:command("grumble")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I know this: he got it from the post office in Mielikki and he lives near there.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Go get it back and I will make it worth it to you.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Do not let anyone see you and do not leave a trail of bodies behind you.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'And be careful!  If you jostle the package too much it just might explode.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'For now though, we are done.  Begone.'")
    wait(2)
    self:command("open fence")
    actor:send(tostring(self.name) .. " says, 'Well, go on.'")
    self:emote("pushes " .. tostring(actor.name) .. " harshly away.")
    actor.name:move("north")
    self:command("close fence")
end