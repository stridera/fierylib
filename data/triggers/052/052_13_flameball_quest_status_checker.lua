-- Trigger: Flameball quest status checker
-- Zone: 52, ID: 13
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #5213
--
-- "quest"/"progress" status check for the emmath_flameball quest. Stage 2
-- shows a have/need list of the three flames keyed by quest var. Probability
-- 0 in the legacy DG meant keyword-only (no random firing) — preserved as a
-- straight keyword guard with no random gate.
--
-- TODO: keys "emmath_flameball:17308", "emmath_flameball:5211",
--       "emmath_flameball:5212" use legacy vnums; should match the
--       composite "{zone}_{local}" form set in 052_08 once aligned.
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "quest") or string.find(speech_lower, "progress")) then
    return true
end

wait(2)
if actor:get_quest_stage("emmath_flameball") == 1 then
    actor:send(tostring(self.name) .. " says, 'Do you still seek this ball of flame?'")
    self:command("ponder")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Ah, to hold it in your palm...  You would need to prove your worth for such power.'")
    self:emote("looks thoughtful for a moment.")
elseif actor:get_quest_stage("emmath_flameball") == 2 then
    actor:send(tostring(self.name) .. " says, 'You need to show mastery over the fire.'")
    self:emote("pulls out his well-used thinking cap, and begins to think.")
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Bring me the three parts of flame: <b:white>White</>, <blue>Gray</>, and &9<blue>Black</>.  I think we can talk again then.'")
    local black = actor:get_quest_var("emmath_flameball:17308")
    local white = actor:get_quest_var("emmath_flameball:5211")
    local gray = actor:get_quest_var("emmath_flameball:5212")
    if black or white or gray then
            self.room:send("You have brought me:")
        if white then
            self.room:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</>")
        end
        if gray then
            self.room:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</>")
        end
        if black then
            self.room:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. "</>")
        end
    end
    self.room:send("I still need:")
    if not white then
        self.room:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</>")
    end
    if not gray then
        self.room:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</>")
    end
    if not black then
        self.room:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. "</>")
    end
    wait(3)
    actor:send(tostring(self.name) .. " says, 'Well?  Go on, then!'")
elseif actor:get_quest_stage("emmath_flameball") == 3 then
    self:command("peer " .. tostring(actor.name))
    actor:send(tostring(self.name) .. " says, 'Didn't we talk about this already?'")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'Bring me the renegade <b:blue>blue flame</>!'")
else
    actor:send(tostring(self.name) .. " says, 'What quest?  You don't work for me.'")
end