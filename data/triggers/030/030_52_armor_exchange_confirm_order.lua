-- Trigger: Armor Exchange confirm order
-- Zone: 30, ID: 52
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #3052

-- Converted from DG Script #3052: Armor Exchange confirm order
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "no"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
local item = actor:get_quest_var("armor_exchange:armor_id")
if string.find(speech, "yes") then
    if (item or 0) == 0 then
        actor:send(tostring(self.name) .. " says, 'I don't think you asked me for anything, no sir.'")
        return _return_value
    end
    actor:send(tostring(self.name) .. " tells you, 'Oh my, yes dearie, of course.'")
    local class, tier
    if (item or 0) <= 55303 then
        class = 1
        tier = 1
    elseif (item or 0) <= 55307 then
        class = 1
        tier = 2
    elseif (item or 0) <= 55311 then
        class = 1
        tier = 3
    elseif (item or 0) <= 55315 then
        class = 1
        tier = 4
    elseif (item or 0) <= 55319 then
        class = 1
        tier = 5
    elseif (item or 0) <= 55323 then
        class = 1
        tier = 6
    elseif (item or 0) <= 55327 then
        class = 1
        tier = 7
    elseif (item or 0) <= 55331 then
        class = 2
        tier = 1
    elseif (item or 0) <= 55335 then
        class = 2
        tier = 2
    elseif (item or 0) <= 55339 then
        class = 2
        tier = 3
    elseif (item or 0) <= 55343 then
        class = 2
        tier = 4
    elseif (item or 0) <= 55347 then
        class = 2
        tier = 5
    elseif (item or 0) <= 55351 then
        class = 2
        tier = 6
    elseif (item or 0) <= 55355 then
        class = 2
        tier = 7
    elseif (item or 0) <= 55359 then
        class = 3
        tier = 1
    elseif (item or 0) <= 55363 then
        class = 3
        tier = 2
    elseif (item or 0) <= 55367 then
        class = 3
        tier = 3
    elseif (item or 0) <= 55371 then
        class = 3
        tier = 4
    elseif (item or 0) <= 55375 then
        class = 3
        tier = 5
    elseif (item or 0) <= 55379 then
        class = 3
        tier = 6
    elseif (item or 0) <= 55383 then
        class = 3
        tier = 7
    end
    actor:send(tostring(self.name) .. " says, 'So " .. objects.template(math.floor(item / 100), item % 100).name .. " is a <b:yellow>class " .. tostring(class) .. " tier " .. tostring(tier) .. "</> piece of gear.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'I'll give it to you for any other armor of equal or greater rarity.'")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Consult the chart for degrees of rarity.'")
    actor:send(tostring(self.name) .. " points to the sign.")
else
    actor:set_quest_var("gem_exchange", "gem_id", 0)
    actor:send(tostring(self.name) .. " says, 'Alright, what DO you want then?'")
end