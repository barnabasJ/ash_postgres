# Delta mode contracts

| Story                         | Behavior                                                                                    |
| ----------------------------- | ------------------------------------------------------------------------------------------- |
| [US-APDI-001](US-APDI-001.md) | Run and roll back an initial generated delta migration.                                     |
| [US-APDI-002](US-APDI-002.md) | Run an incremental column migration without recompiling the applied initial file.           |
| [US-APDI-003](US-APDI-003.md) | initial codegen produces a v2 delta with CreateTable + AddAttribute ops                     |
| [US-APDI-004](US-APDI-004.md) | adding an attribute in a follow-up codegen produces a minimal delta                         |
| [US-APDI-005](US-APDI-005.md) | codegen with no changes does not emit any new delta files                                   |
| [US-APDI-006](US-APDI-006.md) | removing an attribute produces a RemoveAttribute op that reduces correctly                  |
| [US-APDI-007](US-APDI-007.md) | renaming an attribute produces a RenameAttribute op                                         |
| [US-APDI-008](US-APDI-008.md) | altering an attribute (type change) produces an AlterAttribute op                           |
| [US-APDI-009](US-APDI-009.md) | renaming a table produces a RenameTable op                                                  |
| [US-APDI-010](US-APDI-010.md) | renaming a table, reducing, and generating a follow-up delta succeeds                       |
| [US-APDI-011](US-APDI-011.md) | adding an identity (unique constraint) produces AddUniqueIndex ops                          |
| [US-APDI-012](US-APDI-012.md) | adding a custom index produces an AddCustomIndex op                                         |
| [US-APDI-013](US-APDI-013.md) | adding a check constraint produces an AddCheckConstraint op                                 |
| [US-APDI-014](US-APDI-014.md) | references (belongs_to) round-trip through delta encode + reduce                            |
| [US-APDI-015](US-APDI-015.md) | resources with context multitenancy store deltas under tenants/                             |
| [US-APDI-016](US-APDI-016.md) | attribute multitenancy persists the tenancy attribute in ops                                |
| [US-APDI-017](US-APDI-017.md) | two deltas from separate 'branches' merge cleanly and reduce to combined state              |
| [US-APDI-018](US-APDI-018.md) | conflicting deltas (same attribute added in two 'branches') raise ConflictError             |
| [US-APDI-019](US-APDI-019.md) | real sequential codegen on diverged branches produces deltas that merge cleanly             |
| [US-APDI-020](US-APDI-020.md) | generate → squash → generate yields no drift                                                |
| [US-APDI-021](US-APDI-021.md) | post-squash incremental codegen emits the same migration as the no-squash baseline          |
| [US-APDI-022](US-APDI-022.md) | answering 'no' to the drop prompt writes an OptOutDropTable delta                           |
| [US-APDI-023](US-APDI-023.md) | converting a legacy repo then running codegen in delta mode emits no migration              |
| [US-APDI-024](US-APDI-024.md) | post-migrate incremental codegen emits the same migration as the no-migrate baseline        |
| [US-APDI-025](US-APDI-025.md) | creating a resource produces identical migrations in full and delta modes                   |
| [US-APDI-026](US-APDI-026.md) | evolving a resource (add + alter + index) produces identical migrations                     |
| [US-APDI-027](US-APDI-027.md) | removing an attribute produces identical DROP COLUMN migration in both modes                |
| [US-APDI-028](US-APDI-028.md) | custom index produces identical CREATE INDEX migration in both modes                        |
| [US-APDI-029](US-APDI-029.md) | check constraint produces identical migration in both modes                                 |
| [US-APDI-030](US-APDI-030.md) | belongs_to references produce identical FK migration in both modes                          |
| [US-APDI-031](US-APDI-031.md) | attribute multitenancy produces identical migration in both modes                           |
| [US-APDI-032](US-APDI-032.md) | schema-prefixed table produces identical migration in both modes                            |
| [US-APDI-033](US-APDI-033.md) | renaming an attribute produces identical RENAME migration in both modes                     |
| [US-APDI-034](US-APDI-034.md) | delta files for a schema-prefixed resource land under {schema}.{table}/                     |
| [US-APDI-035](US-APDI-035.md) | delta codegen with dev: true writes _dev.json files                                         |
| [US-APDI-036](US-APDI-036.md) | polymorphic resources land in concrete-table snapshot dirs and produce runnable migrations  |
| [US-APDI-037](US-APDI-037.md) | context multitenancy in delta mode produces a tenant migration that runs via migrate_tenant |
| [US-APDI-038](US-APDI-038.md) | squashed delta produces a migration that creates the same schema                            |
