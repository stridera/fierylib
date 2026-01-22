-- Trigger: wizard_eye_apothecary_receive
-- Zone: 550, ID: 39
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55039

-- Converted from DG Script #55039: wizard_eye_apothecary_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("wizard_eye") == 7 then
    -- switch on object.id
    if object.id == 23754 then
        local item = 1
    elseif object.id == 3298 then
        local item = 2
    elseif object.id == 23847 then
        local item = 3
    elseif object.id == 18001 then
        local item = 4
    end
    if actor.quest_variable[wizard_eye:itemitem] then
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already brought me " .. tostring(object.shortdesc) .. ".'")
    else
        actor.name:set_quest_var("wizard_eye", "item%item%", 1)
        world.destroy(object.name)
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".'")
        wait(4)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor.name:advance_quest("wizard_eye")
            local item = 1
            while item <= 4 do
                actor.name:set_quest_var("wizard_eye", "item%item%", 0)
                local item = item + 1
            end
            actor:send(tostring(self.name) .. " says, 'That looks like everything.  Let me grind this all up!'")
            wait(2)
            self:emote("pulls out a mortar and pestle from behind the counter.")
            wait(1)
            self:emote("grinds the roses and cinnamon to a fine powder and shapes it into a small brick.")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'This incense should be perfect for you!'")
            self.room:spawn_object(550, 32)
            self:command("give incense " .. tostring(actor.name))
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Be careful!'")
            self:command("grin " .. tostring(actor.name))
        else
            actor:send(tostring(self.name) .. " says, 'Do you have the rest of the ingredients?'")
        end
    end
end
return _return_value