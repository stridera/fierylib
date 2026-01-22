-- Trigger: Gem Exchange confirm order
-- Zone: 62, ID: 94
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #6294

-- Converted from DG Script #6294: Gem Exchange confirm order
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
local item = actor:get_quest_var("gem_exchange:gem_vnum")
if string.find(speech, "yes") then
    if item == 0 then
        actor:send(tostring(self.name) .. " says, 'Forgive me, I don't have an order under your name.'")
        return _return_value
    end
    actor:send(tostring(self.name) .. " writes your exchange order down.")
    if item <= 55569 then
        local class = 1
        local tier = 1
    elseif item <= 55573 then
        local class = 1
        local tier = 2
    elseif item <= 55577 then
        local class = 1
        local tier = 3
    elseif item <= 55581 then
        local class = 1
        local tier = 4
    elseif item <= 55585 then
        local class = 1
        local tier = 5
    elseif item <= 55589 then
        local class = 1
        local tier = 6
    elseif item <= 55593 then
        local class = 1
        local tier = 7
    elseif item <= 55604 then
        local class = 2
        local tier = 1
    elseif item <= 55615 then
        local class = 2
        local tier = 2
    elseif item <= 55626 then
        local class = 2
        local tier = 3
    elseif item <= 55637 then
        local class = 2
        local tier = 4
    elseif item <= 55648 then
        local class = 2
        local tier = 5
    elseif item <= 55659 then
        local class = 2
        local tier = 6
    elseif item <= 55670 then
        local class = 2
        local tier = 7
    elseif item <= 55681 then
        local class = 3
        local tier = 1
    elseif item <= 55692 then
        local class = 3
        local tier = 2
    elseif item <= 55703 then
        local class = 3
        local tier = 3
    elseif item <= 55714 then
        local class = 3
        local tier = 4
    elseif item <= 55725 then
        local class = 3
        local tier = 5
    elseif item <= 55736 then
        local class = 3
        local tier = 6
    elseif item <= 55747 then
        local class = 3
        local tier = 7
    end
    actor:send(tostring(self.name) .. " says, 'So " .. "%get.obj_shortdesc[%item%]% is a <b:yellow>class %class% tier %tier%</> gemstone.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'We can exchange any gemstone of equal or greater rarity for it.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_vnum", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end