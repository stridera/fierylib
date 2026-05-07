-- Trigger: tempest_fight_room
-- Zone: 238, ID: 18
-- Type: WORLD, Flags: SPEECH
--
-- Run-from-other-trigger entry point fired by tempest_fight (238:17). The
-- Tempest's lightning AoE hits roughly half the people in the room (with
-- replacement, so a target may be struck more than once). Major-globe halves
-- final damage one more time on top; sanctuary or stone-skin take 75 off the
-- raw roll. The Tempest itself (238:3) is excluded.

-- Speech keywords: SecretCommandToHurtPeople
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "secretcommandtohurtpeople") then
    return true  -- No matching keywords
end

local howmany = math.floor(self.room.actor_count / 2)
local hits = 0
local iterations = 0
while hits < howmany do
    iterations = iterations + 1
    -- Bail out if we somehow can't find enough valid targets
    if iterations > 15 then
        break
    end
    local actors = self.room.actors
    if #actors == 0 then
        break
    end
    local victim = actors[random(1, #actors)]
    if not (victim.zone_id == 238 and victim.local_id == 3) then
        local damage = 150 + random(1, 30)
        if victim:has_effect(Effect.Sanctuary) then
            damage = damage - 75
        elseif victim:has_effect(Effect.Stone) then
            damage = damage - 75
        end
        local globed = victim:has_effect(Effect.Major_Globe)
        if globed then
            damage = math.floor(damage / 2)
        end
        local damage_dealt = victim:damage(damage)  -- type: shock
        if damage_dealt == 0 then
            victim:send("<b:blue>The lightning arcs off the Tempest Manifest, but is repelled from you!</>")
            self.room:send_except(victim, "<b:blue>Lightning arcs off the Tempest Manifest, but is repelled from " .. tostring(victim.name) .. "!</>")
        elseif globed then
            victim:send("<b:red>The <blue>lightning <red>rips through the shimmering globe around your body and right into you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "<b:red>The shimmering globe around " .. tostring(victim.name) .. "'s body wavers as the <blue>lightning <red>rips through it.</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
        else
            victim:send("<b:blue>The lightning arcs off the Tempest Manifest and into your body, causing your muscles to spasm wildly!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "<b:blue>Lightning arcs off the Tempest Manifest, jolting " .. tostring(victim.name) .. " with massive force!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
        end
        hits = hits + 1
    end
end
