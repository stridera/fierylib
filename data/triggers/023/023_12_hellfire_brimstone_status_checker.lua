-- Trigger: hellfire_brimstone_status_checker
-- Zone: 23, ID: 12
-- Type: MOB, Flags: SPEECH
-- Status: REVIEWED (synthetic 0% gate removed; nil-arith guarded)
--
-- Original DG Script: #2312
-- Patriarch reports the player's progress through the Hellfire-and-Brimstone
-- quest when they ask about "spell progress".
--
-- TODO(parity): Item progress is keyed by legacy 5-digit-style ids
-- ("hellfire_brimstone:4318" etc.) but 023_01 sets composite keys
-- ("hellfire_brimstone:43_18"). Reconcile with 023_01.

-- Speech keywords: "spell" or "progress"
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("hellfire_brimstone")
local meat = actor:get_quest_var("hellfire_brimstone:meat") or 0
local brimstone = actor:get_quest_var("hellfire_brimstone:brimstone") or 0
local item1 = actor:get_quest_var("hellfire_brimstone:4318")
local item2 = actor:get_quest_var("hellfire_brimstone:5211")
local item3 = actor:get_quest_var("hellfire_brimstone:5212")
local item4 = actor:get_quest_var("hellfire_brimstone:17308")
local item5 = actor:get_quest_var("hellfire_brimstone:48110")
local item6 = actor:get_quest_var("hellfire_brimstone:53000")
wait(2)
-- switch on stage
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'I need <b:red>meat</> for the fire.'")
    local total = (6 - meat)
    if total == 1 then
        self.room:send("Bring me <b:red>" .. tostring(total) .. "</> more pound of flesh from the paladins at the Sacred Haven.")
    else
        self.room:send("Bring me <b:red>" .. tostring(total) .. "</> more pounds of flesh from the paladins at the Sacred Haven.")
    end
elseif stage == 2 then
    self.room:send(tostring(self.name) .. " says, 'I need <b:yellow>brimstone</> to trace out the sigils.'")
    self.room:send("</>")
    local total = (6 - brimstone)
    if total == 1 then
        self.room:send("Bring me <b:yellow>" .. tostring(total) .. "</> more quantity of brimstone from fiery spirits on the")
        self.room:send("</>volcanic island to the north.")
    else
        self.room:send("Bring <b:yellow>" .. tostring(total) .. "</> more quantities of brimstone from fiery spirits on the")
        self.room:send("</>volcanic island to the north.")
    end
elseif stage == 3 then
    self:say("You are to bring me fiery tributes to the Dark One.")
    self.room:send("</>")
    if item1 or item2 or item3 or item4 or item5 or item6 then
        self.room:send("You have already given me:")
        if item1 then
            self.room:send("- " .. tostring(objects.template(43, 18).name))
        end
        if item2 then
            self.room:send("- " .. tostring(objects.template(52, 11).name))
        end
        if item3 then
            self.room:send("- " .. tostring(objects.template(52, 12).name))
        end
        if item4 then
            self.room:send("- " .. tostring(objects.template(173, 8).name))
        end
        if item5 then
            self.room:send("- " .. tostring(objects.template(481, 10).name))
        end
        if item6 then
            self.room:send("- " .. tostring(objects.template(530, 0).name))
        end
    end
    self.room:send("</>")
    self.room:send("Now bring me:")
    if not item1 then
        self.room:send("- " .. tostring(objects.template(43, 18).name) .. "</>from an actress in Anduin.</>")
    end
    if not item2 then
        self.room:send("- <b:white>" .. tostring(objects.template(52, 11).name) .. "</> from a beam of starlight deep in mine.</>")
    end
    if not item3 then
        self.room:send("- <blue>" .. tostring(objects.template(52, 12).name) .. "</> from a devotee of neutrality on a hill.</>")
    end
    if not item4 then
        self.room:send("- &9<blue>" .. tostring(objects.template(173, 8).name) .. " from Chaos incarnate.</>")
    end
    if not item5 then
        self.room:send("- <b:red>" .. tostring(objects.template(481, 10).name) .. "</> from the volcano goddess.</>")
    end
    if not item6 then
        self.room:send("- " .. tostring(objects.template(530, 0).name) .. "</> from a king in a throne room crypt.</>")
    end
else
    if actor:get_has_completed("hellfire_brimstone") then
        self:say("You have already earned the favor of the Dark One.")
    end
end