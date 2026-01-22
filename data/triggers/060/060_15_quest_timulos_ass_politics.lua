-- Trigger: quest_timulos_ass_politics
-- Zone: 60, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6015

-- Converted from DG Script #6015: quest_timulos_ass_politics
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: politics? politics
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "politics?") or string.find(string.lower(speech), "politics")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "assassin" and actor:get_quest_stage("merc_ass_thi_subclass") == 2 then
    actor.name:advance_quest("merc_ass_thi_subclass")
    actor:send(tostring(self.name) .. " says, 'Ah yes, the politics of it all.  Personally I am not one for them, but some people get all mixed up in those.'")
    wait(2)
    self:command("consider " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Well, you seem fit, I guess.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Go kill the Mayor of Mielikki.  He's probably holed up in his office in City Hall.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You'll have to break in, sneak past the guards, and <red>kill</> him.  Get his <b:yellow>cane</> as proof and come back and give it to me.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'It is worth much to me if he dies, so get to it.  It will be worth it for you as well.'")
    self:command("grin " .. tostring(actor.name))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Well, go on.'")
    self:command("open fence")
    self:emote("pushes " .. tostring(actor.name) .. " away.")
    actor.name:move("north")
    self:command("close fence")
end