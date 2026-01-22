-- Trigger: Emmath flames receive
-- Zone: 52, ID: 8
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 9279 chars
--
-- Original DG Script: #5208

-- Converted from DG Script #5208: Emmath flames receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 23822 then
    get_room(238, 90):at(function()
        run_room_trigger(23814)
    end)
    if actor.quest_stage[type_wand] == "wandstep" and not actor.quest_variable[type_wand:wandtask2] then
        return _return_value
    elseif actor:get_quest_stage("emmath_flameball") > 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        local flameball_item = "yes"
    end
elseif object.id == 17308 then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        local subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "black" then
            local right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        local flameball_item = "yes"
    end
elseif object.id == 5211 then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        local subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "white" then
            local right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        local flameball_item = "yes"
    end
elseif object.id == 5212 then
    if actor:get_quest_stage("pyromancer_subclass") > 0 and actor:get_quest_stage("pyromancer_subclass") <= 4 then
        local subclass_item = "yes"
        if actor:get_quest_var("pyromancer_subclass:part") == "gray" then
            local right_item = "yes"
        end
    elseif actor:get_quest_stage("emmath_flameball") >= 0 and actor:get_quest_stage("emmath_flameball") <= 3 then
        local flameball_item = "yes"
    end
end
if subclass_item then
    wait(2)
    self:destroy_item("questobject")
    -- switch on actor:get_quest_stage("pyromancer_subclass")
    if right_item == "yes" then
        if actor:get_quest_stage("pyromancer_subclass") == 4 then
            self:emote("hops up and down rapidly.")
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Goodness the spirit of the flame is complete once again!'")
            self:command("shake " .. tostring(actor.name))
            self:command("grin")
            wait(2)
            actor.name:complete_quest("pyromancer_subclass")
            actor:command("subclass")
        else
            self:command("eyebrow")
            actor:send(tostring(self.name) .. " says, 'No, I already control this part of the flame.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
        end
    elseif actor:get_quest_stage("pyromancer_subclass") == 3 then
        self:command("frown " .. tostring(actor.name))
        if right_item == "yes" then
            actor:send(tostring(self.name) .. " says, 'A shame you didn't retrieve the flame yourself.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Maybe you should do it yourself this time.'")
        else
            actor:send(tostring(self.name) .. " says, 'No, no.  You brought me the wrong flame!'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'I asked you to bring me the " .. tostring(actor:get_quest_var("pyromancer_subclass:part")) .. " one.'")
        end
    elseif actor:get_quest_stage("pyromancer_subclass") == 2 or actor:get_quest_stage("pyromancer_subclass") == 1 then
        actor:send(tostring(self.name) .. " says, 'Curious...  I have not even told you what the quest is yet...'")
    else
        actor:send(tostring(self.name) .. " says, 'What a lovely gift, it will fit nicely on my shelf.'")
        self:command("thank " .. tostring(actor.name))
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Shame you were not performing a quest, you seem like a friend of fire.'")
    end
elseif flameball_item then
    if actor:get_quest_stage("emmath_flameball") == 1 then
        _return_value = false
        wait(2)
        self:command("frown")
        actor:send(tostring(self.name) .. " says, 'But I didn't even tell you what I wanted yet!'")
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'How do you expect to gain power like this?'")
    elseif actor:get_quest_stage("emmath_flameball") == 2 then
        if (object.id == 5211) or (object.id == 5212) or (object.id == 17308) then
            if actor.quest_variable[emmath_flameball:object.vnum] ~= 1 then
                local count = 1 + actor:get_quest_var("emmath_flameball:count")
                actor.name:set_quest_var("emmath_flameball", "count", count)
                actor.name:set_quest_var("emmath_flameball", "%object.vnum%", 1)
            else
                _return_value = false
                wait(2)
                actor:send(tostring(self.name) .. " says, 'You have already brought me " .. tostring(object.shortdesc) .. "!'")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            end
            if count then
                wait(2)
                self:destroy_item("questobject")
                -- switch on count
                if count == 1 then
                    actor:send(tostring(self.name) .. " says, 'Excellent.  That's one.  Two to go.'")
                elseif count == 2 then
                    actor:send(tostring(self.name) .. " says, 'Good, good.  That's two.  One more!'")
                elseif count == 3 then
                    actor.name:advance_quest("emmath_flameball")
                    self:command("smile")
                    actor:send(tostring(self.name) .. " says, 'I'm glad you were able to tame the three flames.'")
                    wait(2)
                    self:command("scratch")
                    actor:send(tostring(self.name) .. " says, 'There is one more, though, a renegade flame.'")
                    wait(1)
                    self:command("sigh")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Some time ago, I battled my counterpart, the illustrious Suralla Iceeye.'")
                    self:emote("looks thoughtful, reminiscing in his mind.")
                    wait(2)
                    actor:send(tostring(self.name) .. " says, 'Nothing terrible came of it, but she succeeded in...'")
                    wait(1)
                    actor:send(tostring(self.name) .. " says, '... changing one of my flames.'")
                    self:emote("looks around himself.")
                    wait(3)
                    actor:send(tostring(self.name) .. " says, 'She was able to meld flame and ice, and form one neither cold nor warm.'")
                    wait(2)
                    self:command("lick")
                    actor:send(tostring(self.name) .. " says, 'I'm sure you understand when I say I cannot allow this flame to exist.'")
                    wait(3)
                    self:command("ponder")
                    actor:send(tostring(self.name) .. " says, 'Return it to me so that I might destroy it.'")
                    wait(7)
                    actor:send(tostring(self.name) .. " says, 'Well, don't wait around all day.'")
                end
            end
        elseif object.id == 23822 then
            self:destroy_item("blue-flame")
            self:command("eye")
            actor:send(tostring(self.name) .. " says, 'I didn't ask you to bring me this yet.")
            self.room:send(tostring(self.name) .. " extinguishes " .. tostring(objects.template(238, 22).name) .. ".")
        end
    elseif actor:get_quest_stage("emmath_flameball") == 3 then
        if object.id == 23822 then
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
            actor:send(tostring(self.name) .. " says, 'Well now I suppose I owe you something, don't I?  You seem ready for the power.'")
            actor.name:erase_quest("emmath_flameball")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'But remember!  With great power, comes great responsibility.'")
            self.room:spawn_object(52, 10)
            self:command("give ball " .. tostring(actor.name))
        end
    end
end
return _return_value