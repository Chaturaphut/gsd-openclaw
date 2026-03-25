# 🔑 Credential Security for AI Agent Teams

> **Rule:** AI agents MUST NEVER hardcode credentials in source code. Period.

When multiple AI agents work on your codebase, credential leaks become exponentially more likely. Each agent session is a potential leak vector. This guide establishes the patterns that keep your secrets safe.

---

## The Problem

AI agents are incredibly capable coders — but they have blind spots:

- 🤖 **Agents copy-paste patterns** — If they see a credential in context, they'll use it inline
- 🔄 **Context carries secrets** — A database password in a plan document might end up in generated code
- 📋 **Agents complete patterns** — Given a partial config, agents will "helpfully" fill in real values
- 🚀 **Fast = careless** — In rapid iteration, git diff review gets skipped

## Prevention Framework

### 1. Pre-Commit Credential Scan

Every agent MUST run a credential check before committing:

```bash
# Scan staged changes for potential secrets
git diff --cached | grep -iE \
  '(password|secret|token|api_key|apikey|private_key|credential)' \
  | grep -v '(example|placeholder|YOUR_|xxx|config\.)' \
  && echo "⚠️ POTENTIAL CREDENTIAL LEAK — Review before committing!" \
  || echo "✅ No credentials detected in staged changes"
```

### 2. Git-Leaks Integration

Install and configure [gitleaks](https://github.com/gitleaks/gitleaks) for automated scanning:

```bash
# Install gitleaks
brew install gitleaks  # macOS
# or
wget https://github.com/gitleaks/gitleaks/releases/latest/download/gitleaks-linux-amd64 -O /usr/local/bin/gitleaks

# Scan before push
gitleaks detect --source . --verbose

# Add as pre-commit hook
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
gitleaks protect --staged --verbose
if [ $? -ne 0 ]; then
    echo "❌ Credential leak detected! Fix before committing."
    exit 1
fi
EOF
chmod +x .git/hooks/pre-commit
```

### 3. `.gitignore` Patterns (Mandatory)

```gitignore
# Credentials & tokens
*.env
.env.*
*-tokens.json
*-credentials.json
config/secrets/
*.pem
*.key
*.p12

# Config with secrets
config/*.json
!config/*.example.json

# IDE & OS
.vscode/
.idea/
.DS_Store
```

### 4. Config File Pattern

**Never this:**
```typescript
// ❌ NEVER — credential in source code
const dbPassword = "super_secret_password_123";
const apiKey = "sk-abc123def456";
```

**Always this:**
```typescript
// ✅ CORRECT — read from config file
import config from '../config/database.json';
const dbPassword = config.password;

// ✅ CORRECT — read from environment
const apiKey = process.env.API_KEY;
```

### 5. Example Config Pattern

Provide example configs that agents can reference without real values:

```json
// config/database.example.json
{
  "host": "localhost",
  "port": 5432,
  "database": "myapp",
  "username": "YOUR_DB_USERNAME",
  "password": "YOUR_DB_PASSWORD"
}
```

### 6. Agent Instruction Template

When spawning dev agents, include this in their instructions:

```markdown
## Security Rules
- ❌ NEVER hardcode credentials, tokens, passwords, or API keys in source code
- ✅ Read credentials from config files or environment variables
- ✅ Run `git diff --cached` before every commit to verify no secrets
- ✅ Use `.example.json` pattern for config templates
- ⚠️ If you find existing hardcoded credentials, refactor them immediately
```

---

## MR Checklist (Pre-Merge)

Before any merge request is approved:

- [ ] `gitleaks detect` passes with no findings
- [ ] `git diff --cached` shows no credential patterns
- [ ] `.gitignore` covers all config files with secrets
- [ ] Example config files exist for any new config requirements
- [ ] No credentials in commit messages or PR descriptions
- [ ] No credentials in comments or documentation

---

## Emergency Response

If a credential is accidentally committed:

```bash
# 1. Remove from history (if not yet pushed)
git reset --soft HEAD~1
# Fix the file
git add -A && git commit

# 2. If already pushed — ROTATE THE CREDENTIAL IMMEDIATELY
# The credential is compromised the moment it hits a remote

# 3. Use BFG Repo-Cleaner for deep history cleaning
bfg --replace-text passwords.txt repo.git
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

> ⚠️ **Rule of thumb:** If a secret hits any remote (GitHub, GitLab, etc.), consider it compromised and rotate immediately. Git history is forever.

---

## Integration with GSD Workflow

| Stage | Credential Check |
|-------|-----------------|
| Plan | Identify which configs need secrets — document in PLAN.md |
| Execute | Agents read from config files, never inline |
| Pre-Commit | `gitleaks protect --staged` |
| QA | Security testing includes credential scan |
| MR Review | Checklist includes credential verification |

---

*Based on battle-tested practices from a 59-agent production team managing 45+ servers.*
