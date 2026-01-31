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
            -- self.zone_id is the mob's zone; destination zone is typically one less
            local dest_zone = self.zone_id - 1
            local rand_offset = 0
            -- switch on dest_zone
            if dest_zone == 160 then
                person:send(tostring(self.name) .. " whips you with her tail and sends you flying into a sandstorm!")
                self.room:send_except(person, tostring(self.name) .. " whips " .. tostring(person.name) .. " with her tail and sends " .. tostring(himher) .. " flying into a sandstorm!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                rand_offset = random(1, 86)
            elseif dest_zone == 162 then
                person:send(tostring(self.name) .. " howls and sends you fleeing in terror!")
                self.room:send_except(person, tostring(self.name) .. " howls and sends " .. tostring(person.name) .. " fleeing in terror!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                rand_offset = random(1, 81)
            elseif dest_zone == 202 then
                person:send(tostring(self.name) .. " roars and hurdles you into the blinding heat!")
                self.room:send_except(person, tostring(self.name) .. " roars and hurdles " .. tostring(person.name) .. " into the blinding heat!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                rand_offset = random(1, 79)
            elseif dest_zone == 551 then
                -- Fall through to else
                person:send(tostring(self.name) .. " roars and hurdles you into the blinding snow!")
                self.room:send_except(person, tostring(self.name) .. " roars and hurdles " .. tostring(person.name) .. " into the blinding snow!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                rand_offset = random(1, 100)
                dest_zone = 554
            else
                person:send(tostring(self.name) .. " roars and hurdles you into the blinding snow!")
                self.room:send_except(person, tostring(self.name) .. " roars and hurdles " .. tostring(person.name) .. " into the blinding snow!")
                self.room:send_except(person, tostring(person.name) .. " is gone!")
                rand_offset = random(1, 100)
                dest_zone = 554
            end
            -- place was (zone * 100) + 99 + random, which equals zone (zone), local (99 + random)
            local dest_local = 99 + rand_offset
            person:teleport(get_room(dest_zone, dest_local))
            -- person looks around
        end
    end
    local person = person.next_in_room
end