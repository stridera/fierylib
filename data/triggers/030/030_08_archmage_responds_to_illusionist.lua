-- Trigger: Archmage responds to 'illusionist'
-- Zone: 30, ID: 8
-- Type: MOB, Flags: SPEECH_TO
-- Status: CLEAN
--
-- Original DG Script: #3008

-- Converted from DG Script #3008: Archmage responds to 'illusionist'
-- Original: MOB trigger, flags: SPEECH_TO, probability: 100%
wait(1)
if string.find(actor.class, "Sorcerer") and actor.level > 9 and actor.level < 46 then
    self:say("If you want to become an illusionist, you might want to talk to the Grand Master in the citadel.")
    wait(3)
    self:say("Unfortunately, he has been in a foul mood of late.  He may not agree to help you.  But I know of no one else.")
elseif string.find(actor.class, "Sorcerer") and actor.level < 10 then
    self:say("Illusionists?  Crafty folk, you can never be quite sure what's going on around them.")
    wait(3)
    self:say("You could become one if you wanted, but you'll have to wait until you have achieved level 10.")
elseif string.find(actor.class, "Illusionist") then
    self:say("Are you looking for the guild?  I hear that they place crafty illusions over the entrances.  But only visual ones...")
    wait(3)
    self:say("They always seem to be near banks, as well.  Sorry, I don't know anything more about them.")
else
    self:say("I always used to take along an illusionist when adventuring.  You never know when they'll come in handy!")
end