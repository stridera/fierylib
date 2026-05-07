-- Trigger: ice_shards_khysan_receive1
-- Zone: 103, ID: 13
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Original DG Script: #10313
-- Stage 1 turn-in. Khysan accepts each of the four candidate
-- books exactly once; per-book dedup keys are stored as
-- ice_shards:<zone>_<id>. When all four arrive, advances the
-- quest and pivots the player toward the Codex of War.

if actor:get_quest_stage("ice_shards") ~= 1 then
    return true
end

local key = "ice_shards:" .. tostring(object.zone_id) .. "_" .. tostring(object.local_id)
local prior = actor:get_quest_var(key)
if prior and prior ~= "" and prior ~= "0" then
    self.room:send(self.name .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(2)
    self:say("Thanks, but you already delivered " .. tostring(object.shortdesc) .. " to me.")
    return false
end

actor:set_quest_var("ice_shards", tostring(object.zone_id) .. "_" .. tostring(object.local_id), 1)
self:destroy_item("book")
wait(2)
self.room:send(self.name .. "'s eyes grow wide.")
self:say("This is incredible!  I never imagined I'd be holding a copy of " .. tostring(object.shortdesc) .. "!")
wait(2)

-- The four target books, looked up by composite (zone, id):
--   16209 → (162, 9)   the Book of Kings
--   18505 → (185, 5)   the Book of Discipline
--   55003 → (550, 3)   the Xapizan Codex
--   58415 → (584, 15)  the Enchiridion
local function got(z, i)
    local v = actor:get_quest_var("ice_shards:" .. tostring(z) .. "_" .. tostring(i))
    return v and v ~= "" and v ~= "0"
end

if got(162, 9) and got(185, 5) and got(550, 3) and got(584, 15) then
    actor:advance_quest("ice_shards")
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
    self.room:send(self.name .. " says, 'There is a mention of Shiran being near Mt. Frostbite in the Xapizan Codex however.  It also mentions a brother codex called <b:yellow>\"The Codex of War\"</>.")
    wait(2)
    self:say("Supposedly, the Codex of War contains a detailed history of battles in the region.  Maybe if Shiran was destroyed in some kind of conflict, the Codex of War might have more clues.")
    wait(2)
    self:say("Try to find a copy and bring it back so we can take a look at it!")
else
    self:say("Did you manage to find any of the other books?")
end

return true
