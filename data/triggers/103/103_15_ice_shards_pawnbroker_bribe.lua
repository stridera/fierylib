-- Trigger: ice_shards_pawnbroker_bribe
-- Zone: 103, ID: 15
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #10315
-- Bribe of 100000+ coins (DG narg = minimum coin value, NOT a
-- percent chance) loosens the pawnbroker's tongue. At stage 4 of
-- ice_shards he names the Butcher's accomplice and points the
-- player toward Slevvirik in Ogakh.

if actor:get_quest_stage("ice_shards") == 4 then
    actor:advance_quest("ice_shards")
    wait(2)
    self.room:send(self.name .. " says, 'I don't know much, but I do know someone paid me to help")
    self.room:send("</>'im slip outta the city.  I'm talkin', they paid A LOT.  Was a dark-skinned elf")
    self.room:send("</>with a buncha orcs.'")
    wait(5)
    self.room:send(self.name .. " says, 'Not the guy ya see skulkin' round the neighborhood or")
    self.room:send("</>nothin' neither, nah.  This guy looked like 'e worked with money.'")
    wait(4)
    self.room:send(self.name .. " says, 'Dunno where they was goin' but I got a feelin' it were")
    self.room:send("</>pretty far.  They was all talkin' 'bout Ogakh or some such.  I dunno, my Orcish")
    self.room:send("</>ain't too good these days.'")
    wait(4)
    self:say("Best of luck catchin' 'im.  Now get out.")
    self:emote("points towards the door.")
end