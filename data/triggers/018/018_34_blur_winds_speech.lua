-- Trigger: blur_winds_speech
-- Zone: 18, ID: 34
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--   Large script: 5157 chars
--
-- Original DG Script: #1834

-- Converted from DG Script #1834: blur_winds_speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes sure yep okay
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "sure") or string.find(string.lower(speech), "yep") or string.find(string.lower(speech), "okay")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
wait(2)
if actor:get_quest_stage("blur") == 4 then
    -- switch on self.id
    if self.id == 1819 then
        local direction = "north"
        local home = 30262
        local color = "&2&b"
        local room = get_room("30262")
        self.room:send(tostring(self.name) .. " says, 'Then you will have to beat me to: " .. tostring(color) .. tostring(room.name) .. "</>")
        self.room:send("</>in Bluebonnet Pass.'")
        self:emote("laughs mightily as it vanishes!")
        actor.name:set_quest_var("blur", "%direction%", 1)
    elseif self.id == 1820 then
        local direction = "south"
        local home = 53557
        local color = "&1&b"
        local room = get_room("53557")
        self.room:send(tostring(self.name) .. " says, 'Long has it been since one such as yourself has made this")
        self.room:send("</>request.  Now show me your speed!'")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Try to reach " .. tostring(color) .. tostring(room.name) .. "</>")
        self.room:send("</>before I do!'")
        self:emote("rustles away with the sound of the leaves.")
        actor.name:set_quest_var("blur", "%direction%", 1)
    elseif self.id == 1821 then
        local direction = "east"
        local home = 12597
        local color = "&3&b"
        local room = get_room("12597")
        if world.count_mobiles("48105") == 0 then
            self:say("Then let it be so!")
            wait(1)
            self.room:send(tostring(self.name) .. " says, 'Reach " .. tostring(color) .. tostring(room.name) .. "</>")
            self.room:send("</>before me!'")
            actor.name:set_quest_var("blur", "%direction%", 1)
        else
            self:say("Then please help me escape from the clutches of this madwoman!")
            wait(1)
            self.room:send("Vulcera throws back her head and cackles!")
        end
    elseif self.id == 1822 then
        local direction = "west"
        local home = 4236
        local color = "&6&b"
        local room = get_room("4236")
        self:say("Well, let's play a different game first...")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I'll be riding the fastest animal in Gothra!")
        self.room:send("</>If you can find me, then we can race!'")
        local load = 20308 + random(1, 46)
        get_room(vnum_to_zone(load), vnum_to_local(load)):at(function()
            self.room:spawn_mobile(203, 21)
        end)
    else
        _return_value = false
    end
    self:teleport(get_room(11, 0))
    local count = 450
    while count > 0 do
        if actor.room == "home" then
            local time = count - 450
            local count = time
        else
            actor:set_quest_var("blur", "%direction%_timer", count)
            local time = count - 5
            wait(5)
            local count = time
        end
    end
    if actor.quest_variable[blur:direction] == 2 then
        world.destroy(self)
    else
        if actor.room == "home" then
            if actor.quest_variable[blur:direction] == 1 then
                actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Wow you're fast!  Incredible!</>'")
                actor.name:set_quest_var("blur", "%direction%", 2)
                if actor:get_quest_var("blur:east") == 2 and actor:get_quest_var("blur:west") == 2 and actor:get_quest_var("blur:north") == 2 and actor:get_quest_var("blur:south") == 2 then
                    skills.set_level(actor.name, "blur", 100)
                    wait(2)
                    actor:send("You have matched the greatest speeds of nature!")
                    actor:send("You have learned <red>Blur</>!")
                    actor.name:complete_quest("blur")
                end
            else
                if self.id == 1822 then
                    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You never found me, too bad!</>'")
                    actor.name:set_quest_var("blur", "%direction%", 0)
                elseif self.id == 1821 then
                    actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "You didn't rescue me in time!</>'")
                    actor.name:set_quest_var("blur", "%direction%", 0)
                end
            end
        else
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Sorry, too slow!</>'")
            actor:send(tostring(self.name) .. " tells you, '" .. tostring(color) .. "Come back if you want a rematch!</>'")
            actor.name:set_quest_var("blur", "%direction%", 0)
        end
    end
end
world.destroy(self)
return _return_value