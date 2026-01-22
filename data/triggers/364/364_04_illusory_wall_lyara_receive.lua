-- Trigger: illusory_wall_lyara_receive
-- Zone: 364, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #36404

-- Converted from DG Script #36404: illusory_wall_lyara_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("illusory_wall") == 1 then
    local item1 = actor:get_quest_var("illusory_wall:18511")
    local item2 = actor:get_quest_var("illusory_wall:10307")
    local item3 = actor:get_quest_var("illusory_wall:41005")
    local item4 = actor:get_quest_var("illusory_wall:51017")
    if actor.quest_variable[illusory_wall:object.vnum] == 1 then
        _return_value = false
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_shortdesc) .. ".")
        self:command("shake")
        self:say("You have already given me this.")
    elseif (item1 == 1 and object.id == 10307) or (item2 == 1 and object.id == 18511) then
        _return_value = false
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_shortdesc) .. ".")
        self:command("shake")
        self.room:send(tostring(self.name) .. " says, 'You have already given me something suitable for")
        self.room:send("</>magic lenses.'")
    else
        if object.id == 10307 or object.id == 18511 then
            actor.name:set_quest_var("illusory_wall", "%object.vnum%", 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self:say("These are excellent lenses.")
        elseif object.id == 41005 then
            actor.name:set_quest_var("illusory_wall", "%object.vnum%", 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'Yes, this will do nicely.  Hopeflly you gained a")
            self.room:send("</>few insights on bending light from the prisms in the Hive as well.'")
        elseif object.id == 51017 then
            actor.name:set_quest_var("illusory_wall", "%object.vnum%", 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " looks at the odd glowing lump.")
            self:say("Ah yes, plenty of extra juice in here.")
        else
            _return_value = false
            wait(1)
            self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_shortdesc) .. ".")
            self:command("shake")
            self:say("This won't help you see through illusions any better.")
        end
        local item1 = actor:get_quest_var("illusory_wall:18511")
        local item2 = actor:get_quest_var("illusory_wall:10307")
        local item3 = actor:get_quest_var("illusory_wall:41005")
        local item4 = actor:get_quest_var("illusory_wall:51017")
        if (item1 or item2) and item3 and item4 then
            actor.name:advance_quest("illusory_wall")
            actor.name:set_quest_var("illusory_wall", "total", 0)
            wait(2)
            self:say("Wonderful, looks like this is everything.")
            wait(2)
            self.room:send(tostring(self.name) .. " holds the prismatic leg spur and the lenses next to each other and utters a few words.")
            self.room:send("<b:yellow>The lenses fuse with the leg spur, taking on a prismatic quality!</>")
            wait(4)
            self.room:send(tostring(self.name) .. " holds the lump of magic over the prismatic lenses and whispers an incantation.")
            self.room:send("<b:yellow>The magic melds with the lenses!</>")
            wait(3)
            self.room:spawn_object(364, 0)
            self.room:send(tostring(self.name) .. " says, 'These lenses will show you little hidden details")
            self.room:send("</>about doors and exits.'")
            self:command("give lenses " .. tostring(actor.name))
            wait(3)
            self.room:send(tostring(self.name) .. " says, '<b:white>[Examine]</> 20 different closeable exits in 20")
            self.room:send("</>different parts of the world.'")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Once you have, you should know enough to replicate")
            self.room:send("</>such barriers on your own.'")
            wait(4)
            self:say("Good luck!")
        else
            wait(2)
            self:say("Do you have the other necessities?")
        end
    end
elseif actor:get_quest_stage("illusory_wall") > 1 then
    _return_value = false
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_shortdesc) .. ".")
    self:say("There's nothing else you need to bring me.")
else
    _return_value = false
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_shortdesc) .. ".")
    self:say("No need for supplies, soldier.")
    self:command("salute " .. tostring(actor.name))
end
return _return_value