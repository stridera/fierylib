-- Library: util
-- Description: Small formatting helpers shared by scripts. Example library; safe to delete.
--
-- Usage from a trigger:
--   local util = require("util")
--   self:say("That will be " .. util.format_coins(1234) .. ".")

local util = {}

-- Format an amount of copper as "1 platinum, 2 gold, 3 silver and 4 copper".
-- 1000 copper = 1 platinum, 100 = 1 gold, 10 = 1 silver (the game's coin values).
function util.format_coins(copper)
    copper = math.floor(tonumber(copper) or 0)
    if copper <= 0 then
        return "nothing"
    end
    local parts = {}
    local denominations = {
        { 1000, "platinum" },
        { 100, "gold" },
        { 10, "silver" },
        { 1, "copper" },
    }
    for _, d in ipairs(denominations) do
        local count = copper // d[1]
        if count > 0 then
            parts[#parts + 1] = count .. " " .. d[2]
            copper = copper - count * d[1]
        end
    end
    if #parts == 1 then
        return parts[1]
    end
    return table.concat(parts, ", ", 1, #parts - 1) .. " and " .. parts[#parts]
end

return util
