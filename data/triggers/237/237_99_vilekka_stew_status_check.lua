-- Trigger: vilekka_stew_status_check
-- Zone: 237, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 17 if statements
--
-- Original DG Script: #23799

-- Converted from DG Script #23799: vilekka_stew_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
local num_spices = actor:get_quest_var("vilekka_stew:num_spices")
local spice1 = actor:get_quest_var("vilekka_stew:got_spice:12552")
local spice2 = actor:get_quest_var("vilekka_stew:got_spice:49022")
local spice3 = actor:get_quest_var("vilekka_stew:got_spice:23750")
local spice4 = actor:get_quest_var("vilekka_stew:got_spice:23751")
local spice5 = actor:get_quest_var("vilekka_stew:got_spice:23752")
local spice6 = actor:get_quest_var("vilekka_stew:got_spice:23753")
local spice7 = actor:get_quest_var("vilekka_stew:got_spice:23754")
local spice8 = actor:get_quest_var("vilekka_stew:got_spice:23755")
local spice9 = actor:get_quest_var("vilekka_stew:got_spice:23756")
local spice10 = actor:get_quest_var("vilekka_stew:got_spice:23757")
local spice11 = actor:get_quest_var("vilekka_stew:got_spice:23758")
local spice12 = actor:get_quest_var("vilekka_stew:got_spice:23759")
local spice13 = actor:get_quest_var("vilekka_stew:got_spice:23760")
if actor:get_has_completed("vilekka_stew") then
    self:say("You have already done me a great service.")
end
local stage = actor:get_quest_stage("vilekka_stew")
-- switch on stage
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Bring me the heart of the drow living in the")
    self.room:send("</>surface city!'")
elseif stage == 2 then
    self:say("Well, do you want to continue or stop?")
elseif stage == 3 then
    self:say("You must bring me the head of the drider king.")
elseif stage == 4 then
    self:say("Well, do you want to continue or stop?")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'Bring me some spices so that I can make this head")
    self.room:send("</>and heart palatable.'")
    if num_spices > 0 then
        -- (empty room echo)
        self.room:send("So far you have brought me:")
        if spice1 then
            self.room:send("- " .. tostring(objects.template(125, 52).name))
        end
        if spice2 then
            self.room:send("- " .. tostring(objects.template(490, 22).name))
        end
        if spice3 then
            self.room:send("- " .. tostring(objects.template(237, 50).name))
        end
        if spice4 then
            self.room:send("- " .. tostring(objects.template(237, 51).name))
        end
        if spice5 then
            self.room:send("- " .. tostring(objects.template(237, 52).name))
        end
        if spice6 then
            self.room:send("- " .. tostring(objects.template(237, 53).name))
        end
        if spice7 then
            self.room:send("- " .. tostring(objects.template(237, 54).name))
        end
        if spice8 then
            self.room:send("- " .. tostring(objects.template(237, 55).name))
        end
        if spice9 then
            self.room:send("- " .. tostring(objects.template(237, 56).name))
        end
        if spice10 then
            self.room:send("- " .. tostring(objects.template(237, 57).name))
        end
        if spice11 then
            self.room:send("- " .. tostring(objects.template(237, 58).name))
        end
        if spice12 then
            self.room:send("- " .. tostring(objects.template(237, 59).name))
        end
        if spice13 then
            self.room:send("- " .. tostring(objects.template(237, 60).name))
        end
    end
    -- (empty room echo)
    local total = 10 - num_spices
    self.room:send("Bring me " .. tostring(total) .. " more spices to prepare this stew.")
else
    self:say("You are not performing a service for me.")
end