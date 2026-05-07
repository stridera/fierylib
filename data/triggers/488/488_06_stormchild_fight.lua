-- Trigger: stormchild fight
-- Zone: 488, ID: 6
-- Type: MOB, Flags: FIGHT
-- Status: REVIEWED
--
-- Original DG Script: #48806
--
-- Behavior: 50% chance per fight tick. Branches:
--   - 40%: invoke 488/51 (stormchild_heal) — area lightning + self-heal flavor.
--   - 30%: invoke 488/52 (thunder wave) — AoE crush against non-zone actors.
--   - 30%: targeted shock blast on `actor`. Mobs tanking eat massive damage to
--     dissuade pet/charm cheese. Sanctuary halves. Actor must still be in the
--     stormchild's room (488/51) when the blast lands.

-- 50% chance to trigger
if not percent_chance(50) then
    return true
end
wait(1)
local mode = random(1, 10)
if mode < 5 then
    self.room:send("<cyan>A sudden gale starts from nowhere, throwing lightning everywhere!</>")
    wait(1)
    run_room_trigger(488, 51)
elseif mode < 8 then
    wait(1)
    run_room_trigger(488, 52)
else
    self:emote("cries, 'Stop it, " .. tostring(actor.name) .. "!'")
    local damage
    if actor.is_player then
        damage = 390 + random(1, 40)
    else
        -- If a mob is tanking, hit it for massive damage!
        damage = 1000 + random(1, 200)
    end
    -- Halve damage for sanc
    if actor:has_effect(Effect.Sanctuary) then
        damage = damage / 2
    end
    self.room:send_except(actor, "Lightning crackles around the Stormchild as she points a finger at " .. tostring(actor.name) .. ".")
    actor:send("Lightning crackles around the Stormchild as she points a finger at you!")
    wait(2)
    if actor and (actor.room == get_room(488, 51)) then
        actor:send("The lightning overloads, flowing into a shocking blast flowing straight for you!")
        self.room:send_except(actor, "The lightning overloads, flowing into a shocking blast flowing straight for " .. tostring(actor.name) .. "!")
        local damage_dealt = actor:damage(damage)  -- type: shock
        if damage_dealt == 0 then
            actor:send("<blue>The blast plays harmlessly over your body.</>")
            self.room:send_except(actor, "<blue>The blast plays harmlessly over " .. tostring(actor.name) .. "'s body.</>")
        else
            self.room:send_except(actor, "<blue>The blast strikes " .. tostring(actor.name) .. " in the chest, throwing " .. tostring(actor.object) .. " into the wall!</> (<blue>" .. tostring(damage_dealt) .. "</>)")
            actor:send("<blue>The blast strikes you square in the chest, throwing you into the wall!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
        end
    else
        self.room:send("The lightning fizzles out around the Stormchild.")
    end
end