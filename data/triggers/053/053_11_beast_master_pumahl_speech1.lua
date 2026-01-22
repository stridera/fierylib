-- Trigger: Beast Master Pumahl speech1
-- Zone: 53, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 12058 chars
--
-- Original DG Script: #5311

-- Converted from DG Script #5311: Beast Master Pumahl speech1
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hunt beasts beast master legendary creatures creature
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hunt") or string.find(string.lower(speech), "beasts") or string.find(string.lower(speech), "beast") or string.find(string.lower(speech), "master") or string.find(string.lower(speech), "legendary") or string.find(string.lower(speech), "creatures") or string.find(string.lower(speech), "creature")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("beast_master") then
    actor:send(tostring(self.name) .. " says, 'You've already proven your dominion over the beasts of Ethilien!'")
elseif not actor:get_quest_stage("beast_master") or (actor:get_quest_stage("beast_master") == 1 and not actor:get_quest_var("beast_master:hunt")) then
    actor:send(tostring(self.name) .. " says, 'I have an excellent beast for you to start with.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Good hunters know terrible monsters lurk everywhere, even beneath our feet in this very city.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'The sewers beneath Mielikki are teeming with life - some of it much more dangerous than the rest.  The slime monsters are particularly pointy and bitey.  Find and kill the biggest of these abominations and we'll welcome you to the ranks of the Beast Masters!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Ready to go spelunking through the sludge?'")
elseif actor:get_quest_var("beast_master:hunt") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current assignment first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("beast_master") - 1) * 10 then
        -- switch on actor:get_quest_stage("beast_master")
        if actor:get_quest_var("beast_master:hunt") == "running" then
            if actor:get_quest_stage("beast_master") == 1 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay an abominable slime creature in the sewers beneath Mielikki.'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 2 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Hunt down a large buck in the forests just outside of Mielikki.'")
            else
                actor:send(tostring(self.name) .. " says, 'Knowing what lurks below Mielikki now, it shouldn't be surprising that danger is just outside our doors.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The forests out east seem safe at first glance, but something evil has taken hold in the deepest heart of the woods.  It has twisted and corrupted many of the animals that made that place their homes and now they present a threat as dangerous as any sewer-dwelling monster.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Take down one of the bucks ripping up the forest.  Maybe it will help the forest recover a little.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Do you feel strong enough to handle that?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 3 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Track down the giant scorpion of Gothra.'")
            else
                actor:send(tostring(self.name) .. " says, 'There are some monsters we think are only stories.  Like out in the Gothra Desert, there's the story of a giant scorpion trapped in a cave.  Other monster hunters have found the cave, but no one has had any luck getting inside.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Maybe you can find someone who knows how to get in and you can kill whatever's on the other side of the door.  Just think what a name you could make for yourself if you pull it off!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you up for some grand exploration?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 4 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Head far to the south and kill a monstrous canopy spider.'")
            else
                actor:send(tostring(self.name) .. " says, 'Since you had some luck with that giant scorpion, let's see you take down another kind of giant arachnid!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There's nothing quite so famous as giant spiders.  Fangorn Forest in South Caelia is full of 'em.  Find the most monstrous canopy spider you can and show it who's the real master of beasts!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Ready to walk the spiderwebs?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 5 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Behead the famed chimera of Fiery Island.'")
            else
                actor:send(tostring(self.name) .. " says, 'Between North and South Caelia are a number of small islands.  All of them are home to some awe-inspiring creatures, each more deadly than the last.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'One unique creature in particular stands out: a three-headed chimera!  Nothing like killing three beasts in one!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Oh, and I understand there's a local shaman out there who knows more about the creature and the island itself.  Might want to stop and talk to him while you're there.  Who knows what you could learn.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You want to go knock a few heads together?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 6 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Slay the \"king\" of the abominations known as driders.'")
            else
                actor:send(tostring(self.name) .. " says, 'You've done great against the surface world, but you've only just begun to scratch... well... the surface.  Below this upper world lies a vast universe of caves and tunnels known as the Underdark.  Whole bunch of the worst kinds of monsters live down there.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The drow, the dark elves, are one of the more infamous.  One of their coming of age rituals involves testing their young in some kind of brutal and savage contest.  Those who fail are turned into grotesque horrors called \"driders\".  They get thrown out of society and form a colony of sorts under the most evil and murderous of them all, who they call a \"king\".'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There's an entrance to a drow city in the caves just east of Mielikki.  There's sure to be a drider king down there!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Can you prove you're better than some half-elf, half-spider abomination?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 7 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Close the eyes of a beholder from under Mt. Frostbite.'")
            else
                actor:send(tostring(self.name) .. " says, 'Ever heard of a beholder?  It's a great big floating eye with teeth, surrounded by a bunch of little eyes on stalks.  They're big, mean, and exceptionally deadly!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'For whatever reason, they show up in uncommonly large numbers in the ice caverns beneath Mt. Frostbite.  And somehow, they've learned to live with the cult up there too.  Just think of it as an added bonus hunt!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You ready to brave the cold?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 8 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Lay the Banshee to eternal rest.'")
            else
                actor:send(tostring(self.name) .. " says, 'Some things are so dangerous, you have to kill them twice.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There used to be a castle up north.  Something terrible happened to it and it sunk into the Northern Swamps, killing everyone inside.  But, anyone who manages to cross through comes back with terrible stories of ghosts and lizardfolk crawling out of the ruins.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Some even tell of ghostly piercing screams echoing through the swamp.  Screaming ghosts can only mean one thing - a banshee.  Destroying a banshee would make for an epic tale!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You in?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 9 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Put an end to Baba Yaga's dreamy witchcraft.'")
            else
                actor:send(tostring(self.name) .. " says, 'I got a great one for you, a literal walking legend.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Some of the wildest monsters ever known have been popping up in the Syric Mountains.  Among them is a troll witch, goes by the name Baba Yaga.  Lives in a house with legs.  Literal chicken legs.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Infiltrate the Realm of the King of Dreams, find Baba Yaga, and kill her.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'It's going to be an incredibly dangerous hunt, one worth of your skills.  Wanna take it on?'")
            end
            if actor:get_quest_var("beast_master:hunt") == "running" then
            elseif actor:get_quest_stage("beast_master") == 10 then
                actor:send(tostring(self.name) .. " says, 'You're still on the hunt.  Defeat the medusa below the city of Templace.'")
            else
                actor:send(tostring(self.name) .. " says, 'The last truly monstrous creature I have for you to hunt down is a horrifying sight to behold.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Somewhere below the ruins of Templace is the lair of a hideous creature with two tusks protruding from her mouth and snakes growing from her head.  She's almost certainly hidden so keep your eyes peeled.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Prepared to stalk the ruined streets of Templace?'")
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'Unfortunately I don't have any beasts for you to pursue at the moment.  Check back later!'")
    end
end