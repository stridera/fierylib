-- Issues stridera/fierymud-rs#86 / #87: colour codes in item names show up raw, e.g.
-- "You remove &3&bSlippers of the Seer&0." The legacy player import stored each carried
-- item's legacy short description (with its `&` colour codes) verbatim in
-- "CharacterItems".custom_name, and the runtime (rightly) only knows the modern <tag> markup.
-- Players cannot type `&` into a name (nameitem rejects it), so every custom_name with an `&`
-- code comes from that import.
--
-- 1. Where the name is just the prototype's own name with its codes, the override is noise:
--    clear it, so the item shows the prototype's (already converted) coloured name.
-- 2. Everything else (a legacy-renamed item) is converted to modern markup with the same rules
--    as fierylib's ColorConverter (relative `&` codes; `&&` is a literal ampersand; `&_` a
--    newline).
--
-- Idempotent: both steps only touch rows that still contain an `&` code, and a converted row
-- no longer does. (A name with a literal `&&` would convert to a single `&`; none exist.)

CREATE FUNCTION pg_temp.legacy_strip(src text) RETURNS text LANGUAGE sql IMMUTABLE AS $$
  SELECT regexp_replace(regexp_replace(src, '&&', E'\x01', 'g'), '&[^&]', '', 'g')
$$;

CREATE FUNCTION pg_temp.legacy_to_tags(src text) RETURNS text LANGUAGE plpgsql AS $$
DECLARE
  i int := 1;
  n int := length(src);
  ch text;
  nx text;
  res text := '';
  fg text; bg text; bold boolean := false; ul boolean := false; dim boolean := false;
  afg text; abg text; abold boolean := false; aul boolean := false; adim boolean := false;
  mods text[];
BEGIN
  WHILE i <= n LOOP
    ch := substr(src, i, 1);
    IF ch = '&' AND i < n THEN
      nx := substr(src, i + 1, 1);
      i := i + 2;
      IF nx = '&' THEN
        res := res || '&';
      ELSIF nx = '_' THEN
        res := res || E'\n';
      ELSIF nx = '0' THEN
        fg := NULL; bg := NULL; bold := false; ul := false; dim := false;
      ELSIF nx IN ('1','2','3','4','5','6','7','9') THEN
        fg := (ARRAY['red','green','yellow','blue','magenta','cyan','white'])[nx::int];
        IF nx = '9' THEN fg := 'black'; END IF;
      ELSIF nx = 'R' THEN bg := 'bg-red';
      ELSIF nx = 'G' THEN bg := 'bg-green';
      ELSIF nx = 'Y' THEN bg := 'bg-yellow';
      ELSIF nx = 'B' THEN bg := 'bg-blue';
      ELSIF nx = 'M' THEN bg := 'bg-magenta';
      ELSIF nx = 'C' THEN bg := 'bg-cyan';
      ELSIF nx = 'W' THEN bg := 'bg-white';
      ELSIF nx IN ('L','K') THEN bg := 'bg-black';
      ELSIF nx = 'b' THEN bold := true;
      ELSIF nx = 'u' THEN ul := true;
      ELSIF nx = 'd' THEN dim := true;
      END IF;
      CONTINUE;
    END IF;
    -- A visible character: bring the open tag in line with the current state.
    IF fg IS DISTINCT FROM afg OR bg IS DISTINCT FROM abg
       OR bold <> abold OR ul <> aul OR dim <> adim THEN
      IF afg IS NOT NULL OR abg IS NOT NULL OR abold OR aul OR adim THEN
        res := res || '</>';
      END IF;
      mods := ARRAY[]::text[];
      IF bold THEN mods := array_append(mods, 'b'); END IF;
      IF ul THEN mods := array_append(mods, 'u'); END IF;
      IF dim THEN mods := array_append(mods, 'dim'); END IF;
      IF bg IS NOT NULL THEN mods := array_append(mods, bg); END IF;
      IF fg IS NOT NULL THEN mods := array_append(mods, fg); END IF;
      IF array_length(mods, 1) > 0 THEN
        res := res || '<' || array_to_string(mods, ':') || '>';
      END IF;
      afg := fg; abg := bg; abold := bold; aul := ul; adim := dim;
    END IF;
    res := res || ch;
    i := i + 1;
  END LOOP;
  IF afg IS NOT NULL OR abg IS NOT NULL OR abold OR aul OR adim THEN
    res := res || '</>';
  END IF;
  RETURN res;
END
$$;

UPDATE "CharacterItems" ci
SET custom_name = NULL
FROM "Objects" o
WHERE o.zone_id = ci.object_zone_id
  AND o.id = ci.object_id
  AND ci.custom_name LIKE '%&%'
  AND lower(pg_temp.legacy_strip(ci.custom_name)) = lower(o.plain_name);

UPDATE "CharacterItems"
SET custom_name = pg_temp.legacy_to_tags(custom_name)
WHERE custom_name LIKE '%&%';
