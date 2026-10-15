-- Trigger: mccabe greet
-- Zone: 481, ID: 153
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #48253
--
-- `wandstep`, `weapon` and `type` are DG globals set on this mob by its LOAD trigger (002_111);
-- they are read from the mob's `globals` table.

-- Converted from DG Script #48253: mccabe greet
-- Original: MOB trigger, flags: GREET, probability: 100%
local stage = actor:get_quest_stage("meteorswarm")
wait(1)
-- No one should be here but sorcs and pyros, so let's throw the rest back out
-- DG %type%_wand: the questmaster's LOAD trigger (002_111) stores the element in globals.type
local wand_quest = (globals.type or "type") .. "_wand"
if actor.class ~= "sorcerer" and actor.class ~= "pyromancer" and actor:get_quest_stage(wand_quest) < (globals.wandstep or 999) then
    self:command("con " .. tostring(actor))
    wait(2)
    self:say("What are you doing here?! Get out!")
    wait(1)
    self.room:send_except(actor, "<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:black>" .. tostring(actor.name) .. "<cyan> sending them<blue> tumbling!</>")
    actor:send("<b:blue>" .. tostring(self.name) .. " </><cyan> sends a blast of air at <b:red>YOU<cyan> sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 154))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 153))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air sends you<blue> tumbling!</>")
    actor:teleport(get_room(481, 152))
    actor:send("<b:blue>" .. tostring(self.name) .. "'s </><cyan>blast of air comes at you from a new angle, sending you<blue> tumbling!</>")
    actor:teleport(get_room(481, 151))
    local damage = (actor.level * 2) + random(1, 30)
    local damage_dealt = actor:damage(damage)  -- type: fire
    actor:send("<b:red>You sustain </><red>severe burns<blue> as you plunge head first through drizzling </><red>lava.</> (<b:red>" .. tostring(damage_dealt) .. "</>)")
elseif (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) or actor:get_quest_stage(wand_quest) == globals.wandstep then
    local minlevel = ((globals.wandstep or 1) - 1) * 10
    if (string.find(actor.class, "sorcerer") and actor.level > 72) or (string.find(actor.class, "pyromancer") and actor.level > 80) then
        if actor:get_quest_var("meteorswarm:new") ~= "no" then
            actor:send(tostring(self.name) .. " tells you, 'Do you have the new meteorite?'")
        elseif (stage or 0) == 0 then
            self.room:spawn_mobile(481, 151)
            self:command("peer seagull")
            self:emote("focuses closely on the seagull flying overhead.")
            self.room:send(tostring(self.name) .. " starts casting '<b:yellow>meteorswarm</>' at an unsuspecting seagull.")
            wait(1)
            run_room_trigger(481, 157)
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
        if actor:get_quest_stage(wand_quest) == globals.wandstep then
            if actor.level >= minlevel then
                if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                    actor:send(tostring(self.name) .. " tells you, 'Or is there even MORE you want from me?  You seem to be in need of a crafting <b:cyan>[upgrade]</>.'")
                else
                    actor:send(tostring(self.name) .. " says, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
                end
            end
        end
    else
        if actor.level >= minlevel then
            if (actor:get_quest_var(wand_quest .. ":greet") or 0) == 0 then
                actor:send(tostring(self.name) .. " tells you, 'I see you're crafting something.  If you want my help, we can talk about <b:cyan>[upgrades]</>.'")
            else
                actor:send(tostring(self.name) .. " tells you, 'Do you have what I need for the " .. tostring(globals.weapon) .. "?'")
            end
        end
    end
end