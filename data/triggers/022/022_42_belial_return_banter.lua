-- Trigger: belial_return_banter
-- Zone: 22, ID: 42
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #2242

-- Converted from DG Script #2242: belial_return_banter
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
-- Belial's Return Banter
local banter = random(1, 6)
local victim = room.actors[random(1, #room.actors)]
-- switch on banter
if banter == 1 then
    wait(2)
    self.room:send("Belial says in common, 'Once more must we play this game?'")
    self.room:send("Belial says in common, 'By now, you know you can't defeat a crowned Prince of the Nines.'")
elseif banter == 2 then
    wait(2)
    self.room:send("Belial says in common, 'How I tired of this foolishness...'")
    self.room:send("Belial says in common, 'You are but a gnat to be squished forthwith.'")
elseif banter == 3 then
    wait(2)
    self.room:send("Belial says in common, 'It will be pleasure to show you unimaginable pain once more!")
elseif banter == 4 then
    wait(2)
    self.room:send("Belial says in common, 'Your death will be as meaningless as your pathetic life!'")
elseif banter == 5 then
    wait(2)
    self.room:send("Belial says in common, 'I grow weary of your intrusions...'")
    self.room:send("Belial says in common, 'This time I shaill see you stay dead!'")
elseif banter == 6 then
    wait(2)
    self.room:send("Belial says in common, 'The Nine Hells take thee...'")
    self.room:send("Belial says in common, 'For your soul now belongs to me!'")
else
    wait(2)
    self.room:send("Belial says in common, 'Your life ends here!'")
end
local belial = self.room:find_actor("belial")
if belial and victim then
    belial:command("kill " .. victim.name)
end