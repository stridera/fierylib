-- Trigger: Gypsy_prince_ask2
-- Zone: 584, ID: 15
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #58415

-- Converted from DG Script #58415: Gypsy_prince_ask2
-- Original: MOB trigger, flags: SPEECH_TO, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"favor"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor:get_quest_stage("major_spell_quest") ~= 2 then
    return true
end

wait(1)
actor:send(tostring(self.name) .. " says to you, 'Ah, you are looking for my favor?'")
self.room:send_except(actor, tostring(self.name) .. " speaks to " .. tostring(actor.name) .. " in a low voice.")
wait(1)
self:command("smile me")
actor:send(tostring(self.name) .. " says to you, 'I get that quite a bit, actually... The last adventurer to'")
actor:send(tostring(self.name) .. " says to you, 'seek my favor left our contract imcomplete... If you could'")
actor:send(tostring(self.name) .. " says to you, 'track down that scoundrel and get my prize he is keeping..'")
actor:send(tostring(self.name) .. " says to you, 'I would consider myself in your debt..'")
wait(1)
self:command("bow " .. tostring(actor.name))
wait(1)
self:command("ask " .. tostring(actor.name) .. " Will you gon on this quest for me?")
actor:advance_quest("major_spell_quest")  -- advances to stage 3