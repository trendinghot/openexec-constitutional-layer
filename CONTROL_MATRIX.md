# CONTROL MATRIX — OpenExec Constitutional Layer

This matrix maps **threat classes** → **required controls** → **enforcement location** → **evidence artifacts**.

Goal: make the constitution **operational**, **auditable**, and **hard to hand-wave**.

---

## How to read this

- **Threat**: what we are defending against
- **Control**: what must exist to stop or limit it
- **Enforced By**: which layer enforces it (ClawShield / OpenExec / ClawLedger)
- **Evidence**: what gets logged (receipt, decision, hashes, provenance)
- **Invariants**: which INVARIANTS.md rules this satisfies

---

## Matrix

### 1) Prompt Injection → Tool Misuse
**Threat:** attacker-supplied text causes tool execution.  
**Control:**
- Treat all external text as untrusted input
- Normalize proposals into typed schemas (no raw instructions)
- Explicit allowlist for actions and scopes
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- governance_decisions.rules_fired_json includes injection filters
- exec_receipts.action + parameters_json hashed
**Invariants:** INV-005, INV-013, INV-014, INV-015

---

### 2) Privilege Escalation (Agent self-upgrades permissions)
**Threat:** agent obtains new scopes/roles or bypasses policy.  
**Control:**
- No self-authorization
- Multi-sig / human approval for privilege changes
- Capability-based execution (no ambient authority)
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- governance_decisions.decision_type=escalate/require_multi_sig
- human_attestors_json (when implemented)
**Invariants:** INV-002, INV-007, INV-019, INV-020

---

### 3) Data Exfiltration (Secrets / PII / bulk export)
**Threat:** sensitive data leaves boundary via email/webhooks/HTTP.  
**Control:**
- Egress allowlist + payload caps
- PII/secrets scanning + redaction
- Receipt-level flags for exfiltration risk
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- exec_receipts.exfiltration_risk / pii_detected (when implemented)
- destination allowlist decision logs
**Invariants:** INV-009, INV-010, INV-011

---

### 4) Rogue Action Loops (Runaway automation)
**Threat:** repeated actions cause damage/cost explosion.  
**Control:**
- loop detection + retry caps
- cost caps per request/tenant/day
- kill switch + quarantine mode
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- governance_decisions.constraints_json (caps)
- exec_receipts.status=aborted with error_code=LOOP_GUARD
**Invariants:** INV-021, INV-025

---

### 5) Supply Chain Attacks (dependency/plugin compromise)
**Threat:** malicious package/plugin changes behavior.  
**Control:**
- dependency pinning and verification
- provenance tracking for tool binaries
- policy bundle hash pinned to decision logs
**Enforced By:** ClawShield + OpenExec + ClawLedger  
**Evidence:**
- governance_decisions.policy_bundle_hash
- exec_receipts.provenance_json (when implemented)
**Invariants:** INV-016, INV-023

---

### 6) Cross-Tenant Contamination
**Threat:** one tenant’s data affects another’s outcomes/actions.  
**Control:**
- strict tenant/workspace scoping on every request
- deny cross-tenant reads/writes by default
- tenant_id must be present in decisions and receipts
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- tenant_id in governance_decisions + exec_receipts
- denied decisions for mismatched tenant boundaries
**Invariants:** INV-008, INV-022

---

### 7) Unauthorized Shell / Arbitrary Code Exec
**Threat:** executing unbounded shell commands.  
**Control:**
- prohibit raw shell by default
- require governance approval + parameterization
- sandbox execution boundaries
**Enforced By:** ClawShield + OpenExec  
**Evidence:**
- exec_receipts.action is allowlisted (no free-form)
- governance decision includes approval scope
**Invariants:** INV-004, INV-012, INV-024

---

### 8) Tampering With Audit Logs
**Threat:** attacker deletes or alters evidence.  
**Control:**
- immutable receipts + hash addressing
- write-once append-only log store (ledger)
- signed hashes where possible
**Enforced By:** ClawLedger (and storage layer)  
**Evidence:**
- receipt_hash / decision_hash
- signatures (when enabled)
**Invariants:** INV-015, INV-016, INV-022

---

## Minimum “Production Ready” Checklist

A deployment is not constitutional-compliant unless:

- Every proposal produces a governance decision (INV-014)
- Every execution produces a receipt (INV-015)
- Unknown tools are rejected (INV-005)
- Execution runs with explicit scopes only (INV-007)
- Tenant boundaries are enforced everywhere (INV-008)
- Egress is constrained and logged (INV-011)
- Loop/cost breakers exist (INV-021)
- Logs are tamper-evident (INV-016)

