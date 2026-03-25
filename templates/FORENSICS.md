# FORENSICS.md Template

## Post-Mortem: [Phase/Incident Name]
**Investigator:** [Name] | **Date:** [Date]

---

### What Happened
[Brief description of what went wrong]

### Expected vs Actual
| Aspect | Expected | Actual |
|--------|----------|--------|
| [Output quality] | [What should have happened] | [What actually happened] |
| [Timeline] | [Expected duration] | [Actual duration] |

### Investigation Checklist
- [ ] **Plan vs Output** — What didn't match?
- [ ] **Agent Instruction** — Was anything missing or ambiguous?
- [ ] **Dependency Chain** — Circular or missing dependencies?
- [ ] **Context Size** — Did the agent exceed context limits?
- [ ] **Research Gaps** — Were pitfalls missed in research phase?
- [ ] **Communication** — Was the handoff clean?

### Root Cause
[Clear description of why this happened]

### Impact
- [What was affected]
- [Time lost]
- [Quality impact]

### Prevention
| Action | Owner | Status |
|--------|-------|--------|
| [Update template/workflow] | [Who] | [ ] TODO |
| [Add verification step] | [Who] | [ ] TODO |

### Lessons Learned
1. [Key takeaway 1]
2. [Key takeaway 2]
