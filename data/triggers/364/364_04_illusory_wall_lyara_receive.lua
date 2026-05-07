-- Trigger: illusory_wall_lyara_receive
-- Zone: 364, ID: 4
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Lyara accepts quest items for the magic spectacles:
--   (103, 7)   small spectacles  } either accepted as the lens
--   (185, 11)  pair of glasses   }
--   (410, 5)   prismatic leg spur
--   (510, 17)  petrified magic lump
-- Once a lens, leg spur, and magic lump are all delivered, she fuses them
-- and gives the player the finished lenses, advancing the quest.
--
-- Original DG Script: #36404
local function obj_id_matches(obj, z, lid)
    return obj.zone_id == z and obj.local_id == lid
end
local lens_a_z, lens_a_id = 103, 7
local lens_b_z, lens_b_id = 185, 11
local spur_z,   spur_id   = 410, 5
local magic_z,  magic_id  = 510, 17
local obj_short = object.short_description or object.name
if actor:get_quest_stage("illusory_wall") == 1 then
    local key = tostring(object.zone_id) .. "_" .. tostring(object.local_id)
    local lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
    local lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
    local spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
    local magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
    if actor:get_quest_var("illusory_wall:" .. key) == 1 then
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self:say("You have already given me this.")
        return true
    elseif (lens_a == 1 and obj_id_matches(object, lens_b_z, lens_b_id))
        or (lens_b == 1 and obj_id_matches(object, lens_a_z, lens_a_id)) then
        wait(1)
        self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
        self:command("shake")
        self.room:send(tostring(self.name) .. " says, 'You have already given me something suitable for")
        self.room:send("</>magic lenses.'")
        return true
    else
        if obj_id_matches(object, lens_a_z, lens_a_id) or obj_id_matches(object, lens_b_z, lens_b_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self:say("These are excellent lenses.")
        elseif obj_id_matches(object, spur_z, spur_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'Yes, this will do nicely.  Hopefully you gained a")
            self.room:send("</>few insights on bending light from the prisms in the Hive as well.'")
        elseif obj_id_matches(object, magic_z, magic_id) then
            actor:set_quest_var("illusory_wall", key, 1)
            wait(2)
            world.destroy(object)
            wait(1)
            self.room:send(tostring(self.name) .. " looks at the odd glowing lump.")
            self:say("Ah yes, plenty of extra juice in here.")
        else
            wait(1)
            self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
            self:command("shake")
            self:say("This won't help you see through illusions any better.")
            return true
        end
        lens_a = actor:get_quest_var("illusory_wall:" .. lens_a_z .. "_" .. lens_a_id)
        lens_b = actor:get_quest_var("illusory_wall:" .. lens_b_z .. "_" .. lens_b_id)
        spur   = actor:get_quest_var("illusory_wall:" .. spur_z   .. "_" .. spur_id)
        magic  = actor:get_quest_var("illusory_wall:" .. magic_z  .. "_" .. magic_id)
        if (lens_a or lens_b) and spur and magic then
            actor:advance_quest("illusory_wall")
            actor:set_quest_var("illusory_wall", "total", 0)
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
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("There's nothing else you need to bring me.")
else
    wait(1)
    self.room:send(tostring(self.name) .. " refuses " .. tostring(obj_short) .. ".")
    self:say("No need for supplies, soldier.")
    self:command("salute " .. tostring(actor.name))
end
return true