-- Trigger: wall_ice_sculptor_greet
-- Zone: 533, ID: 8
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #53308
--
-- Greeting behavior for the wall ice sculptor:
--  * If the player is in the wand-typing quest at stage "wandstep" and
--    is high enough level, prompt them about upgrades.
--  * If the player is eligible for the wall_ice quest (cryomancer,
--    level > 56) and has not started, recruit them.
--  * If they are mid-quest, ask whether they have the remaining blocks.
--
-- TODO: 'wandstep' on line "(wandstep - 1) * 10" is a bare global from
-- the DG conversion. The DG original used %wandstep% which referred to
-- a quest variable storing the current step number. Confirm the correct
-- quest var name (likely actor:get_quest_var("type_wand:wandstep")) and
-- replace the stub below.

wait(1)
if actor:get_quest_stage("type_wand") == "wandstep" then
    local wandstep = tonumber(actor:get_quest_var("type_wand:wandstep")) or 0
    local minlevel = (wandstep - 1) * 10
    if actor.level >= minlevel then
        if actor:get_quest_var("type_wand:greet") == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            actor:set_quest_var("type_wand", "greet", 1)
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("wall_ice")
if stage == 0 then
    if actor.class and string.find(actor.class, "Cryomancer") and actor.level > 56 then
        self:command("wave")
        self:say("Hey, you there, you look like a capable cryomancer!  Lend me a hand with this wall, will ya?")
        wait(2)
        self:say("We had a few nasty surprises with creatures slipping out from Frost Valley.  So Suralla sent me over to reinforce the wall blocking off the tunnel.")
        wait(2)
        self:say("I ran out of supplies and my spells can't make permanent walls.  Can you help me get more ice for the wall?")
    end
elseif stage == 1 then
    local ice = 20 - (tonumber(actor:get_quest_var("wall_ice:blocks")) or 0)
    if ice > 1 then
        self:say("Do you have the " .. tostring(ice) .. " remaining blocks of ice?")
    elseif ice == 1 then
        self:say("Do you have the last remaining block of ice?")
    end
end
