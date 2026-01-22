-- Trigger: Nukreth Spire quest end
-- Zone: 462, ID: 30
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #46230

-- Converted from DG Script #46230: Nukreth Spire quest end
-- Original: MOB trigger, flags: ENTRY, probability: 100%
wait(2)
if destination == 46200 then
    leader:set_quest_var("nukreth_spire", "path%number%", 1)
    if self.id == 46220 then
        self:emote("breathes a deep sigh of relief.")
        self.room:send(tostring(self.name) .. " says, 'I can't believe it...  I never thought we would see the")
        self.room:send("</>sky again.  And it's all thanks to you, " .. tostring(leader) .. ".'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I don't know how we'll ever be able to repay you.'")
        wait(1)
        self:say("Please, take these.  It's all we have left.")
        self.room:spawn_object(5, 36)
        self:command("give sandals " .. tostring(leader))
        wait(2)
        self:say("Now, we'll have to try to start over.  Come on honey.")
        wait(1)
        self.room:send(tostring(self.name) .. " and her husband make their way into the pine barrens headed for Solta.")
        world.destroy(self.room:find_actor("limping-slave"))
    elseif self.id == 46221 then
        self:emote("cries tears of joy.")
        self.room:send(tostring(self.name) .. " says, 'I thought I was going to die in there.  But now I can")
        self.room:send("</>take my baby home and hatch it safely.'")
        wait(1)
        self:say("I don't know how I can thank you.")
        wait(1)
        self:say("Please, take this.  It's all I have.")
        self.room:spawn_object(462, 11)
        self:command("give kobold " .. tostring(leader))
        wait(2)
        self.room:send(tostring(self.name) .. " scurries off into the pine barrens.")
    elseif self.id == 46222 then
        self:emote("bellows a mighty roar!!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I will be back, with all of Ogakh at my side, and we will")
        self.room:send("</>CRUSH these mongrels!'")
        wait(2)
        self:say("I would not have survived without you, " .. tostring(leader) .. ".")
        wait(1)
        self:say("Take this.  Saved it from my time in the army.")
        self.room:spawn_object(462, 10)
        self:command("give faceplate " .. tostring(leader))
        wait(2)
        self:say("Good hunting.")
        self:command("salute")
        wait(2)
        self.room:send(tostring(self.name) .. " marches into the pine barrens.")
    elseif self.id == 46223 then
        self:command("shiver")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Some things can never be unseen.  I'm a changed man, I")
        self.room:send("</>is.'")
        wait(1)
        self:say("'Ere.  May it bring you more luck than it did me.'")
        self.room:spawn_object(462, 9)
        self:command("give ioun " .. tostring(leader))
        wait(2)
        self:say("I best be on me way.")
        self:command("tip")
        self.room:send(tostring(self.name) .. " turns and scuttles off into the pine barrens.")
    end
    local path1 = leader:get_quest_var("nukreth_spire:path1")
    local path2 = leader:get_quest_var("nukreth_spire:path2")
    local path3 = leader:get_quest_var("nukreth_spire:path3")
    local path4 = leader:get_quest_var("nukreth_spire:path4")
    local complete = path1 + path2 + path3 + path4
    if complete == 4 then
        local loop = 1
        while loop < 5 do
            leader:set_quest_var("nukreth_spire", "path%loop%", 0)
            local loop = loop + 1
        end
    end
    world.destroy(self)
end