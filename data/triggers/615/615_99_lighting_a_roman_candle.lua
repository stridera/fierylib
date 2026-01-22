-- Trigger: Lighting a roman candle
-- Zone: 615, ID: 99
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Complex nesting: 6 if statements
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
    _return_value = false
    return _return_value
end
if string.find(arg.id, "self.id") then
    if burning == 1 then
        _return_value = true
        actor:send("It's already lit!")
    elseif on_ground == 0 then
        _return_value = true
        actor:send("To avoid being horribly disfigured by fire, dropping it first might be a good idea.")
    else
        _return_value = true
        local burning = 1
        globals.burning = globals.burning or true
        self.room:send_except(actor, tostring(actor.name) .. " lights " .. tostring(self.shortdesc) .. ".")
        actor:send("You light " .. tostring(self.shortdesc) .. ".")
        wait(2)
        self.room:send("A few small sparks begin flying up out of " .. tostring(self.shortdesc) .. ".")
        wait(1)
        local counter = 10
        while counter do
            -- switch on random(1, 9)
            if random(1, 9) == 1 then
                self.room:send(tostring(self.shortdesc) .. " sends up a shower of <yellow>brilliant <blue>golden<white> sparks</>!")
            elseif random(1, 9) == 2 then
                self.room:send("A blazing stream of <b:red>crimson</> and <b:green>vermillion<white> sparks</> shoots out of " .. tostring(self.shortdesc) .. "!")
            elseif random(1, 9) == 3 then
                self.room:send("A brilliant river of <blue>shining <b:blue>blue</> and <b:yellow>yellow</> <blue>motes</> streams out of " .. tostring(self.shortdesc) .. "!")
            elseif random(1, 9) == 4 then
                self.room:send("Multitudes of brightly <red>bu<yellow>rn<red>in<yellow>g &9<blue>s</><blue>p</>&9<blue>a</><blue>r</>&9<blue>k</><blue>s</> shoot up into the sky from " .. tostring(self.shortdesc) .. "!")
            elseif random(1, 9) == 5 then
                self.room:send(tostring(self.shortdesc) .. " lets loose with an impressive surge of <b:white>white</> and <b:blue>blue</> <blue>stars</>!")
            else
                self.room:send("A stream of <b:red>m<yellow>u<blue>l<magenta>t<green>i<cyan>c<yellow>o<red><blue><green>l<magenta>o<yellow>r<blue>e<red>d</> <blue>sparks</> is surging up out of " .. tostring(self.shortdesc) .. "!")
            end
            wait(1)
            local counter = counter - 1
        end
        wait(1)
        self.room:send(tostring(self.shortdesc) .. " shoots out a few sputtering sparks.")
        wait(3)
        self.room:send(tostring(self.shortdesc) .. " quietly burns out.")
        world.destroy(self.name)
    end
else
    _return_value = false
end
return _return_value