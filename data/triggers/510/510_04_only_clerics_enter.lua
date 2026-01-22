-- Trigger: only_clerics_enter
-- Zone: 510, ID: 4
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #51004

-- Converted from DG Script #51004: only_clerics_enter
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
local _return_value = true  -- Default: allow action
if actor.level < 100 then
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        actor:send("You feel a calmness come over you, as if the troubles of the world are washed away.")
        if entry == "" then
            local entry = 1
            globals.entry = globals.entry or true
        else
            local entry = entry + 1
        end
    else
        actor:send("You can't seem to enter the room!  It is like stepping against a solid wall,")
        actor:send("</>but you can see in.")
        actor:send("You seem to hear a voice whisper, 'This room is not for you.'")
        _return_value = false
    end
end
return _return_value