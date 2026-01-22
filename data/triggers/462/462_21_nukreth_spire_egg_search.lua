-- Trigger: Nukreth Spire egg search
-- Zone: 462, ID: 21
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #46221

-- Converted from DG Script #46221: Nukreth Spire egg search
-- Original: WORLD trigger, flags: COMMAND, probability: 100%

-- Command filter: search
if not (cmd == "search") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path2") == 0 then
        if actor:get_quest_var("nukreth_spire:baby") == 1 then
            actor:set_quest_var("nukreth_spire", "baby", 2)
            actor:send("You begin searching...")
            wait(1)
            self.room:send("A sudden yip comes from outside the pen!")
            self.room:send("A gnoll beastmaster says, 'What's going on in there??'")
            wait(1)
            self.room:send("The beastmaster and a dire hyena enter the pen and attack!")
            actor:send("<b:yellow>You better kill these things and search again!</>")
            self.room:spawn_mobile(462, 26)
            self.room:find_actor("beastmaster"):command("kill %actor%")
            self.room:spawn_mobile(462, 27)
            self.room:find_actor("dire-hyena"):command("kill %actor%")
        elseif actor:get_quest_var("nukreth_spire:baby") == 4 then
            actor:set_quest_var("nukreth_spire", "baby", 0)
            actor:send("You find a speckled kobold egg hidden amongst the straw!")
            self.room:send_except(actor, tostring(actor.name) .. " finds a speckled kobold egg hidden amongst the straw!")
            self.room:spawn_object(462, 14)
        else
            _return_value = false
        end
    else
        _return_value = false
    end
else
    _return_value = false
end
return _return_value