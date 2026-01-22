-- Trigger: Honus speech hunt treasure
-- Zone: 53, ID: 21
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--   Large script: 12521 chars
--
-- Original DG Script: #5321

-- Converted from DG Script #5321: Honus speech hunt treasure
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: hunt treasure
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "hunt") or string.find(string.lower(speech), "treasure")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Only great treasures, the stuff of legend, still wait out there!'")
elseif not actor:get_quest_stage("treasure_hunter") then
    actor:send(tostring(self.name) .. " says, 'Treasure hunting is equal parts cleverness and strength.  You can't always just hack your way through the hordes to your prize.  You have to be smart.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'If you want to see what I mean, here's one to start with.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Out east is an enchanted hollow.  I hear tell a fancy weapon, a strange singing chain, is kept as a prized possession by a nixie deep inside.'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'I'll pay you well if you can bring it back.  The place is filthy with faeries though, so be prepared for puzzles and trickery at every turn!'")
    wait(4)
    actor:send(tostring(self.name) .. " says, 'Are you up to the challenge?'")
elseif actor:get_quest_var("treasure_hunter:hunt") == "found" then
    actor:send(tostring(self.name) .. " says, 'Give me your current order first.'")
    return _return_value
else
    if actor.level >= (actor:get_quest_stage("treasure_hunter") - 1) * 10 then
        -- switch on actor:get_quest_stage("treasure_hunter")
        if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            if actor:get_quest_stage("treasure_hunter") == 1 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find that singing chain and I'll pay you for your time.'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 2 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find one of the true fire rings the theatre in Anduin gives out.  Not the fake prop ones most of the performers carry around, but the real ones they give out at their grand finale.'")
            else
                actor:send(tostring(self.name) .. " says, 'The city of Anduin has a world-famous theatre company that puts on lavish spectacles of murder and mayhem.  It might seem unlikely, but they have a few exceedingly rare treasures they keep too!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'One is a magic weapon, a ring made of pure fire.  They allegedly only give them out to participants of their \"grand finale,\" which they rarely perform.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'See if you can get them to perform it and bring back one of those rings.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You wanna give it a go?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 3 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a sandstone ring in the caves to the west.'")
            else
                actor:send(tostring(self.name) .. " says, 'There's a whacky old guy who lives in the Gothra Desert out west.  Claims he caught him a giant scorpion or something.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I don't care about that part.  What I AM interested in is a small ring he apparently locked in a cave with the scorpion.  I hear it's made out of sandstone and has some pretty special properties.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'I'd wager the old man is the only one who knows how to get into the cave.  You'll have to work with him to figure out how to open it and get inside.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you up for a little spelunking?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 4 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Recover the electrum hoop lost in the bayou shipwreck.'")
            else
                actor:send(tostring(self.name) .. " says, 'You know who's really good at collecting treasure?  Pirates.  They're also really good at wrecking their ships and leaving their treasure for other people to find after they die.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Out past the forests to the east is a bayou which apparently at one time connected to the Arabel Ocean.  There, the remains of a shipwreck peak up from the marsh.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'And so do the remains of the crew!  The place is filthy with zombies!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'But it seems the ship crashed because of some nefarious treasure the captain had brought on board.  Check it out, see if you can find out what it was.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Ready to plunder the ship?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 5 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Bring me back a Rainbow Shell from the volcanic islands.'")
            else
                actor:send(tostring(self.name) .. " says, 'You might be surprised to know shells can be some of the most valuable things in the world.  Some cultures even use them as currency still!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'In particular, there's an extremely rare shell that can only be found on the volcanic island in the Arabel Ocean.  One of the tribal groups out there apparently gives them out as precious gifts.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Think you can figure out how to get your hands on one for me?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 6 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Raid Mystwatch and bring back the legendary Stormshield.'")
            else
                actor:send(tostring(self.name) .. " says, 'Word has it the Knights Templar are preparing to raid the Fortress of Mystwatch just north of Mielikki.  And that means it's open season on the wonders inside.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The demons that control Mystwatch are a unique species, said to control the power of the storm itself.  One of their most powerful relics is something called the Stormshield, a pitch black disc forged from pure night with the power of lightning.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Why don't you join an upcoming raid and see if you can find the shield?  I'll make it worth your time.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You up for it?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 7 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Get your hands on a Snow Leopard Cloak.'")
            else
                actor:send(tostring(self.name) .. " says, 'Up North is a secretive society built on worship of the Great Snow Leopard.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'While they have great power still, they apparently lost the keys to some of their deepest secrets in various wars over the centuries.  I hear they award a Snow Leopard Cloak to those who can help solve some of those mysteries.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'See if you can figure it out and bring back a cloak.  You ready to brave the cold?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 8 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Find a magic ladder that uncoils itself.'")
            else
                actor:send(tostring(self.name) .. " says, 'So I heard about another magic trinket floating around the islands in the Arabel Ocean.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'This one is supposedly a magic ladder that can coil and uncoil itself without anyone holding it.  Just think of all the places we could get into if we had one of those!'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'See if you can figure out who has one and what you need to do to get it from them.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'You interested?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 9 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Seek out a glowing phoenix feather.'")
            else
                actor:send(tostring(self.name) .. " says, 'You've done such a great job, I'm moving you beyond the typical magic weapons and jewelry to the real legendary stuff.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'There's a place in the Syric Mountains where legends literally come to life.  All manner of fantastical creatures, and their treasures, can be found there.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Some have even said the glowing feather of a phoenix can be found for the right price.  Whatever that price is, pay it and bring back one of those feathers.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Are you up to the challenge?'")
            end
            if actor:get_quest_var("treasure_hunter:hunt") == "running" then
            elseif actor:get_quest_stage("treasure_hunter") == 10 then
                actor:send(tostring(self.name) .. " says, 'You still have a treasure to find.  Secure a piece of sleet armor.'")
            else
                actor:send(tostring(self.name) .. " says, 'This last thing I'm looking for hasn't been seen for centuries.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'The frost elves had a kind of magical metal they called \"sleet\" - as light as cloth but hard as ice.  It was probably a relative of mythril, but since none exists now that's only speculation.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'However, it seems a device exists for traveling through time to a place where the frost elves still live.  If you could find that device, you might be able to figure out where to go to get a piece of sleet armor.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'But BE READY.  Legend has it the frost elves were some of the most deadly warriors Ethilien has ever seen.  Stealing anything from them is surely to be the fight of your life.'")
                wait(4)
                actor:send(tostring(self.name) .. " says, 'Ready to take a trip through time?'")
            end
        end
    else
        actor:send(tostring(self.name) .. " says, 'There's still plenty of treasure out there, but it's too dangerous without more experience.  Come back when you've grown a little more.'")
    end
end