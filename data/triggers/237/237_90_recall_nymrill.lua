-- Trigger: recall_nymrill
-- Zone: 237, ID: 90
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #23790

-- Converted from DG Script #23790: recall_nymrill
-- Original: OBJECT trigger, flags: COMMAND, probability: 2%
-- Black potion of recall. On 2% of quaffs, evil-aligned drinkers (alignment
-- <= -350) recall to a class-appropriate Nymrill room and the potion is
-- consumed. Other drinkers get a flavor message and the quaff proceeds.
-- TODO(parity): the "non-evil" branch re-issues `quaff black-potion-recall`
-- via actor:command() while also blocking the original command. This will
-- re-fire this trigger (with another 2% roll) -- preserved from the
-- original DG script but likely unintentional.

-- 2% chance to intercept this quaff at all.
if not percent_chance(2) then
    return true
end

-- Command filter: quaff
if cmd ~= "quaff" then
    return true  -- Not our command
end

if not actor.is_player then
    actor:command("quaff black-potion-recall")
    return false
end

if actor.alignment <= -350 then
    actor:send("You quaff a potion and begin to feel a little light-headed...")
    self.room:send_except(actor, tostring(actor.name) .. " quaffs a black potion of recall.")
    self.room:send_except(actor, tostring(actor.name) .. " disappears in a flash of darkness!")
    if string.find(actor.class, "Thief") or string.find(actor.class, "Assassin") or string.find(actor.class, "Mercenary") or string.find(actor.class, "Rogue") then
        actor:teleport(get_room(495, 25))
    elseif string.find(actor.class, "Sorcerer") or string.find(actor.class, "Cryomancer") or string.find(actor.class, "Pyromancer") then
        actor:teleport(get_room(495, 22))
    elseif string.find(actor.class, "Necromancer") then
        actor:teleport(get_room(495, 14))
    else
        actor:teleport(get_room(495, 12))
    end
    actor:command("look")
    world.destroy(self)
    return false
end

actor:send("As you quaff a potion, you get a funny burning sensation in your stomach...")
actor:command("quaff black-potion-recall")
return false