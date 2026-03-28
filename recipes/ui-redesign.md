# 🎨 UI Redesign & Brand Alignment Recipe

> **Category:** Frontend / Design
> **Complexity:** High (Full GSD Workflow)
> **Goal:** Complete visual overhaul of an existing module or application.

---

## 🏗️ Phase 1: Context & Audit

### 1. Stage 0: Map Current UI
- Audit current components, colors, and layouts.
- Identify "hardcoded" styles vs. design system variables.
- Document broken responsive states or accessibility gaps.

### 2. Stage 1: Define Vision
- Create `PROJECT.md` with the new design direction.
- Define Success Criteria: "Must pass WCAG 2.1 AA", "Lighthouse accessibility score >90".

---

## 📐 Phase 2: Design Contract (UI-Phase)

### 1. Stage 2: Research Design Trends
- Spawn researchers to find modern UI patterns for the specific niche.
- Research Tailwind/CSS component libraries that fit the vision.

### 2. Stage 3: Create UI-CONTRACT.md
- Use the `templates/UI-CONTRACT.md`.
- Define the new Palette, Typography, and Spacing.
- **Critical:** Define the "Before/After" visual delta.

---

## ⚡ Phase 3: Implementation (Execute Waves)

### Wave 1: Tokens & Foundations
- Update `tailwind.config.js` or CSS variables.
- Refactor base components (Buttons, Inputs, Typography).

### Wave 2: Structural Layout
- Update main layouts, headers, and navigation.
- Ensure the "Skeleton" of the new design is responsive.

### Wave 3: Content & Polish
- Update individual pages and data-heavy components.
- Add transitions, animations, and hover effects.

---

## 🧪 Phase 4: Visual Audit (UI-Review)

### 1. Stage 5: 6-Pillar Audit
- Run `/gsd:ui-review`.
- **Visual Accuracy:** Compare implementation against HEX codes in contract.
- **Responsive Fidelity:** Check on 390px, 768px, and 1440px.
- **Interactive Polish:** Verify all new animations are smooth.

### 2. Stage 6: QA Regression
- Ensure that the visual redesign didn't break functional logic (e.g., button still submits form).

---

## ✅ Final Delivery

- **SUMMARY.md:** List all visual changes and new components.
- **HANDOFF.json:** Ready for next feature development on the new UI.
