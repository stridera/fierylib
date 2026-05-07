-- Trigger: Templace Gate
-- Zone: 0, ID: 13
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #13
-- Greet at the city gate: high-level players are welcomed, low-level players
-- are gently teleported home, and immortals receive worship.

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end

if actor.is_immortal then
    self:say(tostring(actor.name) .. ", the gatekeeper falls to the ground and starts worshipping you!")
    self.room:send_except(actor, tostring(self.name) .. " falls to the ground in total awe of " .. tostring(actor.name) .. "'s power.")
    return true
end

if actor.level >= 80 then
    self:say("Hi " .. tostring(actor.name) .. ", welcome to the city of Templace!")
    self.room:send_except(actor, tostring(self.name) .. " welcomes " .. tostring(actor.name) .. ".")
else
    self:say("Hey " .. tostring(actor.name) .. ", this is too dangerous a place for you!")
    self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " doubtfully and makes a strange gesture.")
    actor:teleport(get_room(30, 1))
end
