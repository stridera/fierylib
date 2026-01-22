-- Trigger: tempest_fight_room
-- Zone: 238, ID: 18
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23818

-- Converted from DG Script #23818: tempest_fight_room
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: SecretCommandToHurtPeople
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "secretcommandtohurtpeople")) then
    return true  -- No matching keywords
end
--
-- Lightning strikes half the number of people in the room
-- but not necessarily different people (mwahaha)
--
local howmany = #room.actors / 2
local count = 1
local truecount = 1
while count < howmany do
    local victim = room.actors[random(1, #room.actors)]
    if victim.id ~= 23803 then
        local damage = 150 + random(1, 30)
        if string.find(victim.flags, "SANCT") then
            damage = damage - 75
        elseif string.find(victim.flags, "STONE") then
            damage = damage - 75
        end
        local damage_dealt = victim:damage(damage)  -- type: shock
        if damage == 0 then
            victim:send("<b:blue>The lightning arcs off the Tempest Manifest, but is repelled from you!</>")
            self.room:send_except(victim, "<b:blue>Lightning arcs off the Tempest Manifest, but is repelled from " .. tostring(victim.name) .. "!</>")
        elseif string.find(victim.flags, "MAJOR_GLOBE") then
            victim:send("<b:red>The <blue>lightning <red>rips through the shimmering globe around your body and right into you!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "<b:red>The shimmering globe around " .. tostring(victim.name) .. "'s body wavers as the <blue>lightning <red>rips through it.</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
        else
            victim:send("<b:blue>The lightning arcs off the Tempest Manifest and into your body, causing your muscles to spasm wildly!</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
            self.room:send_except(victim, "<b:blue>Lightning arcs off the Tempest Manifest, jolting " .. tostring(victim.name) .. " with massive force!</> (<yellow>" .. tostring(damage_dealt) .. "</>)")
        end
        count = count + 1
    end
    truecount = truecount + 1
    if truecount > 15 then
        count = howmany
    end
end