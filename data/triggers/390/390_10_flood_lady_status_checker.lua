-- Trigger: flood_lady_status_checker
-- Zone: 390, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39010

-- Converted from DG Script #39010: flood_lady_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("flood") == 1 then
    local fog = "The Blue-Fog"
    local phoenix = "Phoenix Feather Hot Springs"
    local falls = "Three-Falls River"
    local green = "The Greengreen Sea"
    local witch = "Sea's Lullaby"
    local frost = "Frost Lake"
    local black = "The Black Lake"
    local kod = "The Dreaming River"
    local water1 = actor:get_quest_var("flood:water1")
    local water2 = actor:get_quest_var("flood:water2")
    local water3 = actor:get_quest_var("flood:water3")
    local water4 = actor:get_quest_var("flood:water4")
    local water5 = actor:get_quest_var("flood:water5")
    local water6 = actor:get_quest_var("flood:water6")
    local water7 = actor:get_quest_var("flood:water7")
    local water8 = actor:get_quest_var("flood:water8")
    local item2 = actor:get_quest_var("flood:item2")
    local item3 = actor:get_quest_var("flood:item3")
    local item4 = actor:get_quest_var("flood:item4")
    local item6 = actor:get_quest_var("flood:item6")
    local item7 = actor:get_quest_var("flood:item7")
    self:say("As my Envoy, rally the Great Waters of Ethilien.")
    -- (empty room echo)
    if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
        self.room:send("You have rallied:")
        if water1 then
            self.room:send("- <blue>" .. tostring(fog) .. "</>")
        end
        if water2 then
            self.room:send("- <blue>" .. tostring(phoenix) .. "</>")
        end
        if water3 then
            self.room:send("- <blue>" .. tostring(falls) .. "</>")
        end
        if water4 then
            self.room:send("- <blue>" .. tostring(green) .. "</>")
        end
        if water5 then
            self.room:send("- <blue>" .. tostring(witch) .. "</>")
        end
        if water6 then
            self.room:send("- <blue>" .. tostring(frost) .. "</>")
        end
        if water7 then
            self.room:send("- <blue>" .. tostring(black) .. "</>")
        end
        if water8 then
            self.room:send("- <blue>" .. tostring(kod) .. "</>")
        end
        -- (empty room echo)
    end
    -- list items to be returned
    self.room:send("You must still convince:")
    if not water1 then
        self.room:send("- <b:blue>" .. tostring(fog) .. "</>")
        -- (empty room echo)
    end
    if not water2 then
        self.room:send("- <b:blue>" .. tostring(phoenix) .. "</>")
        if item2 == 1 then
            self.room:send("</>    Bring it " .. tostring(objects.template(584, 1).name) .. " to heat its springs.")
        end
        -- (empty room echo)
    end
    if not water3 then
        self.room:send("- <b:blue>" .. tostring(falls) .. "</>")
        if item3 == 1 then
            self.room:send("</>    Find a bell and dance for them.")
        end
        -- (empty room echo)
    end
    if not water4 then
        self.room:send("- <b:blue>" .. tostring(green) .. "</>")
        if item4 == 1 then
            self.room:send("</>    Feed her as many different foods as you can until she is full.")
        end
        -- (empty room echo)
    end
    if not water5 then
        self.room:send("- <b:blue>" .. tostring(witch) .. "</>")
        -- (empty room echo)
    end
    if not water6 then
        self.room:send("- <b:blue>" .. tostring(frost) .. "</>")
        if item6 == 1 then
            self.room:send("</>    Force her to join the cause.")
        end
        -- (empty room echo)
    end
    if not water7 then
        self.room:send("- <b:blue>" .. tostring(black) .. "</>")
        if item7 == 1 then
            self.room:send("</>    Bring it an eternal light to swallow into its blackness.")
        end
        -- (empty room echo)
    end
    if not water8 then
        self.room:send("- <b:blue>" .. tostring(kod) .. "</>")
        -- (empty room echo)
    end
    self.room:send(tostring(self.name) .. " says, 'Tell them: <b:blue>the Arabel Ocean calls for aid</>.'")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_quest_stage("flood") ==2 then
    self:say("Return my heart to me!")
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_has_completed("flood") then
    self:say("I have already enacted my revenge, Envoy.")
elseif not actor:get_quest_stage("flood") then
    self:say("You are not yet my Envoy.")
end