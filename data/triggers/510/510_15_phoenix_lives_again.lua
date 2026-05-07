-- Trigger: phoenix_lives_again
-- Zone: 510, ID: 15
-- Type: WORLD, Flags: SPEECH
--
-- Original DG Script: #51015
-- Reset spell. When somebody speaks the safe-word phrase containing
-- "phoenix is toast" anywhere in the trigger room, force-cleans the
-- phoenix room (510, 79): purges any straggler phoenix corpses and
-- respawns a fresh phoenix. Multiple purges are deliberate — there
-- might be a stale phoenix-key item or two on the floor.

-- Speech keywords: "phoenix is toast"
local speech_lower = string.lower(speech or "")
if not string.find(speech_lower, "phoenix is toast") then
    return true
end

local phoenix_room = get_room(510, 79)
if not phoenix_room then
    return true
end

-- Sweep any stale phoenix entities (mob and items named "phoenix").
for _ = 1, 5 do
    local ph = phoenix_room:find_actor("phoenix")
    if ph then
        world.destroy(ph)
    end
end
phoenix_room:send("The heat of the combustion scorches everything!")
wait(2)
phoenix_room:send("The phoenix rises again from the ashes!")
phoenix_room:spawn_mobile(510, 26)
local new_phoenix = phoenix_room:find_actor("phoenix")
if new_phoenix then
    new_phoenix:command("whistle")
end
