-- Trigger: infidel2_random
-- Zone: 480, ID: 27
-- Type: MOB, Flags: GLOBAL, RANDOM
-- Status: CLEAN
--
-- Original DG Script: #48027

-- Converted from DG Script #48027: infidel2_random
-- Original: MOB trigger, flags: GLOBAL, RANDOM, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
local now = time.stamp
if now - 1 > fight then
    self:emote("looks around for someone to fight.")
    self:command("sniff")
    self:command("remove scimitar")
    self:emote("waves his hands in the air in a mystical manner.")
    wait(1)
    self.room:send("The body of the infidel ages rapidly to return to the decayed state.")
    get_room(480, 84):at(function()
        self.room:spawn_mobile(480, 25)
    end)
    get_room(480, 84):at(function()
        self:command("give polished-scimitar infidel-warrior-necrotic")
    end)
    get_room(480, 84):at(function()
        self.room:find_actor("infidel-warrior-necrotic"):command("wield scimitar")
    end)
    get_room(480, 84):at(function()
        self.room:find_actor("infidel-warrior-necrotic"):teleport(get_room(480, 38))
    end)
    self.room:find_actor("infidel-warrior-necrotic"):command("groan")
    self.room:find_actor("infidel-warrior-necrotic"):say("I hate this form.")
    self:teleport(get_room(480, 84))
    self:destroy_item("all")
    world.destroy(self)
end