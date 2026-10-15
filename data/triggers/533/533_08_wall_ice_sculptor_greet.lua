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
-- The step, element and weapon come from the LOAD trigger 002_111 through `globals`.

wait(1)
local wand_quest = (globals.type or "type") .. "_wand"
if globals.wandstep and actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = (globals.wandstep - 1) * 10
    if actor.level >= minlevel then
        if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
            self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            actor:set_quest_var(wand_quest, "greet", 1)
        else
            self:say("Do you have what I need for the wand?")
        end
        wait(1)
    end
end
local stage = actor:get_quest_stage("wall_ice")
if stage == 0 then
    if actor.class and string.find(actor.class, "cryomancer") and actor.level > 56 then
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
