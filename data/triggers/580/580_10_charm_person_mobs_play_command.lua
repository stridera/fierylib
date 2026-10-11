-- Trigger: charm_person_mobs_play_command
-- Zone: 580, ID: 10
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Intended: when a stage-4 player runs `play <instrument>` in the same
-- room as one of the five master charmers, the charmer reacts and the
-- corresponding charm_person quest_var is set; once all five flags
-- match, the player is granted Charm Person.
--
-- TODO: structure is mangled by the converter. Each charmer/instrument
-- branch is wrapped in an outer `if self.id ~= 3010 then` then mixes
-- empty `if cond then` bodies with `elseif arg == "..."` clauses that
-- chain back to the *outer* if. Result: only the mandolin path is
-- reachable, every other branch is dead. Needs a flat dispatch keyed
-- on (self id, arg).
-- TODO: self.id checks (3010, 58017, 4353, 23721, 58406) and
-- has_equipped/has_item ids ("48925" etc) are legacy vnums. Under
-- composite keys these never match -- update to (zone, local_id).
-- TODO: quest_var keys "charm1".."charm5" here must agree with the
-- progress reader in 580_08, which currently reads "charm_person:charm1"
-- etc. Confirm a single key scheme.

-- Command filter: play
if not (cmd == "play") then
    return true  -- Not our command
end
local _return_value = false  -- Default: block the command (legacy script_driver ret_val = 1)
if actor:get_quest_stage("charm_person") ~= 4 then
    _return_value = true
    return _return_value
end
-- switch on arg
if (self.zone_id ~= 30 or self.id ~= 10) then
    if arg == "mandolin" then
        _return_value = true
        return _return_value
    elseif actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 30 and self.id == 10) and (actor:has_equipped("48925") or actor:has_item("48925")) then
        actor:send("You strum a beautiful tune on the mandolin.")
        self.room:send_except(actor, tostring(actor.name) .. " strums a beautiful tune on the mandolin.")
        wait(2)
        self.room:send(tostring(self.name) .. " hums along dreamily.")
        actor:set_quest_var("charm_person", "charm1", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 580 and self.id == 17) and (actor:has_equipped("37012") or actor:has_item("37012")) then
    elseif arg == "flute" then
        actor:send("You play a melodious tune on the flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a melodious tune on the flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " blushes furiously.")
        actor:set_quest_var("charm_person", "charm2", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    elseif actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 584 and self.id == 6) and (actor:has_equipped("41119") or actor:has_item("41119")) then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 43 and self.id == 53) and (actor:has_equipped("16312") or actor:has_item("16312")) then
    elseif arg == "pipe" then
        actor:send("You blow a wistful melody on the pipe.")
        self.room:send_except(actor, tostring(actor.name) .. " blows a wistful melody on the pipe.")
        wait(2)
        self.room:send(tostring(self.name) .. " closes her eyes and smiles.")
        actor:set_quest_var("charm_person", "charm3", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 237 and self.id == 21) and (actor:has_equipped("58017") or actor:has_item("58017")) then
    elseif arg == "biwa" then
        actor:send("You pluck out a strange, complex arrangement on the biwa.")
        self.room:send_except(actor, tostring(actor.name) .. " plucks out a strange, complex arrangement on the biwa.")
        wait(2)
        self.room:send(tostring(self.name) .. " burbles with contentment.")
        actor:set_quest_var("charm_person", "charm4", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and (self.zone_id == 584 and self.id == 6) and (actor:has_equipped("41119") or actor:has_item("41119")) then
    elseif arg == "sea" or arg == "seas" then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = true
        return _return_value
    end
else
    _return_value = true
end
if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
    wait(4)
    actor:send("Your skill in charming has greatly improved!")
    actor:send("Hinazuru's training has paid off!")
    actor:complete_quest("charm_person")
    actor:send("<b:magenta>You have learned Charm Person!</>")
    skills.set_level(actor, "charm person", 1000)
end
return _return_value