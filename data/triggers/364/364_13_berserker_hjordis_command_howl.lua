-- Trigger: berserker_hjordis_command_howl
-- Zone: 364, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #36413

-- Converted from DG Script #36413: berserker_hjordis_command_howl
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: howl
if not (cmd == "howl") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "h" or cmd == "ho" then
    _return_value = false
    return _return_value
end
if actor:get_quest_stage("berserker_subclass") == 3 then
    actor:advance_quest("berserker_subclass")
    actor:send("You raise your voice in a mighty howl to the Spirits!")
    self.room:send_except(actor, tostring(actor.name) .. " raises " .. tostring(hisher) .. " voice in a mighty howl to the Spirits!")
    wait(2)
    -- switch on random(1, 4)
    if random(1, 4) == 1 then
        local target = 16105
        local place = "a desert cave"
    elseif random(1, 4) == 2 then
        local target = 16310
        local place = "some forested highlands"
    elseif random(1, 4) == 3 then
        local target = 20311
        local place = "a vast plain"
    elseif random(1, 4) == 4 then
    else
        local target = 55220
        local place = "the frozen tundra"
    end
    actor:send(tostring(self.name) .. " throws her head back and howls along with you!")
    self.room:send_except(actor, tostring(self.name) .. " throws her head back and howls along with " .. tostring(actor.name) .. "!")
    wait(2)
    actor:set_quest_var("berserker_subclass", "target", target)
    actor:send("The Spirits reveal to you a vision of <b:yellow>" .. "%get.mob_shortdesc[%target%]%</>!")
    actor:send("You see it is in <b:yellow>" .. tostring(place) .. "</>!")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'The Spirits have spoken!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Find the beast of your Wild Hunt and join our ranks.  Remember, this quest must be undertaken <b:red>ALONE</>.  If you are grouped when you fight your prey, there will be consequences!'")
else
    _return_value = false
end
return _return_value