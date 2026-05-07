-- Trigger: timer_on_recall
-- Zone: 480, ID: 1
-- Type: OBJECT, Flags: GET
-- Status: CLEAN
--
-- Original DG Script: #48001

-- Converted from DG Script #48001: timer_on_recall
-- Original: OBJECT trigger, flags: GET, probability: 100%
self.room:send_except(actor, "As " .. tostring(actor.name) .. " grabs the stone you feel a lurch in your stomach.")
actor:send("You feel the stone burn against your hand for a second and it is gone!")
self.room:teleport_all(get_room(480, 80))
-- TODO(parity): originally forced every transported actor to "look"; find_actor("all")
-- returns at most one actor, so the auto-look only fires for one player. Replace with
-- a per-actor loop once teleport_all returns the list of moved actors.
self.room:find_actor("all"):command("look")
return true