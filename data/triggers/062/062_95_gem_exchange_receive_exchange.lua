-- Trigger: Gem Exchange receive exchange
-- Zone: 62, ID: 95
-- Type: MOB, Flags: RECEIVE
--
-- Soltan Gem Exchange order fulfillment. Player has previously chosen a gem
-- via 062_93 / confirmed it via 062_94 (gem_exchange:gem_id quest_var holds
-- the legacy 5-digit vnum of the desired gem). When the player hands over a
-- gemstone, we accept it iff its vnum is >= the cutoff for the requested item
-- (i.e. equal or greater rarity), then spawn and give the requested gem.
--
-- All gems live in zone 555 with vnums 55566..55747. The cutoff thresholds
-- below mirror the original DG Script's tiering.
--
-- Original DG Script: #6295

-- TODO(parity): the legacy script gates `object.id` on the 5-digit vnum.
-- Here `object.id` is the local id within the gem's zone -- we reconstruct
-- the 5-digit form (zone*100 + local_id) before comparing. Verify that all
-- gems being handed in really live in zone 555.

local item = actor:get_quest_var("gem_exchange:gem_id")
if item == 0 or item == nil then
    actor:send(tostring(self.name) .. " refuses " .. tostring(object.shortdesc) .. ".")
    wait(1)
    actor:send(tostring(self.name) .. " says, 'I don't have any exchange orders listed for you at the")
    actor:send("</>moment...'")
    return true
end

local obj_vnum = object.zone_id * 100 + object.local_id

-- Decode the minimum-acceptable vnum cutoff for the requested item.
local function cutoff_for(it)
    if it <= 55569 then return 55566
    elseif it <= 55573 then return 55570
    elseif it <= 55577 then return 55574
    elseif it <= 55581 then return 55578
    elseif it <= 55585 then return 55582
    elseif it <= 55589 then return 55586
    elseif it <= 55593 then return 55590
    elseif it <= 55604 then return 55594
    elseif it <= 55615 then return 55605
    elseif it <= 55626 then return 55616
    elseif it <= 55637 then return 55627
    elseif it <= 55648 then return 55638
    elseif it <= 55659 then return 55649
    elseif it <= 55670 then return 55660
    elseif it <= 55681 then return 55671
    elseif it <= 55692 then return 55682
    elseif it <= 55703 then return 55693
    elseif it <= 55714 then return 55704
    elseif it <= 55725 then return 55715
    elseif it <= 55736 then return 55726
    elseif it <= 55747 then return 55737
    end
    return nil
end

-- Upper bound: highest-tier consumables stop at 55747 (top tier 3 set);
-- lower-class tiers are valid up through 55751 in the original.
local function upper_for(it)
    if it <= 55703 then return 55751 end
    return 55747
end

local lo = cutoff_for(item)
local hi = upper_for(item)
local in_gem_range = obj_vnum >= 55566 and obj_vnum <= 55751
local found = lo and hi and obj_vnum >= lo and obj_vnum <= hi

if found then
    wait(2)
    actor:send(tostring(self.name) .. " says, 'Here you are, as requested!'")
    world.destroy(object)
    self.room:spawn_object(math.floor(item / 100), item % 100)
    self:command("give all " .. tostring(actor))
    wait(2)
    actor:send(tostring(self.name) .. " says, 'A pleasure doing business with you!'")
    actor:set_quest_var("gem_exchange", "gem_id", 0)
else
    actor:send(tostring(self.name) .. " refuses to perform the exchange.")
    wait(1)
    if in_gem_range then
        local item_name = tostring(objects.template(math.floor(item / 100), item % 100).name)
        actor:send(tostring(self.name) .. " says, 'I'm afraid " .. tostring(object.shortdesc) .. " isn't of high enough rarity")
        actor:send("</>to exchange for " .. item_name .. ".'")
    else
        actor:send(tostring(self.name) .. " says, 'Sorry, " .. tostring(object.shortdesc) .. " isn't the kind of thing")
        actor:send("</>we trade around here...'")
    end
end
return true