-- Trigger: twisted_sorrow_status_tracker
-- Zone: 120, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12099

-- Converted from DG Script #12099: twisted_sorrow_status_tracker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local luck = actor:get_quest_var("twisted_sorrow:satisfied_tree:12016")
local reverence = actor:get_quest_var("twisted_sorrow:satisfied_tree:12017")
local reliance = actor:get_quest_var("twisted_sorrow:satisfied_tree:12018")
local nimbleness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12014")
local kindness = actor:get_quest_var("twisted_sorrow:satisfied_tree:12046")
local tree1 = get_room("12016")
local tree2 = get_room("12017")
local tree3 = get_room("12018")
local tree4 = get_room("12014")
local tree5 = get_room("12046")
wait(4)
if actor:get_quest_stage("twisted_sorrow") > 1 then
    self:command("smile " .. tostring(actor.name))
    wait(1)
    self:say("The trees are satisfied, my friend.")
elseif actor:get_quest_stage("twisted_sorrow") == 1 then
    self:say("Bring drink to awaken the trees from the corruption.")
    if luck == 1 or reverence == 1 or reliance == 1 or nimbleness == 1 or kindness == 1 then
        -- (empty room echo)
        self.room:send("You have already awakened the following trees:")
        if luck == 1 then
            self.room:send("- &9<blue>" .. tostring(tree1.name) .. "</>")
        end
        if reverence == 1 then
            self.room:send("- &9<blue>" .. tostring(tree2.name) .. "</>")
        end
        if reliance == 1 then
            self.room:send("- &9<blue>" .. tostring(tree3.name) .. "</>")
        end
        if nimbleness == 1 then
            self.room:send("- &9<blue>" .. tostring(tree4.name) .. "</>")
        end
        if kindness == 1 then
            self.room:send("- &9<blue>" .. tostring(tree5.name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("Offerings are still needed for:")
    if luck == 0 then
        self.room:send("- <green>" .. tostring(tree1.name) .. "</>")
    end
    if reverence == 0 then
        self.room:send("- <green>" .. tostring(tree2.name) .. "</>")
    end
    if reliance == 0 then
        self.room:send("- <green>" .. tostring(tree3.name) .. "</>")
    end
    if nimbleness == 0 then
        self.room:send("- <green>" .. tostring(tree4.name) .. "</>")
    end
    if kindness == 0 then
        self.room:send("- <green>" .. tostring(tree5.name) .. "</>")
    end
    self.room:send("</>")
    self:say("Say <b:cyan>\"follow me\"</> when you have an offering to present.")
end