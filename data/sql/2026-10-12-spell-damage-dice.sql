-- fierymud-rs #128: "Spell dams static" - Full Harm always hit for exactly 200, Chain Lightning for exactly 140.
-- The damage formulas only had the skill term; legacy mag_damage() (magic.cpp) first rolls the dice from the
-- online damage table (lib/misc/spell_dams) and every `dam += <formula>` case adds its formula on top of that
-- roll. The dice are now part of each formula (data/abilities.json is the source for reimports):
--   NdM + static [+ bonus] + <old skill term>          PvE / mob casters (the npc_* columns)
-- A player casting at a player rolls the pc_* columns; the two are folded into one expression with the
-- `actor_is_player * target_is_player` product Sunray already uses. Spells that used `base_damage` (a stand-in
-- for the table roll) lose that term and its base_damage_note. Cremate has no case in the switch, so the table
-- roll is its whole damage; Degeneration's switch case is `roll_dice(3, 40) + 300`.
-- Keyed by Ability.plain_name; each row only matches while the amount is still the old formula, so a second run
-- changes 0 rows and a builder-edited formula is never overwritten.
UPDATE "AbilityEffect" ae
SET override_params = jsonb_set(ae.override_params, '{amount}', to_jsonb(v.new_amount::text)) - 'base_damage_note'
FROM (VALUES
  ('CALL_LIGHTNING', 0, '(pow(skill,2)*7)/400', '15d5 + 50 + (pow(skill,2)*7)/400'),
  ('CAUSE_CRITIC', 0, '(pow(skill,2)*53)/10000', '8d6 + 9 + (pow(skill,2)*53)/10000'),
  ('CAUSE_LIGHT', 0, '(pow(skill,2)*2)/625', '4d4 + 2 + (pow(skill,2)*2)/625'),
  ('CAUSE_SERIOUS', 0, '(pow(skill,2)*9)/2000', '6d5 + 5 + (pow(skill,2)*9)/2000'),
  ('CHAIN_LIGHTNING', 0, '(pow(skill,2)*7)/500', '12d5 + (26 - 26 * actor_is_player * target_is_player) + (pow(skill,2)*7)/500'),
  ('CREMATE', 0, 'skill * 2', 'roll_dice(20 + 5 * actor_is_player * target_is_player, 15 - 5 * actor_is_player * target_is_player) + (350 - 225 * actor_is_player * target_is_player)'),
  ('DESTROY_UNDEAD', 0, 'base_damage + (pow(skill, 2) * 27) / 1000', '18d5 + 40 + (pow(skill, 2) * 27) / 1000'),
  ('DISPEL_EVIL', 0, 'base_damage + (pow(skill, 2) * 7) / 1000', '10d5 + 15 + (pow(skill, 2) * 7) / 1000'),
  ('DISPEL_GOOD', 0, 'base_damage + (pow(skill, 2) * 7) / 1000', '10d5 + 15 + (pow(skill, 2) * 7) / 1000'),
  ('DIVINE_BOLT', 0, 'base_damage + (pow(skill, 2) * 53) / 10000', '12d4 + 9 + (pow(skill, 2) * 53) / 10000'),
  ('DIVINE_RAY', 0, 'base_damage + pow(skill, 2) / 125', 'roll_dice(10 - 5 * actor_is_player * target_is_player, 10) + min(75, skill * 2) + pow(skill, 2) / 125'),
  ('FIRESTORM', 0, 'base_damage + (pow(skill, 2) * 1) / 100', 'roll_dice(10 - 5 * actor_is_player * target_is_player, 10 + 2 * actor_is_player * target_is_player) + (pow(skill, 2) * 1) / 100'),
  ('FLOOD', 0, 'base_damage + (pow(skill, 2) * 13) / 200', 'roll_dice(50 - 35 * actor_is_player * target_is_player, 10 + 5 * actor_is_player * target_is_player) + (50 - 50 * actor_is_player * target_is_player) + (pow(skill, 2) * 13) / 200'),
  ('FULL_HARM', 0, '(pow(skill,2)*1)/50', 'roll_dice(50, 14 - 11 * actor_is_player * target_is_player) + 50 + (pow(skill,2)*1)/50'),
  ('HARM', 0, '(pow(skill,2)*41)/5000', 'roll_dice(50, 6 - 4 * actor_is_player * target_is_player) + 35 + (pow(skill,2)*41)/5000'),
  ('HELL_BOLT', 0, 'base_damage + (pow(skill, 2) * 53) / 10000', 'roll_dice(10 - 5 * actor_is_player * target_is_player, 10 - 4 * actor_is_player * target_is_player) + (pow(skill, 2) * 53) / 10000'),
  ('HELLFIRE_BRIMSTONE', 0, 'base_damage + pow(skill, 2) / 180', 'roll_dice(30 - 20 * actor_is_player * target_is_player, 5 + 3 * actor_is_player * target_is_player) + (25 - 25 * actor_is_player * target_is_player) + pow(skill, 2) / 180'),
  ('HOLY_WORD', 0, 'base_damage + (pow(skill, 2) * 33) / 2000', '20d5 + 35 + (pow(skill, 2) * 33) / 2000'),
  ('ICE_SHARDS', 0, 'base_damage + (pow(skill, 2) * 1) / 10', '20d20 + (300 - 250 * actor_is_player * target_is_player) + (pow(skill, 2) * 1) / 10'),
  ('ICE_STORM', 0, 'base_damage + (pow(skill, 2) * 1) / 100', '20d5 + 35 + (pow(skill, 2) * 1) / 100'),
  ('LESSER_EXORCISM', 0, 'base_damage + pow(skill, 2) / 25', '50d5 + 50 + pow(skill, 2) / 25'),
  ('METEORSWARM', 0, 'base_damage + (pow(skill, 2) * 13) / 200', 'roll_dice(50 - 35 * actor_is_player * target_is_player, 10 + 5 * actor_is_player * target_is_player) + (50 + 30 * actor_is_player * target_is_player) + (pow(skill, 2) * 13) / 200'),
  ('STYGIAN_ERUPTION', 0, 'base_damage + pow(skill, 2) / 125', '12d5 + 36 + pow(skill, 2) / 125'),
  ('SUPERNOVA', 0, 'base_damage + (pow(skill, 2) * 1) / 10', '20d20 + (300 - 250 * actor_is_player * target_is_player) + (pow(skill, 2) * 1) / 10'),
  ('UNHOLY_WORD', 0, 'base_damage + (pow(skill, 2) * 33) / 2000', '20d5 + 35 + (pow(skill, 2) * 33) / 2000'),
  ('VAMPIRIC_BREATH', 0, 'base_damage + roll_dice(2, skill + 10)', '1d50 + min(100, skill / (2 + 2 * actor_is_player * target_is_player)) + roll_dice(2, skill + 10)'),
  ('WRITHING_WEEDS', 0, 'base_damage + (pow(skill, 2) * 53) / 10000', '8d6 + 9 + (pow(skill, 2) * 53) / 10000'),
  ('DEGENERATION', 0, 'skill', '3d40 + 300')
) AS v(plain_name, ord, old_amount, new_amount),
     "Ability" a,
     "Effect" e
WHERE a.plain_name = v.plain_name
  AND ae.ability_id = a.id
  AND ae."order" = v.ord
  AND e.id = ae.effect_id
  AND e.name = 'damage'
  AND ae.override_params->>'amount' = v.old_amount;
