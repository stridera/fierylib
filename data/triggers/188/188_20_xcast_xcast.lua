-- Trigger: xcast_xcast
-- Zone: 188, ID: 20
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--   Large script: 11992 chars
--
-- Original DG Script: #18820

-- Converted from DG Script #18820: xcast_xcast
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: xcast
if not (cmd == "xcast") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- 
-- X-cast
-- This trigger works with 18821, x-decide, to cast custom spells with various
-- effects.  It may only be used by mobiles in the 18820 to 18842 range,
-- Laoris' dragonquest mobiles.
-- 
-- Expected variables set by x-decide:
-- xid - unique integer identifier, like 1
-- xname - name of the spell, such as 'arctic blast'
-- xstars - duration to cast the spell, ie., 2
-- xmagic - magic words uttered at the end of the spell, like 'zimblo argis'
-- xeffect - actual effect of the spell, such as 'damage' or 'expel'
-- xmode - sets whether it's victim or self-only
-- xamount - only meaningful for some spell types, ie., 100
-- 
if (actor.id >= 18820) and (actor.id <= 18842) then
    _return_value = true
    -- Must use x-decide to select a spell first
    if not xname then
        actor:send("You have not chosen a spell to x-cast yet!")
        -- No x-casting damage on self, immortals, or people in other rooms
    elseif (xmode == "victim") and (arg.name == actor.name) then
        actor:send("You cannot x-cast at yourself.")
    elseif (xmode == "victim") and (arg.room ~= actor.room) then
        actor:send("You must be in the same room as " .. tostring(arg.name) .. "!")
    elseif (xmode == "victim") and (arg.level > 99) then
        actor:send("You cannot x-cast at immortals!")
    else
        if xmode ~= "victim" then
            local notarg = 1
        end
        -- Begin casting messages
        if xmode == "victim" then
            arg:send(tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</> at <b:red>You</>!!!...")
            self.room:send_except(arg, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
            actor:send("You start casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        elseif xmode == "self" then
            self.room:send_except(actor, tostring(actor.name) .. " starts casting <b:yellow>'" .. tostring(xname) .. "'</>...")
        end
        actor:send("You start chanting...")
        wait(2)
        -- Imitate casting stars
        local stars = xstars
        while stars > 0 do
            if notarg or (arg.room == actor.room) then
                actor:send(tostring(stars) .. " remaining on " .. tostring(xname))
                wait(2)
                local stars = stars - 1
            else
                local spell_stop = 1
                local stars = 0
            end
        end
        -- If player is still here, make with the magic
        if spell_stop ~= 1 then
            if notarg or (arg.room == actor.room) then
                if xmode == "victim" then
                    arg:send(tostring(actor.name) .. " stares at you and utters the words, '" .. tostring(xmagic) .. "'.")
                    self.room:send_except(arg, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                elseif xmode == "self" then
                    self.room:send_except(actor, tostring(actor.name) .. " closes " .. tostring(actor.possessive) .. " eyes and utters the words, '" .. tostring(xmagic) .. "'.")
                end
                actor:send("You complete your spell.")
                if xeffect == "damage" then
                    local damage = xamount + random(1, 50)
                end
                -- Show the message
                if xid == 1 then
                    self.room:send_except(actor, "<yellow>" .. tostring(actor.name) .. " lets out a <red>soul-rending<yellow> screech</>!")
                    actor:send("<yellow>You let out shattering screech!</>")
                elseif xid == 2 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " waves a taloned paw, bring down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                    actor:send("<b:white>You wave a taloned paw at the room, bringing down a </><cyan>bli<blue>zz</><cyan>ard<b:white> of snow!</>")
                elseif xid == 3 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " looks much healthier than before!</>")
                    actor:send("<b:white>You feel MUCH healthier than before!</>")
                elseif xid == 4 then
                    self.room:send_except(arg, tostring(actor.name) .. " waves a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                    actor:send("You wave a hand at " .. tostring(arg.name) .. ", whisking " .. tostring(arg.object) .. " away!")
                elseif xid == 5 then
                    self.room:send_except(actor, "<b:white>" .. tostring(actor.name) .. " speaks a holy word of sanctification!</>")
                    actor:send("<b:white>You speak a holy word of sanctification!</>")
                elseif xid == 6 then
                    arg:send("&9<blue>" .. tostring(actor.name) .. " chants an arcane word at you, locking you in an iron maiden!</>")
                    self.room:send_except(arg, "&9<blue>" .. tostring(actor.name) .. " chants an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                    actor:send("&9<blue>You chant an arcane word at " .. tostring(arg.name) .. ", locking " .. tostring(arg.object) .. " in an iron maiden!</>")
                elseif xid == 7 then
                    self.room:send_except(actor, "<blue>Lightning streaks out from " .. tostring(actor.name) .. "'s body, sizzling through the air.</>")
                    actor:send("<blue>Lightning streaks out from your body, crackling through the air.</>")
                elseif xid == 8 then
                    arg:send(tostring(actor.name) .. " screams a commination at you, causing runes to appear on your skin!  (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, "Runes appear on " .. tostring(arg.name) .. " as " .. tostring(actor.name) .. " screams an obloquy at " .. tostring(arg.object) .. "!  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You scream a curse at " .. tostring(arg.name) .. ", causing runes to appear on " .. tostring(arg.possessive) .. " skin! (<yellow>" .. tostring(damage) .. "</>)")
                elseif xid == 9 then
                    arg:send(tostring(actor.name) .. " flings a ball of caustic acid at you, burning your flesh. (<b:red>" .. tostring(damage) .. "</>)")
                    self.room:send_except(arg, tostring(actor.name) .. " flings a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(actor.possessive) .. " flesh.  (<blue>" .. tostring(damage) .. "</>)")
                    actor:send("You throw a ball of caustic acid at " .. tostring(arg.name) .. ", burning " .. tostring(arg.possessive) .. " flesh. (<yellow>" .. tostring(damage) .. "</>)")
                else
                    self.room:send_except(actor, "X-cast failure.  Nothing happens.")
                    actor:send("Unrecognized xid number.")
                end
                -- Do the deed
                if xeffect == "damage" then
                    local damage_dealt = arg:damage(damage)  -- type: physical
                elseif xeffect == "heal" then
                    actor:heal(xamount)
                end
                if xeffect == "transport" then
                    if xamount == -1 then
                        arg:send(tostring(actor.name) .. " waves a hand at you, whisking you away!")
                        local max_tries = 20
                        while max_tries > 0 do
                            arg:teleport(get_room(vnum_to_zone(random(1, 60000)), vnum_to_local(random(1, 60000))))
                            if arg.room ~= actor.room then
                                local max_tries = 0
                            end
                            local max_tries = max_tries - 1
                        end
                        if not max_tries then
                            arg:teleport(get_room(1000, 0))
                        end
                    else
                        arg:teleport(get_room(vnum_to_zone(xamount), vnum_to_local(xamount)))
                    end
                    arg:command("look")
                elseif xeffect == "area" then
                    local max_tries = 20
                    while max_tries > 0 do
                        local victim = room.actors[random(1, #room.actors)]
                        if victim then
                            if (victim.id ~= actor.id) and not (string.find(target_list, "Xvictim.nameX")) then
                                local target_list = target_listXvictim.nameX
                                local damage = xamount + random(1, 50)
                                if xid == 1 then
                                    victim:send("<yellow>The screech pierces into your head, causing great pain!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<yellow>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head in pain.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 2 then
                                    victim:send("<cyan>The sudden blizzard <b:white>chills</><cyan> you to the bone!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<cyan>" .. tostring(victim.name) .. " shivers and turns blue in the blizzard.</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif (xid == 5) and (victim.alignment <= -350) then
                                    victim:send("<b:white>You cry out in pain upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<b:white>" .. tostring(victim.name) .. " grasps " .. tostring(victim.possessive) .. " head upon hearing " .. tostring(actor.name) .. "'s blessing!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                elseif xid == 7 then
                                    victim:send("<blue>The lightning strikes you in the chest, shocking your body!</> (<b:red>" .. tostring(damage) .. "</>)")
                                    self.room:send_except(victim, "<blue>" .. tostring(victim.name) .. " reels back, struck in the chest by the lightning!</> (<blue>" .. tostring(damage) .. "</>)")
                                    local damage_dealt = victim:damage(damage)  -- type: physical
                                end
                            end
                        else
                            local max_tries = 0
                        end
                        local max_tries = max_tries - 1
                    end
                end
            else
                local spell_stop = 1
            end
        end
        -- If the player left somewhere along the way, fail spell
        if spell_stop == 1 then
            actor:send("You stop invoking abruptly!")
            self.room:send_except(actor, tostring(actor.name) .. " stops invoking abruptly!")
        end
    end
else
    -- Do nothing for non-dragonquest mobs
    _return_value = false
end
return _return_value