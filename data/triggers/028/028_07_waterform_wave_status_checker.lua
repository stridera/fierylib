-- Trigger: waterform_wave_status_checker
-- Zone: 28, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--   Large script: 5025 chars
--
-- Original DG Script: #2807

-- Converted from DG Script #2807: waterform_wave_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("waterform")
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Find a piece of armor made of water to serve as the basis")
    self.room:send("</>of your new form.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'You need a special vessel to gather water in.  Kill")
    self.room:send("</>Tri-Aszp and get a large bone from her.'")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'You need a special vessel to gather water in.  Give me")
    self.room:send("</>the large bone from a grown white dragon so I can make you one.'")
elseif stage == 4 then
    local region1 = actor:get_quest_var("waterform:region1")
    local region2 = actor:get_quest_var("waterform:region2")
    local region3 = actor:get_quest_var("waterform:region3")
    local region4 = actor:get_quest_var("waterform:region4")
    local region5 = actor:get_quest_var("waterform:region5")
    self:say("Collect samples of living water from four different regions.")
    if region1 or region2 or region3 or region4 or region5 then
        -- (empty room echo)
        self.room:send("You already have samples from:")
        if region1 then
            self.room:send("- <blue>The Blue Fog trails and waters</>")
        end
        if region2 then
            self.room:send("- <blue>Nordus</>")
        end
        if region3 then
            self.room:send("- <blue>Layveran Labyrinth</>")
        end
        if region4 then
            self.room:send("- <blue>The Elemental Plane of Water</>")
        end
        if region5 then
            self.room:send("- <blue>The sunken castle</>")
        end
    end
    -- (empty room echo)
    local samples = 4 - (region1 + region2 + region3 + region4 + region5)
    self.room:send("You need <b:blue>" .. tostring(samples) .. "</> more.")
elseif stage == 5 then
    self:say("Give me the cup so I can see the samples.")
elseif stage == 6 then
    local water1 = actor:get_quest_var("waterform:3296")
    local water2 = actor:get_quest_var("waterform:58405")
    local water3 = actor:get_quest_var("waterform:53319")
    local water4 = actor:get_quest_var("waterform:55804")
    local water5 = actor:get_quest_var("waterform:58701")
    local water6 = actor:get_quest_var("waterform:37014")
    self:say("You are looking for six unique sources of water.")
    if water1 or water2 or water3 or water4 or water5 or water6 then
        -- (empty room echo)
        self.room:send("You have already analyzed water from:")
        if water1 then
            self.room:send("- <blue>a granite pool in the village of Mielikki</>")
        end
        if water2 then
            self.room:send("- <blue>a sparkling artesian well in the Realm of the King of Dreams</>")
        end
        if water3 then
            self.room:send("- <blue>a crystal clear fountain in the caverns of the Ice Cult</>")
        end
        if water4 then
            self.room:send("- <blue>the creek in the Eldorian Foothills</>")
        end
        if water5 then
            self.room:send("- <blue>the wishing well at the Dancing Dolphin in South Caelia</>")
        end
        if water6 then
            self.room:send("- <blue>an underground brook in the Minithawkin Mines</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to analyze water from:")
    if not water1 then
        self.room:send("- <b:cyan>a granite pool in the village of Mielikki</>")
    end
    if not water2 then
        self.room:send("- <b:cyan>a sparkling artesian well in the Realm of the King of Dreams</>")
    end
    if not water3 then
        self.room:send("- <b:cyan>a crystal clear fountain in the caverns of the Ice Cult</>")
    end
    if not water4 then
        self.room:send("- <b:cyan>the creek in the Eldorian Foothills</>")
    end
    if not water5 then
        self.room:send("- <b:cyan>the wishing well at the Dancing Dolphin in South Caelia</>")
    end
    if not water6 then
        self.room:send("- <b:cyan>an underground brook in the Minithawkin Mines</>")
    end
elseif stage == 7 then
    self:say("Just return the cup to me and you're done!")
elseif actor:get_has_completed("waterform") then
    self:say("I already showed you how to transform into water.")
elseif not stage then
    self:say("But we're not doing anything together!")
end
if stage > 3 then
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you need a new cup, say \"<b:yellow>I need a new cup</>\".'")
end