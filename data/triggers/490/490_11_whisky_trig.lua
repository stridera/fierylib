-- Trigger: whisky_trig
-- Zone: 490, ID: 11
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49011

-- Converted from DG Script #49011: whisky_trig
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
wait(2)
if object.type == "LIQ CONTAINER" then
    if object.val1 == 0 then
        self:say("An empty container?  How generous.")
    elseif object.val2 ~= 5 then
        self:say("Whisky is what I wanted!")
    else
        self:say("Thanks " .. tostring(actor.name) .. " and here is your ladder")
        self.room:spawn_object(490, 41)
        self:command("give ladder " .. tostring(actor.name))
    end
end