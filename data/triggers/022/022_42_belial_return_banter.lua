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
local victim = self.room.actors[random(1, #self.room.actors)]
-- switch on banter
do
    local _sw1 = string.lower(tostring(banter or ""))
    if tonumber(_sw1) == 1 then
        wait(2)
        self.room:send("Belial says in common, 'Once more must we play this game?'")
        self.room:send("Belial says in common, 'By now, you know you can't defeat a crowned Prince of the Nines.'")
    elseif tonumber(_sw1) == 2 then
        wait(2)
        self.room:send("Belial says in common, 'How I tired of this foolishness...'")
        self.room:send("Belial says in common, 'You are but a gnat to be squished forthwith.'")
    elseif tonumber(_sw1) == 3 then
        wait(2)
        self.room:send("Belial says in common, 'It will be pleasure to show you unimaginable pain once more!")
    elseif tonumber(_sw1) == 4 then
        wait(2)
        self.room:send("Belial says in common, 'Your death will be as meaningless as your pathetic life!'")
    elseif tonumber(_sw1) == 5 then
        wait(2)
        self.room:send("Belial says in common, 'I grow weary of your intrusions...'")
        self.room:send("Belial says in common, 'This time I shaill see you stay dead!'")
    elseif tonumber(_sw1) == 6 then
        wait(2)
        self.room:send("Belial says in common, 'The Nine Hells take thee...'")
        self.room:send("Belial says in common, 'For your soul now belongs to me!'")
    else
        wait(2)
        self.room:send("Belial says in common, 'Your life ends here!'")
    end
end
self.room:find_actor("belial"):command("kill " .. tostring(victim.name))