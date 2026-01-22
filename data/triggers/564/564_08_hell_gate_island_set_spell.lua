-- Trigger: hell_gate_island_set_spell
-- Zone: 564, ID: 8
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #56408

-- Converted from DG Script #56408: hell_gate_island_set_spell
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send(tostring(mobiles.template(564, 0).name) .. " comes out of hiding.")
get_room(11, 0):at(function()
    find_player("diabolist"):teleport(get_room(564, 31))
end)
if world.count_mobiles("56402") == 0 then
    wait(1)
    self.room:send("Larathiel's golden celestial blood seeps into the steaming ground.")
    wait(3)
    self.room:send("The earth shudders and shifts as it cracks and breaks apart!")
    self.room:send("A gout of <b:red>fire</> erupts from a fissure leading into the bowels of the earth!")
    wait(2)
    self.room:send("An enormous demonic entity claws its way out of the hole.")
    wait(2)
    -- 
    -- Yes, Brolgoroth remains in game until killed or purged via reset
    -- 
    self.room:spawn_mobile(564, 2)
    self.room:send("The demon looks around itself and roars victoriously!")
    self.room:send("Brolgoroth says, <b:red>'At last, Garl'lixxil is connected to Ethilien again!</>")
    self.room:send("</><b:red>Now to add this world my dominion!'</>")
end
local person = self.people
while person do
    if person:get_quest_stage("hell_gate") == 6 then
        wait(2)
        person:send("Brolgoroth tells you, <b:red>'Thank you, " .. tostring(person.name) .. ", for your unholy service.</>")
        person:send("</><b:red>As promised, I shall teach you a great secret.'</>_")
        person:send("Your mind is flooded with images of fire and pain as Brolgoroth's mind connects with yours.")
        person:send("<b:red>The secrets of Hell Gate are seared into your memory!</>")
        person.name:complete_quest("hell_gate")
        if not actor:get_quest_var("hell_trident:helltask4") and actor:get_quest_stage("hell_trident") == 2 then
            actor:set_quest_var("hell_trident", "helltask4", 1)
        end
        self.room:find_actor("diabolist"):command("mskillset %person.name% hell gate")
    end
    local person = person.next_in_room
end