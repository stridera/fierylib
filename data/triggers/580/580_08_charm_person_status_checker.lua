-- Trigger: charm_person_status_checker
-- Zone: 580, ID: 8
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--
-- Hinazuru reports the player's charm_person quest progress when they
-- ask about "spell progress": which instruments have been collected at
-- stage 3, which charmers have been serenaded at stage 4, etc.
--
-- TODO: legacy DG probability was 0%; preserved here, but the keyword
-- gate is the real driver -- 0% means the trigger never actually fires.
-- TODO: quest_vars are read using legacy-vnum keys
-- ("charm_person:58017", ":charm1", etc). Set sites in 580_05 / 580_07 /
-- 580_10 use composite "<zone>_<id>" keys, so these reads never see
-- writes and the helpful progress lists stay empty. Unify the keys.

-- 0% chance to trigger (preserved from original DG -- see TODO)
if not percent_chance(0) then
    return true
end

-- Speech keywords: spell / progress
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "spell") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("charm_person")
if actor:get_has_completed("charm_person") then
    self:say("I have already taught you my signature spell.")
elseif stage == 0 then
    self:say("I have not yet agreed to train you.")
elseif stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'You must find the rod that casts Charm Person in the crypt in")
    self.room:send("</>the Iron Hills.'")
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'Help the theatre company in Anduin perform their grand finale")
    self.room:send("</>and bring back the unique fire ring they give out afterward.'")
    wait(1)
    self.room:send(tostring(self.name) .. " says, 'They have a number of problems which you will need to work out")
    self.room:send("</>before you can seek out their replacement \"Pippin\" and lure him to his fiery grave.'")
elseif stage == 3 then
    self:say("Locate five musical instruments and bring them to me.")
    if actor:get_quest_var("charm_person:58017") or actor:get_quest_var("charm_person:16312") or actor:get_quest_var("charm_person:48925") or actor:get_quest_var("charm_person:37012") or actor:get_quest_var("charm_person:41119") then
        -- (empty room echo)
        self.room:send("You have already brought me:")
        if actor:get_quest_var("charm_person:58017") then
            self.room:send("- <magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:16312") then
            self.room:send("- <magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:48925") then
            self.room:send("- <magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:37012") then
            self.room:send("- <magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:41119") then
            self.room:send("- <magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not actor:get_quest_var("charm_person:58017") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(580, 17).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:16312") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(163, 12).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:48925") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(489, 25).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:37012") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(370, 12).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:41119") then
        self.room:send("- <b:magenta>" .. tostring(objects.template(411, 19).name) .. "</>")
    end
elseif stage == 4 then
    self:say("You must charm the five master charmers.")
    self.room:send("Ask them <b:white>[Let me serenade you]</>.")
    if actor:get_quest_var("charm_person:charm1") or actor:get_quest_var("charm_person:charm2") or actor:get_quest_var("charm_person:charm3") or actor:get_quest_var("charm_person:charm4") or actor:get_quest_var("charm_person:charm5") then
        -- (empty room echo)
        self.room:send("You have already charmed:")
        if actor:get_quest_var("charm_person:charm1") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm2") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm3") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm4") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
        end
        if actor:get_quest_var("charm_person:charm5") then
            self.room:send("- <magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You still need to find:")
    if not actor:get_quest_var("charm_person:charm1") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(30, 10).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm2") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(580, 17).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm3") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(43, 53).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm4") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(237, 21).name) .. "</>")
    end
    if not actor:get_quest_var("charm_person:charm5") then
        self.room:send("- <b:magenta>" .. tostring(mobiles.template(584, 6).name) .. "</>")
    end
end