-- Trigger: dragons_health_myorrhed_receive
-- Zone: 586, ID: 2
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--   Large script: 12769 chars
--
-- Original DG Script: #58602

-- Converted from DG Script #58602: dragons_health_myorrhed_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("dragons_health")
if stage == 1 then
    if object.id == 12509 then
        wait(2)
        self:emote("examines " .. tostring(object.shortdesc) .. ".")
        world.destroy(object)
        wait(1)
        self:command("nod")
        actor:send(tostring(self.name) .. " says, 'I had little doubt you would succeed.'")
        actor.name:advance_quest("dragons_health")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Your next target is considerably more powerful so be prepared.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'The dragon Tri-Aszp has a cult dedicated to her in the")
        actor:send("</>northern reaches.  She uses them to commit heinous acts and keep the")
        actor:send("</>region in her clutches.'")
        wait(5)
        self:emote("places her hands on the egg.")
        actor:send(tostring(self.name) .. " says, 'It would be a boon to both this dragon's future and to all")
        actor:send("</>dragonkind if you could eliminate her.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Dragon scales have incredible monetary and ancestral value.")
        actor:send("</>A scale from Tri-Aszp will remind our hatchling of the legacy it bears.")
        actor:send("</>Bring back one of her scales as a trophy.'")
    else
        _return_value = false
        actor:send(tostring(self.name) .. " says, 'Hmmm, this doesn't seem to have the proper draconic energies.'")
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    end
elseif stage == 2 then
    if object.id == 53325 then
        actor.name:advance_quest("dragons_health")
        wait(2)
        self:emote("runs her eyes over " .. tostring(object.shortdesc) .. ".")
        world.destroy(object)
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Excellent work.  With the Cult of the Ice Dragon in shambles,")
        actor:send("</>the world is that much safer.'")
        wait(3)
        actor:send(tostring(self.name) .. " says, 'Tri-Aszp's children may grow to be a threat in the future")
        actor:send("</>which is why this next generation is so important.'")
        wait(4)
        actor:send(tostring(self.name) .. " says, 'That next generation of chromatic dragons is actually what")
        actor:send("</>we should address next.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Sagece of Raymif, the half-demon dragon that rules Templace,")
        actor:send("</>had two spawn sometime after she crawled into our world.  They are entombed in")
        actor:send("</>a crypt far to the north as guardians of a soul-shredding lich.'")
        wait(5)
        actor:send(tostring(self.name) .. " says, 'In their position is a wondrous stone unlike anything else in")
        actor:send("</>existence.  It flickers with an inner green light.'")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'Destroy her spawn, the black dragons Thelriki and Jerajai, and")
        actor:send("</>return with the stone.'")
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        actor:send(tostring(self.name) .. " says, '" .. tostring(object.shortdesc) .. " is not one of Tri-Aszp's scales.'")
    end
elseif stage == 3 then
    if object.id == 48024 then
        if actor:get_quest_var("dragons_health:thelriki") and actor:get_quest_var("dragons_health:jerajai") then
            actor.name:advance_quest("dragons_health")
            wait(2)
            self:emote("looks suspiciously at " .. tostring(object.shortdesc) .. ".")
            world.destroy(object)
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Thank you for ending them.  They shall blight the world no more.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'Now for the hardest task of all.  When Templace fell and demons")
            actor:send("</>from Garl'lixxil were loosed on Ethilien, the balance of the Dragonwars")
            actor:send("</>was forever changed.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'The time has come to right that balance.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Lay siege to Templace and slay the ancient black dragon Sagece")
            actor:send("</>of Raymif.  Bring back her skin and a shield she keeps, plus the two decoys")
            actor:send("</>she keeps in her cursed hoard.'")
            wait(2)
            actor:send(tostring(self.name) .. " says, 'And know, you must be there when the demon dragon falls.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'May Bahamut watch over you and grant you fortune!'")
        elseif actor:get_quest_var("dragons_health:thelriki") and not actor:get_quest_var("dragons_health:jerajai") then
            _return_value = false
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'Jerajai still lives!  You must destroy him first!'")
        elseif not actor:get_quest_var("dragons_health:thelriki") and actor:get_quest_var("dragons_health:jerajai") then
            _return_value = false
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'Thelriki still lives!  You must destroy her first!'")
        else
            _return_value = false
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'The hell-dragon spawn still live!  You must destroy them first!'")
        end
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'This is not part of their hoard.'")
    end
elseif stage == 4 then
    local sagece = actor:get_quest_var("dragons_health:sagece")
    if object.id == 52016 or object.id == 52017 or object.id == 52022 or object.id == 52023 then
        if not sagece then
            _return_value = false
            actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
            actor:send(tostring(self.name) .. " says, 'You must slay Sagece first!'")
        else
            if actor.quest_variable["dragons_health:" .. object.vnum] then
                _return_value = false
                actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
                actor:send(tostring(self.name) .. " says, 'You have already given this to me.'")
                return _return_value
            else
                actor.name:set_quest_var("dragons_health", "%object.vnum%", 1)
                wait(2)
                local emote = random(1, 4)
                -- switch on emote
                if emote == 1 then
                    self:emote("looks at " .. tostring(object.shortdesc) .. " with disdain.")
                elseif emote == 2 then
                    self:emote("regards " .. tostring(object.shortdesc) .. " with caution.")
                elseif emote == 3 then
                    self:emote("grimaces at " .. tostring(object.shortdesc) .. ".")
                else
                    self:emote("sneers at " .. tostring(object.shortdesc) .. ".")
                end
                world.destroy(object)
            end
        end
        local item1 = actor:get_quest_var("dragons_health:52016")
        local item2 = actor:get_quest_var("dragons_health:52017")
        local item3 = actor:get_quest_var("dragons_health:52022")
        local item4 = actor:get_quest_var("dragons_health:52023")
        wait(1)
        if item1 and item2 and item3 and item4 then
            actor.name:advance_quest("dragons_health")
            actor:send(tostring(self.name) .. " says, 'I can't believe she's finally gone.'")
            wait(2)
            self:emote("places the remnants of the other dragons' hoards around the egg.'")
            wait(2)
            actor:send("The egg shifts and rocks slightly with signs of life!")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'The last thing the egg needs is money.  Lots of it.'")
            -- (empty send to actor)
            actor:send(tostring(self.name) .. " says, 'Bring anything of value you can find. You can even offer coin.")
            actor:send("</>About 10,000 platinum worth of treasure should be satisfactory.  That's about")
            actor:send("</>10,000,000 copper, in case it needed to be said.'")
            wait(4)
            actor:send(tostring(self.name) .. " says, 'Some very powerful objects are so unique they are priceless.")
            actor:send("</>Bring them to me and I shall see if they are worth including as well.'")
            wait(3)
            actor:send(tostring(self.name) .. " says, 'And remember, just because someone sells something for a")
            actor:send("</>certain price, doesn't mean it's actually worth that much!'")
        else
            actor:send(tostring(self.name) .. " says, 'Good.  Do you have the remaining artifacts?'")
        end
    else
        _return_value = false
        actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        actor:send(tostring(self.name) .. " says, 'This is not significant enough to Sagece.'")
        return _return_value
    end
elseif stage == 5 then
    if object.cost == 0 and object.level < 60 then
        _return_value = false
        wait(2)
        self:emote("examines " .. tostring(object.shortdesc) .. " closely.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Unfortunately there isn't enough inherent value to <b:yellow>" .. tostring(object.shortdesc) .. " to be part of the hatchling's hoard.'")
        return _return_value
    else
        wait(2)
        self:emote("examines " .. tostring(object.shortdesc) .. " closely.")
        if (object.level >= 60) and (object.cost == 0) then
            local price = (object.level * 1000)
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  Although it has no inherent price, the mystic value of it is: <b:yellow>" .. tostring(price) .. "</> copper.'")
        elseif object.level >= 60 and object.cost < (object.level * 1000) then
            local price = (object.level * 1000)
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  Even though it has some material value, the mystic value of it is: <b:yellow>" .. tostring(price) .. "</> copper.'")
        elseif (object.level < 60 and object.cost > 0) or (object.level >= 60 and object.cost >= (object.level * 1000)) then
            local price = object.cost
            actor:send(tostring(self.name) .. " says, 'Ah, " .. tostring(object.shortdesc) .. ".  It has a value of: <b:yellow>" .. tostring(object.cost) .. "</> copper.'")
        end
        actor:send("</>")
        actor:send(tostring(self.name) .. " says, 'It shall be included in the offerings.'")
        self:emote("places " .. tostring(object.shortdesc) .. " next to the egg.")
        world.destroy(object)
        wait(2)
    end
    local hoard = actor:get_quest_var("dragons_health:hoard")
    local wealth = (hoard + price)
    actor.name:set_quest_var("dragons_health", "hoard", wealth)
    local value = actor:get_quest_var("dragons_health:hoard")
    if value >= 10000000 then
        actor.name:advance_quest("dragons_health")
        run_room_trigger(58604)
    else
        local total = (10000000 - value)
        local plat = (total / 1000)
        local gold = (total / 100) - (plat * 10)
        local silv = (total / 10) - (plat * 100) - (gold * 10)
        local copp = total  - (plat * 1000) - (gold * 100) - (silv * 10)
        -- now the price can be reported
        actor:send(tostring(self.name) .. " says, 'We need " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper more in treasure and coins.'")
    end
else
    _return_value = false
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm not looking for anything right now.'")
end
return _return_value