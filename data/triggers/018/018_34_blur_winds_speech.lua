-- Trigger: blur_winds_speech
-- Zone: 18, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #1834
-- TODO(parity): legacy 5-digit room vnums for the four wind home rooms
-- (30262, 53557, 12597, 4236) need translation to composite (zone_id, local_id).
-- Best guesses inferred from zone numbering are inline below — verify with the
-- world map and adjust the get_room(...) calls before going live.
-- TODO(parity): the original DG `actor.room == home` was a room == int compare;
-- here we compare composite room ids. Same semantic, but verify the home rooms.

-- Converted from DG Script #1834: blur_winds_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes sure yep okay
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "yes") or string.find(speech_lower, "sure") or string.find(speech_lower, "yep") or string.find(speech_lower, "okay")) then
    return true  -- No matching keywords
end

if actor:get_quest_stage("blur") ~= 4 then
    return true
end

wait(2)

-- Hoist all branch-scoped locals.
local direction
local home_zone
local home_id
local color

if self.zone_id == 18 and self.local_id == 19 then  -- North Wind
    direction = "north"
    home_zone, home_id = 302, 62  -- legacy 30262
    color = "&2&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the northern peak"
    self.room:send(tostring(self.name) .. " says, 'Then you will have to beat me to: " .. tostring(color) .. tostring(rname) .. "</>")
    self.room:send("</>in Bluebonnet Pass.'")
    self:emote("laughs mightily as it vanishes!")
    actor:set_quest_var("blur", direction, 1)
elseif self.zone_id == 18 and self.local_id == 20 then  -- South Wind
    direction = "south"
    home_zone, home_id = 535, 57  -- legacy 53557
    color = "&1&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the standing stones"
    self.room:send(tostring(self.name) .. " says, 'Long has it been since one such as yourself has made this")
    self.room:send("</>request.  Now show me your speed!'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'Try to reach " .. tostring(color) .. tostring(rname) .. "</>")
    self.room:send("</>before I do!'")
    self:emote("rustles away with the sound of the leaves.")
    actor:set_quest_var("blur", direction, 1)
elseif self.zone_id == 18 and self.local_id == 21 then  -- East Wind
    direction = "east"
    home_zone, home_id = 125, 97  -- legacy 12597
    color = "&3&b"
    local room = get_room(home_zone, home_id)
    local rname = room and room.name or "the volcano caldera"
    if world.count_mobiles(481, 5) == 0 then
        self:say("Then let it be so!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Reach " .. tostring(color) .. tostring(rname) .. "</>")
        self.room:send("</>before me!'")
        actor:set_quest_var("blur", direction, 1)
    else
        self:say("Then please help me escape from the clutches of this madwoman!")
        wait(1)
        self.room:send("Vulcera throws back her head and cackles!")
    end
elseif self.zone_id == 18 and self.local_id == 22 then  -- West Wind
    direction = "west"
    home_zone, home_id = 42, 36  -- legacy 4236
    color = "&6&b"
    self:say("Well, let's play a different game first...")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'I'll be riding the fastest animal in Gothra!")
    self.room:send("</>If you can find me, then we can race!'")
    get_room(203, 8 + random(1, 46)):at(function()
        self.room:spawn_mobile(203, 21)
    end)
end

if not direction then
    return true
end

self:teleport(get_room(11, 0))

-- Polling loop: stop when player reaches the home room or the timer expires.
local count = 450
while count > 0 do
    if actor.room and actor.room.zone_id == home_zone and actor.room.local_id == home_id then
        count = 0
    else
        actor:set_quest_var("blur", direction .. "_timer", count)
        wait(5)
        count = count - 5
    end
end

local arrived = actor.room and actor.room.zone_id == home_zone and actor.room.local_id == home_id
if actor:get_quest_var("blur:" .. direction) == 2 then
    world.destroy(self)
elseif arrived then
    if actor:get_quest_var("blur:" .. direction) == 1 then
        actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Wow you're fast!  Incredible!</>'")
        actor:set_quest_var("blur", direction, 2)
        if actor:get_quest_var("blur:east") == 2 and actor:get_quest_var("blur:west") == 2 and actor:get_quest_var("blur:north") == 2 and actor:get_quest_var("blur:south") == 2 then
            skills.set_level(actor.name, "blur", 100)
            wait(2)
            actor:send("You have matched the greatest speeds of nature!")
            actor:send("You have learned <red>Blur</>!")
            actor:complete_quest("blur")
        end
    else
        if self.zone_id == 18 and self.local_id == 22 then
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You never found me, too bad!</>'")
            actor:set_quest_var("blur", direction, 0)
        elseif self.zone_id == 18 and self.local_id == 21 then
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You didn't rescue me in time!</>'")
            actor:set_quest_var("blur", direction, 0)
        end
    end
else
    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Sorry, too slow!</>'")
    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Come back if you want a rematch!</>'")
    actor:set_quest_var("blur", direction, 0)
end

world.destroy(self)
return true
