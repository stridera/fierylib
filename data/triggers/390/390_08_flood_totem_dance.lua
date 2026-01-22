-- Trigger: flood_totem_dance
-- Zone: 390, ID: 8
-- Type: MOB, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #39008

-- Converted from DG Script #39008: flood_totem_dance
-- Original: MOB trigger, flags: COMMAND, probability: 100%

-- Command filter: dance
if not (cmd == "dance") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "d" then
    _return_value = false
    return _return_value
end
local color = "&4&b"
if actor:get_quest_stage("flood") == 1 then
    local bell1 = actor:has_item("6903")
    local bell2 = actor:has_item("12311")
    local bell3 = actor:has_item("12316")
    local bell4 = actor:has_equipped("6903")
    local bell5 = actor:has_equipped("12311")
    local bell6 = actor:has_equipped("12316")
    local bell7 = actor:has_item("17309")
    local bell8 = actor:has_equipped("17309")
    if bell1 or bell2 or bell3 or bell4 or bell5 or bell6 or bell7 or bell8 then
        self.room:send_except(actor, tostring(actor.name) .. " dances an ancient circle dance, calling to the great Spirits of the Canyon.")
        actor:send("You dance an ancient circle dance, calling to the great Spirits of the canyon.")
        wait(1)
        actor:send(tostring(color) .. tostring(self.name) .. " begins to dance with you, complementing and accentuating your movement and rhythms.</>")
        self.room:send_except(actor, tostring(color) .. tostring(self.name) .. " begins to dance with " .. tostring(actor.name) .. ", complementing and accentuating " .. tostring(hisher) .. " movement and rhythms.</>")
        wait(3)
        self.room:send(tostring(self.name) .. " speaks in three voices:")
        self.room:send(tostring(color) .. "'You show proper respect for the Spirits of the Canyon and their children.  In turn, we will respect your position as Envoy and heed the call of the Ocean.'</>")
        actor.name:set_quest_var("flood", "water3", 1)
        wait(2)
        self.room:send(tostring(color) .. tostring(self.name) .. " continues to dance, gradually uniting with the river.</>")
        local water1 = actor:get_quest_var("flood:water1")
        local water2 = actor:get_quest_var("flood:water2")
        local water3 = actor:get_quest_var("flood:water3")
        local water4 = actor:get_quest_var("flood:water4")
        local water5 = actor:get_quest_var("flood:water5")
        local water6 = actor:get_quest_var("flood:water6")
        local water7 = actor:get_quest_var("flood:water7")
        local water8 = actor:get_quest_var("flood:water8")
        if water1 and water2 and water3 and water4 and water5 and water6 and water7 and water8 then
            actor.name:advance_quest("flood")
            wait(1)
            actor:send("<b:blue>You have garnered the support of all the great waters!</>")
        end
        world.destroy(self)
    else
        actor:send("You begin to dance but " .. tostring(self.name) .. " is unresponsive.")
        self.room:send_except(actor, tostring(actor.name) .. " begins to dance but " .. tostring(self.name) .. " is unresponsive.")
        actor:send("Something seems to be off about your preparations.")
    end
else
    _return_value = false
end
return _return_value