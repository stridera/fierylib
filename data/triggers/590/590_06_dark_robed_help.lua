-- Trigger: dark_robed_help
-- Zone: 590, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #59006

-- Converted from DG Script #59006: dark_robed_help
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: help?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "help?")) then
    return true  -- No matching keywords
end
local target = actor
if target.alignment <=-350 and target.level <100 then
    wait(3)
    if target.room == self.room then
        target:send(tostring(self.name) .. " squints their eyes and peers at you.")
        self.room:send_except(target.name, tostring(self.name) .. " squints their eyes and peers at " .. tostring(target.name) .. ".")
        wait(6)
        target.name:send(tostring(self.name) .. " whispers to you, 'Are you strong enough to assist me?")
        target.name:send("</>I have a couple of allies that have breached the Sacred Haven and secured me")
        target.name:send("</>a key of great importance.'")
        wait(2)
        self:emote("flashes a dingy key, held tight in their skinny, grey hands.")
        wait(5)
        target:send(tostring(self.name) .. " whispers to you, 'Before I release my key I need you to")
        target:send("</>prove that you are worthy of this deed.  Do you feel strong enough to handle")
        target:send("</>this task?'")
    end
end