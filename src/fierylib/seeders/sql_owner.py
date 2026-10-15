"""Ownership fix-up block shared by the SQL patches that create tables."""


def owner_fixup_sql(tables: tuple[str, ...]) -> str:
    """A ``DO`` block giving ``tables`` (and their serial sequences) the owner of ``"Characters"``.

    A patch run by a superuser (``postgres`` on prod) creates tables owned by that user; Prisma and
    the game then hit "permission denied". Environment-neutral: dev's owner is ``strider``, prod's
    ``fierynext``. Ends with a newline; rerunning is a no-op.
    """
    arr = ", ".join(f"'{t}'" for t in tables)
    return f"""-- Environment-neutral ownership: tables created by a superuser (postgres on prod)
-- must belong to the same role as the existing tables, or Prisma gets
-- "permission denied". Dev owner is strider, prod is fierynext.
DO $$
DECLARE
  tbl_owner text;
  t text;
  seq text;
BEGIN
  SELECT tableowner INTO tbl_owner FROM pg_tables WHERE tablename = 'Characters' LIMIT 1;
  IF tbl_owner IS NOT NULL THEN
    FOREACH t IN ARRAY ARRAY[{arr}] LOOP
      EXECUTE format('ALTER TABLE %I OWNER TO %I', t, tbl_owner);
      FOR seq IN
        SELECT sq.relname
        FROM pg_class sq
        JOIN pg_depend d ON d.objid = sq.oid AND d.deptype = 'a'
        JOIN pg_class tb ON tb.oid = d.refobjid
        WHERE sq.relkind = 'S' AND tb.relname = t AND tb.relnamespace = 'public'::regnamespace
      LOOP
        EXECUTE format('ALTER SEQUENCE %I OWNER TO %I', seq, tbl_owner);
      END LOOP;
    END LOOP;
  END IF;
END $$;
"""
