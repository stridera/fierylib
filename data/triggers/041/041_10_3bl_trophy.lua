-- Trigger: 3bl_trophy
-- Zone: 41, ID: 10
-- Type: MOB, Flags: SPEECH, SPEECH_TO
-- Status: CLEAN
--
-- 3bl recruiter: when a Black Legion recruit asks about "trophy"/"trophies"
-- the mob lists which 3eg-faction items it is interested in receiving.
-- Trophy IDs (zone 55) are the Eldorian Guard drops created by the
-- p*_3eg_death triggers in this zone.
--
-- Original DG Script: #4110

-- Speech keywords: trophy trophies
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "trophy") or string.find(speech_lower, "trophies")) then
    return true  -- No matching keywords
end
if actor:get_quest_var("Black_Legion:eg_ally") then
    actor:send(tostring(self.name) .. " tells you, 'You have already chosen your side!  Be")
    actor:send("</>gone, filth!'")
    return true
end
-- Trophy item IDs (zone 55). Names resolved from objects.template at runtime.
local trophy_ids = { 5504, 5506, 5508, 5510, 5512, 5514, 5516 }
if actor.alignment <= 150 and actor:get_quest_stage("Black_Legion") == 1 then
    actor:send(tostring(self.name) .. " tells you, 'As you fight the allies of Eldorian Guard")
    actor:send("</>you will periodically find goods on their bodies that we will want in order to")
    actor:send("</>prove that you are working with us.'")
    actor:send("</>Items we're interested in are:")
    for _, id in ipairs(trophy_ids) do
        local proto = objects.template(55, id)
        local label = proto and proto.name or ("trophy " .. tostring(id))
        actor:send("- " .. tostring(label))
    end
end