-- Trigger: group_heal_status_check
-- Zone: 185, ID: 99
-- Type: MOB, Flags: SPEECH
--
-- Player asks the doctor for status/progress on the group_heal quest.
-- Reports the current stage and (for stages 5 and 6) the per-target
-- progress.
--
-- TODO(parity): the legacy quest-var keys ("group_heal:18515",
-- "group_heal:46414", etc.) use 5-digit vnums. 185_20/22/23 now write
-- keys in "<zone>_<id>" form. Update the read side here once the
-- imported world is verified, so the listed (zone, id) splits below
-- match what the writers actually use:
--   chefs: (83,7) (510,7) (185,12) (300,3) (502,3) (103,8)
--   targets: (185,6) (464,14) (430,20) (125,13) (361,3) (588,3) (300,54)

local s = string.lower(speech)
if not (string.find(s, "status") or string.find(s, "progress")) then
    return true
end

local stage = actor:get_quest_stage("group_heal")
wait(2)

if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'Please track down the bandit raider somewhere in the")
    self.room:send("</>Gothra desert and recover our stolen medical supplies.'")
    if world.count_mobiles(185, 22) == 0 then
        get_room(11, 0):at(function() self.room:spawn_mobile(185, 22) end)
        get_room(11, 0):at(function() self.room:spawn_object(161, 6) end)
        get_room(11, 0):at(function() self.room:spawn_object(161, 6) end)
        get_room(11, 0):at(function() self:command("give scimitar bandit") end)
        get_room(11, 0):at(function() self:command("give scimitar bandit") end)
        get_room(11, 0):at(function() self.room:find_actor("bandit"):command("wear all") end)
        get_room(11, 0):at(function() self.room:find_actor("bandit"):teleport(get_room(161, 86)) end)
    end
elseif stage == 2 then
    self:say("Please find the medical supplies stolen by the bandit raider.")
elseif stage == 3 or stage == 4 then
    self.room:send(tostring(self.name) .. " says, 'You are currently trying to locate the records of a group")
    self.room:send("</>healing ritual in a lost kitchen in the Great Northern Swamp.'")
elseif stage == 5 then
    self.room:send(tostring(self.name) .. " says, 'You are visiting every <b:white>chef</> and <b:white>cook</> to get their notes on")
    self.room:send("</>the healing ritual.'")
    -- TODO(parity): keys below should match writers (185_22 uses
    -- "<zone>_<id>"). Reading both legacy vnum keys and new keys for
    -- now during the migration window.
    local recipes = {
        { vnum_key = "group_heal:18515", new_key = "group_heal:83_7",   tpl = {83, 7}    },
        { vnum_key = "group_heal:18516", new_key = "group_heal:510_7",  tpl = {510, 7}   },
        { vnum_key = "group_heal:18517", new_key = "group_heal:185_12", tpl = {185, 12}  },
        { vnum_key = "group_heal:18518", new_key = "group_heal:300_3",  tpl = {300, 3}   },
        { vnum_key = "group_heal:18519", new_key = "group_heal:502_3",  tpl = {502, 3}   },
        { vnum_key = "group_heal:18520", new_key = "group_heal:103_8",  tpl = {103, 8}   },
    }
    local any = false
    for _, r in ipairs(recipes) do
        if actor:get_quest_var(r.vnum_key) or actor:get_quest_var(r.new_key) then
            any = true
            break
        end
    end
    if any then
        self.room:send("</>You have already brought me notes from:")
        for _, r in ipairs(recipes) do
            if actor:get_quest_var(r.vnum_key) or actor:get_quest_var(r.new_key) then
                self.room:send("- " .. tostring(mobiles.template(r.tpl[1], r.tpl[2]).name))
            end
        end
        local total = 6 - (actor:get_quest_var("group_heal:total") or 0)
        self.room:send("</>Bring me notes from " .. tostring(total) .. " more chefs.")
        self.room:send(tostring(self.name) .. " says, 'And if you need a new copy of the Rite, just say:")
        self.room:send("</><b:yellow>\"I lost the Rite\"</> and I will give you a new one.'")
    end
elseif stage == 6 then
    self.room:send(tostring(self.name) .. " says, 'You are delivering the medical packages to <b:white>injured</>, <b:white>wounded,")
    self.room:send("</><b:white>sick</>, or <b:white>hobbling</> creatures.'")
    local total = 5 - (actor:get_quest_var("group_heal:total") or 0)
    local people = {
        { vnum_key = "group_heal:18506", new_key = "group_heal:185_6",  tpl = {185, 6}   },
        { vnum_key = "group_heal:46414", new_key = "group_heal:464_14", tpl = {464, 14}  },
        { vnum_key = "group_heal:43020", new_key = "group_heal:430_20", tpl = {430, 20}  },
        { vnum_key = "group_heal:12513", new_key = "group_heal:125_13", tpl = {125, 13}  },
        { vnum_key = "group_heal:36103", new_key = "group_heal:361_3",  tpl = {361, 3}   },
        { vnum_key = "group_heal:58803", new_key = "group_heal:588_3",  tpl = {588, 3}   },
        { vnum_key = "group_heal:30054", new_key = "group_heal:300_54", tpl = {300, 54}  },
    }
    local any = false
    for _, p in ipairs(people) do
        if actor:get_quest_var(p.vnum_key) or actor:get_quest_var(p.new_key) then
            any = true
            break
        end
    end
    if any then
        self.room:send("You have aided:")
        for _, p in ipairs(people) do
            if actor:get_quest_var(p.vnum_key) or actor:get_quest_var(p.new_key) then
                self.room:send("- " .. tostring(mobiles.template(p.tpl[1], p.tpl[2]).name))
            end
        end
    end
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
