-- Trigger: Major Globe Lirne receive 1
-- Zone: 534, ID: 65
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #53465

-- Converted from DG Script #53465: Major Globe Lirne receive 1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("major_globe_spell")
if stage == 5 then
    actor.name:advance_quest("major_globe_spell")
    local room = random(1, 5)
    -- switch on room
    -- Haunted House
    if room == 1 then
        local room = 16903
        -- Tower in the Wastes
    elseif room == 2 then
        local room = 12553
        -- Mystwatch
    elseif room == 3 then
        local room = 16063
        -- Abbey
    elseif room == 4 then
        local room = 18582
        -- Sunken
    elseif room == 5 then
        local room = 53079
        -- Sunken
    else
        local room = 53078
    end
    actor.name:set_quest_var("major_globe_spell", "room", room)
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
    _return_value = false
    self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Perhaps you should do the steps of this quest in order.  Go talk to Earle.'")
elseif stage > 5 then
    wait(1)
    self:destroy_item("majorglobe-salve")
    actor:send(tostring(self.name) .. " says, 'But... you've already given me this.  I'm healed already.'")
end
return _return_value