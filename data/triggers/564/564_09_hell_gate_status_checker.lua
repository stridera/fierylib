-- Trigger: hell_gate_status_checker
-- Zone: 564, ID: 9
-- Type: MOB, Flags: SPEECH
-- Status: NEEDS_REVIEW
--   Complex nesting: 27 if statements
--   Large script: 6310 chars
--
-- Original DG Script: #56409

-- Converted from DG Script #56409: hell_gate_status_checker
-- Original: MOB trigger, flags: SPEECH, probability: 100%

-- Speech keywords: status status? progress progress?
local speech_lower = string.lower(speech)
if not (string.find(string.lower(speech), "status") or string.find(string.lower(speech), "status?") or string.find(string.lower(speech), "progress") or string.find(string.lower(speech), "progress?")) then
    return true  -- No matching keywords
end
local stage = actor:get_quest_stage("hell_gate")
wait(2)
-- switch on stage
if stage == 1 then
    self.room:send(tostring(self.name) .. " says, 'We are preparing to open a door to")
    self.room:send("</>Garl'lixxil and release one of our demon lords.  Find " .. tostring(objects.template(32, 13).name) .. ".'")
elseif stage == 2 then
    local key1 = actor:get_quest_var("hell_gate:8303")
    local key2 = actor:get_quest_var("hell_gate:23709")
    local key3 = actor:get_quest_var("hell_gate:49008")
    local key4 = actor:get_quest_var("hell_gate:52012")
    local key5 = actor:get_quest_var("hell_gate:52013")
    local key6 = actor:get_quest_var("hell_gate:53402")
    local key7 = actor:get_quest_var("hell_gate:58109")
    self:say("You must find seven keys to seven gates.")
    -- (empty room echo)
    if key1 or key2 or key3 or key4 or key5 or key6 or key7 then
        self.room:send("You have already found:")
        if key1 then
            self.room:send("<red>" .. tostring(objects.template(83, 3).name) .. "</>")
        end
        if key2 then
            self.room:send("<red>" .. tostring(objects.template(237, 9).name) .. "</>")
        end
        if key3 then
            self.room:send("<red>" .. tostring(objects.template(490, 8).name) .. "</>")
        end
        if key4 then
            self.room:send("<red>" .. tostring(objects.template(520, 12).name) .. "</>")
        end
        if key5 then
            self.room:send("<red>" .. tostring(objects.template(520, 13).name) .. "</>")
        end
        if key6 then
            self.room:send("<red>" .. tostring(objects.template(534, 2).name) .. "</>")
        end
        if key7 then
            self.room:send("<red>" .. tostring(objects.template(581, 9).name) .. "</>")
        end
    end
    -- (empty room echo)
    self.room:send("You must still find:")
    if not key1 then
        self.room:send("<b:red>A small, well-crafted key made of wood with the smell of rich sap</>")
        self.room:send("<b:red>Kept at the gate of a tribe's home.</>")
        -- (empty room echo)
    end
    if not key6 then
        self.room:send("<b:red>A key made of light silvery metal which only elves can work</>")
        self.room:send("<b:red>Deep in a frozen valley.</>")
        -- (empty room echo)
    end
    if not key2 then
        self.room:send("<b:red>A large, black key humming with magical energy</>")
        self.room:send("<b:red>From a twisted cruel city in a huge underground cavern.</>")
        -- (empty room echo)
    end
    if not key7 then
        self.room:send("<b:red>A simple lacquered iron key</>")
        self.room:send("<b:red>In the care of a radiant bird on an emerald island.</>")
        -- (empty room echo)
    end
    if not key3 then
        self.room:send("<b:red>A rusted but well cared for key</>")
        self.room:send("<b:red>Held by a winged captain on an island of magical beasts.</>")
        -- (empty room echo)
    end
    if not key5 then
        self.room:send("<b:red>A golden plated, wrought-iron key</>")
        self.room:send("<b:red>held at the gates to a desacrated city.</>")
        -- (empty room echo)
    end
    if not key4 then
        self.room:send("<b:red>One nearly impossible to see</>")
        self.room:send("<b:red>guarded by a fiery beast with many heads.</>")
    end
elseif stage == 3 then
    local blood1 = actor:get_quest_var("hell_gate:56400")
    local blood2 = actor:get_quest_var("hell_gate:56401")
    local blood3 = actor:get_quest_var("hell_gate:56402")
    local blood4 = actor:get_quest_var("hell_gate:56403")
    local blood5 = actor:get_quest_var("hell_gate:56404")
    local blood6 = actor:get_quest_var("hell_gate:56405")
    local blood7 = actor:get_quest_var("hell_gate:56406")
    self.room:send(tostring(self.name) .. " says, 'Sacrifice seven different <b:red>children</>.")
    self.room:send("</><b:white>[Drop]</> their <b:red>blood</> here to defile the keys.'")
    -- (empty room echo)
    if blood1 or blood2 or blood3 or blood4 or blood5 or blood6 or blood7 then
        self.room:send("You have already found:")
        if blood1 then
            self.room:send("<red>" .. tostring(objects.template(564, 0).name) .. "</>")
        end
        if blood2 then
            self.room:send("<red>" .. tostring(objects.template(564, 1).name) .. "</>")
        end
        if blood3 then
            self.room:send("<red>" .. tostring(objects.template(564, 2).name) .. "</>")
        end
        if blood4 then
            self.room:send("<red>" .. tostring(objects.template(564, 3).name) .. "</>")
        end
        if blood5 then
            self.room:send("<red>" .. tostring(objects.template(564, 4).name) .. "</>")
        end
        if blood6 then
            self.room:send("<red>" .. tostring(objects.template(564, 5).name) .. "</>")
        end
        if blood7 then
            self.room:send("<red>" .. tostring(objects.template(564, 6).name) .. "</>")
        end
    end
    -- (empty room echo)
    local total = (7 - (blood1 + blood2 + blood3 + blood4 + blood5 + blood6 + blood7))
    if total == 1 then
        self.room:send("Sacrifice the last child!")
    else
        self.room:send(tostring(self.name) .. " says, 'Bring the blood of <red>" .. tostring(total) .. "</> more children.'")
    end
    -- (empty room echo)
    self.room:send(tostring(self.name) .. " says, 'If you need a new dagger, say <b:red>\"I need a new</>")
    self.room:send("</><b:red>dagger\"</>.'")
elseif stage == 4 then
    self:say("Give the spider-shaped dagger back to me.")
elseif stage == 5 then
    self:say("Slay Larathiel and release our demon lord!")
else
    if actor:get_has_completed("hell_gate") then
        self:say("You have already learned to open the gates of Hell.")
    else
        self:say("You're not working with me.")
    end
end