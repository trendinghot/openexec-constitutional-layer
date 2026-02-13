-- Canonical execution receipt schema (Postgres)

CREATE TABLE IF NOT EXISTS exec_receipts (
  receipt_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  trace_id TEXT NOT NULL,
  request_id TEXT NOT NULL,
  tenant_id TEXT NOT NULL,
  action TEXT NOT NULL,
  parameters_json JSONB NOT NULL,
  approved BOOLEAN NOT NULL DEFAULT FALSE,
  approved_at TIMESTAMPTZ NOT NULL,
  executed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  status TEXT NOT NULL,
  result_json JSONB,
  receipt_hash TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_exec_receipts_trace_id ON exec_receipts(trace_id);
CREATE INDEX IF NOT EXISTS idx_exec_receipts_tenant_id ON exec_receipts(tenant_id);
