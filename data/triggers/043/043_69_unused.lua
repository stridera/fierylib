-- Trigger: **UNUSED**
-- Zone: 43, ID: 69
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN (unused; admin-only restart helper)
--
-- Original DG Script: #4369

-- Converted from DG Script #4369: **UNUSED**
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"restart"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
if actor.is_player then
    self:set_flag("sentinel", true)
    get_room(43, 51):at(function()
        run_room_trigger(43, 63)
    end)
    if actor:get_quest_stage("theatre") == 0 then
        actor:start_quest("theatre")
        actor:send("<b:white>You have begun the theatre quest!</>")
    end
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
        while i >= a do
            local member = actor.group_member[a]
            if member == actor then
                a = a + 1
            else
                if member and member.room == self.room then
                    if member:get_quest_stage("theatre") == 0 then
                        member:start_quest("theatre")
                        member:send("<b:white>You have begun the theatre quest!</>")
                    end
                elseif member then
                    i = i + 1
                end
            end
            a = a + 1
        end
    end
    wait(0.2)
    self:command("grin")
    wait(3)
    self:say("Then you'll need this.")
    self.room:spawn_object(43, 4)
    wait(0.4)
    self:emote("produces a key from his pocket.")
    self:command("give key " .. tostring(actor.name))
    wait(3)
    self:say("You should be able to reach their nest from our workshop in the back of the theater.  There's a second entrance above the balcony, but it's always locked from the other side.")
    wait(0.4)
    self:say("Good luck!")
    self:command("bow " .. tostring(actor.name))
    self:set_flag("sentinel", false)
end