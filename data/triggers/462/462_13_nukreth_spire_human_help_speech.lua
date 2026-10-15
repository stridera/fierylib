-- Trigger: Nukreth Spire human help speech
-- Zone: 462, ID: 13
-- Type: MOB, Flags: SPEECH
--
-- Original DG Script: #46213

-- Converted from DG Script #46213: Nukreth Spire human help speech
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"husband", "help", "yes", "okay", "who", "where"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("nukreth_spire") > 0 then
    if (actor:get_quest_var("nukreth_spire:path1") or 0) == 0 then
        self.room:send(tostring(self.name) .. " says, 'They took us both captive.  But just a moment ago three")
        self.room:send("</>of their cultists took him as a sacrifice to their Demon Lord...'")
        wait(0.2)
        self.room:send("Her voice trails off.")
        wait(2)
        self:command("shake")
        self:say("No, he's still alive, I know it.  Please, save him!")
        wait(1)
        self.room:send(tostring(self.name) .. " says, 'They took him deeper into the den.  Find him and bring")
        self.room:send("</>him back here.  I'll keep this area safe.'")
        if (actor:get_quest_var("nukreth_spire:rescue") or 0) == 0 then
            actor:set_quest_var("nukreth_spire", "rescue", 1)
        end
        if not globals.running then
            globals.running = true
            if world.count_mobiles(462, 6) == 0 then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 6)
                end)
            end
            if world.count_mobiles(462, 7) == 0 then
                get_room(462, 62):at(function()
                    self.room:spawn_mobile(462, 7)
                end)
            end
            if world.count_mobiles(462, 8) == 0 then
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