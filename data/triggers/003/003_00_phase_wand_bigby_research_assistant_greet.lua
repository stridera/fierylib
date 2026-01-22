-- Trigger: phase wand bigby research assistant greet
-- Zone: 3, ID: 0
-- Type: MOB, Flags: GREET_ALL
-- Status: NEEDS_REVIEW
--   Complex nesting: 15 if statements
--
-- Original DG Script: #300

-- Converted from DG Script #300: phase wand bigby research assistant greet
-- Original: MOB trigger, flags: GREET_ALL, probability: 100%
if self:has_effect(Effect.Invisible) then
    self:command("vis")
end
wait(2)
local air = actor:get_quest_stage("air_wand")
local airgreet = actor:get_quest_var("air_wand:greet")
local fire = actor:get_quest_stage("fire_wand")
local firegreet = actor:get_quest_var("fire_wand:greet")
local ice = actor:get_quest_stage("ice_wand")
local icegreet = actor:get_quest_var("ice_wand:greet")
local acid = actor:get_quest_stage("acid_wand")
local acidgreet = actor:get_quest_var("acid_wand:greet")
if air > 2 or fire > 2 or ice > 2 or acid > 2 or airgreet or firegreet or icegreet or acidgreet then
    self:say("Ah, welcome back " .. tostring(actor.name) .. "!")
    wait(2)
end
if string.find(actor.class, "sorcerer") or string.find(actor.class, "pyromancer") or string.find(actor.class, "cryomancer") or string.find(actor.class, "illusionist") or string.find(actor.class, "necromancer") then
    if actor.level >= 10 then
        if (actor:has_equipped("300") or actor:has_item("300")) and air < 2 then
            if not air then
                actor:start_quest("air_wand")
            end
            actor:set_quest_var("air_wand", "greet", 1)
            local offer = 1
        elseif air == 2 then
            local continue = 1
        end
        if (actor:has_equipped("310") or actor:has_item("310")) and fire < 2 then
            if not fire then
                actor:start_quest("fire_wand")
            end
            actor:set_quest_var("fire_wand", "greet", 1)
            local offer = 1
        elseif fire == 2 then
            local continue = 1
        end
        if (actor:has_equipped("320") or actor:has_item("320")) and ice < 2 then
            if not ice then
                actor:start_quest("ice_wand")
            end
            actor:set_quest_var("ice_wand", "greet", 1)
            local offer = 1
        elseif ice == 2 then
            local continue = 1
        end
        if (actor:has_equipped("330") or actor:has_item("330")) and acid < 2 then
            if not acid then
                actor:start_quest("acid_wand")
            end
            actor:set_quest_var("acid_wand", "greet", 1)
            local offer = 1
        elseif acid == 2 then
            local continue = 1
        end
        if continue then
            self:say("Have you been practicing and looking for the gems you need?")
            wait(2)
        end
        if offer then
            self.room:send(tostring(self.name) .. " says, 'I see you have a new elemental wand!  I can <b:cyan>upgrade</> basic wands.'")
            wait(2)
        end
        if air > 2 or fire > 2 or ice > 2 or acid > 2 then
            self.room:send(tostring(self.name) .. " says, 'If you want to upgrade a wand again, I can point you in the right direction.  Just tell me which energy type you want to work on: <green>acid</>, <b:white>air</>, <red>fire</>, or <b:blue>ice</>.'")
        end
    end
end