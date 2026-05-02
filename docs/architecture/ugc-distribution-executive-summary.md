# UGC Distribution Executive Summary

## Recommendation

AeroBeat should use a **hybrid UGC model** for the near-term PC community release:

- keep the **package contract**, **validation rules**, **cloud bake/sign pipeline**, and **runtime trust boundary** first-party
- optionally use a **third-party UGC shell** such as mod.io for community-facing discovery, subscriptions, ratings, reporting, and file delivery
- keep all core content identity and trust decisions **vendor-neutral and AeroBeat-controlled**

## Why this is the right near-term choice

### A mod.io-style shell is attractive because it reduces v1 surface area

For a **camera-first Boxing + Flow** game shipping **PC community-first**, the fastest way to support creators is not to build every community feature from scratch.

A mature third-party shell can help with:

- creator pages and community identity
- browsing and discovery
- subscriptions/follows
- ratings, comments, and reports
- hosted downloads and CDN distribution
- moderation dashboards and admin ergonomics

That lets AeroBeat spend engineering time on the parts that are uniquely AeroBeat: package design, trust, safety, and runtime behavior.

### Fully self-hosting everything is expensive earlier than it needs to be

A full first-party UGC platform would also require AeroBeat to own:

- account systems and support flows
- abuse prevention and rate limits
- search and discovery UX
- moderation tooling and takedown workflows
- storage, CDN, quotas, and operational support
- community admin surfaces and legal/process overhead

That is real product and ops scope. It may become worth it later, but it is larger than the current release slice needs.

## What AeroBeat should own no matter what

A third-party platform can help distribute content, but AeroBeat should still own:

- the canonical package shape and manifest rules
- validation of untrusted submissions
- bake/sign authority for approved runtime artifacts
- the allow/deny decision for what the client may install or mount
- first-party IDs, hashes, versions, and trust metadata
- archival of re-bakable authored source packages

This separation matters because **downloadable** is not the same thing as **trusted at runtime**.

## Practical near-term decision

For the current product direction, AeroBeat should:

1. ship a **first-party package and trust pipeline**
2. treat mod.io or an equivalent provider as a **replaceable outer shell**, not the source of runtime truth
3. optimize around **PC community release first**, while keeping future store/mobile paths open by avoiding vendor-defined package semantics

## Bottom line

Use a **mod.io-style shell around an AeroBeat-owned trust core**.

That gives AeroBeat the shortest path to useful UGC for the current Boxing + Flow PC community release, without locking the game's content model or runtime trust to a third-party vendor.