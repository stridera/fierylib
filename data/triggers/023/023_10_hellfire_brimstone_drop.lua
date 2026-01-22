-- Trigger: hellfire_brimstone_drop
-- Zone: 23, ID: 10
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #2310

-- Converted from DG Script #2310: hellfire_brimstone_drop
-- Original: WORLD trigger, flags: DROP, probability: 100%
wait(1)
if actor:get_quest_stage("hellfire_brimstone") == 1 then
    if object.id == 2338 then
        self.room:send("The bonfire crackles and roars!")
        world.destroy(object)
        wait(1)
        self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Ah, such a pleasing sacrifice.'")
        local meat = actor:get_quest_var("hellfire_brimstone:meat") + 1
        actor.name:set_quest_var("hellfire_brimstone", "meat", meat)
        if actor:get_quest_var("hellfire_brimstone:meat") >= 6 then
            wait(1)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'This should be enough.  The Dark One is paying_attention now.'")
            actor.name:advance_quest("hellfire_brimstone")
            actor.name:set_quest_var("hellfire_brimstone", "drop", 0)
            wait(2)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'The next step is collecting the very soil of Hell_itself: brimstone.  Brimstone can be found in and around volcanoes.  The fiery_spirits that dwell there should collect it naturally.'")
            wait(5)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Six quantities of brimstone are necessary to make the_proper diagram for summoning hellfire.  Bring them here and <b:red>[drop]</> them'")
        else
            wait(2)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Bring some more.'")
        end
    end
elseif actor:get_quest_stage("hellfire_brimstone") == 2 then
    if object.id == 2337 then
        self.room:send(tostring(mobiles.template(23, 11).name) .. " draws out lines with the brimstone.")
        world.destroy(object)
        self.room:send(tostring(mobiles.template(23, 11).name) .. " flashes a wicked grin.")
        self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'It will burn like the very bowels of Hell.'")
        local brimstone = actor:get_quest_var("hellfire_brimstone:brimstone") + 1
        actor.name:set_quest_var("hellfire_brimstone", "brimstone", brimstone)
        if actor:get_quest_var("hellfire_brimstone:brimstone") >= 6 then
            wait(2)
            self:command("nod")
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'The Dark One is pleased with your efforts.'")
            actor.name:advance_quest("hellfire_brimstone")
            actor.name:set_quest_var("hellfire_brimstone", "drop", 0)
            wait(2)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Finally, gather six different types of fiery tribute:'")
            self.room:send("- three colors of flame:")
            self.room:send("</>&9<blue>    black</> from Chaos incarnate")
            self.room:send("</><blue>    gray</> from a devotee of neutrality")
            self.room:send("</><b:white>    white</> from a beam of starlight")
            self.room:send("- a torch carried by an actress pretending to be a goddess")
            self.room:send("- a dagger carried by the volcano goddess")
            self.room:send("- a fiery sword wielded by a king in his throne room crypt")
            wait(6)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Return with these six fires and by six given thrice,_the spell shall be complete.'")
        else
            wait(2)
            self.room:send(tostring(mobiles.template(23, 11).name) .. " says, 'Bring some more.'")
        end
    end
end