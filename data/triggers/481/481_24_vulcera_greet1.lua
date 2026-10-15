-- Trigger: vulcera_greet1
-- Zone: 481, ID: 24
-- Type: MOB, Flags: GREET, GREET_ALL
-- Status: CLEAN
--
-- Original DG Script: #48124
--
-- `wandstep`, `weapon` and `type` are DG globals set on this mob by its LOAD trigger (002_111);
-- they are read from the mob's `globals` table.

-- Converted from DG Script #48124: vulcera_greet1
-- Original: MOB trigger, flags: GREET, GREET_ALL, probability: 100%
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
wait(0.6)
self:command("peer " .. tostring(actor.name))
self:say("So puny one, you dare to disturb me?")
local stage = 7
local person = actor
local i = person.group_size
local a
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage(wand_quest) == globals.wandstep then
            if person.level >= 60 then
                if (person:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    wait(0.2)
                    self:say("What do you want pathetic mortal?")
                else
                    self:say("Do you have what I require for the " .. tostring(globals.weapon) .. "?")
                end
            end
        end
        if person:get_quest_stage("fieryisle_quest") == stage then
            person:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            if person:has_item(481, 16) then
                wait(0.2)
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
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end