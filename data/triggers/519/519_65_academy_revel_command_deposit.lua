-- Trigger: academy_revel_command_deposit
-- Zone: 519, ID: 65
-- Type: MOB, Flags: COMMAND
--
-- Original DG Script: #51965

-- Converted from DG Script #51965: academy_revel_command_deposit
-- Original: MOB trigger, flags: COMMAND, probability: 100%
--
-- The real `deposit` runs (this script lets it through) and takes ONE amount:
-- `deposit <amount> [copper|silver|gold|platinum]` or `deposit all`, at a
-- banker (the Master of the Revel is one). The lesson used to ask for
-- "deposit 1 gold 1 silver 1 copper", which the command rejects with a usage
-- line, and advanced anyway. It now advances only when the typed amount is one
-- the command accepts and the student can have on hand: Lua cannot read the
-- wallet, so the cap is the purse the lesson hands out (5 gold 5 silver
-- 5 copper = 555 copper).

-- Command filter: deposit
if not (cmd == "deposit") then
    return true  -- Not our command
end

local LESSON_PURSE = 555  -- copper handed out by 519:92
local COIN = { copper = 1, cop = 1, c = 1, silver = 10, sil = 10, s = 10,
    gold = 100, gol = 100, g = 100, platinum = 1000, plat = 1000, p = 1000 }

-- Copper value of a deposit argument, "all", or nil when the command would
-- answer with its usage line (same rules as the server's bank amount parser).
local function bank_amount(text)
    text = string.lower(string.match(text or "", "^%s*(.-)%s*$"))
    if text == "all" then
        return "all"
    end
    local words = {}
    for w in string.gmatch(text, "%S+") do
        words[#words + 1] = w
    end
    local num, attached = string.match(words[1] or "", "^(%d+)(.*)$")
    if not num then
        return nil
    end
    local unit
    if attached == "" then
        if words[3] then
            return nil
        end
        unit = words[2] or "copper"
    else
        if words[2] then
            return nil
        end
        unit = attached
    end
    local scale = COIN[unit]
    if not scale then
        return nil
    end
    local total = tonumber(num) * scale
    if total <= 0 then
        return nil
    end
    return total
end

local lesson_open = (actor:get_quest_var("school:money") or 0) == 1
if not (lesson_open or actor:get_quest_var("school:money") == "complete") then
    return true  -- Not in the money lesson: the plain command
end

-- Let the real command run and answer for itself.
local amount = bank_amount(arg)
allow_command()
wait(0.5)
if lesson_open then
    if amount == "all" or (amount and amount <= LESSON_PURSE) then
        actor:set_quest_var("school", "money", "complete")
        actor:send(tostring(self.name) .. " tells you, 'Thank you for using Academy Bank.")
        actor:send("You can <b:cyan>WITHDRAW</> your funds at any time.'")
        wait(1)
    else
        actor:send(tostring(self.name) .. " tells you, 'Name one amount, like <b:green>deposit 1 gold</>.'")
        return
    end
end
if actor:get_quest_stage("school") == 5 then
    if actor:get_quest_var("school:money") == "complete" and actor:get_quest_var("school:rest") == "complete" then
        actor:advance_quest("school")
        actor:send(tostring(self.name) .. " tells you, 'You're ready to graduate from Ethilien Academy!")
        actor:send(tostring(self.name) .. " says, '<b:green>Say finish</> to end the school.'")
    else
        actor:send(tostring(self.name) .. " tells you, '<b:green>Say resting</> to finish your last lesson, or say <magenta>SKIP</> to jump to the end of the Academy.'")
    end
end
