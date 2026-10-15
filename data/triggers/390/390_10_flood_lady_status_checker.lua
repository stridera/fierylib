-- Trigger: flood_lady_status_checker
-- Zone: 390, ID: 10
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #39010
--
-- The Lady reports the Envoy's progress: which Great Waters have been
-- rallied (waterN flags), which still need convincing, and any hint
-- previously given (itemN flags from spirits' demands).

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"status", "status?", "progress", "progress?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end

wait(0.2)
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
    if water1 or water2 or water3 or water4 or water5 or water6 or water7 or water8 then
        self.room:send("You have rallied:")
        if water1 then self.room:send("- <blue>" .. fog .. "</>") end
        if water2 then self.room:send("- <blue>" .. phoenix .. "</>") end
        if water3 then self.room:send("- <blue>" .. falls .. "</>") end
        if water4 then self.room:send("- <blue>" .. green .. "</>") end
        if water5 then self.room:send("- <blue>" .. witch .. "</>") end
        if water6 then self.room:send("- <blue>" .. frost .. "</>") end
        if water7 then self.room:send("- <blue>" .. black .. "</>") end
        if water8 then self.room:send("- <blue>" .. kod .. "</>") end
    end
    self.room:send("You must still convince:")
    if not water1 then
        self.room:send("- <b:blue>" .. fog .. "</>")
    end
    if not water2 then
        self.room:send("- <b:blue>" .. phoenix .. "</>")
        if (item2 or 0) == 1 then
            self.room:send("</>    Bring it " .. objects.template(584, 1).name .. " to heat its springs.")
        end
    end
    if not water3 then
        self.room:send("- <b:blue>" .. falls .. "</>")
        if (item3 or 0) == 1 then
            self.room:send("</>    Find a bell and dance for them.")
        end
    end
    if not water4 then
        self.room:send("- <b:blue>" .. green .. "</>")
        if (item4 or 0) == 1 then
            self.room:send("</>    Feed her as many different foods as you can until she is full.")
        end
    end
    if not water5 then
        self.room:send("- <b:blue>" .. witch .. "</>")
    end
    if not water6 then
        self.room:send("- <b:blue>" .. frost .. "</>")
        if (item6 or 0) == 1 then
            self.room:send("</>    Force her to join the cause.")
        end
    end
    if not water7 then
        self.room:send("- <b:blue>" .. black .. "</>")
        if (item7 or 0) == 1 then
            self.room:send("</>    Bring it an eternal light to swallow into its blackness.")
        end
    end
    if not water8 then
        self.room:send("- <b:blue>" .. kod .. "</>")
    end
    self.room:send(self.name .. " says, 'Tell them: <b:blue>the Arabel Ocean calls for aid</>.'")
    self.room:send(self.name .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_quest_stage("flood") == 2 then
    self:say("Return my heart to me!")
    self.room:send(self.name .. " says, 'If you lost the Heart, say <b:blue>I lost the heart</>.'")
elseif actor:get_has_completed("flood") then
    self:say("I have already enacted my revenge, Envoy.")
else
    self:say("You are not yet my Envoy.")
end