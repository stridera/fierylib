-- Trigger: wall_ice_sculptor_receive
-- Zone: 533, ID: 12
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53312
--
-- Sculptor receives a block of living ice from the player. If the
-- player is on stage 1 of the wall_ice quest, increment their block
-- count; on the 20th block, advance the quest. If not on the quest,
-- the block is still consumed politely.

if actor:get_quest_stage("wall_ice") == 1 then
    wait(2)
    local blocks = (tonumber(actor:get_quest_var("wall_ice:blocks")) or 0) + 1
    actor:set_quest_var("wall_ice", "blocks", blocks)
    self:say("Great, this is exactly what I need!")
    self.room:send(tostring(self.name) .. " adds " .. tostring(object.shortdesc) .. " to the wall blocking the tunnel.")
    self:destroy_item("all.block-living-ice")
    if blocks == 20 then
        wait(1)
        actor:advance_quest("wall_ice")
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