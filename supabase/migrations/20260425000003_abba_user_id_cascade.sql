-- ============================================================================
-- 20260425000003: Phase A3 — abba.* user_id FK ON DELETE CASCADE
--                 + community_posts orphan cleanup
-- ----------------------------------------------------------------------------
-- Adds ON DELETE CASCADE to 6 abba.* tables whose user_id references
-- auth.users(id) without cascade. This is required for the "last-app"
-- branch of the delete_account Edge Function (Option C) to cleanly remove
-- all abba data when auth.users itself is deleted.
--
-- Tables affected (currently NO ACTION → CASCADE):
--   1. abba.prayers
--   2. abba.prayer_streaks
--   3. abba.milestones
--   4. abba.user_settings
--   5. abba.notification_settings
--   6. abba.community_posts
--
-- Tables already using CASCADE on user_id (no change needed):
--   - abba.post_comments / post_likes / comment_likes / post_saves
--   - abba.reports.reporter_id
--
-- Why cleanup is part of this migration:
--   ALTER TABLE … ADD FOREIGN KEY validates against existing data. The
--   community_posts table holds 10 posts authored by 6 seed user_ids
--   (00000000-0000-0000-0000-000000000001..6) that no longer exist in
--   auth.users — leftover from early development before the CASCADE was
--   in place. Without first removing them the FK swap cannot succeed,
--   so the cleanup runs in the same transaction. If the cleanup fails
--   for any reason, the entire migration rolls back and the schema is
--   left untouched.
--
-- Diagnostics measured by operator (2026-04-25) before this migration:
--   - 10 orphan posts across 6 seed user_ids
--   - 18 orphan comments (auto-cleaned via post_id CASCADE)
--   - 12 orphan likes (auto-cleaned via post_id CASCADE)
--   - 0 orphan saves
--   - reports cleanup is unconditional (no-op when 0)
--
-- Cleanup is bounded to user_ids missing from auth.users — never touches
-- data owned by a live user.
--
-- All FK swaps use information_schema lookup so the migration is robust
-- to any historical constraint rename.
--
-- See:
--   apps/abba/specs/REQUIREMENTS.md §11
--   .claude/rules/learned-pitfalls.md (Option C account deletion)
-- ============================================================================


DO $$
DECLARE
  -- Phase A — cleanup state
  v_orphan_post_ids       UUID[];
  v_orphan_comment_ids    UUID[];
  v_orphan_post_count     INT;
  v_orphan_comment_count  INT;
  v_reports_post_deleted  INT;
  v_reports_cmt_deleted   INT;

  -- Phase B — cascade swap state
  v_target_tables TEXT[] := ARRAY[
    'prayers',
    'prayer_streaks',
    'milestones',
    'user_settings',
    'notification_settings',
    'community_posts'
  ];
  v_table           TEXT;
  v_constraint_name TEXT;
BEGIN
  -- =====================================================================
  -- Phase A — community_posts orphan cleanup (must precede the FK swap)
  -- =====================================================================

  -- A.1 Snapshot orphan post ids
  SELECT array_agg(id) INTO v_orphan_post_ids
  FROM abba.community_posts
  WHERE user_id NOT IN (SELECT id FROM auth.users);

  v_orphan_post_count := COALESCE(array_length(v_orphan_post_ids, 1), 0);

  -- A.2 Snapshot comment ids that would cascade-delete with those posts
  --     (so reports targeting them can be cleaned BEFORE the rows vanish)
  IF v_orphan_post_count > 0 THEN
    SELECT array_agg(id) INTO v_orphan_comment_ids
    FROM abba.post_comments
    WHERE post_id = ANY(v_orphan_post_ids);
  ELSE
    v_orphan_comment_ids := ARRAY[]::UUID[];
  END IF;

  v_orphan_comment_count := COALESCE(array_length(v_orphan_comment_ids, 1), 0);

  RAISE NOTICE 'cleanup snapshot: % orphan posts, % comments-to-cascade',
    v_orphan_post_count, v_orphan_comment_count;

  -- A.3 reports cleanup (target_id is not a FK, so no automatic cascade)
  IF v_orphan_post_count > 0 THEN
    DELETE FROM abba.reports
    WHERE target_type = 'post'
      AND target_id = ANY(v_orphan_post_ids)
      AND app_id = 'abba';
    GET DIAGNOSTICS v_reports_post_deleted = ROW_COUNT;
  ELSE
    v_reports_post_deleted := 0;
  END IF;

  IF v_orphan_comment_count > 0 THEN
    DELETE FROM abba.reports
    WHERE target_type = 'comment'
      AND target_id = ANY(v_orphan_comment_ids)
      AND app_id = 'abba';
    GET DIAGNOSTICS v_reports_cmt_deleted = ROW_COUNT;
  ELSE
    v_reports_cmt_deleted := 0;
  END IF;

  RAISE NOTICE 'cleanup reports: % post-targeted, % comment-targeted',
    v_reports_post_deleted, v_reports_cmt_deleted;

  -- A.4 Delete orphan posts. Existing CASCADE on post_id wipes
  --     post_comments / post_likes / post_saves; comment_likes cascades
  --     via post_comments.id.
  IF v_orphan_post_count > 0 THEN
    DELETE FROM abba.community_posts
    WHERE id = ANY(v_orphan_post_ids);
    RAISE NOTICE 'cleanup deleted % orphan community_posts (children cascaded)',
      v_orphan_post_count;
  ELSE
    RAISE NOTICE 'cleanup: no orphan community_posts found, skipping';
  END IF;

  -- =====================================================================
  -- Phase B — swap user_id FK to ON DELETE CASCADE on 6 abba.* tables
  -- =====================================================================
  FOREACH v_table IN ARRAY v_target_tables LOOP
    -- Look up the FK constraint name on (abba.<table>.user_id → auth.users.id)
    -- whose delete_rule is not already CASCADE.
    SELECT tc.constraint_name INTO v_constraint_name
    FROM information_schema.table_constraints tc
    JOIN information_schema.key_column_usage kcu
      ON tc.constraint_name = kcu.constraint_name
     AND tc.table_schema = kcu.table_schema
    JOIN information_schema.referential_constraints rc
      ON tc.constraint_name = rc.constraint_name
     AND tc.table_schema = rc.constraint_schema
    WHERE tc.constraint_type = 'FOREIGN KEY'
      AND tc.table_schema = 'abba'
      AND tc.table_name = v_table
      AND kcu.column_name = 'user_id'
      AND rc.delete_rule <> 'CASCADE'
    LIMIT 1;

    IF v_constraint_name IS NULL THEN
      RAISE NOTICE 'abba.% — user_id FK already CASCADE or not found, skipping',
        v_table;
      CONTINUE;
    END IF;

    EXECUTE format(
      'ALTER TABLE abba.%I DROP CONSTRAINT %I',
      v_table, v_constraint_name
    );

    EXECUTE format(
      'ALTER TABLE abba.%I '
      'ADD CONSTRAINT %I '
      'FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE',
      v_table, v_constraint_name
    );

    RAISE NOTICE 'abba.% — % swapped to ON DELETE CASCADE',
      v_table, v_constraint_name;
  END LOOP;
END $$;


-- ---------------------------------------------------------------------------
-- Verification (run after migration completes — should return 0 rows)
-- ---------------------------------------------------------------------------
-- SELECT tc.table_name, rc.delete_rule
-- FROM information_schema.table_constraints tc
-- JOIN information_schema.referential_constraints rc
--   ON tc.constraint_name = rc.constraint_name
-- JOIN information_schema.key_column_usage kcu
--   ON tc.constraint_name = kcu.constraint_name
-- WHERE tc.table_schema = 'abba'
--   AND kcu.column_name = 'user_id'
--   AND rc.delete_rule <> 'CASCADE';


-- ---------------------------------------------------------------------------
-- Rollback (for reference — do not execute unless explicitly needed)
-- ---------------------------------------------------------------------------
-- The deleted orphan rows cannot be restored; they were demonstrably
-- corrupt (user_id pointed at non-existent auth.users rows). Reverting
-- the FK referential action only:
--
-- DO $$
-- DECLARE
--   v_table TEXT;
--   v_constraint TEXT;
-- BEGIN
--   FOREACH v_table IN ARRAY ARRAY['prayers','prayer_streaks','milestones',
--                                  'user_settings','notification_settings',
--                                  'community_posts']
--   LOOP
--     SELECT constraint_name INTO v_constraint
--     FROM information_schema.table_constraints
--     WHERE constraint_type='FOREIGN KEY'
--       AND table_schema='abba' AND table_name=v_table
--     LIMIT 1;
--     EXECUTE format('ALTER TABLE abba.%I DROP CONSTRAINT %I', v_table, v_constraint);
--     EXECUTE format(
--       'ALTER TABLE abba.%I ADD CONSTRAINT %I '
--       'FOREIGN KEY (user_id) REFERENCES auth.users(id)',
--       v_table, v_constraint
--     );
--   END LOOP;
-- END $$;
