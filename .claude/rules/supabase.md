---
paths: ["supabase/**"]
---

# Supabase Rules

## Multi-Tenancy Strategy
- **Schema separation**: Per-app PostgreSQL schemas (`blacklabelled`, `abba`, etc.)
- **Shared infrastructure**: `public` schema contains `tenants`, `user_tenants`, `languages`, `translations`
- **Tenant linking**: `tenant_id UUID NOT NULL REFERENCES public.tenants(id) ON DELETE CASCADE`

## Table Creation Requirements
- `tenant_id UUID NOT NULL REFERENCES public.tenants(id)` column is required
- `created_at TIMESTAMPTZ NOT NULL DEFAULT now()` is required
- PK: `UUID PRIMARY KEY DEFAULT gen_random_uuid()`
- Table names: snake_case, plural
- `ENABLE ROW LEVEL SECURITY` immediately upon creation

## RLS Policy Patterns
```sql
-- Read-only public data (portfolios, etc.)
FOR SELECT USING (true);

-- Soft delete filter
FOR SELECT USING (deleted_at IS NULL);

-- Admin write policy
-- ⚠️ Do NOT use NEW. prefix in INSERT WITH CHECK!
-- Supabase RLS does not support NEW references in INSERT.
-- Use column names directly (tenant_id, NOT NEW.tenant_id)
FOR INSERT WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.user_tenants ut
    WHERE ut.user_id = auth.uid()
      AND ut.tenant_id = tenant_id          -- ✅ correct
      -- AND ut.tenant_id = NEW.tenant_id   -- ❌ causes error
      AND ut.role IN ('owner', 'admin')
  )
);
```

## Schema Creation Pattern
```sql
CREATE SCHEMA IF NOT EXISTS {app_name};
GRANT USAGE ON SCHEMA {app_name} TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA {app_name} TO anon, authenticated, service_role;
```

## Migrations
- Filename: `{timestamp}_{description}.sql` (e.g., 20260411000001_public_multi_tenant.sql)
- Order: public infrastructure → app schemas → seed data

## Never
- Include service_role key in client code
- Deploy tables without RLS
- Run DB migrations directly (including during Ralph) → user applies manually
- Hardcode UUIDs (use gen_random_uuid())

## RPC Functions
- Declare with SECURITY DEFINER
- Input validation is required
