-- Trigger: Dark pixies torment brownie
-- Zone: 120, ID: 7
-- Type: WORLD, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #12007

-- Converted from DG Script #12007: Dark pixies torment brownie
-- Original: WORLD trigger, flags: RANDOM, probability: 60%

-- 60% chance to trigger
if not percent_chance(60) then
    return true
end
local brownie = self.room:find_actor("haggard-brownie")
local tormentor = self.room:find_actor("dark-pixie-tormentor")
if brownie and tormentor then
    local r1 = random(1, 5)
    if r1 == 1 then
        tormentor:emote("hisses, 'Where is your forest magic now, tree-turd?'")
    elseif r1 == 2 then
        tormentor:emote("growls, 'Tell us why you intrude, clod... and we may slay you swiftly.'")
    elseif r1 == 3 then
        tormentor:emote("swiftly kicks the haggard brownie in the kidney.")
    elseif r1 == 4 then
        tormentor:emote("hisses, 'You sicken me, dirty-skin.'")
    else
        self.room:send("Snap!  A dark pixie raises another welt on the haggard brownie's arm.")
    end
    wait(8)
    local r2 = random(1, 4)
    if r2 == 1 then
        brownie:emote("whimpers piteously.")
    elseif r2 == 2 then
        brownie:emote("glares resentfully at a dark pixie.")
    elseif r2 == 3 then
        brownie:emote("bites his lip, though a tear seems to be forming in his eye.")
    else
        brownie:emote("covers his head with his arms, moaning, 'No!'")
    end
end