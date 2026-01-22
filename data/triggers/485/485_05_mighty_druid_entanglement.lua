-- Trigger: mighty_druid entanglement
-- Zone: 485, ID: 5
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 31 if statements
--   Large script: 7559 chars
--
-- Original DG Script: #48505

-- Converted from DG Script #48505: mighty_druid entanglement
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local now = time.stamp
if paralysis_victim_1 and ((paralysis_victim_1.room ~= self.room) or (paralysis_expire_1 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_1.room == self.room then
        self.room:send_except(paralysis_victim_1, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
        paralysis_victim_1:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_1.name) .. " from its grasp.</>")
    end
    paralysis_victim_1 = nil
end
if paralysis_victim_2 and ((paralysis_victim_2.room ~= self.room) or (paralysis_expire_2 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_2.room == self.room then
        self.room:send_except(paralysis_victim_2, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
        paralysis_victim_2:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_2.name) .. " from its grasp.</>")
    end
    paralysis_victim_2 = nil
end
if paralysis_victim_3 and ((paralysis_victim_3.room ~= self.room) or (paralysis_expire_3 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_3.room == self.room then
        self.room:send_except(paralysis_victim_3, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
        paralysis_victim_3:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_3.name) .. " from its grasp.</>")
    end
    paralysis_victim_3 = nil
end
if paralysis_victim_4 and ((paralysis_victim_4.room ~= self.room) or (paralysis_expire_4 <= now)) then
    -- Clear paralysis on expired victim
    if paralysis_victim_4.room == self.room then
        self.room:send_except(paralysis_victim_4, "<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
        paralysis_victim_4:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
    else
        self.room:send("<green>The crop of roots recedes, releasing " .. tostring(paralysis_victim_4.name) .. " from its grasp.</>")
    end
    paralysis_victim_4 = nil
end
-- 25% chance to do creeping doom proc
local mode = random(1, 4)
if mode == 1 then
    wait(2)
    run_room_trigger(48503)
    return _return_value
end
-- 75% chance to attempt to entangle
if (not paralysis_victim_1) or (not paralysis_victim_2) or (not paralysis_victim_3) or (not paralysis_victim_4) then
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                if paralysis_victim_4 then
                    -- quit if four people already entangled
                    return _return_value
                else
                    -- 20% chance if three people are entangled
                    local chance = random(1, 10)
                end
            else
                -- 25% chance if two people are entangled
                local chance = random(1, 8)
            end
        else
            -- 33% chance if one person is already entangled
            local chance = random(1, 6)
        end
    else
        -- 50% chance if no one is already entangled
        local chance = random(1, 4)
    end
    if chance > 3 then
        return _return_value
    end
    local max_tries = 10
    while max_tries >= 0 do
        -- find a victim, preferably an assassin
        -- but will settle for any player if no assassin found
        local victim = room.actors[random(1, #room.actors)]
        if victim.id == -1 then
            if (paralysis_victim_1 and (paralysis_victim_1.name == victim.name)) or (paralysis_victim_2 and (paralysis_victim_2.name == victim.name)) or (paralysis_victim_3 and (paralysis_victim_3.name == victim.name)) then
                local victim = self
            elseif victim.class == "Assassin" then
                local max_tries = 0
            else
                local secondary_victim = victim
            end
        end
        local max_tries = max_tries - 1
    end
    -- quit if no players
    if victim.id == -1 then
    elseif secondary_victim then
        local victim = secondary_victim
    else
        return _return_value
    end
    wait(2)
    self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
    victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
    self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
    victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
    -- declare paralysis message
    local message = "&2The roots lock you in place, preventing movement!&0"
    globals.message = globals.message or true
    -- create a basher to force the player into a bashed stance
    if (victim.size == "Small") or (victim.size == "Tiny") then
        -- Basher is medium
        self.room:spawn_mobile(485, 15)
    elseif (victim.size == "Large") or (victim.size == "Huge") or (victim.size == "Giant") then
        -- Basher is huge
        self.room:spawn_mobile(485, 13)
    else
        -- Basher is large
        self.room:spawn_mobile(485, 14)
    end
    self.room:find_actor("bashing-roots"):spawn_object(10, 16)
    self.room:find_actor("bashing-roots"):command("mat 1100 wear shield")
    victim:command("stand")
    self.room:find_actor("bashing-roots"):command("bash %victim.name%")
    self.room:find_actor("bashing-roots"):destroy_item("shield")
    world.destroy(self.room:find_actor("bashing-roots"))
    -- reinitiate combat if victim was tanking
    if actor.name == victim.name then
        wait(2)
        combat.engage(self, victim.name)
    end
    -- save victim variable
    if paralysis_victim_1 then
        if paralysis_victim_2 then
            if paralysis_victim_3 then
                local paralysis_victim_4 = victim
                globals.paralysis_victim_4 = globals.paralysis_victim_4 or true
                local paralysis_expire_4 = now + 1
                globals.paralysis_expire_4 = globals.paralysis_expire_4 or true
            else
                local paralysis_victim_3 = victim
                globals.paralysis_victim_3 = globals.paralysis_victim_3 or true
                local paralysis_expire_3 = now + 1
                globals.paralysis_expire_3 = globals.paralysis_expire_3 or true
            end
        else
            local paralysis_victim_2 = victim
            globals.paralysis_victim_2 = globals.paralysis_victim_2 or true
            local paralysis_expire_2 = now + 1
            globals.paralysis_expire_2 = globals.paralysis_expire_2 or true
        end
    else
        local paralysis_victim_1 = victim
        globals.paralysis_victim_1 = globals.paralysis_victim_1 or true
        local paralysis_expire_1 = now + 1
        globals.paralysis_expire_1 = globals.paralysis_expire_1 or true
    end
end