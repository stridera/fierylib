-- Trigger: recall_nymrill
-- Zone: 237, ID: 90
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23790

-- Converted from DG Script #23790: recall_nymrill
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%

-- 2% chance to trigger
if not percent_chance(2) then
    return true
end

-- Command filter: quaff
if not (cmd == "quaff") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor.id == -1 then
    if actor.alignment <= -350 then
        _return_value = true
        actor:send("You quaff a potion and begin to feel a little light-headed...")
        self.room:send_except(actor, tostring(actor.name) .. " quaffs a black potion of recall.")
        self.room:send_except(actor, tostring(actor.name) .. " disappears in a flash of darkness!")
        if (string.find(actor.class, "Thief")) or (string.find(actor.class, "Assassin")) or (string.find(actor.class, "Mercenary")) or (string.find(actor.class, "Rogue")) then
            actor:teleport(get_room(495, 25))
        elseif (string.find(actor.class, "Sorcerer")) or (string.find(actor.class, "Cryomancer")) or (string.find(actor.class, "Pyromancer")) then
            actor:teleport(get_room(495, 22))
        elseif string.find(actor.class, "Necromancer") then
            actor:teleport(get_room(495, 14))
        else
            actor:teleport(get_room(495, 12))
        end
        actor:command("look")
        world.destroy(self)
    else
        actor:send("As you quaff a potion, you get a funny burning sensation in your stomach...")
        _return_value = true
        actor:command("quaff black-potion-recall")
    end
else
    _return_value = true
    actor:command("quaff black-potion-recall")
end
return _return_value