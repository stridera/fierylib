-- Trigger: load random gems
-- Zone: 300, ID: 20
-- Type: MOB, Flags: GREET
-- Status: NEEDS_REVIEW
--   Complex nesting: 8 if statements
--
-- Original DG Script: #30020

-- Converted from DG Script #30020: load random gems
-- Original: MOB trigger, flags: GREET, probability: 100%
-- number of gems to load -- statring at 3, but that might be too many
local loop = 3
-- gem vnums go from  to 55566-55751
-- p1 vnums from 55566-55593
-- p2 vnums from 55594-55670
-- P3 cnums from 55671-55747 (there are gems up to 55751, but not used.
-- random # -- 1-10 to create probabilites of good gem
-- 0 = NO GEM
-- 1 = NO GEM
-- 2-6 = P1 Gem
-- 7-9 = P2 Gem
-- 10  = P3 Gem
-- -- lets see if we should run process to get gems
-- -- we do that by looking for object 18701 -- if we are wearing it
-- -- then we don't need to load gems again
-- all the important stuff incased in this loop
if not self:has_equipped("18701") then
    self.room:spawn_object(187, 1)
    get_room(11, 0):at(function()
        self:command("wear lock")
    end)
    local itt = 1
    while itt <= loop do
        local p = random(1, 10)
        if p == 10 then
            -- say p3! %p%
            local base = 55671
            local extra = random(1, 76)
        end
        -- p2 gem
        if (p <=9) and (p>=7) then
            -- say p2 %p%555
            local base = 55594
            local extra = random(1, 76)
        end
        -- p1 gem
        if (p <=6) and (p>=2) then
            -- say p1 %p%
            local base = 55566
            local extra = random(1, 27)
        end
        -- no gem
        if p < 2 then
            -- say no gem - %p%
            local base = 0
            local extra = 0
        end
        if base > 55560 then
            -- All gem bases are in zone 556 (556xx range)
            local gem_zone = 556
            local gem_local = (base % 100) + extra
            self.room:spawn_object(gem_zone, gem_local)
            self:command("sell gem Jhanna")
        end
        local itt = itt + 1
    end
end