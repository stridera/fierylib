-- Trigger: odai_kannon_receive
-- Zone: 580, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: CLEAN
--
-- Receives the cage key (zone 582, id 200 in legacy 58200 format) from a
-- player. Kannon is freed, drops a curated loot pile (gems + armor across
-- previous/current/next wear-position sets), thanks the player, then
-- teleports/purges herself.
--
-- TODO: spawn_object zone/id pairs use legacy vnum offsets; double-check
-- that zones 553, 556 still own the gem/armor object IDs in the 37-72
-- range after import.
if actor.is_player then
    if object.id == 58200 then
        wait(1)
        self:destroy_item("key")
        self.room:send(tostring(self.name) .. " stares in astonishment.")
        self:say("You... you're ... releasing me?")
        self.room:send(tostring(self.name) .. " looks around the cage, slowly regaining her composure.")
        wait(1)
        self:say("Please, accept these tokens!")
        -- boss setup - trigger 55586
        -- 
        local count = 0
        while count < 3 do
            local bonus = random(1, 100)
            local will_drop = random(1, 100)
            -- 4 pieces of armor per sub_phase in phase_2
            local what_armor_drop = random(1, 4)
            -- 11 classes questing in phase_2
            local what_gem_drop = random(1, 11)
            -- 
            if will_drop <= 60 then
                -- Normal non-bonus drops
                if bonus <= 50 then
                    -- drop a gem from the previous wear pos set
                    self.room:spawn_object(556, 37 + what_gem_drop)
                elseif bonus >= 51 and bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop a gem from the current wear pos set
                    self.room:spawn_object(556, 48 + what_gem_drop)
                else
                    -- We're in the BONUS ROUND!!
                    -- drop a gem from the next wear pos set
                    self.room:spawn_object(556, 59 + what_gem_drop)
                end
            elseif will_drop >= 61 and will_drop <= 80 then
                -- Normal non-bonus drops
                if bonus <= 50 then
                    -- drop destroyed armor 55299 is the ID before the
                    -- first piece of armor.
                    self.room:spawn_object(553, 43 + what_armor_drop)
                elseif bonus >= 51 and bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop armor from the current wear pos set
                    self.room:spawn_object(553, 47 + what_armor_drop)
                else
                    -- We're in the BONUS ROUND!!
                    -- drop a piece of armor from next wear pos
                    self.room:spawn_object(553, 51 + what_armor_drop)
                end
            else
                -- Normal non-bonus drops
                if bonus <= 50 then
                    -- drop armor and gem from previous wear pos
                    self.room:spawn_object(556, 37 + what_gem_drop)
                    self.room:spawn_object(553, 43 + what_armor_drop)
                elseif bonus >= 51 and bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop a gem and armor from the current wear pos set
                    self.room:spawn_object(553, 47 + what_armor_drop)
                    self.room:spawn_object(556, 48 + what_gem_drop)
                else
                    -- We're in the BONUS ROUND!!
                    -- drop armor and gem from next wear pos
                    self.room:spawn_object(556, 59 + what_gem_drop)
                    self.room:spawn_object(553, 51 + what_armor_drop)
                end
            end
            count = count + 1
        end
        self:command("remove all.pearl")
        self:command("give all " .. tostring(actor.name))
        wait(1)
        self:say("I'm FREE!")
        self.room:send("The goddess disappears in a flash of blazing light!")
        world.destroy(self.room:find_actor("kannon"))
    end
end