# US-APMG-034 — A serial integer can become an explicit-default integer

As a developer, I need generated integer migrations to preserve the selected sequence and identity contract.

Given an actual initial generated integer primary key with nil default,

When native generation compares the immutable version whose default is zero,

Then the forward migration changes bigint default to zero before dropping its sequence, and reverse SQL recreates the bigint sequence before modifying the column without a default-nil or bigserial shortcut.

Owning case: `test/migration_generator_serial_sequence_test.exs`, story tag `US-APMG-034`.

Status: source migrated; executable verification pending.
