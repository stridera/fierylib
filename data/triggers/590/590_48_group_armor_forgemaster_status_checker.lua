-- Trigger: group_armor_forgemaster_status_checker
-- Zone: 590, ID: 48
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 16 if statements
--
-- Original DG Script: #59048

-- Converted from DG Script #59048: group_armor_forgemaster_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("group_armor")
-- switch on stage
if stage == 1 then
    local item1 = actor:get_quest_var("group_armor:6118")
    local item2 = actor:get_quest_var("group_armor:11704")
    local item3 = actor:get_quest_var("group_armor:11707")
    local item4 = actor:get_quest_var("group_armor:16906")
    local obj1 = objects.template(61, 18).name
    local obj2 = objects.template(117, 4).name
    local obj3 = objects.template(117, 7).name
    local obj4 = objects.template(169, 6).name
    local step = "locate items that cast the spell &7&barmor&0"
elseif stage == 2 then
    local step = "replace my &7&bforging hammer&0"
elseif stage == 3 or stage == 4 then
    local step = "Take the forging hammer where light reaches deep underground and &7&b[commune]&0"
elseif stage == 5 then
    local step = "find a suitable amulet to be the focus of this spell"
    local item1 = actor:get_quest_var("group_armor:12500")
    local obj1 = objects.template(125, 0).name
elseif stage == 6 then
    local step = "locate ethereal items to provide protective energy to the amulet"
    local item1 = actor:get_quest_var("group_armor:47004")
    local item2 = actor:get_quest_var("group_armor:47018")
    local item3 = actor:get_quest_var("group_armor:53003")
    local obj1 = objects.template(470, 4).name
    local obj2 = objects.template(470, 18).name
    local obj3 = objects.template(530, 3).name
else
    if actor:get_has_completed("group_armor") then
        if actor.gender == "male" then
            self:say("You've already helped me lad.")
        elseif actor.gender == "female" then
            self:say("You've already helped me lass.")
        end
        return _return_value
    else
        self:say("You aren't doing anything for me at the moment.")
        return _return_value
    end
end
wait(2)
self:say("You are trying to:")
self.room:send(tostring(step) .. ".")
if stage == 1 or stage == 5 or stage == 6 then
    if item1 or item2 or item3 or item4 then
        -- (empty room echo)
        self.room:send("You have already brought me:")
        if item1 then
            self.room:send("- " .. tostring(obj1))
        end
        if item2 then
            self.room:send("- " .. tostring(obj2))
        end
        if item3 then
            self.room:send("- " .. tostring(obj3))
        end
        if item4 then
            self.room:send("- " .. tostring(obj4))
        end
    end
    -- (empty room echo)
    self.room:send("You need to locate:")
    if not item1 then
        self.room:send("- <b:yellow>" .. tostring(obj1) .. "</>")
    end
    if stage == 1 or stage == 6 then
        if not item2 then
            self.room:send("- <b:yellow>" .. tostring(obj2) .. "</>")
        end
        if not item3 then
            self.room:send("- <b:yellow>" .. tostring(obj3) .. "</>")
        end
        if stage == 1 then
            if not item4 then
                self.room:send("- <b:yellow>" .. tostring(obj4) .. "</>")
            end
        end
    end
end