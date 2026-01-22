-- Trigger: Ill-subclass: Load the choker
-- Zone: 172, ID: 11
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #17211

-- Converted from DG Script #17211: Ill-subclass: Load the choker
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if actor:get_quest_stage("illusionist_subclass") == 4 then
    actor.name:advance_quest("illusionist_subclass")
    actor.name:advance_quest("illusionist_subclass")
    local obj = self.objects
    local chokerpresent = 0
    while obj do
        if obj.id == 17214 then
            local chokerpresent = 1
        end
        local obj = obj.next_in_room
    end
    if chokerpresent == 0 then
        self.room:spawn_object(172, 14)
    end
end