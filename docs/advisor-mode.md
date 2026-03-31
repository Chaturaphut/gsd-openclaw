# Advisor Mode — Research-Backed Decision Making

> Cherry-picked from GSD v1.27.0 — Adapted for OpenClaw multi-agent workflows

## Overview

**Advisor Mode** is a pre-decision research workflow that spawns parallel agents to evaluate gray-area decisions before you commit. Instead of going with one agent's opinion, multiple specialists analyze the problem from different angles and present a synthesized recommendation.

Use it when: a decision has significant trade-offs, multiple valid approaches exist, or you want confidence before committing to an architecture or strategy.

---

## When to Use Advisor Mode

| Decision Type | Use Advisor? |
|--------------|-------------|
| Architecture choice (Monolith vs Microservices) | ✅ Yes |
| Tech stack selection | ✅ Yes |
| Security implementation approach | ✅ Yes |
| "Should we build or buy?" | ✅ Yes |
| Business strategy with unknowns | ✅ Yes |
| Simple feature implementation | ❌ No |
| Clear requirement, no ambiguity | ❌ No |

---

## OpenClaw Advisor Pattern

Instead of asking one agent, spawn **2-3 specialist agents** to evaluate the same question independently, then synthesize.

### Basic Pattern

```
MumuX receives ambiguous decision request
  ├─ spawn Advisor A: domain expert (e.g., Moses for backend)
  ├─ spawn Advisor B: risk perspective (e.g., Michael for security)
  └─ spawn Advisor C: strategic view (e.g., Daniel for strategy)
       └─ MumuX synthesizes → presents CEO with:
            - Option A: [recommendation + rationale]
            - Option B: [alternative + trade-offs]
            - Recommended: [which + why]
```

### Agent Selection by Decision Type

| Decision Domain | Advisor 1 | Advisor 2 | Advisor 3 |
|----------------|-----------|-----------|-----------|
| Backend architecture | Moses | Ephraim | Isaiah |
| Security implementation | Michael | Obadiah | Ezra |
| Frontend framework | David | Miriam | Elijah |
| Database choice | Levi | Moses | Noah |
| Cloud infrastructure | Noah | Ephraim | Gideon |
| Business strategy | Daniel | Joseph | Nehemiah |
| AI/ML approach | Isaiah | Moses | Beam |

---

## Spawn Template

```
spawn [AgentA]:
  task: |
    ADVISOR ROLE: Evaluate the following decision from a [domain] perspective.
    
    DECISION: [Clear statement of what needs to be decided]
    
    CONTEXT:
    - Current situation: [describe]
    - Constraints: [time/budget/team size/tech stack]
    - Success criteria: [what good looks like]
    
    YOUR JOB:
    1. Analyze the options below from your [domain] expertise
    2. Identify risks and benefits of each
    3. Give a clear recommendation with rationale
    4. Flag any unknowns that need more research
    
    OPTIONS TO EVALUATE:
    A. [Option A]
    B. [Option B]
    C. [Option C if applicable]
    
    OUTPUT FORMAT:
    ## My Assessment ([Your Domain])
    **Recommended:** Option [X]
    **Confidence:** High/Medium/Low
    
    ### Option A
    - Pros: ...
    - Cons: ...
    - Risk: ...
    
    ### Option B
    - Pros: ...
    - Cons: ...
    - Risk: ...
    
    ### Key Concerns from [Domain] Perspective
    [list]
    
    ### What Would Change My Recommendation
    [list of assumptions/unknowns]
```

---

## Synthesis Template (MumuX)

After receiving advisor outputs, synthesize into CEO-ready format:

```markdown
## Decision: [Title]
**Recommended:** Option [X]
**Consensus:** [Strong / Split / Contested]

### Advisor Votes
- [AgentA] ([Domain]): Option [X] — "[key reason]"
- [AgentB] ([Domain]): Option [X] — "[key reason]"
- [AgentC] ([Domain]): Option [Y] — "[dissenting reason if any]"

### Why Option [X]
[2-3 sentence synthesis of the strongest arguments]

### Risks to Watch
1. [Risk A] — mitigated by [action]
2. [Risk B] — monitor by [metric]

### If You Choose Option [Y] Instead
[What changes, what additional steps needed]

**Decision needed from CEO:** Approve Option [X] / Choose alternative
```

---

## Real Example: "Build vs Buy" Advisor Run

**Decision:** Should we build our own AI ticket triage system or use an off-the-shelf solution?

**Advisors spawned:**
1. **Moses** (Backend) → evaluates build complexity, maintenance burden, API integration options
2. **Joseph** (CFO) → evaluates cost: build cost vs SaaS pricing at scale, ROI timeline
3. **Isaiah** (AI/ML) → evaluates AI quality: can we match/beat SaaS accuracy with custom model?

**Synthesis by MumuX:**
- Moses: Build (API integration with WHMCS is non-trivial for off-shelf tools)
- Joseph: Build (SaaS at 26K customers = $X/mo vs one-time build cost amortized over 3y)
- Isaiah: Build (custom model trained on Ruk-Com tickets will outperform generic AI)

**Recommendation: Build** — Strong consensus, aligned with 2026 growth goals.

---

## Research Before Questions

GSD v1.27.0 introduced `research_before_questions` config — advisors run research first, then formulate questions. In OpenClaw terms: **spawn research agent first** before spawning advisors when domain knowledge is sparse.

```
1. spawn Isaiah: research current state of [topic] → RESEARCH.md
2. spawn advisors with RESEARCH.md as context
3. Synthesize
```

---

## Anti-Patterns

❌ **Ask one agent for all opinions** — Single perspective, blind spots unchecked  
❌ **Spawn advisors without clear decision criteria** — Vague outputs, can't synthesize  
❌ **Skip synthesis** — CEO overwhelmed with raw advisor outputs  
❌ **Use advisor mode for obvious decisions** — Wastes tokens and time  
❌ **Advisors see each other's outputs** — Anchoring bias, defeats the purpose  

---

## Quick Checklist

```
[ ] Decision is genuinely ambiguous (not obvious)
[ ] 2-3 advisors selected from relevant domains
[ ] Each advisor gets same context (isolated, no cross-contamination)
[ ] Each advisor gives: recommendation + confidence + key concerns
[ ] MumuX synthesizes: consensus + recommended + risks
[ ] CEO gets: recommendation + 1-2 alternatives + decision point
```

---

*Cherry-picked from GSD v1.27.0 — Advisor Mode feature*  
*Adapted for Ruk-Com OpenClaw multi-agent team by MumuX*
