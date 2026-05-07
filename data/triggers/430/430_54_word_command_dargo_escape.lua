-- Trigger: word_command_dargo_escape
-- Zone: 430, ID: 54
-- Type: MOB, Flags: ENTRY
-- Status: NEEDS_REVIEW
--   TODO(parity): legacy logic was heavily DG-flavored; reworked to runtime
--   semantics but the multi-room escape choreography (Cyprianum re-spawn,
--   Dargo teleports) should be playtested end-to-end.
--
-- Original DG Script: #43054

-- Converted from DG Script #43054: word_command_dargo_escape
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
if not globals.questor then
    return true
end
local questor = self.room:find_actor(globals.questor)
if self.room.zone_id == 430 and self.room.local_id == 37 then
    if world.count_mobiles(430, 17) > 0 then
        get_room(430, 176):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(430, 148))
    else
        local escape = false
        if questor then
            for _, person in ipairs(questor.group) do
                if person.room == self.room and person:get_quest_stage("word_command") == 3 then
                    escape = true
                end
            end
        end
        if not escape then
            get_room(430, 92):at(function()
                self.room:spawn_mobile(430, 16)
            end)
            self.room:send("Cyprianum the Reaper shouts, 'You didn't think you could escape without confronting me and my servant, did you Dargo?'")
            get_room(430, 176):at(function()
                self.room:spawn_mobile(430, 17)
            end)
            self.room:send(tostring(self.name) .. " shrieks as he vanishes in a flash of light and crimson haze!")
            self:teleport(get_room(430, 148))
        end
    end
elseif self.room.zone_id == 430 and self.room.local_id == 176 then
    if world.count_mobiles(430, 16) > 0 then
        self.room:send(tostring(mobiles.template(430, 16).name) .. " shouts, 'I will never allow you to harm my master!'")
        self.room:send("<b:red>" .. tostring(self.name) .. " is consumed in a crackle of red lightning and vanishes!</>")
        self.room:send("Cackling laughter echoes through the maze!")
        self:teleport(get_room(430, 148))
    end
elseif self.room.zone_id == 430 and self.room.local_id == 0 then
    if world.count_mobiles(430, 17) > 0 then
        get_room(430, 176):at(function()
            self.room:find_actor("cyprianum"):shout("You can never escape me!")
        end)
        self.room:send("<red>" .. tostring(self.name) .. " vanishes in a flash of light and crimson haze!</>")
        self:emote("shrieks as he disappears!")
        self.room:send("Cackling laughter echoes through the halls.")
        self:teleport(get_room(430, 148))
    else
        self:command("cheer")
        self:say("Thank you so much!")
        if questor then
            for _, person in ipairs(questor.group) do
                if person.room == self.room then
                    if person:get_quest_stage("word_command") == 3 then
                        person:send(self.name .. " tells you, 'As promised, here is the spell.'")
                        person:send(tostring(self.name) .. " gives you a disintegrating scroll with an ancient spell on it.")
                        skills.set_level(person.name, "word of command", 100)
                        person:send("<b:magenta>You have learned Word of Command!</>")
                        person:complete_quest("word_command")
                    elseif person.is_player then
                        person:send(self.name .. " tells you, 'To show my gratitude, take this.'")
                        local count = 0
                        while count < 3 do
                            local what_gem_drop = random(1, 11)
                            self.room:spawn_object(557, 36 + what_gem_drop)
                            count = count + 1
                        end
                        self:command("give all.gem " .. tostring(person.name))
                    end
                end
            end
        end
        self.room:send(tostring(self.name) .. " waves farewell!")
        world.destroy(self)
    end
end
