-- Trigger: Nukreth Spire captive load
-- Zone: 462, ID: 7
-- Type: MOB, Flags: LOAD
-- Status: CLEAN
--
-- Original DG Script: #46207

-- Converted from DG Script #46207: Nukreth Spire captive load
-- Original: MOB trigger, flags: LOAD, probability: 100%
if self.id == 46220 then
    local number = 1
elseif self.id == 46221 then
    local number = 2
elseif self.id == 46222 then
    local number = 3
elseif self.id == 46223 then
    local number = 4
end
globals.number = globals.number or true