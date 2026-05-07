-- Trigger: Gem Exchange confirm order
-- Zone: 62, ID: 94
-- Type: MOB, Flags: SPEECH
--
-- Player confirms (yes/no) the gem order placed via 062_93. On "yes" we
-- decode the (class, tier) rarity bucket from the legacy 5-digit vnum and
-- explain the exchange rule. On "no" we clear the pending order.
--
-- Original DG Script: #6294

if not (string.find(string.lower(speech), "yes")
        or string.find(string.lower(speech), "no")) then
    return true
end
wait(2)
local item = actor:get_quest_var("gem_exchange:gem_id")
if string.find(speech, "yes") then
    if item == 0 or item == nil then
        actor:send(tostring(self.name) .. " says, 'Forgive me, I don't have an order under your name.'")
        return true
    end
    actor:send(tostring(self.name) .. " writes your exchange order down.")
    local class, tier
    if item <= 55569 then class, tier = 1, 1
    elseif item <= 55573 then class, tier = 1, 2
    elseif item <= 55577 then class, tier = 1, 3
    elseif item <= 55581 then class, tier = 1, 4
    elseif item <= 55585 then class, tier = 1, 5
    elseif item <= 55589 then class, tier = 1, 6
    elseif item <= 55593 then class, tier = 1, 7
    elseif item <= 55604 then class, tier = 2, 1
    elseif item <= 55615 then class, tier = 2, 2
    elseif item <= 55626 then class, tier = 2, 3
    elseif item <= 55637 then class, tier = 2, 4
    elseif item <= 55648 then class, tier = 2, 5
    elseif item <= 55659 then class, tier = 2, 6
    elseif item <= 55670 then class, tier = 2, 7
    elseif item <= 55681 then class, tier = 3, 1
    elseif item <= 55692 then class, tier = 3, 2
    elseif item <= 55703 then class, tier = 3, 3
    elseif item <= 55714 then class, tier = 3, 4
    elseif item <= 55725 then class, tier = 3, 5
    elseif item <= 55736 then class, tier = 3, 6
    elseif item <= 55747 then class, tier = 3, 7
    end
    local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
    actor:send(tostring(self.name) .. " says, 'So " .. item_name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> gemstone.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We can exchange any gemstone of equal or greater rarity for it.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end
return true