-- Trigger: ice_shards_status_tracker
-- Zone: 103, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #10318
-- Player asks about "ice shards progress" and Khysan summarises
-- the active quest stage. Stage 1 enumerates which of the four
-- foundational books are still missing. DG narg=0 = substring.

local s = string.lower(speech)
if not (string.find(s, "ice") or string.find(s, "shards") or string.find(s, "progress")) then
    return true
end

wait(2)
local stage = actor:get_quest_stage("ice_shards")

local function got(z, i)
    local v = actor:get_quest_var("ice_shards:" .. tostring(z) .. "_" .. tostring(i))
    return v and v ~= "" and v ~= "0"
end

if stage == 1 then
    local books = {
        {162, 9},   -- the Book of Kings
        {185, 5},   -- the Book of Discipline
        {550, 3},   -- the Xapizan Codex
        {584, 15},  -- the Enchiridion
    }
    self:say("You are looking for four books of mystic knowledge.")

    local any_in = false
    for _, b in ipairs(books) do
        if got(b[1], b[2]) then any_in = true; break end
    end
    if any_in then
        self.room:send("You have brought me:")
        for _, b in ipairs(books) do
            if got(b[1], b[2]) then
                self.room:send("- <b:yellow>" .. objects.template(b[1], b[2]).name .. "</>")
            end
        end
    end
    self.room:send("You still need to find:")
    for _, b in ipairs(books) do
        if not got(b[1], b[2]) then
            self.room:send("- <b:yellow>" .. objects.template(b[1], b[2]).name .. "</>")
        end
    end
elseif stage == 2 then
    self:say("I need you to find the Codex of War.")
elseif stage == 3 then
    self.room:send(self.name .. " says, 'You are looking for any records or journals Commander")
    self.room:send("</>Thraja keeps.'")
elseif stage == 4 then
    self.room:send(self.name .. " says, 'Talk to the pawnbroker in Anduin about the Butcher of")
    self.room:send("</>Anduin so you can find his map.'")
elseif stage == 5 then
    self.room:send(self.name .. " says, 'Talk to Slevvirik in Ogakh about the Butcher of Anduin")
    self.room:send("</>so you can find his map.'")
elseif stage == 6 then
    self:say("Bring the map of Ickle from the Butcher of Anduin.")
elseif stage == 7 then
    self.room:send(self.name .. " says, 'You are looking for any kind of written clues about the")
    self.room:send("</>library at Shiran in Ysgarran's Keep in Frost Valley.'")
elseif stage == 8 then
    self.room:send(self.name .. " says, 'You are looking for the Book of Redemption, whatever")
    self.room:send("</>that is.'")
elseif stage == 9 then
    self.room:send(self.name .. " says, 'You are looking for the lost library of Shiran in Frost")
    self.room:send("</>Valley!'")
elseif stage == 10 then
    self:say("Have you found the magic book in the lost library??")
elseif actor:get_has_completed("ice_shards") then
    self.room:send(self.name .. " says, 'You've already done a miraculous thing by bring the")
    self.room:send("</>Aqua Mundi to me!")
else
    self:say("Progress on what?  There's no fee to use the springs.")
    self:command("smile " .. actor.name)
end
