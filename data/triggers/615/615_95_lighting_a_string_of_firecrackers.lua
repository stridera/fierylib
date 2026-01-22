-- Trigger: Lighting a string of firecrackers
-- Zone: 615, ID: 95
-- Type: OBJECT, Flags: COMMAND
-- Status: NEEDS_REVIEW
--   Large script: 5371 chars
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
        self.room:send("The fuse on " .. tostring(self.shortdesc) .. " burns slowly, giving off some smoke.")
        wait(1)
        local counter = 20
        while counter do
            self.room:send(tostring(self.shortdesc) .. " explodes!")
            -- switch on random(1, 20)
            if random(1, 20) == 1 then
                self.room:send("<blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <b:red>BANG!</>  <magenta>BANG!</>  <b:yellow>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 2 then
                self.room:send("<b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 3 then
                self.room:send("<b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 4 then
                self.room:send("<b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>")
            elseif random(1, 20) == 5 then
                self.room:send("<b:magenta>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>")
            elseif random(1, 20) == 6 then
                self.room:send("<blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>")
            elseif random(1, 20) == 7 then
                self.room:send("<blue>BANG!</>  <yellow>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <yellow>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>")
            elseif random(1, 20) == 8 then
                self.room:send("<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:magenta>BANG!</>  <red>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 9 then
                self.room:send("<b:magenta>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 10 then
                self.room:send("<b:red>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 11 then
                self.room:send("<b:blue>BANG!</>  <b:magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:blue>BANG!</>  <b:magenta>BANG!</>")
            elseif random(1, 20) == 12 then
                self.room:send("<b:blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 13 then
                self.room:send("<b:blue>BANG!</>  <blue>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 14 then
                self.room:send("<blue>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 15 then
                self.room:send("<b:yellow>BANG!</>  <b:blue>BANG!</>")
            elseif random(1, 20) == 16 then
                self.room:send("<b:blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 17 then
                self.room:send("<yellow>BANG!</>  <red>BANG!</>  <red>BANG!</>  <b:blue>BANG!</>  <b:blue>BANG!</>  <blue>BANG!</>")
            elseif random(1, 20) == 18 then
                self.room:send("<blue>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <red>BANG!</>  <b:red>BANG!</>  <blue>BANG!</>  <b:red>BANG!</>")
            elseif random(1, 20) == 19 then
                self.room:send("<b:red>BANG!</>  <b:yellow>BANG!</>  <blue>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>  <yellow>BANG!</>  <magenta>BANG!</>  <blue>BANG!</>")
            else
                self.room:send("<b:blue>BANG!</>  <b:red>BANG!</>")
            end
            wait(3)
            local counter = counter - 1
        end
        wait(1)
        self.room:send(tostring(self.shortdesc) .. " shoots out a few sputtering sparks.")
        world.destroy(self.name)
    end
else
    _return_value = false
end
return _return_value