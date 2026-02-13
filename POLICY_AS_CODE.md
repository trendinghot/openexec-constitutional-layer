# POLICY-AS-CODE — OpenExec Constitutional Layer

This document defines the constitutional requirement that governance decisions are evaluated using
a **real policy-as-code engine** (e.g., OPA/Rego) and that decisions are **cryptographically bound**
to the exact policy bundle used.

## Constitutional Requirement

1. Governance decisions MUST be evaluated by an enforceable policy engine (not prompt text).
2. Each governance decision MUST include:
   - constitution_version
   - policy_bundle_hash (sha256 of compiled policy bundle / wasm)
   - rules_fired / rationale as evidence
3. Approval tokens MUST embed policy_bundle_hash.
4. Execution MUST reject approvals whose policy_bundle_hash does not match the currently loaded policy bundle.
5. System MUST fail closed if policy bundle cannot be loaded or hashed.

## Why this exists

Without bundle hashing, a decision can be “approved” under one policy version and executed later under another.
That breaks audit integrity and enables silent policy drift.

Policy binding makes approvals tamper-evident and replay-resistant across policy upgrades.

