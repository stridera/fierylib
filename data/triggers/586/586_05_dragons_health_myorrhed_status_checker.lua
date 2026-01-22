-- Trigger: dragons_health_myorrhed_status_checker
-- Zone: 586, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--
-- Original DG Script: #58605

-- Converted from DG Script #58605: dragons_health_myorrhed_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress? status status?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?") or string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("dragons_health")
wait(2)
if actor:get_has_completed("dragons_health") then
    self.room:send(tostring(self.name) .. " says, 'You have already kept vigil with me.")
    self.room:send("</>May the Song of the Dragons give you strength.'")
    return _return_value
else
    -- switch on stage
    if stage == 1 then
        local dragon = "the blue dragon in the Tower in the Wastes"
        local treasure = "its crystal"
    elseif stage == 2 then
        local dragon = "Tri-Aszp"
        local treasure = "one of her scales"
    elseif stage == 3 then
        local dragon = "Thelriki and Jerajai"
        local treasure = "the jewel in their hoard"
    elseif stage == 4 then
        local dragon = "Sagece"
        local treasure = "her skins and shields"
    elseif stage == 5 then
        local total = 10000000 - actor:get_quest_var("dragons_health:hoard")
        local plat = total / 1000
        local gold = total / 100 - plat * 10
        local silv = total / 10 - plat * 100 - gold * 10
        local copp = total  - plat * 1000 - gold * 100 - silv * 10
        -- now the price can be reported
        self.room:send(tostring(self.name) .. " says, 'The new hatchling's hoard needs enriching.")
        self.room:send("</>" .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper")
        self.room:send("</>more in treasure and coins ought to do it.'")
        return _return_value
    else
        self:say("Progress of what?  You're not keeping guard with me...")
    end
    if stage == 4 then
        self.room:send(tostring(self.name) .. " says, 'You are undertaking your hardest task:'")
    elseif stage ~= 5 then
        self.room:send(tostring(self.name) .. " says, 'You are trying to:'")
    end
    self.room:send("- kill " .. tostring(dragon) .. " and bring me " .. tostring(treasure) .. ".")
    if stage == 3 then
        local thelriki = actor:get_quest_var("dragons_health:thelriki")
        local jerajai = actor:get_quest_var("dragons_health:jerajai")
        -- (empty room echo)
        if thelriki or jerajai then
            self.room:send("You have slain:")
            if thelriki then
                self.room:send("- Thelriki")
            end
            if jerajai then
                self.room:send("- Jerajai")
            end
        end
        -- (empty room echo)
        self.room:send("You must still:")
        if not thelriki then
            self.room:send("- kill Thelriki")
        end
        if not actor:get_quest_var("dragons_health:jerajai") then
            self.room:send("- kill Jerajai")
        end
        self.room:send("- bring the heartstone")
    elseif stage == 4 then
        -- (empty room echo)
        local item1 = actor:get_quest_var("dragons_health:52016")
        local item2 = actor:get_quest_var("dragons_health:52017")
        local item3 = actor:get_quest_var("dragons_health:52022")
        local item4 = actor:get_quest_var("dragons_health:52023")
        local sagece = actor:get_quest_var("dragons_health:sagece")
        if item1 or item2 or item3 or item4 or sagece then
            self.room:send("You have already:")
            if sagece then
                self.room:send("- slain Sagece of Raymif")
            end
            if item1 then
                self.room:send("- brought Sagece's skin")
            end
            if item2 then
                self.room:send("- brought Sagece's shield")
            end
            if item3 then
                self.room:send("- brought the skin from Sagece's hoard")
            end
            if item4 then
                self.room:send("- brought the shield from Sagece's hoard")
            end
        end
        -- (empty room echo)
        self.room:send("You must still:")
        if not sagece then
            self.room:send("- kill Sagece of Raymif")
        end
        if not item1 then
            self.room:send("- bring Sagece's skin")
        end
        if not item2 then
            self.room:send("- bring Sagece's shield")
        end
        if not item3 then
            self.room:send("- find the skin in Sagece's hoard")
        end
        if not item4 then
            self.room:send("- find the shield in Sagece's hoard")
        end
    end
end