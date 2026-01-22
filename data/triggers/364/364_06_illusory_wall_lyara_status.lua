-- Trigger: illusory_wall_lyara_status
-- Zone: 364, ID: 6
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--   Refactored: Replaced 90+ if-statements with data-driven region table
--
-- Original DG Script: #36406

-- Converted from DG Script #36406: illusory_wall_lyara_status
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Load shared region data
local REGIONS = require("shared.illusory_wall_regions")

--- Display completed regions to the room
local function display_completed_regions(room, actor)
    for _, region in ipairs(REGIONS) do
        if actor:get_quest_var("illusory_wall:" .. region.key) then
            room:send("- <blue>" .. region.display .. "</>")
        end
    end
end

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(speech_lower, "status") or string.find(speech_lower, "progress")) then
    return true  -- No matching keywords
end

local stage = actor:get_quest_stage("illusory_wall")
local item1 = actor:get_quest_var("illusory_wall:10307")
local item2 = actor:get_quest_var("illusory_wall:18511")
local item3 = actor:get_quest_var("illusory_wall:41005")
local item4 = actor:get_quest_var("illusory_wall:51017")

wait(2)

if actor.class ~= "illusionist" and actor.class ~= "bard" then
    self.room:send(tostring(self.name) .. " says, 'I appreciate your interest but I have nothing I")
    self.room:send("</>can teach you.'")

elseif actor:get_has_completed("illusory_wall") then
    self.room:send(tostring(self.name) .. " says, 'I have already taught you <b:magenta>I<cyan>l<magenta>l<cyan>u<magenta>s<cyan>o<magenta>r<cyan>y <magenta>W<cyan>a<magenta>l<cyan>l</>.")
    self.room:send("</>I have nothing else to teach you, soldier.'")
    self:command("salute " .. tostring(actor.name))

elseif stage == 0 then
    self:say("I haven't agreed to teach you yet.")

elseif stage == 1 then
    -- Stage 1: Collect items for magical spectacles
    self:say("You're looking for things to make magical spectacles.")

    if item1 or item2 or item3 or item4 then
        self.room:send("</>You have already brought me:")
        if item1 then
            self.room:send("- <b:white>" .. tostring(objects.template(103, 7).name) .. "</>")
        end
        if item2 then
            self.room:send("- <b:white>" .. tostring(objects.template(185, 11).name) .. "</>")
        end
        if item3 then
            self.room:send("- <b:white>" .. tostring(objects.template(410, 5).name) .. "</>")
        end
        if item4 then
            self.room:send("- <b:white>" .. tostring(objects.template(510, 17).name) .. "</>")
        end
    end

    self.room:send("You still need to find:")
    if not item1 and not item2 then
        self.room:send("- <b:yellow>" .. "%get.obj_shortdesc[10307]%</> or <b:yellow>%get.obj_shortdesc[18511]%</>")
    end
    if not item3 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(410, 5).name) .. "</>")
    end
    if not item4 then
        self.room:send("- <b:yellow>" .. tostring(objects.template(510, 17).name) .. "</>")
    end

elseif stage == 2 then
    -- Stage 2: Study doors in 20 regions
    self:say("Complete your study of doors in 20 regions.")
    local doors = actor:get_quest_var("illusory_wall:total")
    self.room:send("You have examined doors in <b:magenta>" .. tostring(doors) .. "</> regions:")

    display_completed_regions(self.room, actor)

    local remaining = (20 - doors)
    self.room:send("Locate doors in <b:magenta>" .. tostring(remaining) .. "</> more regions.")
    self.room:send("If you need new lenses say, <b:magenta>\"I need new glasses\"</>.")
end
