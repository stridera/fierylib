-- Trigger: Moonwell Map 5 Receive
-- Zone: 163, ID: 63
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16363

-- Converted from DG Script #16363: Moonwell Map 5 Receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("moonwell_spell_quest") == 11 then
    if actor:get_quest_var("moonwell_spell_quest:map") == 1 then
        wait(15)
        self:destroy_item("map")
        self.room:spawn_object(163, 66)
        self.room:send(tostring(self.name) .. " completes her drawing on the bark map.")
        wait(15)
        self:command("give map " .. tostring(actor.name))
        if actor.gender == "female" then
            actor:send(tostring(self.name) .. " tells you, 'Keep that map Sister, that you may never forget how to")
            actor:send("</>conduct this ceremony.'")
        else
            actor:send(tostring(self.name) .. " tells you, 'Keep that map Brother, that you may never forget how to")
            actor:send("</>conduct this ceremony.'")
        end
        wait(20)
        actor:send(tostring(self.name) .. " tells you, 'Let us finish the ceremony.'")
        self.room:send(tostring(self.name) .. " places " .. tostring(objects.template(550, 20).name) .. " at the edge of the circle and prays.")
        wait(5)
        self.room:send("<magenta>A </>moonwell <magenta>appears at " .. tostring(self.name) .. "'s feet!</>")
        wait(20)
        self.room:send("<b:cyan>The moonwell beings to <b:magenta>swirl</>!")
        wait(25)
        -- mecho &5A swirling &0moonwell &5appears at %self.name%'s feet!&0
        run_room_trigger(16348)
        wait(30)
        self.room:send("A soft yet loud voice says, 'You have done well young dryad.  Perhaps you truly")
        self.room:send("</>are repentant.  For your service, I release you from your shackles.'")
        wait(10)
        self.room:send("The voice says, 'Remember this always.'")
        wait(15)
        self.room:send("A bright flash of light pierces the area and the dryad is transformed into a beautiful mortal woman!")
        wait(10)
        self.room:send("The beautiful druid says, 'Thank you my Goddess, Mielikki!  At last, I am free")
        self.room:send("</>again!'")
        wait(2)
        self.room:send("The beautiful druid bows deeply, enters the moonwell and disappears!")
        actor.name:complete_quest("moonwell_spell_quest")
        skills.set_level(actor.name, "moonwell", 100)
        world.destroy(self)
    else
        _return_value = false
        self:command("shake")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'I need the ring first.'")
    end
end
return _return_value