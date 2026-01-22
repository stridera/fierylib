-- Trigger: ice elemental lord - damage
-- Zone: 486, ID: 31
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48631

-- Converted from DG Script #48631: ice elemental lord - damage
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Hit half as many people are in the room
local negatecold = "!COLD"
local pop = self.actor_count / 2
local max = 15
local count = 1
self.room:send("<b:cyan>The Ice Elemental Lord crashes into the wall, bringing down a shower of ice!</>")
while count <= pop do
    local victim = room.actors[random(1, #room.actors)]
    -- Don't hit the Ice Elemental Lord
    if victim.id ~= 48632 then
        local flags = victim.aff_flags
        -- Base damage between 100 and 130
        local damage = 100 + random(1, 30)
        if string.find(flags, "SANCT") then
            local damage = damage / 2
        end
        if string.find(flags, "WATERFORM") then
            -- Heal players with waterform
            victim:send("<b:blue>The falling ice melts into your body!</> (<green>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. "'s body absorbs the falling ice!</> (<yellow>" .. tostring(damage) .. "</>)")
            victim:heal(damage)
        elseif (string.find(flags, "negatecold")) or (string.find(flags, "PROT_COLD")) then
            -- No effect for negate cold or elemental warding for ice
            victim:send("<cyan>The falling ice bounces off your skin, settling lightly on the floor.</>")
            self.room:send_except(victim, "<cyan>The falling ice bounces off " .. tostring(victim.name) .. "'s skin, settling lightly on the floor.</>")
        elseif string.find(flags, "FIRESHIELD") then
            -- No effect for fireshield
            victim:send("<cyan>The barrage of ice <yellow>vaporizes<cyan> as it touches the <red>flames<cyan> around your body!</>")
            self.room:send_except(victim, "<cyan>The barrage of ice <yellow>vaporizes<cyan> on the <red>flames<cyan> about " .. tostring(victim.name) .. "'s body!</>")
        elseif string.find(flags, "BLUR") then
            -- Decrease damage for blur
            local damage = damage - 35
            victim:send("<cyan>You dance through the barrage and only a few blocks of ice strike you!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>Dancing through the barrage, " .. tostring(victim.name) .. " is struck by few ice blocks.</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        elseif string.find(flags, "FLY") then
            -- Decrease damage for fly
            local damage = damage / 2
            victim:send("<cyan>You dart through the air, missing much of the falling ice!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " darts through the air, evading much of the falling ice!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        elseif string.find(flags, "STONE") then
            -- Increase damage for stone skin
            local damage = damage + 60
            victim:send("<cyan>Slowed by your stony skin, you are unable to dodge a slab of falling ice!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>Unable to dodge, " .. tostring(victim.name) .. " takes the full brunt of the hail!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        else
            -- Hit everyone else
            victim:send("<cyan>As you look up, a huge block of ice strikes you on the head!</> (<b:red>" .. tostring(damage) .. "</>)")
            self.room:send_except(victim, "<cyan>A hail of icy shards crashes down upon " .. tostring(victim.name) .. "!</> (<blue>" .. tostring(damage) .. "</>)")
            local damage_dealt = victim:damage(damage)  -- type: physical
        end
        local count = count + 1
    end
    local max = max - 1
    if max < 1 then
        local count = pop + 1
    end
end