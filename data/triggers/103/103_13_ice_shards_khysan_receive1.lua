-- Trigger: ice_shards_khysan_receive1
-- Zone: 103, ID: 13
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10313

-- Converted from DG Script #10313: ice_shards_khysan_receive1
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
local _return_value = true  -- Default: allow action
local stage = actor:get_quest_stage("ice_shards")
if stage == 1 then
    if actor.quest_variable["ice_shards:object.vnum"] == 1 then
        _return_value = false
        self.room:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
        wait(2)
        self:say("Thanks, but you already delivered " .. tostring(object.shortdesc) .. " to me.")
    else
        actor.name:set_quest_var("ice_shards", "%object.vnum%", 1)
        self:destroy_item("book")
        wait(2)
        self.room:send(tostring(self.name) .. "'s eyes grow wide.")
        -- (empty room echo)
        self:say("This is incredible!  I never imagined I'd be holding a copy of " .. tostring(object.shortdesc) .. "!")
        wait(2)
        local book1 = actor:get_quest_var("ice_shards:16209")
        local book2 = actor:get_quest_var("ice_shards:18505")
        local book3 = actor:get_quest_var("ice_shards:55003")
        local book4 = actor:get_quest_var("ice_shards:58415")
        if book1 and book2 and book3 and book4 then
            actor.name:advance_quest("ice_shards")
            self:emote("slowly reads through the contents of each book.")
            wait(4)
            self:emote("takes copious notes.")
            wait(1)
            self:say("Hmmmm, I wonder if...")
            wait(1)
            self:say("No, that won't work...")
            wait(4)
            self:emote("sighs with frustration.")
            self:say("I hate to say it, but this isn't going to cut it.  The texts just don't have enough information about the spell.")
            wait(3)
            self:command("ponder")
            self.room:send(tostring(self.name) .. " says, 'There is a mention of Shiran being near Mt. Frostbite in the Xapizan Codex however.  It also mentions a brother codex called <b:yellow>\"The Codex of War\"</>.")
            wait(2)
            self:say("Supposedly, the Codex of War contains a detailed history of battles in the region.  Maybe if Shiran was destroyed in some kind of conflict, the Codex of War might have more clues.")
            wait(2)
            self:say("Try to find a copy and bring it back so we can take a look at it!")
        else
            self:say("Did you manage to find any of the other books?")
        end
    end
end
return _return_value