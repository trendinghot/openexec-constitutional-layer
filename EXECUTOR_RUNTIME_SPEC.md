# EXECUTOR RUNTIME SPEC — OpenExec Constitutional Layer

This document defines the mandatory runtime security constraints
for the OpenExec execution layer.

If any runtime requirement cannot be enforced,
OpenExec must refuse production deployment.

---

# 1) Execution Boundary Model

OpenExec must run inside an isolation boundary that enforces:

- No host filesystem access
- No unrestricted network access
- No privilege escalation
- No ambient credentials
- No uncontrolled shell execution

Recommended isolation technologies:

- MicroVM (Firecracker / Kata Containers)
- gVisor
- WebAssembly sandbox (WASI)
- Container with seccomp + AppArmor + read-only root

Minimum acceptable: container with strict seccomp profile + read-only root filesystem.

---

# 2) Filesystem Rules

OpenExec runtime must enforce:

- Read-only root filesystem
- Writable temp directory only
- No access to:
  - /etc
  - host mounts
  - Docker socket
  - system device files
- No dynamic module loading from arbitrary paths

If action requires file write:
- Must be scoped to tenant workspace
- Must be explicitly allowed in approval token scope

---

# 3) Network Egress Controls

Default: deny-all egress.

OpenExec must only allow outbound calls to:

- Explicitly allowlisted domains
- Pre-approved IP ranges
- Service-bound connectors

Outbound calls must enforce:

- DNS resolution validation
- No raw IP bypass
- No localhost / metadata endpoints
- No 169.254.169.254
- No internal control plane addresses

Optional advanced:

- eBPF outbound filters
- Service mesh enforcement

---

# 4) Capability Injection Model

Execution must have zero ambient authority.

All capabilities must be injected per request:

- Scoped API tokens
- Short-lived credentials
- Limited-access connectors
- Parameter-level scope restrictions

Secrets must be:

- Pulled from vault
- Never exposed to reasoning layer
- Never written to logs

---

# 5) Deterministic Execution Wrapper

OpenExec must wrap every action in:

- Typed input schema validation
- Parameter canonicalization
- Parameter hashing
- Token validation
- Structured execution call
- Structured result capture

No dynamic eval().
No free-form interpreter calls.
No string-concatenated shell commands.

---

# 6) Shell Execution Rules

Shell execution is high-risk.

If enabled:

- Must be parameterized
- No user-controlled string concatenation
- Must run inside:
    - isolated namespace
    - read-only root
    - no outbound network (unless scoped)
- Must log command hash, not raw command with secrets

Raw shell passthrough is constitutionally prohibited.

---

# 7) Model Invocation Boundary

If OpenExec invokes LLMs:

- Model endpoints must be allowlisted
- Prompt must be structured
- No injection of secrets into prompt
- Token limits must be enforced
- Cost must be tracked

LLM calls are treated as external execution, not trusted reasoning.

---

# 8) Observability Requirements

Executor must emit structured logs:

- trace_id
- request_id
- action
- parameters_hash
- token_id
- execution_env
- start_time
- end_time
- status
- result_hash

Logs must not contain:

- Secrets
- Full PII payloads
- Raw credentials

---

# 9) Loop & Cost Guardrails

Executor must enforce:

- Max retry count
- Max recursive depth
- Max total execution time
- Max cost budget per token

If limits exceeded:

- Abort
- Produce receipt with status=aborted
- Flag loop_guard_triggered

---

# 10) Immutable Evidence Integration

After execution:

- Receipt must be generated
- receipt_hash computed
- Optional signature applied
- Stored in ledger

Execution is not considered complete until receipt is written.

---

# 11) Key Management

OpenExec must:

- Only hold public verification keys
- Never store governance private keys
- Support key rotation via public_key_id
- Refuse tokens signed by unknown keys

---

# 12) Hard Fail Conditions

OpenExec must refuse execution if:

- Approval token missing
- Token invalid
- Token expired
- Nonce reused
- Policy bundle hash mismatch
- Tenant mismatch
- Scope mismatch
- Runtime sandbox not active

Fail open is forbidden.

---

# 13) Production Readiness Criteria

Deployment is not constitutional-compliant unless:

- Sandbox verified active
- Egress deny-by-default enforced
- Token validation active
- Receipt writing active
- Loop breakers active
- Observability active

If any disabled → system must declare NON-COMPLIANT.

---

Constitution without runtime enforcement is advisory.

Runtime without constitution is dangerous.

OpenExec requires both.

