-- Trigger: supernova_guildmaster_speech2
-- Zone: 62, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #6206

-- Converted from DG Script #6206: supernova_guildmaster_speech2
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: phalya lamp help? lamp? phayla? help information information? clue clue?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "phalya") or string.find(string.lower(speech), "lamp") or string.find(string.lower(speech), "help?") or string.find(string.lower(speech), "lamp?") or string.find(string.lower(speech), "phayla?") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "information") or string.find(string.lower(speech), "information?") or string.find(string.lower(speech), "clue") or string.find(string.lower(speech), "clue?")) then
    return true  -- No matching keywords
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("supernova") == 2 and (actor:has_item("48917") or actor:has_equipped("48917")) then
    actor.name:advance_quest("supernova")
    local rnd1 = random(1, 3)
    -- switch on rnd1
    if rnd1 == 1 then
        local step3 = 4318
    elseif rnd1 == 2 then
        local step3 = 10316
    elseif rnd1 == 3 then
        local step3 = 58062
    else
        _return_value = false
    end
    actor.name:set_quest_var("supernova", "step3", step3)
    local rnd2 = random(1, 3)
    -- switch on rnd2
    if rnd2 == 1 then
        local step4 = 18577
    elseif rnd2 == 2 then
        local step4 = 17277
    elseif rnd2 == 3 then
        local step4 = 8561
    else
        _return_value = false
    end
    actor.name:set_quest_var("supernova", "step4", step4)
    local rnd3 = random(1, 3)
    -- switch on rnd3
    if rnd3 == 1 then
        local step5 = 53219
    elseif rnd3 == 2 then
        local step5 = 47343
    elseif rnd3 == 3 then
        local step5 = 16278
    else
        _return_value = false
    end
    actor.name:set_quest_var("supernova", "step5", step5)
    local rnd4 = random(1, 3)
    -- switch on rnd4
    if rnd4 == 1 then
        local step6 = 58657
    elseif rnd4 == 2 then
        local step6 = 35119
    elseif rnd4 == 3 then
        local step6 = 55422
    else
        _return_value = false
    end
    actor.name:set_quest_var("supernova", "step6", step6)
    local step7 = random(1, 3)
    actor.name:set_quest_var("supernova", "step7", step7)
    self:say("Ah I see you found one of Phayla's lamps!")
    wait(3)
    self.room:send(tostring(self.name) .. " says, 'Phayla likes to visit the material plane to engage")
    self.room:send("</>in her favorite leisure activities.'")
    wait(2)
    local clue = actor:get_quest_var("supernova:step3")
    -- switch on clue
    if clue == 4318 then
        self.room:send(tostring(self.name) .. " says, 'Recently, she was spotted in Anduin, taking in a")
        self.room:send("</>show from the best seat in the house.'")
    elseif clue == 10316 then
        self.room:send(tostring(self.name) .. " says, 'I understand she frequents the hottest spring at")
        self.room:send("</>the popular resort up north.'")
    elseif clue == 58062 then
        self.room:send(tostring(self.name) .. " says, 'She occasionally visits a small remote island")
        self.room:send("</>theatre, where she enjoys meditating in their reflecting room.'")
    else
        _return_value = false
    end
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'You may be able to find a clue to her whereabouts")
    self.room:send("</>there.'")
elseif actor:get_quest_stage("supernova") == 1 then
    self.room:send(tostring(self.name) .. " says, 'If you return here with one of Phayla's lamps, I")
    self.room:send("</>may be able to give you some more insight as to her whereabouts.'")
end
return _return_value