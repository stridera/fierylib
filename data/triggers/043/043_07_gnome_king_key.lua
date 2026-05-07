-- Trigger: gnome_king_key
-- Zone: 43, ID: 7
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #4307

-- Converted from DG Script #4307: gnome_king_key
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: yes
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "yes")) then
    return true  -- No matching keywords
end
if actor.is_player then
    self:set_flag("sentinel", true)
    get_room(43, 51):at(function()
        run_room_trigger(43, 63)
    end)
    local person = actor
    local i = person.group_size
    local a
    if i then
        a = 1
    else
        a = 0
    end
    while i >= a do
        local member = actor.group_member[a]
        if member and member.room == self.room then
            if member:get_quest_stage("theatre") == 0 then
                member:start_quest("theatre")
                member:send("<b:white>You have begun the theatre quest!</>")
            end
        elseif member then
            i = i + 1
        end
        a = a + 1
    end
    wait(2)
    self:command("grin")
    wait(3)
    self:say("Then you'll need this.")
    self.room:spawn_object(43, 4)
    wait(4)
    self:emote("produces a key from his pocket.")
    self:command("give key " .. tostring(actor.name))
    wait(3)
    self:say("You should be able to reach their nest from our workshop in the back of the theater.  There's a second entrance above the balcony, but it's always locked from the other side.")
    wait(4)
    self:say("Good luck!")
    self:command("bow " .. tostring(actor.name))
    self:set_flag("sentinel", false)
end