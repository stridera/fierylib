-- Trigger: resurrection_quest_status_checker
-- Zone: 85, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN (reviewed)
--
-- Original DG Script: #8599

-- Converted from DG Script #8599: resurrection_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("resurrection_quest") then
    self:say("You have already learned the secrets of the Resurrection.")
    return
end

local stage = actor:get_quest_stage("resurrection_quest")
local hunt = nil
local mob1 = nil
local mob2 = nil
local mob3 = nil
local item = nil

-- switch on stage
if stage == 3 then
    self:say("Do something to interfere with Ziijhan.")
    wait(1)
    self:say("I hear he has a bishop locked up in the dungeon.")
    return
elseif stage == 4 then
    hunt = "Lajon's Soul, Lajon's Corruption, and the Tres Keeper"
    mob1 = "4004"
    mob2 = "4003"
    mob3 = "4016"
    item = mobiles.template(40, 8) and mobiles.template(40, 8).name or "the ring of souls"
elseif stage == 5 then
    item = objects.template(40, 8) and objects.template(40, 8).name or "the ring of souls"
    self:say("Bring me back " .. tostring(item) .. ".")
    return
elseif stage == 6 then
    hunt = "2 Xeg-Yi and Aelfric"
    mob2 = "53411"
    mob1 = "53308"
    item = objects.template(533, 7) and objects.template(533, 7).name or "the white robes"
elseif stage == 7 then
    item = objects.template(533, 7) and objects.template(533, 7).name or "the dragon robes"
    self:say("Bring me back " .. tostring(item) .. ".")
    return
elseif stage == 8 then
    hunt = "the spectral man, the bloody remains, and Luchiaans"
    mob1 = "51005"
    mob2 = "53001"
    mob3 = "51014"
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "Diabolist") then
        item = objects.template(510, 28) and objects.template(510, 28).name or "an object of power"
    end
elseif stage == 9 then
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "Diabolist") then
        item = objects.template(510, 28) and objects.template(510, 28).name or "an object of power"
    end
    self:say("Bring me back " .. tostring(item) .. ".")
    return
elseif stage == 10 then
    hunt = "the weaponsmith's spirit and the crazed mage"
    mob1 = "52003"
    mob2 = "52015"
    item = objects.template(520, 1) and objects.template(520, 1).name or "the mage's artifact"
elseif stage == 11 then
    item = objects.template(520, 1) and objects.template(520, 1).name or "the mage's artifact"
    self:say("Bring me back " .. tostring(item) .. ".")
    return
else
    self:say("Did you want to do a quest of some kind?  Because you're not at the moment.  Get lost.")
    return
end

-- Handle stages 4, 6, 8, 10 that have mobs to hunt
if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
    local target1 = actor:get_quest_var("resurrection_quest:" .. mob1)
    local target2 = actor:get_quest_var("resurrection_quest:" .. mob2)
    local target3 = nil
    if stage == 6 or stage == 10 then
        target3 = 1  -- No third target needed
    elseif mob3 then
        target3 = actor:get_quest_var("resurrection_quest:" .. mob3)
    end

    self:say("You must eliminate:")
    self.room:send(tostring(hunt))

    local done = false
    if stage == 4 or stage == 8 then
        if target1 and target2 and target3 then
            done = true
        end
    elseif stage == 6 then
        if target1 and target2 and target2 >= 2 then
            done = true
        end
    else
        if target1 and target2 then
            done = true
        end
    end

    if done then
        self:say("You have dispatched them.  Give me the death talisman!")
        return
    end

    if target1 or target2 or (target3 and target3 ~= 1) then
        self.room:send("You have destroyed:")
        if target1 then
            self.room:send("- Target 1")
        end
        if stage == 6 then
            if target2 and target2 >= 2 then
                self.room:send("- " .. tostring(target2) .. " Xeg-Yi")
            end
        else
            if target2 then
                self.room:send("- Target 2")
            end
        end
        if (stage == 4 or stage == 8) and target3 then
            self.room:send("- Target 3")
        end
    end

    if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or not target2 or target2 < 2)) then
        self.room:send("You still need to dispatch:")
        if not target1 then
            self.room:send("- Target 1")
        end
        if stage == 6 then
            if not target2 or target2 < 2 then
                local xeg = 2 - (target2 or 0)
                self.room:send("- " .. tostring(xeg) .. " Xeg-Yi")
            end
        else
            if not target2 then
                self.room:send("- Target 2")
            end
        end
        if (stage == 4 or stage == 8) and not target3 then
            self.room:send("- Target 3")
        end
        self.room:send("Return " .. tostring(item) .. " as proof.")
    end

    self.room:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
end

if stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'If you need a new talisman, say <blue>\"I need a new talisman\"</>.'")
end
