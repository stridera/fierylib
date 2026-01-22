-- Trigger: flood_spirits_receive
-- Zone: 390, ID: 7
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #39007

-- Converted from DG Script #39007: flood_spirits_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("flood")
-- switch on self.id
if stage == 2 then
    if object.id == 39000 then
        if self.id == 39012 then
            self:destroy_item("heart-ocean")
            wait(1)
            self.room:send(tostring(self.name) .. " screams, 'LET THE SIEGE BEGIN!!'")
            -- (empty room echo)
            self.room:send("The ocean erupts in a violent frenzy.")
            wait(3)
            self.room:send("Massive waves begin to crest and smash against the settlement gate.")
            self.room:send(tostring(self.name) .. " screams with reckless abandon like the most terrifying of barbarian berserkers.")
            wait(6)
            self.room:send("Spirits rise up through the churning ocean.")
            self.room:send("Giant black waves and enormous icebergs assault the rocky shores!")
            self.room:send(tostring(self.name) .. " wails, 'YOU SHALL DIE FOR STEALING FROM ME.'")
            wait(7)
            self.room:send("The nine Great Waters pull away from the settlement's borders as if granting a moment of reprieve.")
            wait(4)
            self.room:send("The ocean's level drops as the waters quickly rush away.")
            wait(4)
            self.room:send("On the horizon, a titanic wall of water rises up like a hellish behemoth.")
            wait(2)
            self.room:send("The gargantuan tsunami rushes toward the rocks and SMASHES through the settlement gate!")
            wait(6)
            self.room:send("Screaming voices are instantly snuffed out.")
            self.room:send("Dozens of bodies smash into the rocks and shatter like glass as the tsunami obliterates the settlement.")
            wait(8)
            self.room:send("As quickly as it began, the flood waters recede leaving nothing but chilling silence and carnage in its wake.")
            wait(6)
            self.room:send("The Lady of the Sea vanishes beneath the waves.")
            run_room_trigger(39013)
            wait(4)
            actor:send("A watery voice floats past your ear:")
            actor:send("'Never forget what you have witnessed here today.'")
            wait(1)
            actor:send("It whispers the eldritch formula for summoning such a cataclysm again.")
            actor.name:complete_quest("flood")
            skills.set_level(actor.name, "flood", 100)
            actor:send("<b:blue>You have learned Flood.</>")
            wait(2)
            actor:send("'Thank you for the role you played.'")
            world.destroy(self)
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self:say("This is not my heart!")
            wait(1)
            self.room:send(tostring(self.name) .. " bellows, 'GIVE IT BACK OR I WILL DESTROY YOU.'")
        end
    end
elseif self.id == 39014 then
    local color = "&6"
    if stage == 1 then
        if object.id == 58401 then
            self:destroy_item("feather")
            wait(1)
            self.room:send(tostring(self.name) .. " submerges the feather in the steaming water.")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I can entrust the safety of the springs to this</>")
            self.room:send("</>" .. tostring(color) .. "feather's magical energy for a short while.  I will join the ocean's crusade.'</>")
            actor.name:set_quest_var("flood", "water2", 1)
            wait(2)
            self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This will not keep my spring sufficiently warm.'</>")
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I need nothing from you.'</>")
    end
elseif self.id == 39016 then
    local color = "&2"
    if stage == 1 then
        if object.type == "food" then
            if actor:get_quest_var("flood:" .. object.vnum) then
                wait(2)
                self.room:send(tostring(self.name) .. " wails in anger as she thrashes about!")
                self.room:send(tostring(self.name) .. " throws " .. tostring(object.shortdesc) .. " into the sea!")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have already eaten that!  I refuse to eat it again!'</>")
            else
                actor.name:set_quest_var("flood", "%object.vnum%", 1)
                local full = actor:get_quest_var("flood:hunger")
                local hunger = (full + object.val0)
                actor.name:set_quest_var("flood", "hunger", hunger)
                self:destroy_item("food")
                self.room:send(tostring(self.name) .. " greedily devours " .. tostring(object.shortdesc) .. ".")
                if hunger >= 200 then
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.</>")
                    wait(1)
                    self:command("burp")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The dead within me are sated.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'For now.'")
                    wait(1)
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'We will join with the ocean in her revenge.'")
                    wait(1)
                    self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
                    actor.name:set_quest_var("flood", "water4", 1)
                else
                    wait(2)
                    self.room:send(tostring(self.name) .. " licks her massive chops.")
                    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me more!'</>")
                    return _return_value
                end
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This is not food!!'</>")
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I want nothing from you.'</>")
    end
elseif self.id == 39019 then
    local color = "&9&b"
    if stage == 1 then
        if object.type == "light" then
            if object.val1 == -1 then
                actor.name:set_quest_var("flood", "water7", 1)
                wait(2)
                self.room:send(tostring(self.name) .. " grins with a sick malevolence.")
                wait(2)
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I'll take great joy in this!'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " plunges the light into the depths of the Black Lake.")
                world.destroy(object)
                wait(3)
                self.room:send("The light twinkles for a few moments as it sinks into the darkness before fading forever.")
                wait(4)
                self:command("laugh")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Intoxicating.'</>")
                wait(2)
                self.room:send(tostring(self.name) .. " says," .. tostring(color) .. " 'I will join the Arabel Ocean with pleasure.'</>")
                self:command("bow")
                wait(2)
                self.room:send(tostring(color) .. tostring(self.name) .. " splashes back into the inky blackness of the lake.</>")
            else
                _return_value = false
                self.room:send(tostring(self.name) .. " scoffs.")
                self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This wouldn't glow forever even before I consume it.'</>")
            end
        else
            _return_value = false
            self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'This isn't even a light!'</>")
        end
    else
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'You have nothing to offer me.'</>")
    end
else
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I have no need for this.'</>")
end
if stage == 1 then
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor.name:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
end
world.destroy(self)
return _return_value