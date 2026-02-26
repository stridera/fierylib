-- Trigger: set_encrytped_phrase
-- Zone: 510, ID: 2
-- Type: WORLD, Flags: PREENTRY
-- Status: CLEAN
--
-- Original DG Script: #51002

-- Converted from DG Script #51002: set_encrytped_phrase
-- Original: WORLD trigger, flags: PREENTRY, probability: 100%
if running ~= "yes" then
    local running = "yes"
    globals.running = globals.running or true
    chosen = nil
    local chosen = random(1, 4)
    globals.chosen = globals.chosen or true
    -- we have 4 known phrases..it would be nice if this were completely dynamic though :)
    -- switch on chosen
    if chosen == 1 then
        local descr = "PLTWK ZHWIL OIXWI ONXML KMJ"
    elseif chosen == 2 then
        local descr = "PLTWK ZHWIL OIXMB XGFVZ LIYBX"
    elseif chosen == 3 then
        local descr = "PLTWK ZHWIL OIXBK KVJZL ORIMW KNX"
    elseif chosen == 4 then
        local descr = "PLTWK ZHWIL OIXTX DMJQG NOWSN C"
    end
    doors.set_description(get_room(510, 30), "n", "%descr%")
    wait(2)
    running = nil
end