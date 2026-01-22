-- Trigger: word_command_dargo_escape
-- Zone: 430, ID: 54
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #43054

-- Converted from DG Script #43054: word_command_dargo_escape
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
if not questor then
    return _return_value
end
if self.room == 43037 then
    if world.count_mobiles("43017") > 0 then
        get_room(431, 76):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(431, 48))
    else
        local i = questor.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = questor.group_member[i]
            if person.room == self.room then
                if person:get_quest_stage("word_command") == 3 then
                    local escape = 1
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
        end
        if not escape then
            get_room(430, 92):at(function()
                self.room:spawn_mobile(430, 16)
            end)
            self.room:send("Cyprianum the Reaper shouts, 'You didn't think you could escape without confronting me and my servant, did you Dargo?'")
            get_room(431, 76):at(function()
                self.room:spawn_mobile(430, 17)
            end)
            self.room:send(tostring(self.name) .. " shrieks as he vanishes in a flash of light and crimson haze!")
            self:teleport(get_room(431, 48))
        end
    end
elseif self.room == 43176 then
    if world.count_mobiles("43016") > 0 then
        self.room:send(tostring(mobiles.template(430, 16).name) .. " shouts, 'I will never allow you to harm my master!'")
        self.room:send("<b:red>" .. tostring(self.name) .. " is consumed in a crackle of red lightning and vanishes!</>")
        self.room:send("Cackling laughter echoes through the maze!")
        self:teleport(get_room(431, 48))
    end
elseif self.room == 43000 then
    if world.count_mobiles("43017") > 0 then
        get_room(431, 76):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(431, 48))
    else
        self:command("cheer")
        self:say("Thank you so much!")
        local i = questor.group_size
        if i then
            local a = 1
        else
            local a = 0
        end
        while i >= a do
            local person = questor.group_member[a]
            if person.room == self.room then
                if person:get_quest_stage("word_command") == 3 then
                    person:send(self.name .. " tells you, '" .. "As promised, here is the spell." .. "'")
                    person:send(tostring(self.name) .. " gives you a disintegrating scroll with an ancient spell on it.")
                    skills.set_level(person.name, "word of command", 100)
                    person:send("<b:magenta>You have learned Word of Command!</>")
                    person.name:complete_quest("word_command")
                elseif person.id == -1 then
                    person:send(self.name .. " tells you, '" .. "To show my gratitude, take this." .. "'")
                    local count = 0
                    while count < 3 do
                        local what_gem_drop = random(1, 11)
                        local gem_vnum = what_gem_drop + 55736
                        self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                        local count = count + 1
                    end
                    self:command("give all.gem " .. tostring(person))
                end
            elseif person then
                local i = i + 1
            end
            local a = a + 1
            self.room:send(tostring(self.name) .. " waves farewell!")
            world.destroy(self)
        end
    end
end  -- auto-close block