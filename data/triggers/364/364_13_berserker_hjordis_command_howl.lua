-- Trigger: berserker_hjordis_command_howl
-- Zone: 364, ID: 13
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN (reviewed 2026-01-22)
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
    local target_zone = nil
    local target_local = nil
    local place = nil
    local roll = random(1, 4)
    if roll == 1 then
        target_zone, target_local = 161, 5  -- was 16105
        place = "a desert cave"
    elseif roll == 2 then
        target_zone, target_local = 163, 10  -- was 16310
        place = "some forested highlands"
    elseif roll == 3 then
        target_zone, target_local = 203, 11  -- was 20311
        place = "a vast plain"
    else
        target_zone, target_local = 552, 20  -- was 55220
        place = "the frozen tundra"
    end
    actor:send(tostring(self.name) .. " throws her head back and howls along with you!")
    self.room:send_except(actor, tostring(self.name) .. " throws her head back and howls along with " .. tostring(actor.name) .. "!")
    wait(2)
    -- Store as zone * 100 + local for quest var compatibility
    actor:set_quest_var("berserker_subclass", "target", target_zone * 100 + target_local)
    actor:send("The Spirits reveal to you a vision of <b:yellow>" .. tostring(mobs.template(target_zone, target_local).short_description) .. "</>!")
    actor:send("You see it is in <b:yellow>" .. tostring(place) .. "</>!")
    wait(6)
    actor:send(tostring(self.name) .. " says, 'The Spirits have spoken!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Find the beast of your Wild Hunt and join our ranks.  Remember, this quest must be undertaken <b:red>ALONE</>.  If you are grouped when you fight your prey, there will be consequences!'")
else
    _return_value = false
end
return _return_value