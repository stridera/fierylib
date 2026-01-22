-- Trigger: rock_demon_call_rock
-- Zone: 520, ID: 0
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #52000

-- Converted from DG Script #52000: rock_demon_call_rock
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
wait(1)
self.room:send("The demon has animated some rocks which spin around you!")
wait(1)
local numhits = random(1, 3)
local numhits = numhits + 2
local thishit = 0
while thishit < numhits do
    local dmg = random(1, 50)
    local dmg = dmg + 50
    local rnd = room.actors[random(1, #room.actors)]
    if rnd.id == 52017 then
        self.room:send_except(rnd, "A lump of rock merges with " .. tostring(rnd.name) .. " and he seems stronger! (<yellow>" .. tostring(dmg) .. "</>)")
        rnd:send("You absorb strength from the rock! (<yellow>" .. tostring(dmg) .. "</>)")
        rnd:heal(dmg)
    else
        if rnd:get_quest_stage("meteorswarm") == 2 or rnd:get_quest_var("meteorswarm:new") ~= "yes" then
            if rnd:get_quest_stage("meteorswarm") == 2 then
                rnd:advance_quest("meteorswarm")
            elseif rnd:get_quest_var("meteorswarm:new") ~= "yes" then
                rnd:set_quest_var("meteorswarm", "new", "no")
            end
            self.room:spawn_object(482, 52)
            rnd:send("<b:red>A flaming meteor shoots off the towering rock demon,</>")
            rnd:send("<b:red>soars through the sky, and begins to fall toward the ground!</>")
            self.room:send_except(rnd, "<b:red>A flaming meteor shoots off the towering rock demon,</>")
            self.room:send_except(rnd, "<b:red>but " .. tostring(rnd.name) .. " catches it!</>")
            rnd:command("get meteorite")
            rnd:send("<b:red>You now have an appropriate focus!</>")
        else
            local damage_dealt = rnd:damage(dmg)  -- type: crush
            if damage_dealt == 0 then
                rnd:send("A lump of rock whizzes right through you!")
                self.room:send_except(rnd, tostring(rnd.name) .. " watches a rock zip right through " .. tostring(rnd.possessive) .. " body.")
            else
                rnd:send("A lump of rock whizzes towards you.  You can't dodge! (<b:red>" .. tostring(damage_dealt) .. "</>)")
                self.room:send_except(rnd, tostring(rnd.name) .. " gets whacked by a lump of flying rock! (<blue>" .. tostring(damage_dealt) .. "</>)")
            end
        end
    end
    local thishit = thishit + 1
end