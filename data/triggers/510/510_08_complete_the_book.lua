-- Trigger: complete_the_book
-- Zone: 510, ID: 8
-- Type: OBJECT, Flags: WEAR
-- Status: CLEAN
--
-- Original DG Script: #51008

-- Converted from DG Script #51008: complete_the_book
-- Original: OBJECT trigger, flags: WEAR, probability: 100%
local _return_value = true  -- Default: allow action
-- we wont hold the magic...
_return_value = false
-- actor must be holding the magic book
if actor:has_equipped("51022") then
    actor:send("You feel a strong attraction between the book and the magic - you can't hold them apart!")
    self.room:send_except(actor, tostring(actor.name) .. " appears to be struggling to keep the book and the magic apart, but vainly.")
    wait(1)
    self.room:send("The magic melts into the book, and makes it whole!")
    wait(6)
    self.room:send("The book glows more and more brightly!")
    actor:send("Ack - the book is heating up too! You don't think you can hold it much longer...")
    actor:command("remove book-of-healing")
    world.destroy(self.room:find_object("book-of-healing"))
    actor:send("You drop the book hurriedly to avoid burning yourself!")
    self.room:send_except(actor, tostring(actor.name) .. " drops a large book.")
    self.room:spawn_object(510, 23)
    world.destroy(self)
else
    actor:send("You can't seem to get a proper grip on it, it almost squirms.")
end
return _return_value