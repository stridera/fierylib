-- Trigger: Emmath staff receive
-- Zone: 52, ID: 15
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #5215

-- Converted from DG Script #5215: Emmath staff receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local minlevel = (step - 1) * 10
if actor.level < ((step - 1) * 10) then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You'll need to be at least level " .. tostring(minlevel) .. " before I can improve your bond with your weapon.'")
    return _return_value
elseif actor.has_completed["type_wand"] then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'You already have the most powerful " .. tostring(type) .. " " .. tostring(weapon) .. " in existence!'")
    return _return_value
elseif actor.quest_stage["type_wand"] < step then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Your " .. tostring(weapon) .. " isn't ready for improvement yet.'")
    return _return_value
elseif actor.quest_stage["type_wand"] == "step" then
    local stage = actor.quest_stage["type_wand"]
    if actor.quest_variable["type_wand:task4"] then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'I already primed your " .. tostring(weapon) .. ".'")
    else
        local job1 = actor.quest_variable["type_wand:task1"]
        local job2 = actor.quest_variable["type_wand:task2"]
        local job3 = actor.quest_variable["type_wand:task3"]
        if job1 and job2 and job3 then
            local room = get.room[task4]
            actor:set_quest_var(type .. "_wand", "task4", 1)
            wait(2)
            actor:send(tostring(self.name) .. " utters eldritch incantations over " .. tostring(object.shortdesc) .. ".")
            wait(2)
            self.room:send(tostring(object.shortdesc) .. " begins to crackle with supreme elemental power!")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Now that you've captured the demon's energies, you must make your way deep into the elementals planes.  There, in the full glory of elemental " .. tostring(type) .. ", find " .. tostring(room.name) .. " and <b:cyan>imbue</> it with the power of the plane.'")
            wait(6)
            actor:send(tostring(self.name) .. " says, 'It will forge the most powerful " .. tostring(weapon) .. " of " .. tostring(type) .. " in all the realms!'")
            self:command("give all " .. tostring(actor))
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            if not job1 then
                local remaining = ((actor.quest_stage["type_wand"] - 1) * 50) - actor.quest_variable["type_wand:attack_counter"]
                actor:send(tostring(self.name) .. " says, 'You still need to attack " .. tostring(remaining) .. " more times to fully bond with your " .. tostring(weapon) .. "!'")
                wait(1)
            end
            if not job2 then
                local gem_zone, gem_local = gem // 100, gem % 100
                if gem_zone == 0 then gem_zone = 1000 end
                actor:send(tostring(self.name) .. " says, 'You have to give me " .. objects.template(gem_zone, gem_local).shortdesc .. " first.'")
                wait(1)
            end
            if not job3 then
                local task3_zone, task3_local = task3 // 100, task3 % 100
                if task3_zone == 0 then task3_zone = 1000 end
                actor:send(tostring(self.name) .. " says, 'You still need to slay " .. mobs.template(task3_zone, task3_local).shortdesc .. ".'")
            end
        end
    end
end
return _return_value