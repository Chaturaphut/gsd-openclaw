# GSD Workflow — Spec-Driven Development for Ruk-Com Virtual Team
# Adapted from Get-Shit-Done (github.com/gsd-build/get-shit-done)
# CEO Order: 2026-03-22 | Applies to ALL projects, ALL agents
# Updated: 2026-03-29 — GSD SDK & UI-Phase formalization (GSD v1.30)

> **หลักการ:** ทุกงาน Dev ต้องผ่าน Spec → Research → Plan → Execute → Verify
> ไม่มี "ลุยเลย" อีกต่อไป — ยกเว้น hotfix/bug fix เล็กน้อย

---

## 🎯 Why This Exists

**ปัญหาที่เราเจอ:**
- Dev spawn แล้วลุยเลยโดยไม่มี spec ชัด → field name mismatch, logic ไม่ตรง
- QA loop 3-5 รอบเพราะ Dev ไม่เข้าใจ requirement ชัด
- Frontend/Backend ไม่ sync กัน → API schema ไม่ตรง UI
- Context rot ใน session ยาว → output คุณภาพตก

**สิ่งที่ GSD Workflow แก้:**
- Structured planning ก่อนเขียนโค้ดแม้แต่บรรทัดเดียว
- Research ก่อน plan เพื่อหา pitfalls ล่วงหน้า
- Plan verification ก่อน execute เพื่อจับ gap
- Fresh context per agent (เราทำอยู่แล้ว) + structured handoff
- Wave-based parallel execution with dependency tracking

---

## 📋 Document System

ทุก project ที่ใช้ GSD Workflow ต้องมีไฟล์เหล่านี้:

### Required Documents
| File | Purpose | Who Creates | When |
|------|---------|-------------|------|
| `PROJECT.md` | Vision, scope, tech stack, constraints | MumuX + CEO | Project kickoff |
| `REQUIREMENTS.md` | v1/v2/out-of-scope requirements | MumuX | After CEO brief |
| `ROADMAP.md` | Phases mapped to requirements | MumuX | After requirements |
| `STATE.md` | Current state, blockers, decisions | MumuX (auto-update) | Every session |

### Per-Phase Documents
| File | Purpose | Who Creates | When |
|------|---------|-------------|------|
| `{phase}-CONTEXT.md` | Implementation decisions, preferences | MumuX + CEO | Before planning |
| `{phase}-RESEARCH.md` | Technical research, pitfalls, options | Researcher agents | During plan-phase |
| `{phase}-PLAN.md` | Atomic task plans with verification | Planner agent | After research |
| `{phase}-UI-SPEC.md` | Design contract (frontend only) | Kwhan/UX team | Before plan (UI phases) |
| `{phase}-SUMMARY.md` | What was built, what changed | Dev agent | After execute |
| `{phase}-QA.md` | QA report (existing format) | Meekun/QA team | After execute |

### Storage Location
```
{project-root}/.planning/
├── PROJECT.md
├── REQUIREMENTS.md
├── ROADMAP.md
├── STATE.md
├── config.json          # workflow settings
├── phases/
│   ├── phase-1-{name}/
│   │   ├── CONTEXT.md
│   │   ├── RESEARCH.md
│   │   ├── PLAN-01.md
│   │   ├── PLAN-02.md
│   │   ├── UI-SPEC.md
│   │   ├── SUMMARY.md
│   │   └── QA.md
│   └── phase-2-{name}/
│       └── ...
├── research/            # domain research cache
├── quick/               # ad-hoc tasks
└── threads/             # cross-session context threads
```

---

## 🔄 Workflow Stages

### Stage 0: Map Codebase (Brownfield projects only)
**เมื่อไหร่:** เมื่อเพิ่ม feature ใน project ที่มีอยู่แล้ว
**ใครทำ:** Son (SA) + Dev Lead ที่เกี่ยวข้อง
**Output:**
- `codebase/STACK.md` — Tech stack, versions, frameworks
- `codebase/ARCHITECTURE.md` — Project structure, patterns, data flow
- `codebase/CONVENTIONS.md` — Naming, formatting, error handling patterns
- `codebase/CONCERNS.md` — Known tech debt, fragile areas, performance issues

### Stage 1: Define Requirements
**เมื่อไหร่:** CEO สั่งงานใหม่ / feature request
**ใครทำ:** MumuX (ถามชี้แจง CEO ถ้าจำเป็น)
**Checklist:**
- [ ] Goals: เป้าหมายชัดเจน (WHAT, not HOW)
- [ ] Scope: v1 (must), v2 (nice-to-have), out-of-scope
- [ ] Constraints: tech stack, timeline, dependencies
- [ ] Success criteria: วัดผลได้

### Stage 2: Research (Parallel)
**เมื่อไหร่:** ก่อน planning ทุกครั้ง (ยกเว้น hotfix)
**ใครทำ:** Spawn 2-4 researcher agents ขนานกัน:
1. **Stack Researcher** — library options, version compatibility
2. **Architecture Researcher** — design patterns, data flow
3. **Pitfalls Researcher** — common mistakes, edge cases, security concerns
4. **Domain Researcher** — business logic, industry standards (ถ้าจำเป็น)

**Output:** `{phase}-RESEARCH.md` — รวม findings + recommendations
**Size Limit:** ≤3,000 words (กระชับ เน้น actionable insights)

### Stage 3: Plan
**เมื่อไหร่:** หลัง research เสร็จ
**ใครทำ:** MumuX (plan) → Son/SA (verify plan)
**Format:** Structured task plan (XML-inspired)

```markdown
## Task 1: [name]
- **Files:** [list of files to create/modify]
- **Dependencies:** [other tasks that must complete first]
- **Wave:** [1/2/3 — parallel grouping]
- **Action:**
  - Step-by-step implementation instructions
  - Specific function names, API schemas, data types
  - Error handling requirements
- **Verify:** [how to test this task is done correctly]
- **Done When:** [acceptance criteria]
```

**Plan Verification Checklist (ก่อน execute):**
- [ ] ทุก requirement มี task ครอบคลุม
- [ ] ไม่มี task ที่ scope เกิน v1
- [ ] API schema ตรงกันระหว่าง frontend/backend tasks
- [ ] Dependencies ถูกต้อง (no circular, no missing)
- [ ] Verification steps ชัดเจน + testable
- [ ] File paths ถูกต้องตาม project structure
- [ ] ไม่มี field name mismatch (!!!)

### Stage 4: Execute (Wave-based)
**เมื่อไหร่:** หลัง plan verified
**ใครทำ:** Dev agents (ตาม pool assignments)

**Wave Execution Rules:**
```
Wave 1: Independent tasks → spawn parallel
         Task A (Backend API)  |  Task B (DB Schema)
                    ↓                     ↓
Wave 2: Depends on Wave 1 → spawn after Wave 1 done
         Task C (Frontend UI — needs API from A)
                    ↓
Wave 3: Integration
         Task D (Wire up + test)
```

**Per-Task Agent Instructions MUST include:**
1. The task plan (copy from PLAN.md)
2. PROJECT.md context (abbreviated)
3. Relevant RESEARCH.md findings
4. API schema / data contracts (ถ้ามี)
5. Verification steps

**After each task:** Agent writes `{phase}-SUMMARY.md` entry

### Stage 5: QA & Verify
**เมื่อไหร่:** หลัง execute ทุก task เสร็จ
**ใครทำ:** QA Pool (Meekun/Gam/Aom/Bew) — ตาม QA Loop rule เดิม

**เพิ่มเติมจาก GSD:**
- Verify against PLAN.md done criteria (ไม่ใช่แค่ "ดูเหมือนทำงาน")
- เทียบ UI vs API schema จาก plan
- ตรวจทุก edge case ที่ระบุไว้ใน RESEARCH.md

---

## ⚡ Quick Mode (งานเล็ก)

**เมื่อไหร่:** Bug fix, config change, small refactor, hotfix
**ข้ามได้:** Research, Plan Verification, UI-SPEC
**ยังต้องทำ:** Plan (brief), Execute, QA

```markdown
## Quick Task: [description]
- **Files:** [list]
- **Action:** [what to do]
- **Verify:** [how to test]
- **Done When:** [criteria]
```

**Threshold:** ถ้างาน touch ≤3 files + ไม่มี new API = Quick Mode ได้
**ถ้า touch >3 files หรือมี new API = Full GSD Workflow**

---

## 📊 Context Size Limits

เพื่อป้องกัน context rot:

| Document | Max Size | Notes |
|----------|----------|-------|
| PROJECT.md | 2,000 words | Vision only, no implementation details |
| REQUIREMENTS.md | 3,000 words | Concise, bullet points |
| RESEARCH.md | 3,000 words | Actionable findings only |
| PLAN.md (per plan) | 2,000 words | One plan per task group |
| Agent instruction | 4,000 words | Plan + context combined |
| SUMMARY.md | 1,000 words | What changed, not why |

---

## 🔗 Integration with Existing Rules

GSD Workflow **เพิ่มเติม** จากกฎเดิม ไม่แทนที่:
- ✅ Git Branch Flow → ยังใช้เหมือนเดิม (branch per MR)
- ✅ QA Loop → ยังบังคับเหมือนเดิม (Dev → QA → loop)
- ✅ Docker Deploy → ยังใช้ docker compose เท่านั้น
- ✅ Permission Registration → ยังต้องเพิ่ม permission ทุก endpoint
- ✅ 3-System Sync → ยังต้อง sync ทั้ง 3 (AI Ticket)
- ✅ Model Footer → ยังใส่ท้ายทุกข้อความ

**เพิ่มเติม:**
- 🆕 ก่อน spawn Dev → ต้องมี PLAN.md ที่ verify แล้ว
- 🆕 Plan ต้องระบุ API schema + field names ชัดเจน
- 🆕 Wave execution tracking ใน STATE.md
- 🆕 Research phase ก่อน plan (งานใหญ่)

---

## 📌 Agent Responsibilities

### MumuX (Coordinator)
- สร้าง PROJECT.md, REQUIREMENTS.md, ROADMAP.md
- สร้าง PLAN.md + verify plan ก่อน spawn Dev
- Track STATE.md ทุก session
- Wave orchestration (spawn parallel ถูกจังหวะ)

### Son (Solution Architect)
- Review plan ก่อน execute (plan verification)
- ตรวจ API schema consistency
- ตรวจ architecture fit

### Dev Pool (Mai/Tae/Pond/Film/etc.)
- Execute ตาม PLAN.md เท่านั้น — ห้ามเพิ่ม/ลด scope เอง
- เขียน SUMMARY.md หลัง execute
- ถ้าพบปัญหาที่ plan ไม่ได้ cover → report กลับ MumuX (ห้ามแก้ spec เอง)

### QA Pool (Meekun/Gam/Aom/Bew)
- Verify against PLAN.md done criteria
- เทียบ field names/API schema ตาม plan
- ตรวจ edge cases จาก RESEARCH.md

### UX Pool (Kwhan/Pai/Jeed/etc.)
- สร้าง UI-SPEC.md สำหรับ frontend phases
- Review UI implementation vs spec

---

## 🚨 When to Use Full vs Quick

| Scenario | Mode | Reason |
|----------|------|--------|
| New feature (>3 files) | **Full GSD** | Need spec + research |
| New API endpoints | **Full GSD** | Need schema contract |
| Bug fix (≤3 files) | **Quick** | Known scope |
| Config change | **Quick** | Trivial |
| Hotfix production | **Quick** | Speed priority |
| UI redesign | **Full GSD** + UI-SPEC | Need design contract |
| New module/section | **Full GSD** | Need architecture research |
| Integration with external service | **Full GSD** | Need pitfall research |

---

## ✅ Definition of Done (Phase)

- [ ] ทุก task ใน PLAN.md execute แล้ว
- [ ] SUMMARY.md เขียนแล้ว
- [ ] Git: branch created, committed, MR merged
- [ ] QA: pass ทุก verification criteria
- [ ] STATE.md updated
- [ ] No console errors
- [ ] Responsive test pass (ถ้ามี UI)

---

---

## 🆕 Cherry-picked from GSD v1.26–v1.29 (Added 2026-03-26)

### 📦 Session Handoff (from v1.26)
**ปัญหา:** Agent session ยาว → context rot, คนรับงานต่อไม่รู้ว่าทำถึงไหน
**วิธีใช้:** ทุก phase ที่เสร็จ ให้ Dev agent สร้าง `HANDOFF.json` ใน `.planning/phases/{phase}/`

```json
{
  "phase": "phase-1-api-setup",
  "status": "complete",
  "completedTasks": ["task-1", "task-2"],
  "pendingTasks": [],
  "decisions": [
    {"id": "D001", "summary": "ใช้ Redis สำหรับ session", "reason": "performance"}
  ],
  "blockers": [],
  "nextSteps": ["Start phase-2 frontend"],
  "modifiedFiles": ["src/api/routes.ts", "src/services/auth.ts"],
  "timestamp": "2026-03-26T01:00:00Z"
}
```

**กฎ:**
- Agent ที่รับงานต่อ ต้องอ่าน HANDOFF.json ก่อนเริ่มทำ
- MumuX ใส่ HANDOFF.json ใน agent instruction เมื่อ spawn agent ต่อ

### 🧪 Cross-Phase Regression Gate (from v1.26)
**ปัญหา:** แก้ Phase 2 แล้ว Phase 1 พัง
**กฎ:**
- หลัง execute phase ใหม่ → QA ต้องรัน test ของ phase ก่อนหน้าด้วย
- ถ้า regression พบ → ถือว่า QA ไม่ผ่าน ต้องแก้ก่อน
- เพิ่มใน QA Report section: `🔄 Regression: [PASS/FAIL] — tested phase 1-N test suites`

### ✅ Requirements Coverage Gate (from v1.26)
**ปัญหา:** Plan ไม่ครอบคลุมทุก requirement → ทำเสร็จแล้วขาดอยู่ดี
**กฎ:**
- ก่อน approve PLAN.md → ตรวจว่าทุกข้อใน REQUIREMENTS.md มี task ครอบคลุม
- ถ้า requirement ไหนไม่มี task → ห้าม execute จนกว่าจะเพิ่ม
- Checklist ใน plan: `[ ] Requirement coverage: X/Y requirements mapped to tasks`

### 🔍 Stub Detection (from v1.27)
**ปัญหา:** Dev สร้าง function เปล่า / TODO / placeholder แล้วบอก "เสร็จแล้ว"
**กฎ:**
- QA ต้อง grep หา stubs ก่อนรับงาน:
  ```bash
  grep -rn "TODO\|FIXME\|HACK\|PLACEHOLDER\|throw new Error('Not implemented')\|// stub\|pass  #" src/
  ```
- พบ stub ใน production code = **BUG** → ส่งกลับ Dev แก้
- ยกเว้น: test files, comments ที่เป็น future enhancement (ต้อง tag `// FUTURE:`)

### ⚡ Fast Mode (from v1.27)
**เพิ่มจาก Quick Mode ที่มีอยู่:**
- **Fast Mode:** งานเล็กมาก (1 file, ≤20 lines change) → ทำเลย ไม่ต้อง plan
- **Quick Mode:** ≤3 files, ไม่มี new API → plan สั้น + execute + QA
- **Full GSD:** >3 files หรือมี new API → full workflow

| Mode | Plan | Research | QA | เมื่อไหร่ |
|------|------|----------|----|----------|
| Fast | ❌ | ❌ | Spot check | 1 file, ≤20 lines |
| Quick | Brief | ❌ | Full QA | ≤3 files, no new API |
| Full GSD | Full | ✅ | Full QA | >3 files หรือ new API |

### 🧠 Advisor Mode (from v1.27)
**ปัญหา:** งานซับซ้อนที่มีหลายทางเลือก และต้องการการวิเคราะห์เปรียบเทียบก่อนตัดสินใจ
**วิธีใช้:** เมื่อ MumuX หรือ Son (SA) ต้องการความเห็นที่หลากหลาย:
- Spawn 2-3 advisor agents ขนานกันเพื่อวิเคราะห์ gray areas
- แต่ละ agent ให้เหตุผล ข้อดี/ข้อเสีย และ recommendation
- สรุปผลลัพธ์ใน `ADVISORY-LOG.md` ก่อนเลือกแนวทางใน PLAN.md

### 📦 Milestone Summary (from v1.28)
**ปัญหา:** เมื่อจบ Milestone ใหญ่ สมาชิกทีมที่มาใหม่หรือ CEO ตามไม่ทันว่า "เรามีอะไรใหม่บ้าง"
**วิธีใช้:** เมื่อจบทุก milestone ให้สร้าง `MILESTONE-SUMMARY.md`:
- สรุป features ที่สร้างเสร็จ
- รายการ API endpoints ใหม่
- Breaking changes (ถ้ามี)
- แผนงานสำหรับ milestone ถัดไป

### 🚥 Decision Waiting Signal (from v1.26)
**ปัญหา:** Agent ติดขัด (blocker) แล้วหยุดทำงานโดยไม่บอกชัดเจนว่ารออะไร
**วิธีใช้:** เมื่อ agent ต้องการการตัดสินใจจากคน (CEO/Manager) ให้สร้าง `.planning/WAITING.json`
```json
{
  "reason": "API selection",
  "options": ["Option A (Fast)", "Option B (Scalable)"],
  "blocked_tasks": ["task-3", "task-4"],
  "timestamp": "2026-03-27T03:00:00Z"
}
```

### 🌱 Plant Seed / Persistent Threads (from v1.27)
**ปัญหา:** ไอเดียดีๆ ที่ยังไม่อยู่ใน roadmap มักจะหายไปเมื่อจบ session
**วิธีใช้:** ใช้ `.planning/seeds/` เพื่อเก็บไอเดียหรือ context threads ที่ต้องการให้ agent ในอนาคตเห็น
- `SEED-XXX.md` — บันทึกไอเดีย, context เฉพาะทาง, หรือแนวทางการแก้ปัญหาที่อาจใช้ภายหลัง

### 🔀 Workstream Namespacing (from v1.28)
**ปัญหา:** ทำ 2 milestones พร้อมกัน → .planning/ ชนกัน
**วิธีใช้:**
- ถ้ามีหลาย milestone/feature ทำขนาน → แยก workstream:
  ```
  .planning/
  ├── workstreams/
  │   ├── ws-api-refactor/
  │   │   ├── PLAN-01.md
  │   │   └── STATE.md
  │   └── ws-new-dashboard/
  │       ├── PLAN-01.md
  │       └── STATE.md
  ```
- แต่ละ workstream มี STATE.md แยก ไม่กวนกัน
- MumuX track progress แต่ละ workstream ใน root STATE.md

### 🔬 Forensics / Post-mortem (from v1.28)
**เมื่อไหร่:** workflow ไปไม่ถูกทาง, agent loop ไม่จบ, output ไม่ตรง spec
**ใครทำ:** MumuX หรือ Son (SA)
**Checklist:**
- [ ] Plan vs actual output — อะไรไม่ตรง?
- [ ] Agent instruction — ขาดอะไรไป?
- [ ] Dependency chain — มี circular/missing dep ไหม?
- [ ] Context size — agent ได้ context เกิน limit ไหม?
- [ ] Root cause → บันทึกใน `{phase}-FORENSICS.md`
- [ ] Prevention → อัปเดต workflow/template ป้องกันซ้ำ

### 📦 Agent Skill Injection (from v1.29)
**ปัญหา:** Sub-agents ไม่มี skill เฉพาะทางที่จำเป็นสำหรับ project
**วิธีใช้:** เพิ่ม section `agent_skills` ใน config หรือ project context เพื่อฉีด skill (เช่น .md files หรือ CLI tools) เข้าไปใน sub-agent ตอน spawn
**กฎ:**
- ทุก project ควรมี skill directory สำหรับ task เฉพาะทาง (เช่น `/skills/custom-api-tester.md`)
- MumuX ต้องระบุ skill ที่จำเป็นใน instruction ของ sub-agent

### 🎨 UI-Phase and UI-Review Steps (from v1.29)
**ปัญหา:** งาน UI มักจะหลุด spec หรือมี visual bugs เยอะ
**วิธีใช้:** เพิ่ม stage **UI-Phase** และ **UI-Review** ใน workflow:
- **UI-Phase:** เน้นการสร้าง UI ตาม UI-SPEC.md (CSS, Layout, Responsive)
- **UI-Review:** การทำ visual audit ตาม 6-pillar (Visual, Interaction, Responsive, Performance, Accessibility, Security)
**กฎ:** งาน frontend ทุกงานต้องผ่าน UI-Review ก่อนส่งให้ QA

### 🔒 Security Scanning CI (from v1.29)
**ปัญหา:** AI code อาจมี prompt injection, hardcoded secrets หรือ base64 data ที่แอบแฝง
**วิธีใช้:** รวม security scan เข้ากับ workflow:
- **Execute-phase:** รัน automated secret scanning และ static analysis
- **QA-phase:** ตรวจหา prompt injection patterns และ suspicious base64 payloads
**กฎ:** ห้าม merge code ที่ไม่ผ่าน security scan ขั้นพื้นฐาน

### 🌊 Windsurf Runtime Support (from v1.29)
**ปัญหา:** การสลับไปมาสระหว่าง workflow ต่างๆ ใน Windsurf (Codeium) อาจทำให้สับสน
**วิธีใช้:** GSD รองรับ Windsurf เต็มรูปแบบ:
- ติดตั้งผ่าน `--windsurf` flag
- แมพคำสั่ง `/gsd:plan` และ `/gsd:execute` เข้ากับ native edit tools ของ Windsurf
- ป้องกันการทำงานทับซ้อน (file locking) เมื่อรันหลายเครื่องมือขนานกัน

### 🤖 GSD SDK — Headless Execution (from v1.30)
**ปัญหา:** บางงานต้องการความรวดเร็วโดยไม่ต้องโต้ตอบกับ UI หรือต้องการทำแบบ batch
**วิธีใช้:** ใช้ GSD SDK (TypeScript) ในการสร้าง automation:
- รัน workflow ตั้งแต่ต้นจนจบโดยใช้ SDK blueprints
- กำหนด safety rails และ verification gates ในโค้ด
- รองรับการทำ batch task execution ข้ามหลาย project

---

## 🔄 GSD Upstream Tracking

**ต้นฉบับ:** github.com/gsd-build/get-shit-done
**Last checked:** 2026-03-29 | **Upstream version:** v1.30.0 (GSD SDK)
**Cron:** Zen (Agent #60) เช็คทุกสัปดาห์ รายงาน CEO ถ้ามี feature ใหม่ที่น่าใช้

---

*Effective: 2026-03-22 | Version: 1.8 (updated 2026-03-29)*
*Adapted from GSD (Get Shit Done) by TÂCHES — adjusted for OpenClaw multi-agent architecture*
