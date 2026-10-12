-- Ethilien Training Academy (zone 519) tutorial fixes: speech phrases that never matched, exit-block hints (playtest round 5 N4).
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- body (md5), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/519/519_02_academy_instructor_hello_class.lua
  (519, 2, $trig$-- Converted from DG Script #51902: academy_instructor_hello_class
-- Original: MOB trigger, flags: SPEECH_TO, probability: 0%

-- Speech phrase: hello class (the DG arg 0 is "contains the phrase", not a chance)
if not string.find(string.lower(speech), "hello class", 1, true) then
    return true  -- Not the phrase
end
if actor:get_quest_var("school:speech") == 1 then
    actor:set_quest_var("school", "speech", 2)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Exactly!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'You can talk to one person at a time by using the <b:cyan>(T)ELL</> command.")
    actor:send("Only the person you TELL to will hear what you say.")
    actor:send("You can talk to anyone, anywhere in the world.")
    actor:send("You do it by typing <b:cyan>tell [person] [message]</>'")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Try typing <b:green>tell instructor hello teacher</>.'")
end$trig$, 'd4b9ed2a78ac3c26914edbbe9c939b57'),
  -- data/triggers/519/519_03_academy_instructor_speech2.lua
  (519, 3, $trig$-- Converted from DG Script #51903: academy_instructor_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: hello teacher (the DG arg 0 is "contains the phrase", not a chance)
if not string.find(string.lower(speech), "hello teacher", 1, true) then
    return true  -- Not the phrase
end
if actor:get_quest_var("school:speech") == 2 then
    actor:set_quest_var("school", "speech", 3)
    wait(2)
    actor:send(tostring(self.name) .. " tells you, 'Well hello yourself!  You're learning well!'")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Mass communication channels include:'")
    -- (empty send to actor)
    actor:send("</><b:cyan>(GOS)SIP</> which talks to everyone in the game at once.")
    actor:send("</>   It's definitely the most popular communication channel.")
    actor:send("</>   It's a great way to ask questions or get help.")
    -- (empty send to actor)
    actor:send("</><b:cyan>(SH)OUT</> which talks to everyone in your zone.")
    -- (empty send to actor)
    actor:send("</><b:cyan>(PETI)TION</> which talks to all the Gods currently online.")
    actor:send("</>   It's best for asking semi-private or admin questions.")
    -- (empty send to actor)
    actor:send("</><b:cyan>GROUPSAY</> or <b:cyan>GSAY</> talks to everyone you're grouped with.")
    actor:send("</>   Check <b:cyan>HELP GROUP</> for more information on grouping.")
    -- (empty send to actor)
    actor:send("You can also use <b:cyan>LASTGOS</> and <b:cyan>LASTTEL</> to see what the last messages you received were.")
    -- (empty send to actor)
    actor:send("To see who's logged on, use the <b:cyan>WHO</> command.")
    wait(3)
    actor:send(tostring(self.name) .. " tells you, 'Do you have any questions about communication?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '31e5d6f2f5696f3f9108d185ed8d3e81'),
  -- data/triggers/519/519_77_academy_class_blocker.lua
  (519, 77, $trig$-- Converted from DG Script #51977: academy_class_blocker
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: east
if not (cmd == "east") then
    return true  -- Not our command
end
local stage = actor:get_quest_stage("school")
if stage < 5 then
    actor:send(tostring(self.name) .. " tells you, 'You're not quite ready to move on yet!'")
    -- Say what to do about it (the original gave no hint).
    if stage == 3 then
        actor:send(tostring(self.name) .. " tells you, 'Finish the combat lessons here first, or say <magenta>SKIP</> to move on to <b:yellow>LOOT</> and <b:yellow>TOGGLES</>.  You can also say <magenta>EXIT</> to leave the Academy.'")
    elseif stage == 4 then
        actor:send(tostring(self.name) .. " tells you, 'Finish the <b:yellow>LOOT</> and <b:yellow>TOGGLES</> lessons first, or say <magenta>SKIP</> to move on.  You can also say <magenta>EXIT</> to leave the Academy.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'Say <magenta>EXIT</> to leave the Academy, or go back and finish your earlier lessons.'")
    end
else
    actor:move("e")
end$trig$, 'da8db342f1237e00d7d328da6ae115f9'),
  -- data/triggers/519/519_85_academy_instructor_speech_skip.lua
  (519, 85, $trig$-- Converted from DG Script #51985: academy_instructor_speech_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: skip
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "skip")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("school") == 1 then
    actor:advance_quest("school")
    actor:set_quest_var("school", "speech", "complete")
    actor:set_quest_var("school", "gear", "complete")
    actor:set_quest_var("school", "explore", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Certainly.  You'll continue to the east.'")
    actor:command("search curtain")
    self:command("open curtain")
    actor:move("east")
end$trig$, '4a9ad4eef17f8c67f94e370043a50739'),
  -- data/triggers/519/519_86_academy_clerk_speech_hit_points.lua
  (519, 86, $trig$-- Converted from DG Script #51986: academy_clerk_speech_hit_points
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- Speech phrase: hit points (the DG arg 0 is "contains the phrase", not a chance)
if not string.find(string.lower(speech), "hit points", 1, true) then
    return true  -- Not the phrase
end
wait(2)
if actor:get_quest_stage("school") == 2 then
    actor:set_quest_var("school", "hp", "complete")
    actor:send(tostring(self.name) .. " tells you, 'Look at the prompt in the lower-left corner of your screen again.")
    actor:send("The two numbers on the left are your <b:red>Hit Points</>.")
    actor:send("The first number is your <b:red>Current Hit Points</>.")
    actor:send("The second number is your <b:red>Maximum Hit Points</>.")
    actor:send("Your <b:red>Maximum</> increases every time you level.")
    actor:send("</>")
    actor:send("When you get hit in combat, your current Hit Points go down.")
    actor:send("If your Hit Points reach 0, you are knocked unconscious.")
    actor:send("If your Hit Points reach -10, you die.")
    wait(1)
    actor:send(tostring(self.name) .. " tells you, 'Are you ready to continue?")
    actor:send("You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '63f4ff7e38bf14a9acaf587abffca1bd')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
