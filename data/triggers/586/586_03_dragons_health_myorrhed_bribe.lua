-- Trigger: dragons_health_myorrhed_bribe
-- Zone: 586, ID: 3
-- Type: MOB, Flags: BRIBE
-- Status: CLEAN
--
-- Original DG Script: #58603
-- Myorrhed accepts coin offerings during the final hoard-building stage of
-- dragons_health (stage 5). At any other stage she returns the coins to the
-- player. The 1% probability matches the original DG trigger.

if not percent_chance(1) then
    return true
end
if actor:get_quest_stage("dragons_health") == 5 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Ah, coin itself!  I count:'")
    if platinum and platinum > 0 then
        self.room:send(tostring(platinum) .. " platinum")
    end
    if gold and gold > 0 then
        self.room:send(tostring(gold) .. " gold")
    end
    if silver and silver > 0 then
        self.room:send(tostring(silver) .. " silver")
    end
    if copper and copper > 0 then
        self.room:send(tostring(copper) .. " copper")
    end
    wait(2)
    self:say("This shall be included in the offerings.")
    self:emote("places the money next to the egg.")
    local hoard = actor:get_quest_var("dragons_health:hoard") or 0
    local wealth = hoard + ((platinum or 0) * 1000) + ((gold or 0) * 100) + ((silver or 0) * 10) + (copper or 0)
    actor:set_quest_var("dragons_health", "hoard", wealth)
    if wealth >= 10000000 then
        actor:advance_quest("dragons_health")
        run_room_trigger(586, 4)
    else
        local total = 10000000 - wealth
        local plat = total // 1000
        local rem_gold = (total // 100) - (plat * 10)
        local silv = (total // 10) - (plat * 100) - (rem_gold * 10)
        local copp = total - (plat * 1000) - (rem_gold * 100) - (silv * 10)
        self.room:send(tostring(self.name) .. " says, 'We need " .. tostring(plat) .. " platinum, " .. tostring(rem_gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper")
        self.room:send("</>more in treasure and coins.'")
    end
else
    self:say("I appreciate the gesture, but I am in no need of money.")
    self:command("give " .. tostring(platinum or 0) .. " platinum " .. tostring(gold or 0) .. " gold " .. tostring(silver or 0) .. " silver " .. tostring(copper or 0) .. " copper " .. tostring(actor.name))
end