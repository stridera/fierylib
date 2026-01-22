-- Trigger: major_globe_greet
-- Zone: 534, ID: 50
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #53450

-- Converted from DG Script #53450: major_globe_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if (actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer") and (actor.level >= 57) then
    if actor:get_has_completed("major_globe_spell") then
        return _return_value
    end
    wait(1)
    -- switch on actor:get_quest_stage("major_globe_spell")
    if actor:get_quest_stage("major_globe_spell") == 1 or actor:get_quest_stage("major_globe_spell") == 2 or actor:get_quest_stage("major_globe_spell") == 3 or actor:get_quest_stage("major_globe_spell") == 4 or actor:get_quest_stage("major_globe_spell") == 5 then
        self:emote("coughs fitfully.")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Have you brought me the salve from Earle?'")
        actor:send(tostring(self.name) .. " looks at you pleadingly.")
        self.room:send_except(actor, tostring(self.name) .. " looks at " .. tostring(actor.name) .. " pleadingly.")
    elseif actor:get_quest_stage("major_globe_spell") == 6 or actor:get_quest_stage("major_globe_spell") == 7 then
        actor:send(tostring(self.name) .. " turns to look at you.")
        self.room:send_except(actor, tostring(self.name) .. " turns to look at " .. tostring(actor.name) .. ".")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Welcome back, were you able to find the spellbook?'")
    elseif actor:get_quest_stage("major_globe_spell") == 8 then
        actor:send(tostring(self.name) .. " hops up from his chair as you enter.")
        self.room:send_except(actor, tostring(self.name) .. " hops up from his chair as " .. tostring(actor.name) .. " enters.")
        wait(1)
        actor:send(tostring(self.name) .. " comes limping over to you.")
        self.room:send_except(actor, tostring(self.name) .. " limps over to " .. tostring(actor.name) .. ".")
        local wards_left = 5 - actor:get_quest_var("major_globe_spell:ward_count")
        if wards_left > 1 then
            actor:send(tostring(self.name) .. " says, 'The wards!  The wards!  Do you have them?  We still need " .. tostring(wards_left) .. " of them!")
        else
            actor:send(tostring(self.name) .. " says, 'Just one ward left!  Do you have it?'")
        end
    elseif actor:get_quest_stage("major_globe_spell") == 9 or actor:get_quest_stage("major_globe_spell") == 10 then
        actor:send(tostring(self.name) .. " bounds over to you.")
        self.room:send_except(actor, tostring(self.name) .. " runs over to " .. tostring(actor.name) .. ".")
        wait(1)
        local final_item = actor:get_quest_var("major_globe_spell:final_item")
        actor:send(tostring(self.name) .. " says, 'Do you have " .. "%get.obj_shortdesc[%final_item%]% to channel the power?  Please say you do!'")
    else
        actor:send(tostring(self.name) .. " turns his head to look at you.")
        self.room:send_except(actor, tostring(self.name) .. " turns his head to look at " .. tostring(actor.name) .. ".")
        self:command("cough")
        wait(2)
        actor:send(tostring(self.name) .. " says, 'You're a " .. tostring(actor.class) .. "!  Perhaps you can <b:cyan>assist</> me.'")
    end
end