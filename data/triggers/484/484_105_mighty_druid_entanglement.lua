-- Trigger: mighty_druid entanglement
-- Zone: 484, ID: 105
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48505
--
-- Entangles up to four players at a time. The slots are the DG globals
-- `paralysis_victim_N` / `paralysis_expire_N` (N = 1..4) and `message`, kept in this mob's
-- `globals` table so the wear-off pulse (484_104) and the paralysis_prevent_* command
-- blockers (484_130..) see the same state. The expiry stamp is unix seconds (`time.stamp`).

local now = time.stamp
for n = 1, 4 do
    local v = globals["paralysis_victim_" .. n]
    if v and (v.room ~= self.room or (globals["paralysis_expire_" .. n] or 0) <= now) then
        -- Clear paralysis on expired victim
        if v.room == self.room then
            self.room:send_except(v, "<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
            v:send("<green>The crop of roots recedes, releasing you from its grasp.</>")
        else
            self.room:send("<green>The crop of roots recedes, releasing " .. tostring(v.name) .. " from its grasp.</>")
        end
        globals["paralysis_victim_" .. n] = nil
    end
end
-- 25% chance to do creeping doom proc
if random(1, 4) == 1 then
    wait(2)
    run_room_trigger(484, 103)
    return
end
-- 75% chance to attempt to entangle: use the first free slot; the more slots are taken, the
-- lower the chance (50%, 33%, 25%, 20%); quit if all four are taken.
local slot = 1
while slot <= 4 and globals["paralysis_victim_" .. slot] do
    slot = slot + 1
end
if slot > 4 then
    return
end
if random(1, 2 * slot + 2) > 3 then
    return
end

local function entangled(person)
    for n = 1, 4 do
        local v = globals["paralysis_victim_" .. n]
        if v and v.name == person.name then
            return true
        end
    end
    return false
end

-- find a victim, preferably an assassin, but settle for any player if no assassin is found
local victim, secondary_victim
local max_tries = 10
while max_tries >= 0 do
    victim = self.room.actors[random(1, #self.room.actors)]
    if victim and victim.is_player then
        if entangled(victim) then
            victim = self
        elseif victim.class == "assassin" then
            max_tries = 0
        else
            secondary_victim = victim
        end
    end
    max_tries = max_tries - 1
end
-- quit if no players
if not (victim and victim.is_player) then
    if secondary_victim then
        victim = secondary_victim
    else
        return
    end
end
wait(2)
self.room:send_except(victim, tostring(self.name) .. " snarls and waves a hand at the ground at " .. tostring(victim.name) .. "'s feet.")
victim:send(tostring(self.name) .. " snarls at you and waves a hand at the ground around your feet!")
self.room:send_except(victim, "<green>A crop of wriggling roots bursts from the ground, entangling " .. tostring(victim.name) .. "!</>")
victim:send("<green>A crop of wriggling roots bursts from the ground, entangling you!</>")
-- declare paralysis message
globals.message = "<green>The roots lock you in place, preventing movement!</>"
-- create a basher to force the player into a bashed stance
if (victim.size == "Small") or (victim.size == "Tiny") then
    -- Basher is medium
    self.room:spawn_mobile(484, 115)
elseif (victim.size == "Large") or (victim.size == "Huge") or (victim.size == "Giant") then
    -- Basher is huge
    self.room:spawn_mobile(484, 113)
else
    -- Basher is large
    self.room:spawn_mobile(484, 114)
end
self.room:find_actor("bashing-roots"):spawn_object(10, 16)
self.room:find_actor("bashing-roots"):command("mat 1100 wear shield")
victim:command("stand")
self.room:find_actor("bashing-roots"):command("bash " .. tostring(victim.name))
self.room:find_actor("bashing-roots"):destroy_item("shield")
world.destroy(self.room:find_actor("bashing-roots"))
-- reinitiate combat if victim was tanking
if actor.name == victim.name then
    wait(2)
    combat.engage(self, victim.name)
end
-- save victim variable
globals["paralysis_victim_" .. slot] = victim
globals["paralysis_expire_" .. slot] = now + 1
