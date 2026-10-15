-- Trigger: luchiaans_greeting
-- Zone: 510, ID: 3
-- Type: MOB, Flags: GREET
--
-- Original DG Script: #51003
-- On greet, Luchiaans reacts to the player's class and quest progress:
--   - Necromancers / Sorcerers (magequest < 2): offers a partnership.
--   - Warriors: sizes them up as future zombie stock.
--   - Clerics / Priests (clericquest < 2): asks to learn healing spells.
local magequest = globals.magequest or 0
local clericquest = globals.clericquest or 0
if actor.is_player and actor.level < 100 then
    if (string.find(actor.class, "necromancer") or string.find(actor.class, "sorcerer")) and magequest < 2 then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "You and I could be partners in this, if you want? I could use an extra pair of hands.")
    end
    if string.find(actor.class, "warrior") then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self:command("poke " .. tostring(actor.name))
        self:say("Hmm... not bad stock for my experiments.  I may save your corpse.")
        self:emote("grins diabolically.")
        self:command("cackle")
    end
    if (string.find(actor.class, "cleric") or string.find(actor.class, "priest")) and clericquest < 2 then
        wait(0.5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "Can you teach me some of your healing spells?")
        self:whisper(actor.name, "I may have a need for the theory of regeneration.")
    end
end