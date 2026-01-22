-- Trigger: academy_clerk_greet
-- Zone: 519, ID: 23
-- Type: MOB, Flags: GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #51923

-- Converted from DG Script #51923: academy_clerk_greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
wait(2)
if actor:get_quest_stage("school") == 2 then
    if actor:get_quest_var("school:prep") == 1 then
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
    elseif actor:get_quest_var("school:score") == 1 then
        actor:send(tostring(self.name) .. " tells you, 'Let's pick up where we left off.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>SCORE</> is how you see all the numeric stuff about yourself:")
        actor:send("Experience, Hit and Movement Points, Stats, Saves, blah blah blah.'")
        wait(8)
        actor:send(tostring(self.name) .. " tells you, 'Check it out by typing <b:green>score</> now.'")
    end
elseif actor:get_quest_stage("school") == 3 then
    -- switch on actor.class
    if actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" or actor.class == "bard" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a stealthy type.  You'll do best in lessons with Doctor Mischief.  Proceed <b:green>down</> to their classroom.'")
    elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're an arcane spell caster.  You would definitely benefit from the Chair of Arcane Studies' seminar on spellcasting.  Proceed <b:green>south</> to his laboratory.'")
    elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a divine spell caster.  You would definitely benefit from private classes with the Professor of Divinity.  Proceed <b:green>east</> to his chapel.'")
    elseif actor.class == "warrior" or actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "monk" or actor.class == "berserker" then
        actor:send(tostring(self.name) .. " tells you, 'I see you're a fighter type.  You'll do best learning from the Academy's Warmaster.  Proceed <b:green>north</> to her arena.'")
    else
        actor:send(tostring(self.name) .. " tells you, 'I have no idea where to send you.  Ask a god for help!'")
    end
end