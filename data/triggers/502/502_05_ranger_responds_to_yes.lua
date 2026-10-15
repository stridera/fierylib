-- Trigger: Ranger responds to yes
-- Zone: 502, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #50205

-- Converted from DG Script #50205: Ranger responds to yes
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.6)
if world.count_mobiles(502, 9) < 1 then
    self:command("peer " .. tostring(actor.name))
else
    self:say("Well, a ghostly fellow ran by here just a moment ago.")
    run_room_trigger(502, 6)
end