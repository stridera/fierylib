-- Trigger: shaman_speak1
-- Zone: 178, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #17801

-- Converted from DG Script #17801: shaman_speak1
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: master let the test begin
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "master") or string.find(string.lower(speech), "let") or string.find(string.lower(speech), "the") or string.find(string.lower(speech), "test") or string.find(string.lower(speech), "begin")) then
    return true  -- No matching keywords
end
if self.is_fighting then
    self:say("Your test may begin when mine has finished!")
else
    if world.count_mobiles("17811") then
        self:say("I'm sorry.  I'm already helping someone else face their fears.")
        self:say("You may try when they are finished.")
    else
        self:say("It is your right to face your fears.")
        self:say("Let us hope you have the power to overcome them.")
        wait(1)
        actor:send("Everything blurs for a second as the shaman gestures.")
        actor:teleport(get_room(178, 69))
        self:emote("gestures, and " .. tostring(actor.name) .. " disappears in a blur.")
        get_room(178, 69):at(function()
            -- actor looks around
        end)
        wait(1)
        actor:send("<blue>" .. tostring(self.name) .. " tells you, 'If you need to leave, my apprentice will show you the way out.'</>")
        get_room(178, 72):at(function()
            self.room:spawn_mobile(178, 11)
        end)
        if not world.count_mobiles("17812") then
            get_room(178, 72):at(function()
                self.room:spawn_mobile(178, 12)
            end)
        end
    end
end