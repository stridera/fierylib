-- Trigger: dragons_health_myorrhed_bribe
-- Zone: 586, ID: 3
-- Type: MOB, Flags: BRIBE
-- Status: NEEDS_REVIEW
--   Complex nesting: 7 if statements
--
-- Original DG Script: #58603

-- Converted from DG Script #58603: dragons_health_myorrhed_bribe
-- Original: MOB trigger, flags: BRIBE, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end
if actor:get_quest_stage("dragons_health") == 5 then
    wait(2)
    self.room:send(tostring(self.name) .. " says, 'Ah, coin itself!  I count:'")
    if platinum then
        self.room:send(tostring(platinum) .. " platinum")
    end
    if gold then
        self.room:send(tostring(gold) .. " gold")
    end
    if silver then
        self.room:send(tostring(silver) .. " silver")
    end
    if copper then
        self.room:send(tostring(copper) .. " copper")
    end
    wait(2)
    self:say("This shall be included in the offerings.")
    self:emote("places the money next to the egg.")
    local hoard = actor:get_quest_var("dragons_health:hoard")
    local wealth = hoard + ((platinum * 1000) + (gold * 100) + (silver * 10) + copper)
    actor.name:set_quest_var("dragons_health", "hoard", wealth)
    local value = actor:get_quest_var("dragons_health:hoard")
    if value >= 10000000 then
        actor.name:advance_quest("dragons_health")
        run_room_trigger(58604)
    else
        local total = (10000000 - value)
        local plat = (total / 1000)
        local gold = ((total / 100) - (plat * 10))
        local silv = ((total / 10) - (plat * 100) - (gold * 10))
        local copp = (total  - (plat * 1000) - (gold * 100) - (silv * 10))
        -- now the price can be reported
        self.room:send(tostring(self.name) .. " says, 'We need " .. tostring(plat) .. " platinum, " .. tostring(gold) .. " gold, " .. tostring(silv) .. " silver, " .. tostring(copp) .. " copper")
        self.room:send("</>more in treasure and coins.'")
    end
else
    self:say("I appreciate the gesture, but I am in no need of money.")
    self:command("give " .. tostring(platinum) .. " platinum " .. tostring(gold) .. " gold " .. tostring(silver) .. " silver " .. tostring(copper) .. " copper " .. tostring(actor.name))
end