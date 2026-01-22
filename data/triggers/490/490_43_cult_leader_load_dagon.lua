-- Trigger: cult_leader_load_dagon
-- Zone: 490, ID: 43
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #49043

-- Converted from DG Script #49043: cult_leader_load_dagon
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if self.room ~= 49091 then
    self:teleport(get_room(490, 91))
else
    if actor.id == -1 then
        local stage = 5
        local person = actor
        local i = person.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = person.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("griffin_quest") >= stage then
                    local load = "yes"
                    if person:get_quest_stage("griffin_quest") == "stage" then
                        person.name:advance_quest("griffin_quest")
                        person:send("<b:white>You have advanced the quest!</>")
                    end
                end
            elseif person and person.id == -1 then
                local i = i + 1
            end
            local a = a + 1
        end
    end
end
if load == "yes" then
    if world.count_mobiles("49021") == 0 then
        wait(2)
        self:command("cackle")
        self:say("You are too late!  It is time to call the great Dagon!")
        wait(2)
        self:emote("makes some mystical moves with his hands and whispers an ancient spell.")
        self.room:send("There is a shimmer in the air and suddenly Dagon stands before you.")
        get_room(11, 0):at(function()
            self.room:spawn_mobile(490, 21)
        end)
        self.room:spawn_object(490, 1)
        get_room(11, 0):at(function()
            self:command("give griffin-skin dagon")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("dagon"):command("wear skin")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("dagon"):teleport(get_room(490, 91))
        end)
        self.room:find_actor("dagon"):command("roar")
        wait(4)
        self.room:find_actor("dagon"):say("At last, summoned to the aid of my faithful.")
    end
end