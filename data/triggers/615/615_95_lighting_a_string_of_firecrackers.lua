-- Trigger: Lighting a string of firecrackers
-- Zone: 615, ID: 95
-- Type: OBJECT, Flags: COMMAND
-- Status: CLEAN
--
-- Original DG Script: #61595

-- Converted from DG Script #61595: Lighting a string of firecrackers
-- Original: OBJECT trigger, flags: COMMAND, probability: 100%

-- Command filter: light
if not (cmd == "light") then
    return true  -- Not our command
end
local _return_value = true  -- Default: allow action
if string.find(arg, "firework") or string.find(arg, "firecracker") or string.find(arg, "string") or string.find(arg, "firecrackers") then
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
        self.room:send("The fuse on " .. tostring(self.shortdesc) .. " burns slowly, giving off some smoke.")
        wait(1)
        local bangs = {
            "<blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <b:red>BANG!</>  <magenta>BANG!</>  <b:yellow>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>",
            "<b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>",
            "<b:magenta>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>",
            "<blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<blue>BANG!</>  <yellow>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <yellow>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <red>BANG!</>  <blue>BANG!</>",
            "<b:magenta>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>",
            "<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:magenta>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>",
            "<b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>",
            "<blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <blue>BANG!</>",
            "<b:yellow>BANG!</>  <b:blue>BANG!</>",
            "<b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>",
            "<yellow>BANG!</>  <red>BANG!</>  <red>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>",
            "<blue>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>",
            "<b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <yellow>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>",
            "<b:blue>BANG!</>  <b:red>BANG!</>",
        }
        local counter = 20
        while counter > 0 do
            self.room:send(tostring(self.shortdesc) .. " explodes!")
            self.room:send(bangs[random(1, #bangs)])
            wait(3)
            counter = counter - 1
        end
        wait(1)
        self.room:send(tostring(self.shortdesc) .. " shoots out a few sputtering sparks.")
        world.destroy(self.name)
    end
else
    _return_value = true
end
return _return_value