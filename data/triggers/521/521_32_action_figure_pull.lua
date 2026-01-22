-- Trigger: action_figure_pull
-- Zone: 521, ID: 32
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52132

-- Converted from DG Script #52132: action_figure_pull
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == "string" then
    _return_value = true
    -- switch on random(1, 9)
    if random(1, 9) == 1 then
        local phrase = "Ahoy scurvey mateys!"
    elseif random(1, 9) == 2 then
        local phrase = "Arrr, its the plank for ye!"
    elseif random(1, 9) == 3 then
        local phrase = "Combat is too fricking slow here."
    elseif random(1, 9) == 4 then
        local phrase = "What the devil are you scallawags doing on my ship!?"
    elseif random(1, 9) == 5 then
        local phrase = "You there!  Return the &bBlack Pearl&0 to me, I say!"
    elseif random(1, 9) == 6 then
        local phrase = "Bring me one noggin of rum, now, won't you?"
    elseif random(1, 9) == 7 then
        local phrase = "Shiver me timbers!"
    elseif random(1, 9) == 8 then
        local phrase = "Fifteen gnomes on the dead man's chest, yo ho ho and a bottle of rum!"
    elseif random(1, 9) == 9 then
        local phrase = "Do you buckle your swash or swash your buckler?"
    else
        local phrase = "Yaaarrrrr!"
    end
    self.room:send(tostring(actor.name) .. " pulls the string on a Dakhod action figure.")
    self.room:send("The Dakhod action figure says, '" .. tostring(phrase) .. "'")
else
    _return_value = false
end
return _return_value