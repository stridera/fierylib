-- Trigger: khysan-greet
-- Zone: 103, ID: 9
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #10309
-- Greets returning players (any active ice_shards quest stage or
-- the actor mid wand-upgrade quest at this step) with a "Welcome
-- back" line; otherwise gives the new-arrival pitch and, for high-
-- level cryomancers, drops a hint about an unknown spell.
--
-- TODO(parity): the original referenced DG context globals
-- `%type%` and `%wandstep%` (resolved by the wand-quest framework
-- elsewhere in the legacy lib). Those globals are not part of the
-- runtime trigger context and the converter could not infer them,
-- so the wand-related branches are gated on a `wandstep` runtime
-- global which is currently nil. They become inert until the
-- wand framework is ported.

local ice_stage = actor:get_quest_stage("ice_shards")
local wand_stage = actor:get_quest_stage("type_wand")

local seen_before = false
if ice_stage and ice_stage > 0 then
    seen_before = true
end
if wandstep and wand_stage > wandstep then
    seen_before = true
end
if wandstep and wand_stage == wandstep and actor:get_quest_var("type_wand:greet") == 1 then
    seen_before = true
end

wait(1)
actor:send(self.name .. " looks up at your approach.")

if seen_before then
    self:say("Welcome back my friend.")
    wait(2)
    if ice_stage and ice_stage > 0 and not actor:get_has_completed("ice_shards") then
        self:say("Did you find any more clues?")
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            wait(1)
            if actor.level >= minlevel then
                if actor:get_quest_var("type_wand:greet") == 0 then
                    self:say("Or is there something else that brings you back?")
                else
                    self:say("Or do you have what I need for a new staff?")
                end
            end
        end
    else
        if wandstep and wand_stage == wandstep then
            local minlevel = (wandstep - 1) * 10
            if actor.level >= minlevel then
                if actor:get_quest_var("type_wand:greet") == 0 then
                    self:say("Is there something else that brings you back?")
                else
                    self:say("Do you have what I need for a new staff?")
                end
            end
        end
    end
else
    self.room:send(self.name .. " smiles warmly and says, 'Welcome to Phoenix Feather Resort.'")
    wait(1)
    self:say("We are currently offering free services to all adventurers.")
    wait(1)
    self:command("bow " .. actor.name)
    self:say("Please enjoy your stay.  You may enter the hot springs to the south.")
    if wandstep and wand_stage == wandstep then
        wait(1)
        local minlevel = (wandstep - 1) * 10
        if actor.level >= minlevel and actor:get_quest_var("type_wand:greet") == 0 then
            self.room:send(self.name .. " says, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
        end
    end
    if not (ice_stage and ice_stage > 0) then
        wait(3)
        if string.find(actor.class, "Cryomancer") then
            if actor:get_has_completed("major_globe_spell")
               and actor:get_has_completed("relocate_spell_quest")
               and actor:get_has_completed("wall_ice")
               and actor:get_has_completed("waterform")
               and actor:get_has_completed("flood") then
                self:say("Oh, " .. actor.name .. " " .. tostring(actor.title) .. "!  I've heard of you!  You're quite talked about amongst our fellow cryomancers.")
                if actor.level > 88 then
                    self.room:send("</>")
                    self:say("Makes me wonder if you could have mastered the most powerful cryomantic spell ever known.")
                end
            end
        end
    end
end
