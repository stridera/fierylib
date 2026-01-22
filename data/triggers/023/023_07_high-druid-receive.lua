-- Trigger: high-druid-receive
-- Zone: 23, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--   Large script: 5042 chars
--
-- Original DG Script: #2307

-- Converted from DG Script #2307: high-druid-receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if string.find(actor.class, "Druid") then
        if object.id == 2331 then
            self:command("smile " .. tostring(actor.name))
            local blessings = 1
            globals.blessings = globals.blessings or true
            wait(2)
            self:destroy_item("blessing")
            self:say("I am grateful the monoliths are still serving their purpose.")
            self:say("Perhaps the one to the west still retains its blessing as well?")
            wait(2)
            self:say("Please bring that to me as well!")
            self:command("sigh")
            self:say("I would go myself, but I cannot leave the Vale.")
        elseif object.id == 2333 then
            if blessings == 1 then
                local blessings = 2
                globals.blessings = globals.blessings or true
                self.room:send(tostring(self.name) .. " closes his eyes and smiles.")
                wait(2)
                self:destroy_item("blessing")
                self:say("This is heartening!  I do hope the sprites were not too much trouble.")
                self:say("They tricked us long ago and kept the powers of nature for themselves.")
                wait(2)
                self:say("Another power point is to the north.  Bring me that blessing and we shall be one step closer to restoring the stones.")
                self:command("bow " .. tostring(actor.name))
            else
                self:say("Why thank you.  But how did you know I wanted this?")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif object.id == 2332 then
            if blessings == 2 then
                self.room:send("The ancient druid's eyes light up as he receives the blessing.")
                local blessings = 3
                globals.blessings = globals.blessings or true
                wait(2)
                self:destroy_item("blessing")
                self:say("At last, the restoration is almost complete!")
                self:say("The only one remaining is the blessing of the east.")
                wait(2)
                self:say("But be careful - it was placed far from the others.")
                self:say("Since many of the ancient roads are no more, you may have some difficulty finding it.")
            else
                self:say("Why thank you.  But this does me little good right now.")
                wait(2)
                self:destroy_item("blessing")
            end
        elseif object.id == 2330 then
            if blessings == 3 then
                self.room:send(tostring(self.name) .. " heaves a great sigh of relief as he places the blessings on the stone slab.")
                local blessings = 0
                globals.blessings = globals.blessings or true
                wait(1)
                self.room:send("The &9<blue>stone slab</> begins to <b:white>glow brightly!</>")
                wait(2)
                self.room:send("<b:green>Tendrils of power shoot out from the stone slab, lighting the vale!</>")
                self.room:send(tostring(self.name) .. " smiles hapily as he watches Nature's power at work.")
                wait(4)
                self.room:send("The <b:green>glow</> begins to fade.")
                wait(1)
                actor:send(tostring(self.name) .. " turns to you and bows.")
                self.room:send_except(actor, tostring(self.name) .. " bows to " .. tostring(actor.name) .. ".")
                self:say("Truly, you have performed a great service to the Druids of Anlun Vale.")
                self:say("Please, it is not much, but accept this s a token of my gratitude.")
                wait(1)
                self.room:send(tostring(self.name) .. " pulls something out of his robes.")
                self.room:spawn_object(23, 35)
                self:command("give gaia-cloak " .. tostring(actor.name))
                wait(1)
                self:say("Truly, you have the makings of a great druid within you.")
                self:say("Never lose sight of that, and you shall prosper.")
            else
                self:say("Very interesting - but I cannot use that just now.")
                wait(2)
                self:destroy_item("blessing")
            else
                self:command("eye " .. tostring(actor.name))
                self:say("And why should I need this?")
                _return_value = false
            end
        else
            _return_value = false
            self:say("Thank you, but I do not need this.")
            actor:send(tostring(self.name) .. " returns the item to you.")
        end
    else
        self:say("I am sorry, but I am only looking for help from a fellow druid.")
        actor:send(tostring(self.name) .. " gives " .. tostring(object.shortdesc) .. " back to you.")
    end
end
return _return_value