# THREAT TAXONOMY — OpenExec Constitutional Layer

This taxonomy defines structured threat categories for governed autonomous systems.

The goal is not to list every possible attack.

The goal is to classify attacks into enforceable architectural classes.

---

## Tier 1 — Input Layer Threats

### T1.1 Prompt Injection
External text attempts to alter tool usage or governance decisions.

Sources:
- Web pages
- Emails
- Documents
- Chat history
- PDFs
- Third-party API responses

Risk:
Tool misuse, data exfiltration, unauthorized actions.

Mapped Controls:
- Typed schema normalization
- Allowlisted tools
- Governance review
- Decision logging

---

### T1.2 Context Poisoning
Malicious data inserted into long-term memory / vector DB.

Risk:
Persistent corruption of agent reasoning.

Mapped Controls:
- Memory validation gates
- Tenant-scoped storage
- Sanitization pipelines
- Audit trail of memory writes

---

## Tier 2 — Execution Layer Threats

### T2.1 Tool Misuse
Agent invokes tool outside intended scope.

Risk:
Unauthorized writes, destructive actions.

Controls:
- Explicit action allowlist
- Capability-based scope enforcement
- Deterministic execution only

---

### T2.2 Privilege Escalation
Agent acquires expanded permissions.

Risk:
Bypassing governance, cross-tenant access.

Controls:
- No self-authorization
- Multi-sig for privilege changes
- Policy-as-code enforcement

---

### T2.3 Arbitrary Code Execution
Unbounded shell or interpreter execution.

Risk:
Host compromise, data theft.

Controls:
- Shell disabled by default
- Parameterized execution only
- Sandbox isolation boundary

---

## Tier 3 — Data & Boundary Threats

### T3.1 Data Exfiltration
Sensitive data leaves system boundary.

Risk:
PII leakage, secrets exposure.

Controls:
- Egress caps
- Destination allowlists
- Redaction scanning
- Receipt-level flags

---

### T3.2 Cross-Tenant Contamination
One tenant’s data impacts another tenant.

Risk:
Regulatory violation, data breach.

Controls:
- Tenant ID enforcement
- Scoped queries
- Strict workspace isolation

---

### T3.3 Secret Exposure
API keys, tokens, credentials leaked via logs or LLM context.

Controls:
- Secrets vault isolation
- Redaction policies
- Never return secrets to reasoning layer

---

## Tier 4 — Governance Layer Threats

### T4.1 Governance Bypass
Execution occurs without approval.

Controls:
- Fail-closed invariant
- Approval token required
- Approval replay protection

---

### T4.2 Policy Mutation
Agent attempts to modify governance rules.

Controls:
- Policy changes require multi-sig
- Constitution version hashing
- Immutable decision logs

---

## Tier 5 — Systemic & Operational Threats

### T5.1 Rogue Loops
Agent repeatedly executes harmful cycle.

Controls:
- Retry caps
- Loop detection heuristics
- Automatic kill switch

---

### T5.2 Cost Explosion
Unbounded LLM/tool invocation cost.

Controls:
- Spend caps
- Per-tenant quotas
- Circuit breakers

---

### T5.3 Supply Chain Compromise
Malicious dependency/plugin/model.

Controls:
- Dependency pinning
- Checksums
- Provenance tracking
- Policy bundle hash logging

---

### T5.4 Audit Tampering
Attempt to alter or delete evidence.

Controls:
- Append-only logging
- Hash-addressed records
- Signature verification

---

## Constitutional Mapping

Every Tier 1–5 threat must map to:

- An invariant in INVARIANTS.md
- A control in CONTROL_MATRIX.md
- An enforcement layer (Shield, Exec, Ledger)
- A decision log + execution receipt artifact

If any threat class cannot be mapped to enforceable controls,
the system is not production-ready.

