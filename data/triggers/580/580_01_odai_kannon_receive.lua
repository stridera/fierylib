-- Trigger: odai_kannon_receive
-- Zone: 580, ID: 1
-- Type: MOB, Flags: RECEIVE
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
--
-- Original DG Script: #58001

-- Converted from DG Script #58001: odai_kannon_receive
-- Original: MOB trigger, flags: RECEIVE, probability: 100%
-- I'm going to restructure this one ever so
-- Slightly to purge Kannon after she bolts so
-- She's just not hanging out in the void.
-- 
-- Adding in a gem/gear loop as well.
-- 
if actor.id == -1 then
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
                    local gem_vnum = what_gem_drop + 55637
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                elseif bonus >= 51 &bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop a gem from the current wear pos set
                    local gem_vnum = what_gem_drop + 55648
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                else
                    -- We're in the BONUS ROUND!!
                    -- drop a gem from the next wear pos set
                    local gem_vnum = what_gem_drop + 55659
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                end
            elseif will_drop >=61 &will_drop <= 80 then
                -- Normal non-bonus drops
                if bonus <= 50 then
                    -- drop destroyed armor 55299 is the vnum before the
                    -- first piece of armor.
                    local armor_vnum = what_armor_drop + 55343
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                elseif bonus >= 51 &bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop armor from the current wear pos set
                    local armor_vnum = what_armor_drop + 55347
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                else
                    -- We're in the BONUS ROUND!!
                    -- drop a piece of armor from next wear pos
                    local armor_vnum = what_armor_drop + 55351
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                end
            else
                -- Normal non-bonus drops
                if bonus <= 50 then
                    -- drop armor and gem from previous wear pos
                    local gem_vnum = what_gem_drop + 55637
                    local armor_vnum = what_armor_drop + 55343
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                elseif bonus >= 51 &bonus <= 90 then
                    -- We're in the Normal drops from current wear pos set
                    -- drop a gem and armor from the current wear pos set
                    local armor_vnum = what_armor_drop + 55347
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                    local gem_vnum = what_gem_drop + 55648
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                else
                    -- We're in the BONUS ROUND!!
                    -- drop armor and gem from next wear pos
                    local gem_vnum = what_gem_drop + 55659
                    self.room:spawn_object(vnum_to_zone(gem_vnum), vnum_to_local(gem_vnum))
                    local armor_vnum = what_armor_drop + 55351
                    self.room:spawn_object(vnum_to_zone(armor_vnum), vnum_to_local(armor_vnum))
                end
            end
            local count = count + 1
        end
        self:command("remove all.pearl")
        self:command("give all " .. tostring(actor.name))
        wait(1)
        self:say("I'm FREE!")
        self.room:send("The goddess disappears in a flash of blazing light!")
        world.destroy(self.room:find_actor("kannon"))
    end
end