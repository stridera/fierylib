-- Trigger: phase wand command imbue
-- Zone: 3, ID: 9
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 18 if statements
--   Large script: 8393 chars
--
-- Original DG Script: #309

-- Converted from DG Script #309: phase wand command imbue
-- Original: OBJECT trigger, flags: COMMAND, probability: 3%

-- 3% chance to trigger
if not percent_chance(3) then
    return true
end

-- Command filter: imbue
if not (cmd == "imbue") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "i" or cmd == "im" then
    _return_value = false
    return _return_value
end
-- switch on self.id
if self.id == 303 then
    local type = "air"
    local area = "howling winds"
elseif self.id == 313 then
    local type = "fire"
    local area = "sweltering tunnels"
elseif self.id == 323 then
    local type = "ice"
    local area = "vast ocean"
elseif self.id == 333 then
    local type = "acid"
    local area = "murky swamp"
elseif self.id == 306 then
    local type = "air"
    local place = 49007
    local ward = 53454
    local wardname = "ward-mist"
    local nextname = "staff-gales"
    local crafted = 8515
elseif self.id == 316 then
    local type = "fire"
    local place = 5272
    local ward = 53456
    local wardname = "ward-flames"
    local nextname = "staff-infernos"
    local crafter = 48250
elseif self.id == 326 then
    local type = "ice"
    local place = 55105
    local ward = 53457
    local wardname = "ward-ice"
    local nextname = "staff-blizzards"
    local crafter = 10300
elseif self.id == 336 then
    local type = "acid"
    local place = 16355
    local ward = 53453
    local wardname = "ward-plants"
    local nextname = "staff-tremors"
    local crafter = 48029
elseif self.id == 308 then
    local type = "air"
    local place = 48862
    local color = "&3&b"
    local nextname = "staff-maelstrom"
elseif self.id == 318 then
    local type = "fire"
    local place = 47800
    local color = "&1&b"
    local nextname = "staff-glorious-flame"
elseif self.id == 328 then
    local type = "ice"
    local place = 47708
    local color = "&6&b"
    local nextname = "staff-frozen-deep"
elseif self.id == 338 then
    local type = "acid"
    local place = 47672
    local color = "&2&b"
    local nextname = "staff-disintegration"
end
-- switch on self.id
if self.id == 306 or self.id == 308 or self.id == 316 or self.id == 318 or self.id == 326 or self.id == 328 or self.id == 336 or self.id == 338 then
    local weapon = "staff"
else
    local weapon = "wand"
end
if actor.room == "place" then
    if not actor.quest_variable[type_wand .. ":wandtask1"] then
        local counter = 50
        local remaining = ((actor.quest_stage[type_wand] - 1) * counter) - actor.quest_variable[type_wand .. ":attack_counter"]
        actor:send("You need to attack " .. tostring(remaining) .. " more times to fully bond with your " .. tostring(weapon) .. "!")
        return _return_value
    else
        if self.id == 306 or self.id == 316 or self.id == 326 or self.id == 336 then
            if actor.quest_variable[type_wand .. ":wandtask5"] then
                if actor.inventory[ward] then
                    actor:send("You raise " .. tostring(self.shortdesc) .. " and " .. "%get.obj_shortdesc[%ward%]% above your head.")
                    wait(1)
                    actor:send("The energies of this place start to flow through you!")
                    wait(3)
                    actor:command("drop " .. tostring(wardname))
                    world.destroy(wardname)
                    actor:send("%get.obj_shortdesc[%ward%]% floats into the air and unravels into wispy tendrils of elemental energy!")
                    wait(2)
                    actor:send("The energies wrap around " .. tostring(self.shortdesc) .. ".")
                    wait(3)
                    actor:send(tostring(self.shortdesc) .. " is transformed!")
                    local reward = "yes"
                    actor:advance_quest("%type%_wand")
                    actor:set_quest_var("%type%_wand", "greet", 0)
                    actor:set_quest_var("%type%_wand", "attack_counter", 0)
                    local number = 1
                    while number <= 5 do
                        actor:set_quest_var("%type%_wand", "wandtask%number%", 0)
                        local number = number + 1
                    end
                else
                    actor:send("You don't have " .. "%get.obj_shortdesc[%ward%]% with you!")
                end
            else
                actor:send("<b:blue>" .. tostring(self.shortdesc) .. " must be primed by " .. "%get.mob_shortdesc[%crafter%]% before you can imbue it!</>")
            end
        elseif self.id == 308 or self.id == 318 or self.id == 328 or self.id == 338 then
            if actor.quest_variable[type_wand .. ":wandtask4"] then
                actor:send("You close your eyes and hold " .. tostring(self.shortdesc) .. " before you.")
                wait(2)
                actor:send("You feel the wheel of the cosmos rotating around you here in this place.")
                wait(3)
                actor:send("You begin to draw from the vast elemental energies of the plane...")
                wait(3)
                actor:send("Drawing all the raw primordial power you can muster, you suffuse the very essence of the realm into your staff!")
                actor:send(tostring(color) .. "You have perfected your staff!</>")
                actor:complete_quest("%type%_wand")
                local reward = "yes"
            end
        end
    end
elseif self.id == 303 then
    if actor.room >= 55001 and actor.room <= 55003 and actor.quest_variable[type_wand .. ":greet"] == 1 then
        local continue = "yes"
    else
        _return_value = false
    end
elseif self.id == 313 then
    if actor.room >= 5200 and actor.room <= 5299 and actor.quest_variable[type_wand .. ":greet"] == 1 then
        local continue = "yes"
    else
        _return_value = false
    end
elseif self.id == 323 then
    if actor.room >= 39001 and actor.room <= 39189 and actor.quest_variable[type_wand .. ":greet"] == 1 then
        local continue = "yes"
    else
        _return_value = false
    end
elseif self.id == 333 then
    if actor.room >= 7300 and actor.room <= 7457 and actor.quest_variable[type_wand .. ":greet"] == 1 then
        local continue = "yes"
    else
        _return_value = false
    end
else
    _return_value = false
end
if continue == "yes" then
    actor:send("You imbue your wand with the energy of the " .. tostring(area) .. "!")
    actor:set_quest_var("%type%_wand", "wandtask4", 1)
elseif reward == "yes" then
    local nextstaff = self.id + 1
    -- self.id is already local, so nextstaff is local_id + 1; zone comes from self
    self.room:spawn_object(self.zone_id, nextstaff)
    actor:command("get " .. tostring(nextname))
    local expcap = self.level
    local expmod = 0
    if expcap < 9 then
        local expmod = (((expcap * expcap) + expcap) / 2) * 55
    elseif expcap < 17 then
        local expmod = 440 + ((expcap - 8) * 125)
    elseif expcap < 25 then
        local expmod = 1440 + ((expcap - 16) * 175)
    elseif expcap < 34 then
        local expmod = 2840 + ((expcap - 24) * 225)
    elseif expcap < 49 then
        local expmod = 4640 + ((expcap - 32) * 250)
    elseif expcap < 90 then
        local expmod = 8640 + ((expcap - 48) * 300)
    else
        local expmod = 20940 + ((expcap - 89) * 600)
    end
    -- Adjust exp award by class so all classes receive the same proportionate amount
    -- switch on person.class
    if person.class == "Warrior" or person.class == "Berserker" then
        -- 110% of standard
        local expmod = (expmod + (expmod / 10))
    elseif person.class == "Paladin" or person.class == "Anti-Paladin" or person.class == "Ranger" then
        -- 115% of standard
        local expmod = (expmod + ((expmod * 2) / 15))
    elseif person.class == "Sorcerer" or person.class == "Pyromancer" or person.class == "Cryomancer" or person.class == "Illusionist" or person.class == "Bard" then
        -- 120% of standard
        local expmod = (expmod + (expmod / 5))
    elseif person.class == "Necromancer" or person.class == "Monk" then
        -- 130% of standard
        local expmod = (expmod + (expmod * 2) / 5)
    else
        local expmod = expmod
    end
    actor:send("<b:yellow>You gain experience!</>")
    local setexp = (expmod * 10)
    local loop = 0
    while loop < 5 do
        actor:award_exp(setexp)
        local loop = loop + 1
    end
    world.destroy(self)
else
    _return_value = false
end
return _return_value