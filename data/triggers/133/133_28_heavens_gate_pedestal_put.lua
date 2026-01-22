-- Trigger: heavens_gate_pedestal_put
-- Zone: 133, ID: 28
-- Type: OBJECT, Flags: DROP
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--   Large script: 6037 chars
--
-- Original DG Script: #13328

-- Converted from DG Script #13328: heavens_gate_pedestal_put
-- Original: OBJECT trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on target.id
if actor:get_quest_stage("heavens_gate") == 1 then
    if target.id == 23817 then
        wait(2)
        actor.name:advance_quest("heavens_gate")
        world.destroy(self.room:find_object("bowl"))
        wait(2)
        self.room:send("Starlight settles on the burnished silver of " .. tostring(objects.template(238, 17).name) .. ".")
        wait(1)
        actor.name:send("<b:white>For a moment, all is calm, until the starlight crone rushes at you!</>")
        wait(2)
        actor:send("<b:white>You receive a vision of seven keys to seven gates <b:cyan>[put] <b:white>upon the <b:cyan>[pedestal]</>.")
        wait(1)
        actor:send("<b:white>One by one you receive a vision of each key:</>_")
        actor:send("<b:cyan>1. A small skeleton key forged of night and shadow</>")
        actor:send("</>   hidden deep in a twisted labyrinth.</>_")
        actor:send("<b:cyan>2. A key made from a piece of the black and pitted wood</>")
        actor:send("</>   typical of trees in the Twisted Forest near Mielikki.</>_")
        actor:send("<b:cyan>3. A large, black key humming with magical energy from</>")
        actor:send("</>   a twisted cruel city in a huge underground cavern.</>_")
        actor:send("<b:cyan>4. A key covered in oil</>")
        actor:send("</>   kept by a long-dead caretaker in a necropolis.</>_")
        actor:send("<b:cyan>5. A rusted but well cared for key</>")
        actor:send("</>   carried by an enormous griffin.</>_")
        actor:send("<b:cyan>6. A golden plated, wrought-iron key</>")
        actor:send("</>   held at the gates to a desecrated city.</>_")
        actor:send("<b:cyan>7. One nearly impossible to see</>")
        actor:send("</>   guarded by a fiery beast with many heads.</>")
        wait(1)
        actor:send("<b:white>Each key transforms into a star forming a circle in the sky.</>")
        actor:send("<b:white>They open some kind of gateway, leading into the unknown.</>")
        wait(1)
        actor:send("<b:white>The starlight crone gestures to the pedestal before dissipating into the dark.</>")
    else
        local response = "default"
    end
    if actor:get_quest_stage("heavens_gate") == 2 then
        if actor:get_quest_var("heavens_gate:" .. tostring(target.vnum)) then
        elseif target.id == 4005 or target.id == 12142 or target.id == 23709 or target.id == 47009 or target.id == 49008 or target.id == 52012 or target.id == 52013 then
            _return_value = false
            actor:send("The star knight refuses to take a second copy of the key.")
            return _return_value
        else
            actor.name:set_quest_var("heavens_gate", "%target.vnum%", 1)
            wait(1)
            world.destroy(self.contents)
            wait(2)
            local key1 = actor:get_quest_var("heavens_gate:4005")
            local key2 = actor:get_quest_var("heavens_gate:12142")
            local key3 = actor:get_quest_var("heavens_gate:23709")
            local key4 = actor:get_quest_var("heavens_gate:47009")
            local key5 = actor:get_quest_var("heavens_gate:49008")
            local key6 = actor:get_quest_var("heavens_gate:52012")
            local key7 = actor:get_quest_var("heavens_gate:52013")
            if (key1 + key2 + key3 + key4 + key5 + key6 + key7) == 7 then
                actor.name:advance_quest("heavens_gate")
                wait(1)
                actor:send("<b:white>The starry knight lifts the seven keys into the air.</>")
                wait(2)
                actor:send("<b:white>The keys begin to glow and swirl around one another.</>")
                wait(2)
                actor:send("<b:white>They fuse together into a single shining electrum key!</>")
                self.room:spawn_object(133, 51)
                actor:command("get key")
                wait(1)
                actor:send("<b:white>The valiant star knight reveals to you seven anomalies that threaten Ethilien.</>")
                wait(1)
                actor:send("<b:white>You see:</>")
                actor:send("</><b:cyan>1. A pool in a temple of ice and stone</>")
                actor:send("</>   leading to the realm of a death god.</>_")
                actor:send("</><b:cyan>2. A pool in a temple of ice and stone</>")
                actor:send("</>   leading to the realm of a war god.</>_")
                actor:send("</><b:cyan>3. A pool hidden under a well</>")
                actor:send("</>   on an island filled with ferocious beasts.</>_")
                actor:send("</><b:cyan>4. A portal from black rock</>")
                actor:send("</>   to black ice.</>_")
                actor:send("</><b:cyan>5. A portal from a fortress of the undead</>")
                actor:send("</>   to a realm of demons.</>_")
                actor:send("</><b:cyan>6. An archway that delivers demons</>")
                actor:send("</>   to the fortress of the dead.</>_")
                actor:send("</><b:cyan>7. An arch hidden in another plane</>")
                actor:send("</>   granting demons access to an enchanted village of mutants.</>")
                wait(1)
                actor:send("<b:white>Unintelligible words burble forth from the rifts... </>")
                wait(2)
                actor:send("<b:white>In your soul you hear the call to take the Key of Heaven and <b:cyan>seal <b:white>the <b:cyan>rifts!</>")
                world.destroy(self)
            else
                actor:send("<b:white>The starlight twinkles in recognition of your deed!</>_ _")
                actor:send("<b:white>It places the key in the bowl and beckons you to bring another.</>")
            end
        end
    else
        local response = "default"
    end
else
    local response = "default"
end
if response == "default" then
    actor:send("Nothing happens.")
end
return _return_value