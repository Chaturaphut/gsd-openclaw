# Dependency Graph Template

Visualize task dependencies and critical path.

```mermaid
flowchart TD
    subgraph Requirements
        R1[REQ-1: User Auth]
        R2[REQ-2: Dashboard]
        R3[REQ-3: API]
    end

    subgraph Tasks
        T1[Task 1: DB Schema]
        T2[Task 2: Auth API]
        T3[Task 3: Dashboard API]
        T4[Task 4: Auth UI]
        T5[Task 5: Dashboard UI]
        T6[Task 6: E2E Tests]
    end

    R1 --> T1
    R1 --> T2
    R2 --> T3
    R2 --> T5
    R3 --> T2
    R3 --> T3

    T1 --> T2
    T1 --> T3
    T2 --> T4
    T3 --> T5
    T4 --> T6
    T5 --> T6

    %% Critical path highlighting
    linkStyle 3,6,7,9,10 stroke:#f00,stroke-width:2px

    style T6 fill:#4CAF50,color:#fff
    style R1 fill:#E3F2FD,stroke:#1565C0
    style R2 fill:#E3F2FD,stroke:#1565C0
    style R3 fill:#E3F2FD,stroke:#1565C0
```

## Reading the Graph

- **Red lines** = Critical path (longest dependency chain)
- **Blue boxes** = Requirements (source)
- **Green box** = Final integration task
- Each arrow means "must complete before"
