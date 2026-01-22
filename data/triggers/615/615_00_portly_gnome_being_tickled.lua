-- Trigger: Portly gnome being tickled
-- Zone: 615, ID: 0
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61500

-- Converted from DG Script #61500: Portly gnome being tickled
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: tickle gnome
if not (cmd == "tickle" or cmd == "gnome") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- This is a trigger for tickling the portly gnome in the Enchanted Hollow.
-- Tickling makes him float up into the air with glee.
-- If there's a cherry up in a tree, he'll grab it and end up dropping it,
-- thus making it accessible to players.
if string.find(arg, "gnome") then
    local rightobj = 1
end
if string.find(arg, "portly") then
    local rightobj = 1
end
if rightobj ==1 then
    self.room:send_except(actor, tostring(actor.name) .. " tickles " .. tostring(self.name) .. ".")
    actor:send("You tickle " .. tostring(self.name) .. ".")
    wait(1)
    self:emote("doubles over, giggling!")
    wait(5)
    self:emote("loses contact with the ground, spinning upward into the air...")
    wait(10)
    self:command("get purple-cherry-in-tree")
    wait(10)
    self:emote("descends slowly back to the ground.")
else
    _return_value = false
end
return _return_value