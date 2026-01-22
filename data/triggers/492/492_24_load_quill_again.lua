-- Trigger: load_quill_again
-- Zone: 492, ID: 24
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #49224

-- Converted from DG Script #49224: load_quill_again
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
-- Make sure it doesn't load more than once
if actor:get_quest_stage("relocate_spell_quest") == 8 then
    world.destroy(self.room:find_actor("golden-quill"))
    self.room:spawn_object(492, 51)
end