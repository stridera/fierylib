-- Trigger: major_globe_earle_receive_shale
-- Zone: 534, ID: 62
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53462

-- Converted from DG Script #53462: major_globe_earle_receive_shale
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("major_globe_spell") == 2 then
    -- chunk of shale
    wait(1)
    actor.name:advance_quest("major_globe_spell")
    self:destroy_item("majorglobe-shale")
    self:command("nod")
    actor:send(tostring(self.name) .. " says, 'This will do.'")
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Next you will need to retrieve some alcohol for the salve.  Make it <b:yellow>sake</>, actually.  That would be best.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well, go on then!  Don't keep Lirne waiting.'")
    self:emote("starts crushing the shale in a bowl.")
end