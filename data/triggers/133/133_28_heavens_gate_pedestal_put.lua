-- Trigger: heavens_gate_pedestal_put
-- Zone: 133, ID: 28
-- Type: OBJECT, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #13328
--
-- Pedestal interaction for the Heavens Gate quest. Fires whenever an object
-- is dropped on / put on the pedestal (this trigger lives on the pedestal).
--
-- Stage 1: deposit the silver prayer bowl (238, 17). The crone reveals the
--          seven keys to seven gates and advances the quest to stage 2.
-- Stage 2: deposit each of the seven gate keys. Once all seven have been
--          contributed (any order), they fuse into the Key of Heaven
--          (133, 51), seven rifts are revealed and the quest advances to
--          stage 3. Duplicate keys are rejected. Non-key drops fall
--          through to "Nothing happens."
--
-- Quest var schema (must stay in sync with 133_31_status_checker):
--   heavens_gate:<legacy_id> = 1   where legacy_id = zone_id * 100 + local_id
--   for the seven gate keys (4005, 12142, 23709, 47009, 49008, 52012, 52013).

local stage = actor:get_quest_stage("heavens_gate")

-- Stage 1: silver prayer bowl on pedestal -> reveal the seven keys.
if stage == 1 and target.zone_id == 238 and target.local_id == 17 then
    wait(2)
    actor:advance_quest("heavens_gate")
    world.destroy(self.room:find_object("bowl"))
    wait(2)
    self.room:send("Starlight settles on the burnished silver of " .. tostring(objects.template(238, 17).name) .. ".")
    wait(1)
    actor:send("<b:white>For a moment, all is calm, until the starlight crone rushes at you!</>")
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
    return true
end

-- Stage 2: deposit one of the seven gate keys.
if stage == 2 then
    local legacy_id = target.zone_id * 100 + target.local_id
    local is_gate_key =
        legacy_id == 4005  or legacy_id == 12142 or legacy_id == 23709 or
        legacy_id == 47009 or legacy_id == 49008 or legacy_id == 52012 or
        legacy_id == 52013

    if is_gate_key then
        local var_key = "heavens_gate:" .. tostring(legacy_id)
        if actor:get_quest_var(var_key) then
            actor:send("The star knight refuses to take a second copy of the key.")
            return true
        end

        actor:set_quest_var("heavens_gate", tostring(legacy_id), 1)
        wait(1)
        world.destroy(target)
        wait(2)

        local function got(id) return actor:get_quest_var("heavens_gate:" .. id) and 1 or 0 end
        local total = got("4005") + got("12142") + got("23709")
                    + got("47009") + got("49008") + got("52012") + got("52013")

        if total == 7 then
            actor:advance_quest("heavens_gate")
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
        return true
    end
end

actor:send("Nothing happens.")
return true
