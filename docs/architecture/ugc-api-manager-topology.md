# UGC API Manager Topology

This document defines the recommended repo and package topology for AeroBeat's online content stack now that:

- **AeroBeat is explicitly free-to-play**
- the product supports **free workouts** and **premium workouts**
- **mod.io is the current outer community/distribution layer**
- AeroBeat still needs an **AeroBeat-owned account and entitlement architecture**

The short version:

- **Yes:** `aerobeat-tool-api` should be the Godot-imported singleton/service layer.
- **No:** product repos should not talk to mod.io directly.
- **Yes:** provider-specific code should live behind explicit adapter repos.
- **No:** `aerobeat-tool-api` must not be framed as a thin mod.io wrapper.

The goal is to keep AeroBeat's public contracts, identity model, access policy, and trust decisions **AeroBeat-owned**, while making the current mod.io path concrete enough to build now and replace later if needed.

## Decision summary

### 1. `aerobeat-tool-api` should be the Godot-imported identity/access/entitlement manager

`aerobeat-tool-api` is the correct semantic lane for the client-facing online manager because it should own the AeroBeat-facing surface for:

- athlete session and account state
- linked-account and access status
- free vs premium workout access checks
- library sync and owned-workout views
- discovery of AeroBeat-approved content
- creator submission/status flows
- trusted install/download policy
- provider orchestration behind an AeroBeat-shaped contract

It should become the **only repo that assemblies and product-level Godot packages import for online workout/content access**.

That means `aerobeat-assembly-community`, `aerobeat-feature-boxing`, `aerobeat-feature-flow`, and future UI shells should depend on `aerobeat-tool-api` for online content behavior instead of embedding provider calls or bespoke HTTP glue.

### 2. mod.io-specific behavior should stay in dedicated adapter repos

Provider-specific behavior should not accumulate inside gameplay repos, UI repos, or the public API manager contract.

The minimum concrete provider repo needed now is:

- **`aerobeat-vendor-modio`**
  - owns mod.io REST/auth/listing/upload/download mapping
  - owns provider-side purchase/ownership transport only where official, non-deprecated surfaces legitimately support it
  - owns provider DTOs and provider-specific error normalization
  - translates provider objects into AeroBeat-facing results consumed by `aerobeat-tool-api`

A creator-specific split such as `aerobeat-vendor-modio-creator` remains a future-only option if real code pressure proves it necessary.

### 3. A separate workflow/domain repo is still premature

For the current stage, AeroBeat does **not** need a separate repo like:

- `aerobeat-tool-ugc-workflows`
- `aerobeat-domain-ugc`
- `aerobeat-service-submissions`

Right now the cleaner split is:

- **AeroBeat-facing identity/access/entitlement manager** in `aerobeat-tool-api`
- **provider-specific mod.io implementation** in `aerobeat-vendor-modio`
- **product repos consume only the manager**

A separate workflow/domain repo becomes justified only if AeroBeat later has multiple providers, non-Godot consumers that need the same orchestration cleanly, or backend orchestration large enough to deserve its own boundary.

## Recommended repo responsibilities

### `aerobeat-tool-api`

**Role:** AeroBeat-facing client API manager singleton imported into Godot consumers.

**Owns:**

- `AeroToolManager`-style singleton/autoload entrypoint
- guest/session handling for AeroBeat APIs
- athlete identity/access status exposed in AeroBeat terms
- request orchestration to AeroBeat-owned endpoints
- resilience behavior such as retry/backoff and rate-limit handling
- response parsing into AeroBeat-facing DTOs/resources
- trusted install/download policy helpers
- library sync helpers used by assemblies
- creator submission/status service surfaces
- provider selection only as configuration/composition, not vendor business logic

**Must not own:**

- raw mod.io DTOs as its primary public contract
- direct platform-account-linking mechanics as public API shape
- vendor wallet/purchased-content terminology as the canonical long-term vocabulary
- direct gameplay logic
- feature-specific UI flows
- ad hoc one-off HTTP calls in random scenes/scripts

### `aerobeat-vendor-modio`

**Role:** replaceable provider adapter for mod.io.

**Owns:**

- mod.io auth/session exchange helpers as needed
- mod.io request construction and response parsing
- provider listing/search/subscription/upload/download mapping
- provider-side ownership/purchase sync mechanics only through official, non-deprecated surfaces we can actually rely on
- provider object ID ↔ AeroBeat mapping helpers where required
- provider-specific error normalization for the manager layer
- mod.io-specific DTOs kept out of product repos

**Must not own:**

- canonical AeroBeat athlete/account identity
- long-term AeroBeat entitlement vocabulary
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

**Role:** consume trusted AeroBeat-facing online services.

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

### It matches the documented architecture

The backend API and hybrid UGC docs already say the game client should integrate through AeroBeat API surfaces. Making `aerobeat-tool-api` the singleton manager keeps that direction coherent while tightening the newer identity/access/entitlement framing.

### It matches GodotEnv package consumption

`aerobeat-tool-api` is already set up as a repo-root-consumed package with a hidden `.testbed/` workbench for development. That is the right shape for a reusable autoload/service package that multiple assemblies can install without importing gameplay baggage.

### It preserves vendor replaceability

If `aerobeat-tool-api` depends on a provider adapter instead of inlining mod.io concerns everywhere, AeroBeat can later:

- replace mod.io with another shell
- support a second provider in parallel
- shift more traffic back to first-party endpoints
- preserve a stable athlete/account/access contract while transport changes underneath

### It keeps public contracts AeroBeat-shaped

The manager's public surface should speak in AeroBeat concepts such as:

- athlete identity
- linked accounts
- workout access
- free vs premium entitlement state
- content IDs
- approval/trust state
- library sync
- install/download intent
- creator submission state

not raw provider-native field names, wallet mechanics, or object lifecycles.

## Anti-patterns AeroBeat should avoid

### 1. Direct mod.io calls from product repos

This is still the main architectural hiss point.

### 2. Treating provider IDs as canonical content IDs

mod.io IDs should remain mappings, not the primary identity the runtime or access system keys off.

### 3. Letting provider ownership semantics become the durable product contract

Even if mod.io currently serves as the purchased-content server after platform-originated sync, AeroBeat should not hard-code vendor wallet semantics into its long-term public API vocabulary.

### 4. Letting provider moderation or availability imply runtime trust

A provider listing being visible or downloadable must not imply that the client is allowed to mount or trust it.

### 5. Smearing network policy across many repos

Retries, token handling, guest/session behavior, rate-limit handling, and error normalization should not be reimplemented in every product surface.

### 6. Over-splitting before stable seams exist

One manager repo plus one provider adapter repo is still the clean starting point.

## Recommended public shape for `aerobeat-tool-api`

The manager should expose a small AeroBeat-facing service surface, for example:

- `services/auth/`
- `services/account/`
- `services/discovery/`
- `services/library/`
- `services/entitlements/`
- `services/submissions/`
- `services/downloads/`
- `interfaces/provider_adapter.gd`
- `providers/` composition glue that wires the active adapter
- `autoload/` or `src/AeroToolManager.gd` singleton entrypoint

A healthy shape is:

```text
aerobeat-tool-api/
├── src/
│   ├── AeroToolManager.gd
│   ├── interfaces/
│   │   └── ugc_provider_adapter.gd
│   ├── services/
│   │   ├── auth/
│   │   ├── account/
│   │   ├── discovery/
│   │   ├── library/
│   │   ├── entitlements/
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

1. **Harden `aerobeat-tool-api` as the singleton identity/access/entitlement manager**
   - define public AeroBeat-facing service interfaces
   - add provider-adapter seam
   - keep package import shape GodotEnv-friendly
2. **Create or continue hardening `aerobeat-vendor-modio`**
   - implement the first provider adapter behind that seam
   - keep all mod.io DTOs and request logic there
3. **Only then evaluate additional splits**
   - only create further workflow/provider repos if code pressure proves it necessary

## Final recommendation

For the current AeroBeat online content stack:

- treat **`aerobeat-tool-api` as the Godot-imported identity/access/entitlement manager**
- keep **`aerobeat-vendor-modio` as the single provider adapter repo actually needed now**
- **do not** create a separate workflow/domain repo yet
- enforce dependency direction so **product repos only consume `aerobeat-tool-api`**
- prohibit direct mod.io integration from assemblies, features, and UI shells

That keeps the current mod.io path practical without giving mod.io ownership over AeroBeat's long-term account, access, or trust architecture.
