-- Trigger: action_figure_pull
-- Zone: 521, ID: 32
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #52132

-- Converted from DG Script #52132: action_figure_pull
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- Command location mask 1: legacy OCMD_EQUIP=1 (worn), OCMD_INVEN=2 (carried), OCMD_ROOM=4 (floor)
if not (location == "equip") then
    return true  -- Not in a location this trigger watches
end

-- Command filter: pull
if not (cmd == "pull") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
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