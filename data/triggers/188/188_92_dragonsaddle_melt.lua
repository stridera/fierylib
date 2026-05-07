-- Trigger: dragonsaddle_melt
-- Zone: 188, ID: 92
-- Type: OBJECT, Flags: GET, WEAR
-- Status: CLEAN
--
-- Original DG Script: #18892

-- Converted from DG Script #18892: dragonsaddle_melt
-- Original: OBJECT trigger, flags: GET, WEAR, probability: 100%
-- Allow the dragon mounts (mob 18890/18891) to handle the saddle silently;
-- anyone else picking it up causes it to melt away.
if (actor.id == 18890) or (actor.id == 18891) then
    return true
end
if actor.canbeseen then
    actor:send("As you take hold of " .. tostring(self.shortdesc) .. ", it melts between your fingers.")
    self.room:send_except(actor, "As " .. tostring(actor.name) .. " takes hold of " .. tostring(self.shortdesc) .. ", it melts between " .. tostring(actor.possessive) .. " fingers.")
else
    self.room:send(tostring(self.shortdesc) .. " spontaneously combusts.")
end
world.destroy(self)
return true