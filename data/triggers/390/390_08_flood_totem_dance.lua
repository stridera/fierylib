-- Trigger: flood_totem_dance
-- Zone: 390, ID: 8
-- Type: MOB, Flags: COMMAND
-- Status: NEEDS_REVIEW
--
-- Original DG Script: #39008
--
-- Three-Falls totem (39015): when the Envoy dances while carrying or
-- wearing one of four ritual bells, the totem joins the dance and
-- pledges its waters (sets `flood:water3`). Without a bell the totem
-- ignores the dance.
--
-- TODO: bell IDs were converted from legacy vnums:
--   6903  -> (69, 3)    canyon bell?
--   12311 -> (123, 11)
--   12316 -> (123, 16)
--   17309 -> (173, 9)
-- Confirm those (zone, local_id) tuples against the imported objects
-- before relying on this in production.
-- TODO: `hisher` was a DG global; replace with proper pronoun lookup
-- (e.g. actor:pronoun("possessive")) when that helper is wired up.

if cmd ~= "dance" then
    return true
end
if actor:get_quest_stage("flood") ~= 1 then
    return true
end

local has_bell =
    actor:has_item(69, 3) or actor:has_equipped(69, 3)
    or actor:has_item(123, 11) or actor:has_equipped(123, 11)
    or actor:has_item(123, 16) or actor:has_equipped(123, 16)
    or actor:has_item(173, 9)  or actor:has_equipped(173, 9)

if not has_bell then
    actor:send("You begin to dance but " .. self.name .. " is unresponsive.")
    self.room:send_except(actor, actor.name .. " begins to dance but " .. self.name .. " is unresponsive.")
    actor:send("Something seems to be off about your preparations.")
    return true
end

local color = "&4&b"
local hisher_pron = (hisher or "their")
self.room:send_except(actor, actor.name .. " dances an ancient circle dance, calling to the great Spirits of the Canyon.")
actor:send("You dance an ancient circle dance, calling to the great Spirits of the canyon.")
wait(1)
actor:send(color .. self.name .. " begins to dance with you, complementing and accentuating your movement and rhythms.</>")
self.room:send_except(actor, color .. self.name .. " begins to dance with " .. actor.name .. ", complementing and accentuating " .. hisher_pron .. " movement and rhythms.</>")
wait(3)
self.room:send(self.name .. " speaks in three voices:")
self.room:send(color .. "'You show proper respect for the Spirits of the Canyon and their children.  In turn, we will respect your position as Envoy and heed the call of the Ocean.'</>")
actor:set_quest_var("flood", "water3", 1)
wait(2)
self.room:send(color .. self.name .. " continues to dance, gradually uniting with the river.</>")

if actor:get_quest_var("flood:water1")
        and actor:get_quest_var("flood:water2")
        and actor:get_quest_var("flood:water3")
        and actor:get_quest_var("flood:water4")
        and actor:get_quest_var("flood:water5")
        and actor:get_quest_var("flood:water6")
        and actor:get_quest_var("flood:water7")
        and actor:get_quest_var("flood:water8") then
    actor:advance_quest("flood")
    wait(1)
    actor:send("<b:blue>You have garnered the support of all the great waters!</>")
end
world.destroy(self)
return true