-- Trigger: DemonLordBow
-- Zone: 125, ID: 25
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--
-- Original DG Script: #12525

-- Converted from DG Script #12525: DemonLordBow
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: bow
if not (cmd == "bow") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "b" or cmd == "bo" then
    _return_value = false
    return _return_value
end
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
        if person:get_quest_stage("krisenna_quest") == 2 then
            local krisenna = person:get_quest_stage("krisenna_quest")
            person.name:advance_quest("krisenna_quest")
            person:send("<b:white>You have advanced the quest!</>")
            local go = "zone"
        end
    elseif person then
        local i = i + 1
    end
    local a = a + 1
end
if actor:get_quest_stage("hell_trident") == 2 then
    local hell = actor:get_quest_stage("hell_trident")
    if actor.level >= 90 then
        if not actor:get_quest_var("hell_trident:helltask5") then
            if actor:get_has_completed("resurrection_quest") then
                actor:set_quest_var("hell_trident", "helltask5", 1)
            end
        end
        if not actor:get_quest_var("hell_trident:helltask4") then
            if actor:get_has_completed("hell_gate") then
                actor:set_quest_var("hell_trident", "helltask4", 1)
            end
        end
        if actor:get_quest_var("hell_trident:greet") == 1 then
            go = nil
            local go = "trident"
        else
            local go = "zone"
        end
    end
end
if go then
    actor:send("You bow before him.")
    self.room:send_except(actor, tostring(actor.name) .. " bows before " .. tostring(self.name) .. ".")
    wait(1)
    if go == "trident" then
        self:say("I see you still remember your manners.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Why have you returned?  Have you brought your sacrifices?'")
        if krisenna == 2 then
            wait(1)
            actor:send(tostring(self.name) .. " says, 'Or is it something else?'")
        end
    elseif go == "zone" then
        self:say("Ah yes, the respect I deserve.")
        wait(1)
        self:command("peer " .. tostring(actor.name))
        wait(2)
        self:say("What brings you to me?")
        wait(2)
        if hell == 2 then
            actor:send(tostring(self.name) .. " says, 'Your quest for a new <b:cyan>[trident]</> perhaps?'")
            if krisenna == 2 then
                wait(1)
                actor:send(tostring(self.name) .. " says, 'Or is it something else?'")
            end
        end
    end
else
    _return_value = false
end
return _return_value