-- Trigger: Gothra_Old_Man_speech3
-- Zone: 161, ID: 4
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #16104
--
-- When the player mentions "trouble", the old man boasts about his
-- youthful adventures, including catching a giant scorpion -- a hint that
-- pairs with the "scorpion" speech trigger.

-- Speech keyword: trouble
if not string.find(string.lower(speech), "trouble") then
    return true
end
self:command("nod " .. tostring(actor.name))
self:say("Yes I said trouble, kids today, why when I was your age I was taming the realms! And I even caught me a giant scorpion!")
self:command("nod man")