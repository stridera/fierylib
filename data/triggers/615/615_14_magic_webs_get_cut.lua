-- Trigger: Magic webs get cut
-- Zone: 615, ID: 14
-- Type: WORLD, Flags: DROP
-- Status: CLEAN
--
-- Original DG Script: #61514

-- Converted from DG Script #61514: Magic webs get cut
-- Original: WORLD trigger, flags: DROP, probability: 100%
if object.id == 61505 and web_present == 1 then
    -- An emblazoned flint knife has been dropped in this room, where
    -- a web is blocking an exit.
    wait(1)
    self.room:send("The knife flies at the web, slicing back and forth.  It cuts easily through the strands.")
    self.room:send("The web is shredded.  Its translucent fragments drift away on a light breeze.")
    -- The web is implemented by a useless exit.  Replace the bad exit
    -- with an ordinary one.
    get_room(615, 49):exit("east"):set_state({hidden = true})
    get_room(615, 49):exit("east"):set_state({hidden = false})
    world.destroy(self.room:find_actor("blocking-web"))
    local web_present = 0
    globals.web_present = globals.web_present or true
    -- The emblazoned flint knife's magic is used up:
    -- replace it with the ordinary flint knife.
    world.destroy(self.room:find_actor("emblazoned-flint-knife"))
    self.room:spawn_object(615, 6)
    -- The spider, if present, may attempt to build a new web at any time.
    -- However, we'd rather it attack the player who destroyed the web first.
    -- Therefore, set this variable to prevent web-building for a while.
    local web_pause = 1
    globals.web_pause = globals.web_pause or true
    -- Determine whether the spider is present.
    local spider = self:get_people("61517")
    if spider then
        -- Now, the spider's response to this insolence.
        wait(1)
        spider:emote("squeaks furiously!")
        wait(4)
        spider:command("glare " .. tostring(actor.name))
        wait(1)
        spider:command("kill %actor.name%")
    end
    wait(10)
    local web_pause = 0
    globals.web_pause = globals.web_pause or true
    -- The spider may now build the web (it won't try while it's in combat).
end