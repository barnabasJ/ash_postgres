# US-APDELTA-62 — Persist temporal relationship state through real code generation

As a developer, I need delta code generation to preserve the complete desired resource state across subsequent runs.

- **Given** two temporal resources connected through a period-aware foreign key.
- **When** public generation persists deltas and the native reader reduces their JSON.
- **Then** the complete reference and desired attributes survive, and unchanged generation writes no files.

Owned by `test/delta_generation_security_test.exs`.
