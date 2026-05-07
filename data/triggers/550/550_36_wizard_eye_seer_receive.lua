-- Trigger: wizard_eye_seer_receive
-- Zone: 550, ID: 36
-- Type: MOB, Flags: RECEIVE
--
-- Seer of Griffin Isle receives the three sachet ingredients (bay,
-- thyme, and an indigo silk dress); when all three are in, she stitches
-- a herbal sachet (550, 30) and gives it to the player.
--
-- Original DG Script: #55036

-- Converted from DG Script #55036: wizard_eye_seer_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("wizard_eye") == 4 then
    local item = nil
    if object.zone_id == 23 and object.local_id == 29 then
        item = 1
    elseif object.zone_id == 237 and object.local_id == 53 then
        item = 2
    elseif object.zone_id == 480 and object.local_id == 5 then
        item = 3
    end
    if not item then
        return true
    end
    local var_key = "item" .. tostring(item)
    if actor:get_quest_var("wizard_eye:" .. var_key) then
        actor:send(tostring(self.name) .. " says, 'You already brought me this!'")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    else
        actor:set_quest_var("wizard_eye", var_key, 1)
        wait(2)
        world.destroy(object)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'Yep, this'll do.'")
        if actor:get_quest_var("wizard_eye:item1") and actor:get_quest_var("wizard_eye:item2") and actor:get_quest_var("wizard_eye:item3") then
            actor:advance_quest("wizard_eye")
            local i = 1
            while i <= 4 do
                actor:set_quest_var("wizard_eye", "item" .. tostring(i), 0)
                i = i + 1
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
                actor:send(tostring(self.name) .. " says, 'Oh do you have the thyme?'")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Of course you don't, you don't have a wristwatch!'")
                self:command("laugh")
                wait(1)
                actor:send(tostring(self.name) .. " says, 'No but really, if you have it, give it to me.'")
            end
        end
    end
end
return true