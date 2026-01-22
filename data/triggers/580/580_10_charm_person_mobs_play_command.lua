-- Trigger: charm_person_mobs_play_command
-- Zone: 580, ID: 10
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 9 if statements
--   Large script: 5013 chars
--
-- Original DG Script: #58010

-- Converted from DG Script #58010: charm_person_mobs_play_command
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: play
if not (cmd == "play") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("charm_person") ~= 4 then
    _return_value = false
    return _return_value
end
-- switch on arg
if self.id ~= 3010 then
    if arg == "mandolin" then
        _return_value = false
        return _return_value
    elseif actor:get_quest_stage("charm_person") == 4 and self.id ==3010 and (actor:has_equipped("48925") or actor:has_item("48925")) then
        actor:send("You strum a beautiful tune on the mandolin.")
        self.room:send_except(actor, tostring(actor.name) .. " strums a beautiful tune on the mandolin.")
        wait(2)
        self.room:send(tostring(self.name) .. " hums along dreamily.")
        actor.name:set_quest_var("charm_person", "charm1", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = false
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 58017 and (actor:has_equipped("37012") or actor:has_item("37012")) then
    elseif arg == "flute" then
        actor:send("You play a melodious tune on the flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a melodious tune on the flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " blushes furiously.")
        actor.name:set_quest_var("charm_person", "charm2", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    elseif actor:get_quest_stage("charm_person") == 4 and self.id == 58406 and (actor:has_equipped("41119") or actor:has_item("41119")) then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor.name:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = false
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 4353 and (actor:has_equipped("16312") or actor:has_item("16312")) then
    elseif arg == "pipe" then
        actor:send("You blow a wistful melody on the pipe.")
        self.room:send_except(actor, tostring(actor.name) .. " blows a wistful melody on the pipe.")
        wait(2)
        self.room:send(tostring(self.name) .. " closes her eyes and smiles.")
        actor.name:set_quest_var("charm_person", "charm3", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = false
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 23721 and (actor:has_equipped("58017") or actor:has_item("58017")) then
    elseif arg == "biwa" then
        actor:send("You pluck out a strange, complex arrangement on the biwa.")
        self.room:send_except(actor, tostring(actor.name) .. " plucks out a strange, complex arrangement on the biwa.")
        wait(2)
        self.room:send(tostring(self.name) .. " burbles with contentment.")
        actor.name:set_quest_var("charm_person", "charm4", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = false
        return _return_value
    end
    if actor:get_quest_stage("charm_person") == 4 and self.id == 58406 and (actor:has_equipped("41119") or actor:has_item("41119")) then
    elseif arg == "sea" or arg == "seas" then
        actor:send("You play a haunting, dulcet tune on the Sea's Flute.")
        self.room:send_except(actor, tostring(actor.name) .. " plays a haunting, dulcet tune on the Sea's Flute.")
        wait(2)
        self.room:send(tostring(self.name) .. " sighs with nostalgia and longing.")
        actor.name:set_quest_var("charm_person", "charm5", 1)
        actor:send("<b:magenta>" .. tostring(self.name) .. " is charmed by your playing!</>")
    else
        _return_value = false
        return _return_value
    end
else
    _return_value = false
end
if actor:get_quest_var("charm_person:charm1") and actor:get_quest_var("charm_person:charm2") and actor:get_quest_var("charm_person:charm3") and actor:get_quest_var("charm_person:charm4") and actor:get_quest_var("charm_person:charm5") then
    wait(4)
    actor:send("Your skill in charming has greatly improved!")
    actor:send("Hinazuru's training has paid off!")
    actor.name:complete_quest("charm_person")
    actor:send("<b:magenta>You have learned Charm Person!</>")
    skills.set_level(actor.name, "charm person", 100)
end
return _return_value