-- Trigger: Ranger Trophy assignment look
-- Zone: 53, ID: 15
-- Type: OBJECT, Flags: LOOK
-- Status: CLEAN
--
-- Original DG Script: #5315

-- Converted from DG Script #5315: Ranger Trophy assignment look
-- Original: OBJECT trigger, flags: LOOK, probability: 100%
local _return_value = true  -- Default: allow action
-- switch on self.id
if self.id == 5300 then
    local victim1 = "an abominable slime creature"
    local stage = 1
elseif self.id == 5301 then
    local victim1 = "a large buck"
    local stage = 2
elseif self.id == 5302 then
    local victim1 = "the giant scorpion"
    local stage = 3
elseif self.id == 5303 then
    local victim1 = "a monstrous canopy spider"
    local stage = 4
elseif self.id == 5304 then
    local victim1 = "the chimera"
    local stage = 5
elseif self.id == 5305 then
    local victim1 = "the drider king"
    local stage = 6
elseif self.id == 5306 then
    local victim1 = "a beholder"
    local stage = 7
elseif self.id == 5307 then
    local victim1 = "the Banshee"
    local stage = 8
elseif self.id == 5308 then
    local victim1 = "Baba Yaga"
    local stage = 9
elseif self.id == 5309 then
    local victim1 = "the medusa"
    local stage = 10
end
_return_value = false
actor:send("This is a notice to slay " .. tostring(victim1) .. ".")
if actor:get_quest_var("beast_master:hunt") == "dead" and actor:get_quest_stage("beast_master") == "stage" then
    actor:send("You have completed the hunt.")
    actor:send("Return your assignment to Pumahl for your reward!")
end
return _return_value