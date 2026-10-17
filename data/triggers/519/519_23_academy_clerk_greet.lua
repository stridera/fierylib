-- Trigger: academy_clerk_greet
-- Zone: 519, ID: 23
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #51923

-- Converted from DG Script #51923: academy_clerk_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(0.2)
if actor:get_quest_stage("school") == 2 then
    if (actor:get_quest_var("school:prep") or 0) == 1 then
        actor:set_quest_var("school", "prep", "complete")
        actor:send(tostring(self.name) .. " tells you, 'Aww, a fresh-faced adventurer, how sweet.'")
        self:command("chuckle")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Well kid, let's get ya ready to fight!")
        actor:send("I have two quick things to introduce you to:")
        actor:send("<b:yellow>HIT POINTS</>, and <b:yellow>(SC)ORE</>.")
        actor:send("</>")
        actor:send("<b:green>Say</> one or the other to learn about it.")
        actor:send("You can also say <magenta>SKIP</> to move to the next lesson.'")
    elseif (actor:get_quest_var("school:score") or 0) == 1 then
        actor:send(tostring(self.name) .. " tells you, 'Let's pick up where we left off.'")
        wait(0.2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
        actor:send("Experience, Hit Points, Stamina, Stats, Saves, blah blah blah.'")
        wait(8)
        actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
    end
elseif actor:get_quest_stage("school") == 3 then
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
            actor:send(tostring(self.name) .. " tells you, 'I have no idea where to send you.  Ask a god for help!'")
        end
    end
end