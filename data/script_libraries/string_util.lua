-- Library: string_util
-- Description: Utility functions for handling and outputting speech

local string_util = {}

-- Returns true if any of the words are found in the message.
-- Words are case-insensitive.
-- Example:
--    string_util.any_word("What is your favorite color?", { "color", "colour", "hue", "rainbow" }) == true
function string_util.contains_any(message, words)
    local lower = message:lower()
    for _, word in ipairs(words) do
        if lower:find(word:lower(), 1, true) then
            return true
        end
    end
    return false
end

-- Searches the message for any of the words found in the keys of a table.
-- Returns the associated value from the table, or nil if not found.
-- Example:
--   local tbl = { platinum = 1000, gold = 100, silver = 10, copper = 1 }
--   string_util.match_table("Do you have gold?", tbl) == 100
function string_util.match_table(message, tbl)
    local lower = message:lower()
    for word, value in pairs(tbl) do
        if lower:find(word:lower(), 1, true) then
            return value
        end
    end
end

return string_util