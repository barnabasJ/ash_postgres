# US-APDELTA-65 — Remove a temporal primary-key member without codegen drift

As a developer, I need a changed temporal primary key to retain its complete desired membership in persisted delta state.

Given a generated temporal table whose primary key contains `id` and `other_id`.
When public generation changes the desired primary key to contain only `id`.
Then reduction clears `other_id`'s old primary-key flag, retains the full desired attribute state, and unchanged generation writes no files.

Owned by `test/delta_generation_security_test.exs`.
