-- Trigger: timetravel_shake
-- Zone: 534, ID: 15
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #53415

-- Converted from DG Script #53415: timetravel_shake
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: shake
if not (cmd == "shake") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "s" or cmd == "sh" then
    _return_value = false
    return _return_value
end
if string.find(self.name, "arg") then
    if actor:has_equipped("53424") then
        actor:send("You shake the glass globe up and down vigorously.")
        self.room:send_except(actor, tostring(actor.name) .. " shakes a glass globe up and down vigorously.")
        if actor.room == 53466 or actor.room == 53570 then
            self.room:send("The snow in the globe swirls...and your vision blurs for a second!")
            if actor.room == 53466 then
                self.room:teleport_all(get_room(535, 70))
                self.room:find_actor("all"):command("look")
                local person = actor
                local i = person.group_size
                if i then
                    local a = 1
                else
                    local a = 0
                end
                while i >= a do
                    local person = actor.group_member[a]
                    if person.room == actor.room then
                        if not person:get_quest_stage("frost_valley_quest") then
                            person:start_quest("frost_valley_quest")
                        end
                        person:set_quest_var("frost_valley_quest", "shake", 1)
                    elseif person then
                        local i = i + 1
                    end
                    local a = a + 1
                end
            elseif actor.room == 53570 then
                self.room:teleport_all(get_room(534, 66))
                self.room:find_actor("all"):command("look")
            end
        end
    else
        actor:send("You need to hold it to shake it!")
    end
else
    _return_value = false
end
return _return_value