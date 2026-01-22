-- Trigger: fire_goddess_skirt
-- Zone: 43, ID: 38
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #4338

-- Converted from DG Script #4338: fire_goddess_skirt
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
self:set_flag("sentinel", true)
if object.id == 4305 then
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("theatre") >= 5 then
                local accept = "yes"
                if person:get_quest_stage("theatre") == 5 then
                    person:advance_quest("theatre")
                    person:send("<b:white>You have advanced the quest!</>")
                end
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
    wait(2)
    self:command("blush")
    self:emote("says sheepishly, 'I was wondering where I left that.'")
    self:command("rest")
    wait(5)
    self:command("remove sash")
    self:command("drop sash")
    self:command("wear skirt")
    wait(3)
    self:emote("composes herself.")
    wait(2)
    if accept == "yes" then
        self:emote("clears her throat.")
        wait(2)
        self:say("Well, I suppose this means you dealt with the monkeys and helped our cast.  Thanks to you, our show has a chance of going on!")
        wait(4)
        self:say("However, we're still missing one important thing...")
        wait(2)
        actor:send("The Fire Goddess eyes you suspiciously.")
        self.room:send_except(actor, "The Fire Goddess eyes " .. tostring(actor.name) .. " suspiciously.")
        wait(2)
        actor:send("The Fire Goddess gives you an approving nod.")
        self.room:send_except(actor, tostring(actor) .. " The Fire Goddess gives " .. tostring(actor.name) .. " an approving nod.")
        self:say("Yes, I think you can help.")
        wait(4)
        -- (empty say)
        self:say("We need to find our Pippin in order to perform the grand Finale.  He's somewhere out in the world, trying to find his corner of the sky.")
        wait(4)
        self:say("I want you to bring him to us.")
        wait(2)
        -- (empty say)
        self:say("Take this.  Use its magic to lure him back to the theater.")
        self.room:spawn_object(43, 18)
        self:command("give torch " .. tostring(actor.name))
        wait(4)
        self:say("Hold it in your hand when you find him.  He won't be able to resist the beauty of one perfect flame.")
        wait(4)
        self:say("Now, when you get him back here, order him to enter the Fire Box.  We've prepared and hidden it upstage center just for him.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, <b:red>'Be careful not to get inside it yourself!'</>")
        wait(3)
        self:say("It's only for an extraordinary person like Pippin.")
        wait(4)
        self:say("We'll be waiting for you.")
    end
else
    _return_value = false
    actor:send("The Fire Goddess looks at you funny.")
    self.room:send_except(actor, "The Fire Goddess looks at " .. tostring(actor.name) .. " with an odd expression.")
    wait(2)
    self:say("What is this?")
end
self:set_flag("sentinel", false)
return _return_value