-- Trigger: Diplomat quest: ranger receiving things
-- Zone: 502, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #50204

-- Converted from DG Script #50204: Diplomat quest: ranger receiving things
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
--
-- TODO: actor.id and object.id are now "zone:local" strings, so the
-- numeric equality checks (50218, 50201, 50209) never match. The intent
-- appears to be: when given a diplomat-token (legacy 50218 -> 502:18),
-- record which mob delivered it (legacy 50201/50209 -> 502:1 / 502:9)
-- via globals.mdiplomat, then consume the token. Rewrite using
-- `actor.zone_id`/`actor.local_id` and `object.zone_id`/`object.local_id`
-- once the intended composite IDs are confirmed; the local `mdiplomat`
-- assignments below are dead (block-scoped, never read).
local actor_id = actor.id
wait(1)
if object.id == 50218 then
    wait(1)
    if actor_id == 50201 then
        local mdiplomat = 1
        globals.mdiplomat = globals.mdiplomat or true
    elseif actor_id == 50209 then
        local mdiplomat = 0
        globals.mdiplomat = globals.mdiplomat or true
    end
    self:destroy_item("diplomat-token")
end