-- Trigger: pfarlysia_cloak
-- Zone: 22, ID: 67
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #2267

-- Converted from DG Script #2267: pfarlysia_cloak
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
wait(2)
actor:send("As you wear " .. tostring(self.shortdesc) .. ", the cloak shimmers a <b:red>redish</>-<b:yellow>yellow</>.")
self.room:send_except(actor, "As " .. tostring(actor.name) .. " wears " .. tostring(self.shortdesc) .. ", the cloak shimmers a <b:red>redish</>-<b:yellow>yellow</>.")