-- Trigger: quest_obj_package(8813)
-- Zone: 60, ID: 20
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #6020

-- Converted from DG Script #6020: quest_obj_package(8813)
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and actor:get_quest_stage("merc_ass_thi_subclass") == 3 then
    if self.room ~= 8828 then
        _return_value = false
        self.room:send_except(actor, tostring(self.shortdesc) .. " suddenly bursts into flames!")
        actor:send(tostring(self.shortdesc) .. " suddenly bursts into flames from being handled too much!")
        world.destroy(self)
    else
        actor.name:advance_quest("merc_ass_thi_subclass")
        actor:send("&9<blue>You've secured the package!")
        actor:send("Now get out carefully!</>")
    end
end
return _return_value