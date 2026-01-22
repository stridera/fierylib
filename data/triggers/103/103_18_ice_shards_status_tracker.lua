-- Trigger: ice_shards_status_tracker
-- Zone: 103, ID: 18
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #10318

-- Converted from DG Script #10318: ice_shards_status_tracker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: ice shards progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "ice") or string.find(string.lower(speech), "shards") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("ice_shards")
if stage == 1 then
    local book1 = actor:get_quest_var("ice_shards:16209")
    local book2 = actor:get_quest_var("ice_shards:18505")
    local book3 = actor:get_quest_var("ice_shards:55003")
    local book4 = actor:get_quest_var("ice_shards:58415")
    self:say("You are looking for four books of mystic knowledge.")
    if book1 or book2 or book3 or book4 then
        -- (empty room echo)
        self.room:send("You have brought me:")
        if book1 then
            self.room:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
        end
        if book2 then
            self.room:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
        end
        if book3 then
            self.room:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
        end
        if book4 then
            self.room:send("- <b:yellow> " .. tostring(objects.template(584, 15).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not book1 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(162, 9).name) .. "</>")
    end
    if not book2 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(185, 5).name) .. "</>")
    end
    if not book3 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(550, 3).name) .. "</>")
    end
    if not book4 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(584, 15).name) .. "</>")
    end
elseif stage == 2 then
    self:say("I need you to find the Codex of War.")
elseif stage == 3 then
    self.room:send(tostring(self.name) .. " says, 'You are looking for any records or journals Commander")
    self.room:send("</>Thraja keeps.'")
elseif stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'Talk to the pawnbroker in Anduin about the Butcher of")
    self.room:send("</>Anduin so you can find his map.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'Talk to Slevvirik in Ogakh about the Butcher of Anduin")
    self.room:send("</>so you can find his map.'")
elseif stage == 6 then
    self:say("Bring the map of Ickle from the Butcher of Anduin.")
elseif stage == 7 then
    self.room:send(tostring(self.name) .. " says, 'You are looking for any kind of written clues about the")
    self.room:send("</>library at Shiran in Ysgarran's Keep in Frost Valley.'")
elseif stage == 8 then
    self.room:send(tostring(self.name) .. " says, 'You are looking for the Book of Redemption, whatever")
    self.room:send("</>that is.'")
elseif stage == 9 then
    self.room:send(tostring(self.name) .. " says, 'You are looking for the lost library of Shiran in Frost")
    self.room:send("</>Valley!'")
elseif stage == 10 then
    self:say("Have you found the magic book in the lost library??")
elseif actor:get_has_completed("ice_shards") then
    self.room:send(tostring(self.name) .. " says, 'You've already done a miraculous thing by bring the")
    self.room:send("</>Aqua Mundi to me!")
elseif not stage then
    self:say("Progress on what?  There's no fee to use the springs.")
    self:command("smile " .. tostring(actor))
end