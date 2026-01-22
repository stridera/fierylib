-- Trigger: apprentice_speak1
-- Zone: 178, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17804

-- Converted from DG Script #17804: apprentice_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: i have failed my quest
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "i") or string.find(string.lower(speech), "have") or string.find(string.lower(speech), "failed") or string.find(string.lower(speech), "my") or string.find(string.lower(speech), "quest")) then
    return true  -- No matching keywords
end
self:command("comfort " .. tostring(actor.name))
self:say("Maybe another time you will succeed.")
self:emote("utters the words 'rednes ot nruter'.")
actor:teleport(get_room(178, 68))
do
    local _mob = world.find_mobile("fetch-apparition")
    if _mob then
        _mob.room:at(function()
            world.destroy(self.room:find_actor("fetch-apparition"))
        end)
    end
end
-- actor looks around