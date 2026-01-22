-- Trigger: academy_instructor_speech2
-- Zone: 519, ID: 3
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51903

-- Converted from DG Script #51903: academy_instructor_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: hello teacher
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hello") or string.find(string.lower(speech), "teacher")) then
    return true  -- No matching keywords
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
end