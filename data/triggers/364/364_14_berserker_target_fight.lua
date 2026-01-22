-- Trigger: berserker_target_fight
-- Zone: 364, ID: 14
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #36414

-- Converted from DG Script #36414: berserker_target_fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
local room = self.room
local person = room.people
while person do
    if person:get_quest_stage("berserker_subclass") == 4 then
        if person.group_size ~= 0 and person:get_quest_var("berserker_subclass:target") == self.id then
            wait(2)
            person:send("<b:red>You must hunt this creature alone!  No groups allowed!</>")
            local zone = ((self.id / 100) - 1)
            -- switch on zone
            if zone == 160 then
                person:send(tostring(self.name) .. " whips you with her tail and sends you flying into a sandstorm!")
                self.room:send_except(person, tostring(self.name) .. " whips " .. tostring(person.name) .. " with her tail and sends " .. tostring(himher) .. " flying into a sandstorm!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                local random = random(1, 86)
            elseif zone == 162 then
                person:send(tostring(self.name) .. " howls and sends you fleeing in terror!")
                self.room:send_except(person, tostring(self.name) .. " howls and sends " .. tostring(person.name) .. " fleeing in terror!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                local random = random(1, 81)
            elseif zone == 202 then
                person:send(tostring(self.name) .. " roars and hurdles you into the blinding heat!")
                self.room:send_except(person, tostring(self.name) .. " roars and hurdles " .. tostring(person.name) .. " into the blinding heat!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                local random = random(1, 79)
            elseif zone == 551 then
            else
                person:send(tostring(self.name) .. " roars and hurdles you into the blinding snow!")
                self.room:send_except(person, tostring(self.name) .. " roars and hurdles " .. tostring(person.name) .. " into the blinding snow!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                local random = random(1, 100)
                local zone = 554
            end
            local place = ((zone * 100) + 99 + random)
            person:teleport(get_room(vnum_to_zone(place), vnum_to_local(place)))
            -- person looks around
        end
    end
    local person = person.next_in_room
end