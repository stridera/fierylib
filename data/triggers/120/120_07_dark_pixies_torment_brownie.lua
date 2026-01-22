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
if (self:get_people("12019")) and (self:get_people("12020")) then
    -- switch on random(1, 5)
    if random(1, 5) == 1 then
        self.room:find_actor("dark-pixie-tormentor"):emote("hisses, 'Where is your forest magic now, tree-turd?'")
    elseif random(1, 5) == 2 then
        self.room:find_actor("dark-pixie-tormentor"):emote("growls, 'Tell us why you intrude, clod... and we may slay you swiftly.'")
    elseif random(1, 5) == 3 then
        self.room:find_actor("dark-pixie-tormentor"):emote("swiftly kicks the haggard brownie in the kidney.")
    elseif random(1, 5) == 4 then
        self.room:find_actor("dark-pixie-tormentor"):emote("hisses, 'You sicken me, dirty-skin.'")
    else
        self.room:send("Snap!  A dark pixie raises another welt on the haggard brownie's arm.")
    end
    wait(8)
    -- switch on random(1, 4)
    if random(1, 4) == 1 then
        self.room:find_actor("haggard-brownie"):emote("whimpers piteously.")
    elseif random(1, 4) == 2 then
        self.room:find_actor("haggard-brownie"):emote("glares resentfully at a dark pixie.")
    elseif random(1, 4) == 3 then
        self.room:find_actor("haggard-brownie"):emote("bites his lip, though a tear seems to be forming in his eye.")
    else
        self.room:find_actor("haggard-brownie"):emote("covers his head with his arms, moaning, 'No!'")
    end
end