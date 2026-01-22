-- Trigger: group_heal_chefs_receive
-- Zone: 185, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--   Large script: 6291 chars
--
-- Original DG Script: #18522

-- Converted from DG Script #18522: group_heal_chefs_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
_return_value = false
if object.id == 18514 and actor:get_quest_stage("group_heal") == 5 then
    if actor.quest_variable[group_heal:self.vnum] then
        if self.id == 50203 then
            actor:send(tostring(self.name) .. " moans and swats your hand away.")
            self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
        elseif self.id == 51007 then
            self:command("cackle " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " inches away from you.")
            self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
        else
            self:say("I've told you everything I can.  Good luck!")
        end
    else
        actor.name:set_quest_var("group_heal", "%self.vnum%", 1)
        -- switch on self.id
        if self.id == 8307 then
            -- the Frakati Chef
            self:say("So you would like some help?  Looks like quite a meal.")
            wait(2)
            self.room:send(tostring(self.name) .. " says, 'Roasting methods may be a little difficult to control.")
            self.room:send("</>I can share with you some methods the Frakati people use to prepare and roast")
            self.room:send("</>wild game.'")
            wait(4)
            self:emote("writes down several notes.")
            wait(3)
            self.room:spawn_object(185, 15)
            self:command("give notes " .. tostring(actor.name))
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'These small tips will make sure your meats stay tender")
            self.room:send("</>and juicy while soaking up as much flavor as possible.'")
            wait(2)
            self:say("Good luck.")
        elseif self.id == 51007 then
            -- the crazy chef
            self:emote("begins to run in a circle laughing hysterically.")
            wait(4)
            self:emote("stops running and starts writing.")
            wait(2)
            self.room:send(tostring(self.name) .. " keeps laughing and writing...")
            wait(2)
            self.room:send("... and writing...")
            wait(2)
            self.room:send("... and writing...")
            wait(2)
            self.room:send("... and writing...")
            wait(4)
            self.room:spawn_object(185, 16)
            self:command("give notes " .. tostring(actor.name))
            self:command("laugh " .. tostring(actor.name))
        elseif self.id == 18512 then
            -- a scruffy cook
            self.room:send(tostring(self.name) .. " says, 'Well what is this?  I heard the doctor talking about a")
            self.room:send("</>feast of some kind...'")
            wait(2)
            self:emote("trails off while reading the ritual recipe.")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Well I can definitely help out with some of this.")
            self.room:send("</>Desserts aren't considered a specialty of our Abbey because most bakers")
            self.room:send("</>prefer techniques and ingredients no longer suited for monastic life.'")
            wait(3)
            self.room:send(tostring(self.name) .. " says, 'But since we still see the value in what you can grow")
            self.room:send("</>and process by hand, I can easily help replicate a recipe this old.'")
            wait(4)
            self.room:spawn_object(185, 17)
            self:emote("writes down a list of notes.")
            self:command("give notes " .. tostring(actor.name))
            wait(1)
            self:say("This should meet the doctor's needs.")
        elseif self.id == 30003 then
            -- Dugrik
            self.room:send(tostring(self.name) .. " says, 'Normally I'd charge for this.  But since that's \"illegal\" here")
            self.room:send("</>now, I guess you got lucky.'")
            wait(3)
            self:say("Yeah, I see something I can help with.")
            wait(3)
            self:emote("points to several spots on the paper.")
            self:say("Make this adjustment here, here, and here.")
            wait(4)
            self:emote("points to another section.")
            self.room:send(tostring(self.name) .. " says, 'This word just means \"boil.\"  It will do exactly the same thing if")
            self.room:send("</>you just boil it.'")
            wait(4)
            self.room:send(tostring(self.name) .. " says, 'Oh and be real careful with that one there.  Unless you got an")
            self.room:send("</>orcish constitution, cook it wrong and you can poison yourself.'")
            self:command("chuckle")
            wait(1)
            self.room:spawn_object(185, 18)
            self:command("give notes " .. tostring(actor.name))
        elseif self.id == 50203 then
            -- the zombified pirate cook
            self.room:send(tostring(self.name) .. " moans.")
            wait(2)
            self:emote("shambles into the wall with a great THUD!")
            self.room:send("A book of barely preserved pieces of paper falls from a shelf onto what remains of " .. tostring(self.name) .. "'s head.")
            self.room:spawn_object(185, 19)
            wait(1)
            self:command("drop notes")
        else
            _return_value = false
        end
        self:command("give notes " .. tostring(actor.name))
    end
else
    if self.id == 50203 then
        actor:send(tostring(self.name) .. " moans and swats your hand away.")
        self.room:send_except(actor, tostring(self.name) .. " moans and swats " .. tostring(actor.name) .. "'s hand away.")
    elseif self.id == 51007 then
        self:command("cackle " .. tostring(actor.name))
        actor:send(tostring(self.name) .. " inches away from you.")
        self.room:send_except(actor, tostring(self.name) .. " inches away from " .. tostring(actor.name) .. ".")
    else
        self:say("Sorry, what is this?")
        actor:send(tostring(self.name) .. " returns " .. tostring(object.shortdesc) .. " to you.")
    end
end
return _return_value