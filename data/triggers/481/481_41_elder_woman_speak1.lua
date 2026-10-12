-- Trigger: elder_woman_speak1
-- Zone: 481, ID: 41
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #48141

-- Converted from DG Script #48141: elder_woman_speak1
-- Original: MOB trigger, flags: SPEECH, num_arg: 1 (DG word-list mode, not a probability)

-- DG word list (num_arg 1): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"spell", "spell?", "help", "help?"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(2)
local stage = 2
local person = actor
local i = person.group_size
local a
local ash
if i then
    a = 1
else
    a = 0
end
while i >= a do
    person = actor.group_member[a]
    if person.room == self.room then
        if person:get_quest_stage("fieryisle_quest") == stage then
            person:advance_quest("fieryisle_quest")
            person:send("<b:white>You have advanced your quest!</>")
            ash = 1
        elseif person:get_quest_stage("fieryisle_quest") == 3 or person:get_quest_stage("fieryisle_quest") == 4 then
            ash = 2
        end
    elseif person and person.is_player then
        i = i + 1
    end
    a = a + 1
end
if ash == 1 then
    self.room:send(tostring(self.name) .. " says, 'If you want me to help you, then you must do me a favor.  Kill the ash lord and bring me his crown.'")
    if world.count_mobiles(481, 7) < 1 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(481, 7)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):spawn_object(481, 24)
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):command("wear crown")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("ash-lord"):teleport(get_room(481, 57))
        end)
    end
elseif ash == 2 then
    self:say("Bring me the ash lord's crown first.")
else
    self:say("I have no idea what you are talking about.")
    self:command("eye " .. tostring(actor.name))
end