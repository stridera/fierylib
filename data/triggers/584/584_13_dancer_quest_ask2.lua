-- Trigger: Dancer_quest_ASK2
-- Zone: 584, ID: 13
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58413
--
-- Confirms the dancer's quest start and advances to stage 2; the prince
-- chimes in afterwards if he's still in the room.

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

if not actor.is_player then
    return true
end
if actor:get_quest_stage("major_spell_quest") ~= 1 then
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says to you, 'Oh thank you!'")
actor:send(tostring(self.name) .. " says to you, 'You must gain the princes favor..'")
actor:send(tostring(self.name) .. " says to you, 'then maybe he will give me to you so you can set me free.'")
self.room:send_except(actor, tostring(self.name) .. " whispers something to " .. tostring(actor.name))
actor:advance_quest("major_spell_quest")  -- advances to stage 2
wait(5)

local prince = self.room:find_actor("prince")
if prince then
    prince:say("Hey, what are you talking to them about?!")
    prince:command("sigh")
    wait(2)
    prince:say("You can't get good help now days...")
end