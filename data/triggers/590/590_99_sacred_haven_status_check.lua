-- Trigger: sacred_haven_status_check
-- Zone: 590, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59099

-- Converted from DG Script #59099: sacred_haven_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 0% (DG marker for speech-only)
-- The 0% probability gate was DG's way of saying "speech-only"; we drop it
-- here so the SPEECH match can fire normally. Keyword set is the original
-- "what am I doing?" prompt - require all four word fragments to appear.

-- Speech keywords: what am I doing?
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "what")
        and string.find(speech_lower, "am")
        and string.find(speech_lower, "i")
        and string.find(speech_lower, "doing")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("sacred_haven")
local light = actor:get_quest_var("sacred_haven:given_light")
local key = actor:get_quest_var("sacred_haven:find_key")
local blood = actor:get_quest_var("sacred_haven:given_blood")
local trinket = actor:get_quest_var("sacred_haven:given_trinket")
local earring = actor:get_quest_var("sacred_haven:given_earring")
wait(2)
if stage == 1 and light == 0 then
    self.room:send(tostring(self.name) .. " says, 'Prove yourself.  Bring me " .. tostring(objects.template(590, 26).name))
    self.room:send("</>from a priest on the second floor.'")
elseif stage == 1 and light == 1 then
    self:say("Ask me about my artifacts.")
elseif stage == 2 and key == 0 then
    self:say("Break my ally out of jail.")
    -- (empty room echo)
    self.room:send("Then bring me:")
    self.room:send("- " .. tostring(objects.template(590, 28).name))
    self.room:send("- " .. tostring(objects.template(590, 29).name))
    self.room:send("- " .. tostring(objects.template(590, 30).name))
elseif stage == 2 and key == 1 then
    self:say("Find the key my ally stashed in the courtyard.")
    -- (empty room echo)
    self.room:send("Then bring me:")
    self.room:send("- " .. tostring(objects.template(590, 28).name))
    self.room:send("- " .. tostring(objects.template(590, 29).name))
    self.room:send("- " .. tostring(objects.template(590, 30).name))
elseif stage == 2 and key == 2 then
    self:say("Bring me my artifacts.")
    if blood or trinket or earring then
        -- (empty room echo)
        self.room:send("You have brought me:")
        if blood == 1 then
            self.room:send("- " .. tostring(objects.template(590, 28).name))
        end
        if trinket == 1 then
            self.room:send("- " .. tostring(objects.template(590, 29).name))
        end
        if earring == 1 then
            self.room:send("- " .. tostring(objects.template(590, 30).name))
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if blood == 0 then
        self.room:send("- " .. tostring(objects.template(590, 28).name))
    end
    if trinket == 0 then
        self.room:send("- " .. tostring(objects.template(590, 29).name))
    end
    if earring == 0 then
        self.room:send("- " .. tostring(objects.template(590, 30).name))
    end
    wait(2)
    self:say("Bring me my artifacts! Chop chop!")
end