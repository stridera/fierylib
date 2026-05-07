-- Trigger: major_globe_quest_status_checker
-- Zone: 534, ID: 99
-- Type: MOB, Flags: SPEECH
-- Status: CLEAN
--
-- Original DG Script: #53499

-- Converted from DG Script #53499: major_globe_quest_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 0%
-- NOTE: legacy probability 0% on SPEECH means "always run on keyword match";
-- the converter's percent_chance(0) gate has been removed.

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
    -- TODO(parity): trigger 53457 stores ward keys as "ward_<local_id>" with
    -- ids 53-57 (zone 534). Legacy DG used 5-digit vnums 53453-53457; keep the
    -- new local-id convention here.
    local plant = actor:get_quest_var("major_globe_spell:ward_53")
    local mist = actor:get_quest_var("major_globe_spell:ward_54")
    local water = actor:get_quest_var("major_globe_spell:ward_55")
    local flame = actor:get_quest_var("major_globe_spell:ward_56")
    local ice = actor:get_quest_var("major_globe_spell:ward_57")
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
    -- final_item now stores the chosen object's local id within zone 534
    -- (ids 58-61) — see trigger 53467.
    local final_item = actor:get_quest_var("major_globe_spell:final_item")
    local place
    if final_item == 58 then
        place = "in a border keep"
    elseif final_item == 59 then
        place = "on an emerald isle"
    elseif final_item == 60 then
        place = "within a misty fortress"
    else
        place = "in an underground city"
    end
    local item_name = objects.template(534, final_item).name
    actor:send(tostring(self.name) .. " says, 'Find <b:yellow>" .. tostring(item_name) .. "</> " .. tostring(place) .. ".'")
    actor:send(tostring(self.name) .. " says, 'Bring me <b:cyan>" .. tostring(item_name) .. "</>.'")
end  -- auto-close block