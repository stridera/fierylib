-- Trigger: dark servant fight
-- Zone: 489, ID: 25
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Doom dark-servant combat AI. Three branches at low chance:
--   * 10% hitall
--   * 10% (warrior variant only) re-target onto a stealthy player
--   * 10/20% reach a shadowy limb to drain life from a player and self-heal

-- Stop combat if our current target is another doom mobile (48900-48999)
-- and rest in a holding room while we recover.
if (actor.id >= 48900) and (actor.id <= 48999) then
    wait(1)
    get_room(11, 0):at(function()
        self.room:find_actor("dark-servant"):heal(1000)
    end)
end
wait(2)
local chance = random(1, 10)
if chance > 3 then
    -- 70% chance to do nothing this round.
    return true
elseif chance == 1 then
    -- 10% chance to hitall
    self:attack_all()
    return true
elseif (chance == 2) and (self.id == 48909) then
    -- 10% chance for the warrior dark-servant to re-target onto an
    -- Assassin or Thief in the room.
    local victim
    for _ = 1, 9 do
        local candidate = room.actors[random(1, #room.actors)]
        if candidate and (candidate.class == "Assassin" or candidate.class == "Thief") then
            victim = candidate
            break
        end
    end
    if victim and victim.is_player then
        combat.engage(victim)
    end
    return true
else
    -- Warrior servant: 10% chill-drain. Non-warrior servants: 20% chill-drain.
    -- Pick a non-doom player; fall back to the current attacker if it's the
    -- dark-servant's current victim and is itself a doom mob (matches the
    -- DG fallback path).
    local victim
    for _ = 1, 5 do
        local candidate = room.actors[random(1, #room.actors)]
        if candidate and ((candidate.id < 48900) or (candidate.id > 48999)) then
            victim = candidate
            break
        end
    end
    if not victim then
        if actor and (actor.id > 48900) and (actor.id < 48999) then
            victim = actor
        else
            return true
        end
    end
    local casters = "Sorcerer Cryomancer Pyromancer Necromancer Cleric Priest Diabolist Druid Conjurer Shaman"
    -- Be nice to casters
    local damage
    if string.find(casters, tostring(victim.class)) then
        damage = 200 + random(1, 30)
    else
        damage = 380 + random(1, 30)
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
