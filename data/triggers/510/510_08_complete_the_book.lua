-- Trigger: complete_the_book
-- Zone: 510, ID: 8
-- Type: OBJECT, Flags: WEAR
--
-- Original DG Script: #51008
-- Fires when the player tries to wear the petrified magic. If they
-- are also wearing the damaged spellbook (510, 22), the two fuse into
-- the completed book of healing (510, 23). The petrified magic and
-- the damaged book are both destroyed in the process.

-- Must be wearing the damaged spellbook (510, 22) for the merge.
if not actor:has_equipped(510, 22) then
    actor:send("You can't seem to get a proper grip on it, it almost squirms.")
    return true
end

actor:send("You feel a strong attraction between the book and the magic - you can't hold them apart!")
self.room:send_except(actor, tostring(actor.name) .. " appears to be struggling to keep the book and the magic apart, but vainly.")
wait(1)
self.room:send("The magic melts into the book, and makes it whole!")
wait(6)
self.room:send("The book glows more and more brightly!")
actor:send("Ack - the book is heating up too! You don't think you can hold it much longer...")
actor:command("remove book-of-healing")
local damaged = self.room:find_object("book-of-healing")
if damaged then
    world.destroy(damaged)
end
actor:send("You drop the book hurriedly to avoid burning yourself!")
self.room:send_except(actor, tostring(actor.name) .. " drops a large book.")
self.room:spawn_object(510, 23)
world.destroy(self)
return true
