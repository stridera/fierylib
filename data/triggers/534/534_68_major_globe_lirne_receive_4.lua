-- Trigger: Major Globe Lirne receive 4
-- Zone: 534, ID: 68
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53468

-- Converted from DG Script #53468: Major Globe Lirne receive 4
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 10 then
    if actor:get_quest_var("major_globe_spell:final_item") == object.id then
        wait(1)
        self:destroy_item("majorglobe-channel")
        skills.set_level(actor.name, "major globe", 100)
        self:emote("grins excitedly.")
        actor:send(tostring(self.name) .. " says, 'Yes!  Now I can cast the spell... and defeat the demon!'")
        self:emote("holds the wards in one hand.")
        wait(2)
        actor:send(tostring(self.name) .. " starts casting <b:yellow>'major globe'</>...")
        wait(2)
        self:emote("completes his spell...")
        self:emote("closes his eyes and utters the words, 'wiyaf travo'.")
        self.room:send("<b:red>A shimmering globe of force wraps around " .. tostring(self.name) .. "'s body.</>")
        wait(2)
        self:command("smile")
        actor:send(tostring(self.name) .. " says, 'I feel much better too!  My sincerest thanks for your help.  As thanks, I offer you knowledge of this ancient spell also.'")
        wait(1)
        actor:send(tostring(self.name) .. " stares at you and utters a quick incantation.")
        actor:send("<b:white>You feel your skill in spell knowledge improving!</>")
        self.room:send_except(actor, tostring(self.name) .. " stares at " .. tostring(actor.name) .. " and utters a quick incantation.")
        wait(1)
        actor.name:complete_quest("major_globe_spell")
        wait(1)
        actor:send(tostring(self.name) .. " says, 'Now I must take my leave.  Wish me well!'")
        self:emote("hurries out of the room.")
        self:teleport(get_room(11, 0))
        world.destroy(self)
    else
        local response = "This isn't what the spell calls for..."
    end
elseif stage < 10 then
    local response = "I'm not ready for that yet.  Do the quest in the right order."
end
if response then
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, '" .. tostring(response) .. "'")
end
return _return_value