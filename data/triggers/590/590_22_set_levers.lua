-- Trigger: set_levers
-- Zone: 590, ID: 22
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #59022

-- Converted from DG Script #59022: set_levers
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
if first_kill ~= 2 then
    local rnd = random(1, 6)
    -- switch on rnd
    if rnd == 1 then
        local first = 1
        local secnd = 2
        local last = 3
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    elseif rnd == 2 then
        local first = 1
        local secnd = 3
        local last = 2
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    elseif rnd == 3 then
        local first = 2
        local secnd = 3
        local last = 1
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    elseif rnd == 4 then
        local first = 2
        local secnd = 1
        local last = 3
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    elseif rnd == 5 then
        local first = 3
        local secnd = 2
        local last = 1
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    elseif rnd == 6 then
        local first = 3
        local secnd = 1
        local last = 2
        globals.first = globals.first or true
        globals.secnd = globals.secnd or true
        globals.last = globals.last or true
    end
    local first_kill = 2
    globals.first_kill = globals.first_kill or true
    local first_pin = 1
    local secnd_pin = 1
    local last_pin = 1
    globals.first_pin = globals.first_pin or true
    globals.secnd_pin = globals.secnd_pin or true
    globals.last_pin = globals.last_pin or true
end