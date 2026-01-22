-- Trigger: luchiaans_greeting
-- Zone: 510, ID: 3
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #51003

-- Converted from DG Script #51003: luchiaans_greeting
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and actor.level < 100 then
    if (string.find(actor.class, "Necromancer") or string.find(actor.class, "Sorcerer")) and magequest < 2 then
        wait(5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "You and I could be partners in this, if you want? I could use an extra pair of hands.")
    end
    if string.find(actor.class, "Warrior") then
        wait(5)
        self:command("ponder")
        wait(2)
        self:command("poke " .. tostring(actor.name))
        self:say("Hmm... not bad stock for my experiments.  I may save your corpse.")
        self:emote("grins diabolically.")
        self:command("cackle")
    end
    if (string.find(actor.class, "Cleric") or string.find(actor.class, "Priest")) and clericquest < 2 then
        wait(5)
        self:command("ponder")
        wait(2)
        self.room:send_except(actor, "Luchiaans leans close to " .. tostring(actor.name) .. ".")
        self:whisper(actor.name, "Can you teach me some of your healing spells?")
        self:whisper(actor.name, "I may have a need for the theory of regeneration.")
    end
end