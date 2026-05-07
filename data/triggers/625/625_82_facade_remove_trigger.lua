-- Trigger: facade remove trigger
-- Zone: 625, ID: 82
-- Type: OBJECT, Flags: REMOVE
-- Status: CLEAN
--
-- Original DG Script: #62582

-- Converted from DG Script #62582: facade remove trigger
-- Original: OBJECT trigger, flags: REMOVE, probability: 100%
--
-- TODO(parity): The legacy trailing message used DG colour codes
-- (`&0&7ol&bten&0&7 in&3&bner &0&3la&1&byers!&0`) that the converter
-- couldn't translate. The first send below has the prefix but is
-- truncated mid-sentence; restore once the colour palette is mapped.
-- Also: legacy used a single fallback (mob id < 1 = player) — that
-- should become an explicit `actor.is_player` check.
if actor.zone_id == 625 and actor.local_id == 70 then
    actor:send("As your patience dwindles you rip the rocky layer from your face, exposing the molten inner layers!")
    self.room:send_except(actor, "&9<blue>As " .. tostring(actor.name) .. "'s patience dwindles <red>" .. tostring(actor.name) .. " <blue>r<b:yellow>ip</><yellow>s <b:red>the &9<blue>rocky layer from <b:red>" .. tostring(actor.possessive) .. " face, </><yellow>expos<blue>ing the molten inner layers!")
    actor:send("<yellow>Your body melts, becoming more fluid.</>")
    self.room:send_except(actor, "<b:yellow>" .. tostring(actor.name) .. "'s body melts, becoming more fluid.</>")
elseif actor.is_player then
    actor:send("<b:yellow>Your skin softens and returns to normal.</>")
    self.room:send_except(actor, "<b:yellow>" .. tostring(actor.name) .. "'s skin softens and returns to normal.</>")
end