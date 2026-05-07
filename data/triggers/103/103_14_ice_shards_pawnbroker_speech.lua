-- Trigger: ice_shards_pawnbroker_speech
-- Zone: 103, ID: 14
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10314
-- Anyone says "butcher" near the pawnbroker. If the actor is at
-- ice_shards stage 4, the broker plays coy and prompts for a
-- bribe (handled by 103_15). Otherwise he warns them off.
-- DG narg=0 = substring speech match.

local s = string.lower(speech)
if not string.find(s, "butcher") then
    return true
end
wait(2)
if actor:get_quest_stage("ice_shards") == 4 then
    self:say("Sorry, never heard of 'im.")
    wait(1)
    self:command("cough")
    self:emote("very conspicuously lays his open hand on the counter.")
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'I have some great old boots for sale though.")
    self.room:send("</>Only <b:white>100 platinum</>.'")
else
    self:say("Ya might not wanna be so loud with that name round 'ere.")
end