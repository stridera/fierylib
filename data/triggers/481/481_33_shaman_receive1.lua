-- Trigger: shaman_receive1
-- Zone: 481, ID: 33
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #48133

-- Converted from DG Script #48133: shaman_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 48122 then
    wait(2)
    self:destroy_item("head")
    self:command("bow " .. tostring(actor.name))
    self:say("You are indeed a mighty warrior.  Please have this gift as a token of my appreciation.")
    self.room:spawn_object(481, 23)
    self:command("give stone-necklace " .. tostring(actor.name))
    wait(1)
    self:command("consider " .. tostring(actor.name))
    wait(1)
    local person = actor
    local i = person.group_size
    local levelcheck = 0
    local queststart = 0
    local lowlevel = 0
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person.level >= 50 then
                local levelcheck = 1
                if person:get_quest_stage("fieryisle_quest") <= 1 then
                    if person:get_quest_stage("fieryisle_quest") == 0 then
                        person.name:start_quest("fieryisle_quest")
                        person:send("<b:white>You have now begun the Fiery Island quest!</>")
                    end
                    local queststart = 1
                    person.name:set_quest_var("fieryisle_quest", "chimera", "dead")
                end
            else
                person:send("<red>You are too low level to continue this quest.</>")
                local lowlevel = 1
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
end
if levelcheck then
    if queststart then
        if lowlevel then
            self.room:send(tostring(self.name) .. " says, 'Some of you are still too inexperienced but...'")
            wait(2)
        end
        self.room:send(tostring(self.name) .. " says, 'I wonder if you are mighty enough to take on Vulcera herself - we are sick of her spiteful acts against us.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'Of course, you would need the correct phrase to open the secret entrance to the volcano.  The phrase is <b:cyan>buntoi nakkarri karisto</>.'")
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'If you find the son of the warlord inside, he may have gleaned some information about Vulcera.'")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'May the true volcano god look after you and help you destroy the usurper.'")
        wait(5)
        self.room:send(tostring(self.name) .. " says, 'If you forget what to do, you can come back to me and check on your <b:cyan>[progress]</>.'")
    else
        if lowlevel then
            self.room:send(tostring(self.name) .. " says, 'Some of you are still too inexperienced but...'")
            wait(2)
        end
        self.room:send(tostring(self.name) .. " says, 'Remember, the mystic phrase to open the volcano is <b:cyan>'buntoi nakkarri karisto'</>.  May the true volcano god guide you.'")
    end
else
    self.room:send(tostring(self.name) .. " says, 'You are a bit inexperienced to take on Vulcera, although you have done well to kill the chimera.  Thank you for your help, " .. tostring(actor.name) .. ".  Perhaps we will meet again when you have seen more of the world.'")
end