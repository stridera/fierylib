-- Trigger: Emmath blue flame receive
-- Zone: 52, ID: 14
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #5214

-- Converted from DG Script #5214: Emmath blue flame receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
get_room(238, 90):at(function()
    run_room_trigger(23814)
end)
-- flameball
if actor:get_quest_stage("emmath_flameball") == 2 and actor.quest_stage["type_wand"] ~= "step" then
    wait(2)
    self:destroy_item("blue-flame")
    self:command("eye")
    actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.'")
    actor:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    wait(2)
    self:destroy_item("blue-flame")
    actor:send(tostring(self.name) .. " says, 'Ah yes... the blue flame.'")
    self:command("smile self")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Such a pity to destroy such an artifact as this.'")
    self:emote("pauses momentarily.")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'But it must be done.'")
    wait(1)
    self:emote("crushes the blue flame in his hand, its essence evaporating into the air.")
    wait(2)
    self:command("lick")
    wait(2)
    self:command("look " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I.  You seem ready for the power.'")
    actor.name:erase_quest("emmath_flameball")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
    self.room:spawn_object(52, 10)
    self:command("give ball " .. tostring(actor.name))
end
-- phase wand
if actor.quest_stage["type_wand"] then
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
        if actor.quest_variable["type_wand:task2"] then
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'You already gave me this.'")
        else
            actor:set_quest_var(type .. "_wand", "task2", 1)
            wait(2)
            world.destroy(object)
            actor:send(tostring(self.name) .. " says, 'This is just what I need.'")
            wait(1)
            local job1 = actor.quest_variable["type_wand:task1"]
            local job2 = actor.quest_variable["type_wand:task2"]
            local job3 = actor.quest_variable["type_wand:task3"]
            if job1 and job2 and job3 then
                actor:send(tostring(self.name) .. " says, 'Let me prime the " .. tostring(weapon) .. ".'")
            else
                actor:send(tostring(self.name) .. " says, 'Now finish practicing with your " .. tostring(weapon) .. ".'")
            end
        end
    end
end
return _return_value