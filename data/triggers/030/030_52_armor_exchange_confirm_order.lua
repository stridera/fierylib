-- Trigger: Armor Exchange confirm order
-- Zone: 30, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3052

-- Converted from DG Script #3052: Armor Exchange confirm order
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes no
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "no")) then
    return true  -- No matching keywords
end
wait(2)
local item = actor:get_quest_var("armor_exchange:armor_vnum")
if string.find(speech, "yes") then
    if item == 0 then
        actor:send(tostring(self.name) .. " says, 'I don't think you asked me for anything, no sir.'")
        return _return_value
    end
    actor:send(tostring(self.name) .. " tells you, 'Oh my, yes dearie, of course.'")
    if item <= 55303 then
        local class = 1
        local tier = 1
    elseif item <= 55307 then
        local class = 1
        local tier = 2
    elseif item <= 55311 then
        local class = 1
        local tier = 3
    elseif item <= 55315 then
        local class = 1
        local tier = 4
    elseif item <= 55319 then
        local class = 1
        local tier = 5
    elseif item <= 55323 then
        local class = 1
        local tier = 6
    elseif item <= 55327 then
        local class = 1
        local tier = 7
    elseif item <= 55331 then
        local class = 2
        local tier = 1
    elseif item <= 55335 then
        local class = 2
        local tier = 2
    elseif item <= 55339 then
        local class = 2
        local tier = 3
    elseif item <= 55343 then
        local class = 2
        local tier = 4
    elseif item <= 55347 then
        local class = 2
        local tier = 5
    elseif item <= 55351 then
        local class = 2
        local tier = 6
    elseif item <= 55355 then
        local class = 2
        local tier = 7
    elseif item <= 55359 then
        local class = 3
        local tier = 1
    elseif item <= 55363 then
        local class = 3
        local tier = 2
    elseif item <= 55367 then
        local class = 3
        local tier = 3
    elseif item <= 55371 then
        local class = 3
        local tier = 4
    elseif item <= 55375 then
        local class = 3
        local tier = 5
    elseif item <= 55379 then
        local class = 3
        local tier = 6
    elseif item <= 55383 then
        local class = 3
        local tier = 7
    end
    actor:send(tostring(self.name) .. " says, 'So " .. "%get.obj_shortdesc[%item%]% is a <b:yellow>class %class% tier %tier%</> piece of gear.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'll give it to you for any other armor of equal or greater rarity.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_vnum", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end