-- Trigger: 8ball message generator
-- Zone: 12, ID: 70
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #1270

-- Converted from DG Script #1270: 8ball message generator
-- Original: OBJECT trigger, flags: COMMAND, probability: 1%

-- 1% chance to trigger
if not percent_chance(1) then
    return true
end

-- Command filter: shake
if not (cmd == "shake") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if arg == 8ball then
    _return_value = true
    self.room:send(tostring(actor.name) .. " shakes a magic 8ball.")
    local rndm = random(1, 20)
    -- switch on rndm
    if rndm == 1 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"As I see it, yes.\"")
    elseif rndm == 2 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Ask again later.\"")
    elseif rndm == 3 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Better not tell you now.\"")
    elseif rndm == 4 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Cannot predict now.\"")
    elseif rndm == 5 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Concentrate and ask again.\"")
    elseif rndm == 6 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Dont count on it.\"")
    elseif rndm == 7 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"It is certain.\"")
    elseif rndm == 8 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"It is decidedly so.\"")
    elseif rndm == 9 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Most likely.\"")
    elseif rndm == 10 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"My reply is no.\"")
    elseif rndm == 11 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"My sources say no.\"")
    elseif rndm == 12 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Outlook not so good.\"")
    elseif rndm == 13 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Outlook good.\"")
    elseif rndm == 14 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Reply hazy, try again.\"")
    elseif rndm == 15 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Signs point to yes.\"")
    elseif rndm == 16 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Very doubtful.\"")
    elseif rndm == 17 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Without a doubt.\"")
    elseif rndm == 18 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Yes.\"")
    elseif rndm == 19 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"Yes  definitely.\"")
    elseif rndm == 20 then
        self.room:send(tostring(self.shortdesc) .. " shows, \"You may rely on it.\"")
    end
else
    _return_value = false
end
return _return_value