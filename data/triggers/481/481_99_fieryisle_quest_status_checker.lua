-- Trigger: fieryisle_quest_status_checker
-- Zone: 481, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48199

-- Converted from DG Script #48199: fieryisle_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"progress", "progress?", "status", "status?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
local stage = actor:get_quest_stage("fieryisle_quest")
wait(0.2)
if actor.level < 55 then
    self:say("You aren't ready to take on the volcano goddess yet.")
    return true
end
if actor:get_has_completed("fieryisle_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have freed us from Vulcera's tyranny!  The true")
    self.room:send("</>volcano god is pleased!'")
elseif stage > 0 then
    self:say("Currently you are trying to:")
    -- switch on stage
    do
        local _sw1 = string.lower(tostring(stage or ""))
        if tonumber(_sw1) == 1 then
            self.room:send("Enter the volcano and find the warlord's son.")
            self.room:send("Defeat the guardian to learn the mystic phrase to open the volcano.")
        elseif tonumber(_sw1) == 2 then
            self.room:send("Find the dwarrow woman and ask for a spell of reversal.")
        elseif tonumber(_sw1) == 3 then
            self.room:send("Kill the ash lord and retrieve his crown.")
        elseif tonumber(_sw1) == 4 then
            self.room:send("Return the crown of the ash lord to the dwarrow woman.")
        elseif tonumber(_sw1) == 5 then
            self.room:send("Find the person turned to rock and hold the spell the dwarrow woman gave you.")
        elseif tonumber(_sw1) == 6 then
            self.room:send("Retrieve the ivory key.")
        elseif tonumber(_sw1) == 7 then
            self.room:send("Find Vulcera in the ivory tower.")
        elseif tonumber(_sw1) == 8 then
            self.room:send("Give the ivory key to Vulcera.")
        elseif tonumber(_sw1) == 9 then
            self.room:send("Defeat Vulcera!")
        end
    end
    if stage > 1 then
        self.room:send("The mystic phrase to open the volcano is <b:white>buntoi nakkarri karisto</>.")
    end
else
    self:say("You are not on this quest yet.")
end