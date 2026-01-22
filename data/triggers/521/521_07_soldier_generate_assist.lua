-- Trigger: Soldier_Generate_Assist
-- Zone: 521, ID: 7
-- Type: MOB, Flags: FIGHT
-- Status: CLEAN
--
-- Original DG Script: #52107

-- Converted from DG Script #52107: Soldier_Generate_Assist
-- Original: MOB trigger, flags: FIGHT, probability: 6%

-- 6% chance to trigger
if not percent_chance(6) then
    return true
end
local soldiers = loaded + 1
if kids < 6 then
    local rnd = room.actors[random(1, #room.actors)]
    self.room:send("The Platinum Knight lets out a horrid SCREAM!")
    wait(2)
    self:emote("starts to hum a strange mantra.")
    wait(2)
    self.room:send("A Bright flash of light fills the room and two soldiers crawl forth through it.")
    self.room:spawn_mobile(521, 18)
    self.room:spawn_mobile(521, 18)
    if rnd.id == -1 then
        self.room:find_actor("soldier"):command("hit %rnd.name%")
    else
        self.room:find_actor("dragon"):command("hit %actor.name%")
    end
    local loaded = kids
    globals.loaded = globals.loaded or true
end