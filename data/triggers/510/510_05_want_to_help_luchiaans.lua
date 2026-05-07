-- Trigger: want_to_help_Luchiaans
-- Zone: 510, ID: 5
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51005
-- Reacts to the player asking about "partners" or "teach" depending on
-- their class:
--   - Clerics / Priests asking "teach" → cleric-book quest.
--   - Necromancers / Sorcerers asking "partners" → phoenix-heart quest.
-- Other classes get class-shamed.

-- Speech keywords: partners, teach
local speech_lower = string.lower(speech or "")
local asked_partners = string.find(speech_lower, "partners") ~= nil
local asked_teach = string.find(speech_lower, "teach") ~= nil
if not (asked_partners or asked_teach) then
    return true
end

if not actor.is_player then
    return true
end

local class
if string.find(actor.class, "Cleric") or string.find(actor.class, "Priest") then
    class = "C"
elseif string.find(actor.class, "Necromancer") or string.find(actor.class, "Sorcerer") then
    class = "S"
end

local clericquest = clericquest or 0
local magequest = magequest or 0

if asked_teach then
    if class ~= "C" then
        self:command("laugh " .. tostring(actor.name))
        self:say("I have nothing to learn from you, " .. tostring(actor.name) .. " you upstart!")
    elseif clericquest == 3 then
        self:say("Thanks, but I don't need any more cleric books.")
    else
        self:say("Yes, well, not exactly teach, there is a book of cleric spells in the town, but only a cleric can get it.")
        self:command("chuckle")
        self:say("If you bring it to me I will reward you.")
        if clericquest ~= 2 then
            globals.clericquest = 1
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
        globals.magequest = 1
    end
end
