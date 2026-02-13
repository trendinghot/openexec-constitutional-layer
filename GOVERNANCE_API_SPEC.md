# GOVERNANCE API SPEC — OpenExec Constitutional Layer

This document defines the required protocol between:

- OpenExec (Execution Layer)
- ClawShield (Governance Layer)

No execution may occur outside this protocol.

---

## 1) Proposal Submission

### Endpoint
POST /v1/governance/proposals

### Required Fields

{
  "trace_id": "uuid",
  "request_id": "uuid",
  "tenant_id": "string",
  "workspace_id": "string",
  "requested_by": "agent_or_user_id",
  "action": "string",
  "parameters_json": { ... },
  "risk_context": {
      "estimated_cost_usd": 0,
      "data_classification": "public|internal|pii|restricted",
      "impact_level": "low|moderate|high|critical"
  }
}

---

## 2) Governance Decision Response

ClawShield must return:

{
  "decision_id": "uuid",
  "trace_id": "uuid",
  "decision_type": "approve|deny|escalate|require_mfa|require_multi_sig",
  "constitution_version": "vX.Y",
  "policy_bundle_hash": "sha256",
  "constraints": {
      "allowed_scopes": ["email:send"],
      "max_cost_usd": 10,
      "expires_at": "timestamp",
      "rate_limit_per_min": 5
  },
  "approval_token": "signed_token_string"
}

---

## 3) Approval Token Requirements

Approval token must:

- Be cryptographically signed
- Include:
    - decision_id
    - tenant_id
    - action
    - allowed_scopes
    - expiry timestamp
- Be single-use where possible
- Be rejected if expired
- Be rejected if tampered

---

## 4) Execution Call Requirements

OpenExec may only execute when:

- approval_token is present
- approval_token signature is valid
- token not expired
- token matches action + tenant
- constraints enforced locally

If any validation fails:
Execution must abort (INV-003).

---

## 5) Replay Protection

Approval tokens must:

- Contain nonce or unique ID
- Be recorded upon use
- Be rejected on second use

---

## 6) Mandatory Logging

On every decision:
- governance_decisions record must be written.

On every execution:
- exec_receipts record must be written.

If logging fails:
Execution must fail closed.

---

## Constitutional Principle

The Governance API is not an optimization layer.

It is the constitutional gate.

No gate → no execution.

