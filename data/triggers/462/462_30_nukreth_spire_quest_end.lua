-- Trigger: Nukreth Spire quest end
-- Zone: 462, ID: 30
-- Type: MOB, Flags: ENTRY
-- Status: CLEAN
--
-- Original DG Script: #46230

-- Converted from DG Script #46230: Nukreth Spire quest end
-- Original: MOB trigger, flags: ENTRY, probability: 100%
-- TODO(parity): legacy `destination == 46200` was the entry-room vnum
-- check. Verify this triggers when the captive enters (462, 0). Also
-- legacy used DG `%number%`/`%loop%` interpolations in quest var names —
-- we resolve `globals.number` (set in 462_07) and iterate path1..path4.
wait(2)
if destination == 46200 then
    local leader_name = globals.leader
    local leader = leader_name and find_player(leader_name) or nil
    if not leader then
        return true
    end
    local number = globals.number or (self.local_id - 19)
    leader:set_quest_var("nukreth_spire", "path" .. tostring(number), 1)
    if self.local_id == 20 then
        self:emote("breathes a deep sigh of relief.")
        self.room:send(tostring(self.name) .. " says, 'I can't believe it...  I never thought we would see the")
        self.room:send("</>sky again.  And it's all thanks to you, " .. tostring(leader_name) .. ".'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I don't know how we'll ever be able to repay you.'")
        wait(1)
        self:say("Please, take these.  It's all we have left.")
        self.room:spawn_object(4, 136)
        self:command("give sandals " .. tostring(leader_name))
        wait(2)
        self:say("Now, we'll have to try to start over.  Come on honey.")
        wait(1)
        self.room:send(tostring(self.name) .. " and her husband make their way into the pine barrens headed for Solta.")
        world.destroy(self.room:find_actor("limping-slave"))
    elseif self.local_id == 21 then
        self:emote("cries tears of joy.")
        self.room:send(tostring(self.name) .. " says, 'I thought I was going to die in there.  But now I can")
        self.room:send("</>take my baby home and hatch it safely.'")
        wait(1)
        self:say("I don't know how I can thank you.")
        wait(1)
        self:say("Please, take this.  It's all I have.")
        self.room:spawn_object(462, 11)
        self:command("give kobold " .. tostring(leader_name))
        wait(2)
        self.room:send(tostring(self.name) .. " scurries off into the pine barrens.")
    elseif self.local_id == 22 then
        self:emote("bellows a mighty roar!!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'I will be back, with all of Ogakh at my side, and we will")
        self.room:send("</>CRUSH these mongrels!'")
        wait(2)
        self:say("I would not have survived without you, " .. tostring(leader) .. ".")
        wait(1)
        self:say("Take this.  Saved it from my time in the army.")
        self.room:spawn_object(462, 10)
        self:command("give faceplate " .. tostring(leader_name))
        wait(2)
        self:say("Good hunting.")
        self:command("salute")
        wait(2)
        self.room:send(tostring(self.name) .. " marches into the pine barrens.")
    elseif self.local_id == 23 then
        self:command("shiver")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Some things can never be unseen.  I'm a changed man, I")
        self.room:send("</>is.'")
        wait(1)
        self:say("'Ere.  May it bring you more luck than it did me.'")
        self.room:spawn_object(462, 9)
        self:command("give ioun " .. tostring(leader_name))
        wait(2)
        self:say("I best be on me way.")
        self:command("tip")
        self.room:send(tostring(self.name) .. " turns and scuttles off into the pine barrens.")
    end
    local path1 = leader:get_quest_var("nukreth_spire:path1") or 0
    local path2 = leader:get_quest_var("nukreth_spire:path2") or 0
    local path3 = leader:get_quest_var("nukreth_spire:path3") or 0
    local path4 = leader:get_quest_var("nukreth_spire:path4") or 0
    local complete = path1 + path2 + path3 + path4
    if complete == 4 then
        for loop = 1, 4 do
            leader:set_quest_var("nukreth_spire", "path" .. tostring(loop), 0)
        end
    end
    world.destroy(self)
end