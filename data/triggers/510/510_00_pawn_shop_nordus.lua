-- Trigger: Pawn Shop (Nordus)
-- Zone: 510, ID: 0
-- Type: WORLD, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #51000

-- Converted from DG Script #51000: Pawn Shop (Nordus)
-- Original: WORLD trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: floor phrase is
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "floor") or string.find(string.lower(speech), "phrase") or string.find(string.lower(speech), "is")) then
    return true  -- No matching keywords
end
-- switch on the global variable which was set when they entered
local flagit = 0
-- switch on chosen
if speech == "floor phrase is open sesame" then
    if chosen == 1 then
        local flagit = 1
    end
    if speech == "floor phrase is eingang bitte" then
    elseif chosen == 2 then
        local flagit = 1
    end
    if speech == "floor phrase is traverser dedans" then
    elseif chosen == 3 then
        local flagit = 1
    end
    if speech == "floor phrase is let me in dorkus" then
    elseif chosen == 4 then
        local flagit = 1
    end
end
if flagit == 1 then
    self.room:send("The ground begins to rumble and the dirt begins to part.")
    get_room(510, 30):exit("d"):set_state({hidden = false})
    get_room(510, 30):exit("d"):set_state({description = "You see flashes of colour in the darkness below...this looks unnatural."})
    wait(7)
    self.room:send("The ground again begins to tremble as the passageway dissolves.")
    wait(5)
    self.room:send("The floor returns to normal without a trace of the secret it holds.")
    get_room(510, 30):exit("d"):set_state({hidden = true})
end