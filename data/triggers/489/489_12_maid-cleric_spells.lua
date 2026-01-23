-- Trigger: maid-cleric spells
-- Zone: 489, ID: 12
-- Type: WORLD, Flags: GLOBAL
-- Status: NEEDS_REVIEW
--   Complex nesting: 26 if statements
--   Large script: 6316 chars
--
-- Original DG Script: #48912

-- Converted from DG Script #48912: maid-cleric spells
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Clear stop-casting message
if stop_casting then
    stop_casting = nil  -- extra value ignored
end
if not casting then
    local casting = 1
    globals.casting = globals.casting or true
    local heal_chance = random(1, 10)
    if (healing and (heal_chance > 2)) or (heal_chance == 10) then
        self.room:send("A maid in waiting starts casting <b:yellow>'group heal'</>...")
        wait(5)
        if stop_casting then
            -- Stop casting if we've been passed a stop-casting message
            stop_casting = nil
            casting = nil
            return _return_value
        end
        self.room:send("A maid in waiting completes her spell...")
        self.room:send("A maid in waiting utters the words, 'craes poir'.")
        local actor = room.actors[random(1, #room.actors)]
        if actor then
            -- Check to see if Lokari and his three maids exist, and heal each of them
            if world.count_mobiles("48901") > 0 then
                self.room:find_actor("lokari"):heal(450)
            end
            if world.count_mobiles("48915") > 0 then
                self.room:find_actor("maid-rogue"):heal(450)
            end
            if world.count_mobiles("48922") > 0 then
                self.room:find_actor("maid-sorcerer"):heal(450)
            end
            if world.count_mobiles("48923") > 0 then
                self.room:find_actor("maid-cleric"):heal(450)
            end
        end
    else
        -- Alternate between good and evil spells
        if spell == "good" then
            local spell = "evil"
        else
            local spell = "good"
        end
        globals.spell = globals.spell or true
        if spell == "good" then
            self.room:send("A maid in waiting starts casting <b:yellow>'consecration'</>...")
        else
            self.room:send("A maid in waiting starts casting <b:yellow>'sacrilege'</>...")
        end
        wait(2)
        if stop_casting then
            -- Stop casting if we've been passed a stop-casting message
            stop_casting = nil
            casting = nil
            return _return_value
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
            local next = person.next_in_room
            if ((person.id < 48900) or (person.id > 48999)) and (person.level < 100) then
                if (spell == "good") and (person.alignment < -349) then
                    local globed = person:has_effect(Effect.Major_Globe)
                    if globed then
                        -- No damage for major globe
                        self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body flares as the maid's spell flows around it.</>")
                        person:send("<b:red>The shimmering globe around your body flares as the spell flows around it.</>")
                    else
                        local damage = 210 + random(1, 20)
                        if person:has_effect(Effect.Sanctuary) then
                            local damage = damage / 2
                        end
                        if person:has_effect(Effect.Stone) then
                            local damage = damage / 2
                        end
                        -- Chance for critical hit
                        local variant = random(1, 20)
                        if variant == 1 then
                            local damage = damage / 2
                        elseif variant == 20 then
                            local damage = damage * 2
                        end
                        self.room:send_except(person, "<b:white>" .. tostring(person.name) .. " cries out in anguish upon hearing the maid's blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<b:white>You cry out in anguish upon hearing the maid's blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                        local damage_dealt = person:damage(damage)  -- type: physical
                    end
                elseif (spell == "evil") and (person.alignment > 349) then
                    if string.find(person.flags, "MAJOR_GLOBE") then
                        -- No damage for major globe
                        self.room:send_except(person, "<b:red>The shimmering globe around " .. tostring(person.name) .. "'s body flares as the maid's spell flows around it.</>")
                        person:send("<b:red>The shimmering globe around your body flares as the spell flows around it.</>")
                    else
                        local damage = 210 + random(1, 20)
                        if person:has_effect(Effect.Sanctuary) then
                            local damage = damage / 2
                        end
                        if person:has_effect(Effect.Stone) then
                            local damage = damage / 2
                        end
                        -- Chance for critical hit
                        local variant = random(1, 20)
                        if variant == 1 then
                            local damage = damage / 2
                        elseif variant == 20 then
                            local damage = damage * 2
                        end
                        self.room:send_except(person, "<blue>&9" .. tostring(person.name) .. " screams in torment upon hearing the maid's curse!</> (<blue>" .. tostring(damage) .. "</>)")
                        person:send("<blue>&9You scream in torment upon hearing the maid's curse!</> (<b:red>" .. tostring(damage) .. "</>)")
                        local damage_dealt = person:damage(damage)  -- type: physical
                    end
                end
            end
            local person = next
        end
    end
    wait(2)
    casting = nil
end