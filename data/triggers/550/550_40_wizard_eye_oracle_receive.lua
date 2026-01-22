-- Trigger: wizard_eye_oracle_receive
-- Zone: 550, ID: 40
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #55040

-- Converted from DG Script #55040: wizard_eye_oracle_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("wizard_eye") == 10 then
    -- switch on object.id
    if object.id == 3218 then
        local item = 1
    elseif object.id == 53424 then
        local item = 2
    elseif object.id == 43021 then
        local item = 3
    elseif object.id == 4003 then
        local item = 4
    end
    if actor:get_quest_var("wizard_eye:item" .. item) then
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already brought me " .. tostring(object.shortdesc) .. ".'")
    else
        actor.name:set_quest_var("wizard_eye", "item%item%", 1)
        wait(2)
        world.destroy(object.name)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor.name:advance_quest("wizard_eye")
            local item = 1
            while item <= 4 do
                actor.name:set_quest_var("wizard_eye", "item%item%", 0)
                local item = item + 1
            end
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'This seems to be all of them.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'O Rhalean, show me the balance of Justice!'")
            self:emote("utters a few words of power!")
            wait(2)
            actor:send("The four orbs begin to <b:white>glow</>!")
            actor:send("They become fully transparent and colorless.")
            wait(3)
            self:emote("scrutinizes the four now identical mystic orbs.")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'Yes I see...'")
            self:emote("picks up one of the four clear crystal balls.")
            self.room:spawn_object(550, 33)
            self:command("give crystal-ball " .. tostring(actor.name))
            wait(2)
            actor:send(tostring(self.name) .. " says, 'This will be your window to the universe.'")
            wait(2)
            self:command("bow " .. tostring(actor.name))
            actor:send(tostring(self.name) .. " says, 'May Justice follow you always.'")
        else
            self:command("nod")
            actor:send(tostring(self.name) .. " says, 'And the rest?'")
        end
    end
end
return _return_value