-- Trigger: blacksmith quest
-- Zone: 87, ID: 0
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #8700

-- Converted from DG Script #8700: blacksmith quest
-- Original: MOB trigger, flags: GREET, probability: 100%
wait(1)
actor:send(tostring(self.name) .. " says, 'Hello traveler, I was wondering if you had seen a dwarven")
actor:send("</>boy heading this way?  My supplies are late, they should have been here a day")
actor:send("</>ago.  Doren is never late, I wish i could go looking for him.  I fear something")
actor:send("</>has happened to him, will you go find him?'")