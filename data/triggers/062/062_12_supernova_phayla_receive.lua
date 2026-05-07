-- Trigger: supernova_phayla_receive
-- Zone: 62, ID: 12
-- Type: MOB, Flags: RECEIVE
--
-- Phayla accepts the miniature sun (510, 73) and Phayla's lamp (489, 17) as
-- payment for teaching Supernova. Tracks each item via quest_var keys so the
-- player can hand them in across sessions; once both are received she runs
-- the teaching cinematic, sets the supernova skill to 100, and completes the
-- quest.
--
-- Original DG Script: #6212

-- TODO(parity): legacy used `skills.set_level(actor.name, "supernova", 100)`.
-- Confirm the runtime API (likely `actor:set_skill_level("supernova", 100)`)
-- and migrate; left as-is to preserve original behavior.

local function payment_key(obj)
    return tostring(obj.zone_id) .. "_" .. tostring(obj.local_id)
end

local is_sun = (object.zone_id == 510 and object.local_id == 73)
local is_lamp = (object.zone_id == 489 and object.local_id == 17)

if is_sun or is_lamp then
    if actor:get_quest_var("supernova:" .. payment_key(object)) == 1 then
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        self:say("You've already given me this.")
    else
        actor:set_quest_var("supernova", payment_key(object), 1)
        wait(2)
        self:command("nod")
        world.destroy(object)
        if actor:get_quest_var("supernova:510_73") == 1 and actor:get_quest_var("supernova:489_17") == 1 then
            self:say("Alright, get comfortable.  This may take a while.")
            wait(3)
            self.room:send(tostring(self.name) .. " demonstrates some of the basics.")
            actor:send("You take notes and try to follow along.")
            wait(5)
            self:say("No, the diagrams need to look like this...")
            self.room:send_except(actor, tostring(self.name) .. " makes changes to " .. tostring(actor.name) .. "'s notes.")
            actor:send(tostring(self.name) .. " makes changes to your notes.")
            wait(5)
            self:say("Yes, that's good.  Move your hands like this.")
            self.room:send(tostring(self.name) .. " waves her hands about.")
            wait(5)
            self:say("Yes, that's much closer.")
            actor:send("You feel you're starting to get the hang of it!")
            self.room:send_except(actor, "It seems " .. tostring(actor.name) .. " is starting to get the hang of it!")
            wait(9)
            actor:send("You have a breakthrough!")
            self.room:send_except(actor, tostring(actor.name) .. " has a breakthrough!")
            wait(1)
            self:say("That's it!!  You've got it!")
            self.room:send_except(actor, tostring(actor.name) .. " radiates with inner arcane fire!")
            actor:send("<b:red>You have mastered Supernova!</>")
            skills.set_level(actor.name, "supernova", 100)
            actor:complete_quest("supernova")
        else
            self:say("And the other?")
        end
    end
else
    self:say("This isn't acceptable payment.")
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
end
return true