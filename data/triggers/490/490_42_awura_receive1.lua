-- Trigger: awura_receive1
-- Zone: 490, ID: 42
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49042

-- Converted from DG Script #49042: awura_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
if object.id == 49001 then
    wait(2)
    self:destroy_item("griffin-skin")
    if not (world.count_mobiles("49010")) then
        get_room(491, 90):at(function()
            self.room:spawn_mobile(490, 10)
        end)
    end
    if actor:get_quest_stage("griffin_quest") == 7 then
        get_room(491, 90):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 62)
        end)
        get_room(491, 90):at(function()
            self.room:find_actor("adramalech"):spawn_object(490, 19)
        end)
        actor:advance_quest("griffin_quest")
        actor:send("<b:white>You have advanced the quest!</>")
    end
    self.room:send("a look of disgust crosses Awura's features as she handles the skin.")
    self:emote("utters a short spell.")
    wait(8)
    self.room:send("The griffin skin turns to smoke and blows away in the breeze.")
    wait(4)
    actor.name:send("Awura studies you closely, to be sure of your intentions.")
    self.room:send_except(actor.name, "Awura studies " .. tostring(actor.name) .. " closely, to be sure of " .. tostring(actor.possessive) .. " intentions.")
    self.room:send(tostring(self.name) .. " says, '" .. tostring(actor.name) .. ", thank you so much for saving our home from Dagon's rule.'")
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'As a small token of gratitude, please accept this helmet.  It is not much, but I pray it will help you in the future.'")
    self.room:spawn_object(490, 61)
    self:command("give helmet " .. tostring(actor.name))
    wait(4)
    self:command("curtsey " .. tostring(actor.name))
    wait(4)
    self.room:send(tostring(self.name) .. " says, 'Now, seek out and destroy Dagon's demonic essence, Adramalech.  A portal to its home realm is locked beneath the well.  The cult leader must have had a key of some kind.'")
else
    _return_value = false
    actor:send("<b:white>" .. tostring(self.name) .. " tells you, 'No, thank you.'</>")
end
return _return_value