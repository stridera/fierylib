-- Trigger: major_globe_earle_receive_sake
-- Zone: 534, ID: 63
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53463

-- Converted from DG Script #53463: major_globe_earle_receive_sake
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- DG receive arg list (58002): this trigger ran only for these items.
-- The runtime does not filter on arg_list, so the filter lives here.
if not (
    (object.zone_id == 580 and object.id == 2)
) then
    return true
end

if actor:get_quest_stage("major_globe_spell") == 3 then
    -- bottle of sake
    wait(0.1)
    actor:advance_quest("major_globe_spell")
    self:destroy_item("sake")
    actor:send(tostring(self.name) .. " says, 'Good, good.  This will mix well.  Just one more ingredient.  We'll need some <b:yellow>marigold poultice</> to complete this salve.'")
    self:command("think")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'It's commonly used by healers, perhaps you should track one down.'")
end