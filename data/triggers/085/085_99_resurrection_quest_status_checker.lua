-- Trigger: resurrection_quest_status_checker
-- Zone: 85, ID: 99
-- Type: MOB, Flags: SPEECH
--
-- Player asks Norisent for status / progress on the resurrection quest.
-- Tells them the current stage's hit list and item to return, marks
-- which targets they've already eliminated (via per-mob quest vars),
-- and reminds them of the banishment phrase.
--
-- TODO(parity): hunt-tracking quest vars are read as
-- "resurrection_quest:mob1"/"mob2"/"mob3" but other triggers (085_58)
-- record kills under "resurrection_quest:<zone>_<id>". Reconcile the
-- key naming and replace the legacy 5-digit mob ids with composite
-- (zone, id) lookups once the new ids are pinned down.
--
-- Original DG Script: #8599

-- Converted from DG Script #8599: resurrection_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("resurrection_quest") then
    self:say("You have already learned the secrets of the Resurrection.")
    return true
end

local stage = actor:get_quest_stage("resurrection_quest")
local hunt, item
local mob1, mob2, mob3
local mob1_name, mob2_name, mob3_name

if stage == 3 then
    self:say("Do something to interfere with Ziijhan.")
    wait(1)
    self:say("I hear he has a bishop locked up in the dungeon.")
    return true
elseif stage == 4 then
    mob1_name = mobiles.template(40, 4).name
    mob2_name = mobiles.template(40, 3).name
    mob3_name = mobiles.template(40, 16).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 4004
    mob2 = 4003
    mob3 = 4016
    item = objects.template(40, 8).name
elseif stage == 5 then
    item = objects.template(40, 8).name
elseif stage == 6 then
    mob2_name = mobiles.template(533, 8).name
    mob1_name = "the Xeg-Yi"  -- displayed as a count
    hunt = "2 Xeg-Yi and " .. mob2_name
    mob2 = 53411
    mob1 = 53308
    item = objects.template(533, 7).name
elseif stage == 7 then
    item = objects.template(533, 7).name
elseif stage == 8 then
    mob1_name = mobiles.template(510, 5).name
    mob2_name = mobiles.template(530, 1).name
    mob3_name = mobiles.template(510, 14).name
    hunt = mob1_name .. ", " .. mob2_name .. ", and " .. mob3_name
    mob1 = 51005
    mob2 = 53001
    mob3 = 51014
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "Diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 9 then
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        item = "a large book on healing from Nordus"
    elseif string.find(actor.class, "Diabolist") then
        item = objects.template(510, 28).name
    end
elseif stage == 10 then
    mob1_name = mobiles.template(520, 3).name
    mob2_name = mobiles.template(520, 15).name
    hunt = mob1_name .. " and " .. mob2_name
    mob1 = 52003
    mob2 = 52015
    item = objects.template(520, 1).name
elseif stage == 11 then
    item = objects.template(520, 1).name
else
    self:say("Did you want to do a quest of some kind?  Because you're not at the moment.  Get lost.")
    return true
end

if stage == 4 or stage == 6 or stage == 8 or stage == 10 then
    local target1 = actor:get_quest_var("resurrection_quest:mob1")
    local target2 = actor:get_quest_var("resurrection_quest:mob2")
    local target3
    if stage == 6 or stage == 10 then
        target3 = 1
    else
        target3 = actor:get_quest_var("resurrection_quest:mob3")
    end
    self:say("You must eliminate:")
    self.room:send(tostring(hunt))

    local done = false
    if stage == 4 or stage == 8 then
        if target1 and target2 and target3 then done = true end
    elseif stage == 6 then
        if target1 and (target2 == 2) then done = true end
    else
        if target1 and target2 then done = true end
    end
    if done then
        self:say("You have dispatched them.  Give me the death talisman!")
        return true
    end

    if target1 or target2 or target3 then
        self.room:send("You have destroyed:")
        if target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            if target2 == 2 and mob2_name then
                self.room:send("- " .. tostring(target2) .. " " .. mob2_name)
            end
        else
            if target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if (stage == 4 or stage == 8) and target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
    end
    if (stage ~= 6 and (not target1 or not target2 or not target3)) or (stage == 6 and (not target1 or (target2 or 0) < 2)) then
        self.room:send("You still need to dispatch:")
        if not target1 and mob1_name then
            self.room:send("- " .. mob1_name)
        end
        if stage == 6 then
            local t2 = target2 or 0
            if t2 < 2 and mob2_name then
                local xeg = 2 - t2
                self.room:send("- " .. tostring(xeg) .. " " .. mob2_name)
            end
        else
            if not target2 and mob2_name then
                self.room:send("- " .. mob2_name)
            end
        end
        if not target3 and mob3_name then
            self.room:send("- " .. mob3_name)
        end
        self.room:send("Return " .. tostring(item) .. " as proof.")
    end
    self.room:send("Don't forget the banishment phrase: <b:blue>Dhewsost Konre</>")
elseif stage == 5 or stage == 7 or stage == 9 or stage == 11 then
    self:say("Bring me back " .. tostring(item) .. ".")
end
if stage >= 4 then
    self.room:send(tostring(self.name) .. " says, 'If you need a new talisman, say &9<blue>\"I need a new talisman\"</>.'")
end