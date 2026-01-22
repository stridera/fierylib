-- Trigger: wall_ice_sculptor_greet
-- Zone: 533, ID: 8
-- Type: MOB, Flags: GREET
-- Status: CLEAN
-- Fixed: Removed broken phase wand upgrade code (handled by generic trigger 003)
--
-- Original DG Script: #53308

-- Converted from DG Script #53308: wall_ice_sculptor_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
-- Note: Phase wand upgrade greet logic removed - handled by generic phase wand triggers
local stage = actor:get_quest_stage("wall_ice")
if stage == 0 then
    if string.find(actor.class, "Cryomancer") and actor.level > 56 then
        self:command("wave")
        self:say("Hey, you there, you look like a capable cryomancer!  Lend me a hand with this wall, will ya?")
        wait(2)
        self:say("We had a few nasty surprises with creatures slipping out from Frost Valley.  So Suralla sent me over to reinforce the wall blocking off the tunnel.")
        wait(2)
        self:say("I ran out of supplies and my spells can't make permanent walls.  Can you help me get more ice for the wall?")
    end
elseif stage == 1 then
    local ice = (20 - actor:get_quest_var("wall_ice:blocks"))
    if ice > 1 then
        self:say("Do you have the " .. tostring(ice) .. " remaining blocks of ice?")
    elseif ice == 1 then
        self:say("Do you have the last remaining block of ice?")
    end
end