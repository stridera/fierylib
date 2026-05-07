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

if not string.find(string.lower(speech), "help") then
    return true
end
if actor:get_quest_stage("flood") ~= 1 then
    return true
end

local color
local id = self.local_id or self.id
if id == 13 or id == 39013 then
    color = "&4"
elseif id == 14 or id == 39014 then
    color = "&6"
elseif id == 16 or id == 39016 then
    color = "&2"
elseif id == 18 or id == 39018 then
    color = "&7&b"
elseif id == 19 or id == 39019 then
    color = "&9&b"
elseif id == 20 or id == 39020 then
    color = "&6&b"
elseif id == 15 or id == 39015 or id == 17 or id == 39017 then
    return true  -- silent spirits
else
    color = "&4&b"
end
self.room:send(self.name .. " says, " .. color .. "'Help with what?'</>")