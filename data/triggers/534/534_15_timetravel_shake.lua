-- Trigger: timetravel_shake
-- Zone: 534, ID: 15
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
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
-- TODO(parity): original DG checked `self.name == "%arg%"` (object self-name
-- against the typed argument). Runtime semantics for matching the typed item
-- to this object trigger should be confirmed; for now keep the legacy
-- string.find behavior.
if string.find(self.name, arg or "") then
    if actor:has_equipped(534, 24) then
        actor:send("You shake the glass globe up down vigorously.")
        self.room:send_except(actor, tostring(actor.name) .. " shakes a glass globe up down vigorously.")
        -- TODO(parity): legacy room vnum 53466 = zone 534/id 66 (Lirne's tower
        -- ruined), 53570 = zone 535/id 70 (intact past tower). actor.room is
        -- a Room object now; compare via zone_id/local_id.
        local rzone = actor.room.zone_id
        local rid = actor.room.local_id
        local at_present = (rzone == 534 and rid == 66)
        local at_past = (rzone == 535 and rid == 70)
        if at_present or at_past then
            self.room:send("The snow in the globe swirls...and your vision blurs for a second!")
            if at_present then
                self.room:teleport_all(get_room(534, 170))
                self.room:find_actor("all"):command("look")
                -- iterate group: hoist `a` out of the if/else so it's visible
                local a
                local i = actor.group_size
                if i then
                    a = 1
                else
                    a = 0
                end
                while i >= a do
                    local person = actor.group_member[a]
                    if person.room == actor.room then
                        if not person:get_quest_stage("frost_valley_quest") then
                            person:start_quest("frost_valley_quest")
                        end
                        person:set_quest_var("frost_valley_quest", "shake", 1)
                    elseif person then
                        i = i + 1
                    end
                    a = a + 1
                end
            elseif at_past then
                self.room:teleport_all(get_room(534, 66))
                self.room:find_actor("all"):command("look")
            end
        end
    else
        actor:send("You need to hold it to shake it!")
    end
end
return true