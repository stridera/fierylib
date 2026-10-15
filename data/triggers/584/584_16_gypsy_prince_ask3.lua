-- Trigger: gypsy_prince_ask3
-- Zone: 584, ID: 16
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58416

-- Converted from DG Script #58416: gypsy_prince_ask3
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 3 then
    return true
end

wait(0.2)
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send(tostring(self.name) .. " says to you, 'Excellent!  That rogue of a guard, a monstrous bronze statue'")
actor:send(tostring(self.name) .. " says to you, 'that now guards the entrance of that accursed village was to'")
actor:send(tostring(self.name) .. " says to you, 'search the Underdark for an item for me.  Go to him and demand'")
actor:send(tostring(self.name) .. " says to you, 'it in the name of the Gypsy Prince of Calia and I shall reward you.'")
actor:advance_quest("major_spell_quest")  -- advances to stage 4