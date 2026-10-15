-- Zone 519 academy: word-list speech triggers branch on the matched word, case-insensitive, ignoring punctuation (playtest r12)
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
  -- data/triggers/519/519_00_academy_recruitor_speech_select.lua
  (519, 0, $trig$-- Converted from DG Script #51900: academy_recruitor_speech_select
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"basic", "combat", "none"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if speech_word == "basic" then
    if actor:get_quest_stage("school") == 0 then
        actor:start_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'Then welcome to the Ethilien Training Academy!")
        actor:send("Here you'll learn the basic commands to play FieryMUD.")
        actor:send("</>")
        actor:send("</><b:cyan>Be sure to read everything your teachers tell you!</>")
        actor:send("If you just skip to the next command, you'll miss out on a lot!!!'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Each command will have parenthesis around the first few letters.")
        actor:send("That is the shortest string you can use.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Tutorial commands will appear <b:green>in green text</>.")
        actor:send("Type those phrases <b:green>exactly</> as they appear.")
        actor:send("Remember, <b:green>spelling matters!!!</>'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say ready</> when you want to move on.'")
    else
        self:command("unlock gates")
        self:command("open gates")
        actor:send(tostring(self.name) .. " tells you, 'It's always a good idea to review the basics.'")
        actor:erase_quest("school")
        actor:start_quest("school")
        actor:send(tostring(self.name) .. " escorts you into the Academy.")
        actor:move("east")
        self:command("close gates")
        self:command("lock gates")
    end
elseif speech_word == "none" then
    if actor.level == 1 then
        if actor:get_quest_stage("school") == 0 then
            actor:start_quest("school")
            actor:send(tostring(self.name) .. " tells you, 'Then you can begin your adventures at the Forest Temple of Mielikki!  Good luck and happy hunting!'</>")
            wait(2)
            actor:send(tostring(self.name) .. " tells you, 'You may come back train at the academy at any time.'</>")
        else
            actor:send(tostring(self.name) .. " tells you, 'You can resume or repeat your training at any time if you wish.'</>")
        end
    else
        actor:send(tostring(self.name) .. " tells you, 'You seem to have a handle on what to do anyway.  You may come back and go through the training academy at any time.'</>")
    end
    wait(2)
    actor:send(tostring(self.name) .. " waves good-bye and escorts you away.")
    actor:move("up")
    if not actor:get_has_completed("school") then
        actor:complete_quest("school")
    end
elseif speech_word == "combat" then
    if actor:get_quest_stage("school") == 0 then
        actor:start_quest("school")
    else
        actor:erase_quest("school")
        actor:start_quest("school")
    end
    actor:advance_quest("school")
    actor:advance_quest("school")
    actor:send(tostring(self.name) .. " tells you, 'Tutorial commands will appear <b:green>in green text</>.")
    actor:send("Type those phrases <b:green>exactly</> as they appear to advance.")
    actor:send("Remember, <b:green>spelling matters!!!</>'")
    wait(3)
    -- switch on actor.class
    local direction = nil
    if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.'")
        direction = "down"
    elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.'")
        direction = "south"
    elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.'")
        direction = "east"
    elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.'</>")
        direction = "north"
    else
        actor:send(tostring(self.name) .. " tells you, 'I have no idea what to do with your class.  Please contact a god!'")
    end
    wait(2)
    actor:teleport(get_room(519, 8))
    if direction then
        get_room(519, 8):at(function()
            actor:command(direction)
        end)
    end
end$trig$, '2994d09ea0a6e90cf5d2f949eef82d1c'),
  -- data/triggers/519/519_04_academy_instructor_speech_yes_no_continue.lua
  (519, 4, $trig$-- Converted from DG Script #51904: academy_instructor_speech_yes_no_continue
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no", "continue"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 1 then
    if speech_word == "yes" then
        if (actor:get_quest_var("school:speech") or 0) == 3 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Say</>")
            actor:send("<b:yellow>Tell</>")
            actor:send("<b:yellow>Gossip</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif (actor:get_quest_var("school:gear") or 0) == 16 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Inventory</>")
            actor:send("<b:yellow>Wear</>")
            actor:send("<b:yellow>Equipment</>")
            actor:send("<b:yellow>Light</>")
            actor:send("<b:yellow>Remove</>")
            actor:send("<b:yellow>Get</>")
            actor:send("<b:yellow>Drop</>")
            actor:send("<b:yellow>Junk</>")
            actor:send("<b:yellow>Give</>")
            actor:send("<b:yellow>Put</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        elseif (actor:get_quest_var("school:explore") or 0) == 6 then
            actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
            actor:send("<b:yellow>Look</>")
            actor:send("<b:yellow>Search</>")
            actor:send("<b:yellow>Doors</>")
            actor:send("<b:yellow>Scan</>")
            actor:send("<b:yellow>Movement</>_")
            actor:send("I'll know you're ready to move on if you <b:green>say continue</>.'")
        end
    else
        if (actor:get_quest_var("school:speech") or 0) == 3 then
            actor:set_quest_var("school", "speech", "complete")
        elseif (actor:get_quest_var("school:gear") or 0) == 16 then
            actor:set_quest_var("school", "gear", "complete")
        elseif (actor:get_quest_var("school:explore") or 0) == 6 then
            actor:set_quest_var("school", "explore", "complete")
        end
        local advance
        if actor:get_quest_var("school:speech") == "complete" and actor:get_quest_var("school:gear") == "complete" and actor:get_quest_var("school:explore") == "complete" then
            advance = "yes"
        else
            advance = "no"
        end
        if advance == "yes" then
            actor:advance_quest("school")
            actor:send(tostring(self.name) .. " tells you, 'Then you're ready to move on!")
            actor:send("Proceed <b:green>east</>.")
            actor:send("In the next room you'll prepare for combat training!'")
        elseif advance == "no" then
            actor:send(tostring(self.name) .. " tells you, 'It looks like you still need to complete lessons on:")
            if actor:get_quest_var("school:speech") ~= "complete" then
                actor:send("<b:yellow>COMMUNICATION</>")
            end
            if actor:get_quest_var("school:gear") ~= "complete" then
                actor:send("<b:yellow>GEAR</>")
            end
            if actor:get_quest_var("school:explore") ~= "complete" then
                actor:send("<b:yellow>EXPLORATION</>")
            end
            actor:send("</>")
            actor:send("You can <b:green>say</> any of these to start a lesson on it or say <magenta>SKIP</> to move on to the next teacher.'")
        end
    end
end$trig$, 'f995a9bbd511afe42993583af929a956'),
  -- data/triggers/519/519_05_academy_instructor_speech_say_tell_gossip.lua
  (519, 5, $trig$-- Converted from DG Script #51905: academy_instructor_speech_say_tell_gossip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"say", "tell", "gossip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if (actor:get_quest_var("school:speech") or 0) == 3 then
    if speech_word == "say" then
        actor:send(tostring(self.name) .. " tells you, 'The most basic command is <b:cyan>(SA)Y</>.")
        actor:send("It sends your message to everything in the room, even NPCs and monsters.'")
    elseif speech_word == "tell" or speech_word == "whisper" then
        actor:send(tostring(self.name) .. " tells you, 'You can talk to one person by using <b:cyan>(T)ELL</>.")
        actor:send("Only the person you talk to will hear what you say, just like how I'm talking to you right now.")
        actor:send("You use it by typing <b:cyan>TELL [person] [message]</>.'")
    elseif speech_word == "gossip" then
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>(GOS)SIP</> talks to everyone in the game.")
        actor:send("It's definitely the most popular communication channel.")
        actor:send("It's a great way to ask questions or get help.'")
    end
    actor:send("</>")
    actor:send(tostring(self.name) .. " tells you, 'Do you have any other questions about communication?")
    actor:send(tostring(self.name) .. " tells you, 'You can <b:green>say yes</> or <b:green>say no</>.'")
end$trig$, '90a07d4096f8dd93d4e8c321e5231a25'),
  -- data/triggers/519/519_88_academy_clerk_speech_yes_no_skip.lua
  (519, 88, $trig$-- Converted from DG Script #51988: academy_clerk_speech_yes_no_skip
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
local speech_word = nil  -- the first listed word found; branch on this, not on the raw speech
for _, w in ipairs({"yes", "no", "skip"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        speech_word = w
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    local advance
    if speech_word == "yes" then
        if actor:get_quest_var("school:score") == "complete" and actor:get_quest_var("school:hp") == "complete" then
            advance = "yes"
        else
            advance = "no"
        end
    elseif speech_word == "skip" then
        advance = "yes"
    elseif speech_word == "no" then
        actor:send(tostring(self.name) .. " tells you, 'What would you like to review?  You can say:")
        actor:send("<b:yellow>Hit Points</>")
        actor:send("<b:yellow>Score</>_")
        actor:send(tostring(self.name) .. " tells you, <b:green>Say continue</> when you're ready to move on.'")
    end
    if advance == "yes" then
        actor:advance_quest("school")
        self:command("eye " .. tostring(actor))
        wait(1)
        actor:send(tostring(self.name) .. " considers your capabilities...")
        wait(3)
        actor:send(tostring(self.name) .. " tells you, 'Hmmmm...'")
        wait(2)
        -- switch on actor.class
        do
            local _sw1 = string.lower(tostring(actor.class or ""))
            if _sw1 == "rogue" or _sw1 == "thief" or _sw1 == "assassin" or _sw1 == "mercenary" or _sw1 == "bard" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
            elseif _sw1 == "sorcerer" or _sw1 == "cryomancer" or _sw1 == "pyromancer" or _sw1 == "necromancer" or _sw1 == "illusionist" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
            elseif _sw1 == "cleric" or _sw1 == "priest" or _sw1 == "diabolist" or _sw1 == "druid" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
            elseif _sw1 == "warrior" or _sw1 == "paladin" or _sw1 == "anti-paladin" or _sw1 == "ranger" or _sw1 == "monk" or _sw1 == "berserker" then
                actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'I have no idea what to do with you.  Find a god and ask for help!'")
            end
        end
    elseif advance == "no" then
        if actor:get_quest_var("school:score") == "complete" then
            actor:send(tostring(self.name) .. " tells you, 'Let's talk about <b:yellow>HIT POINTS</> next.")
            actor:send("<b:green>Say hit points</> to begin.'")
        elseif actor:get_quest_var("school:hp") == "complete" then
            actor:send(tostring(self.name) .. " tells you, 'Let's talk about <b:yellow>SCORE</> next.")
            actor:send("<b:green>Say score</> to begin.'")
        end
    end
end$trig$, '30f60f337f1ff1a1a7b0ccf7f6c25854')
) AS v(zone_id, id, commands, old_md5)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = v.old_md5
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
