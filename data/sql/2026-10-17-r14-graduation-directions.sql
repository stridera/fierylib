-- Playtest r14 B3: 519:73 graduation directions one per line (legacy newline color codes removed)
--
-- Idempotent: a row already holding the new body is left alone, so rerunning
-- updates nothing. Keyed by the composite primary key (zone_id, id).
-- Guarded: a row is only touched while it still holds the previous committed
-- file (md5 of the body or of the whole file, with or without the final
-- newline), so rows edited in Muditor since then are left alone.

BEGIN;

UPDATE "Triggers" AS t
SET commands = v.commands,
    updated_at = now()
FROM (VALUES
  -- data/triggers/519/519_73_academy_revel_speech_finish.lua
  (519, 73, $trig$-- Converted from DG Script #51973: academy_revel_speech_finish
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- DG word list (num_arg 100): the speech must contain one of these as a whole word or phrase.
local speech_padded = " " .. string.lower(speech) .. " "
local speech_hit = false
for _, w in ipairs({"finish"}) do
    if string.find(speech_padded, "[%s%p]" .. string.gsub(w, "%p", "%%%0") .. "[%s%p]") then
        speech_hit = true
        break
    end
end
if not speech_hit then
    return true  -- None of the listed words
end
wait(0.2)
if actor:get_quest_stage("school") == 6 then
    actor:complete_quest("school")
    if actor.level == 1 then
        -- switch on actor.class -- target XP for level 2 by class
        local goal
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" then
            goal = 6323
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "illusionist" or actor.class == "bard" then
            goal = 6599
        elseif actor.class == "monk" or actor.class == "necromancer" then
            goal = 7149
        elseif actor.class == "warrior" or actor.class == "berserker" then
            goal = 6049
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "diabolist" or actor.class == "druid" or actor.class == "rogue" or actor.class == "thief" or actor.class == "assassin" or actor.class == "mercenary" then
            goal = 5499
        else
            goal = 5499
        end
        local cap = (goal / 5)
        local reward = (goal - actor.exp)
        local loops = (reward / cap)
        local diff = (reward - (loops * cap))
        local lap = 1
        while lap <= loops do
            actor:award_exp(cap)
            lap = lap + 1
        end
        actor:award_exp(diff)
        -- switch on actor.class -- guild routing
        local direction, direction2, master
        if actor.class == "paladin" or actor.class == "anti-paladin" or actor.class == "ranger" or actor.class == "warrior" or actor.class == "monk" or actor.class == "berserker" then
            direction = "the Warrior's Guild"
            direction2 = "south\nsouth\nsouth\neast\neast\nnorth\neast\nnorth"
            master = "Warrior Coach"
        elseif actor.class == "rogue" or actor.class == "thief" or actor.class == "mercenary" or actor.class == "assassin" or actor.class == "bard" then
            direction = "the Rogue's Guild"
            direction2 = "south\nsouth\nsouth\nwest\nsouth\neast\ndown"
            master = "the Master Rogue"
        elseif actor.class == "sorcerer" or actor.class == "cryomancer" or actor.class == "pyromancer" or actor.class == "necromancer" or actor.class == "illusionist" then
            direction = "the Mage's Guild"
            direction2 = "south\nsouth\nsouth\nwest\nwest\nsouth\nsouth\neast"
            master = "the Archmage"
        elseif actor.class == "cleric" or actor.class == "priest" or actor.class == "druid" or actor.class == "diabolist" then
            direction = "the Cleric's Guild"
            direction2 = "west\nnorth"
            master = "the High Priestess"
        else
            self:say("Oops, you broke, find a god.")
            return true
        end
        wait(2)
        actor:send(tostring(self.name) .. " tells you, 'Now that you've finished the Academy, it's time to find your Guild Master!")
        actor:send("They are waiting in your guild's Inner Sanctum, just beyond the entrance room to your guild.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:cyan>Look</> at the <b:cyan>map</> in your inventory.")
        actor:send("It will show you a layout of town.'")
        wait(2)
        actor:send(tostring(self.name) .. " tells you, '<b:green>East</> is the Forest Temple of Mielikki.")
        actor:send("Your guild is <b:magenta>" .. tostring(direction) .. "</>.")
        actor:send("From the Temple of Mielikki it is:")
        -- one direction per line, as the legacy newline color codes laid it out
        for step in string.gmatch(direction2, "[^\n]+") do
            actor:send("<b:yellow> " .. step .. "</>")
        end
        actor:send("Your Guild Master is <b:magenta>" .. tostring(master) .. "</>.")
        actor:send("</>")
        actor:send("You gain levels automatically as you earn experience; type <b:cyan>LEVEL</> to see how close you are.")
        actor:send("If you ever forget anything you can always consult the <b:cyan>HELP</> file.'")
        wait(3)
    end
    actor:send(tostring(self.name) .. " tells you, 'Your Guild Master here in the Town of Mielikki will grant you your first quest.")
    actor:send("They will ask you for <b:yellow>gems</> and <b:yellow>armor</> which drop randomly from creatures across the world.")
    actor:send("Bring back what they ask for and you'll be well rewarded!'")
    wait(4)
    actor:send(tostring(self.name) .. " tells you, 'Congratulations again, graduate!  May you climb to ever greater fortune!'")
end$trig$, ARRAY['5eedca030ded2c24af223bde20458a61', '2d31c1fc90e2f06080ea95cbce7689e4', 'cd0ab1a0c25c75c256a5c827afe8c616'])
) AS v(zone_id, id, commands, old_md5s)
WHERE t.zone_id = v.zone_id
  AND t.id = v.id
  AND md5(t.commands) = ANY (v.old_md5s)
  AND t.commands IS DISTINCT FROM v.commands;

COMMIT;
