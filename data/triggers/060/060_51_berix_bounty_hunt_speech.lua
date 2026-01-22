-- Trigger: Berix bounty hunt speech
-- Zone: 60, ID: 51
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 10499 chars
--
-- Original DG Script: #6051

-- Converted from DG Script #6051: Berix bounty hunt speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: job jobs what contract contracts
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "job") or string.find(string.lower(speech), "jobs") or string.find(string.lower(speech), "what") or string.find(string.lower(speech), "contract") or string.find(string.lower(speech), "contracts")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("bounty_hunt") then
    actor:send(tostring(self.name) .. " says, 'You know, I'm fresh out of work for you.  Good luck!'")
elseif not actor:get_quest_stage("bounty_hunt") or (actor:get_quest_stage("bounty_hunt") == 1 and not actor:get_quest_var("bounty_hunt:bounty")) then
    actor:send(tostring(self.name) .. " says, 'Sure, I have something easy to start with.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I have benefactors who would like certain individuals to... disappear.  The resulting chaos is to their benefit.  They're willing to pay handsomely for that to occur.  Ours is not ask questions but simply see that it happen.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'One such individual is the king of some cat colony or somme such down near the town of Mielikki.  I don't know why they say he's \"merely\" a king, but again, our job isn't to ask questions.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Can I count on you to get this done?'")
elseif actor:get_quest_var("bounty_hunt:bounty") == "dead" then
    actor:send(tostring(self.name) .. " says, 'Give me your current contract first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("bounty_hunt") - 1) * 10 then
        -- switch on actor:get_quest_stage("bounty_hunt")
        if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            if actor:get_quest_stage("bounty_hunt") == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Best get on killing that cat-king or whatever first.'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the Noble and the Abbot sheltering him at the Abbey of St. George.'")
            else
                actor:send(tostring(self.name) .. " says, 'There's a noble who's gone into hiding because a lot of people want him dead.  But good news: I've been able to locate him!  He's hiding in the Abbey of St. George.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I've got someone who's so angry, they're asking us to kill not just the noble, but the Abbot who took him in!  Double payday!'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'You in?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the three Chieftains in the southwestern Highlands.'")
            else
                actor:send(tostring(self.name) .. " says, 'There are three warring clans down in the Highlands past the Gothra Desert: O'Connor, McLeod, and Cameron.  Each has taken out a contract on the other, but get this: they all paid in advance!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'It's a big job, but it'll be totally worth it if we pull it off.  And it'll be a legendary triple-cross!  Think of how impressive that'll be!'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'So whadda ya say?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Find the Frakati Leader and kill him.'")
            else
                actor:send(tostring(self.name) .. " says, 'I've got a challenge for you.  There's a hidden reservation near the town of Mielikki for a group of tribal hunters.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I have a contract for their leader.  Elusive bastard, but could be an interesting job.  Plus you can keep whatever you find.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'You interested?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Infiltrate the Sacred Haven and take out the number two in command, Cyrus.'")
            else
                actor:send(tostring(self.name) .. " says, 'I got a big contract this time.  Someone from Ogakh is trying to tip the scales in South Caelia by destablizing the Sacred Haven.  They want the head of Cyrus, the number two in command.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Only problem is the Sacred Haven is a literal fortress.  Wall to wall paladins with platemail and holy swords, the whole nine yards.  Getting to Cyrus could be a mission all on its own.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Are you up for it?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Disappear Lord Venth down south.'")
            else
                actor:send(tostring(self.name) .. " says, 'With the success of the Sacred Haven mission, someone is feeling bold.  They're looking for Lord Venth in the Tolder Borderhold Keep to disappear.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The borderhold isn't too hard to get into, but Venth is a real tough character.  Be ready for a knockdown drag out fight.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'What do you think?  Do you want it?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Send the high druid on a permanent pilgrimage.'")
            else
                actor:send(tostring(self.name) .. " says, 'The South Caelia jobs just keep coming.  Another religious leader for you.  One of the most influential druids in the world makes his home in Anlun Vale.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Making him vanish will be a warning to all the other sects to keep clear of worldly affairs.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Sound like something you could be interested in?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Kill the Lizard King.  If you can even find him...'")
            else
                actor:send(tostring(self.name) .. " says, 'Really odd request this next one.'")
                wait(2)
                actor:send(tostring(self.name) .. " says, 'The Northern Swamps seem to be under the domain of a king of the lizard men.  Recon suggests he makes his home in a castle that sunk into the the swamp ages ago.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I've got a contract to hunt down and kill the Lizard King.  Not sure what the reason could be, but it sounds like a thrillride anyway.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'You down?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  Take out the leader of the Ice Cult up north before they get wind of it.'")
            else
                actor:send(tostring(self.name) .. " says, 'Got a really difficult job for you next.  Up north is a very secretive, very deadly cult dedicated to worshipping some kinda dragon.  These are some extremely nasty customers, I mean the worst!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'We've been asked to take out their high priestess, a woman by the name of Sorcha.  I'm sure she's well guarded, given the cult's resources, but that's why I need someone like you on the job.'")
                wait(3)
                actor:send(tostring(self.name) .. " says, 'Think you can handle it?'")
            end
            if actor:get_quest_var("bounty_hunt:bounty") == "running" then
            elseif actor:get_quest_stage("bounty_hunt") == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a job to do.  End the reign of the Goblin King.  We'll all probably dream a little more soundly then.'")
            else
                actor:send(tostring(self.name) .. " says, 'The last job I have is for a tyrant so terrible he can hardly be real.  We've been offered a contract for the Goblin King up in the Syric Mountains.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Some wild magic nonsense happened up there a few years ago so now the whole place is like a waking nightmare.  I understand it well enough to know I don't understand it!  'Fraid I can't be of much help to you.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You got this one?'")
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'All my other jobs are too risky for someone without more experience.  Come back when you've seen a little more.'")
    end
end