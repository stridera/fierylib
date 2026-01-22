-- Trigger: vulcera_greet1
-- Zone: 481, ID: 24
-- Type: MOB, Flags: GREET, GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #48124

-- Converted from DG Script #48124: vulcera_greet1
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
wait(6)
self:command("peer " .. tostring(actor.name))
self:say("So puny one, you dare to disturb me?")
local stage = 7
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("phase_wand") == "wandstep" then
            if person.level >= 60 then
                if person:get_quest_var("phase_wand:greet") == 0 then
                    wait(2)
                    self:say("What do you want pathetic mortal?")
                else
                    self:say("Do you have what I require for the " .. tostring(weapon) .. "?")
                end
            end
        end
        if person:get_quest_stage("fieryisle_quest") == "stage" then
            person.name:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            if person:has_item("48116") then
                wait(2)
                self:emote("does a double take at " .. tostring(person.name) .. ".")
                self:say("Are you the one who has the key to the ivory chest?!")
                wait(1)
                self:command("bow " .. tostring(person.name))
                self:say("If so you could end my punishment, I would make it worth your while.")
                wait(2)
                self:emote("mutters a brief incantation and a cloak of flames appears.")
                person:send("<b:white>Group credit will not be awarded for the next step.</>")
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end