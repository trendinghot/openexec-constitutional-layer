-- Canonical governance decision log schema (Postgres)

CREATE TABLE IF NOT EXISTS governance_decisions (
  decision_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trace_id TEXT NOT NULL,
  request_id TEXT NOT NULL,
  tenant_id TEXT NOT NULL,
  decision_type TEXT NOT NULL,
  constitution_version TEXT NOT NULL,
  policy_bundle_hash TEXT NOT NULL,
  rules_fired_json JSONB NOT NULL,
  rationale TEXT NOT NULL,
  decided_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  decision_hash TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_gov_decisions_trace_id ON governance_decisions(trace_id);
CREATE INDEX IF NOT EXISTS idx_gov_decisions_tenant_id ON governance_decisions(tenant_id);
