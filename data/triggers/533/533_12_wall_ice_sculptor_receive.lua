-- Trigger: wall_ice_sculptor_receive
-- Zone: 533, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53312

-- Converted from DG Script #53312: wall_ice_sculptor_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wall_ice") == 1 then
    wait(2)
    local ice = actor:get_quest_var("wall_ice:blocks") + 1
    actor.name:set_quest_var("wall_ice", "blocks", ice)
    self:say("Great, this is exactly what I need!")
    self.room:send(tostring(self.name) .. " adds " .. tostring(object.shortdesc) .. " to the wall blocking the tunnel.")
    self:destroy_item("all.block-living-ice")
    if actor:get_quest_var("wall_ice:blocks") == 20 then
        wait(1)
        actor.name:advance_quest("wall_ice")
        self.room:send(tostring(self.name) .. " says, 'Excellent, this looks like enough ice!  Now all we have to do is cast the spell.  If you'd like to do the honors, just command the ice to <b:cyan>crystalize</>.'")
    else
        wait(2)
        self:say("Got any more?")
    end
else
    wait(2)
    self:destroy_item("all.block-living-ice")
    self:say("Hey thanks!  I could always use more of those.")
end