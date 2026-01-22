-- Trigger: phoenix_lives_again
-- Zone: 510, ID: 15
-- Type: WORLD, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #51015

-- Converted from DG Script #51015: phoenix_lives_again
-- Original: WORLD trigger, flags: SPEECH, probability: 100%

-- Speech keywords: p PHOENIX IS TOAST
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "p") or string.find(string.lower(speech), "phoenix") or string.find(string.lower(speech), "is") or string.find(string.lower(speech), "toast")) then
    return true  -- No matching keywords
end
-- We purge phoenix a lot here. This is to ensure that the phoenix's
-- corpse goes away. Don't want to "purge corpse" because there might
-- be a player corpse. Purge multiple times on the random off
-- chance that there might be a phoenix key or something on the ground.
get_room(510, 79):at(function()
    world.destroy(self.room:find_actor("phoenix"))
end)
get_room(510, 79):at(function()
    world.destroy(self.room:find_actor("phoenix"))
end)
get_room(510, 79):at(function()
    world.destroy(self.room:find_actor("phoenix"))
end)
get_room(510, 79):at(function()
    world.destroy(self.room:find_actor("phoenix"))
end)
get_room(510, 79):at(function()
    world.destroy(self.room:find_actor("phoenix"))
end)
get_room(510, 79):at(function()
    self.room:send("The heat of the combustion scorches everything!")
end)
wait(2)
get_room(510, 79):at(function()
    self.room:send("The phoenix rises again from the ashes!")
end)
get_room(510, 79):at(function()
    self.room:spawn_mobile(510, 26)
end)
get_room(510, 79):at(function()
    self.room:find_actor("phoenix"):command("whistle")
end)