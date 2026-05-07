-- Trigger: rana_receive1
-- Zone: 510, ID: 16
-- Type: MOB, Flags: RECEIVE
--
-- Original DG Script: #51016
-- Original DG keyword: object vnum 51017 (the page).
-- When Rana receives the page, she examines the protection spell,
-- swaps her held item from the page to the magic, and follows the
-- giver back to Luchiaans for the showdown.
if not (object.zone_id == 510 and object.id == 17) then
    return true
end

self:emote("examines her new prize briefly.")
self:say("So...this is it eh?  The legendary protection spell!")
self:command("remove page")
self:command("drop page")
self:command("hold magic")
self:follow(actor)
self:say("Take me to Luchiaans now - I am ready to terminate his sorry existence!")
