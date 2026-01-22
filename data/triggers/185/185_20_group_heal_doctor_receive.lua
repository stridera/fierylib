-- Trigger: group_heal_doctor_receive
-- Zone: 185, ID: 20
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--   Large script: 8201 chars
--
-- Original DG Script: #18520

-- Converted from DG Script #18520: group_heal_doctor_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("group_heal")
if stage == 2 then
    if object.id == 18513 then
        self:destroy_item("supplies")
        wait(2)
        self:say("Thank you so much!  This is an enormous relief!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Now I can get to working on that ritual to create a portable")
        self.room:send("</>healing spell and teach you about healing groups of people in the process,")
        self.room:send("</>" .. tostring(actor.name) .. ".'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Based on books I found in our library, historical records")
        self.room:send("</>indicate the last anyone heard of this spell a hearth priest was working on")
        self.room:send("</>perfecting it.  He worked out of a kitchen somewhere in the")
        self.room:send("</><green>Great Northern Swamps</>.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'I'm not sure how helpful that is, but maybe if you <b:white>search</>")
        self.room:send("</>through some of the abandoned kitchens out there, you'll find something useful.'")
        -- switch on random(1, 3)
        if random(1, 3) == 1 then
            -- Mystwatch
            local room = 16051
        elseif random(1, 3) == 2 then
            -- Nordus
            local room = 51012
        else
            -- Sunken
            local room = 53178
        end
        actor:set_quest_var("group_heal", "room", room)
        actor:advance_quest("group_heal")
    else
        _return_value = false
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'These aren't our missing supplies.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
elseif stage == 4 then
    if object.id == 18514 then
        actor:advance_quest("group_heal")
        wait(2)
        self:emote("scans through the book.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Strange, this doesn't look like a ritual at all, at least")
        self.room:send("</>not in the strictest sense.  It looks more like... like a meal.'")
        wait(1)
        self:say("A very BIG meal...")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Huh... Well those sure are some unusual dishes.  I've never")
        self.room:send("</>seen anything quite like this before.  I don't even know what half these")
        self.room:send("</>ingredients are.'")
        wait(4)
        self:say("I'm a doctor, dammit, not a chef!")
        wait(2)
        self:command("ponder")
        wait(2)
        self:say("A chef!  That's it!")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Could you go consult with different <b:white>chefs</> and <b:white>cooks</> to")
        self.room:send("</>figure out what these things are?  I'm sure I can procure the ingredients once")
        self.room:send("</>I know what I actually need.'")
        wait(5)
        self:say("It looks like there are six parts to this.")
        wait(1)
        self:command("give rite " .. tostring(actor.name))
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Seek out a professional for each part, <b:white>give them the rite</>,")
        self.room:send("</>and get some notes from them.'")
        wait(3)
        self:say("Thank you for your help!")
    else
        _return_value = false
        wait(2)
        self:say("This doesn't look like it will be of any help.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
elseif stage == 5 then
    if object.id == 18515 or object.id == 18516 or object.id == 18517 or object.id == 18518 or object.id == 18519 or object.id == 18520 then
        if actor:get_quest_var("group_heal:" .. tostring(object.vnum)) == 1 then
            _return_value = false
            wait(2)
            self:command("shake")
            self:say("You already brought me " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
        else
            self:destroy_item("notes")
            actor:set_quest_var("group_heal", tostring(object.vnum), 1)
            local total = actor:get_quest_var("group_heal:total") + 1
            actor:set_quest_var("group_heal", "total", total)
            wait(2)
            self:say("Thank you!")
            wait(1)
            self:emote("studies the notes.")
            wait(2)
            self:say("Ah yes, I see.")
            wait(1)
            -- switch on random(1, 4)
            if random(1, 4) == 1 then
                self:say("I can substitute that with that?  Interesting!")
            elseif random(1, 4) == 2 then
                self:say("That looks like a very reasonable suggestion!")
            elseif random(1, 4) == 3 then
                self:say("Oh so that's what that thing is called now...")
            else
                self:say("I see how this works!")
            end
        end
        if total == 6 then
            self:destroy_item("notes")
            actor:advance_quest("group_heal")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'That looks like everything!  May I have that copy of the Rite")
            self.room:send("</>please?'")
        else
            wait(1)
            self:say("Please, bring me the notes on the rest of the rite!")
        end
    end
elseif stage == 6 then
    if object.id == 18514 then
        actor:set_quest_var("group_heal", "total", 0)
        wait(2)
        self:destroy_item("heroes-feast")
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I think I can put this together now!!  Wait here while I")
        self.room:send("</>prepare the feast.'")
        wait(2)
        self:emote("leaves for the kitchens.")
        self:teleport(get_room(11, 0))
        wait(8)
        get_room(185, 30):at(function()
            self.room:send("Delicious smells and the sound of chanting begin to waft in from the courtyard.")
        end)
        wait(10)
        self:teleport(get_room(185, 30))
        self:emote("returns with an incredible feast!")
        wait(4)
        self:emote("carefully divides up the feast and neatly packages it along with medical supplies.")
        self.room:spawn_object(185, 21)
        self.room:spawn_object(185, 21)
        self.room:spawn_object(185, 21)
        self.room:spawn_object(185, 21)
        self.room:spawn_object(185, 21)
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'The final thing I ask is for you to go out into the world")
        self.room:send("</>and help those in need.'")
        wait(4)
        self:say("Here, take these care packages of food and medicine.")
        wait(2)
        self:command("give all.food " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Seek out five creatures who are <b:white>sick</>, <b:white>injured</>, <b:white>dying</>,")
        self.room:send("</><b:white>wounded</>, or <b:white>hobbling</>. Bring them succor with those packages.'")
        wait(4)
        self:say("Except for Lirne.")
        wait(2)
        self:command("grumble")
        wait(2)
        self:say("He needs to learn his lesson eventually.")
        wait(4)
        self:say("May St. George ever smile upon your endeavors!")
        wait(2)
        self:command("wave " .. tostring(actor.name))
    else
        _return_value = false
        self:say("I'm afraid this won't be of much use to me right now.")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
else
    _return_value = false
    self:say("I'm afraid this won't be of much use to me right now.")
    actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
end
return _return_value