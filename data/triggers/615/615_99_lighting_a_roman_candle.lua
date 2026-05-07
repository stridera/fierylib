-- Trigger: Lighting a roman candle
-- Zone: 615, ID: 99
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61599

-- Converted from DG Script #61599: Lighting a roman candle
-- Original: OBJECT trigger, flags: COMMAND, probability: 7%

-- 7% chance to trigger
if not percent_chance(7) then
    return true
end

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
-- switch on cmd
if cmd == "l" then
    _return_value = true
    return _return_value
end
-- Argument should match this candle. Accept any string.find match against
-- the object's keywords.
if arg and #arg > 0 and string.find(string.lower(self.shortdesc or ""), string.lower(arg)) then
    if globals.burning == 1 then
        _return_value = false
        actor:send("It's already lit!")
    elseif globals.on_ground == 0 then
        _return_value = false
        actor:send("To avoid being horribly disfigured by fire, dropping it first might be a good idea.")
    else
        _return_value = false
        globals.burning = 1
        self.room:send_except(actor, tostring(actor.name) .. " lights " .. tostring(self.shortdesc) .. ".")
        actor:send("You light " .. tostring(self.shortdesc) .. ".")
        wait(2)
        self.room:send("A few small sparks begin flying up out of " .. tostring(self.shortdesc) .. ".")
        wait(1)
        local sparks = {
            tostring(self.shortdesc) .. " sends up a shower of <yellow>brilliant <blue>golden<white> sparks</>!",
            "A blazing stream of <b:red>crimson</> and <b:green>vermillion<white> sparks</> shoots out of " .. tostring(self.shortdesc) .. "!",
            "A brilliant river of <blue>shining <b:blue>blue</> and <b:yellow>yellow</> <blue>motes</> streams out of " .. tostring(self.shortdesc) .. "!",
            "Multitudes of brightly <red>bu<yellow>rn<red>in<yellow>g &9<blue>s</><blue>p</>&9<blue>a</><blue>r</>&9<blue>k</><blue>s</> shoot up into the sky from " .. tostring(self.shortdesc) .. "!",
            tostring(self.shortdesc) .. " lets loose with an impressive surge of <b:white>white</> and <b:blue>blue</> <blue>stars</>!",
            "A stream of <b:red>m<yellow>u<blue>l<magenta>t<green>i<cyan>c<yellow>o<red>l<blue>o<green>r<magenta>e<yellow>d</> <blue>sparks</> is surging up out of " .. tostring(self.shortdesc) .. "!",
        }
        local counter = 10
        while counter > 0 do
            self.room:send(sparks[random(1, #sparks)])
            wait(1)
            counter = counter - 1
        end
        wait(1)
        self.room:send(tostring(self.shortdesc) .. " shoots out a few sputtering sparks.")
        wait(3)
        self.room:send(tostring(self.shortdesc) .. " quietly burns out.")
        world.destroy(self.name)
    end
else
    _return_value = true
end
return _return_value