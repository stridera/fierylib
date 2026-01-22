-- Trigger: vilekka-greet
-- Zone: 237, ID: 50
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #23750

-- Converted from DG Script #23750: vilekka-greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- Here we go, the big evil vilekka_stew quest of DEATH!! :)
-- This is a quest designed for neutral and evil types only.
-- If good players want a quest, see the sunfire_rescue quest.
if actor.id ~= -1 or actor.level > 99 or actor:get_has_completed("vilekka_stew") then
    return _return_value
end
wait(1)
-- If they are coming back with the items she said to fetch...
-- Starting with the heart of the drow master from Anduin...
if actor:get_quest_stage("vilekka_stew") == 1 then
    self.room:send("The High Priestess says, 'Well? Do you have the heart of that traitor?'")
    self.room:send("She looks greedy.  'Give it to me if you do.  You may ask about your <b:white>[progress]</> if you need.'")
elseif actor:get_quest_stage("vilekka_stew") == 2 then
    self:command("wink " .. tostring(actor.name))
    self:say("Well?  Continue now or stop?")
elseif actor:get_quest_stage("vilekka_stew") == 3 then
    -- Here we have the second stage, the head of the drider king
    self:say("Well?  Have you brought me the head of my enemy?")
    self.room:send("The High Priestess licks her lips.")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Give it to me.  You may ask about your <b:white>[progress]</> if you need.'")
elseif actor:get_quest_stage("vilekka_stew") == 4 then
    self:command("grin " .. tostring(actor.name))
    self:say("Well?  Do you wish to continue now?")
elseif actor:get_quest_stage("vilekka_stew") == 5 then
    -- Now here we have the player supposedly returning with spices and herbs.
    self.room:send(tostring(self.name) .. " says, 'At last, I can carry out the Spider Queen's orders!  Give me the spices and herbs!  The finest of the realm!  Ask for a reminder of your <b:white>[progress]</> if you need.'")
else
    -- IE, if they haven't started the quest.
    if actor.alignment < 349 then
        actor.name:send(tostring(self.name) .. " looks up at you.")
        self.room:send_except(actor, tostring(self.name) .. " looks up at " .. tostring(actor.name) .. ".")
        self.room:send("She says, 'Welcome to my city!  All who are not followers of the path of good are welcome here.'")
        wait(2)
        actor.name:send("She looks closely at you.")
        self.room:send_except(actor, "She looks closely at " .. tostring(actor.name) .. ".")
        self.room:send(tostring(self.name) .. " says, 'In fact, perhaps you can help me.  Yes, I think you can help me perform a great service to the city.'")
    else
        actor.name:send(tostring(self.name) .. " sneers at you.")
        self.room:send_except(actor, tostring(self.name) .. " sneers at " .. tostring(actor.name) .. ".")
        self:say("So, you think you can just wander around my city?")
        self.room:send(tostring(self.name) .. " laughs.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Get out of my sight.  I find your presence annoying.'")
        wait(1)
        self.room:send_except(actor, "<magenta>Vilekka gestures at " .. tostring(actor.name) .. ", and " .. tostring(actor.name) .. " disappears.</>")
        actor.name:teleport(get_room(237, 93))
        wait(1)
        get_room(237, 93):at(function()
            actor.name:send("<magenta>Vilekka gestures at you, and your vision wavers...</>")
        end)
        -- Can't use mat while forcing them to look - they will see the
        -- priestess as she is temporarily in the room due to mat.
        get_room(237, 93):at(function()
            actor.name:send("You find yourself back in the temple.")
        end)
    end
end