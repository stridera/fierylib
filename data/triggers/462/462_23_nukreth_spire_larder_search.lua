-- Trigger: Nukreth Spire larder search
-- Zone: 462, ID: 23
-- Type: WORLD, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #46223

-- Converted from DG Script #46223: Nukreth Spire larder search
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
    if actor:get_quest_var("nukreth_spire:path4") == 0 then
        if actor:get_quest_var("nukreth_spire:treasure") == 1 then
            actor:send("You begin searching...")
            actor:set_quest_var("nukreth_spire", "treasure", 2)
            wait(1)
            self.room:send("A sudden bark comes from")
            self.room:send("A gnoll spiritbreaker says, 'What's going on in there??'")
            wait(1)
            self.room:send("The spiritbreaker roars and attacks!")
            actor:send("<b:yellow>You better kill this thing and search again!</>")
            self.room:spawn_mobile(462, 24)
            self.room:find_actor("spiritbreaker"):command("kill %actor%")
        elseif actor:get_quest_var("nukreth_spire:treasure") == 3 then
            actor:set_quest_var("nukreth_spire", "treasure", 0)
            actor:send("You find a strange stone hidden amongst the bodies!")
            self.room:send_except(actor, tostring(actor.name) .. " finds a strange stone hidden amongst the bodies!")
            self.room:spawn_object(462, 15)
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