-- Trigger: wizard_eye_apothecary_receive
-- Zone: 550, ID: 39
-- Type: MOB, Flags: RECEIVE
--
-- Anduin apothecary receives the four scrying-incense ingredients
-- (cinnamon, red rose, black rose, sapphire rose); on the fourth
-- ingredient she grinds them into the incense (550, 32) and gives it
-- to the player.
--
-- Original DG Script: #55039

-- Converted from DG Script #55039: wizard_eye_apothecary_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 7 then
    local item = nil
    if object.zone_id == 237 and object.local_id == 54 then
        item = 1
    elseif object.zone_id == 30 and object.local_id == 298 then
        item = 2
    elseif object.zone_id == 238 and object.local_id == 47 then
        item = 3
    elseif object.zone_id == 180 and object.local_id == 1 then
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
        world.destroy(object)
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".'")
        wait(4)
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") and actor:get_quest_var("wizard_eye:item4") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
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
return true