-- Trigger: Major Globe Lirne receive 1
-- Zone: 534, ID: 65
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53465

-- Converted from DG Script #53465: Major Globe Lirne receive 1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 5 then
    actor:advance_quest("major_globe_spell")
    -- TODO(parity): legacy DG stored a single room vnum in the
    -- `major_globe_spell:room` quest var, then trigger 53455 used
    -- `actor.room == quest_var` to check if the questor was in the right
    -- search room. With composite ids that single integer no longer
    -- identifies a room; consider storing a (zone, id) pair or a packed
    -- value once a quest-var schema is settled. Vnums below: 16903 haunted
    -- house, 12553 tower in the wastes, 16063 mystwatch, 18582 abbey,
    -- 53079 / 53078 sunken (zone 530).
    local roll = random(1, 5)
    local target_vnum
    if roll == 1 then
        target_vnum = 16903
    elseif roll == 2 then
        target_vnum = 12553
    elseif roll == 3 then
        target_vnum = 16063
    elseif roll == 4 then
        target_vnum = 18582
    elseif roll == 5 then
        target_vnum = 53079
    else
        target_vnum = 53078
    end
    actor:set_quest_var("major_globe_spell", "room", target_vnum)
    wait(1)
    self:destroy_item("majorglobe-salve")
    self:command("smile")
    self:emote("sniffs " .. tostring(objects.template(534, 50).name) .. ".")
    actor:send(tostring(self.name) .. " says, 'Smells powerful.'")
    wait(1)
    self:emote("begins spreading the salve across his lesions.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I can feel it working.'")
    self:command("smile")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Well, no time to waste.  The demon still walks the valley.  To defeat it, we will need to combat its magic.'")
    self:command("ponder")
    wait(3)
    actor:send(tostring(self.name) .. " says, 'I think I know a way...  Yes...'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Lore speaks of a spell powerful enough to deflect great magic.'")
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'The spellbook containing the spell was lost, though.  Perhaps you can find it.'")
    wait(3)
    actor:send(tostring(self.name) .. " says, '<b:cyan>Search</> in each <b:cyan>stack</> and <b:cyan>library</>!  Surely it will be found in one of them.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'm sure it still exists...  It must.'")
    wait(5)
    actor:send(tostring(self.name) .. " says, 'Well?  Quickly, now!'")
elseif stage < 5 then
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Perhaps you should do the steps of this quest in order.  Go talk to Earle.'")
elseif stage > 5 then
    wait(1)
    self:destroy_item("majorglobe-salve")
    actor:send(tostring(self.name) .. " says, 'But... you've already given me this.  I'm healed already.'")
end
return true