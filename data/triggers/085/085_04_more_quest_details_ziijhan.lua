-- Trigger: more_quest_details_ziijhan
-- Zone: 85, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8504

-- Converted from DG Script #8504: more_quest_details_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"brother", "brother?", "remedy", "remedy?", "how", "how?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player and actor:get_quest_stage("nec_dia_ant_subclass") > 1 then
    if actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
        actor:advance_quest("nec_dia_ant_subclass")
    end
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Yes!  My wretched sibling, Ber...  I shall not utter his name!'")
    wait(0.2)
    self:command("fume")
    wait(0.3)
    actor:send(tostring(self.name) .. " says, 'I despise him and his reverent little life.'")
    wait(0.2)
    self:command("ponder")
    actor:send(tostring(self.name) .. " says, 'He thinks he is safe now, beyond my grasp.  That FOOL!'")
    self:command("chuckle")
    wait(0.3)
    actor:send(tostring(self.name) .. " says, 'Enough!  I grow tired of you!'")
    wait(0.2)
    actor:send(tostring(self.name) .. " says, 'Bring back proof of the deed and you shall be accepted.'")
end