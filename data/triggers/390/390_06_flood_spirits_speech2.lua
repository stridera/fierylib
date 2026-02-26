-- Trigger: flood_spirits_speech2
-- Zone: 390, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Large script: 9311 chars
--
-- Original DG Script: #39006

-- Converted from DG Script #39006: flood_spirits_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: stolen revenge destroy flood return
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "stolen") or string.find(string.lower(speech), "revenge") or string.find(string.lower(speech), "destroy") or string.find(string.lower(speech), "flood") or string.find(string.lower(speech), "return")) then
    return true  -- No matching keywords
end
if actor:get_quest_stage("flood") == 1 then
    wait(1)
    -- 
    -- Blue-fog wants nothing.
    -- 
    if self.id == 39013 then
        local color = "&4"
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The ocean is a sister to me.  Long have our waters mingled</>")
        self.room:send("</>" .. tostring(color) .. "and met.'</>")
        wait(3)
        self.room:send(tostring(self.name) .. " says coldly, " .. tostring(color) .. "'Hundreds rest in watery graves in my depths.  What</>")
        self.room:send("</>" .. tostring(color) .. "are a few more?  I shall rally to her cause.'</>")
        wait(2)
        self:command("shrug")
        actor.name:set_quest_var("flood", "water1", 1)
        wait(3)
        self.room:send(tostring(color) .. tostring(self.name) .. " vanishes back into the water.</>")
        -- 
        -- Phoenix wants the feather
        -- 
    elseif self.id == 39014 then
        local color = "&6"
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'I will join this effort if heat can be provided for my</>")
        self.room:send("</>" .. tostring(color) .. "spring while I am away.'</>")
        wait(2)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me a glowing phoenix feather from the Realm of</>")
        self.room:send("</>" .. tostring(color) .. "the King of Dreams and I shall join the ocean's cause.'</>")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Say <b:blue>[Spirit I have returned]</>" .. tostring(color) .. " when you return with what</>")
        self.room:send("</>" .. tostring(color) .. "I ask.'</>")
        wait(2)
        self.room:send(tostring(color) .. "With a mighty cry " .. tostring(self.name) .. " dives back into the water.</>")
        actor.name:set_quest_var("flood", "item2", 1)
        -- 
        -- Three-Falls wants a water dance
        -- 
    elseif self.id == 39015 then
        local color = "&4&b"
        self.room:send(tostring(self.name) .. " speaks in three voices at once:")
        self.room:send(tostring(color) .. "'We only receive petitions from those that perform the proper dances.  Observe</>")
        self.room:send("</>" .. tostring(color) .. "the traditions of the Canyon tribes.  Stand before us with a <b:cyan>bell</>" .. tostring(color) .. ", the</>")
        self.room:send("</>" .. tostring(color) .. "instrument of water, and <b:cyan>dance</>" .. tostring(color) .. " your supplications.  Only then will we heed the</>")
        self.room:send("</>" .. tostring(color) .. "ocean's request.'</>")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Say <b:blue>[Spirit I have returned]</>" .. tostring(color) .. " when you return</>")
        self.room:send("</>" .. tostring(color) .. "with what I ask.'</>")
        wait(3)
        actor.name:set_quest_var("flood", "item3", 1)
        self.room:send(tostring(color) .. tostring(self.name) .. " rushes away with the river rapids.</>")
        -- 
        -- Greengreen wants to devour things
        -- 
    elseif self.id == 39016 then
        local color = "&2"
        self.room:send("With a voice like rattling bones " .. tostring(self.name) .. " speaks:")
        self.room:send(tostring(color) .. "'I move only as my hunger is sated.  Feed me the gluttonous pleasures my</>")
        self.room:send("</>" .. tostring(color) .. "victims once knew in life!'</>")
        wait(2)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Bring me foods that I may devour them!  But never the</>")
        self.room:send("</>" .. tostring(color) .. "same thing twice!'</>")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Say <b:blue>[Spirit I have returned]</>" .. tostring(color) .. " when you bring me</>")
        self.room:send("</>" .. tostring(color) .. "what I ask.'</>")
        wait(3)
        self.room:send(tostring(color) .. tostring(self.name) .. " sinks beneath the waves.</>")
        actor.name:set_quest_var("flood", "item4", 1)
        -- 
        -- Lullaby is free once the Sea Witch is defeated and is called from the Witch's lair
        -- 
    elseif self.id == 39017 then
        local color = "&4&b"
        self.room:send("In sonorous tones " .. tostring(self.name) .. " says, " .. tostring(color) .. "'As the mighty Sea Witch has been defeated</>")
        self.room:send("</>" .. tostring(color) .. "I shall join thee in thy cause.'</>")
        -- (empty room echo)
        self.room:send(tostring(color) .. "Music echoes through the waves as the currents shift and rush back into the ocean!</>")
        actor.name:set_quest_var("flood", "water5", 1)
        -- 
        -- Frozen wants a fight
        -- 
    elseif self.id == 39018 then
        local color = "&7&b"
        actor.name:set_quest_var("flood", "item6", 1)
        self.room:send(tostring(self.name) .. " laughs in a voice as freezing as the blasting wind.")
        wait(1)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'The Ocean thinks itself so mighty that the</>")
        self.room:send("</>" .. tostring(color) .. "great Frozen Lake should heed its call?'</>")
        wait(2)
        self.room:send(tostring(self.name) .. " scoffs.")
        wait(2)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Ridiculous.'</>")
        wait(4)
        self.room:send(tostring(self.name) .. " descends shrieking," .. tostring(color) .. " 'I shall destroy you for your</>")
        self.room:send("</>" .. tostring(color) .. "insolence, Envoy!'</>")
        wait(3)
        combat.engage(self, actor.name)
        return _return_value
        -- 
        -- Black Lake wants an infinite light
        -- 
    elseif self.id == 39019 then
        local color = "&9&b"
        self.room:send("The sound of " .. tostring(self.name) .. "'s laughter terrifies you to your very soul!")
        wait(1)
        self.room:send(tostring(self.name) .. " speaks in sounds like hot steam forced through shredded flesh:")
        self.room:send(tostring(color) .. "'The Black Lake will assist the Arabel Ocean on one condition:</>")
        self.room:send("</>" .. tostring(color) .. "Bring me an eternal light to snuff out so the world may be a touch darker.</>")
        self.room:send("</>" .. tostring(color) .. "Then the Lake shall assist in consuming any lives you ask.'</>")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'Say <b:blue>[Spirit I have returned]</>" .. tostring(color) .. " when you</>")
        self.room:send("</>" .. tostring(color) .. "return with what I ask.'</>")
        actor.name:set_quest_var("flood", "item7", 1)
        -- (empty room echo)
        self.room:send(tostring(color) .. tostring(self.name) .. " descends back into the darkness from whence it came.</>")
        -- 
        -- Dreaming Undine wants nothing but only comes out at night.
        -- 
    elseif self.id == 39020 then
        local color = "&6&b"
        self.room:send(tostring(self.name) .. " giggles like peeling bells.")
        self.room:send(tostring(self.name) .. " traces the dream-like reflection of the moon on the surface of the stream.")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, " .. tostring(color) .. "'May She be witness to this agreement.'</>")
        self:command("shake " .. tostring(actor))
        wait(2)
        self.room:send(tostring(self.name) .. " chimes:")
        self.room:send(tostring(color) .. "'If the moon doth shine then I shall go</>")
        self.room:send("</>" .. tostring(color) .. "following Dreaming's ebb and flow.'</>")
        actor.name:set_quest_var("flood", "water8", 1)
        -- (empty room echo)
        self.room:send(tostring(color) .. tostring(self.name) .. " drifts away on the moonlit current.</>")
    end
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
        actor:advance_quest("flood")
        wait(1)
        actor:send("<b:blue>You have garnered the support of all the great waters!</>")
    end
    world.destroy(self)
end