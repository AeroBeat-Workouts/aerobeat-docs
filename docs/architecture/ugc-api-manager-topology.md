# UGC API Manager Topology

This document defines the recommended repo and package topology for AeroBeat's UGC API stack now that **mod.io is the chosen outer-shell provider** for the current PC community release path.

The short version:

- **Yes:** `aerobeat-tool-api` should be the Godot-imported API manager singleton repo.
- **No:** product repos should not talk to mod.io directly.
- **Yes:** provider-specific code should live behind explicit adapter repos.
- **No:** a separate workflow/domain repo is not justified yet for the current scope.

The goal is to keep AeroBeat's package contract, trust decisions, and client integration **AeroBeat-owned**, while making the mod.io path concrete enough to build now and replace later if needed.

## Decision summary

### 1. `aerobeat-tool-api` should be the Godot-imported API manager singleton

`aerobeat-tool-api` is already the correct semantic lane for the client-facing API manager because it is:

- explicitly a **Tool** repo rather than a gameplay or product repo
- already documented as the official API access layer
- already shaped as a reusable Godot package meant to be imported into assemblies
- already aligned with **GodotEnv package consumption** from the repo root
- the right place for auth, retries, response parsing, caching/policy glue, and provider orchestration behind one AeroBeat-facing surface

It should become the **only repo that assemblies and other product-level Godot packages import for online UGC/API access**.

That means `aerobeat-assembly-community`, `aerobeat-feature-boxing`, `aerobeat-feature-flow`, and future UI shells should depend on `aerobeat-tool-api` for UGC/network behavior instead of embedding provider calls or bespoke HTTP glue.

### 2. mod.io-specific behavior should move into dedicated adapter repos

Provider-specific behavior should not accumulate directly inside gameplay repos, UI repos, or creator-facing product repos.

The minimum concrete provider repo needed now is:

- **`aerobeat-vendor-modio`**
  - owns mod.io REST/auth/listing/upload/download mapping
  - exposes provider DTOs and a provider adapter/service surface
  - translates provider objects into AeroBeat-facing records used by `aerobeat-tool-api`

If upload/broker behavior later becomes large enough, AeroBeat may optionally split a second repo:

- **`aerobeat-vendor-modio-creator`** *(future only, not day-one required)*
  - creator-publishing helpers, upload-session helpers, provider-side submission orchestration

Right now, that second split is probably premature. Day one should prefer **one mod.io adapter repo** unless the creator and athlete/client flows prove materially different in code shape or release cadence.

### 3. A separate UGC workflow/domain repo is premature right now

For the current stage, AeroBeat does **not** need a separate repo like:

- `aerobeat-tool-ugc-workflows`
- `aerobeat-domain-ugc`
- `aerobeat-service-submissions`

Those names imply a layer that would mostly forward requests and spread responsibility across too many small repos before the stable seams are proven.

Today the cleaner split is:

- **contracts** stay in the appropriate core repos (`aerobeat-tool-core`, content/runtime cores as needed)
- **AeroBeat-facing online API manager** lives in `aerobeat-tool-api`
- **provider-specific mod.io implementation** lives in `aerobeat-vendor-modio`
- **product repos consume only the manager**

A workflow/domain repo becomes justified only if AeroBeat later has at least one of these conditions:

- multiple external providers active at once beyond mod.io
- the same UGC workflow needing to serve non-Godot consumers cleanly
- large submission/review/publishing orchestration that no longer fits as tool-side client logic
- enough provider adapters that a shared orchestration lane clearly reduces duplication

Until then, another repo would be architecture theater.

## Recommended repo responsibilities

### `aerobeat-tool-api`

**Role:** AeroBeat-facing client API manager singleton imported into Godot consumers.

**Owns:**

- `AeroToolManager`-style singleton/autoload entrypoint
- auth/session handling for AeroBeat APIs
- request orchestration to AeroBeat-owned endpoints
- resilience behavior such as retry/backoff and rate-limit handling
- response parsing into AeroBeat-facing DTOs/resources
- install/download policy helpers for trusted content flows
- cache/library sync helpers used by assemblies
- provider selection only as configuration/composition, not vendor business logic
- interfaces for provider adapters when an AeroBeat endpoint delegates to provider-backed flows

**Must not own:**

- raw mod.io DTOs as its primary public contract
- direct gameplay logic
- feature-specific UI flows
- content-schema ownership that belongs in content or feature core repos
- ad hoc one-off HTTP calls in random scenes/scripts

### `aerobeat-vendor-modio`

**Role:** replaceable provider adapter for mod.io.

**Owns:**

- mod.io auth token/session exchange helpers as needed
- mod.io request construction and response parsing
- provider listing/search/subscription/upload/download mapping
- provider object ID ↔ AeroBeat mapping helpers where client-side mapping is required
- provider-specific error normalization for the manager layer
- mod.io-specific DTOs kept out of product repos

**Must not own:**

- canonical AeroBeat package/trust decisions
- gameplay/runtime code
- direct assembly integration contracts
- the public product-facing singleton surface

### `aerobeat-tool-core`

**Role:** common tool-side contracts.

**Owns:**

- shared tool/service abstractions
- shared request/result/progress DTO patterns where those are tool-common
- interfaces that `aerobeat-tool-api` or provider adapters may share

**Must not own:**

- mod.io-specific implementation
- the concrete API manager singleton implementation

### Product repos

Examples:

- `aerobeat-assembly-community`
- `aerobeat-feature-boxing`
- `aerobeat-feature-flow`
- `aerobeat-ui-shell-desktop-community`

**Role:** consume trusted AeroBeat-facing API services.

**Owns:**

- product UX
- feature/runtime behavior
- assembly wiring
- calling the manager's stable AeroBeat-facing interfaces

**Must not own:**

- direct mod.io HTTP calls
- direct provider DTO usage as durable product contracts
- duplicated auth/retry/network policy stacks

## Dependency direction

The dependency rule should be simple and strict.

### Day-one dependency graph

```text
product repos / assemblies / UI shells
  -> aerobeat-tool-api
    -> aerobeat-tool-core
    -> aerobeat-vendor-modio

AeroBeat-owned backend APIs
  <- aerobeat-tool-api

mod.io APIs
  <- aerobeat-vendor-modio
```

### Expanded directional view

```text
aerobeat-assembly-community
  -> aerobeat-tool-api
  -> aerobeat-feature-boxing
  -> aerobeat-feature-flow

future product/UI repos
  -> aerobeat-tool-api

`aerobeat-tool-api`
  -> `aerobeat-tool-core`
  -> `aerobeat-vendor-modio`

`aerobeat-vendor-modio`
  -> provider SDK/HTTP client glue only

never:
  product repo -> mod.io directly
  feature repo -> mod.io directly
  UI shell -> mod.io directly
  product repo -> vendor DTO repo as primary contract
```

## Why `aerobeat-tool-api` is the cleanest owner

This decision lines up with both the current docs and the package model.

### It matches the documented architecture

The backend API document already says the game client interacts through `aerobeat-tool-api`. Making that repo the singleton manager is consistent with the existing stated direction rather than inventing a new lane.

### It matches GodotEnv package consumption

`aerobeat-tool-api` is already set up as a repo-root-consumed package with a hidden `.testbed/` workbench for development. That is exactly the right shape for a reusable autoload/service package that multiple assemblies can install without importing gameplay baggage.

### It preserves vendor replaceability

If `aerobeat-tool-api` depends on a provider adapter instead of inlining mod.io concerns everywhere, AeroBeat can later:

- replace mod.io with another shell
- support a second provider in parallel
- shift more traffic back to first-party endpoints

without rewriting product repos.

### It keeps public contracts AeroBeat-shaped

The manager's public surface should speak in AeroBeat concepts such as:

- content IDs
- approval/trust state
- library sync
- install/download intent
- creator submission state

not raw provider-native field names or object lifecycles.

## Anti-patterns AeroBeat should avoid

### 1. Direct mod.io calls from product repos

This is the main architectural hiss point.

Do **not** allow:

- `aerobeat-assembly-community` to call mod.io REST directly
- feature repos to embed `HTTPRequest` logic for vendor APIs
- UI shells to parse provider responses as if they were product contracts

That creates lock-in, duplicates auth/retry code, and makes provider exit expensive.

### 2. Treating provider IDs as canonical content IDs

mod.io IDs should remain mappings, not the primary identity the runtime or trust system keys off.

Canonical IDs stay AeroBeat-owned.

### 3. Letting provider moderation imply runtime trust

A provider listing being visible or downloadable must not imply that the client is allowed to mount or trust it.

AeroBeat trust decisions remain first-party.

### 4. Smearing network policy across many repos

Retries, token handling, guest/session behavior, rate-limit handling, and error normalization should not be reimplemented in every product surface.

### 5. Publishing vendor DTOs as durable product contracts

The public API consumed by assemblies should remain AeroBeat-shaped. Provider DTOs should stay behind adapter boundaries.

### 6. Over-splitting before stable seams exist

Do not create five micro-repos for auth, uploads, submissions, discovery, and moderation until the real code pressure exists. One manager repo plus one provider adapter repo is the clean starting point.

## Recommended public shape for `aerobeat-tool-api`

The manager should expose a small AeroBeat-facing surface, for example:

- `auth/` or `services/auth/`
- `services/library/`
- `services/discovery/`
- `services/submissions/`
- `services/downloads/`
- `interfaces/provider_adapter.gd`
- `providers/` composition glue that wires the active adapter
- `autoload/` or `src/AeroToolManager.gd` singleton entrypoint

The singleton should coordinate services, not become a god object full of raw HTTP code.

A healthy shape is:

```text
aerobeat-tool-api/
├── src/
│   ├── AeroToolManager.gd
│   ├── interfaces/
│   │   └── ugc_provider_adapter.gd
│   ├── services/
│   │   ├── auth/
│   │   ├── discovery/
│   │   ├── library/
│   │   ├── submissions/
│   │   └── downloads/
│   ├── models/
│   └── providers/
│       └── active_provider_registry.gd
└── .testbed/
```

The mod.io-specific implementation should stay outside this repo unless kept behind extremely strict internal boundaries during an early bootstrap. Even then, the target state should remain an extracted adapter repo.

## Repo-creation recommendation

Recommended next repo-creation / hardening order:

1. **Harden `aerobeat-tool-api` as the singleton manager repo**
   - define public AeroBeat-facing service interfaces
   - add provider-adapter seam
   - keep package import shape GodotEnv-friendly
2. **Create `aerobeat-vendor-modio`**
   - implement the first provider adapter behind that seam
   - keep all mod.io DTOs and request logic there
3. **Only then evaluate additional splits**
   - only create `aerobeat-vendor-modio-creator` or a workflow/domain repo if code pressure proves it necessary

If AeroBeat wants the smallest execution-ready move set, that is it.

## Final recommendation

For the current AeroBeat UGC stack:

- treat **`aerobeat-tool-api` as the Godot-imported API manager singleton repo**
- create **`aerobeat-vendor-modio` as the single provider adapter repo actually needed now**
- **do not** create a separate UGC workflow/domain repo yet
- enforce dependency direction so **product repos only consume `aerobeat-tool-api`**
- prohibit direct mod.io integration from assemblies, features, and UI shells

That keeps the current mod.io path practical without giving mod.io ownership over AeroBeat's long-term package or trust architecture.
