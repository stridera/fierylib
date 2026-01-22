-- Trigger: Girbina_Tickmaster_greet
-- Zone: 360, ID: 20
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 22 if statements
--
-- Original DG Script: #36020

-- Converted from DG Script #36020: Girbina_Tickmaster_greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- 
-- Greet trigger got Girbina Tickmaster
-- 
if actor.id ~= -1 or actor.level > 99 then
    return _return_value
end
if actor.class == "sorcerer" then
    wait(2)
    -- De-sluttify DG variable
    port_quest = nil
    -- 
    -- Conditionals for which quest is being done.  Note we're going
    -- to require these be done in order.
    -- 
    if actor.level >= 25 and not actor:get_has_completed("speculan_wilderland") then
        local port_quest = "SW"
        self:say("you will be on SW")
    end
    if actor.level >= 33 and (actor:get_has_completed("speculan_wilderland") and not actor:get_has_completed("nikozian_ice")) then
        local port_quest = "NI"
        self:say("you will be on NI")
    end
    if actor.level >= 41 and (actor:get_has_completed("nikozian_ice") and not actor:get_has_completed("stonewardens_promise")) then
        self:say("you will be on SW")
        local port_quest = "SW"
    end
    if actor.level >= 41 and (actor:get_has_completed("stonewardens_promise") and not actor:get_has_completed("parcel_to_sw")) then
        local port_quest = "PtSW"
        self:say("you will be on PtSW")
    end
    if actor.level >= 49 and (actor:get_has_completed("parcel_to_sw") and not actor:get_has_completed("winds_of_gothra")) then
        self:say("you will be on WoG")
        local port_quest = "WoG"
    end
    if actor.level >= 49 and (actor:get_has_completed("winds_of_gothra") and not actor:get_has_completed("ruck_to_ni") ) then
        local port_quest = "RtNI"
        self:say("you will be on RtNI")
    end
    if actor.level >= 57 and (actor:get_has_completed("ruck_to_ni") and not actor:get_has_completed("muster_of_sp") ) then
        self:say("you will be on MoSP")
        local port_quest = "MoSP"
    end
    if actor.level >= 65 and (actor:get_has_completed("muster_of_sp") and not actor:get_has_completed("crush_the_wog") ) then
        local port_quest = "CtWoG"
        self:say("you will be on CtWoG")
    end
    if actor.level >= 73 and (actor:get_has_completed("crush_the_wog") and not actor:get_has_completed("eldoria_proper") ) then
        self:say("you will be on EP")
        local port_quest = "EP"
    end
    if actor.level >= 81 and (actor:get_has_completed("eldoria_proper") and not actor:get_has_completed("assembly_of_ep") ) then
        local port_quest = "AoEP"
        self:say("you will be on AoEP")
    end
    -- Say IT
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
        self:say("You are on SW")
    end
    if port_quest == "EP" then
        self:say("You are on EP")
    end
    if port_quest == "AoEP" then
        self:say("You are on AoEP")
    end
else
    return _return_value
end