-- Trigger: waterform_waters_examine
-- Zone: 28, ID: 6
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #2806

-- Converted from DG Script #2806: waterform_waters_examine
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
if actor:get_quest_stage("waterform") == 6 and (actor:has_equipped("2808") or actor:has_item("2808")) then
    if actor:get_quest_var("waterform:" .. tostring(self.vnum)) then
        wait(1)
        actor:send("<b:blue>You have already examined this source.</>")
        return _return_value
    else
        wait(1)
        actor:send("<b:blue>You gather some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        actor:set_quest_var("waterform", tostring(self.vnum), 1)
        self.room:send_except(actor, "<blue>" .. tostring(actor.name) .. " gathers some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    local water1 = actor:get_quest_var("waterform:3296")
    local water2 = actor:get_quest_var("waterform:58405")
    local water3 = actor:get_quest_var("waterform:53319")
    local water4 = actor:get_quest_var("waterform:55804")
    local water5 = actor:get_quest_var("waterform:58701")
    local water6 = actor:get_quest_var("waterform:37014")
    if water1 and water2 and water3 and water4 and water5 and water6 then
        actor:advance_quest("waterform")
        actor:send("<b:blue>Your examinations of the water sources are complete!</>")
    end
end