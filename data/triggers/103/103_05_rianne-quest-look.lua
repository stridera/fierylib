-- Trigger: rianne-quest-look
-- Zone: 103, ID: 5
-- Type: WORLD, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #10305
-- Reacts to "look <recipe|wall|paper|slip>" or "look icebox" while
-- the player is mid resort_cooking quest. The first form prints
-- the active recipe and its remaining ingredient list; the second
-- prints the running tally of items already turned in.
--
-- Returns true (allow normal look) when the actor's stage is out
-- of range or no keyword matched, otherwise consumes the command
-- (returns false) so the room description does not also render.

if cmd ~= "look" then
    return true
end

local stage = actor:get_quest_stage("resort_cooking")
if stage < 1 or stage > 5 then
    return true
end

-- Per-stage recipe + ingredient list (mirrors 103_04). Each row is
-- {zone, id}; nil-tail rows are absent slots for that stage.
local recipe
local ingredients
if stage == 1 then
    recipe = "Peach Cobbler"
    ingredients = {{615, 1}, {237, 54}, {30, 114}, {350, 1}}
elseif stage == 2 then
    recipe = "Seafood Salad"
    ingredients = {{490, 24}, {237, 50}, {237, 22}, {80, 3}, {125, 15}, {16, 6}}
elseif stage == 3 then
    recipe = "Fish Stew"
    ingredients = {{552, 13}, {300, 2}, {100, 30}, {125, 52}, {237, 57}, {185, 9}, {103, 11}}
elseif stage == 4 then
    recipe = "Honey-Glazed Ham"
    ingredients = {{410, 11}, {83, 50}, {20, 1}, {502, 7}, {61, 6}}
else  -- stage == 5
    recipe = "Saffroned Jasmine Rice"
    ingredients = {{580, 19}, {370, 13}, {237, 60}}
end

local function shortdesc(row)
    return objects.template(row[1], row[2]).name
end

local a = string.lower(arg or "")
if string.find(a, "recipe") or string.find(a, "wall")
   or string.find(a, "paper") or string.find(a, "slip") then
    actor:send("The wall is covered in slips of paper, each with a different recipe.  One")
    actor:send("</>especially stands out among the mess.")
    actor:send("</>")
    actor:send("</>==========<b:white>" .. recipe .. "</>==========")
    for _, row in ipairs(ingredients) do
        actor:send("</>  " .. shortdesc(row))
    end
    return false
elseif string.find(a, "icebox") then
    actor:send("Looking inside the icebox, you see:")
    local nothing = true
    for i, row in ipairs(ingredients) do
        local v = actor:get_quest_var("resort_cooking:item" .. tostring(i))
        if v and v ~= "" and v ~= "0" then
            actor:send("</>  " .. shortdesc(row))
            nothing = false
        end
    end
    if nothing then
        actor:send("</>  Nothing.")
    end
    return false
end

return true
