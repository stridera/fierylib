-- Trigger: LP_bard_subclass_speech2
-- Zone: 43, ID: 55
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4355

-- Converted from DG Script #4355: LP_bard_subclass_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: audition audition? process process?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "audition") or string.find(string.lower(speech), "audition?") or string.find(string.lower(speech), "process") or string.find(string.lower(speech), "process?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Rogue") and (actor.level >= 10 and actor.level <= 25) then
    -- switch on actor.race
    -- case ADD RESTRICTED RACES HERE
    -- msend %actor% &1Your race cannot subclass to bard.&0
    -- halt
    -- break
    if not actor:get_quest_stage("bard_subclass") then
        wait(2)
        actor:send(tostring(self.name) .. " says, 'We're looking for someone who can sing and dance and act - a real triple threat.  It'll earn you a place in the spotlight and the Bard Guild.  You'll be a real professional!'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Whadda ya say kid?  You wanna give it a shot?'")
    end
end