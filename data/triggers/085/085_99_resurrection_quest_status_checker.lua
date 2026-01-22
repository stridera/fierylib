-- Trigger: resurrection_quest_status_checker
-- Zone: 85, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 26 if statements
--   Large script: 5671 chars
--
-- Original DG Script: #8599

-- Converted from DG Script #8599: resurrection_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("resurrection_quest") then
    self:say("You have already learned the secrets of the Resurrection.")
    return _return_value
else
    local stage = actor:get_quest_stage("resurrection_quest")
    -- switch on stage
    if stage == 3 then
        self:say("Do something to interfere with Ziijhan.")
        wait(1)
        self:say("I hear he has a bishop locked up in the dungeon.")
        return _return_value
    elseif stage == 4 then
        local hunt = mobiles.template(40, 4).name, mobiles.template(40, 3).name, and mobiles.template(40, 16).name
        local mob1 = 4004
        local mob2 = 4003
        local mob3 = 4016
        local item = objects.template(40, 8).name
    elseif stage == 5 then
        local item = objects.template(40, 8).name
    elseif stage == 6 then
        local hunt = 2 Xeg-Yi and mobiles.template(533, 8).name
        local mob2 = 53411
        local mob1 = 53308
        local item = objects.template(533, 7).name
    elseif stage == 7 then
        local item = objects.template(533, 7).name
    elseif stage == 8 then
        local hunt = mobiles.template(510, 5).name, mobiles.template(530, 1).name, and mobiles.template(510, 14).name
        local mob1 = 51005
        local mob2 = 53001
        local mob3 = 51014
        if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
            local item = "a large book on healing from Nordus"
        elseif string.find(actor.class, "Diabolist") then
            local item = objects.template(510, 28).name
        end
        if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        elseif stage == 9 then
            local item = "a large book on healing from Nordus"
        elseif string.find(actor.class, "Diabolist") then
            local item = objects.template(510, 28).name
        end
    elseif stage == 10 then
        local hunt = mobiles.template(520, 3).name and mobiles.template(520, 15).name
        local mob1 = 52003
        local mob2 = 52015
        local item = objects.template(520, 1).name
    elseif stage == 11 then
        local item = objects.template(520, 1).name
    else
        self:say("Did you want to do a quest of some kind?  Because you're not at the moment.  Get lost.")
    end
end
if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
    local target1 = actor.quest_variable[resurrection_quest:mob1]
    local target2 = actor.quest_variable[resurrection_quest:mob2]
    if stage == 6 or stage == 10 then
        local target3 = 1
    else
        local target3 = actor.quest_variable[resurrection_quest:mob3]
    end
    self:say("You must eliminate:")
    self.room:send(tostring(hunt))
    if stage == 4 or stage == 8 then
        if target1 and target2 and target3 then
            local done = 1
        end
    elseif stage == 6 then
        if target1 and (target2 == 2) then
            local done = 1
        end
    else
        if target1 and target2 then
            local done = 1
        end
    end
    if done then
        -- (empty room echo)
        self:say("You have dispatched them.  Give me the death talisman!")
        return _return_value
    end
    if target1 or target2 or target3 then
        -- (empty room echo)
        self.room:send("You have destroyed:")
        if target1 then
            self.room:send("- " .. "%get.mob_shortdesc[%mob1%]%")
        end
        if stage == 6 then
            if target2 == 2 then
                self.room:send("- " .. tostring(target2) .. " " .. "%get.mob_shortdesc[%mob2%]%")
            end
        else
            if target2 then
                self.room:send("- " .. "%get.mob_shortdesc[%mob2%]%")
            end
        end
        if stage == 4 or stage == 8 then
            if target3 then
                self.room:send("- " .. "%get.mob_shortdesc[%mob3%]%")
            end
        end
    end
    if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or target2 < 2)) then
        -- (empty room echo)
        self.room:send("You still need to dispatch:")
        if not target1 then
            self.room:send("- " .. "%get.mob_shortdesc[%mob1%]%")
        end
        if stage == 6 then
            if target2 < 2 then
                local xeg = (2 - target2)
                self.room:send("- " .. tostring(xeg) .. " " .. "%get.mob_shortdesc[%mob2%]%")
            end
        else
            if not target2 then
                self.room:send("- " .. "%get.mob_shortdesc[%mob2%]%")
            end
        end
        if not target3 then
            self.room:send("- " .. "%get.mob_shortdesc[%mob3%]%")
        end
        -- (empty room echo)
        self.room:send("Return " .. tostring(item) .. " as proof.")
    end
    -- (empty room echo)
    self.room:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
    self:say("Bring me back " .. tostring(item) .. ".")
end
if stage >= 4 then
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you need a new talisman, say &9<blue>\"I need a new talisman\"</>.'")
end