-- Trigger: The_Finale
-- Zone: 43, ID: 99
-- Type: WORLD, Flags: RANDOM
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--   Large script: 6176 chars
--
-- Original DG Script: #4399

-- Converted from DG Script #4399: The_Finale
-- Original: WORLD trigger, flags: RANDOM, probability: 100%
if get_people("4336") == 0 then
    return _return_value
else
    if get_people("4333") then
        local room = get_room("4333")
        if room:get_people("4399") then
            get_room(43, 33):at(function()
                find_player("leading-player"):teleport(get_room(11, 0))
            end)
        end
    end
    if self:get_people("4312") then
        local char = self:get_people("4312")
    else
        local char = self.people
    end
    self.room:send("The Fire Goddess shouts, 'Ladies and Gentlemen!  We present to you a spectacle never before seen on a public stage!  The only completely perfect act in our repertoire!'")
    get_room(43, 33):at(function()
        self.room:send("The Fire Goddess shouts, 'Ladies and Gentlemen!  We present to you a spectacle never before seen on a public stage!  The only completely perfect act in our repertoire!'")
    end)
    wait(4)
    self.room:send("A chorus of voices shouts out in response, 'THE FINALE!!'")
    get_room(43, 33):at(function()
        self.room:send("A chorus of voices shouts out in response, 'THE FINALE!!'")
    end)
    wait(5)
    self.room:send("Deep, stirring chords are struck on numerous instruments, resounding like a death knell in the box.")
    get_room(43, 33):at(function()
        self.room:send("Instruments strum to life all around.")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("Deep, stirring chords break loose from the darkness, haunting the stage.")
    end)
    self.room:send("Voices starting to sing outside the box, faintly in the distance.")
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("Ghostly voices float through theater, singing and whispering unintelligibly.")
    end)
    wait(7)
    self.room:send("A single, strong male voice sounds out in the darkness, calling out your name, inviting you to dance.")
    get_room(43, 33):at(function()
        self.room:send("From the darkness of the fire box emerges the Leading Player in all his glory, inviting you to dance.")
    end)
    get_room(43, 33):at(function()
        self.room:send("The Leading Player stalks the room with his eyes, crooning, '" .. tostring(char.name) .. ", think about the sun.'")
    end)
    wait(6)
    get_room(43, 33):at(function()
        self.room:send("Pointing to the rafters, the Leading Player screams, 'Let's give this angel some more light!!'")
    end)
    get_room(43, 33):at(function()
        self.room:send("Oppressively bright light bursts down from the enormous sun on the theater ceiling.")
    end)
    wait(6)
    self.room:send("A powerful, driving chord strikes and strikes hard!")
    get_room(43, 33):at(function()
        self.room:send("A powerful, driving chord strikes and strikes hard!")
    end)
    wait(2)
    self.room:send("The music starts to blast a new, driving beat.")
    get_room(43, 33):at(function()
        self.room:send("The music starts to blast a new, driving beat.")
    end)
    wait(5)
    self.room:send("The rhythm starts to pick up, pounding faster and faster, drawing you into the melody, begging your body to dance.")
    get_room(43, 33):at(function()
        self.room:send("The players emerge from all around, moving to the now pounding rhythm.")
    end)
    get_room(43, 33):at(function()
        self.room:send("You find yourself swept up into the dance, unable to resist the music.")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("The players swirl about you, tumbling together into a giant clump.")
    end)
    wait(5)
    self.room:send("Suddenly, the box begins to get hotter and hotter, the inside starting to smoke.")
    get_room(43, 33):at(function()
        self.room:send("Moving into a circle around the stage, the players sing, 'When the power and the glory are there at your command!'")
    end)
    wait(3)
    get_room(43, 33):at(function()
        self.room:send("They wave their rings at the fire box as the Fire Goddess heats the box with her touch.")
    end)
    wait(6)
    self.room:send("Lights explode through the walls of the box, sparking the wood and lighting the box on fire!")
    get_room(43, 33):at(function()
        self.room:send("Glowing with an inner fire as they dance, the players call out, '" .. tostring(char.name) .. "!!'")
    end)
    wait(6)
    self.room:send("<blue>Br<b:yellow>i</><blue>ll<b:yellow>ia</><blue>nt</> flash charges go off all around, exploding in a barrage of colors!")
    get_room(43, 33):at(function()
        self.room:send("<blue>Br<b:yellow>i</><blue>ll<b:yellow>ia</><blue>nt</> flash charges go off all around, exploding in a barrage of colors!")
    end)
    wait(4)
    get_room(43, 33):at(function()
        self.room:send("The players belt out in unison 'THINK ABOUT THE SUN!!'")
    end)
    wait(10)
    self.room:send("A voice cackles from the stage as the box <red>E<b:yellow>X<b:red>P</><red>L<red>O<b:yellow>D<red>E</><red>S</> into flames!!!!")
    get_room(43, 33):at(function()
        self.room:send("The Leading Player cackles as the box <red>E<b:yellow>X<b:red>P</><red>L<red>O<b:yellow>D<red>E</><red>S</> into flames!!!")
    end)
    local person = self.people
    while person do
        if person.id ~= -1 then
            person:damage(1000)  -- type: physical
        else
            person:damage(200)  -- type: physical
        end
        local person = person.next_in_room
    end
    wait(2)
    self.room:teleport_all(get_room(43, 33))
    get_room(43, 33):at(function()
        world.destroy(self.room:find_actor("box"))
    end)
    get_room(43, 33):at(function()
        self.room:spawn_object(43, 22)
    end)
    get_room(43, 36):exit("down"):set_state({hidden = false})
    wait(2)
    get_room(43, 36):exit("down"):set_state({hidden = true})
    if get_people("1100") then
        local room = get_room("1100")
        if room:get_people("4399") then
            get_room(11, 0):at(function()
                find_player("leading-player"):teleport(get_room(43, 33))
            end)
        end
    end
end