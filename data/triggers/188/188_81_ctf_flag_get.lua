-- Trigger: ctf_flag_get
-- Zone: 188, ID: 81
-- Type: OBJECT, Flags: GET
-- Status: NEEDS_REVIEW (parses, but team-membership tests need real IDs; see TODOs)
--
-- Original DG Script: #18881
-- Converted from DG Script #18881: ctf_flag_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
--
-- TODO(parity): `self.id ~= "flag_a"` was a string compare. Replace with
-- `self.local_id ~= 82` / `self.local_id ~= 83` (the team flag local ids)
-- once the team mapping is finalized.
-- TODO(parity): `actor:has_equipped("18880")` and `actor.wearing[18881]` use
-- legacy 5-digit vnums; switch to composite-key lookups.
local _return_value = true  -- Default: allow action
-- *** Set entity IDs ****
local referee = 18880
local flag_a = 18882
local flag_b = 18883
local enemy_flag
-- Player is on team A
if actor:has_equipped("18880") then
    -- Player is trying to pick up team A's flag
    if self.id ~= "flag_a" then
        enemy_flag = "yes"
    end
    -- Player is on team B
elseif actor.wearing[18881] then
    -- Player is trying to pick up team B's flag
    if self.id ~= "flag_b" then
        enemy_flag = "yes"
    end
end
if enemy_flag == "yes" then
    local hands = 0
    if actor:get_worn("held") then
        hands = 1
    end
    if actor:get_worn("held2") then
        hands = hands + 1
    end
    if actor:get_worn("wield") then
        hands = hands + 1
    end
    if actor:get_worn("wield2") then
        hands = hands + 1
    end
    if actor:get_worn("2hwield") then
        hands = hands + 1
    end
    if actor:get_worn("shield") then
        hands = 2
    end
    if hands < 2 then
        _return_value = false
        wait(1)
        actor:command("hold flag")
    else
        _return_value = true
        actor:send("You must have a free hand to pick up the flag!")
    end
else
    _return_value = true
    actor:send("You can't pick that up!")
end
return _return_value