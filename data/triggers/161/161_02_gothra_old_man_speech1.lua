-- Trigger: Gothra_Old_Man_speech1
-- Zone: 161, ID: 2
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16102
--
-- When the player mentions "precious", the old man laments his lost bracelet
-- (a gift from his merchant-rogue wife) and the wreck of his cart.

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"precious"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
self:command("sigh")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'Yes, during our battles with a giant monster near here a gift from my dear wife was lost.'")
self:command("wince")
wait(0.1)
self:command("grumble")
actor:send("An old man whispers to you 'Wrecked up my cart real good too...'")
self.room:send_except(actor, "An old man speaks to " .. tostring(actor.name) .. " in a low voice.")
actor:send("An old man whispers to you 'She wasn't happy, she's quite the rogue from a prominent merchant family and the bracelet was an heirloom.'")
self:command("frown")
actor:send("An old man whispers to you 'If I only had it back....'")