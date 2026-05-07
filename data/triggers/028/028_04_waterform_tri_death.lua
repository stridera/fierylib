-- Trigger: waterform_tri_death
-- Zone: 28, ID: 4
-- Type: MOB, Flags: DEATH
-- Status: REVIEWED (group iteration normalized; "yes" string literal fixed)
--
-- Original DG Script: #2804
-- When Tri-Aszp dies, every group member in the same room who is on
-- waterform stage 2 (or who has the cup-replacement flag set) gets a
-- white dragon thigh bone (28:7) and advances to stage 3.
-- TODO: revisit the "waterform:new == yes" branch -- the original DG logic
--       is unclear here; current behavior advances stage on cup-replacement
--       too, which may not be intended.

local function maybe_award(person)
    if person.room ~= self.room then
        return
    end
    local stage = person:get_quest_stage("waterform")
    if stage == 2 or person:get_quest_var("waterform:new") == "yes" then
        self.room:spawn_object(28, 7)
        person:advance_quest("waterform")
    end
end

if actor.group then
    for _, member in ipairs(actor.group) do
        maybe_award(member)
    end
else
    maybe_award(actor)
end
