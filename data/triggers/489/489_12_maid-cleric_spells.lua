-- Trigger: maid-cleric spells
-- Zone: 489, ID: 12
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- The cleric maid's spell loop. Once per tick:
--   * If a stop-casting flag is queued (set by trigger 15 when the cleric
--     dies mid-cast), clear it and abort.
--   * Otherwise pick between a group heal (favored after the maid-cleric's
--     50%-HP healing mode is primed) and an alignment-based AOE that
--     alternates consecration <-> sacrilege each invocation.

-- Clear stop-casting message
if globals.stop_casting then
    globals.stop_casting = nil
end
if globals.casting then
    return true
end
globals.casting = 1
local heal_chance = random(1, 10)
if (globals.healing and (heal_chance > 2)) or (heal_chance == 10) then
    self.room:send("A maid in waiting starts casting <b:yellow>'group heal'</>...")
    wait(5)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    self.room:send("A maid in waiting completes her spell...")
    self.room:send("A maid in waiting utters the words, 'craes poir'.")
    -- Heal Lokari and any of his three maids that are still alive.
    if world.count_mobiles(489, 1) > 0 then
        self.room:find_actor("lokari"):heal(450)
    end
    if world.count_mobiles(489, 15) > 0 then
        self.room:find_actor("maid-rogue"):heal(450)
    end
    if world.count_mobiles(489, 22) > 0 then
        self.room:find_actor("maid-sorcerer"):heal(450)
    end
    if world.count_mobiles(489, 23) > 0 then
        self.room:find_actor("maid-cleric"):heal(450)
    end
else
    -- Alternate between good and evil spells.
    if globals.spell == "good" then
        globals.spell = "evil"
    else
        globals.spell = "good"
    end
    local spell = globals.spell
    if spell == "good" then
        self.room:send("A maid in waiting starts casting <b:yellow>'consecration'</>...")
    else
        self.room:send("A maid in waiting starts casting <b:yellow>'sacrilege'</>...")
    end
    wait(2)
    if globals.stop_casting then
        -- Stop casting if we've been passed a stop-casting message
        globals.stop_casting = nil
        globals.casting = nil
        return true
    end
    if spell == "good" then
        self.room:send("A maid in waiting utters the words, 'parl xafm'.")
        self.room:send("<b:white>A maid in waiting speaks a word of divine consecration!</>")
    else
        self.room:send("A maid in waiting utters the words, 'ebparl xafm'.")
        self.room:send("<blue>&9A maid in waiting speaks a word of demonic sacrilege!</>")
    end
    local person = self.people
    while person do
        local next_person = person.next_in_room
        if ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
            local hit = (spell == "good" and person.alignment < -349)
                     or (spell == "evil" and person.alignment > 349)
            if hit then
                local globed = person:has_effect(Effect.Major_Globe)
                if globed then
                    -- No damage for major globe
                    self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body flares as the maid's spell flows around it.</>")
                    person:send("<b:red>The shimmering globe around your body flares as the spell flows around it.</>")
                else
                    local damage = 210 + random(1, 20)
                    if person:has_effect(Effect.Sanctuary) then
                        damage = damage / 2
                    end
                    if person:has_effect(Effect.Stone) then
                        damage = damage / 2
                    end
                    -- Chance for critical hit
                    local variant = random(1, 20)
                    if variant == 1 then
                        damage = damage / 2
                    elseif variant == 20 then
                        damage = damage * 2
                    end
                    if spell == "good" then
                        self.room:send_except(person, "<b:white>" .. tostring(person.name) .. " cries out in anguish upon hearing the maid's blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<b:white>You cry out in anguish upon hearing the maid's blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                    else
                        self.room:send_except(person, "<blue>&9" .. tostring(person.name) .. " screams in torment upon hearing the maid's curse!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<blue>&9You scream in torment upon hearing the maid's curse!</> (<b:red>" .. tostring(damage) .. "</>)")
                    end
                    person:damage(damage)  -- type: physical
                end
            end
        end
        person = next_person
    end
end
wait(2)
globals.casting = nil