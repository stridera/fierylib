-- Trigger: creeping_doom_logging_camp_drop
-- Zone: 615, ID: 55
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- TODO(parity): The original DG iterated rooms 8703..8759 (zone 87,
-- local 3..59) and killed every NPC except 8708/8710/8711/8714. Until
-- get_room(z, l) consistently exposes a room actor list, this loop
-- visits every candidate room one at a time and walks its actors via
-- :find_actor / :actor_count. Excluded mobs (zone 87) are listed as
-- their (zone, local_id) pairs.
--
-- Original DG Script: #61555

-- Converted from DG Script #61555: creeping_doom_logging_camp_drop
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.zone_id == 615 and object.local_id == 18 then
    wait(1)
    world.destroy(object)
    if actor:get_quest_stage("creeping_doom") == 4 then
        actor:advance_quest("creeping_doom")
    end
    self.room:send("&9<blue>The " .. tostring(objects.template(615, 18).name) .. " bursts open in a flood of insects!</>")
    wait(2)
    zone.echo(87, "<blue>&9An endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 pours through the camp consuming everything in sight!</>")
    wait(1)
    zone.echo(87, "<blue>&9Screams pierce the quiet of the camp as everything is swallowed by a blanket of death!</>")

    -- Spared NPCs in the camp (zone 87 mob locals).
    local spare = { [8] = true, [10] = true, [11] = true, [14] = true }
    for local_id = 3, 59 do
        local r = get_room(87, local_id)
        if r and r.actors then
            for _, person in ipairs(r.actors) do
                if person.is_npc and not spare[person.local_id] then
                    r:at(function()
                        person:damage(5000)
                        r:send("<blue>&9An endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 consumes " .. tostring(person.name) .. "!</>")
                    end)
                    zone.echo(87, "Someone screams as he is consumed by an endless wave of crawling <red>arachnoids</> and <green>insects</>!")
                end
            end
        end
        wait(2)
    end
    zone.echo(87, "<blue>&9Eerie silence falls over the camp as the deluge of death subsides...</>")
end