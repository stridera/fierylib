-- Trigger: major_globe_quest_status_checker
-- Zone: 534, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 10 if statements
--
-- Original DG Script: #53499

-- Converted from DG Script #53499: major_globe_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%

-- 0% chance to trigger
if not percent_chance(0) then
    return true
end

-- Speech keywords: spell progress
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "spell") or string.find(string.lower(speech), "progress")) then
    return true  -- No matching keywords
end
wait(2)
local stage = actor:get_quest_stage("major_globe_spell")
-- switch on stage
if stage == 1 then
    actor:send(tostring(self.name) .. " says, 'Find Earle and tell him <b:cyan>\"Lirne sends me.\"</>'")
elseif stage == 2 then
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>shale</> on Fiery Island.  Bring it to Earle on Griffin Island.'")
elseif stage == 3 then
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>sake</> in Odaishyozen.  Bring it to Earle on Griffin Island.'")
elseif stage == 4 then
    actor:send(tostring(self.name) .. " says, 'Find a <b:yellow>marigold poultice</> on a healer in South Caelia.  Bring it to Earle on Griffin Island.'")
elseif stage == 5 then
    actor:send(tostring(self.name) .. " says, 'Bring me the <b:yellow>salve</> Earle prepared.'")
elseif stage == 6 then
    actor:send(tostring(self.name) .. " says, 'Find the <b:yellow>lost spellbook</> in a <b:cyan>library</> or <b:cyan>stack</>.'")
elseif stage == 7 then
    actor:send(tostring(self.name) .. " says, 'Bring <b:yellow>" .. tostring(objects.template(534, 52).name) .. "</> to me.'")
elseif stage == 8 then
    local plant = actor:get_quest_var("major_globe_spell:ward_53453")
    local mist = actor:get_quest_var("major_globe_spell:ward_53454")
    local water = actor:get_quest_var("major_globe_spell:ward_53455")
    local flame = actor:get_quest_var("major_globe_spell:ward_53456")
    local ice = actor:get_quest_var("major_globe_spell:ward_53457")
    actor:send(tostring(self.name) .. " says, 'Bring <b:yellow>5 elemental wards</>, one each from a mist, a water, an ice, a flame, and a plant elemental.'")
    local wards = actor:get_quest_var("major_globe_spell:ward_count")
    if wards then
        actor:send("You have found: <b:yellow>" .. tostring(wards) .. " wards</>")
    else
        actor:send("You have found: <b:yellow>0 wards</>")
    end
    if plant == 2 then
        actor:send(tostring(objects.template(534, 53).name))
    end
    if mist == 2 then
        actor:send(tostring(objects.template(534, 54).name))
    end
    if water == 2 then
        actor:send(tostring(objects.template(534, 55).name))
    end
    if flame == 2 then
        actor:send(tostring(objects.template(534, 56).name))
    end
    if ice == 2 then
        actor:send(tostring(objects.template(534, 57).name))
    end
elseif stage == 9 then
    local final_item = actor:get_quest_var("major_globe_spell:final_item")
    -- switch on final_item
    if final_item == 53458 then
        local place = "in a border keep"
    elseif final_item == 53459 then
        local place = "on an emerald isle"
    elseif final_item == 53460 then
        local place = "within a misty fortress"
    else
        local place = "in an underground city"
    end
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>" .. "%get.obj_shortdesc[%final_item%]%</> in %place%.'")
    local final_item = actor:get_quest_var("major_globe_spell:final_item")
    actor:send(tostring(self.name) .. " says, 'Bring me <b:cyan>" .. "%get.obj_shortdesc[%final_item%]%</>.'")
end  -- auto-close block