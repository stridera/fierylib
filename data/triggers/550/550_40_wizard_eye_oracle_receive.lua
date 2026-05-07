-- Trigger: wizard_eye_oracle_receive
-- Zone: 550, ID: 40
-- Type: MOB, Flags: RECEIVE
--
-- Oracle of Justice receives the four candidate orbs (quartz ball,
-- orb of pure Chaos, Orb of Catastrophe, glass time-globe); on the
-- fourth he equalises them and hands the player a clear crystal ball
-- (550, 33).
--
-- Original DG Script: #55040

-- Converted from DG Script #55040: wizard_eye_oracle_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 10 then
    local item = nil
    if object.zone_id == 30 and object.local_id == 218 then
        item = 1
    elseif object.zone_id == 534 and object.local_id == 24 then
        item = 2
    elseif object.zone_id == 430 and object.local_id == 21 then
        item = 3
    elseif object.zone_id == 40 and object.local_id == 3 then
        item = 4
    end
    if not item then
        return true
    end
    local var_key = "item" .. tostring(item)
    if actor:get_quest_var("wizard_eye:" .. var_key) then
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'You already brought me " .. tostring(object.shortdesc) .. ".'")
    else
        actor:set_quest_var("wizard_eye", var_key, 1)
        wait(2)
        world.destroy(object)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
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
return true