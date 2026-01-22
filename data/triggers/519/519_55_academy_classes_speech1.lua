-- Trigger: academy_classes_speech1
-- Zone: 519, ID: 55
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51955

-- Converted from DG Script #51955: academy_classes_speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: loot
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "loot")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 4 and not actor:get_quest_var("school:loot") then
    actor:set_quest_var("school", "loot", 1)
    actor:send(tostring(self.name) .. " tells you, 'When something dies, it usually leaves behind a <b:yellow>corpse</>.'")
    wait(1)
    self:command("poke " .. tostring(actor))
    actor:send(tostring(self.name) .. " tells you, 'That goes for you too kid.'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'A corpse is like a container.")
    actor:send("You can <b:cyan>EXAMINE corpse</> it to see what it has on it.")
    actor:send("You can <b:cyan>GET [object] corpse</> to take something specific, or you can <b:cyan>GET ALL corpse</> to take everything on it.")
    actor:send("Corpses keep their names as keywords so you can use those too.")
    actor:send("</>")
    actor:send("You can't pick up a corpse, but you can <b:cyan>DRAG</> them from room to room.")
    actor:send("You need <b:cyan>CONSENT</> to drag a player corpse though.")
    actor:send("</>")
    actor:send("If YOU die, you have to trudge all the way back to the room you died in, then get everything from your body, like <b:cyan>GET ALL corpse</>, to get your stuff.'")
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'For now loot this monster by typing <b:green>get all corpse</>.'")
elseif actor:get_quest_stage("school") == 3 and actor:get_quest_var("school:fight") == "last" then
    actor:send(tostring(self.name) .. " tells you, 'You need to <b:green>kill monster</> first!'")
    self.room:spawn_mobile(519, 0)
end