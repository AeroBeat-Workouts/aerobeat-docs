# UGC Distribution Strategy

AeroBeat needs a clear decision on **where community content lives**, **who distributes it**, and **what trust boundary the game enforces at runtime**.

This matters because "UGC platform" can mean two very different things:

1. a **distribution and community surface** where people browse, subscribe, rate, and report content
2. a **runtime trust authority** that decides what packages the AeroBeat client is allowed to load

For AeroBeat, those must stay separate.

Our position is that AeroBeat should keep the **package contract**, **validation pipeline**, **bake/signing authority**, and **runtime trust boundary** first-party. For the current AeroBeat path, **mod.io is the chosen outer shell** for community discovery and distribution, but it is still not the canonical source of truth.

## Why this decision exists

AeroBeat is not deciding between "community content" and "no community content." The project already assumes community-authored content matters. The real decision is how much of the UGC surface AeroBeat wants to own directly during the early release phases.

That decision should stay grounded in the current product slice: **camera-first Boxing and Flow on PC community release first**. UGC distribution is there to support that near-term experience, not to broaden the official gameplay/input promise beyond the current scope.

That choice affects:

- account/auth complexity
- moderation and takedown workflows
- bandwidth and storage operations
- storefront and mobile release flexibility
- vendor lock-in risk
- long-term package compatibility and migration paths

If AeroBeat ties its actual content model to a vendor's storage, identity, or package semantics too early, future platform work gets harder. If AeroBeat self-hosts everything from day one, the team takes on a much larger operational and legal burden before it has to.

## Non-negotiable architectural principles

These principles should hold regardless of which distribution layer AeroBeat uses.

### AeroBeat owns the package contract

The authored package shape, manifest rules, IDs, version semantics, and dependency model remain AeroBeat-defined. Third parties should transport packages, not redefine them.

See also:

- [UGC & Modding Architecture](ugc_modding.md)
- [Cloud Baker Architecture](cloud_baker.md)

### AeroBeat owns validation and bake authority

Any uploaded package must be validated by AeroBeat-controlled tooling before it becomes trusted for runtime distribution. That includes package-shape checks, script scanning, reference checks, and any later bake/export steps.

### AeroBeat owns runtime trust

The game client should trust **AeroBeat-approved artifacts**, not "whatever a community platform returned." A package being downloadable is not the same thing as a package being safe to mount.

This is the critical distinction:

- **distribution trust** = whether a platform is allowed to host or list a file
- **runtime trust** = whether the AeroBeat client is allowed to install, mount, or execute the resulting artifact

AeroBeat may delegate parts of distribution trust. It should not delegate runtime trust.

### AeroBeat keeps vendor-neutral identifiers and metadata

Internal references should prefer AeroBeat content IDs, versions, hashes, and manifests. External provider IDs can exist as mapping fields, not as the primary identity of the package.

### AeroBeat preserves re-bakable source truth

The long-lived asset of value is the authored package and its metadata, not only a vendor-hosted downloadable blob. This preserves re-validation, re-baking, migration, and future platform targeting.

## Current chosen path: mod.io as the distribution shell

AeroBeat's current outer-shell choice is **mod.io** for the community-facing layer while AeroBeat keeps the package contract and trust boundary in-house.

Under this model, a third-party platform handles some or all of:

- public browsing and discovery
- subscriptions/follows
- ratings, comments, and reporting UX
- creator profiles and community identity
- file hosting and CDN delivery
- moderation tooling and admin dashboards

The storefront taxonomy should still stay lean and AeroBeat-shaped. See also [AeroBeat mod.io Tag Mapping](modio-tag-mapping.md) for the current launch proposal covering which metadata becomes public mod.io tags versus what remains first-party/internal.

For current team reference, the canonical AeroBeat storefront/listing URLs are:

- **Sandbox / test page:** <https://test.mod.io/g/aerobeat>
- **Live page:** <https://mod.io/g/aerobeat>

AeroBeat still keeps control of:

- creator package specification
- upload validation rules
- package approval policy
- bake/sign pipeline
- trusted-runtime artifact generation
- final client-side allow/deny rules

### What this option is good at

#### Lower early operational burden

A mature UGC platform can reduce the amount of community plumbing AeroBeat needs to build before shipping a PC community edition.

#### Faster discovery and community features

Search, subscriptions, ratings, reporting, and creator pages are all real product work. Borrowing an existing distribution/community shell can pull that schedule forward.

#### Better moderation ergonomics early on

Third-party admin tooling may provide helpful workflows for reports, visibility toggles, creator sanctions, and audit logs. That does not remove AeroBeat's responsibility, but it can reduce the amount of bespoke moderation UI needed in v1.

#### Useful buffer for PC community distribution

For the current PC-first community release, mod.io is a reasonable way to support creator discovery without immediately owning every account and content-ops surface.

## Limitations of the third-party shell approach

### It does not remove AeroBeat's safety obligations

Even if the file is hosted elsewhere, AeroBeat still needs to validate packages, maintain trustable metadata, and decide what the client can load. A vendor-hosted download cannot be treated as implicitly safe.

### Identity becomes split unless designed carefully

If creator identity, subscriptions, or ownership live entirely in the vendor platform, AeroBeat becomes dependent on that vendor's auth and account semantics. That increases migration cost later.

### Product capabilities may follow vendor contours

Search, taxonomy, review flows, collection behavior, and moderation features may be constrained by what the provider offers. That is acceptable for a shell, but not ideal as a permanent architectural center of gravity.

### Store and mobile implications stay uncertain

A third-party platform may help operationally, but it does not guarantee acceptance for any future storefront or mobile policy environment. Those release paths should still be treated as planning-sensitive and potentially more curated.

AeroBeat should therefore avoid language such as "this solves app store compliance" or "this makes mobile UGC safe by default." It may help, but it is not a blanket guarantee.

## Option B: fully self-hosted UGC platform

Under this model, AeroBeat owns the full stack:

- creator and athlete accounts
- upload APIs
- moderation/reporting systems
- content search and browsing
- library/subscription state
- storage/CDN setup
- admin tooling and takedown workflows
- validation/bake/sign pipeline
- trusted distribution and runtime decisions

### What self-hosting is good at

#### Maximum product control

AeroBeat can shape identity, discovery, moderation, subscriptions, and package semantics around the exact product vision.

#### Cleanest long-term ownership model

There is no vendor dependency for community reach, metadata, or file delivery. Migration concerns are reduced because AeroBeat already owns the whole stack.

#### Strongest alignment between authored truth and distributed truth

When done well, the same first-party system can manage authored submissions, validation state, approved runtime artifacts, and athlete library sync.

## Costs of full self-hosting

### Much larger backend scope

AeroBeat would need to own not just package validation, but also all surrounding product surfaces: auth, quotas, abuse prevention, moderation tools, discovery UX, support flows, and legal/ops processes.

### Higher moderation and takedown burden

Owning the whole platform means owning the whole incident surface. Copyright complaints, abuse reports, impersonation, illegal content, and account enforcement become directly AeroBeat's operational problem.

### More release risk earlier

For the current AeroBeat sequencing, self-hosting everything up front is likely more ambitious than necessary for the first community-focused release.

## Steam and mobile implications

AeroBeat's current release sequencing keeps PC community edition first, with mobile and deeper commercial/storefront paths later. That matters here.

For the near term:

- PC community distribution can tolerate a more open UGC posture
- future mobile/store editions will likely need a more curated content surface
- arcade/commercial variants may want tighter licensing and moderation controls than the community build

The important takeaway is not that one option is automatically "store-safe." It is that a **vendor-neutral package contract plus first-party validation** keeps AeroBeat better positioned to adapt if future platform policies require a more curated or tightly controlled ingestion path.

## Auth and account comparison

### Third-party shell

Pros:

- less first-party account system pressure early on
- existing creator/community identity primitives may be available
- potentially simpler community onboarding for PC release

Cons:

- split identity between AeroBeat and vendor can create user confusion
- subscription/library semantics may not map cleanly to AeroBeat's long-term account model
- migration gets harder if vendor IDs become canonical anywhere

### Fully self-hosted

Pros:

- one identity model for creators and athletes
- easier long-term control of library sync, permissions, and entitlements
- no dependency on outside auth/account roadmap

Cons:

- much larger implementation scope
- more support and abuse-prevention work from day one
- higher burden for secure account recovery, bans, rate limits, and compliance operations

## Moderation and takedown comparison

### Third-party shell

Pros:

- existing report flows and moderation dashboards may reduce early tooling work
- provider may absorb part of the community-management overhead

Cons:

- AeroBeat still needs its own policy decisions and escalation paths
- takedown coordination can become multi-system and slower
- provider tooling may not match AeroBeat's exact moderation model

### Fully self-hosted

Pros:

- complete control over visibility, sanctions, appeals, and takedown handling
- one source of operational truth

Cons:

- full legal/ops burden lands on AeroBeat
- moderation tooling becomes a product requirement, not a future nice-to-have

## Package safety and trust boundary

This is the core architectural red line.

AeroBeat should treat third-party-hosted files as **untrusted input** until they pass first-party validation and any required bake/signing steps.

That means:

- packages must still match AeroBeat's authored contract
- script-bearing or engine-overwriting content remains disallowed
- validation should run in AeroBeat-controlled isolated infrastructure
- the client should prefer AeroBeat-approved artifacts and metadata
- hashes, versions, and approval state should be tracked in AeroBeat systems

In short: a vendor can help distribute content, but AeroBeat must decide what becomes runnable game content.

## Vendor lock-in and exit strategy

AeroBeat should assume that any third-party UGC platform may become too expensive, too limiting, unavailable on some targets, or strategically misaligned later.

To preserve an exit path:

- keep AeroBeat IDs canonical
- store provider IDs as secondary mappings
- keep authored packages and metadata exportable
- avoid provider-specific package semantics inside the game/runtime contract
- keep validation, bake, and signing first-party
- design library/subscription sync so it can be reimplemented later

If AeroBeat ever leaves a provider, the goal should be to migrate the distribution shell without redefining content packages or breaking runtime trust assumptions.

## Recommended phased approach

### Phase 1: first-party package contract, mod.io distribution shell

For the near-term PC community release, AeroBeat should keep the package model and trust pipeline first-party while using mod.io as the current community/distribution layer.

This means:

- creators still target AeroBeat-defined packages
- AeroBeat validation remains mandatory
- AeroBeat can bake/sign trusted runtime artifacts
- a third-party service can host community pages, downloads, ratings, and reporting UX
- the game client integrates through AeroBeat-controlled trust decisions rather than directly inheriting vendor trust

### Phase 2: add first-party mirrors and metadata authority

As the ecosystem matures, AeroBeat should strengthen first-party control over:

- canonical package metadata
- approval status and trust records
- library sync and user entitlements where needed
- archival of authored source packages and approved artifacts

This reduces dependency on any single provider while preserving the convenience of a third-party shell.

### Phase 3: keep the option to self-host more of the outer shell

If product scale, platform requirements, or economics justify it later, AeroBeat can pull more of discovery, identity, and moderation in-house without rewriting the package contract.

That is the key advantage of the phased approach: the migration path is architectural, not emergency surgery.

## Final recommendation

AeroBeat should **not** build its core UGC architecture around any third-party platform.

It also probably should **not** self-host the entire community/distribution stack on day one.

The recommended direction is a **hybrid model**:

- **first-party** package contract, validation, bake/signing authority, trust metadata, and runtime allow rules
- **mod.io as the current outer** distribution/community shell for discovery, hosting, and moderation assistance
- **vendor-neutral** identifiers and package semantics so AeroBeat can migrate later without breaking content

Concretely, AeroBeat should treat mod.io as the current chosen delivery/community layer, but not as the system that defines content truth.

That gives AeroBeat the fastest path to useful community distribution while preserving the harder architectural requirement: AeroBeat decides what a valid package is, what gets baked or signed, what enters quarantine, and what the game is allowed to trust.
