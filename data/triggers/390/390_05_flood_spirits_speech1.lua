-- Trigger: flood_spirits_speech1
-- Zone: 390, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #39005
--
-- A water spirit responds to "help" from the Envoy. The reply is the same
-- for every spirit, only the color changes.
--
-- TODO: original DG dispatched on legacy vnums 39013-39020 (the eight
-- water-spirit mobiles). Now that everything is (zone, id), this should
-- key off self.local_id (presumably 13..20). Confirm those local IDs and
-- swap the comparisons. Spirits 15 and 17 intentionally fall through with
-- no color (Three-Falls and Sea's Lullaby don't accept "help").

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"help"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("flood") ~= 1 then
    return true
end

local color
local id = self.local_id or self.id
if id == 13 or id == 39013 then
    color = "<blue>"
elseif id == 14 or id == 39014 then
    color = "<cyan>"
elseif id == 16 or id == 39016 then
    color = "<green>"
elseif id == 18 or id == 39018 then
    color = "<b:white>"
elseif id == 19 or id == 39019 then
    color = "<b:black>"
elseif id == 20 or id == 39020 then
    color = "<b:cyan>"
elseif id == 15 or id == 39015 or id == 17 or id == 39017 then
    return true  -- silent spirits
else
    color = "<b:blue>"
end
self.room:send(self.name .. " says, " .. color .. "'Help with what?'</>")