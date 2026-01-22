-- Trigger: major_globe_earle_receive_marigold
-- Zone: 534, ID: 64
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53464

-- Converted from DG Script #53464: major_globe_earle_receive_marigold
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if actor:get_quest_stage("major_globe_spell") == 4 then
    -- marigold salve
    wait(1)
    actor.name:advance_quest("major_globe_spell")
    self:destroy_item("marigold-poultice")
    actor:send(tostring(self.name) .. " says, 'Excellent, let me just finish this salve then...'")
    self:emote("begins mixing the items in a clay bowl.")
    wait(2)
    self:emote("recites a short incantation over the bowl.")
    wait(2)
    self:emote("pours the salve into a tiny jar.")
    actor:send(tostring(self.name) .. " says, 'There we are, this will surely cure whatever ails Lirne.'")
    self.room:spawn_object(534, 50)
    self:command("give herbal-salve " .. tostring(actor.name))
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well, don't keep him waiting.  Go, go!'")
end