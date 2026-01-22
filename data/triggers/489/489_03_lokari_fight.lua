-- Trigger: lokari fight
-- Zone: 489, ID: 3
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #48903

-- Converted from DG Script #48903: lokari fight
-- Original: MOB trigger, flags: FIGHT, probability: 100%
-- Cast stone skin on self if not already active
if not (self:has_effect(Effect.Stone)) then
    spells.cast(self, "stone skin", self, 100)
end
combat.rescue(self, self.room:find_actor("maid-rogue"))
combat.rescue(self, self.room:find_actor("maid-sorcerer"))
combat.rescue(self, self.room:find_actor("maid-cleric"))
if actor.id ~= -1 then
    if world.count_mobiles("48915") then
        self.room:find_actor("maid-rogue"):command("assist lok")
    end
    if world.count_mobiles("48922") then
        self.room:find_actor("maid-sorcerer"):command("assist lok")
    end
    if world.count_mobiles("48923") then
        self.room:find_actor("maid-cleric"):command("assist lok")
    end
end
local mode = random(1, 100)
wait(1)
if mode < 16 then
    -- 15% chance of echoes of justice, 300-400 damage
    run_room_trigger(48905)
elseif mode < 31 then
    -- 15% chance to throw a player into another player
    run_room_trigger(48906)
elseif mode < 51 then
    -- 20% chance to hear praises, heal 700-1000
    local amount = 500 + random(1, 300)
    self.room:send("<b:yellow>A chorus of praise echoes through the cell, bolstering Lokari's pride!</>")
    self.room:find_actor("lokari"):heal(amount)
elseif (0) and (mode < 40) and actor and (actor.id ~= -1) then
    -- Temporarily disabled until I figure out wth mdamage
    -- doesn't work on mobs.
    -- 5% chance for foreknowledge: mob instadeath
    self:emote("waves a hand in the air.")
    self.room:send_except(actor, "<cyan>Ghostly images appear in the air, foretelling " .. tostring(actor.name) .. "'s death!</>")
    actor:send("<cyan>Ghostly images appear in the air, foretelling your death!</>")
    wait(1)
    if actor and (actor.room ~= self.room) then
        -- Bring back the victim if he/she has left the room
        actor:teleport(get_room(vnum_to_zone(self.room), vnum_to_local(self.room)))
    end
    if actor then
        self.room:send("<b:cyan>Lokari's prophecy comes to pass!</>")
        actor:damage(5000)  -- type: physical
    end
end