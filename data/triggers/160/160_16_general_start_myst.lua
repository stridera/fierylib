-- Trigger: general_start_myst
-- Zone: 160, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16016

-- Converted from DG Script #16016: general_start_myst
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor.id == -1 then
    if object.id == 3026 then
        -- advance the quest
        local i = actor.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("mystwatch_quest") then
                    person.name:set_quest_var("mystwatch_quest", "step", "general")
                    person:send("<b:white>You have delivered the totem to the General!</>")
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        local myst_gen_active = 1
        globals.myst_gen_active = globals.myst_gen_active or true
        wait(1)
        world.destroy(self.room:find_actor("totem"))
        self.room:send(tostring(self.name) .. " starts to examine the totem which begins to glow and hum.")
        wait(2)
        self:say("So, that fool Magistrate down in the forest town is such a coward that he must send the likes of YOU to do his bidding.")
        wait(2)
        self:say("Well... I shall have to make examples of you all now...")
        self:command("cackle")
        wait(1)
        combat.engage(self, actor.name)
    else
        wait(1)
        self:say("Thank you, thank you very much.")
    end
end