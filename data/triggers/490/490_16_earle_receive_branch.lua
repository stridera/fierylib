-- Trigger: Earle receive branch
-- Zone: 490, ID: 16
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49016

-- Converted from DG Script #49016: Earle receive branch
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- Small oak branch given
wait(2)
local person = actor
local i = person.group_size
if i then
    local a = 1
else
    local a = 0
end
while i >= a do
    local person = person.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("griffin_quest") == 0 then
            person.name:start_quest("griffin_quest")
            person:send("<b:white>You have now begun the Griffin Isle quest!</>")
        end
        person:set_quest_var("griffin_quest", "oak", 1)
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
self:destroy_item("small-oak-branch")
if not world.count_mobiles("49001") then
    get_room(490, 81):at(function()
        self.room:spawn_mobile(490, 1)
    end)
end
get_room(490, 81):at(function()
    self.room:find_actor("undead-captain"):spawn_object(490, 37)
end)
self:say("Ah, excellent work, " .. tostring(actor.name) .. ".")
self:emote("examines the oak branch.")
wait(2)
self:say("The centuries have taken their toll, but it is still powerful.")
self:emote("utters some incantations and the branch starts to sprout roots and leaves!")
self.room:spawn_object(490, 45)
self:command("give sapling " .. tostring(actor.name))
wait(3)
self:say("This sapling needs to be placed near the altar to be effective.  May the tree spirits guard you.")
if actor:get_quest_stage("griffin_quest") == 1 then
    wait(2)
    self:say("Now, did you also retrieve the sword?  Give it to me.")
end