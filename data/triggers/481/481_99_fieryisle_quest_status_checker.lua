-- Trigger: fieryisle_quest_status_checker
-- Zone: 481, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48199

-- Converted from DG Script #48199: fieryisle_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress? status status?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?") or string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("fieryisle_quest")
wait(2)
if actor.level < 55 then
    self:say("You aren't ready to take on the volcano goddess yet.")
    return _return_value
end
if actor:get_has_completed("fieryisle_quest") then
    self.room:send(tostring(self.name) .. " says, 'You have freed us from Vulcera's tyranny!  The true")
    self.room:send("</>volcano god is pleased!'")
elseif stage > 0 then
    self:say("Currently you are trying to:")
    -- switch on stage
    if stage == 1 then
        self.room:send("Enter the volcano and find the warlord's son.")
        self.room:send("Defeat the guardian to learn the mystic phrase to open the volcano.")
    elseif stage == 2 then
        self.room:send("Find the dwarrow woman and ask for a spell of reversal.")
    elseif stage == 3 then
        self.room:send("Kill the ash lord and retrieve his crown.")
    elseif stage == 4 then
        self.room:send("Return the crown of the ash lord to the dwarrow woman.")
    elseif stage == 5 then
        self.room:send("Find the person turned to rock and hold the spell the dwarrow woman gave you.")
    elseif stage == 6 then
        self.room:send("Retrieve the ivory key.")
    elseif stage == 7 then
        self.room:send("Find Vulcera in the ivory tower.")
    elseif stage == 8 then
        self.room:send("Give the ivory key to Vulcera.")
    elseif stage == 9 then
        self.room:send("Defeat Vulcera!")
    end
    if stage > 1 then
        self.room:send("The mystic phrase to open the volcano is <b:white>buntoi nakkarri karisto</>.")
    end
else
    self:say("You are not on this quest yet.")
end