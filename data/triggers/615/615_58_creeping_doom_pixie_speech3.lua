-- Trigger: creeping_doom_pixie_speech3
-- Zone: 615, ID: 58
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #61558

-- Converted from DG Script #61558: creeping_doom_pixie_speech3
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: nature majesty treat remind nature? majesty? treat? remind?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "nature") or string.find(string.lower(speech), "majesty") or string.find(string.lower(speech), "treat") or string.find(string.lower(speech), "remind") or string.find(string.lower(speech), "nature?") or string.find(string.lower(speech), "majesty?") or string.find(string.lower(speech), "treat?") or string.find(string.lower(speech), "remind?")) then
    return true  -- No matching keywords
end
if string.find(actor.class, "Druid") then
    if actor.level > 80 then
        if actor:get_quest_stage("creeping_doom") == 0 then
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'They have lost their respect for Nature and us,")
            self.room:send("</>its fey emissaries.  They slaughter our families like pigs.  They burn the")
            self.room:send("</>forests and overhunt the fields.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'They no longer fear us.")
            self.room:send("</>We who come for their children in the night.")
            self.room:send("</>We who bring nightmares to generations.")
            self.room:send("</>We who dream a Dream they should pray we never awaken from.'")
            wait(2)
            self:say("They have forgotten.")
            wait(4)
            self:say("We will make them remember.")
        end
    end
end