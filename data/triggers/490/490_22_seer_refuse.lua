-- Trigger: Seer refuse
-- Zone: 490, ID: 22
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49022

-- Converted from DG Script #49022: Seer refuse
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- TODO(parity): Original DG referenced quest-state object IDs (%wandgem%,
-- %wandtask3%, %wandtask4%, %wand_id%) used by the wizard_eye quest to skip
-- this refuse trigger. Those globals are not represented in the Lua runtime
-- yet; the early-return short-circuit is omitted until the wizard_eye quest
-- exposes the equivalent quest-var lookup.
local _return_value = true  -- Default: allow action
local response, action
if actor:get_quest_stage("wizard_eye") == 4 then
    response = "This isn't a dress, bay, or thyme!  I don't have thyme for this!"
    action = "cackle"
else
    response = "This isn't sunscreen, what use do I have for it?"
end
if response then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
    if action then
        self:command(action)
    end
end
return _return_value