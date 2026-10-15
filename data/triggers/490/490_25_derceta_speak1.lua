-- Trigger: derceta_speak1
-- Zone: 490, ID: 25
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #49025

-- Converted from DG Script #49025: derceta_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: rock boulder
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "rock") or string.find(string.lower(speech), "boulder")) then
    return true  -- No matching keywords
end
wait(0.2)
-- switch on actor:get_quest_stage("griffin_quest")
do
    local _sw1 = string.lower(tostring(actor:get_quest_stage("griffin_quest") or ""))
    if tonumber(_sw1) == 0 or tonumber(_sw1) == 1 then
        self:command("ponder " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'I'm not sure you're ready to face the cultists.  Speak to Earle")
        self.room:send("</>first.")
    elseif tonumber(_sw1) == 2 then
        self.room:send(tostring(self.name) .. " says, 'Have you spoken to the seer?  You cannot hope to prevail")
        self.room:send("</>otherwise.'")
    elseif tonumber(_sw1) == 3 then
        self:command("peer " .. tostring(actor.name))
        self:emote("flexes her mighty muscles.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I can push any boulder you choose, but first you must do something")
        self.room:send("</>for me.'")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Get me back my crystal midget that that thief Derrick stole, and I")
        self.room:send("</>will help you.'")
    else
        self:set_flag("sentinel", true)
        self.room:send(tostring(self.name) .. " says, 'Certainly, just lead me to the rock and say <b:white>'push now'</>.'")
        self:follow(actor.name)
    end
end