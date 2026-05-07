-- Trigger: lokari fight
-- Zone: 489, ID: 3
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Lokari's combat AI: rescues each of his maids when they're being hit, lets
-- the maids assist him, then rolls a single d100 for one of three signature
-- abilities (echoes-of-justice AOE / throw-player smash / morale heal). The
-- foreknowledge instadeath branch is gated off until mdamage works on mobs.

-- TODO(parity): the original DG had Lokari issue 'stone' to the sorcerer when
-- he wasn't already stoneskinned, triggering trigger 10. The converter dropped
-- that branch (left an UNCONVERTED stub which we removed). Re-add when the
-- runtime exposes actor commands cleanly here.
combat.rescue(self, self.room:find_actor("maid-rogue"))
combat.rescue(self, self.room:find_actor("maid-sorcerer"))
combat.rescue(self, self.room:find_actor("maid-cleric"))
if actor.is_npc then
    if world.count_mobiles(489, 15) > 0 then
        self.room:find_actor("maid-rogue"):command("assist lok")
    end
    if world.count_mobiles(489, 22) > 0 then
        self.room:find_actor("maid-sorcerer"):command("assist lok")
    end
    if world.count_mobiles(489, 23) > 0 then
        self.room:find_actor("maid-cleric"):command("assist lok")
    end
end
local mode = random(1, 100)
wait(1)
if mode < 16 then
    -- 15% chance of echoes of justice, 300-400 damage
    run_room_trigger(489, 5)
elseif mode < 31 then
    -- 15% chance to throw a player into another player
    run_room_trigger(489, 6)
elseif mode < 51 then
    -- 20% chance to hear praises, heal 700-1000
    local amount = 500 + random(1, 300)
    self.room:send("<b:yellow>A chorus of praise echoes through the cell, bolstering Lokari's pride!</>")
    self.room:find_actor("lokari"):heal(amount)
elseif false and (mode < 40) and actor and (actor.is_npc) then
    -- Temporarily disabled until I figure out wth mdamage
    -- doesn't work on mobs.
    -- 5% chance for foreknowledge: mob instadeath
    self:emote("waves a hand in the air.")
    self.room:send_except(actor, "<cyan>Ghostly images appear in the air, foretelling " .. tostring(actor.name) .. "'s death!</>")
    actor:send("<cyan>Ghostly images appear in the air, foretelling your death!</>")
    wait(1)
    if actor and (actor.room ~= self.room) then
        -- Bring back the victim if he/she has left the room
        actor:teleport(self.room)
    end
    if actor then
        self.room:send("<b:cyan>Lokari's prophecy comes to pass!</>")
        actor:damage(5000)  -- type: physical
    end
end