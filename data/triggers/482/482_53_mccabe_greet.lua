-- Trigger: mccabe greet
-- Zone: 482, ID: 53
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #48253

-- Converted from DG Script #48253: mccabe greet
-- Original: MOB trigger, flags: GREET, probability: 100%
-- **McCabe's greet Trigger***
-- **
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
-- **No one should be here but sorcs and pyros, so lets throw the rest back out***
if actor.class ~= "sorcerer" and actor.class ~= "pyromancer" and actor.quest_stage[type_wand] < wandstep then
    self:command("con " .. tostring(actor))
    wait(2)
    self:say("What are you doing here?! Get out!")
    wait(1)
    self.room:send_except(actor, "<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at &9<blue>" .. tostring(actor.name) .. "<cyan> sending " .. tostring(actor.object) .. "<blue> tumbling!</>")
    actor:send("<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:red>YOU<cyan> sending you<blue> tumbling!</>")
    actor:teleport(get_room(482, 54))
    -- actor looks around
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(482, 53))
    -- actor looks around
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(482, 52))
    -- actor looks around
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air comes at you from a new angle, sending you<blue> tumbling!</>")
    actor:teleport(get_room(482, 51))
    local damage = (actor.level * 2) + random(1, 30)
    local damage_dealt = actor:damage(damage)  -- type: fire
    actor:send("<b:red>You sustain </><red>severe burns<blue> as you plunge head first through drizzling </><red>lava.</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
    -- actor looks around
elseif (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) or actor.quest_stage[type_wand] == "wandstep" then
    local minlevel = (wandstep - 1) * 10
    if (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) then
        if actor:get_quest_var("meteorswarm:new") /= no then
            actor:send(tostring(self.name) .. " tells you, 'Do you have the new meteorite?'")
        elseif not stage then
            self.room:spawn_mobile(482, 51)
            self:command("peer seagull")
            self:emote("focuses closely on the seagull flying overhead.")
            self.room:send(tostring(self.name) .. " starts casting '<b:yellow>meteorswarm</>' at an unsuspecting seagull.")
            wait(1)
            run_room_trigger(48257)
            self.room:find_actor("seagull"):command("panic")
            self.room:find_actor("seagull"):emote("panics and flees to the north.")
            world.destroy(self.room:find_actor("seagull"))
            wait(2)
            self:command("giggle")
            wait(5)
            actor:send(tostring(self.name) .. " tells you, 'I see you admire my conjuring.  Perhaps you've never seen anyone calling <b:cyan>meteors</>?'")
        elseif stage == 1 then
            actor:send(tostring(self.name) .. " tells you, 'Have you spoken to Jemnon?  He's in some tavern, no doubt, waiting for some new blunder to embark on.'")
        elseif stage == 2 then
            actor:send(tostring(self.name) .. " tells you, 'Well, did Jemnon tell you where the rock demon is?'")
        elseif stage == 3 then
            actor:send(tostring(self.name) .. " tells you, 'Have you found a suitable focus?'")
        elseif stage == 4 then
            actor:send(tostring(self.name) .. " tells you, 'I can see from the singe marks you accomplished your task!  Are you ready to press on?'")
        elseif stage == 5 then
            actor:send(tostring(self.name) .. " tells you, 'Were you able to glean something from Dargentan's teachings?'")
        end
        if actor.quest_stage[type_wand] == "wandstep" then
            if actor.level >= minlevel then
                if actor.quest_variable[type_wand:greet] == 0 then
                    actor:send(tostring(self.name) .. " tells you, 'Or is there even MORE you want from me?  You seem to be in need of a crafting <b:cyan>[upgrade]</>.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
                end
            end
        end
    else
        if actor.level >= minlevel then
            if actor.quest_variable[type_wand:greet] == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the " .. tostring(weapon) .. "?'")
            end
        end
    end
end