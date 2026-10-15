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

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"trophy", "trophies"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
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