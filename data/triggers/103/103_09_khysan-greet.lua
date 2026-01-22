-- Trigger: khysan-greet
-- Zone: 103, ID: 9
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 19 if statements
--
-- Original DG Script: #10309

-- Converted from DG Script #10309: khysan-greet
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor:get_quest_stage("ice_shards") then
    local should_return = "yes"
end
if actor.quest_stage["type_wand"] > wandstep then
    local should_return = "yes"
end
if actor.quest_stage["type_wand"] == "wandstep" and actor.quest_variable["type_wand:greet"] == 1 then
    local should_return = "yes"
end
wait(1)
actor:send(tostring(self.name) .. " looks up at your approach.")
if should_return == "yes" then
    self:say("Welcome back my friend.")
    wait(2)
    if actor:get_quest_stage("ice_shards") and not actor:get_has_completed("ice_shards") then
        self:say("Did you find any more clues?")
        if actor.quest_stage["type_wand"] == "wandstep" then
            local minlevel = (wandstep - 1) * 10
            wait(1)
            if actor.level >= minlevel then
                if actor.quest_variable["type_wand:greet"] == 0 then
                    self:say("Or is there something else that brings you back?")
                else
                    self:say("Or do you have what I need for a new staff?")
                end
            end
        end
    else
        if actor.quest_stage["type_wand"] == "wandstep" then
            local minlevel = (wandstep - 1) * 10
            if actor.level >= minlevel then
                if actor.quest_variable["type_wand:greet"] == 0 then
                    self:say("Is there something else that brings you back?")
                else
                    self:say("Do you have what I need for a new staff?")
                end
            end
        end
    end
else
    self.room:send(tostring(self.name) .. " smiles warmly and says, 'Welcome to Phoenix Feather Resort.'")
    wait(1)
    self:say("We are currently offering free services to all adventurers.")
    wait(1)
    self:command("bow " .. tostring(actor))
    self:say("Please enjoy your stay.  You may enter the hot springs to the south.")
    if actor.quest_stage["type_wand"] == "wandstep" then
        wait(1)
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel then
            if actor.quest_variable["type_wand:greet"] == 0 then
                self.room:send(tostring(self.name) .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            end
        end
    end
    if not actor:get_quest_stage("ice_shards") then
        wait(3)
        if string.find(actor.class, "Cryomancer") then
            if actor:get_has_completed("major_globe_spell") and actor:get_has_completed("relocate_spell_quest") and actor:get_has_completed("wall_ice") and actor:get_has_completed("waterform") and actor:get_has_completed("flood") then
                self:say("Oh, " .. tostring(actor.name) .. " " .. tostring(actor.title) .. "!  I've heard of you!  You're quite talked about amongst our fellow cryomancers.")
                if actor.level > 88 then
                    self.room:send("</>")
                    self:say("Makes me wonder if you could have mastered the most powerful cryomantic spell ever known.")
                end
            end
        end
    end
end