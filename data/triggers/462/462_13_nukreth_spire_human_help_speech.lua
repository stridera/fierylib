-- Trigger: Nukreth Spire human help speech
-- Zone: 462, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #46213

-- Converted from DG Script #46213: Nukreth Spire human help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: husband help yes okay who where
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "husband") or string.find(string.lower(speech), "help") or string.find(string.lower(speech), "yes") or string.find(string.lower(speech), "okay") or string.find(string.lower(speech), "who") or string.find(string.lower(speech), "where")) then
    return true  -- No matching keywords
end
wait(2)
if actor:get_quest_stage("nukreth_spire") then
    if actor:get_quest_var("nukreth_spire:path1") == 0 then
        self.room:send(tostring(self.name) .. " says, 'They took us both captive.  But just a moment ago three")
        self.room:send("</>of their cultists took him as a sacrifice to their Demon Lord...'")
        wait(2)
        self.room:send("Her voice trails off.")
        wait(2)
        self:command("shake")
        self:say("No, he's still alive, I know it.  Please, save him!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'They took him deeper into the den.  Find him and bring")
        self.room:send("</>him back here.  I'll keep this area safe.'")
        if not actor:get_quest_var("nukreth_spire:rescue") then
            actor:set_quest_var("nukreth_spire", "rescue", 1)
        end
        if not running then
            local running = "yes"
            globals.running = globals.running or true
            if not world.count_mobiles("46206") then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 6)
                end)
            end
            if not world.count_mobiles("46207") then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 7)
                end)
            end
            if not world.count_mobiles("46208") then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 8)
                end)
            end
        end
    else
        actor:send("<b:red>You have already completed this option.</>")
    end
else
    actor:send("<b:red>You must first start this quest before you can earn rewards.</>")
end