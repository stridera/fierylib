-- Trigger: vial-drop
-- Zone: 484, ID: 23
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #48423

-- Converted from DG Script #48423: vial-drop
-- Original: OBJECT trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
if actor:get_quest_stage("doom_entrance") == 5 then
    if actor.room == 23731 then
        self.room:send("The vial of sunlight <b:white>flares brightly!</>")
        wait(2)
        self.room:send("<b:yellow>Sunlight fills the darkened cavern and voices cry out in pain!</>")
        local person = actor
        local i = person.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = actor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("doom_entrance") == 5 then
                    person.name:advance_quest("doom_entrance")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        self.room:send("&9<blue>The vial dissolves in a flash of light.</>")
        world.destroy(self)
    else
        self.room:send("Dropping the vial here would have no effect!")
    end
end
return _return_value