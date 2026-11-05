# US-APDI-035 — delta codegen with dev: true writes _dev.json files

As a developer, I need delta snapshots and generated migrations to preserve the intended schema through --dev flag.

## Scenario

Given a static resource is generated with native dev mode.
When the actual dev snapshot is decoded and reduced with dev enabled and disabled.
Then the _dev file contains a valid delta, dev reduction includes its field and ordinary reduction ignores it.

Coverage: `US-APDI-035` in `test/delta_mode_dev_test.exs`.
