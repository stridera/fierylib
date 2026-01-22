-- Trigger: creeping_doom_pixie_receive
-- Zone: 615, ID: 53
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 8237 chars
--
-- Original DG Script: #61553

-- Converted from DG Script #61553: creeping_doom_pixie_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("creeping_doom")
if stage == 1 then
    if object.id == 11812 or object.id == 16213 or object.id == 48029 then
        if actor:get_quest_var("creeping_doom:" .. tostring(object.vnum)) == 1 then
            _return_value = false
            self:say("You already brought me " .. "%get.obj_shortdesc[%object.vnum%]%")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        else
            actor.name:set_quest_var("creeping_doom", "%object.vnum%", 1)
            wait(2)
            world.destroy(object)
            self:say("Just what we need.")
            if actor:get_quest_var("creeping_doom:11812") and actor:get_quest_var("creeping_doom:16213") and actor:get_quest_var("creeping_doom:48029") then
                actor.name:advance_quest("creeping_doom")
                wait(1)
                self:say("Yesssss... Raaaaaaage...")
                wait(2)
                self:say("Now we need all the doom!  Swarms of DOOM!!")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Ethilien is chock-full of creepy-crawlies:")
                self.room:send("</>Flies, bugs, spiders, scorpions, giant ant creatures...")
                wait(2)
                self:say("The list goes on.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Creeping Doom is just swarms of these things.  You'll")
                self.room:send("</>need to gather <b:green>11 essence of swarms</> from these creatures, one for every circle")
                self.room:send("</>of magic the spell requires.'")
                wait(4)
                self.room:send(tostring(self.name) .. " says, 'Harvesting these essences'll take time and patience.")
                self.room:send("</>The more powerful the insect you kill, the more likely you'll find acceptable")
                self.room:send("</>essences.  Bring those essences to me.'")
            else
                wait(2)
                self:say("Where's the rest?")
            end
        end
    else
        _return_value = false
        wait(2)
        self:say("This isn't going to help.")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 2 then
    if object.id == 61517 then
        wait(2)
        self:say("Yesssss...  More essences!")
        local spiders = actor:get_quest_var("Creeping_doom:spiders") + 1
        actor.name:set_quest_var("creeping_doom", "spiders", spiders)
        self:destroy_item("essence-of-swarms")
        wait(2)
        if actor:get_quest_var("Creeping_doom:spiders") == 11 then
            actor.name:advance_quest("creeping_doom")
            self.room:send(tostring(self.name) .. " says, 'The Rage and Doom are hyped, but we need to keep 'em")
            self.room:send("</>from going too aggro.  Trophies from ending Nature's suffering'll temper them")
            self.room:send("</>into a focused, deadly weapon.  The scythe to cut down Nature's enemies...'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'There are three particular trees that suffer in")
            self.room:send("</>unnatural agony.  Help them and bring a trophy of the experience.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'One is a treant plagued by invasive dogs in the")
            self.room:send("</>forest of the oldest Rhell.  Ease the tree's suffering and bring back a limb")
            self.room:send("</>as a relic of peace.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Another is an eternally burning tree in the ruined")
            self.room:send("</>city Templace.  End the tree's suffering and bring back one of its burning")
            self.room:send("</>branches as a relic of succor.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'The final is an elder tremaen in an ancient forest")
            self.room:send("</>beset by the elemental Plane of Fire.  The tremaen carries the holy Seed of")
            self.room:send("</>the Silveroak.  Return with the Seed as a relic of the promise of new life")
            self.room:send("</>even in the face of extreme burnination.'")
        else
            local remaining = 11 - actor:get_quest_var("Creeping_doom:spiders")
            self.room:send(tostring(self.name) .. " says, 'You have brought me " .. tostring(actor:get_quest_var("Creeping_doom:spiders")) .. " <b:green>essence of swarms</>.")
            self.room:send(tostring(remaining) .. " more to go.'")
        end
    else
        _return_value = false
        self:say("This isn't a swarm!!")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 3 then
    if object.id == 48416 or object.id == 52034 or object.id == 62503 then
        if actor:get_quest_var("creeping_doom:" .. tostring(object.vnum)) == 1 then
            _return_value = false
            self:say("You already found this.")
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        else
            actor.name:set_quest_var("creeping_doom", "%object.vnum%", 1)
            wait(1)
            self:say("This is it!")
            world.destroy(object)
            if actor:get_quest_var("creeping_doom:48416") and actor:get_quest_var("creeping_doom:52034") and actor:get_quest_var("creeping_doom:62503") then
                self:say("These are all the parts we need!")
                actor.name:advance_quest("creeping_doom")
                wait(1)
                self.room:send(tostring(self.name) .. " ties the bit of vine to the treant limb.")
                wait(2)
                self.room:send("Using the burning branch, she lights the vine on fire and crushes the scarab and spider.")
                wait(3)
                self.room:send(tostring(self.name) .. " sprinkles the Seed of the Silveroak with the ash mixture.")
                wait(1)
                self.room:send("One by one " .. tostring(self.name) .. " blows the essences of swarms onto the Seed of the Silveroak.")
                wait(2)
                self.room:send("The Seed of the Silveroak glows <green>green</> and <red>red</>!")
                wait(1)
                self.room:spawn_object(615, 18)
                self:command("give essence-natures-vengeance " .. tostring(actor.name))
                wait(2)
                -- (empty say)
                self.room:send(tostring(self.name) .. " says, 'Now to rain doom on the doomed heads of our doomed")
                self.room:send("</>enemies!'")
                wait(2)
                self:say("In the Black Woods is a logging camp clearcutting the forest.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, 'Take this new seed and drop it at the")
                self.room:send("</><b:white>entrance to the logging camp</>.'")
                wait(3)
                self.room:send(tostring(self.name) .. " says, 'Death will wash over the camp and annihilate")
                self.room:send("</>everything there.  Stay and watch.  Hear every last scream.  Feel")
                self.room:send("</>every last death.  Then you'll understand Creeping Doom.'")
                wait(4)
                self:say("That is the strength of Nature's vengeance.")
                wait(4)
                self:say("Once you've done the deed, come back.")
            else
                wait(1)
                self:say("Help the other trees and bring the trophies to me.")
            end
        end
    else
        _return_value = false
        self:say("The heck is this??")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
else
    _return_value = false
    self:say("The heck is this??")
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value