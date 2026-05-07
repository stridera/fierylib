-- Trigger: common_child_speak1
-- Zone: 510, ID: 26
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #51026
-- Reacts to "kafit" — both heads of the two-headed child reveal
-- that "kafit" is the key to decoding Luchiaans' spells and beg the
-- adventurer for vengeance.

-- Speech keyword: "kafit"
if not string.find(string.lower(speech or ""), "kafit") then
    return true
end
self.room:send("Both the child's heads focus their attention on you.")
self.room:send("One head says, 'That is the key to decoding Luchiaans' spells.'")
self.room:send("The other head says, 'Avenge us, adventurer!'")
self:command("beg " .. tostring(actor.name))