# INVARIANTS — OpenExec Constitutional Layer

This document defines **non-negotiable, enforceable invariants** for governed autonomous systems.

These are not “best practices.”
These are **constitutional constraints**.

If any invariant cannot be enforced, the system must **fail closed**.

---

## 0) Definitions

- **Reasoning Layer**: produces proposals (plans, intents, tool calls) but has **zero direct execution** authority.
- **Governance Layer (ClawShield)**: evaluates proposals against constitution + policy-as-code, assigns constraints, requires approvals.
- **Execution Layer (OpenExec)**: runs **only approved** actions, deterministically, inside strict sandbox boundaries.
- **Witness Layer (ClawLedger)**: immutable logging of decisions + executions + hashes + provenance.

---

## 1) Constitutional Invariants

### INV-001 — Separation of Powers
Reasoning, governance, execution, and witness are **independent layers**.  
No layer may be “merged” or bypassed in production.

### INV-002 — No Self-Authorization
An agent (reasoning layer) may **never approve its own actions**.  
Approval must come from governance (and humans when required).

### INV-003 — Fail Closed by Default
If governance is unavailable, policies cannot be loaded, or receipts cannot be written:  
**execution must stop**.

### INV-004 — Deterministic Execution Only
OpenExec must run actions as **deterministic commands** with:
- fixed input schema
- explicit parameters
- reproducible outcomes (as far as practical)

No free-form “do whatever” execution is allowed.

### INV-005 — Explicit Allowlist for Tools
All tools/actions must be **explicitly allowlisted** by action name + scope.
Unknown tools are rejected.

### INV-006 — Least Privilege Everywhere
Every action must run with:
- minimum filesystem access
- minimum network access
- minimum API scopes
- minimum runtime permissions

### INV-007 — Capability-Based Access
Execution must have **zero ambient authority**.  
All access is granted explicitly via capabilities (scopes) in the governance envelope.

### INV-008 — Strong Tenant Isolation
No action may access data outside its tenant/workspace boundary.  
Cross-tenant reads/writes are **constitutionally forbidden** unless explicitly governed under a separate cross-tenant protocol.

### INV-009 — Secret Non-Disclosure
Secrets (API keys, tokens, credentials) must never be:
- logged in plaintext
- returned to the reasoning layer
- embedded into receipts

OpenExec may *use* secrets, but cannot *reveal* them.

### INV-010 — Output Redaction and PII Controls
Governance must apply redaction rules to any output that can reach:
- LLM context
- user UI
- logs
- external channels

### INV-011 — Data Egress Limits
Outbound data transfer must be capped by policy:
- max payload size
- destination allowlist
- rate limits
- content scanning (PII/secrets)

### INV-012 — No Direct Shell Without Governance
Any shell execution (bash, powershell, cmd, python exec) is **high risk** and must:
- require governance approval
- be parameterized (no unbounded user-controlled strings)
- run in the strictest sandbox possible

### INV-013 — Prompt Injection is Treated as Input Compromise
All external text is untrusted:
- web pages
- email bodies
- docs
- PDFs
- chat logs

No external text may directly become tool instructions without governance normalization.

### INV-014 — Decision Logging is Mandatory
Every proposal must produce a governance decision record capturing:
- decision type (approve/deny/escalate)
- policy bundle hash
- constitution version
- rules fired
- rationale

### INV-015 — Execution Receipts are Mandatory
Every execution must produce an immutable receipt capturing:
- trace_id, request_id
- tenant_id/workspace
- action + parameters hash
- approval references
- timestamps
- status + result hash

### INV-016 — Cryptographic Integrity of Records
Decision logs and receipts must be hash-addressed and tamper-evident.  
Where possible, records are signed.

### INV-017 — Replay Protection
Approvals must be time-bound and single-use where feasible.  
OpenExec must reject replayed or expired approvals.

### INV-018 — Pre-Execution Preview for High Impact Actions
High-impact actions must produce a “preview diff”:
- what will change
- how many records/objects affected
- cost estimate
- irreversible flags

### INV-019 — Human-in-the-Loop for High Risk Classes
Classes requiring human approval (baseline):
- money movement / billing
- deleting large sets of data
- privilege / role changes
- credential rotation
- outbound mass messaging

### INV-020 — Multi-Party Approval for Critical Operations
Certain actions require multi-sig (>=2 approvers), e.g.:
- production DB destructive actions
- disabling security controls
- changing governance policies
- deploying new executors

### INV-021 — Cost and Loop Circuit Breakers
Governance + executor must enforce:
- max spend (per request, per tenant, per day)
- loop detection thresholds
- max retries

If triggered: **kill and quarantine** the agent session.

### INV-022 — Immutable Auditability
All critical events must be audit reconstructible:
- who requested
- what was proposed
- why it was approved/denied
- what executed
- what changed

### INV-023 — Supply Chain Pinning
Dependencies, models, and tool plugins must be pinned and verified:
- lockfiles
- checksums/signatures
- provenance tracking

### INV-024 — Sandbox Boundary is Non-Negotiable
Execution must occur inside a sandbox boundary that prevents:
- host filesystem access
- arbitrary network egress
- privilege escalation

### INV-025 — Incident Response Must Be Built-In
The system must support:
- kill switch
- quarantine mode
- log export
- tenant isolation lockdown
- credential rotation runbooks

---

## 2) Enforcement Requirement

An invariant is only real if it is enforceable by:
- policy-as-code (OPA/Rego or equivalent)
- runtime constraints (sandbox/capabilities)
- immutable logging
- human approvals where required

If enforcement is not possible, the feature is **out of scope** for production until it is.

