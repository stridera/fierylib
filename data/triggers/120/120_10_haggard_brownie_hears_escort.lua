-- Trigger: Haggard brownie hears 'escort'
-- Zone: 120, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12010

-- Converted from DG Script #12010: Haggard brownie hears 'escort'
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"escort"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
-- Remember who is escorting us so trigger 120-21 can hand out the reward.
globals.rescuer = actor
if not (self.room.zone_id == 120 and self.room.local_id == 103) and not (self.room.zone_id == 120 and self.room.local_id == 95) and not (self.room.zone_id == 120 and self.room.local_id == 30) then
    wait(0.4)
    self:follow(actor)
end