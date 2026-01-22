-- Trigger: Rhell Merchant receive 4-3
-- Zone: 625, ID: 33
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #62533

-- Converted from DG Script #62533: Rhell Merchant receive 4-3
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("ursa_quest") == 4 then
    if actor:get_quest_var("ursa_quest:choice") == 3 then
        -- for path 3, the merchant asks for an anvil
        -- note - the anvil is extremely heavy but must be picked up and given to the merchant to complete the quest; it cannot just be dragged to him.
        if object.type == "LIQCONTAINER" then
            if object.val2 == 10 then
                wait(2)
                world.destroy(object)
                actor.name:advance_quest("ursa_quest")
                wait(1)
                self:say("Excellent.  Now to crush this ring...")
                self:emote("drops the ring of stolen life.")
                self:emote("wields the Golden Druidstaff.")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("blink")
                wait(3)
                self.room:send("<b:green>" .. tostring(self.name) .. " </><green>SMACKS<b:green> the ring, which </><green>bounces<b:green> and lands lightly back on the dirt.</>")
                wait(3)
                self:command("grumble")
                self.room:send(tostring(self.name) .. " says, This isn't going to work.  Off the Great Road is a lumber mill.  Their smith has an anvil that will do perfectly.")
            else
                wait(2)
                self.room:send(tostring(self.name) .. " examines " .. tostring(object.shortdesc) .. ".")
                wait(1)
                self:say("Good, now put some milk in this, and bring it to me again.")
                self:command("give " .. tostring(object) .. " " .. tostring(actor) .. ".")
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            wait(1)
            self:say("I'm not sure how one gets milk out of this.")
        end
    end
end
return _return_value