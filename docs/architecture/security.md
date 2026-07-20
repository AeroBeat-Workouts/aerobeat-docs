# Security Strategy

AeroBeat's current security posture should match the product direction that is actually being pursued:

- **camera-first Boxing + Flow**
- **BeatSaver-powered imported play**
- **PC-first release scope**
- a narrower and cleaner package/customization surface than the older freeform mod-first story

This page replaces older security framing that assumed a broader always-online economy, richer public runtime customization, and more settled backend/security infrastructure than the current docs can honestly claim.

## Security priorities for the current slice

The main trust problems now cluster around four areas:

1. **untrusted imported content**
2. **camera/input privacy**
3. **account/community abuse surfaces**
4. **future reviewed public UGC lanes**

## 1. Treat imported BeatSaver content as untrusted input

The imported-player direction makes BeatSaver source material strategically important, but that does **not** mean imported files should be treated as trusted.

Current principle:

- BeatSaver ZIPs, extracted metadata, cover art, audio, and derived conversion artifacts are all **untrusted input**

### What that means in practice

Imported-content tooling should prefer:

- strict format parsing
- conservative file-type handling
- explicit size and resource limits during import/conversion
- clean separation between raw source artifacts and runtime-canonical playable assets

This matches the newer package story:

- raw source/provenance can live under `.artifacts/`
- playable AeroBeat records and normalized media stay separate from raw source
- the runtime should consume the clean converted result rather than improvising directly over arbitrary source payloads whenever practical

## 2. Do not quietly reopen arbitrary-code modding

The docs cleanup intentionally moved AeroBeat away from the older "everything is a mod pack" mental model.

Security should say that plainly:

- the current public/community content direction is **not** a generic arbitrary-code mod platform
- package-local runtime code and freeform executable payloads should not be treated as normal content inputs
- customization lanes should stay controlled and explicit rather than becoming a back door for unsafe content execution

That matters for both:

- the manual-authored workout-package lane
- the BeatSaver-powered imported-player lane

## 3. Keep imported-player and reviewed-UGC trust boundaries separate

AeroBeat currently has two distinct content stories in the docs:

### A. Imported-player lane

This is the BeatSaver-powered path.

Security emphasis:

- safe ingestion/conversion
- provenance retention
- clean local playable outputs
- no claim that imported source is automatically review-clean or policy-clean for public redistribution

### B. Reviewed public UGC lane

This is the narrower reviewed workout-package lane documented elsewhere.

Security emphasis:

- review/moderation gates
- package validation
- controlled publication/distribution workflow
- the current provider-shell/trust-core separation already documented in the UGC architecture pages

The important rule is that these lanes should not be collapsed into one vague "mods" bucket.

## 4. Camera/privacy protection is first-class

Because official v1 gameplay input is camera only, privacy is not a side note.

Current security/privacy posture should prefer:

- collecting only the camera-derived gameplay data actually needed for the feature
- avoiding unnecessary persistence of raw camera frames
- treating calibration and pose-derived state as sensitive device/user data even when it is not formal health data
- making debug capture, logging, and replay collection explicit rather than silent

The docs should avoid implying that broad camera/video retention is normal.

## 5. Online features should be described cautiously

Older security text assumed a more settled online economy / global leaderboard / anti-cheat stack than the current product slice justifies.

The current honest stance is narrower:

- AeroBeat may later support accounts, cloud/community features, and scoped competitive systems
- those systems should remain **AeroBeat-owned trust decisions** even if a third-party shell such as mod.io participates in surrounding workflows
- but the current security docs should not overclaim a fully finished always-online enforcement model where the product direction is still being actively narrowed

### Practical implication

Use security language that still holds if the near-term product is:

- primarily local/imported play
- plus optional future community/account layers
- rather than a giant server-authoritative platform from day one

## 6. Validation and review still matter for public creator content

For the reviewed public workout-package lane, security still depends on layered controls such as:

- package/schema validation
- media/type restrictions
- moderation/review gates
- quarantine/revocation paths when content later proves unsafe, illegal, deceptive, or broken

That remains compatible with the current UGC architecture docs without repeating stale claims about every exact backend implementation detail here.

## 7. Provenance is part of security

The newer BeatSaver conversion direction deliberately preserves source truth and conversion traces.

That is useful for more than debugging. It also supports security/trust goals:

- inspect what source package produced a local playable artifact
- understand what the converter changed, dropped, or normalized
- re-run or audit conversion behavior later
- keep authored runtime records cleaner than the raw import surface

In other words, provenance storage under `.artifacts/` is also a trust and auditability feature.

## 8. Keep provider shells outside the core trust boundary

The broader docs already establish that third-party community/distribution services may act as the current outer shell for some workflows.

Security should stay consistent with that:

- AeroBeat's package truth, validation authority, and runtime trust decisions stay first-party
- third-party services may assist with discovery, hosting, moderation workflow, or account-linking seams
- but they should not be described as the canonical source of gameplay/content trust

## 9. Minimal current security rules worth stating clearly

For the current AeroBeat direction, the clearest durable rules are:

1. **Imported files are untrusted.**
2. **Runtime-playable artifacts should be cleaner than raw source artifacts.**
3. **Arbitrary executable mod/code payloads are not part of the normal content contract.**
4. **Camera/privacy handling must stay explicit and minimal.**
5. **Public creator content requires validation/review gates.**
6. **AeroBeat-owned trust decisions stay inside AeroBeat's architecture even when outside providers help with distribution/community workflows.**

## Current recommendation

AeroBeat should frame security as a **content-ingestion + privacy + trust-boundary** problem first.

That means:

- secure the BeatSaver/import pipeline
- keep raw-source and runtime-canonical content separated
- avoid reopening unsafe freeform modding assumptions
- treat camera data carefully
- keep public UGC behind explicit validation/review paths
- keep provider shells outside the core trust boundary

That is the security posture that best fits the current BeatSaver-powered Boxing + direct-4x3 Flow direction.
