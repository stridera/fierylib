-- Trigger: hell_gate_dagger_replacement
-- Zone: 564, ID: 11
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #56411
--
-- If the player has lost the ritual dagger during stage 3, they say
-- "I need a new dagger" to the diabolist who marks the quest var so
-- 564_04's stage-3 path will accept any (30, 213) replacement they
-- bring back. The original DG's 0% probability was a quirk; speech
-- match is the actual gate, so we ignore the probability column.

-- Speech keyword: "I need a new dagger" (full phrase match — partial
-- matches over single words like "I" or "a" would over-fire).
if not string.find(string.lower(speech), "i need a new dagger") then
    return true
end

wait(2)
if actor:get_quest_stage("hell_gate") == 3 then
    actor:set_quest_var("hell_gate", "new", "yes")
    self:command("grumble")
    self.room:send(tostring(self.name) .. " says, 'I don't have another.  You'll have to find a")
    self.room:send("</>replacement.'")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'If you can find another, I will verify it")
    self.room:send("</>will work.'")
end
