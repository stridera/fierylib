-- Trigger: Haggard brownie greets
-- Zone: 120, ID: 6
-- Type: MOB, Flags: GREET
-- Status: CLEAN
--
-- Original DG Script: #12006

-- Converted from DG Script #12006: Haggard brownie greets
-- Original: MOB trigger, flags: GREET, probability: 100%
if actor.id == -1 and self.room == 12103 then
    wait(3)
    self:emote("looks at you with desperation.")
    wait(8)
    local room = get.room[self.room]
    if room:get_people("12020") then
        self:say("Please, help me escape from these fiends!")
        wait(3)
        self.room:find_actor("dark-pixie-tormentor"):command("slap haggard-brownie")
        self.room:find_actor("dark-pixie-tormentor"):emote("hisses, 'It will be ssssilent!'")
        wait(2)
        self:emote("cringes away, uttering a little yelp.")
    else
        self:say("I am so lost!  Will you help me get home?")
        self:say("Say 'I will escort you' if so.  But beware!")
        self:say("The forces of darkness hunt me...")
        wait(4)
        self:command("scan")
    end
end