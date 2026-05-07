-- Trigger: Random_Poison
-- Zone: 40, ID: 0
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #4000
-- Tainted-air poison effect on entry. Players below level 100 take
-- staggered poison ticks; if they're still alive after each one,
-- another (larger) tick lands a few pulses later. Echoes the player
-- and the room every time damage is applied.

if actor.level >= 100 then
    return true
end

local function tick(amount, msg_self, msg_room)
    actor:damage(amount)  -- type: poison
    actor:send(msg_self .. " (<green>" .. tostring(amount) .. "</>)")
    self.room:send_except(actor, msg_room .. " (<green>" .. tostring(amount) .. "</>)")
end

wait(1)
tick(5,
    "The tainted air fills your lungs with its cryptic essence.",
    tostring(actor.name) .. " begins to appear ill and faint.")
if actor.hp <= 0 then return true end

wait(4)
tick(15,
    "The poison rips into your body corrupting your blood.",
    tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain.")
if actor.hp <= 0 then return true end

wait(30)
tick(12,
    "The poison rips into your body corrupting your blood.",
    tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain.")
if actor.hp <= 0 then return true end

wait(30)
tick(15,
    "The poison rips into your body corrupting your blood.",
    tostring(actor.name) .. " bends over rasping and grabbing " .. tostring(actor.possessive) .. " chest in pain.")
