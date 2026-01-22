-- Trigger: thief_subclass_package_give
-- Zone: 60, ID: 26
-- Type: OBJECT, Flags: GIVE
-- Status: CLEAN
--
-- Original DG Script: #6026

-- Converted from DG Script #6026: thief_subclass_package_give
-- Original: OBJECT trigger, flags: GIVE, probability: 100%
local _return_value = true  -- Default: allow action
if victim:get_quest_var("merc_ass_thi_subclass:subclass_name") == "thief" and victim:get_quest_stage("merc_ass_thi_subclass") == 3 then
    if self.room ~= 8828 then
        _return_value = false
        self.room:send_except(actor, tostring(self.shortdesc) .. " suddenly bursts into flames!")
        actor:send(tostring(self.shortdesc) .. " suddenly bursts into flames from being handled too much!")
        world.destroy(self)
    else
        victim.name:advance_quest("merc_ass_thi_subclass")
        victim:send("You've secured the package!")
    end
end
return _return_value