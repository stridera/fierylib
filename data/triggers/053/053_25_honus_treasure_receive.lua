-- Trigger: Honus treasure receive
-- Zone: 53, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #5325

-- Converted from DG Script #5325: Honus treasure receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == 61514 then
    -- singing chain
    local stage = 1
elseif object.id == 4319 then
    -- fire ring
    local stage = 2
elseif object.id == 16103 then
    -- sandstone ring
    local stage = 3
elseif object.id == 50215 then
    -- electrum hoop
    local stage = 4
elseif object.id == 48101 then
    -- rainbow shell
    local stage = 5
elseif object.id == 16009 then
    -- stormshield
    local stage = 6
elseif object.id == 55008 then
    -- snow leopard cloak
    local stage = 7
elseif object.id == 49041 then
    -- rope ladder
    local stage = 8
elseif object.id == 58401 then
    -- phoenix feather
    local stage = 9
elseif object.id == 53500 or object.id == 53501 or object.id == 53505 or object.id == 53506 then
    -- sleet armor
    local stage = 10
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
        if person:get_quest_stage("treasure_hunter") == "stage" then
            if person:get_quest_var("treasure_hunter:hunt") == "found" then
                person:set_quest_var("treasure_hunter", "hunt", "returned")
                local accept = 1
                local refuse = 0
            elseif actor:get_quest_var("treasure_hunter:hunt") == "running" then
                if accept then
                    local refuse = 0
                else
                    local refuse = 1
                end
            elseif actor:get_quest_var("treasure_hunter:hunt") == "returned" then
                if accept then
                    local refuse = 0
                else
                    local refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") > stage then
                if accept then
                    local refuse = 0
                else
                    local refuse = 2
                end
            elseif actor:get_quest_stage("treasure_hunter") < stage then
                if accept then
                    local refuse = 0
                else
                    local refuse = 3
                end
            end
        end
    elseif person and person.id == -1 then
        local i = i + 1
    end
    local a = a + 1
end
if accept == 1 then
    wait(2)
    world.destroy(object)
    self:command("grin")
    self.room:send(tostring(self.name) .. " says, 'Excellent!  Now just give me the order paperwork and I can pay you.'")
elseif refuse then
    _return_value = false
    self:command("shake")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    if refuse == 1 then
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'Nah nah nah, you gotta put in at least a little effort toward finding this yourself, come on.'")
    elseif refuse == 2 then
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'You already stole - er, recovered this treasure!'")
    elseif refuse == 3 then
        wait(2)
        self.room:send(tostring(self.name) .. " says, 'I'm not looking for that...  Yet.'")
    end
end
return _return_value