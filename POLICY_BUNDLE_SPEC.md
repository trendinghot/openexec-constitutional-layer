# POLICY BUNDLE SPEC — OpenExec Constitutional Layer

This document defines the structure and lifecycle of governance policy bundles.

A policy bundle is the executable representation of constitutional enforcement logic.

It must be:

- Versioned
- Hash-addressable
- Immutable once deployed
- Cryptographically verifiable

---

## 1) Policy Bundle Definition

A policy bundle contains:

- Constitution version reference
- Allowed actions and scopes
- Risk thresholds
- Human approval classes
- Cost limits
- Rate limits
- Egress controls
- Tenant isolation constraints
- Escalation rules

---

## 2) Canonical Policy Bundle Structure (JSON)

{
  "bundle_version": "2026.02.12",
  "constitution_version": "v1.0",
  "issued_at": "timestamp",
  "rules": {
    "allowlisted_actions": {
        "email:send": {
            "risk_level": "moderate",
            "requires_human": false,
            "max_cost_usd": 5
        },
        "db:delete_many": {
            "risk_level": "high",
            "requires_human": true,
            "multi_sig": true
        }
    },
    "egress_controls": {
        "allowed_domains": ["api.twilio.com", "api.sendgrid.com"],
        "max_payload_kb": 256
    },
    "loop_controls": {
        "max_retries": 3,
        "max_actions_per_min": 10
    }
  }
}

---

## 3) Policy Bundle Hashing

Every policy bundle must:

- Be canonicalized (sorted keys)
- Be SHA-256 hashed
- Store policy_bundle_hash in governance_decisions

The hash must uniquely identify enforcement logic at decision time.

---

## 4) Policy Immutability

Once deployed:

- Policy bundles cannot be edited in place.
- Any modification requires:
    - New bundle_version
    - New hash
    - Multi-sig approval (INV-020)
    - Ledger entry

---

## 5) Enforcement Model

ClawShield must:

- Load active policy bundle at runtime
- Validate constitution compatibility
- Evaluate proposals deterministically
- Emit:
    - decision_type
    - constraints
    - policy_bundle_hash

OpenExec must:

- Enforce constraints from approval token
- Reject mismatched policy versions

---

## 6) Version Compatibility

Constitution and policy bundles must be compatible:

If policy references deprecated invariant:
    → reject deployment

If constitution version changes:
    → require policy re-issuance

---

## 7) Audit Requirements

For every governance decision:

- Store constitution_version
- Store policy_bundle_hash
- Store rules_fired_json

This enables full forensic reconstruction.

---

## Constitutional Principle

Policy bundles are the executable embodiment of the constitution.

If bundles are mutable or opaque,
the system is not governed.

