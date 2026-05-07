-- Trigger: vilekka_stew_status_check
-- Zone: 237, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #23799

-- Converted from DG Script #23799: vilekka_stew_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 100%
-- "progress" report for the vilekka_stew quest. Lists current stage hint
-- and, on stage 5, which of the ten herbs/spices have been delivered.

-- Speech keywords: progress progress?
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "progress") then
    return true  -- No matching keywords
end
wait(2)
if actor:get_has_completed("vilekka_stew") then
    self:say("You have already done me a great service.")
    return true
end
local stage = actor:get_quest_stage("vilekka_stew")
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
    local num_spices = actor:get_quest_var("vilekka_stew:num_spices") or 0
    -- (key, zone, local_id) for each accepted spice.
    local spices = {
        { "12552", 125, 52 },
        { "49022", 490, 22 },
        { "23750", 237, 50 },
        { "23751", 237, 51 },
        { "23752", 237, 52 },
        { "23753", 237, 53 },
        { "23754", 237, 54 },
        { "23755", 237, 55 },
        { "23756", 237, 56 },
        { "23757", 237, 57 },
        { "23758", 237, 58 },
        { "23759", 237, 59 },
        { "23760", 237, 60 },
    }
    if num_spices > 0 then
        self.room:send("So far you have brought me:")
        for _, s in ipairs(spices) do
            if actor:get_quest_var("vilekka_stew:got_spice:" .. s[1]) == 1 then
                self.room:send("- " .. tostring(objects.template(s[2], s[3]).name))
            end
        end
    end
    local remaining = 10 - num_spices
    self.room:send("Bring me " .. tostring(remaining) .. " more spices to prepare this stew.")
else
    self:say("You are not performing a service for me.")
end
