-- Trigger: ctf_flag_get
-- Zone: 188, ID: 81
-- Type: OBJECT, Flags: GET
-- Status: NEEDS_REVIEW
--   Complex nesting: 11 if statements
--
-- Original DG Script: #18881

-- Converted from DG Script #18881: ctf_flag_get
-- Original: OBJECT trigger, flags: GET, probability: 100%
local _return_value = true  -- Default: allow action
-- *** Set vnum variables ****
-- Mobiles
local referee = 18880
-- Objects
local vnum_a = 18880
local vnum_b = 18881
local flag_a = 18882
local flag_b = 18883
-- Player is on team A
if actor:has_equipped("18880") then
    -- Player is trying to pick up team A's flag
    if self.id ~= "flag_a" then
        local enemy_flag = "yes"
    end
    -- Player is on team B
elseif actor:has_equipped("18881") then
    -- Player is trying to pick up team B's flag
    if self.id ~= "flag_b" then
        local enemy_flag = "yes"
    end
end
if enemy_flag == "yes" then
    local hands = 0
    if actor:get_worn("held") then
        local hands = 1
    end
    if actor:get_worn("held2") then
        local hands = hands + 1
    end
    if actor:get_worn("wield") then
        local hands = hands + 1
    end
    if actor:get_worn("wield2") then
        local hands = hands + 1
    end
    if actor:get_worn("2hwield") then
        local hands = hands + 1
    end
    if actor:get_worn("shield") then
        local hands = 2
    end
    if hands < 2 then
        _return_value = true
        wait(1)
        actor:command("hold flag")
    else
        _return_value = false
        actor:send("You must have a free hand to pick up the flag!")
    end
else
    _return_value = false
    actor:send("You can't pick that up!")
end
return _return_value