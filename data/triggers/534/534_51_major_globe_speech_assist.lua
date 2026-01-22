-- Trigger: major_globe_speech_assist
-- Zone: 534, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53451

-- Converted from DG Script #53451: major_globe_speech_assist
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: assist assist? help help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "assist") or string.find(string.lower(speech), "assist?") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
if (actor.id == -1) and (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class== "pyromancer") and (actor.level >= 57) and not (actor:get_has_completed("major_globe_spell")) and (actor:get_quest_stage("major_globe_spell") == 0) then
    actor.name:start_quest("major_globe_spell")
    wait(2)
    self:emote("nods slowly.")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Yes...  I was recently defeated by a rogue demon roving this valley.  He injured me terribly, but...'")
    self:emote("breaks into a coughing fit!")
    wait(2)
    self:emote("recomposes himself.")
    actor:send(tostring(self.name) .. " says, 'I can't let down Ysgarran, though.  I must defeat the demon.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'But not in this state.'")
    self:command("sigh")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Earle of the druids owes me a favor.  Please visit him in my behalf and acquire a salve for my wounds.'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Tell him <b:cyan>\"Lirne sends me.\"</>  I'm sure he will help.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'You can check your <b:cyan>[spell progress]</> with me if you forget what to do.'")
end