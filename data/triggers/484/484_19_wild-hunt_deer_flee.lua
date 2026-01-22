-- Trigger: wild-hunt deer flee
-- Zone: 484, ID: 19
-- Type: MOB, Flags: GLOBAL, COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48419

-- Converted from DG Script #48419: wild-hunt deer flee
-- Original: MOB trigger, flags: GLOBAL, COMMAND, probability: 100%

-- Command filter: drop
if not (cmd == "drop") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- If drop the player is using the secret keyword to drop
-- the rag, flee!  Unfortunately, players can force the
-- deer to flee any time, so don't tell any of them this
-- keyword.
_return_value = false
if actor:get_quest_stage("doom_entrance") and actor:get_quest_var("doom_entrance:wild_hunt") == 1 and arg == "ragtoscarewhitetaileddeer" then
    wait(1)
    local room = self.room
    while room == self.room do
        self:command("flee")
    end
end
return _return_value