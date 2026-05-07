-- Trigger: hell_gate_island_set_spell
-- Zone: 564, ID: 8
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #56408
--
-- Coda of the hell-gate quest, fired from larathiel_death (564, 7) via
-- run_room_trigger. The diabolist re-emerges, then if Brolgoroth has not
-- yet been spawned the climactic emergence sequence plays. Every player
-- in the room on stage 6 gets the demon's reward, the hell_gate quest
-- completes, and (parity) hell_trident task 4 is marked.
--
-- TODO(parity): the original DG also dispatched
-- `wat 1100 wteleport diabolist 56431` to send the priest off-island
-- after speaking. The Lua converter emits `:at(function() ... end)` on
-- a remote room, but that room-callback API is not yet in the runtime,
-- so the priest currently stays here. Restore once available.
self.room:send(tostring(mobiles.template(564, 0).name) .. " comes out of hiding.")

-- Send the diabolist back to the priest hub at (564, 31). When room:at()
-- is supported by the runtime this becomes the original cross-room call.
get_room(11, 0):at(function()
    local d = find_player("diabolist")
    if d then d:teleport(get_room(564, 31)) end
end)

if world.count_mobiles(564, 2) == 0 then
    wait(1)
    self.room:send("Larathiel's golden celestial blood seeps into the steaming ground.")
    wait(3)
    self.room:send("The earth shudders and shifts as it cracks and breaks apart!")
    self.room:send("A gout of <b:red>fire</> erupts from a fissure leading into the bowels of the earth!")
    wait(2)
    self.room:send("An enormous demonic entity claws its way out of the hole.")
    wait(2)
    -- Brolgoroth remains in game until killed or purged via reset.
    self.room:spawn_mobile(564, 2)
    self.room:send("The demon looks around itself and roars victoriously!")
    self.room:send("Brolgoroth says, <b:red>'At last, Garl'lixxil is connected to Ethilien again!</>")
    self.room:send("</><b:red>Now to add this world my dominion!'</>")
end

for _, person in ipairs(self.room.people) do
    if person:get_quest_stage("hell_gate") == 6 then
        wait(2)
        person:send("Brolgoroth tells you, <b:red>'Thank you, " .. tostring(person.name) .. ", for your unholy service.</>")
        person:send("</><b:red>As promised, I shall teach you a great secret.'</>")
        person:send("Your mind is flooded with images of fire and pain as Brolgoroth's mind connects with yours.")
        person:send("<b:red>The secrets of Hell Gate are seared into your memory!</>")
        person:complete_quest("hell_gate")
        -- Original DG referenced %actor.*% here even though actor isn't
        -- bound for this GLOBAL trigger; carry forward the parallel
        -- hell_trident progress on `person` instead.
        if not person:get_quest_var("hell_trident:helltask4") and person:get_quest_stage("hell_trident") == 2 then
            person:set_quest_var("hell_trident", "helltask4", 1)
        end
        local diabolist = self.room:find_actor("diabolist")
        if diabolist then
            diabolist:command("mskillset " .. tostring(person.name) .. " hell gate")
        end
    end
end
