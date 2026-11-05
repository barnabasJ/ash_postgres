# US-APMG-035 — An explicit-default integer can regain its serial sequence

As a developer, I need generated integer migrations to preserve the selected sequence and identity contract.

Given an actual initial generated integer primary key with default zero,

When native generation compares the immutable nil-default version,

Then forward SQL creates the bigint sequence before modifying the column and sets nextval, while reverse SQL restores default zero before dropping the sequence.

Owning case: `test/migration_generator_serial_sequence_test.exs`, story tag `US-APMG-035`.

Status: source migrated; executable verification pending.
