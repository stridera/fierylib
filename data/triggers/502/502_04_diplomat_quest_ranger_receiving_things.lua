-- Trigger: Diplomat quest: ranger receiving things
-- Zone: 502, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #50204

-- Converted from DG Script #50204: Diplomat quest: ranger receiving things
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local avnum = actor.id
wait(1)
if object.id == 50218 then
    wait(1)
    if avnum == 50201 then
        local mdiplomat = 1
        globals.mdiplomat = globals.mdiplomat or true
    elseif avnum == 50209 then
        local mdiplomat = 0
        globals.mdiplomat = globals.mdiplomat or true
    end
    self:destroy_item("diplomat-token")
end