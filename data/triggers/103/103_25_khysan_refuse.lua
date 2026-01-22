-- Trigger: Khysan refuse
-- Zone: 103, ID: 25
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--
-- Original DG Script: #10325

-- Converted from DG Script #10325: Khysan refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on object.id
if object.id == "%wandgem%" or object.id == "%wandtask3%" or object.id == "%wandtask4%" or object.id == "%wandvnum%" then
    return _return_value
else
    local stage = actor:get_quest_stage("ice_shards")
    -- switch on stage
    -- switch on object.id
    if object.id == 16209 or object.id == 18505 or object.id == 55003 or object.id == 58415 then
        return _return_value
    else
        local response = "This isn't one of the four books I need to consult."
    end
    if object.id ~= 55004 then
        local response = "This isn't the Codex of War."
    end
    if object.id ~= 58806 then
        local response = "This isn't Commander Thraja's journal..."
    end
    if object.id ~= 48502 then
        local response = "Weird, this doesn't look like a map of Ickle."
    end
    if object.id ~= 53423 then
        local response = "Do you think we can get new information from object.shortdesc?  I doubt it..."
    end
    if object.id ~= 43013 then
        local response = "Is this a book?"
    end
    if object.id ~= 10325 then
        local response = "Is this all you could find?"
    end
    local response = "Oh, is this a gift for me?  I appreciate it, but I'm fine for now."
    if response then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say(tostring(response))
    end
end  -- auto-close block
return _return_value