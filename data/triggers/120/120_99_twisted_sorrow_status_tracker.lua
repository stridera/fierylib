-- Trigger: twisted_sorrow_status_tracker
-- Zone: 120, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #12099
--
-- Player asks "progress?" — druid summarizes which Rhell trees have been
-- satisfied and which still need offerings.

-- Speech keywords: progress
local speech_lower = string.lower(speech)
if not string.find(speech_lower, "progress") then
    return true  -- No matching keywords
end

-- Each entry: { tree_room_local_id, quest_var_suffix }
-- Quest var key matches the legacy 5-digit room vnum used by trigger 120-3.
local trees = {
    { 16, "12016" },  -- Tree of Luck
    { 17, "12017" },  -- Tree of Reverence
    { 18, "12018" },  -- Tree of Self-Reliance
    { 14, "12014" },  -- Tree of Nimbleness
    { 46, "12046" },  -- Tree of Kindness
}

wait(4)
local stage = actor:get_quest_stage("twisted_sorrow")
if stage > 1 then
    self:command("smile " .. actor.name)
    wait(1)
    self:say("The trees are satisfied, my friend.")
    return true
end

if stage ~= 1 then
    return true
end

self:say("Bring drink to awaken the trees from the corruption.")

local any_satisfied = false
for _, t in ipairs(trees) do
    if actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) == 1 then
        any_satisfied = true
        break
    end
end

if any_satisfied then
    self.room:send("You have already awakened the following trees:")
    for _, t in ipairs(trees) do
        if actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) == 1 then
            self.room:send("- &9<blue>" .. get_room(120, t[1]).name .. "</>")
        end
    end
end

self.room:send("Offerings are still needed for:")
for _, t in ipairs(trees) do
    if actor:get_quest_var("twisted_sorrow:satisfied_tree:" .. t[2]) ~= 1 then
        self.room:send("- <green>" .. get_room(120, t[1]).name .. "</>")
    end
end
self.room:send("</>")
self:say("Say <b:cyan>\"follow me\"</> when you have an offering to present.")