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
    _return_value = false
    local phrases = {
        "Ahoy scurvey mateys!",
        "Arrr, its the plank for ye!",
        "Combat is too fricking slow here.",
        "What the devil are you scallawags doing on my ship!?",
        "You there!  Return the <blue>Black Pearl</> to me, I say!",
        "Bring me one noggin of rum, now, won't you?",
        "Shiver me timbers!",
        "Fifteen gnomes on the dead man's chest, yo ho ho and a bottle of rum!",
        "Do you buckle your swash or swash your buckler?",
    }
    local phrase = phrases[random(1, #phrases)]
    self.room:send(actor.name .. " pulls the string on a Dakhod action figure.")
    self.room:send("The Dakhod action figure says, '" .. phrase .. "'")
end
return _return_value