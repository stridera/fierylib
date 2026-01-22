-- Trigger: Helping_blacksmith_quest
-- Zone: 87, ID: 1
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #8701

-- Converted from DG Script #8701: Helping_blacksmith_quest
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes yes.
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "yes.")) then
    return true  -- No matching keywords
end
wait(2)
if world.count_mobiles("8712") == 0 then
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