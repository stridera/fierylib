-- Trigger: telescope_subquest_receive
-- Zone: 492, ID: 56
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #49256

-- Converted from DG Script #49256: telescope_subquest_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
-- Check for proper actor stage and item
if object.id == 53424 then
    if actor:get_quest_stage("relocate_spell_quest") == 4 then
        wait(10)
        actor:send("The observer tells you, 'Thank you so much, you have recovered the lost globe!'")
        self:command("thank " .. tostring(actor.name))
        self:command("rem telescope")
        actor:send("The observer tells you, 'Here, you may now have my Crystal Telescope.'")
        self:command("give telescope " .. tostring(actor.name))
        actor.name:advance_quest("relocate_spell_quest")
        self:command("bow " .. tostring(actor.name))
        self.room:send("The observer leaves down.")
        world.destroy(self.room:find_actor("globe"))
        world.destroy(self.room:find_actor("observer"))
        return _return_value
    else
        wait(10)
        self:command("eyebrow " .. tostring(actor.name))
        actor:send("The observer tells you, 'Yes, this is what I seek, but how did you come by it?")
        actor:send("</>Only the one that did retrieve the glass for me can be rewarded!'")
        self.room:send_except(actor, "The observer questions " .. tostring(actor.name) .. " harshly.")
        self:command("junk snow-globe")
    end
else
    _return_value = false
    wait(2)
    actor:send("The observer tells you, 'This isn't my globe!'")
    actor:send("The observer returns your item to you.")
    self.room:send_except(actor, "The observer refuses " .. tostring(obj.shortdesc) .. " from " .. tostring(actor.name) .. ".")
end
return _return_value