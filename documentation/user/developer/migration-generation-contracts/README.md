# Migration generation contracts

These stories preserve the native migration generator's observable behavior while its tests use immutable resource definitions and case-owned output paths.

Each feature test module runs with `async: true`. Define resource and domain
versions as immutable modules. Point every relationship at the matching
destination version. Run the actual public generator against persisted files
under ExUnit's `tmp_dir`. Capture stdout and prompt input with native
`ExUnit.CaptureIO`. Configure repository capabilities through fixed native
callbacks. When a case executes SQL, use ExUnit supervision and ordinary SQL
Sandbox ownership. Keep session changes transaction-local.

The two repository-specific native UUID stories inspect that repository's
generated output. Other configured repositories keep their own capabilities.

| Story                         | Contract                                                               |
| ----------------------------- | ---------------------------------------------------------------------- |
| [US-APMG-001](US-APMG-001.md) | Empty resources produce no migration or snapshot                       |
| [US-APMG-002](US-APMG-002.md) | A primary-key-only resource produces one migration and snapshot        |
| [US-APMG-003](US-APMG-003.md) | Timestamptz selection preserves explicit migration type overrides      |
| [US-APMG-004](US-APMG-004.md) | Timestamptz resources expose the native Ecto type                      |
| [US-APMG-005](US-APMG-005.md) | Stored datetime instants survive a transaction-local timezone change   |
| [US-APMG-006](US-APMG-006.md) | FK attribute declaration order preserves table creation                |
| [US-APMG-007](US-APMG-007.md) | PostgreSQL 18 UUID capability selects native uuidv7 defaults           |
| [US-APMG-008](US-APMG-008.md) | Native UUID support omits the obsolete extension function              |
| [US-APMG-009](US-APMG-009.md) | Initial snapshots retain types, defaults, sources and identities       |
| [US-APMG-010](US-APMG-010.md) | Schema-qualified snapshots retain schema and index predicates          |
| [US-APMG-011](US-APMG-011.md) | Concurrent indexes use a separate nontransactional migration           |
| [US-APMG-012](US-APMG-012.md) | Custom indexes preserve nulls-distinct choices                         |
| [US-APMG-013](US-APMG-013.md) | Custom indexes preserve sort directions                                |
| [US-APMG-014](US-APMG-014.md) | A dependent FK follows its concurrent unique index                     |
| [US-APMG-015](US-APMG-015.md) | Explicitly named split migrations have unique names and modules        |
| [US-APMG-016](US-APMG-016.md) | Column renames precede replacement indexes in both directions          |
| [US-APMG-017](US-APMG-017.md) | Same-name index replacements drop the prior index first                |
| [US-APMG-018](US-APMG-018.md) | Removed constraints and columns remain reversible in dependency order  |
| [US-APMG-019](US-APMG-019.md) | Identity renames remain reversible with their column renames           |
| [US-APMG-020](US-APMG-020.md) | Composite primary-key removal and restoration rebuild the correct keys |

| [US-APMG-021](US-APMG-021.md) | Indexed attribute rename avoids an unrelated modify |
| [US-APMG-022](US-APMG-022.md) | Identity index names can change without replacement |
| [US-APMG-023](US-APMG-023.md) | Identity predicate changes replace the old index first |
| [US-APMG-024](US-APMG-024.md) | New required fields retain their nullability |
| [US-APMG-025](US-APMG-025.md) | Confirmed single-field renames generate rename SQL |
| [US-APMG-026](US-APMG-026.md) | Declined single-field renames add the new field |
| [US-APMG-027](US-APMG-027.md) | A selected rename target determines the generated column rename |
| [US-APMG-028](US-APMG-028.md) | Selected identity renames preserve forward and reverse index order |
| [US-APMG-029](US-APMG-029.md) | Declining a multiple-candidate rename adds the new fields |
| [US-APMG-030](US-APMG-030.md) | Resources sharing one table contribute all added attributes |
| [US-APMG-031](US-APMG-031.md) | Resources sharing one table contribute all identities |
| [US-APMG-032](US-APMG-032.md) | Concurrent identity changes produce a separate index migration |
| [US-APMG-033](US-APMG-033.md) | A column absent from another shared-table resource stays nullable |

| [US-APMG-034](US-APMG-034.md) | A serial integer can become an explicit-default integer |
| [US-APMG-035](US-APMG-035.md) | An explicit-default integer can regain its serial sequence |
| [US-APMG-036](US-APMG-036.md) | Generated integer primary keys use bigserial |
| [US-APMG-037](US-APMG-037.md) | Explicit identity migration types are preserved |

| [US-APMG-038](US-APMG-038.md) | Context-tenant composite keys retain tenant prefixes |
| [US-APMG-039](US-APMG-039.md) | Schema-qualified field renames preserve their schema |
| [US-APMG-040](US-APMG-040.md) | Schema-qualified renames preserve additional field changes |

| [US-APMG-041](US-APMG-041.md) | Codegen checks reject pending changes without writing files |
| [US-APMG-042](US-APMG-042.md) | Codegen checks identify remaining development migrations |
| [US-APMG-043](US-APMG-043.md) | Codegen checks do not infer ambiguous renames |

| [US-APMG-044](US-APMG-044.md) | Global attribute multitenancy preserves existing identities |
| [US-APMG-045](US-APMG-045.md) | Global context multitenancy preserves skipped foreign keys |

| [US-APMG-046](US-APMG-046.md) | Supported literal defaults preserve exact migration values |
| [US-APMG-047](US-APMG-047.md) | Unsupported literal defaults warn and omit an invalid SQL default |
| [US-APMG-048](US-APMG-048.md) | Regular table creation retains declared PostgreSQL options |
| [US-APMG-049](US-APMG-049.md) | Tenant table creation retains declared PostgreSQL options |

| [US-APMG-050](US-APMG-050.md) | Decimal creation preserves declared precision and scale |
| [US-APMG-051](US-APMG-051.md) | Decimal changes preserve updated precision and scale |
| [US-APMG-052](US-APMG-052.md) | Arbitrary decimal constraints omit precision and scale options |
| [US-APMG-053](US-APMG-053.md) | Decimal constraints can change from fixed to arbitrary |
| [US-APMG-054](US-APMG-054.md) | Decimal foreign keys preserve target precision and scale |

| [US-APMG-055](US-APMG-055.md) | Adding varchar storage preserves its size and prior type |
| [US-APMG-056](US-APMG-056.md) | Changing varchar size preserves both declared sizes |
| [US-APMG-057](US-APMG-057.md) | Binary storage changes preserve the declared size |
| [US-APMG-058](US-APMG-058.md) | An explicit migration type does not modify unrelated columns |

| [US-APMG-059](US-APMG-059.md) | Skipped resources remain visible in the no-change report |
| [US-APMG-060](US-APMG-060.md) | Extension migrations increment past the persisted sequence |

| [US-APMG-061](US-APMG-061.md) | Check constraint creation and replacement preserve exact SQL |
| [US-APMG-062](US-APMG-062.md) | Check constraints account for the declared base filter |
| [US-APMG-063](US-APMG-063.md) | Constraint removal precedes related table modification |
| [US-APMG-064](US-APMG-064.md) | A mapping-only constraint does not erase another resource’s check |
| [US-APMG-065](US-APMG-065.md) | An unfiltered check is not wrapped by another resource’s filter |
| [US-APMG-066](US-APMG-066.md) | Shared checks combine their declared base filters |
| [US-APMG-067](US-APMG-067.md) | Conflicting same-name checks fail with an actionable error |
| [US-APMG-068](US-APMG-068.md) | Reverse constraint creation retains its base-filter composition |
| [US-APMG-069](US-APMG-069.md) | Historical snapshots without constraint filters remain unchanged |

| [US-APMG-070](US-APMG-070.md) | Polymorphic FKs honor relationship table context |
| [US-APMG-071](US-APMG-071.md) | PK changes preserve dependent FK operation order |
| [US-APMG-072](US-APMG-072.md) | Tenant identity indexes do not duplicate the tenant column |
| [US-APMG-073](US-APMG-073.md) | New tenant columns precede their identity indexes |
| [US-APMG-074](US-APMG-074.md) | Confirmed table removal drops the table and its snapshot |
| [US-APMG-075](US-APMG-075.md) | A second generation after a drop is a no-op |
| [US-APMG-076](US-APMG-076.md) | Declining a drop retains its snapshot without asking again |
| [US-APMG-077](US-APMG-077.md) | Resources excluded from migration do not become drop candidates |
| [US-APMG-078](US-APMG-078.md) | Confirmed schema-qualified drops retain their prefix |
| [US-APMG-079](US-APMG-079.md) | Dependent tables are dropped before referenced tables |
| [US-APMG-080](US-APMG-080.md) | Dependent foreign keys are dropped before the removed parent table |
| [US-APMG-081](US-APMG-081.md) | Additive migrations show the baseline review reminder |
| [US-APMG-082](US-APMG-082.md) | Commented removals show the safeguard escalation |
| [US-APMG-083](US-APMG-083.md) | Confirmed table drops show destructive escalation |
| [US-APMG-084](US-APMG-084.md) | Uncommented column removal shows destructive escalation |
| [US-APMG-085](US-APMG-085.md) | Quiet mode suppresses review reminders |
| [US-APMG-086](US-APMG-086.md) | Check mode reports pending codegen without warning output or files |
| [US-APMG-087](US-APMG-087.md) | No-shell mode suppresses review reminders |
| [US-APMG-088](US-APMG-088.md) | Dry-run output includes the baseline review reminder |
| [US-APMG-089](US-APMG-089.md) | Rename a resource table without recreating it |
| [US-APMG-090](US-APMG-090.md) | Propose a rename despite an empty target snapshot directory |
| [US-APMG-091](US-APMG-091.md) | Preserve the schema prefix in table renames |
| [US-APMG-092](US-APMG-092.md) | Select a rename target among multiple new tables |
| [US-APMG-093](US-APMG-093.md) | Decline a rename and confirm the original table drop |
| [US-APMG-094](US-APMG-094.md) | Move a table into a schema without recreating it |
| [US-APMG-095](US-APMG-095.md) | Move a table before altering it under the new schema |
| [US-APMG-096](US-APMG-096.md) | Decline a public-to-explicit-schema move |
| [US-APMG-097](US-APMG-097.md) | Move an existing table between explicit schemas |
| [US-APMG-098](US-APMG-098.md) | Decline a move between explicit schemas |
| [US-APMG-099](US-APMG-099.md) | Keep foreign keys intact when their referenced table moves schema |
| [US-APMG-101](US-APMG-101.md) | Infer UUID foreign keys |
| [US-APMG-102](US-APMG-102.md) | Create a unique index before its dependent foreign key |
| [US-APMG-103](US-APMG-103.md) | Infer the destination attribute type |
| [US-APMG-104](US-APMG-104.md) | Preserve explicit reference matching |
| [US-APMG-105](US-APMG-105.md) | Index an inferred reference |
| [US-APMG-106](US-APMG-106.md) | Generate a partial reference index |
| [US-APMG-107](US-APMG-107.md) | Change a reference index predicate without replacing its foreign key |
| [US-APMG-108](US-APMG-108.md) | Disable a reference index without replacing its foreign key |
| [US-APMG-109](US-APMG-109.md) | Keep the schema in deferrable constraint changes |
| [US-APMG-110](US-APMG-110.md) | Include tenant columns in reference indexes |
| [US-APMG-111](US-APMG-111.md) | Avoid duplicate tenant columns in reference indexes |
| [US-APMG-112](US-APMG-112.md) | Replace single-column indexes when acquiring multitenancy |
| [US-APMG-113](US-APMG-113.md) | Replace composite indexes when removing multitenancy |
| [US-APMG-114](US-APMG-114.md) | Combine explicit matching with tenant matching |
| [US-APMG-115](US-APMG-115.md) | Keep all-tenant identities independent of tenant columns |
| [US-APMG-116](US-APMG-116.md) | Rebuild all-tenant identities when their base filter changes |
| [US-APMG-117](US-APMG-117.md) | Rebuild all-tenant custom indexes when their base filter changes |
| [US-APMG-118](US-APMG-118.md) | Preserve all-tenant indexes across tenant-attribute changes |
| [US-APMG-119](US-APMG-119.md) | Replace a filtered identity when its name and predicate change together |
| [US-APMG-120](US-APMG-120.md) | Drop a foreign key before changing its reference options |
| [US-APMG-121](US-APMG-121.md) | Match tenant columns only where required |
| [US-APMG-122](US-APMG-122.md) | Require full tenant matching for required primary-key references |
| [US-APMG-123](US-APMG-123.md) | Infer simple tenant matching for nullable references |
| [US-APMG-124](US-APMG-124.md) | Respect an explicit tenant reference match type |
| [US-APMG-125](US-APMG-125.md) | Recreate a tenant foreign key when it becomes nullable |
| [US-APMG-126](US-APMG-126.md) | Nilify selected reference columns under multitenancy |

Executable verification is pending with the host's compile/test owner.
