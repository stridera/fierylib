-- Trigger: Nukreth Spire orc help speech
-- Zone: 462, ID: 15
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #46215

-- Converted from DG Script #46215: Nukreth Spire orc help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: axe help yes okay where
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "axe") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "where")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path3") == 0 then
        self:command("nod")
        self.room:send(tostring(self.name) .. " says, 'They took my axe when they captured me.  Gave it to")
        self.room:send("</>one of the chieftain's favorite mates.'")
        wait(2)
        self:command("snarl")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'Was a gift from an order of dark monks.  Sure would")
        self.room:send("</>love it back.'")
        wait(2)
        self:say("For some revenge...")
        wait(1)
        self:say("Go find it and bring it to me.  I'll hold this area.")
        if not running then
            local running = "yes"
            globals.running = globals.running or true
            get_room(11, 0):at(function()
                self.room:spawn_mobile(462, 5)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):spawn_object(462, 13)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):command("wield axe")
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("mate"):teleport(get_room(462, 40))
            end)
        end
    else
        actor:send("<b:red>You have already completed this quest path.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end