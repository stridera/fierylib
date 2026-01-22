-- Trigger: dark servant fight
-- Zone: 489, ID: 25
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48925

-- Converted from DG Script #48925: dark servant fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
if (actor.id >= 48900) and (actor.id <= 48999) then
    -- Stop combat if fighting another doom mobile
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("dark-servant"):heal(1000)
    end)
end
wait(2)
local chance = random(1, 10)
if chance > 3 then
    -- Short-circuit
    return _return_value
elseif chance == 1 then
    -- 10% chance to hitall
    self:attack_all()
    return _return_value
elseif (chance == 2) and (self.id == 48909) then
    -- 10% chance to switch to an assassin, if this is the warrior dark servant
    local max_tries = 9
    while max_tries > 0 do
        local victim = room.actors[random(1, #room.actors)]
        if (victim.class == "Assassin") or (victim.class == "Thief") then
            local max_tries = 0
        end
        local max_tries = max_tries - 1
    end
    if (max_tries == -1) and (victim.id == -1) then
        combat.engage(self, victim.name)
        return _return_value
    end
    return _return_value
else
    -- If warrior servant, 10% chance to chill someone, stealing their hp
    -- If nonwarrior servant, 20% chance
    -- Attempt to get a player no more than max_tries times
    local max_tries = 5
    while max_tries > 0 do
        local victim = room.actors[random(1, #room.actors)]
        if victim and ((victim.id < 48900) or (victim.id > 48999)) then
            local max_tries = 0
        end
        local max_tries = max_tries - 1
    end
    if max_tries == -1 then
        if (victim.id > 48900) and (victim.id < 48999) and actor then
            local victim = actor
        else
            return _return_value
        end
    else
        return _return_value
    end
    local casters = "Sorcerer Cryomancer Pyromancer Necromancer Cleric Priest Diabolist Druid Conjurer Shaman"
    -- Be nice to casters
    if string.find(casters, victim.class) then
        local damage = 200 + random(1, 30)
    else
        local damage = 380 + random(1, 30)
    end
    local damage_dealt = victim:damage(damage)  -- type: heal
    if damage_dealt == 0 then
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", but cannot draw out any life. (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, but cannot draw out any life. (<b:red>" .. tostring(damage_dealt) .. "</>)")
    else
        self.room:send_except(victim, tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards " .. tostring(victim.name) .. ", <b:blue>chilling</> " .. tostring(victim.object) .. " to the <b:white>bone</>! (<blue>" .. tostring(damage_dealt) .. "</>)")
        victim:send(tostring(self.name) .. " reaches a <blue>&9shadowy</> limb towards you, <b:blue>chilling</> you to the <b:white>bone</>! (<b:red>" .. tostring(damage_dealt) .. "</>)")
    end
    local amount = damage_dealt * 2
    self.room:find_actor("dark-servant"):heal(amount)
end