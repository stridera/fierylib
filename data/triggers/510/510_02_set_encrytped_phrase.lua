-- Trigger: set_encrytped_phrase
-- Zone: 510, ID: 2
-- Type: WORLD, Flags: PREENTRY
--
-- Original DG Script: #51002
-- On first entry, picks one of four encrypted phrases at random and
-- writes its ciphertext into the description of the `n` exit of room
-- (510, 30). Pairs with 510_00 (pawn_shop_nordus): only the matching
-- plaintext spoken there will reveal the down exit. The picked
-- index is published as the global `chosen` so 510_00 can validate.

if running == "yes" then
    return true
end
running = "yes"
chosen = random(1, 4)

local descr
if chosen == 1 then
    descr = "PLTWK ZHWIL OIXWI ONXML KMJ"
elseif chosen == 2 then
    descr = "PLTWK ZHWIL OIXMB XGFVZ LIYBX"
elseif chosen == 3 then
    descr = "PLTWK ZHWIL OIXBK KVJZL ORIMW KNX"
elseif chosen == 4 then
    descr = "PLTWK ZHWIL OIXTX DMJQG NOWSN C"
end

-- TODO(parity): The Lua runtime does not yet expose
-- `room:exit(dir):set_state{description = ...}`. Original intent: write
-- `descr` (the ciphertext) into the `n` exit description of (510, 30)
-- so players reading the description can decode it and speak the
-- plaintext at room (510, 0). Restore when the door API lands.
local _ = descr  -- keep `descr` referenced until the door API is wired.

wait(2)
running = nil
