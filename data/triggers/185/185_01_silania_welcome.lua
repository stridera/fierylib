-- Trigger: silania_welcome
-- Zone: 185, ID: 1
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 13 if statements
--
-- Original DG Script: #18501

-- Converted from DG Script #18501: silania_welcome
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(2)
-- switch on actor:get_quest_stage("pri_pal_subclass")
if actor:get_quest_stage("pri_pal_subclass") == 1 then
    actor:send(tostring(self.name) .. " says, 'You've returned!  Let's talk about your <b:cyan>quest</>.'")
elseif actor:get_quest_stage("pri_pal_subclass") == 2 or actor:get_quest_stage("pri_pal_subclass") == 3 then
    actor:send(tostring(self.name) .. " says, 'Have you returned with the bronze chalice the diabolists stole?'")
else
    if string.find(actor.class, "Warrior") then
        -- switch on actor.race
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            local classgreet = "no"
        else
            local classgreet = "yes"
            local maxlevel = 25
        end
    elseif string.find(actor.class, "Cleric") then
        -- switch on actor.race
        if actor.race == "drow" or actor.race == "faerie_unseelie" then
            local classgreet = "no"
        else
            local classgreet = "yes"
            local maxlevel = 35
        end
    end
    if classgreet == "yes" then
        if actor.level >= 10 and actor.level <= maxlevel then
            actor:send(tostring(self.name) .. " says, 'Some know not of their <b:cyan>destinies</>, others simply choose to ignore them.  Which of the two are you?'")
            wait(2)
            self:command("ponder " .. tostring(actor.name))
        end
    end
    -- TODO: Phase wand quest integration needs proper variable names
    -- Original used undefined variables: type_wand, wandstep, weapon
    if actor:get_quest_stage("phase_mace") == "macestep" then
        local minlevel = macestep * 10
        if actor.level >= minlevel then
            if actor:get_quest_var("phase_mace:greet") == 0 then
                actor:send(tostring(self.name) .. " says, 'I sense a ghostly presence about your weapons.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " says, 'Do you have what I need?'")
            end
        end
    end
end  -- auto-close block