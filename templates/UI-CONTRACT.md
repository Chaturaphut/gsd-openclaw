# UI Design Contract — Phase {PHASE_ID}

> **Source of Truth:** {PHASE_TITLE}
> **Generated:** {TIMESTAMP}

---

## 1. Design System & Tokens

### Colors (HEX/Tailwind)
- **Primary**: {PRIMARY_COLOR}
- **Secondary**: {SECONDARY_COLOR}
- **Background**: {BG_COLOR}
- **Text**: {TEXT_COLOR}

### Typography
- **Font Family**: {FONT_FAMILY}
- **Scale**: {TYPO_SCALE} (e.g., 16px/24px/32px)
- **Weights**: {FONT_WEIGHTS}

### Spacing & Layout
- **Grid**: {GRID_SYSTEM} (e.g., 12-column, 8px grid)
- **Padding/Margin Scale**: {SPACING_SCALE}

---

## 2. Component Inventory

| Component | Purpose | States | Requirements |
|-----------|---------|--------|--------------|
| {COMPONENT_1} | {PURPOSE} | Default, Loading, Error | {SPEC} |
| {COMPONENT_2} | {PURPOSE} | Default, Hover, Active | {SPEC} |

---

## 3. Responsive Targets

- **Mobile (390px)**: {MOBILE_LAYOUT_SPEC}
- **Tablet (768px)**: {TABLET_LAYOUT_SPEC}
- **Desktop (1440px)**: {DESKTOP_LAYOUT_SPEC}

---

## 4. Visual Interactions

- **Animations**: {ANIMATION_GUIDE}
- **Transitions**: {TRANSITION_SPEC} (e.g., 200ms ease-in-out)
- **Feedback Loops**: {FEEDBACK_SPEC} (e.g., toast, inline errors)

---

## 5. Accessibility (WCAG 2.1 AA)

- **Contrast**: All text must meet 4.5:1 ratio.
- **ARIA**: All interactive elements must have semantic roles.
- **Keyboard**: Full navigation support with visible focus rings.

---

## 6. Performance Perception

- **Loading**: Use {SKELETON_STYLE} for initial load.
- **Transition**: Use {STAGGERED_ENTRANCE} for list items.

---

## Approval Checkbox
- [ ] UI Designer generated and verified.
- [ ] Coordinator confirmed technical feasibility.
- [ ] User (optional) reviewed visual direction.
