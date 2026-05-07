-- Trigger: apprentice_speak1
-- Zone: 178, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17804

-- Converted from DG Script #17804: apprentice_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0% (always-fires gate; pattern-matched)

-- TODO(parity): DG keyword list "i have failed my quest" was a phrase match;
-- converter emitted per-word OR which over-triggers (any sentence with "i"
-- or "my" matches). Treating as phrase match here for fidelity.
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "i have failed my quest") then
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