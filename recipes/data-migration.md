# Recipe: Data Migration — Safe Migration Workflow

> **Use this recipe when:** migrating database schemas, moving data between systems, transforming data formats, or running zero-downtime migrations in production.

---

## When to Use This Recipe

- Schema migrations (add/rename/drop columns, change types)
- Data transformation pipelines (normalize, denormalize, reshape)
- System migrations (MongoDB → MariaDB, Redis → new cache layer)
- Zero-downtime blue/green data transitions
- Bulk data imports from external sources

**Risk Level:** 🔴 HIGH — Always requires a rollback plan and staging validation.

---

## Phase Overview

```
Discuss → Research → Plan → Execute (staged) → Verify → Ship
         ↓            ↓         ↓
     analyze      write      run dry-run
     current      plan +     first, then
     schema       rollback   production
```

---

## Step 1: Discuss Phase

Gather context before touching anything.

```
/gsd:discuss-phase --research
```

Key questions to answer:
- [ ] What is the current data size? (rows, GB)
- [ ] What is the acceptable downtime window? (zero / maintenance / hours)
- [ ] Is there a rollback checkpoint? (snapshot, backup, dual-write)
- [ ] What downstream services depend on this schema?
- [ ] Are there foreign key / index constraints to preserve?

---

## Step 2: Research Phase

Agent: **Levi (DBA)** — analyze schema + identify risks

```markdown
## Research Tasks (delegate to Levi)
1. Dump current schema DDL
2. Identify affected tables and row counts
3. Check foreign key constraints and indexes
4. Identify dependent application code (API queries, ORM models)
5. Estimate migration duration with sample run
6. Document rollback SQL / reverse migration script
```

Output expected: `RESEARCH.md` with schema analysis + risk matrix.

---

## Step 3: Plan Phase

```
/gsd:plan-phase
```

Mandatory plan sections:
- **Migration Strategy:** big-bang vs. online migration vs. dual-write
- **Execution Stages:** pre-migration, migration, post-migration, cleanup
- **Rollback Plan:** exact SQL or script to revert
- **Validation Gates:** row counts, checksums, application smoke test

### Migration Strategies

| Strategy | Use When | Risk |
|----------|----------|------|
| **Big-bang** | Small dataset, maintenance window ok | Medium |
| **Online migration** | Large dataset, zero downtime required | Low (complex) |
| **Dual-write** | Critical path, need parallel validation | Low (expensive) |
| **Shadow table** | Schema change with no downtime tolerance | Low |

---

## Step 4: Execute — Staged Approach

### Wave 1: Backup & Preparation (Levi + Ezra)
```bash
# Always snapshot before touching production
mysqldump -u root -p <db_name> > backup_$(date +%Y%m%d_%H%M%S).sql
# Or for MongoDB:
mongodump --db <db_name> --out backup_$(date +%Y%m%d_%H%M%S)

# Verify backup integrity
wc -l backup_*.sql  # sanity check
```

### Wave 2: Staging Migration (Levi)
```bash
# Run on staging first — ALWAYS
mysql -u root -p staging_db < migration.sql
# Validate row counts
mysql -e "SELECT COUNT(*) FROM new_table;" staging_db
```

### Wave 3: Application Code Update (Moses + David)
- Update ORM models / query code
- Add backward-compat layer if dual-write strategy
- Deploy to staging, run integration tests

### Wave 4: Production Migration (Levi + Ezra)
```bash
# For zero-downtime: use pt-online-schema-change or gh-ost
pt-online-schema-change --alter "ADD COLUMN new_field VARCHAR(255)" \
  D=prod_db,t=target_table --execute

# For maintenance window: direct SQL
mysql -u root -p prod_db < migration.sql
```

### Wave 5: Validation (Elijah QA)
- Row count matches expected
- Application smoke test passes
- No error spikes in logs
- Performance benchmark (query time before vs. after)

---

## Step 5: Verify

Checklist before closing the migration:

- [ ] **Row count parity:** source vs. destination count matches
- [ ] **Data integrity:** spot-check 100 random rows for correctness
- [ ] **Index health:** EXPLAIN on critical queries — no full table scans
- [ ] **Application health:** zero 500 errors for 15 minutes post-migration
- [ ] **Rollback tested:** dry-ran rollback SQL on staging successfully
- [ ] **Backup retained:** keep backup for ≥ 7 days post-migration
- [ ] **Cleanup:** drop deprecated columns/tables only after 1 full release cycle

---

## Rollback Procedure

If something goes wrong:

```bash
# Step 1: Halt application writes (maintenance mode or feature flag)
# Step 2: Restore from backup
mysql -u root -p prod_db < backup_YYYYMMDD_HHMMSS.sql
# Step 3: Restart application services
systemctl restart app-service
# Step 4: Verify application is healthy
# Step 5: Post-mortem
```

---

## Agent Delegation Map

| Task | Agent | Notes |
|------|-------|-------|
| Schema analysis + DDL | **Levi (DBA)** | Primary owner |
| Server/file backup | **Ezra (SysAdmin)** | Snapshot + storage |
| ORM/query code changes | **Moses (Backend)** | App-layer updates |
| Frontend data binding | **David (Frontend)** | If schema affects API response shape |
| Integration testing | **Elijah (QA)** | Post-migration smoke test |
| Infrastructure/downtime | **Noah (Infra)** | Maintenance window coordination |

---

## Anti-Patterns to Avoid

❌ **Never migrate without a backup** — even "small" migrations  
❌ **Never test only on production** — always staging first  
❌ **Never drop old columns immediately** — wait 1 full release cycle  
❌ **Never migrate during peak traffic** — schedule low-traffic windows  
❌ **Never skip row count validation** — silent data loss is the worst kind  
❌ **Never forget dependent services** — check all consumers of the schema  

---

## Templates Used

- [`PLAN.md`](../templates/PLAN.md) — Migration plan with rollback section
- [`RESEARCH.md`](../templates/RESEARCH.md) — Schema analysis output
- [`FORENSICS.md`](../templates/FORENSICS.md) — Post-incident if migration fails
- [`HANDOFF.json`](../templates/HANDOFF.json) — Session continuity for long migrations

---

*Part of GSD-OpenClaw recipe library — github.com/Chaturaphut/gsd-openclaw*
