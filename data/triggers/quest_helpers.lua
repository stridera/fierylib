-- Quest Helpers Module
-- Reusable functions for quest progress displays, class configurations, etc.
--
-- Usage in triggers:
--   local QuestHelpers = require("quest_helpers")
--   QuestHelpers.display_checklist(actor, REGIONS, check_fn, format_fn)

local QuestHelpers = {}

--- Display a checklist of items, showing only completed ones
-- @param actor The player character
-- @param items Array of items to check
-- @param check_fn Function(item) -> boolean, returns true if item is completed
-- @param format_fn Function(item) -> string, returns display text for item
function QuestHelpers.display_checklist(actor, items, check_fn, format_fn)
    for _, item in ipairs(items) do
        if check_fn(item) then
            actor:send(format_fn(item))
        end
    end
end

--- Count completed items in a checklist
-- @param items Array of items to check
-- @param check_fn Function(item) -> boolean, returns true if item is completed
-- @return number of completed items
function QuestHelpers.count_completed(items, check_fn)
    local count = 0
    for _, item in ipairs(items) do
        if check_fn(item) then
            count = count + 1
        end
    end
    return count
end

--- Get class-specific configuration from a lookup table
-- @param actor The player character
-- @param config_table Table mapping class names to config values
-- @return config for actor's class, or nil if not found
function QuestHelpers.get_class_config(actor, config_table)
    return config_table[actor.class] or config_table[actor.base_class]
end

--- Get value from indexed variables (e.g., card1, card2, ... card52)
-- @param self The trigger context
-- @param base_name Base variable name (e.g., "card")
-- @param index The index number
-- @return The variable value
function QuestHelpers.get_indexed_var(self, base_name, index)
    return self:variable(base_name .. tostring(index))
end

--- Set value for indexed variables
-- @param self The trigger context
-- @param base_name Base variable name (e.g., "card")
-- @param index The index number
-- @param value The value to set
function QuestHelpers.set_indexed_var(self, base_name, index, value)
    self:set_variable(base_name .. tostring(index), value)
end

--- Find index of a value in indexed variables
-- @param self The trigger context
-- @param base_name Base variable name
-- @param max_index Maximum index to search
-- @param target_value Value to find
-- @return index if found, nil otherwise
function QuestHelpers.find_in_indexed_vars(self, base_name, max_index, target_value)
    for i = 1, max_index do
        if self:variable(base_name .. tostring(i)) == target_value then
            return i
        end
    end
    return nil
end

--- Loop through indexed variables and apply a function
-- @param self The trigger context
-- @param base_name Base variable name
-- @param max_index Maximum index
-- @param fn Function(index, value) to apply to each
function QuestHelpers.each_indexed_var(self, base_name, max_index, fn)
    for i = 1, max_index do
        local value = self:variable(base_name .. tostring(i))
        fn(i, value)
    end
end

--- Standard quest region data structure helper
-- Creates a region entry for checklist displays
-- @param key The quest variable key suffix
-- @param display The display name shown to player
-- @return table with key and display fields
function QuestHelpers.region(key, display)
    return { key = key, display = display }
end

--- Check if actor has a quest variable set
-- @param actor The player character
-- @param quest_prefix The quest prefix (e.g., "illusory_wall")
-- @param key The specific key to check
-- @return boolean
function QuestHelpers.has_quest_var(actor, quest_prefix, key)
    return actor:get_quest_var(quest_prefix .. ":" .. key) ~= nil
end

return QuestHelpers
