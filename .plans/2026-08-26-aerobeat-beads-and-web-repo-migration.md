# AeroBeat Beads And Web Repo Migration

**Date:** 2026-08-26
**Status:** In Progress
**Agent:** cookie
**Bead:** `aerobeat-docs-j1eh` (legacy transition source: `oc-4bm`)

## Goal

Converge the AeroBeat polyrepo family on Beads 1.2.2 schema v53, preserve every legitimate remote ledger, publish the 14 approved browser-native repositories with their existing subtree history, and restore durable project-specific coordination after the DSH-only transition.

## References

- AeroBeat umbrella README: `../README.md` relative to the polyrepo container.
- Completed mobile CV plan: polyrepo `.plans/2026-08-25-mobile-cv-responsiveness.md` and preserved orchestration history.
- Physical Android telemetry: `/home/derrick/Downloads/telemetry/`.
- Migration backup: `/home/derrick/.dsh/backups/aerobeat-beads-20260826T164900Z/`.
- Upstream repair: `gastownhall/beads` PR `#4878`, commit `fe1d97f11ee32f4d94271fb1130310b9c77b18cc`.
- Temporary validated migration binary: `/tmp/beads-122-pr4878.GLRY3r/bin/bd`, SHA-256 `4dbc524ca161b1287805bb44a2800c626e640c91c03a10b1c15e46a31228a274`.

## Diagnosis

The DSH transition preserved three incompatible states: legitimate remote-backed v26 ledgers, metadata-only checkouts (some with copied project IDs), and empty `.beads/.gitkeep` placeholders in local-only web folders. Current `bd` then failed on post-v26 fields or stopped at an empty placeholder. The latest mobile CV `oc-*` state remained safe in the preserved schema-v53 orchestration ledger.

Pico's Vialytix precedent established the safe repair: designate one migrator per remote, preserve old embedded databases, bootstrap authoritative remote history, use only the upstream pre-0047 clone-local wisp-table repair while retaining the v53 ceiling, push normally, and commit generated `sync.remote`/ignore metadata. Never copy `.git` or `.beads/metadata.json` between children.

## Approved Decisions

- Derrick explicitly authorized the AeroBeat Beads migration across the polyrepo family.
- Derrick chose to create and publicly publish all 14 existing `aerobeat-web-*` folders as independent `AeroBeat-Workouts` GitHub repositories rather than retaining empty placeholders or routing them through the legacy orchestration ledger.
- Existing web subtree history must be preserved from `openclaw-orchestration-agent-legacy`; fresh history is not acceptable.
- Every published web repo receives a fresh unique current Beads identity with no copied metadata.

## Tasks

### 1. Inventory And Backup

**Status:** Complete

- Inventoried 86 AeroBeat child folders, 72 pre-existing Git repos, 21 physical v26 ledgers, 49 metadata-only Beads layouts, and 14 local-only web targets.
- Preserved all pre-migration `.beads` state in `aerobeat-beads-all.tar.gz` with SHA-256 manifest.
- Preserved physical v26 embedded databases locally as `.beads/embeddeddolt-v26-backup-20260826`.
- Protected unrelated `aerobeat-gameplay-runner/.testbed/project.godot` dirt and two pre-existing unpushed `aerobeat-input-gamepad` commits.

### 2. Migrate Existing Legitimate Ledgers

**Status:** In Progress

- Bootstrapped authoritative remote histories.
- Used the validated v1.2.2-scoped upstream repair binary; schema ceiling remains v53.
- Migrated/pushed physical and metadata-only remote-backed ledgers individually.
- Record archived/read-only or otherwise non-pushable exceptions without changing archive state silently.
- Initialize repositories that have no remote Dolt history using `bd init --skip-agents` and push both Git metadata and Dolt history.

### 3. Publish Browser-Native Repositories

**Status:** In Progress

- Created 14 public `AeroBeat-Workouts/aerobeat-web-*` repositories with Derrick's explicit approval.
- Split and pushed existing subtree history from the preserved orchestration Git history.
- Attach each canonical DSH folder to its own origin/main, verify no source drift, replace empty placeholders with fresh unique schema-current Beads, then push.

### 4. Telemetry Recovery

**Status:** Complete

Build `0.0.15` physical Android snapshots confirm Direct full/Fast, main-thread direct adapter, 480x640 camera/input, 30fps video, no resize, and zero dropped frames. The first warm snapshot averaged 122ms CV with 7fps submissions, 9fps pose output, 13ms output age, and 67ms media-pose delta. The later snapshot averaged 136ms CV with 6fps submissions, 8fps pose output, 3ms output age, and 133ms media-pose delta. Pacing keeps the preview fresh and avoids stale queues, but MoveNet inference remains too slow for responsive landmarks. The preserved decision remains follow-up Bead `oc-7j6.6`: compare MediaPipe Pose Landmarker Lite and ONNX Runtime Web with a tiny pose model before custom-model work.

### 5. Commit, Push, QA, And Audit

**Status:** Pending

- Commit/push generated tracked Beads configuration in every owning repo without sweeping unrelated dirt or unpublished commits.
- Verify every active repo with `bd info`, `bd ready`, schema cursor, Git upstream parity, and Dolt push/read-back.
- Verify all 14 public web repositories and their local origins.
- Close `aerobeat-docs-j1eh` and legacy transition Bead `oc-4bm` only after independent audit.

## Results

Pending final migration, commit/push, and audit.
