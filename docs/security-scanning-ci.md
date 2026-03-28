# 🔒 Security Scanning & CI Hardening

> **Adapted from:** GSD v1.29 Security Scanning CI
> **Purpose:** Automate security audits within the workflow to catch vulnerabilities early.

---

## Overview

Modern agent workflows introduce new security risks:
- **Prompt Injection**: Malicious input subverting agent logic.
- **Base64 Encoding**: Hiding malicious code/secrets.
- **Secret Leaks**: Accidental commit of API keys/tokens.
- **Path Traversal**: Manipulating file system tools to access sensitive files.

GSD-OpenClaw introduces integrated security scanning as a standard phase gate.

---

## Security Scanning Features

### 1. Prompt Injection Guards

Subagents are now equipped with pre-processing layers to detect:
- **Direct Injection**: Commands that try to ignore previous instructions.
- **Indirect Injection**: Malicious instructions hidden in untrusted content (e.g., fetched web pages).
- **Control Hijacking**: Attempts to gain elevated permissions or bypass tool filters.

### 2. Base64 & Obfuscation Detection

The executor and verifier tools now scan for:
- Large Base64 blobs in code/config.
- Obfuscated shell commands.
- Encoded payloads that might contain malicious scripts.

### 3. Secret & Credential Scanning

Integrated into the `verify-work` phase and CI workflows:
- Scans all modified files for patterns of:
  - AWS/GCP/Azure keys.
  - GitHub/GitLab PATs.
  - Database connection strings.
  - JWT/Auth tokens.
- **Blocking Gate**: If a secret is detected, the `verify-work` stage fails, and the agent is instructed to scrub the secret from history before proceeding.

### 4. Path Traversal Prevention

Tool-level validation for all file system operations:
- Prevents reading/writing outside the project root.
- Blocks access to sensitive system paths (e.g., `/etc/`, `~/.ssh/`).
- Sanitizes filenames and paths to prevent `../` attacks.

---

## Integration into CI

GSD-OpenClaw provides CI templates (`ci-templates/`) with built-in security scans:

### GitHub Actions (`github-actions.yml`)
- Runs `gsd:security-scan` on every PR.
- Uses Trufflehog/Gitleaks for deep secret scanning.
- Performs static analysis (SAST) on the code changes.

### GitLab CI (`gitlab-ci.yml`)
- Integrates with GitLab's Security Dashboard.
- Runs secret detection and container scanning (if applicable).
- Executes agent-driven security audits.

---

## Usage

### Manual Scan

Run a security audit on the current branch/phase:

```bash
/gsd:security-scan --analyze
```

### Automated Gate

In `workflow-settings.md`, ensure the security gate is enabled:

```json
{
  "security": {
    "scanOnVerify": true,
    "blockOnSecrets": true,
    "blockOnInjection": true
  }
}
```

---

## Best Practices

- **Never ignore a security warning**: If a scan fails, address the root cause.
- **Use .gsdignore**: For legitimate secrets/blobs, use a `.gsdignore` file to exclude them from scanning.
- **Rotate leaked secrets immediately**: If a secret was committed, consider it compromised, even if the agent "scrubbed" it.

---

## Related
- [Credential Security](credential-security.md) — How we handle secrets.
- [Execution Hardening](execution-hardening.md) — General reliability patterns.
- [Permission Registration](permission-registration.md) — How we manage tool access.
