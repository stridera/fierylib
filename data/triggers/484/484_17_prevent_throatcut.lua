-- Trigger: prevent throatcut
-- Zone: 484, ID: 17
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #48417

-- Converted from DG Script #48417: prevent throatcut
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: throatcut
if not (cmd == "throatcut") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "t" or cmd == "th" then
    _return_value = false
    return _return_value
end
if arg then
    local no_throat = "48400 48414 48500 48502 48503 48505 48513 48514 48515 48630 48631 48634 48803 48812 48813 48909 48919"
    local undead = "48404 48405 48902 48903 48905 48912 48913 48914 48915 48921 48922 48923"
    local boss = "48406 48504 48506 48507 48510 48632 48633 48635 48806 48809 48814 48901 48910 48911 48917 48918"
    if string.find(no_throat, "arg.id") then
        _return_value = true
        actor:send("But " .. tostring(arg.name) .. " doesn't even have a throat to cut!")
    elseif string.find(undead, "arg.id") then
        _return_value = true
        actor:send("<b:red>" .. tostring(arg.name) .. " gurgles as you slice into " .. tostring(arg.possessive) .. " throat, but there is little effect!</> (<yellow>0</>)")
        self.room:send_except(actor, "<b:red>" .. tostring(arg.name) .. " looks expressionless as " .. tostring(actor.name) .. " slices into " .. tostring(arg.possessive) .. " throat!</> (<yellow>0</>)")
        arg:command("kill %actor.name%")
    elseif string.find(boss, "arg.id") then
        _return_value = true
        actor:send("You just can't seem to get close enough to " .. tostring(arg.possessive) .. " throat...")
    end
else
    _return_value = false
end
return _return_value