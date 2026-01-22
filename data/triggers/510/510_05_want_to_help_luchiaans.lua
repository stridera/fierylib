-- Trigger: want_to_help_Luchiaans
-- Zone: 510, ID: 5
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   -- UNCONVERTED: it.
--   Complex nesting: 8 if statements
--
-- Original DG Script: #51005

-- Converted from DG Script #51005: want_to_help_Luchiaans
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: partners? teach?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "partners?") or string.find(string.lower(speech), "teach?")) then
    return true  -- No matching keywords
end
if actor.id == -1 then
    if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
        local class = "C"
    end
    if string.find(actor.class, "Necromancer") or string.find(actor.class, "Sorcerer") then
        local class = "S"
    end
    if string.find(speech, "teach")? then
        if class ~= "C" then
            self:command("laugh " .. tostring(actor.name))
            self:say("I have nothing to learn from you, " .. tostring(actor.name) .. " you upstart!")
        elseif clericquest == 3 then
            self:say("Thanks, but I don't need any more cleric books.")
        else
            self:say("Yes, well, not exactly teach, there is a book of cleric spells in the town, but only a cleric can get")
            -- UNCONVERTED: it.
            self:command("chuckle")
            self:say("If you bring it to me I will reward you.")
            if clericquest ~= 2 then
                local clericquest = 1
                globals.clericquest = globals.clericquest or true
            end
        end
    else
        if class ~= "S" then
            self:command("pat " .. tostring(actor.name))
            self:say("No way would I want to be partners with anyone but a sorceror.")
        elseif actor.level < 30 then
            self:say("Sorry, " .. tostring(actor.name) .. ".  I think you are a bit puny to be my partner at the moment.")
        elseif magequest == 2 then
            self:say("Sorry, I've already got everything I need in order to start building up my zombie army.")
        else
            self:command("smile")
            self:say("Great, " .. tostring(actor.name) .. ".")
            self:say("Let's get this relationship off to a flying start - bring me a phoenix heart.")
            self:say("I need it for my regeneration potions.")
            self:emote("rubs his hands together in glee.")
            self:say("I think Rana Theroxa has a pet phoenix somewhere near the council chambers.")
            local magequest = 1
            globals.magequest = globals.magequest or true
        end
    end
end