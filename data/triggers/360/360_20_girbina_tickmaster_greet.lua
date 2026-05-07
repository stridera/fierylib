-- Trigger: Girbina_Tickmaster_greet
-- Zone: 360, ID: 20
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #36020
--
-- Greet trigger for Girbina Tickmaster. Determines which sorcerer port-quest
-- the player should be on based on their level and which earlier quests they
-- have completed, and announces the active assignment.

local _return_value = true

if actor.is_npc or actor.level > 99 then
    return _return_value
end

if actor.class ~= "sorcerer" then
    return _return_value
end

wait(2)

-- Determine the active port-quest for this character. Quests must be
-- completed in order; first matching gate wins.
local port_quest = nil

if actor.level >= 25 and not actor:get_has_completed("speculan_wilderland") then
    port_quest = "SW"
    self:say("you will be on SW")
end
if actor.level >= 33 and (actor:get_has_completed("speculan_wilderland") and not actor:get_has_completed("nikozian_ice")) then
    port_quest = "NI"
    self:say("you will be on NI")
end
if actor.level >= 41 and (actor:get_has_completed("nikozian_ice") and not actor:get_has_completed("stonewardens_promise")) then
    self:say("you will be on SW")
    port_quest = "SW"
end
if actor.level >= 41 and (actor:get_has_completed("stonewardens_promise") and not actor:get_has_completed("parcel_to_sw")) then
    port_quest = "PtSW"
    self:say("you will be on PtSW")
end
if actor.level >= 49 and (actor:get_has_completed("parcel_to_sw") and not actor:get_has_completed("winds_of_gothra")) then
    self:say("you will be on WoG")
    port_quest = "WoG"
end
if actor.level >= 49 and (actor:get_has_completed("winds_of_gothra") and not actor:get_has_completed("ruck_to_ni")) then
    port_quest = "RtNI"
    self:say("you will be on RtNI")
end
if actor.level >= 57 and (actor:get_has_completed("ruck_to_ni") and not actor:get_has_completed("muster_of_sp")) then
    self:say("you will be on MoSP")
    port_quest = "MoSP"
end
if actor.level >= 65 and (actor:get_has_completed("muster_of_sp") and not actor:get_has_completed("crush_the_wog")) then
    port_quest = "CtWoG"
    self:say("you will be on CtWoG")
end
if actor.level >= 73 and (actor:get_has_completed("crush_the_wog") and not actor:get_has_completed("eldoria_proper")) then
    self:say("you will be on EP")
    port_quest = "EP"
end
if actor.level >= 81 and (actor:get_has_completed("eldoria_proper") and not actor:get_has_completed("assembly_of_ep")) then
    port_quest = "AoEP"
    self:say("you will be on AoEP")
end

-- Announce the active assignment.
if port_quest == "SW" then
    self:say("You are on SW")
end
if port_quest == "NI" then
    self:say("You are on NI")
end
if port_quest == "SP" then
    self:say("You are on SP")
end
if port_quest == "PtSW" then
    self:say("You are on PtSW")
end
if port_quest == "WoG" then
    self:say("You are on WoG")
end
if port_quest == "RtNI" then
    self:say("You are on RtNI")
end
if port_quest == "MoSP" then
    self:say("You are on MoSP")
end
if port_quest == "CtWoG" then
    -- TODO: original DG says "You are on SW" here; likely a copy-paste bug,
    -- intended "You are on CtWoG". Preserving original behavior pending review.
    self:say("You are on SW")
end
if port_quest == "EP" then
    self:say("You are on EP")
end
if port_quest == "AoEP" then
    self:say("You are on AoEP")
end

return _return_value
