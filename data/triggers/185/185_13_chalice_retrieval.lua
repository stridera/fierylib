-- Trigger: chalice_retrieval
-- Zone: 185, ID: 13
-- Type: OBJECT, Flags: GET
--
-- Picking up the bronze chalice in its home room advances the
-- pri_pal_subclass quest from stage 2 -> 3. If the same player has
-- already grabbed it in this load, the chalice slips from their
-- fingers (legacy anti-cheese behavior).
--
-- TODO(parity): the legacy 5-digit room vnum 8591 needs verification.
-- Best guess: zone 85, id 91 (chalice room) — confirm against the
-- imported world before relying on this trigger in production.

local CHALICE_ROOM_ZONE = 85
local CHALICE_ROOM_ID = 91

if self.room.zone_id == CHALICE_ROOM_ZONE and self.room.local_id == CHALICE_ROOM_ID then
    if actor:get_quest_stage("pri_pal_subclass") == 2 then
        if globals.already_got then
            self.room:send_except(actor, "The chalice slips from " .. tostring(actor.possessive) .. " fingers!")
            actor:send("The chalice slips from your fingers!")
            return true
        else
            actor:advance_quest("pri_pal_subclass")
        end
    end
    globals.already_got = true
end
return true
