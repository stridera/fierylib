-- Trigger: Gothra_Old_Man_rece
-- Zone: 161, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #16101
--
-- When the player gives the lost bracelet to the old man, he rewards them by
-- handing over a lever (object 161/4) and starts the desert_quest for every
-- group member present in the room.

-- TODO: confirm bracelet identity; legacy used vnum 2023 (zone 20, local 23?).
if object.id == 2023 then
    wait(1)
    self:destroy_item("bracelet")
    self:shout("Woo Hoo!")
    self:say("YES!")
    self:command("thanks " .. tostring(actor.name))
    self:say("I may actually get out of the dog house now!")
    self:command("grin me")
    wait(3)
    self:command("eye " .. tostring(actor.name))
    self:say("Hey, if you are resourceful enough to find this, then maybe you are up for some adventure!")
    self:command("grin")
    self.room:spawn_object(161, 4)
    self:command("give lever " .. tostring(actor.name))
    self:say("Good luck...")

    -- Start desert_quest for the actor and any grouped members in the room.
    local size = actor.group_size or 0
    if size > 0 then
        for i = 1, size do
            local person = actor.group_member[i]
            if person and person.room == self.room then
                if not person:get_quest_stage("desert_quest") then
                    person:start_quest("desert_quest")
                end
                person:set_quest_var("desert_quest", "lever", 1)
            end
        end
    else
        if not actor:get_quest_stage("desert_quest") then
            actor:start_quest("desert_quest")
        end
        actor:set_quest_var("desert_quest", "lever", 1)
    end
end