-- Trigger: blur_cheetah_death
-- Zone: 18, ID: 30
-- Type: MOB, Flags: DEATH
-- Status: CLEAN
--
-- Original DG Script: #1830

-- Converted from DG Script #1830: blur_cheetah_death
-- Original: MOB trigger, flags: DEATH, probability: 100%
-- TODO(parity): legacy 5-digit room vnum 4236 was the West Wind's lair —
-- needs translation to the composite (zone_id, local_id). Verify the correct
-- composite and replace get_room(42, 36) below if mapping differs.
local lair = get_room(42, 36)
local lair_name = lair and lair.name or "the West Wind's lair"
local cheetah_name = mobiles.template(18, 22).name
for _, person in ipairs(self.room.actors) do
    if (person:get_quest_stage("blur") == 4) and (not person:get_quest_var("blur:west")) then
        person:send("<b:white>" .. tostring(cheetah_name) .. " says, 'Well that was fun!</>")
        person:send("</><b:white>Now see if you can reach <b:cyan>" .. tostring(lair_name) .. "</><b:white> before I do!'</>")
        person:send(tostring(cheetah_name) .. " blasts away into the sky!")
        person:set_quest_var("blur", "west", 1)
    end
end