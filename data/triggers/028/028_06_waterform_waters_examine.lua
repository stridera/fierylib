-- Trigger: waterform_waters_examine
-- Zone: 28, ID: 6
-- Type: OBJECT, Flags: LOOK
-- Status: REVIEWED (cup possession check fixed; undefined return fixed)
--
-- Original DG Script: #2806
-- Attached to each of the six water-source objects in the world. When the
-- player looks at a source while on waterform stage 6 with the dragon bone
-- cup (28:8), record the source as examined. After all six are examined,
-- advance the quest.

if actor:get_quest_stage("waterform") == 6
   and (actor:has_equipped(28, 8) or actor:has_item("dragon-bone-cup")) then
    if actor:get_quest_var("waterform:" .. tostring(self.zone_id) .. "_" .. tostring(self.local_id)) then
        wait(1)
        actor:send("<b:blue>You have already examined this source.</>")
        return true
    else
        wait(1)
        actor:send("<b:blue>You gather some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
        actor:set_quest_var("waterform", (tostring(self.zone_id) .. "_" .. tostring(self.local_id)), 1)
        self.room:send_except(actor, "<blue>" .. tostring(actor.name) .. " gathers some water from " .. tostring(self.shortdesc) .. " in " .. tostring(objects.template(28, 8).name) .. ".</>")
    end
    -- Composite IDs: 32:96 Mielikki granite pool, 584:5 King of Dreams artesian
    -- well, 533:19 Ice Cult fountain, 558:4 Eldorian creek, 587:1 Dancing Dolphin
    -- wishing well, 370:14 Minithawkin underground brook.
    local water1 = actor:get_quest_var("waterform:32_96")
    local water2 = actor:get_quest_var("waterform:584_5")
    local water3 = actor:get_quest_var("waterform:533_19")
    local water4 = actor:get_quest_var("waterform:558_4")
    local water5 = actor:get_quest_var("waterform:587_1")
    local water6 = actor:get_quest_var("waterform:370_14")
    if water1 and water2 and water3 and water4 and water5 and water6 then
        actor:advance_quest("waterform")
        actor:send("<b:blue>Your examinations of the water sources are complete!</>")
    end
end