-- Trigger: **UNUSED** — superseded by 488/06 stormchild_fight
-- Zone: 488, ID: 53
-- Type: WORLD, Flags: GLOBAL
-- Status: DEAD_CODE
--
-- Original DG Script: #48853
--
-- DO NOT INVOKE. Logic was moved into the boss MOB FIGHT trigger (488/06)
-- where the targeted "Stop it, NAME!" lightning blast now lives. Body left in
-- place purely for archaeology — it still references DG-script remnants
-- (`tank` global, `string.find(tank, "person.name")` literal, vnum 48851 room
-- compare, block-scoped `local damage`) that are not worth fixing because
-- nothing calls this. If you ever need to revive it, port it cleanly rather
-- than patching.
-- TODO: delete this file after verifying no `run_room_trigger(488, 53)` /
-- equivalent invocation exists in any zone's triggers.
do return true end
-- This trigger is now handled in 48806
if not tank then
    return _return_value
end
local person = self.people
while person do
    local next = person.next_in_room
    if string.find(tank, "person.name") then
        if person.is_player then
            local damage = 390 + random(1, 40)
        else
            -- If a mob is tanking, hit it for massive damage!
            local damage = 1000 + random(1, 200)
        end
        -- Halve damage for sanc
        if person:has_effect(Effect.Sanctuary) then
            damage = damage / 2
        end
        self.room:send_except(person, "Lightning crackles around the Stormchild as she points a finger at " .. tostring(person.name) .. ".")
        person:send("Lightning crackles around the Stormchild as she points a finger at you!")
        wait(2)
        if person and (person.room == 48851) then
            local damage_dealt = person:damage(damage)  -- type: shock
            person:send("The lightning overloads, flowing into a shocking blast flowing straight for you!")
            self.room:send_except(person, "The lightning overloads, flowing into a shocking blast flowing straight for " .. tostring(person.name) .. "!")
            if damage_dealt == 0 then
                self.room:send_except(person, "<blue>The blast passes right through " .. tostring(person.name) .. "'s chest!</>")
                person:send("<blue>The blast goes right through you, striking the wall!</>")
            else
                self.room:send_except(person, "<blue>The blast strikes " .. tostring(person.name) .. " in the chest, throwing " .. tostring(person.object) .. " into the wall!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
                person:send("<blue>The blast strikes you square in the chest, throwing you into the wall!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            end
        else
            self.room:send("The lightning fizzles out around the Stormchild.")
        end
        tank = nil
        return _return_value
    end
    local person = next
end