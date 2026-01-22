-- Trigger: group_heal_status_check
-- Zone: 185, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 21 if statements
--   Large script: 6055 chars
--
-- Original DG Script: #18599

-- Converted from DG Script #18599: group_heal_status_check
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("group_heal")
wait(2)
-- switch on stage
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Please track down the bandit raider somewhere in the")
    self.room:send("</>Gothra desert and recover our stolen medical supplies.'")
    if world.count_mobiles("18522") == 0 then
        get_room(11, 0):at(function()
            self.room:spawn_mobile(185, 22)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self.room:spawn_object(161, 6)
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self:command("give scimitar bandit")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):command("wear all")
        end)
        get_room(11, 0):at(function()
            self.room:find_actor("bandit"):teleport(get_room(161, 86))
        end)
    end
elseif stage == 2 then
    self:say("Please find the medical supplies stolen by the bandit raider.")
elseif stage == 3 or stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'You are currently trying to locate the records of a group")
    self.room:send("</>healing ritual in a lost kitchen in the Great Northern Swamp.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'You are visiting every <b:white>chef</> and <b:white>cook</> to get their notes on")
    self.room:send("</>the healing ritual.'")
    -- (empty room echo)
    local recipe1 = actor:get_quest_var("group_heal:18515")
    local recipe2 = actor:get_quest_var("group_heal:18516")
    local recipe3 = actor:get_quest_var("group_heal:18517")
    local recipe4 = actor:get_quest_var("group_heal:18518")
    local recipe5 = actor:get_quest_var("group_heal:18519")
    local recipe6 = actor:get_quest_var("group_heal:18520")
    if recipe1 or recipe2 or recipe3 or recipe4 or recipe5 or recipe6 then
        self.room:send("</>You have already brought me notes from:")
        if recipe1 then
            self.room:send("- " .. tostring(mobiles.template(83, 7).name))
        end
        if recipe2 then
            self.room:send("- " .. tostring(mobiles.template(510, 7).name))
        end
        if recipe3 then
            self.room:send("- " .. tostring(mobiles.template(185, 12).name))
        end
        if recipe4 then
            self.room:send("- " .. tostring(mobiles.template(300, 3).name))
        end
        if recipe5 then
            self.room:send("- " .. tostring(mobiles.template(502, 3).name))
        end
        if recipe6 then
            self.room:send("- " .. tostring(mobiles.template(103, 8).name))
        end
        -- (empty room echo)
        local total = 6 - actor:get_quest_var("group_heal:total")
        self.room:send("</>Bring me notes from " .. tostring(total) .. " more chefs.")
        -- (empty room echo)
        self.room:send(tostring(self.name) .. " says, 'And if you need a new copy of the Rite, just say:")
        self.room:send("</><b:yellow>\"I lost the Rite\"</> and I will give you a new one.'")
    end
elseif stage == 6 then
        self.room:send(tostring(self.name) .. " says, 'You are delivering the medical packages to <b:white>injured</>, <b:white>wounded,")
        self.room:send("</><b:white>sick</>, or <b:white>hobbling</> creatures.'")
        local total = (5 - actor:get_quest_var("group_heal:total"))
        local person1 = actor:get_quest_var("group_heal:18506")
        local person2 = actor:get_quest_var("group_heal:46414")
        local person3 = actor:get_quest_var("group_heal:43020")
        local person4 = actor:get_quest_var("group_heal:12513")
        local person5 = actor:get_quest_var("group_heal:36103")
        local person6 = actor:get_quest_var("group_heal:58803")
        local person7 = actor:get_quest_var("group_heal:30054")
        -- (empty room echo)
        if person1 or person2 or person3 or person4 or person5 or person6 or person7 then
            self.room:send("You have aided:")
            if person1 then
                self.room:send("- " .. tostring(mobiles.template(185, 6).name))
            end
            if person2 then
                self.room:send("- " .. tostring(mobiles.template(464, 14).name))
            end
            if person3 then
                self.room:send("- " .. tostring(mobiles.template(430, 20).name))
            end
            if person4 then
                self.room:send("- " .. tostring(mobiles.template(125, 13).name))
            end
            if person5 then
                self.room:send("- " .. tostring(mobiles.template(361, 3).name))
            end
            if person6 then
                self.room:send("- " .. tostring(mobiles.template(588, 3).name))
            end
            if person7 then
                self.room:send("- " .. tostring(mobiles.template(300, 54).name))
            end
        end
        -- (empty room echo)
    if total == 1 then
        self.room:send("You need to deliver " .. tostring(total) .. " more packet.")
    else
        self.room:send("You need to deliver " .. tostring(total) .. " more packets.")
    end
else
    if actor:get_has_completed("group_heal") then
        self:say("You finished the quest to learn Group Heal already.")
    else
        self:say("You aren't working on a quest with me.")
    end
end