-- Trigger: calling for help
-- Zone: 625, ID: 1
-- Type: MOB, Flags: FIGHT
-- Status: NEEDS_REVIEW
--   Complex nesting: 12 if statements
--
-- Original DG Script: #62501

-- Converted from DG Script #62501: calling for help
-- Original: MOB trigger, flags: FIGHT, probability: 33%

-- 33% chance to trigger
if not percent_chance(33) then
    return true
end
if self.id == 62501 then
    if %get.mob_count[62502] < 5 then
        self.room:send("<b:green>" .. tostring(self.name) .. " touches a nearby Rhell tree, calling on it for help.</>")
        wait(1)
        self.room:send("<b:green> A Mighty Rhell Tree springs to life!</>")
        wait(1)
        self.room:spawn_mobile(625, 2)
        self.room:find_actor("tree"):command("assist dryad")
    else
        return _return_value
    end
end
if self.id == 62508 then
    wait(3)
    if world.count_mobiles("62509") > 5 then
        return _return_value
    elseif if random(1, 10) > 6 then
        if self:has_effect(Effect.Silence) then
            self.room:send("<b:yellow>" .. tostring(self.name) .. " opens its mouth to howl but no sound comes out!</>")
            return _return_value
        else
            self.room:send("<yellow>" .. tostring(self.name) .. " lets out a deep howl, calling for others in the pack.</>")
            local wolf = random(1, 13)
            wait(2)
            if wolf > 6 then
                self.room:send("<b:yellow>You hear several answering howls! The PACK is coming to join " .. tostring(self.name) .. "!</>")
                wait(2)
                self.room:spawn_mobile(625, 9)
                self.room:find_actor("wolf"):command("assist 2.wolf")
                wait(5)
                self.room:spawn_mobile(625, 9)
                self.room:find_actor("wolf"):command("assist 2.wolf")
            end
        end
    end
end
if self.id == 62509 then
    if world.count_mobiles("62509") > 4 then
        return _return_value
    elseif random(1, 10) > 6 then
        wait(3)
        local wolf = random(1, 15)
        wait(1)
        if self:has_effect(Effect.Silence) then
            self.room:send("<b:yellow>" .. tostring(self.name) .. " opens its mouth to howl but no sound comes out!</>")
            return _return_value
        else
            self.room:send("<b:yellow>" .. tostring(self.name) .. " howls, calling for others in the pack.</>")
            wait(2)
            if wolf < 2 then
                self.room:send("<yellow>You hear a deep howl answering " .. tostring(self.name) .. "'s call for help.</>")
                wait(2)
                self.room:spawn_mobile(625, 8)
                self.room:find_actor("wolf"):command("assist 2.wolf")
            elseif wolf < 5 then
                self.room:send("<b:yellow>You hear a distant howl. Someone is coming to the aid of " .. tostring(self.name) .. "!</>")
                wait(2)
                self.room:spawn_mobile(625, 9)
                self.room:find_actor("wolf"):command("assist 2.wolf")
            end
        end
    end
end