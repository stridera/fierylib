-- Trigger: Helping_blacksmith_quest
-- Zone: 87, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #8701
--
-- TODO(parity): converter wrapped legacy 'mload @ Y' calls in
-- `get_room(559, 32):at(function() self.room:spawn_mobile(...) end)`. The
-- closure passed to `at()` actually runs in the current trigger context (the
-- room argument is ignored) so the spawn happens in the blacksmith's room,
-- not at room (559, 32). Verify the intended target room and either use the
-- callback's room argument (`function(target) target:spawn_mobile(...) end`)
-- or call `get_room(zone, id):spawn_mobile(...)` directly.

-- Converted from DG Script #8701: Helping_blacksmith_quest
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"yes", "yes."}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if world.count_mobiles(87, 12) == 0 then
    actor:send(tostring(self.name) .. " says, 'Thank you, thank you I will ever be in your debt if you")
    actor:send("</>find Doren.  He will be traveling here from the dwarven mines near Anduin.  If")
    actor:send("</>you find Doren tell him that his uncle sent you.  Please hurry!  He could be")
    actor:send("</>hurt or in trouble!'")
    get_room(559, 32):at(function()
        self.room:spawn_mobile(87, 13)
    end)
    get_room(559, 32):at(function()
        self.room:spawn_mobile(87, 13)
    end)
    get_room(559, 32):at(function()
        self.room:spawn_mobile(87, 12)
    end)
    wait(1)
    get_room(559, 32):at(function()
        self.room:find_actor("doren"):spawn_object(87, 9)
    end)
    wait(1)
    get_room(559, 32):at(function()
        self.room:find_actor("doren"):command("drop handcart")
    end)
else
    actor:send(tostring(self.name) .. " says, 'Please go find Doren, he could be hurt.'")
end