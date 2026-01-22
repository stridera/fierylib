-- Trigger: meteor splash
-- Zone: 482, ID: 57
-- Type: WORLD, Flags: GLOBAL
-- Status: CLEAN
--
-- Original DG Script: #48257

-- Converted from DG Script #48257: meteor splash
-- Original: WORLD trigger, flags: GLOBAL, probability: 100%
self.room:send("McCabe completes his spell...")
self.room:send("McCabe closes his eyes and utters the words, 'meteorswarm'")
self.room:send("<red>McCabe conjures up a controlled shower of meteors &9<blue>which <blue>splash </><cyan>harmlessly down in the ocean.</>")
get_room(482, 52):at(function()
    self.room:send("<red>A swarm of burning &9<blue>meteors stream down from the sky, <b:blue>splashing </><cyan>harmlessly into the ocean.</>")
end)
get_room(482, 53):at(function()
    self.room:send("<red>A swarm of burning &9<blue>meteors stream down from the sky, <b:blue>splashing </><cyan>harmlessly into the ocean.</>")
end)
get_room(482, 54):at(function()
    self.room:send("<red>A swarm of burning &9<blue>meteors stream down from the sky, <b:blue>splashing </><cyan>harmlessly into the ocean.</>")
end)