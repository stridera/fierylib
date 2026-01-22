-- Trigger: Ill-subclass: Flowers make people sneeze
-- Zone: 172, ID: 18
-- Type: WORLD, Flags: PREENTRY
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #17218

-- Converted from DG Script #17218: Ill-subclass: Flowers make people sneeze
-- Original: WORLD trigger, flags: PREENTRY, probability: 5%

-- 5% chance to trigger
if not percent_chance(5) then
    return true
end
if string.find(actor.class, "Illusionist") then
    wait(1)
else
    wait(2)
    local num = random(1, 6)
    -- switch on num
    if num == 1 then
        actor:command("sneeze")
        wait(3)
        actor:command("sneeze")
    elseif num == 2 or num == 3 then
        actor:command("sneeze")
    elseif num == 4 then
        actor:command("emore blinks heavily, trying to clear the tears out of %actor.hisher% eyes.")
    elseif num == 5 then
        actor:send("Your nose feels all itchy.")
    else
        actor:emote("wipes " .. tostring(actor.hisher) .. " nose with " .. tostring(actor.hisher) .. " sleeve.")
    end
    -- See if any smugglers are nearby to witness
    local smuggler_here = 0
    local smuggler = 0
    local person = self.people
    while person do
        if person.id == 36300 then
            local smuggler_here = 1
            local smuggler = person
        elseif person.id == 36301 then
            local smuggler_here = 1
            local smuggler = person
        elseif person.id == 36303 then
            local smuggler_here = 1
            local smuggler = person
        elseif person.id == 36304 then
            local smuggler_here = 1
            local smuggler = person
        elseif person.id == 36306 then
            local smuggler_here = 1
            local smuggler = person
        end
        local person = person.next_in_room
    end
    if smuggler_here == 1 then
        local num = random(1, 5)
        -- switch on num
        if num == 1 then
            actor:send("You notice the smuggler paying close attention to you.")
        elseif num == 2 then
            smuggler:command("peer " .. tostring(actor.name))
        elseif num == 3 then
            smuggler:command("look " .. tostring(actor.name))
        elseif num == 4 then
            smuggler:emote("smiles sweetly.")
            wait(2)
            smuggler:emote("asks, 'Is everything alright?'")
        else
            smuggler:command("consider " .. tostring(actor.name))
        end
    end
end