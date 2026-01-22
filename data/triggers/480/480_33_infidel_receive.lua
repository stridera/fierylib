-- Trigger: Infidel receive
-- Zone: 480, ID: 33
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #48033

-- Converted from DG Script #48033: Infidel receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
world.destroy(object)
self.room:send(tostring(self.name) .. " grins as he crushes the Prince's skull to dust.")
wait(1)
self:command("laugh")
self:say("Good, just as it should be.")
wait(2)
self.room:send(tostring(self.name) .. " dusts off his hands and produces a sickly gnarled staff from his belongings.")
wait(1)
self:say("Take this as a reward.")
self.room:spawn_object(480, 39)
self:command("give infidels-staff " .. tostring(actor))
local person = actor
local i = person.group_size
if i then
    while i > 0 do
        local person = actor.group_member[i]
        if person.room == self.room then
            if person:get_quest_stage("hell_trident") == 2 then
                if not person:get_quest_var("hell_trident:helltask6") then
                    person:set_quest_var("hell_trident", "helltask6", 1)
                end
            end
            person:send("<b:yellow>You have finished the infidel's duel!</>")
        end
        local i = i - 1
    end
else
    if person:get_quest_stage("hell_trident") == 2 then
        if not person:get_quest_var("hell_trident:helltask6") then
            person:set_quest_var("hell_trident", "helltask6", 1)
        end
    end
    person:send("<b:yellow>You have finished the infidel's duel!</>")
end