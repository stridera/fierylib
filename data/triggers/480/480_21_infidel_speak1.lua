-- Trigger: infidel_speak1
-- Zone: 480, ID: 21
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48021

-- Converted from DG Script #48021: infidel_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0%
-- Note: original DG probability was 0%; the trigger fires only on the exact
-- challenge phrase and is intentionally not gated by random chance.

-- Speech keywords: full phrase "the prince wishes to challenge you by proxy"
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "the prince wishes to challenge you by proxy", 1, true) then
    return true  -- No matching keywords
end
self:command("rofl")
self:say("I beat him once already.")
if actor.level > 70 then
    self:say("Hmm, you look like you might give me a reasonable battle.")
    self:say("Well...let me even the odds a a little.")
else
    self:say("HAH!  His honor depends on you?!")
    self:say("However, this should put the result beyond doubt.")
end
self:command("rem scimitar")
wait(3)
self:emote("waves his hands in the air in a mystical gesture.")
self:emote("murmurs a spell and suddenly looks younger!")
get_room(480, 84):at(function()
    self.room:spawn_mobile(480, 26)
end)
wait(1)
self:say("Prepare to meet whichever god you believe in!")
get_room(480, 84):at(function()
    self:command("give polished-scimitar infidel-warrior-youthful")
end)
get_room(480, 84):at(function()
    self.room:find_actor("infidel-warrior-youthful"):command("wield scimitar")
end)
self.room:find_actor("infidel-warrior-youthful"):teleport(get_room(480, 38))
self.room:find_actor("infidel-warrior-youthful"):command("kill " .. tostring(actor.name))
self:teleport(get_room(480, 84))
self:destroy_item("all")
world.destroy(self)