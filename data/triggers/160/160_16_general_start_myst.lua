-- Trigger: general_start_myst
-- Zone: 160, ID: 16
-- Type: MOB, Flags: RECEIVE
--
-- Mystwatch quest stage 1 → 2: when a player hands the General the totem
-- (object 30,26), advance every co-located group member from "totem" step
-- to "general" step, consume the totem, set the cross-trigger flag
-- `globals.myst_gen_active` so the General's death trigger knows the quest
-- chain is in progress, then taunt and attack the deliverer.
--
-- For non-totem items the General just thanks the player.

if not actor.is_player then
    return true
end

if object.id == 3026 then
    -- Advance any group member who is on the mystwatch_quest and present.
    for i = 1, actor.group_size do
        local person = actor.group_member[i]
        if person and person.room == self.room then
            if person:get_quest_stage("mystwatch_quest") then
                person:set_quest_var("mystwatch_quest", "step", "general")
                person:send("<b:white>You have delivered the totem to the General!</>")
            end
        end
    end

    -- Cross-trigger handshake: the General's DEATH trigger checks this
    -- flag to decide whether to advance the cycle.
    globals.myst_gen_active = true

    wait(1)
    local totem = self.room:find_object("totem")
    if totem then
        world.destroy(totem)
    end
    self.room:send(tostring(self.name) .. " starts to examine the totem which begins to glow and hum.")
    wait(2)
    self:say("So, that fool Magistrate down in the forest town is such a coward that he must send the likes of YOU to do his bidding.")
    wait(2)
    self:say("Well... I shall have to make examples of you all now...")
    self:command("cackle")
    wait(1)
    combat.engage(actor)
else
    wait(1)
    self:say("Thank you, thank you very much.")
end
