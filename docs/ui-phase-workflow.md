# 🎨 UI Phase & Visual Audit Workflow

> **Adapted from:** GSD v1.23+ and v1.29 UI Workflow
> **Purpose:** Formalize UI design contracts and automate visual quality audits for frontend-heavy phases.

---

## Overview

The UI Phase workflow addresses the common "UI Drift" problem where agents implement functional logic but neglect visual precision, responsive layouts, or brand consistency. It introduces two dedicated checkpoints:

1. **UI Phase (`/gsd:ui-phase`)**: Before code is written, a UI Designer agent generates a **UI Design Contract** (UI-CONTRACT.md).
2. **UI Review (`/gsd:ui-review`)**: After execution, a Visual Auditor agent performs a **6-Pillar Visual Audit** against the contract.

---

## The UI Phase

When a phase is marked as `type: ui` in the PLAN.md, the coordinator spawns a UI Specialist.

### UI Design Contract (UI-CONTRACT.md)

This document defines the "source of truth" for the UI:
- **Design System**: Colors (HEX), Typography (Scale), Spacing (Tailwind/CSS vars).
- **Components**: Required UI elements and their states (Loading, Empty, Error).
- **Responsive Targets**: Mobile (390px), Tablet (768px), Desktop (1440px).
- **Interactions**: Animation guidelines, transitions, and hover states.
- **Accessibility**: ARIA labels, contrast ratios (WCAG 2.1 AA), keyboard nav.

---

## The UI Review (6-Pillar Visual Audit)

The UI Review uses the following six pillars to evaluate the implementation:

1. **Visual Accuracy**: Does it match the colors, fonts, and spacing in the contract?
2. **Responsive Fidelity**: Does the layout hold up across all target resolutions?
3. **Interactive Polish**: Are hover states, transitions, and feedback loops implemented?
4. **Empty/Error States**: Are the "unhappy paths" visually addressed?
5. **Accessibility Compliance**: Are landmarks, labels, and focus rings correct?
6. **Performance Perception**: Are skeletons/spinners used correctly for perceived speed?

---

## Usage in GSD-OpenClaw

### 1. Planning Stage

Add `type: ui` to your phase in `PLAN.md`:

```markdown
### Phase 2: Landing Page Implementation (type: ui)
- [ ] Implement hero section
- [ ] Add feature grid
- [ ] Mobile responsive optimization
```

### 2. Design Stage

The coordinator will generate `UI-CONTRACT.md` before starting the execution.

### 3. Review Stage

After `verify-work` passes functional tests, run the visual audit:

```bash
/gsd:ui-review
```

Or in autonomous mode, the coordinator will automatically spawn a `visual-auditor` agent if the phase was marked as `ui`.

---

## Best Practices

- **Don't skip the contract**: Without a contract, the auditor has no baseline.
- **Provide screenshots/snapshots**: If the runtime supports it (like Browser tool), provide visual proof to the auditor.
- **Iterate**: If UI Review fails, treat it like a test failure. Fix and re-audit.

---

## Related
- [QA Standards](qa-standards.md) — How UI Review fits into overall quality.
- [Responsive Testing](../AGENTS.md#responsive-testing) — CEO Order 2026-03-14.
- [Execution Hardening](execution-hardening.md) — General reliability patterns.
