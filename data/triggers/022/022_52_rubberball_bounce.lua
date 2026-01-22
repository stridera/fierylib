-- Trigger: RubberBall_Bounce
-- Zone: 22, ID: 52
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #2252

-- Converted from DG Script #2252: RubberBall_Bounce
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: bounce
if not (cmd == "bounce") then
    return true  -- Not our command
end
actor:send("The <b:green>green ball</> ricochets off the ground and <b:red>smacks</> your chin.")
self.room:send_except(actor, tostring(actor.name) .. " bounces the <b:green>ball</>.  It ricochets off the ground, <b:red>smacking</> " .. tostring(actor.object) .. " in the <b:red><b:yellow>jaw</></>.")
wait(3)
actor:send("You slump to the ground, <b:red>knocked out</> from the sudden blow from a <b:green>green ball</>.")
self.room:send_except(actor, tostring(actor.name) .. " slumps to the ground, <b:red>knocked out</> from the sudden blow from a <b:green>green ball</>.")
wait(8)
actor:send("As you are <b:cyan>awaken</>, you feel obligated to relay your <b:white>vision</> to the group...")
self.room:send_except(actor, "As " .. tostring(actor.name) .. "  <b:cyan>awakens</>, " .. tostring(actor.name) .. " tells you of " .. tostring(actor.possessive) .. " <b:white>vision</>...")
wait(4)
self.room:send("Held by a <b:yellow>scarred hunter</> who has hunted nearly as many as have <b:red>hunted</> him!")
self.room:send("His body witness to his <b:yellow>warrior prowess</> and acts of <b:blue>pride</> for his fellow people.")