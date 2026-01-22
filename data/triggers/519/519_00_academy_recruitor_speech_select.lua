-- Trigger: academy_recruitor_speech_select
-- Zone: 519, ID: 0
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 5212 chars
--
-- Original DG Script: #51900

-- Converted from DG Script #51900: academy_recruitor_speech_select
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: basic combat none
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "basic") or string.find(string.lower(speech), "combat") or string.find(string.lower(speech), "none")) then
    return true  -- No matching keywords
end
wait(2)
if speech == "basic" then
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
elseif speech == "none" then
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
elseif speech == "combat" then
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
    if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.'")
        local direction = "down"
    elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.'")
        local direction = "south"
    elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.'")
        local direction = "east"
    elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
    else
        actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.'</>")
        local direction = "north"
    else
        actor:send(tostring(self.name) .. " tells you, 'I have no idea what to do with your class.  Please contact a god!'")
    end
    wait(2)
    actor:teleport(get_room(519, 8))
    get_room(519, 8):at(function()
        actor:command("%direction%")
    end)
end