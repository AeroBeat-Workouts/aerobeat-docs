# AeroBeat Beads And Web Repo Migration

**Date:** 2026-08-26
**Status:** Complete
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

**Status:** Complete

- Bootstrapped authoritative remote histories and retained all 21 old physical stores as `.beads/embeddeddolt-v26-backup-20260826`.
- Used the validated v1.2.2-scoped upstream repair binary; schema ceiling remained v53.
- Migrated and pushed every non-archived remote-backed ledger individually.
- Reconciled every local issue ID missing from remote authority; all 21 old physical issue-ID sets are now subsets of their active v53 ledgers. Representative recovered dependency counts also match.
- Initialized repositories with no remote Dolt history using `bd init --skip-agents`, then pushed Git metadata and Dolt history.
- Verified all 85 active checkouts have matching canonical Git origin / Beads sync remotes and successful `bd info` / `bd ready` reads. They represent 81 canonical active repository identities because four old feature-name folders are compatibility checkouts of GitHub-renamed mode repositories: `feature-boxing` → `mode-boxing`, `feature-core` → `mode-core`, `feature-flow` → `mode-flow`, and `template-feature` → `template-mode`. GitHub API returns the same repository ID for each pair. Their Git origins, tracked config, Dolt remotes, and internal repository IDs now use/share the canonical mode identity; the displaced local stores remain preserved as `.beads/embeddeddolt-renamed-alias-backup-20260826`.
- Corrected four additional non-alias internal identities (`environment-loader`, `input-camera-tracking`, `tool-gaussian-splat-loader`, and `tool-gltf-loader`) with `bd migrate --update-repo-id`; every active checkout now reports identical actual/expected repository IDs.
- Left archived `aerobeat-input-gamepad` read-only: its local v53 attempt is preserved as `.beads/embeddeddolt-v53-unpublished-20260826`, archive state was not changed, and its two unrelated pre-existing local commits remain untouched.
- Legacy `.beads/metadata.json.project_id` values remain duplicated in eight historical scaffold/rename groups across 25 folders. That clone-local field is not the v53 repository identity and was not hand-edited. The authoritative internal IDs are corrected as above: unique per canonical active repository, shared only by the four verified GitHub redirect aliases. The duplicate metadata groups are: one 16-folder tool/vendor scaffold group; `environment-community` / `environment-core` / `template-environment`; `spatial-ui-core` / `spatial-ui-mouse` / `template-input`; `spatial-ui-touch` / `spatial-ui-xr` / `template-spatial-ui`; and the four verified feature-to-mode alias pairs.

### 3. Publish Browser-Native Repositories

**Status:** Complete

- Created 14 public `AeroBeat-Workouts/aerobeat-web-*` repositories with Derrick's explicit approval; all use default branch `main` and remain unarchived.
- Split and pushed existing subtree history from the preserved orchestration Git history.
- Attached each canonical DSH folder to its own origin/main with no source drift.
- Replaced empty placeholders with fresh unique schema-current Beads identities and pushed both Git and Dolt state.
- Migrated the next CV benchmark from legacy `oc-7j6.6` to canonical `aerobeat-web-cv-b12`.

### 4. Telemetry Recovery

**Status:** Complete

Build `0.0.15` physical Android snapshots confirm Direct full/Fast, main-thread direct adapter, 480x640 camera/input, 30fps video, no resize, and zero dropped frames. The first warm snapshot averaged 122ms CV with 7fps submissions, 9fps pose output, 13ms output age, and 67ms media-pose delta. The later snapshot summary averaged 136ms CV with 6fps submissions, 8fps pose output, 3ms output age, and 133ms media-pose delta; a later sampling panel in that same raw file reads 100ms, so 133ms is specifically the exported snapshot-summary value rather than a claim that every panel sample was identical. Pacing keeps the preview fresh and avoids stale queues, but MoveNet inference remains too slow for responsive landmarks. The preserved decision was migrated from legacy follow-up `oc-7j6.6` to canonical web-CV Bead `aerobeat-web-cv-b12`: compare MediaPipe Pose Landmarker Lite and ONNX Runtime Web with a tiny pose model before custom-model work.

### 5. Commit, Push, QA, And Audit

**Status:** Complete — independent QA and audit PASS

- Committed/pushed generated tracked Beads configuration without sweeping unrelated dirt or unpublished commits.
- Initial independent QA/audit exposed four GitHub rename redirects that stale local tracking refs had concealed. Corrective commits were first pushed through the redirect names, which proved those names resolve to the same canonical mode repositories; the final repair canonicalized both local checkouts in each pair, corrected the canonical mode internal Beads identities, and retained the normal non-rewritten commit history. Re-audit must use live `git ls-remote` and GitHub repository IDs rather than local tracking refs alone.
- Key post-split validation passed: assembly, CV, UI, and contracts `npm run check && npm test`.
- Verified all 14 public web repositories, default `main`, preserved subtree commit history, clean local origins, and fresh Beads.
- Repo-by-repo machine-readable results live at `/home/derrick/.dsh/backups/aerobeat-beads-20260826T164900Z/final-inventory-v3.tsv` with adjacent SHA-256 sidecar; migration logs and the 86-head manifest remain in the same backup root.
- Independent QA and corrective auditor re-audits passed. Closed canonical `aerobeat-docs-j1eh`, legacy transition `oc-4bm`, completed mobile epic `oc-7j6`, and migrated duplicate follow-up `oc-7j6.6`; canonical next work remains open as `aerobeat-web-cv-b12`.

## Results

- Backed up and checksum-verified all pre-migration Beads state; 21 physical v26 stores remain locally recoverable.
- Converged all 85 active local checkouts on Beads 1.2.2 / v53 behavior. Across the 21 physical backups, all 419 original issue IDs and 205 dependency rows survive; 285 local-only issues from 12 repos were merged into authoritative remote histories.
- Corrected every internal repository ID reported by `bd migrate --update-repo-id`. The 85 active checkouts now represent 81 canonical repository identities because four feature-name folders are verified compatibility checkouts of GitHub-renamed mode repositories. Those aliases share canonical origins, Dolt remotes, Git tips, and internal IDs rather than pretending to be independent repositories.
- Published all 14 approved browser-native repos publicly with preserved subtree history, fresh unique Beads, default `main`, and live local/remote parity.
- Preserved `aerobeat-input-gamepad` as the sole archived exception without changing archive state or pushing its two unrelated local commits. Preserved the unrelated gameplay-runner testbed edit.
- Initial independent QA/audit correctly caught four live branch mismatches hidden by stale local tracking refs. Diagnosis showed the old feature URLs are GitHub redirects to the same mode repositories, not distinct remotes. Normal non-rewritten corrective history now ends at canonical mode-target commits `814d34a`, `97a4205`, `014f1d2`, and `9a14a77`; both local compatibility checkouts in each pair match the live canonical tip.
- Parent revalidation after correction reports 86 local Git folders, exactly one expected live-tip mismatch (`aerobeat-input-gamepad`), 85/85 active `bd info` and `bd ready` successes, zero actual/expected internal-ID mismatches, and no unplanned dirt beyond this plan plus the protected gameplay-runner edit.
- Assembly, CV, UI, and contracts passed `npm run check && npm test`; all four remained clean afterward.
- Telemetry confirms pacing/freshness success but MoveNet latency remains the bottleneck. Canonical next work is `aerobeat-web-cv-b12`.

Independent QA and corrective auditor re-audits passed. Canonical and legacy migration Beads are closed; `aerobeat-web-cv-b12` is the only intended next technical slice.
