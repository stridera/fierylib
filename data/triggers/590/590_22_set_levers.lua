-- Trigger: set_levers
-- Zone: 590, ID: 22
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #59022

-- Converted from DG Script #59022: set_levers
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if globals.first_kill ~= 2 then
    -- Randomize the (first, secnd, last) lever-pull permutation 1..3 -> 1..3
    -- and seed the per-pin sentinels (1 = unpulled, 3 = pulled / used by 590_18).
    local rnd = random(1, 6)
    if rnd == 1 then
        globals.first, globals.secnd, globals.last = 1, 2, 3
    elseif rnd == 2 then
        globals.first, globals.secnd, globals.last = 1, 3, 2
    elseif rnd == 3 then
        globals.first, globals.secnd, globals.last = 2, 3, 1
    elseif rnd == 4 then
        globals.first, globals.secnd, globals.last = 2, 1, 3
    elseif rnd == 5 then
        globals.first, globals.secnd, globals.last = 3, 2, 1
    elseif rnd == 6 then
        globals.first, globals.secnd, globals.last = 3, 1, 2
    end
    globals.first_kill = 2
    globals.first_pin = 1
    globals.secnd_pin = 1
    globals.last_pin = 1
end