-- Trigger: wise_woman_give_parchment
-- Zone: 481, ID: 9
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #48109

-- Converted from DG Script #48109: wise_woman_give_parchment
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
if object.id == 48124 then
    wait(2)
    world.destroy(object)
    local stage = 4
    local person = actor
    local i = person.group_size
    if i then
        local a = 1
    else
        local a = 0
    end
    while i >= a do
        local person = actor.group_member[a]
        if person.room == self.room then
            if person:get_quest_stage("fieryisle_quest") == "stage" then
                local accept = "yes"
                person.name:advance_quest("fieryisle_quest")
                person:send("<b:white>You have advanced your quest!</>")
            end
        elseif person and person.id == -1 then
            local i = i + 1
        end
        local a = a + 1
    end
    if accept == "yes" then
        if not world.count_mobiles("48107") then
            get_room(11, 0):at(function()
                self.room:spawn_mobile(481, 7)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("ash-lord"):spawn_object(481, 24)
            end)
            get_room(11, 0):at(function()
                self.room:find_actor("ash-lord"):command("wear ash-crown")
            end)
            self.room:find_actor("ash-lord"):teleport(get_room(481, 57))
        end
        if not world.count_mobiles("48127") then
            get_room(481, 97):at(function()
                self.room:spawn_mobile(481, 27)
            end)
        end
        self:emote("almost looks happy for a moment.")
        self.room:send(tostring(self.name) .. " says, 'Thank you " .. tostring(actor.name) .. ", killing the ash lord avenges many of my people who have died under his rule.  The only thing I have of any value is a spell of reversal, which can reverse a shape change spell.'")
        self:emote("seems to consider for a short while.")
        wait(3)
        self.room:send(tostring(self.name) .. " says, 'I already gave a copy of this to a young boy searching for his friend.'")
        wait(3)
        self:command("sigh")
        self.room:send(tostring(self.name) .. " says, 'Perhaps he is dead now.  Here is another copy of it for you.'")
        self:emote("writes some words on a piece of parchment.")
        self.room:spawn_object(481, 25)
        self:command("give parchment " .. tostring(actor.name))
        wait(4)
        self.room:send(tostring(self.name) .. " says, 'Best of luck in finding whatever or whomever you have lost.")
        wait(2)
        self:command("whap wise-woman")
        self.room:send(tostring(self.name) .. " says, 'I almost forgot, to activate the spell, you must hold the parchment.'")
    else
        if actor:get_quest_stage("fieryisle_quest") > stage then
            self.room:send(tostring(self.name) .. " says, 'I am not going to write you another spell.'")
        else
            -- quest stage < 4 or not started..how did they get the crown?
            self:command("glare " .. tostring(actor.name))
            self.room:send(tostring(self.name) .. " says, 'What is this insolence?  You hand me a crown without killing the Ash Lord.'")
            self:emote("crumbles the crown between her fingers.")
            self:command("fume")
        end
    end
end