-- Trigger: more_quest_details_ziijhan
-- Zone: 85, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8504

-- Converted from DG Script #8504: more_quest_details_ziijhan
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: brother brother? remedy remedy? how how?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "brother") or string.find(string.lower(speech), "brother?") or string.find(string.lower(speech), "remedy") or string.find(string.lower(speech), "remedy?") or string.find(string.lower(speech), "how") or string.find(string.lower(speech), "how?")) then
    return true  -- No matching keywords
end
if actor.id == -1 and actor:get_quest_stage("nec_dia_ant_subclass") > 1 then
    if actor:get_quest_stage("nec_dia_ant_subclass") == 2 then
        actor.name:advance_quest("nec_dia_ant_subclass")
    end
    self:command("nod " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Yes!  My wretched sibling, Ber...  I shall not utter his name!'")
    wait(2)
    self:command("fume")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I despise him and his reverent little life.'")
    wait(2)
    self:command("ponder")
    actor:send(tostring(self.name) .. " says, 'He thinks he is safe now, beyond my grasp.  That FOOL!'")
    self:command("chuckle")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Enough!  I grow tired of you!'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bring back proof of the deed and you shall be accepted.'")
end