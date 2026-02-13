# APPROVAL TOKEN SPEC — OpenExec Constitutional Layer

This document defines the cryptographically signed approval token required
for any execution action.

OpenExec must refuse execution unless a valid approval token is present.

---

## 1) Core Principle

Execution authority is not implicit.
Execution authority must be explicitly granted,
cryptographically signed,
time-bound,
and scope-limited.

---

## 2) Token Format

Approval tokens must be:

- Detached JSON payload
- Canonicalized (sorted keys)
- SHA-256 hashed
- Signed using Ed25519 (recommended)

Format:

{
  "token_id": "uuid",
  "trace_id": "string",
  "request_id": "string",
  "tenant_id": "string",
  "action": "string",
  "parameters_hash": "sha256 hash of canonical parameters",
  "approval_scope": "string",
  "constitution_version": "string",
  "policy_bundle_hash": "sha256 hash",
  "issued_at": "timestamp",
  "expires_at": "timestamp",
  "nonce": "unique random value",
  "constraints": {
      "max_cost_usd": number,
      "max_retries": number,
      "rate_limit_per_min": number
  }
}

Signature:

{
  "signature_algorithm": "ed25519",
  "public_key_id": "string",
  "signature": "base64"
}

---

## 3) Required Claims

OpenExec must verify:

- token_id exists
- tenant_id matches request context
- action is allowlisted
- parameters_hash matches incoming parameters
- policy_bundle_hash matches active bundle
- expires_at not expired
- nonce unused
- signature valid

If any check fails → reject execution.

---

## 4) Replay Protection

Replay protection must include:

- Nonce registry (short-lived store)
- Expiration enforcement
- One-time use tokens (optional high security mode)

Expired or reused tokens must be rejected.

---

## 5) Signature Model

Recommended:

- ClawShield holds private signing key
- OpenExec holds public verification key
- Key rotation requires:
    - Multi-sig approval
    - Ledger entry
    - New public_key_id

Private keys must never exist inside OpenExec.

---

## 6) Enforcement Algorithm (Pseudo-Flow)

1. Receive execution request
2. Extract approval token
3. Canonicalize parameters
4. Hash parameters
5. Compare parameters_hash
6. Verify signature
7. Validate expiry
8. Validate nonce unused
9. Validate tenant + scope
10. Execute deterministically
11. Produce receipt

---

## 7) Fail-Closed Rule

If token is:

- Missing
- Invalid
- Expired
- Signature mismatch
- Policy mismatch
- Nonce reused

→ Execution must not occur.

---

## 8) High-Risk Mode

For actions marked:

- money movement
- destructive DB ops
- policy modification

Token must include:

- human_attestors
- multi_sig_threshold
- elevated expiry constraints (short-lived)

---

## Constitutional Principle

Governance without signed authorization is advisory.

Governance with signed authorization is enforceable.

OpenExec must only trust signed tokens —
never runtime flags, never environment variables, never LLM output.

