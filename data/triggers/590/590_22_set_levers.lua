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
    do
        local _sw1 = string.lower(tostring(rnd or ""))
        if tonumber(_sw1) == 1 then
            globals.first, globals.secnd, globals.last = 1, 2, 3
        elseif tonumber(_sw1) == 2 then
            globals.first, globals.secnd, globals.last = 1, 3, 2
        elseif tonumber(_sw1) == 3 then
            globals.first, globals.secnd, globals.last = 2, 3, 1
        elseif tonumber(_sw1) == 4 then
            globals.first, globals.secnd, globals.last = 2, 1, 3
        elseif tonumber(_sw1) == 5 then
            globals.first, globals.secnd, globals.last = 3, 2, 1
        elseif tonumber(_sw1) == 6 then
            globals.first, globals.secnd, globals.last = 3, 1, 2
        end
    end
    globals.first_kill = 2
    globals.first_pin = 1
    globals.secnd_pin = 1
    globals.last_pin = 1
end