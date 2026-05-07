-- Trigger: 3eg_trophy
-- Zone: 41, ID: 9
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- 3eg recruiter: when an Eldorian Guard recruit asks about "trophy"/"trophies"
-- the mob lists which 3bl-faction items it is interested in receiving.
-- Trophy IDs (zone 55) are the Black Legion drops created by the p*_3bl_death
-- triggers in this zone.
--
-- Original DG Script: #4109

-- Speech keywords: trophy trophies
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "trophy") or string.find(speech_lower, "trophies")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:bl_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have pledged yourself to the forces of")
    actor:send("</>darkness!  Suffer under your choice!'")
    return true
end
-- Trophy item IDs (zone 55). Names resolved from objects.template at runtime.
local trophy_ids = { 5503, 5505, 5507, 5509, 5511, 5513, 5515 }
if actor.alignment >= -150 and actor:get_quest_stage("Black_Legion") == 1 then
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of the Black Legion")
    actor:send("</>you will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    actor:send("</>Items we're interested in are:")
    for _, id in ipairs(trophy_ids) do
        local proto = objects.template(55, id)
        local label = proto and proto.name or ("trophy " .. tostring(id))
        actor:send("- " .. tostring(label))
    end
end