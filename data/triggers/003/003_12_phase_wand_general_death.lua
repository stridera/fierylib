-- Trigger: phase wand general death
-- Zone: 3, ID: 12
-- Type: MOB, Flags: DEATH
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #312

-- Converted from DG Script #312: phase wand general death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- switch on self.id
if self.id == 23803 then
    local type = "air"
    local color = "&7&b"
    local wandvnum = 307
elseif self.id == 52001 then
    local type = "air"
    local color = "&7&b"
    local wandvnum = 308
elseif self.id == 4013 then
    local type = "fire"
    local color = "&1"
    local wandvnum = 317
elseif self.id == 52002 then
    local type = "fire"
    local color = "&1"
    local wandvnum = 318
elseif self.id == 53300 then
    local type = "ice"
    local color = "&6&b"
    local wandvnum = 327
elseif self.id == 52005 then
    local type = "ice"
    local color = "&6&b"
    local wandvnum = 328
elseif self.id == 52018 then
    local type = "acid"
    local color = "&2&b"
    local wandvnum = 337
elseif self.id == 52007 then
    local type = "acid"
    local color = "&2&b"
    local wandvnum = 338
end
local i = actor.group_size
if i then
    local a = 1
    while i >= a do
        local person = actor.group_member[a]
        local stage = person.quest_stage[type_wand]
        if person.room == self.room then
            if person.quest_stage[type_wand] == 9 then
                if not person.quest_variable[type_wand .. ":wandtask4"] then
                    person:set_quest_var("%type%_wand", "wandtask4", 1)
                    person:send(tostring(color) .. "%get.obj_shortdesc[%wandvnum%]% crackles with vibrant energy!</>")
                    person:send(tostring(color) .. "It is primed for reforging!</>")
                end
            elseif person.quest_stage[type_wand] == 10 then
                if not person.quest_variable[type_wand .. ":wandtask3"] then
                    person:set_quest_var("%type%_wand", "wandtask3", 1)
                    person:send(tostring(color) .. "%get.obj_shortdesc[%wandvnum%]% crackles with vibrant energy!</>")
                    person:send(tostring(color) .. "It is primed for reforging!</>")
                end
            end
        elseif person then
            local i = i + 1
        end
        local a = a + 1
    end
else
    local stage = actor.quest_stage[type_wand]
    if actor.quest_stage[type_wand] == 9 then
        if not actor.quest_variable[type_wand .. ":wandtask4"] then
            actor:set_quest_var("%type%_wand", "wandtask4", 1)
            actor:send(tostring(color) .. "%get.obj_shortdesc[%wandvnum%]% crackles with vibrant energy!</>")
            actor:send(tostring(color) .. "It is primed for reforging!</>")
        end
    elseif actor.quest_stage[type_wand] == 10 then
        if not actor.quest_variable[type_wand .. ":wandtask3"] then
            actor:set_quest_var("%type%_wand", "wandtask3", 1)
            actor:send(tostring(color) .. "%get.obj_shortdesc[%wandvnum%]% crackles with vibrant energy!</>")
            actor:send(tostring(color) .. "It is primed for reforging!</>")
        end
    end
end