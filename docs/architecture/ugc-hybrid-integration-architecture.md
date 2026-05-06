# UGC Hybrid Integration Architecture

This document describes the current **hybrid UGC architecture** where **mod.io** is the chosen outer community/distribution shell around an **AeroBeat-owned trust core**.

The key rule is simple:

> A third-party provider may help users **discover**, **follow**, **download**, and **report** content, but **AeroBeat decides what packages are valid and what runtime artifacts the client is allowed to trust**.

This document uses **mod.io as the current concrete provider**, but the architecture is intentionally **vendor-decoupled** so the outer shell can be replaced later.

## Scope and release framing

This architecture is aimed at the current AeroBeat release sequence:

- **camera-first Boxing + Flow**
- **PC community-first** release
- future mobile/storefront/arcade paths treated as planning-sensitive, not already solved by this design

The goal is to support community content quickly without giving away the package contract, the approval pipeline, or the runtime trust boundary.

For current team reference, the canonical AeroBeat mod.io pages are:

- **Sandbox / test server page:** <https://test.mod.io/g/aerobeat>
- **Live page:** <https://mod.io/g/aerobeat>

## System boundary summary

### Third-party UGC shell responsibilities

A provider such as mod.io may handle:

- public browsing and search UX
- creator pages and social/community identity
- subscriptions/follows
- ratings, comments, and reports
- file hosting and CDN delivery for submitted source packages
- moderation tooling for the outer community surface

### AeroBeat responsibilities

AeroBeat remains the authority for:

- package specification and manifest schema
- canonical content IDs, versions, hashes, and metadata mappings
- creator upload authorization rules
- server-side validation and security scanning
- approval and rejection policy for runnable content
- cloud bake/sign pipeline
- trusted artifact publication metadata
- client install, cache, allow/deny, and quarantine behavior
- runtime mounting rules
- telemetry and auditability
- migration/export strategy away from any provider

## Trust boundaries

### Boundary 1: provider-hosted submissions are untrusted input

Anything uploaded to a third-party shell is treated as **untrusted** until AeroBeat validates it.

A file being visible, downloadable, or even moderator-approved on the provider side does **not** make it runtime-safe.

### Boundary 2: AeroBeat-approved artifacts are the only runtime-trustable artifacts

The AeroBeat client should install and mount only artifacts that:

- map to an AeroBeat content ID and version
- passed AeroBeat validation
- were baked by the AeroBeat pipeline when required
- carry AeroBeat-published integrity metadata
- remain in a non-revoked trust state

### Boundary 3: provider identity is advisory, AeroBeat identity is canonical

Provider object IDs, user IDs, and listing URLs are useful integration fields, but they are **secondary mappings**.

The game runtime, internal APIs, and long-lived metadata should key off AeroBeat-owned identifiers.

## Logical components

```text
Creator Tools
  -> AeroBeat Upload Broker / Mapping API
  -> Third-Party UGC Shell (mod.io example)
  -> AeroBeat Submission Ingest
  -> AeroBeat Validator
  -> AeroBeat Cloud Baker
  -> AeroBeat Trust Metadata + Artifact Registry
  -> AeroBeat Download/Policy API
  -> AeroBeat Game Client
```

## End-to-end content flow

### 1. Authentication and identity flow

#### Creator auth

Creators should authenticate with AeroBeat first.

Recommended pattern:

1. Creator signs into AeroBeat in the SDK or creator portal.
2. AeroBeat decides whether that account may publish the requested content type.
3. AeroBeat either:
   - issues a short-lived provider delegation token, or
   - performs the provider-side upload orchestration on the creator's behalf.
4. AeroBeat stores the mapping between:
   - AeroBeat creator ID
   - provider user/project/mod ID
   - AeroBeat content ID candidate / submission record

This keeps publish permissions and future migration logic anchored to AeroBeat accounts, not only provider accounts.

#### Athlete auth

For browsing/downloading in the game client:

- the athlete authenticates with AeroBeat or uses AeroBeat guest access where allowed
- the client talks to **AeroBeat APIs** for trustable metadata, library sync, and policy decisions
- direct provider access by the client should be minimized and treated as a delivery optimization, not as the source of truth

## 2. Discovery flow

The provider shell may remain the main community-facing discovery surface for early PC release, but the client should still consume **AeroBeat-curated metadata views**.

Recommended pattern:

1. Provider stores the public listing, screenshots, description, tags, and community reactions.
2. AeroBeat mirrors or indexes the subset of metadata needed for in-game browsing.
3. AeroBeat adds first-party fields such as:
   - trust status
   - approved artifact version
   - feature compatibility (`boxing`, `flow`)
   - package/runtime compatibility
   - quarantine or takedown state
4. The game client browses through an AeroBeat endpoint that can join provider metadata with AeroBeat trust metadata.

This allows AeroBeat to hide content that is publicly visible on the provider but not approved for runtime use.

## 3. Submission flow

A concrete hybrid submission flow can look like this:

1. Creator packages content using AeroBeat SDK rules.
2. SDK performs local validation for fast feedback.
3. SDK requests an AeroBeat upload session.
4. AeroBeat creates a submission record with:
   - AeroBeat submission ID
   - creator ID
   - expected checksum
   - declared package type
   - target feature/mode
5. AeroBeat authorizes upload to the third-party shell or receives a provider upload callback.
6. Provider stores the raw file as community-hosted source input.
7. AeroBeat ingest receives the provider file reference, checksum, and listing mapping.
8. AeroBeat queues the submission into the validation pipeline.

This keeps the creator-facing workflow compatible with a mod.io-style shell while ensuring validation begins from AeroBeat-owned records.

## 4. Moderation boundary

Moderation is split on purpose.

### Provider moderation boundary

The provider may moderate the **community surface**, such as:

- public visibility
- comments and ratings
- creator account sanctions inside that service
- report triage for the listing experience

### AeroBeat moderation boundary

AeroBeat moderates the **runtime trust decision**, including:

- whether the submission enters validation
- whether a validated package is approved for baking/publication
- whether an already published artifact is revoked, quarantined, or hidden in-client
- how takedown decisions affect existing installs and library sync

A provider allowing a listing to stay up does not require AeroBeat to trust it.
AeroBeat revoking trust does not require the provider listing to disappear immediately, though the systems should coordinate.

## 5. AeroBeat validator flow

The validator is the first hard trust gate.

### Validator inputs

- provider file reference or fetched source blob
- AeroBeat submission metadata
- declared package type and target feature
- expected checksum and size

### Validator checks

The validator should run in AeroBeat-controlled isolated infrastructure and perform checks such as:

- package shape and manifest schema validation
- path normalization and package-boundary enforcement
- script scanning / executable payload rejection
- forbidden extension checks (`.gd`, `.dll`, `.so`, etc.)
- reference validation for internal asset links
- file size / decompression / zip-bomb controls
- compatibility checks for current supported package/runtime versions
- feature targeting checks for current product scope (camera-first Boxing + Flow on PC)

### Validator outputs

- `approved_for_bake`
- `rejected`
- `quarantined_for_review`
- machine-readable error report
- normalized extracted metadata for downstream systems

## 6. Cloud baker flow

If validation passes, the submission moves into the AeroBeat cloud baker.

The baker may:

- import the validated package into a controlled build environment
- transcode or optimize assets where the runtime artifact format requires it
- generate engine/runtime-ready output bundles
- attach versioned integrity metadata
- optionally sign the resulting runtime artifact with AeroBeat-controlled keys

The important separation is:

- **source submission** = creator-authored, untrusted until validated
- **approved artifact** = AeroBeat-generated or AeroBeat-approved runtime payload

## 7. Signed artifact publication

After baking, AeroBeat publishes an approved artifact record.

That record should include:

- AeroBeat content ID
- version
- provider mapping(s)
- source checksum
- baked artifact checksum
- package/runtime compatibility version
- trust state
- publication timestamp
- revocation/quarantine flags
- download location(s)

Download locations may include:

- AeroBeat-controlled CDN URLs
- provider-hosted mirrors
- later first-party mirrors for migration resilience

The client should trust the **AeroBeat publication record**, not the storage vendor.

## 8. Install, update, and cache behavior

### Install flow

1. Client browses AeroBeat metadata.
2. Client requests install for a specific AeroBeat content ID/version.
3. AeroBeat returns the currently approved artifact record and authorized download location.
4. Client downloads the artifact.
5. Client verifies checksum/signature/integrity metadata.
6. Client installs into a managed cache.
7. Client registers the content only after verification succeeds.

### Update flow

Updates should be versioned and explicit.

- Published binaries should be immutable per version.
- A creator update becomes a new version, not an overwrite.
- Auto-update should only move the athlete to a newer version when AeroBeat marks it approved and compatible.

### Cache behavior

Recommended client cache layers:

- **download cache** for recently fetched artifacts
- **installed content cache** for verified artifacts available to mount
- **quarantine area** for failed or revoked payloads that should not mount

Client cache records should store:

- AeroBeat content ID/version
- artifact hash
- install state
- last verification time
- origin location used for download

## 9. Offline and runtime behavior

Downloaded and previously verified artifacts should remain usable offline within AeroBeat policy.

Recommended runtime rules:

- offline play may use already verified installed content
- first-time installs require online trust metadata unless explicitly bundled otherwise
- the client mounts only previously verified artifacts from managed install locations
- unsigned or unrecognized files manually dropped into cache paths should not auto-mount as trusted content

For advanced PC users, AeroBeat may still support manual side-loading as a separate mode, but that should be clearly differentiated from trusted online-distributed content.

## 10. Failure and quarantine flows

Not every failure is the same.

### Submission-time failures

Examples:

- malformed package
- checksum mismatch
- forbidden script/executable content
- unsupported asset type
- validator timeout/resource abuse

Actions:

- mark submission `rejected` or `quarantined_for_review`
- preserve structured error output for the creator
- avoid publishing any runtime artifact record

### Post-publication failures

Examples:

- later policy takedown
- newly discovered security issue
- broken dependency/runtime regression
- provider mirror corruption

Actions:

- mark artifact `revoked` or `quarantined`
- stop new installs
- optionally hide in discovery surfaces
- decide policy for existing local installs:
  - allow existing offline use temporarily
  - warn and disable online matchmaking compatibility
  - hard-disable only when security/legal reasons require it

The key is that quarantine and revocation are first-party states managed by AeroBeat.

## 11. Telemetry and audit trail

AeroBeat should log enough to reconstruct trust decisions and operational failures.

Useful telemetry/events include:

- submission created
- provider upload linked
- validation started/completed/failed
- bake started/completed/failed
- artifact published
- artifact installed
- artifact verification failed
- artifact revoked/quarantined
- client mount denied
- provider sync mismatch

Keep the audit trail keyed by AeroBeat IDs, with provider IDs as related fields.

## 12. Vendor-exit strategy

The architecture should assume the outer shell may be replaced.

### Design rules that preserve exit ability

- keep AeroBeat content IDs canonical
- persist provider IDs only as mappings
- keep authored submissions exportable
- keep trust metadata, approval state, and artifact registry first-party
- avoid provider-specific package semantics in the runtime contract
- keep client install/update behavior driven by AeroBeat APIs
- support publishing the same approved artifact to multiple mirrors/CDNs later

### Migration path

If AeroBeat later leaves mod.io or another provider, the migration should mostly involve:

- swapping the discovery/community shell
- re-pointing upload orchestration
- re-mirroring approved artifacts
- rebuilding metadata connectors

It should **not** require redefining package manifests, changing runtime trust rules, or invalidating installed content formats.

## 13. What this architecture does not claim

This design helps AeroBeat preserve control and future flexibility, but it does **not** automatically guarantee:

- mobile storefront approval
- console/platform-holder acceptance
- legal sufficiency for all copyright/moderation cases
- permanent compatibility across all future runtime targets without re-baking or curation

Those remain product, policy, and platform workstreams.

## Recommended near-term implementation stance

For the current AeroBeat scope, the practical implementation stance is:

- use **mod.io as the current chosen community/distribution shell**, while still keeping the architecture replaceable
- keep validation, bake/sign, trust metadata, and runtime allow rules **inside AeroBeat-owned systems**
- make the game client depend on **AeroBeat trust records**, not provider trust
- optimize first for the **PC community release** supporting **camera-first Boxing + Flow**

That gives AeroBeat a concrete path to ship community content quickly without giving away the architectural parts that are hardest to recover later.