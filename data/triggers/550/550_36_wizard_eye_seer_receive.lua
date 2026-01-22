-- Trigger: wizard_eye_seer_receive
-- Zone: 550, ID: 36
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #55036

-- Converted from DG Script #55036: wizard_eye_seer_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("wizard_eye") == 4 then
    -- switch on object.id
    if object.id == 2329 then
        local item = 1
    elseif object.id == 23753 then
        local item = 2
    elseif object.id == 48005 then
        local item = 3
    end
    if actor.quest_variable[wizard_eye:itemitem] then
        _return_value = false
        actor:send(tostring(self.name) .. " says, 'You already brought me this!'")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    else
        actor.name:set_quest_var("wizard_eye", "item%item%", 1)
        wait(2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Yep, this'll do.'")
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") then
            actor.name:advance_quest("wizard_eye")
            local item = 1
            while item <= 4 do
                actor.name:set_quest_var("wizard_eye", "item%item%", 0)
                local item = item + 1
            end
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Let me just stitch up a little bag for you.'")
            wait(1)
            self:emote("cuts a large square from the indigo silk dress.")
            self:emote("quickly sews the square into a little pouch.")
            self:emote("fills the pouch with the thyme and bay leaves and stitches it shut.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Here ya go!'")
            self.room:spawn_object(550, 30)
            self:command("give sachet " .. tostring(actor.name))
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Sweet dreams!'")
            self:command("cackle")
        else
            wait(2)
            if not actor:get_quest_var("wizard_eye:item1") then
                actor:send(tostring(self.name) .. " says, 'What about the bay?'")
            end
            if not actor:get_quest_var("wizard_eye:item3") then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Did you find a dress I can upcycle?'")
            end
            if not actor:get_quest_var("wizard_eye:item2") then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Oh and do you have the thyme?'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Of course you don't, you don't have a wristwatch!'")
                self:command("laugh")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'No but really, if you have it, give it to me.'")
            end
        end
    end
end
return _return_value