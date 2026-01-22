-- Trigger: creeping_doom_logging_camp_drop
-- Zone: 615, ID: 55
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #61555

-- Converted from DG Script #61555: creeping_doom_logging_camp_drop
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 61518 then
    wait(1)
    world.destroy(object)
    if actor:get_quest_stage("creeping_doom") == 4 then
        actor.name:advance_quest("creeping_doom")
    end
    self.room:send("&9<blue>" .. tostring(world.get_obj_shortdesc(61518)) .. " bursts open in a flood of insects!</>")
    wait(2)
    zone.echo(87, "<blue>&9An endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 pours through the camp consuming everything in sight!</>")
    wait(1)
    zone.echo(87, "<blue>&9Screams pierce the quiet of the camp as everything is swallowed by a blanket of death!</>")
    local number = 8703
    while number < 8760 do
        local area = get.room[number]
        local person = area.people
        while person do
            if person.id ~= -1 and person.id ~= 8708 and person.id ~= 8710 and person.id ~= 8711 and person.id ~= 8714 then
                get_room(vnum_to_zone(area), vnum_to_local(area)):at(function()
                    person:damage(5000)  -- type: physical
                end)
                get_room(vnum_to_zone(area), vnum_to_local(area)):at(function()
                    self.room:send("<blue>&9An endless wave of crawling </><red>arachnoids<blue>&9 and </><green>insects<blue>&9 consumes " .. tostring(person.name) .. "!</>")
                end)
                zone.echo(87, "Someone screams as he is consumed by an endless wave of crawling <red>arachnoids</> and <green>insects</>!")
            end
            local person = person.next_in_room
        end
        wait(2)
        local number = number + 1
        zone.echo(87, "<blue>&9Eerie silence falls over the camp as the deluge of death subsides...<blue>&9")
    end
end  -- auto-close block