-- Trigger: Ill-subclass: Flowers make people sneeze
-- Zone: 172, ID: 18
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- 5% chance on entering the room: anyone who isn't an illusionist gets a
-- random sneeze/itch reaction from the flowers. If a smuggler (zone 363
-- mobs 0/1/3/4/6) is also in the room, they may notice and react with
-- suspicion - this is the in-fiction reason illusionists who don't keep
-- their disguise watertight get ratted out.
--
-- Original DG Script: #17218

if not percent_chance(5) then
    return true
end
if string.find(actor.class, "Illusionist") then
    return true  -- subclass already complete; flowers no longer affect them
end

wait(2)
local num = random(1, 6)
if num == 1 then
    actor:command("sneeze")
    wait(3)
    actor:command("sneeze")
elseif num == 2 or num == 3 then
    actor:command("sneeze")
elseif num == 4 then
    actor:emote("blinks heavily, trying to clear the tears out of " .. actor.hisher .. " eyes.")
elseif num == 5 then
    actor:send("Your nose feels all itchy.")
else
    actor:emote("wipes " .. actor.hisher .. " nose with " .. actor.hisher .. " sleeve.")
end

-- See if any smuggler is nearby to witness the un-Cestia-like sneezing.
local smuggler = nil
local person = self.people
while person do
    if person.zone_id == 363 then
        local lid = person.local_id
        if lid == 0 or lid == 1 or lid == 3 or lid == 4 or lid == 6 then
            smuggler = person
            break
        end
    end
    person = person.next_in_room
end

if smuggler then
    local reaction = random(1, 5)
    if reaction == 1 then
        actor:send("You notice the smuggler paying close attention to you.")
    elseif reaction == 2 then
        smuggler:command("peer " .. tostring(actor.name))
    elseif reaction == 3 then
        smuggler:command("look " .. tostring(actor.name))
    elseif reaction == 4 then
        smuggler:emote("smiles sweetly.")
        wait(2)
        smuggler:emote("asks, 'Is everything alright?'")
    else
        smuggler:command("consider " .. tostring(actor.name))
    end
end