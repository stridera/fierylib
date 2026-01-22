-- Trigger: count up
-- Zone: 625, ID: 73
-- Type: OBJECT, Flags: RANDOM
-- Status: CLEAN
--
-- Original DG Script: #62573

-- Converted from DG Script #62573: count up
-- Original: OBJECT trigger, flags: RANDOM, probability: 100%
if delay > 0 and obj.worn_by ~= 0 then
    wait(delay)
    if charges >= 0 and charges <= maxcharge then
        if charges < maxcharge then
            local charges = charges + 1
            globals.charges = globals.charges or true
            self.room:send("<b:yellow>" .. tostring(self.shortdesc) .. " hums lightly.</>")
        elseif charges == "maxcharges" then
        end
    else
        local charges = 0
        globals.charges = globals.charges or true
    end
end