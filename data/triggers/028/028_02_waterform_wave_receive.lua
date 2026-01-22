-- Trigger: waterform_wave_receive
-- Zone: 28, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #2802

-- Converted from DG Script #2802: waterform_wave_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("waterform")
if actor:get_quest_var("waterform:new") == "yes" then
    if object.id == 2807 then
        wait(2)
        self:say("Yes, I can make a new dragon bone cup from this.")
        world.destroy(object)
        actor:set_quest_var("waterform", "new", 0)
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(2)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self:say("Don't lose this again!")
    else
        _return_value = false
        wait(2)
        self:say("I can't make a new cup from this.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 1 then
    if object.id == 51009 then
        actor:advance_quest("waterform")
        wait(2)
        self:destroy_item("shield")
        self:say("Yes, this will do nicely.")
        self.room:send(tostring(self.name) .. " absorbs " .. tostring(objects.template(510, 9).name) .. " into its massive form!")
        wait(2)
        self:say("Now hold still.")
        wait(2)
        self.room:send(tostring(self.name) .. " crests up to a monumental height and pauses for just a moment.")
        wait(4)
        actor:send(tostring(self.name) .. " CRASHES down and engulfs you!")
        self.room:send_except(actor, tostring(self.name) .. " CRASHES down and engulfs " .. tostring(actor.name) .. "!")
        wait(4)
        actor:send("You feel your body start to soften and flow!")
        actor:send("You feel at one with the Great Wave!")
        self.room:send_except(actor, tostring(actor.name) .. " to merges with the Great Wave!")
        wait(6)
        actor:send("Suddenly you feel your body solidify again.")
        actor:send("You begin to choke!")
        self.room:send_except(actor, tostring(actor.name) .. " begins to struggle against the torrent!")
        wait(5)
        self.room:send_except(actor, tostring(self.name) .. " recedes leaving " .. tostring(actor.name) .. " heaving for breath.")
        actor:send(tostring(self.name) .. " recedes, leaving you gasping for air.")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'That didn't work quite right.  The Amorphous Shield alone")
        self.room:send("</>must not be powerful enough to sustain the transformation.  Perhaps we will")
        self.room:send("</>need to add a few other elements.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I apologize, but if you wish to continue, you will have")
        self.room:send("</>to find a few other things.'")
    else
        _return_value = false
        self:say("This isn't armor made of water.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 3 then
    if object.id == 2807 then
        actor:advance_quest("waterform")
        wait(2)
        self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
        self:destroy_item("thigh-bone")
        self:say("This bone will make an excellent water vessel.")
        wait(2)
        self.room:send(tostring(self.name) .. " transforms into a torrential swirling column!")
        self.room:send("The riptide whittles away at the ice white bone, carving it into a smooth cup.")
        wait(5)
        self.room:send(tostring(self.name) .. " slowly resumes into its gentle undulating form, the cup floating on its crest.")
        self.room:spawn_object(28, 8)
        wait(1)
        self:command("give dragon-bone-cup " .. tostring(actor.name))
        self.room:send(tostring(self.name) .. " says, 'Take this cup.  With it, take samples of <b:blue>four living</>")
        self.room:send("</>water creatures</>.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Each creature must come from a <b:cyan>different region</> of")
        self.room:send("</>the world.  So you'll need samples from more than just the denizens of the")
        self.room:send("</>Blue-Fog river and road.'")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you've gathered the four samples, return and give me")
        self.room:send("</>the cup.'")
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This won't make a usable vessel.")
    end
elseif stage == 4 then
    if object.id == 2808 then
        _return_value = false
        self:say("It seems you haven't collected all four samples yet.")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
    else
        _return_value = false
        self:say("Why are you bringing me this?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self:say("You should be out collecting living water samples.")
    end
elseif stage == 5 then
    if object.id == 2808 then
        actor:advance_quest("waterform")
        _return_value = false
        self:say("Yes, these samples are perfect.")
        wait(2)
        self:emote("rises up, coaxing wavering orbs of water out of the dragon bone cup.")
        self:emote("raises up the shield and merges the watery orbs with it.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'One last thing, just to be sure.  Develop a deeper")
        self.room:send("</>personal insight on the nature of water.'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Using the cup again, <b:cyan>examine</> six unique sources of")
        self.room:send("</>water.'")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'Seek out:'")
        self.room:send("- <b:blue>a granite pool in the village of Mielikki</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a sparkling artesian well in the Realm of the King of Dreams</>")
        -- (empty room echo)
        self.room:send("- <b:blue>a crystal clear fountain in the caverns of the Ice Cult</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the creek in the Eldorian Foothills</>")
        -- (empty room echo)
        self.room:send("- <b:blue>the wishing well at the Dancing Dolphin in South Caelia</>")
        -- (empty room echo)
        self.room:send("- <b:blue>an underground brook in the Minithawkin Mines</>")
        wait(6)
        self.room:send(tostring(self.name) .. " says, 'Once you have examined all six sites, return and I shall")
        self.room:send("</>try the transformation again.'")
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " says, 'You haven't been trying to collect samples in this have")
        self.room:send("</>you?'")
    end
elseif stage == 6 then
    if object.id == 2808 then
        _return_value = false
        self:say("You haven't completed all of your examinations yet!")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your<b:white>[progress]</>?'")
    else
        _return_value = false
        self:say("What is this for?")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Do you need a reminder of your <b:white>[progress]</>?'")
    end
elseif stage == 7 then
    if object.id == 2808 then
        wait(2)
        self:destroy_item("dragon-bone-cup")
        self.room:send(tostring(self.name) .. " says, 'Everything is ready!  I shall attempt the transformation")
        self.room:send("</>again.'")
        wait(2)
        self.room:send(tostring(self.name) .. " rises up like a tower on the water.")
        self.room:send("The Great Wave swells as the waters of the Blue Lake rise to meet it.")
        wait(4)
        actor:send(tostring(self.name) .. " crests and breaks, washing over you!")
        self.room:send_except(actor, tostring(self.name) .. " crests and breaks, washing over " .. tostring(actor.name) .. "!")
        wait(6)
        actor:send("You feel your body liquify as the Great Wave swirls over, in, and through you.")
        actor:send("You can feel the rushing waters of the world in every particle of your being as you join with the Great Wave and the Blue Lake.")
        self.room:send_except(actor, tostring(actor.name) .. " liquifies and joins with the waters of the Great Wave and the Blue Lake.")
        wait(5)
        skills.set_level(actor, "waterform", 100)
        actor:send("<b:blue>The Great Wave imparts the method to transform your body into pure raging water!</>")
        actor:complete_quest("waterform")
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("This is not the dragon bone cup.")
    end
else
    _return_value = false
    self:say("I don't remember asking you to retrieve this.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return _return_value