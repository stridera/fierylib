-- Trigger: hell_gate_island_drop
-- Zone: 564, ID: 6
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #56406

-- Converted from DG Script #56406: hell_gate_island_drop
-- Original: WORLD trigger, flags: DROP, probability: 100%
local _return_value = true  -- Default: allow action
if actor:get_quest_stage("hell_gate") == 3 then
    if actor.quest_variable[hell_gate:object.vnum] then
        _return_value = false
        self.room:send(tostring(mobiles.template(564, 0).name) .. " says, 'We have already gathered this blood.'")
    elseif object.id == 56400 or object.id == 56401 or object.id == 56402 or object.id == 56403 or object.id == 56404 or object.id == 56405 or object.id == 56406 then
        actor.name:set_quest_var("hell_gate", "%object.vnum%", 1)
        wait(1)
        self.room:send(tostring(object.shortdesc) .. " spills on the ground, gathering in a pool.")
        world.destroy(self.room:find_actor("blood"))
        local blood1 = actor:get_quest_var("hell_gate:56400")
        local blood2 = actor:get_quest_var("hell_gate:56401")
        local blood3 = actor:get_quest_var("hell_gate:56402")
        local blood4 = actor:get_quest_var("hell_gate:56403")
        local blood5 = actor:get_quest_var("hell_gate:56404")
        local blood6 = actor:get_quest_var("hell_gate:56405")
        local blood7 = actor:get_quest_var("hell_gate:56406")
        if blood1 and blood2 and blood3 and blood4 and blood5 and blood6 and blood7 then
            actor.name:advance_quest("hell_gate")
            wait(2)
            self.room:send(tostring(mobiles.template(564, 0).name) .. " says, 'I shall need the dagger to finish this step_of the unsealing.  Please give it to me.'")
        else
            self.room:send("The demonic voice says, <red>'This pleases me.  Bring the rest.'</>")
        end
    end
end
return _return_value